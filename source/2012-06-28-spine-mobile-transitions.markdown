---
title: "Spine Mobile --- Transitions"
date: 2012-06-28 15:56
author: roy
---

###Activating Panels

激活 *Panels* ，正如我们在之前在[关于Controller](/blog/2012/06/28/spine-mobile-stage-and-panel-controllers/)中使用 `active()` 函数完成。

```javascript
calss ContactsList extends Panel
  # ...
  
list = new ContactsList
list.active()
```

默认情况下，它将不使用任何 *transitions* , 只是简单的显示 *controller* 。使用 *transition* , 需要把 `trans` 传入到 `active()` :

```javascript
# Transition in form left
list.active(trans: 'left')

# Or, transition in from right
list.active(trans: 'right')
```

目前只支持两种 *transition* ，**left** 和 **right** 。

###Routes

*Panels* 经常由 *routes* 激活。*Spine* 允许传入一个自定的对象作为 `@navigate()` 的最后一个参数来激活 *routes* 。

```javascript
@navigate('/contacts', trans: 'left')
```

`{trans: 'left'}` 然后将会被传入到 *route callback* 。

```javascript
@routes
  '/contacts': (params) ->
    assertEqual( params.trans, 'left')
```

然后应该将 *route callback params* 传入到 `active()`

```javascript
@list = new ContactsList
@routes
  '/contacts': (params) ->
    @list.active(params)
```

我们来浏览一下完整的例子：

```javascript
class ContactsCreate extends Panel
  className: 'contacts create'
  # ...
  
class ContactsList extends Panel
  className: 'contacts list'
  
  constructor: ->
    super
    @addButton('Add contact', @add)
    
  add: ->
    @navigate('/contacts/create', trans: 'right')
   
class Contacts extends Spine.Controller
  constructor: ->
    super
    
    @list = new ContactsList
    @create = new ContactsCreate
    
    @routes
      '/contacts': (params) -> @list.active(params)
      '/contacts/create': (params) -> @create.active(params)
```

可以看到 **ContactsCreate** 的 *Panel* 在 `add()` 方法中指定。同时需要注意 *route* 确认并且传递 **params** 对象的方式，传入到 `active()` 中，因此 *controller* 知道使用 *transition* 的顺序。

> [Transitions](http://spinejs.com/mobile/docs/transitions)
