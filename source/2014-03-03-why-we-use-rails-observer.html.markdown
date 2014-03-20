---
title: 为什么使用 Rails Observer
date: 2014-03-03 22:43 +08:00
tags: Observer, Rails, Design Pattern
author: roy
---

<aside class="aside-block">
  <blockquote>
    <p>**Observer** 和 **ActionController::Caching::Sweeper** 虽然在 Rails 4 中被剥离掉，但是可以使用这个 [Gem](https://github.com/rails/rails-observers)。被剥离掉，并不意味它不好，而是出于“减肥”的目的，遵循 [Composition over inheritance](http://en.wikipedia.org/wiki/Composition_over_inheritance) ，拿掉了不常用的类。</p>
  </blockquote>
</aside>

在 Rails 4 中，**Observer** 和 **ActionController::Caching::Sweeper** 被剥离掉。但是在我们的项目 [Fengche.co](https://fengche.co) 中却非常重的使用的它们。所以在这里分享下，我们是如何使用的。

Rails 框架中有两种 Observers:

* Active Record Observer
* Action Controller Sweeper

## Active Record Observer 和 Callbacks

刚开始接触 Observer 的时候，在 Model 中我很难分清什么时候使用 Observer 什么时候使用 Callback。接下来看看一段真实的代码。

### 特定情况是否适用 Callback

在 Fengche.co 中有这样一个用例，当一个 Comment 被创建的时候，我们需要让用户的使用界面与网站数据保持同步更新，这时会通过 [Pusher](http://pusher.com) 来及时为用户更新数据。所以很自然地我们会在 Comment 里添加一个 after_create 的 callback。

```
# app/models/comment.rb
class Comment < ActiveRecord::Base
  after_create :create_comment_for_client

  private
  def create_comment_for_client
    #pusher gem provide this.
    update_clients_page_via_pusher(self)
  end
end
```

上面那段代码有问题么？如果从实现功能的角度上来说确实没有问题。但是如果从代码可维护的角度来看，让 `Pusher` 来发送 Json 数据到 Client 端真的属于 `Comment` 么？在某些情况下，它确实依赖于 `Comment` 。当在一个 comment 被创建以后，才会利用 Pusher 去发送 json 到 Client 端。但是这样的话，就违背了 **Single Responsibility Principle**。

严格的说 `Comment` 应该只是从数据库中获取数据、更新数据，删除数据，以及对获取的数据加以格式化或者加以区分。`Comment` 不应该知道也不关心创建之后的行为。

### Solution: Observer

我们使用 Observer 重构后：

```
# app/models/comment.rb
class Comment < ActiveRecord::Base
end
```

```
# app/observers/comment_observer.rb
class CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(comment)
    update_clients_page_via_pusher(comment)
  end
end
```

```
# config/application.rb
class Application < Rails::Application
  config.active_record.observers = :comment_observer
end
```

### Benefit

现在 Pusher 和 Comment 完全分离开。它们不再捆绑在一起。如果有一天我们对于 Client 端的更新策略有所改变，我们只需要在 CommentObserver 中做改动，而不会再触碰 Comment 。这样更加符合 OO 的概念，而不是在 Comment 中编辑方法。

说了这么多，Test 可以很直接的反应出这些益处：

```
describe CommentObserver do
  let(:observer) { CommentObserver.instance }
  let(:comment) { double(:comment) }

  it "does trigger the pusher" do
    observer.should_receive(:update_clients_page_via_pusher)
    observer.after_create(comment)
  end
end
```

很明显在测试中，我们不需要再调用 Comment 。

### By the way

另外，如果你听说过 "skinny controller fat model" 的话，相信你也听说过 "fat model is not enough"，关于 Fat Model 的重构推荐可以看下[Rails 项目重构指南](http://yedingding.com/2013/03/04/steps-to-refactor-controller-and-models-in-rails-projects.html)。

### Beyonds ActiveRecord Observer

目前为止，我们知道了使用 Observer 能给我们带来的好处。现在又有了一个新的问题，有些情况下我们需要知道是谁触发了某个操作，举个实际例子，在[风车](https://fengche.co)里面，我们需要知道是谁对任务做了操作。

![Activity Message](/images/activities.png)

如果仅仅使用 Rails 提供的 Observer，我们是没有办法拿到 current_user 信息的，怎么办？目前比较通用的办法是

```
class User < ActiveRecord::Base
  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.current
    Thread.current[:user]
  end
end
```

```
class ApplicationController
  around_filter :set_user_current

  def set_user_current
    User.current = current_user
    yield
    User.current = nil
  end
end
```

这样子能工作，但是有下面几个问题。

1. Observer 可能需要用到多个当前的数据，比如 current account，current user，需要在多个 Model 里定义这样的方法
2. Observer 可能需要非 Model 对象，比如 current socket id，属于 request 信息。
3. 管理 around_filter 不直观，也不美观。

来看一下下面的代码：

```
class TicketsController < ApplicationController
  observer      :ticket_observer, only: [:destroy]

  def destroy
    if current_user.could_delete?(@ticket)
      @ticket.destroy
      render text: "", status: 200
    else
      render text: "", status: 407
    end
  end
end
```

### Partial Solution: ActionController::Caching::Sweeper

这里介绍 Sweeper 是什么东西，很多人不了解，主要是 controller 里的用法。

但是 Sweeper 有个很明显的问题，就是在 Controller 里定义的 Observer 会被自动加入到 Observer 列表里面，而不是标准的 ActiveRecord Observer。当然顾名思义，它本来就是清除页面缓存使用，所以是合理的。但是对我们来说就不够用了，因为我们希望用其他渠道对数据进行的变化也能监控到，比如在 Console 里面， 在 Rake Task 里面。

受到 Sweeper 的启发，我们自己实现了类似的库，区别就是把 Observer 的选择留给了用户，而不是智能的自动加入到系统的 Observer 列表里。

```
## lib/controller_observer.rb
module ControllerObserver
  extend ActiveSupport::Concern

  module ClassMethods #:nodoc:
    def observer(*observers)
      configuration = observers.extract_options!

      observers.each do |observer|
        observer_instance = (observer.is_a?(Symbol) ? Object.const_get(observer.to_s.classify) : observer).instance
        around_filter(observer_instance, only: configuration[:only])
      end
    end
  end
end
```

在 `ApplicationController` 这么使用

```
class ApplicationController < ActionController::Base
  include ControllerObserver

  ...
end
```

同时定义个 AuditObserver。

```
class AuditObserver < ActionController::Caching::Sweeper
  def current_user
    controller ? controller.send(:current_user) : nil
  end
end
```

到此为止，所有集成继承 `AuditObserver` 的 Observer 对象都可以获取到触发这个操作的 controller 对象，当然也就拿到了 request 对象，也就可以在 callback 中拿到当前请求的 `current_user`。

下面看一个设置 Controller Observer 的实际例子，在 `TicketsController` 里。

```
class TicketsController < ApplicationController
  observer :ticket_observer, only: [:destroy] ## setting observer
end

class TicketObserver < AuditObserver
  def after_create(ticket)
    create_audit_comment(ticket, current_user)
  end
end
```

这里的 observer 方法就是之前的 `lib/controller_observer.rb` 里面定义的。而在 AuditCommentObserver 里面我们看到在 `create_audit_comment` 的时候使用到了 `current_user` 对象，也就知道了是谁创建了这个任务。

### Benifit

在这里我们通过 Observer 实现了 model 和 controller 之间的互通，而且没有把 model 和 controller 变得混乱无法维护。而且，如果你对 Cache 有要求的话，可以很便捷的在 Observer 中实现对 Sweeper 的操作。

### What's More

最后，就剩下一个非常讨厌的问题了，Rails 的 Observer 不支持 commit callback。而有些操作我们希望是确定事务 commit 后才去执行的，比如一些后台执行的任务。有意思的是， Model 里又可以使用 after_commit callback。我们在研究代码了以后，使用了私有函数来解决这个问题。

```
class TicketObserver < AuditObserver
  def after_commit(record)
    if record.send(:transaction_include_action?, :create)
    elsif record.send(:transaction_include_action?, :destroy)
    end
  end
end
```

*这里是我加入 Fengche.co 后所学习到的一些知识，如果有错误或者疑问欢迎大家的指正和交流。*

