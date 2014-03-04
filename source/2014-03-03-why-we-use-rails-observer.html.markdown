---
title: 为什么使用 Rails Observer
date: 2014-03-03 22:43 +08:00
tags: Observer, Rails, Design Pattern
author: roy
---

<aside class="aside-block">
  <blockquote>
    <p>**Observer** 和 **ActionController::Caching::Sweeper** 虽然在 Rails 4 中被剥离掉，但是可以使用这个 [Gem](https://github.com/rails/rails-observers)。被剥离掉，并不意味者不好，而是出于“减肥”的目的遵循 [Composition over inheritance](http://en.wikipedia.org/wiki/Composition_over_inheritance) ，拿掉了不常用的类。</p>
  </blockquote>
</aside>

在 Rails 4 中，**Observer** 和 **ActionController::Caching::Sweeper** 被剥离掉。但是在我们的项目 [FengChe.co](http://fengche.co) 中却非常重的使用的他们。所以在这里我想用几篇文章来分享下，我们是如何使用的。

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

对于为什么使用 Observer ，除了 OO 上的考虑外，我们还有对于 Controller 上的需求，下一篇继续分享。

另外，如果你听说过 "skinny controller fat model" 的话，相信你也听说过 "fat model is not enough"，关于 Fat model 的重构推荐可以看下[这里](http://yedingding.com/2013/03/04/steps-to-refactor-controller-and-models-in-rails-projects.html)。
