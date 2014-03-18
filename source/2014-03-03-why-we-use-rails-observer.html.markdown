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

在 Rails 4 中，**Observer** 和 **ActionController::Caching::Sweeper** 被剥离掉。但是在我们的项目 [FengChe.co](http://fengche.co) 中却非常重的使用的它们。所以在这里分享下，我们是如何使用的。

我们使用两种 Observers:

* Active Record Observer
* Action Controller Sweeper

## Active Record Observer 和 Callbacks

刚开始接触 Observer 的时候，在 Model 中我很难分清什么时候使用 Observer 什么时候使用 Callback。接下来看看一段真实的代码。

### 特定情况是否适用 Callback

在 Fengche.co 中有这样一个用例，当一个 Comment 被创建的时候，我们需要让用户的使用界面与网站数据保持同步更新，这时会通过 [Pusher](http://pusher.com) 来及时为用户更新数据。

```
# app/models/comment.rb
class Comment < ActiveRecord::Base
  after_create :create_comment_for_client

  private
  def create_comment_for_client
    #pusher gem provide this.
    pusher_trigger("private-#{self.project_uid}", "comments", { type: 'create', attributes: self.as_json })
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
    pusher_trigger("private-#{comment.project_uid}", "comments", { type: 'create', attributes: comment.as_json })
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
  let(:comment) { CommentObserver.new }

  it "does trigger the pusher" do
    comment.should_receive(:pusher_trigger)
    comment.after_create
  end
end
```

很明显在测试中，我们不需要再调用 Comment 。

### By the way

另外，如果你听说过 "skinny controller fat model" 的话，相信你也听说过 "fat model is not enough"，关于 Fat model 的重构推荐可以看下[这里](http://yedingding.com/2013/03/04/steps-to-refactor-controller-and-models-in-rails-projects.html)。

## Active Record Observer 和 Callbacks

对于为什么使用 Observer ，除了 OO 上的考虑外，我们还有对于 Controller 上的需求。设想一下，如果当一个 Controller 请求 destroy action 后我们要在 Callback 中用到 current user 应该怎样操作？也就是说我们需要在 Model 层拿到依赖于请求的数据。

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

在这里当触发 `TicketsController#destroy` 后，我们需要记录删除动作的操作者并且把他传给 Pusher，那么我们这里的 `current_user` 是如何得到的呢？当然你可以把它们都放在 controller 里面执行，但是我们知道这不是优美的解决方式。所以我们这里仍然选择使用 Observer 来作处理。

```
class TicketObserver < AuditObserver
  def after_destroy(ticket)
    pusher_trigger("private-#{ticket.project_uid}", 'tickets', { type: 'destroy', id: ticket.uid, attributes: { operator_id: current_user.try(:uid) } })
  end
end
```

当然也可以专门用一个 `Service Object` 来做，在这里我必须承认这是非常常见的一种优美的解决方式，而且我想这也是为什么很多人都不怎么使用 Observer 的原因之一（说实话，没有加入 Fengche.co 前，我都在怀疑 Observer 存在的意义），但是不得不说的是这完全是两种方式：

* `Service Object` 是一种 Beyond Rails 的解决方式，它脱离了 Rails 本身，更加多的强调设计模式本身。
* `Observer` 是 Rails 自带的一种行为，而且 DHH 在很多时候建议或者说鼓励大家不要特别在意设计模式。我觉得使用 Observer 也是一种自然并且优美的解决方式，所以我们这里使用了 Rails 本身所集成的 `ActionController::Caching::Sweeper`

关于前面提到的 DHH 的观点，大家可以去[这里](http://rubyrogues.com/056-rr-david-heinemeier-hansson/)了解下，真的非常精彩！

### Solution: ActionController::Caching::Sweeper

这里 `TicketObserver` 继承于 `AuditObserver`，我们是这样定义 `AuditObserver` ：

```
class AuditObserver < ActionController::Caching::Sweeper
  def current_user
    controller ? controller.send(:current_user) : nil
  end
end
```

首先 `AuditObserver` 继承了 `ActionController:Caching::Sweeper`，所以我们可以在这里拿到当前一个当前请求的 Controller 的实例 controller 。

由于我们在 `ApplicationController` 中定义了 `current_user` 这个方法

```
class ApplicationController < ActionController::Base
  def current_user
    controller ? controller.send(:current_user) : Thread.current[:user]
  end
end
```

所以我们只需要执行 `controller.send(:current_user)` 便可以在 callback 中拿到 Controller 当前请求的 `current_user`。

### Setting ActionController::Caching::Sweeper

但是这里还有一个问题，Observer 怎么和 Controller 交互的呢？

在 `TicketsController` 里我们是这样设置的

```
class TicketsController < ApplicationController
  observer :ticket_observer, only: [:destroy] ## setting observer

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

当然只需要只用 Rails-Observer 这个 Gem 就可以实现 `observer :ticket_observer, only: [:destroy]` 完成 callback 和 controller 之间的交互。我们这里没有使用 Gem ，而是自己写了一个简单的 lib ，不过原理是差不多相同的，有兴趣的同学可以看下。

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

在 `ApplicationController` 中调用

```
class ApplicationController < ActionController::Base
  include ControllerObserver

  ...
end
```

### Benifit

在这里我们通过 Observer 实现了 model 和 controller 之间的互通，而且没有把 model 和 controller 变得混乱无法维护。而且，如果你对 Cache 有要求的话，可以很便捷的在 Observer 中实现对 Sweeper 的操作。

*这里是我加入 Fengche.co 后所学习到的一些知识，如果有错误或者疑问欢迎大家的指正和交流。*
