---
title: "Spine Mobile --- Stage &amp; Panel Controllers"
date: 2012-06-28 12:47
author: roy
---

##Stage & Panel Controllers

关于 *Stage* 和 *Panel*。*Stage* 是平台，*Panel* 是其中的面板。*Stage* 覆盖整个可见区域，而 *Panel* 则只覆盖应用的 **header** 和 **content**。一个应用通常将会同时显示 *Stage* 和 *Panel*。

###Stage

*Stage* 包含元素： 一个 **header**，一个 **article** 和一个 **footer**。

像这个样子：
```html
<body class="stage">
  <header></header>
  <article class="viewport"></article>
  <footer></footer>
</body>
```

**Spine Mobile** 包括一些默认的 **CSS**

* 设置整体的宽度和高度为 100%
* **header** 放置在 *stage* 的顶部。
* **footer** 放置在 *stage* 的底部。
* **article** 被放置在 *stage* 的顶部和底部。

*Stage* 的布局

![Stage layout](https://lh3.googleusercontent.com/-R5HgKL4wur0/TnYhHvxKsZI/AAAAAAAABYE/-VErIKpG4iw/s640/Screen%252520Shot%2525202011-09-18%252520at%25252016.59.51.png)

此图中 **header** 为空，所以 **content** 包含了 **header** 部分。

每一个应用建立的时候都会创建一个全域的 *Stage*， 应用的所有 *panel* 都会被加入其中。它通常会设置为 *body* 元素。

```javascript
class App extends Stage.Global
  constructor: ->
    super
    
    # Instantiate panels
    @contacts = new Contacts
    
  jQuery ->
    app = new App(el: $('body'))
```

在上面的例子中，全域的 *Stage* 在页面载入的时候被展示。后来的，它的 *constructor* 开始展示应用的 *panels*。

###Panel

*Panel* 由两个元素组成， **header** 和 **article**。在应用中通常一次只显示一个 *Panel* 。
记本的创建形式：

```html
<div class="panel">
  <header></header>
  <article></article>
</div>
```

**Spine** 包含一些默认的 *panels* 的样式，它可以把 **content** 延伸并填充已有的空间里。视觉效果如下：

![Panel Style](https://lh3.googleusercontent.com/-rXkOzzQQd2o/TnYb9GAk1cI/AAAAAAAABXo/qsXSujwc_2I/s640/Screen%252520Shot%2525202011-09-18%252520at%25252017.10.43.png)

注意：此处 *Panel* 的 **header** 覆盖了 *Stage* 的 **header** 。当 *Panel* 的 **header** 包含了 **按钮** 和 **panel的标题** 时，*Stage* 的 **header** 包含背景梯度。 *Panel* 的 **header** 不能包含背景色，不然会弄乱迁移。*Stage* 的 **header** 包含背景，而 *Panel* 的 **header** 包含 **content** 。

一旦 *Panel* 被展示出来，他就会被加入到全域的 *Stage* 中。这意味着 *Panel* 被加入到全域的 *Stage* 的 **article div** 中，并且被加入到了 *Stage* 的 **manager** 中。

如下示例：

```javascript
class ConractsList extends Panel
  constructor: ->
    super
    Contact.bind('refresh change', @render)
    
  render: =>
    items = Contact.all()
    @html require('views/contacts/item')(items)
    
class App ectends Stage.Global
  cinstructor: ->
    super
    
    # Instantiate panels
    @contacts = new ContactsList
    
    # Acticate a panel
    @contacts.active()
    
  jQuery ->
    app = new App(el: $('body'))
```

正如你所见，当 **App** 的 *Stage* 被展示，然后它展示 **COntactsList** 的 *Panel*。*Panel* 然后在 **Contact** 的 *model* 中建立一些事件的处理，和一个基本的 *render* 函数。一旦 *Panel* 被展示，它将会被 `active()` 方法激活。 这将会停用 *Stage* 所包含的其他一些 *Panel* ，并且激活 **ContactsList** *panel*，并且显示给用户。

###Panel 属性

**Spine Mobile** 包含一些辅助方法来设置 *Panel* 的标题以及加入 *按键*，使用 `title` 和 `addButton`。如果 `title` 实力属性存在，*Panel* 将会在 **header** 中创建一个 `<h2>` 元素包含 *Panel* 的title。同样的，调用 `addButon(name, callback)` 将会添加一个 `<button>` 在 **header** 中。示例：

```javascript
class ContactList extends Panel
  title: 'Contacts'
  
  constructor: ->
    super
    @addButton('New', @new)
    Contact.bind('refresh change', @render)
    
  render: =>
    iters = Contact.all()
    @html require('views/contacts/item')(items)
    
  new: ->
    # ...
```

这样将会建立如下：

```html
<div class="panel">
  <header>
    <button>New</button>
    <h2>Contacts</h2>
  </header>
  <article></article>
</div>
```

> [Stage & Panel Controllers](http://spinejs.com/mobile/docs/controllers)
