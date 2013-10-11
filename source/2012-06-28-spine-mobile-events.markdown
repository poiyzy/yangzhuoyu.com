---
title: "Spine Mobile --- Events"
date: 2012-06-28 17:00
author: roy
---

###300ms click event

一个手机开发人员经常会出的错误是使用 *click* 事件。正确的做法：**不要使用 click event**。 因为 *Mobile Safari* 会有300毫秒的延迟来判定是否为点击操作还是可能有后续操作。

###tap

使用 **tap** 来代替 **click**。

直接使用 **tap** 来代替 **click** 事件：

```javascript
class ContactsList extends Panel
  #Replace 'click' with 'tap'
  events:
    'tap .item': 'select'
    
  select: (e) ->
    item = $(e.target).item()
    @navigate('/contacts', item.id, trans: 'right')
```

当用户的手不离开的时候这个事件将不会被激活，同样这个事件可以被手指滑动所取消。

> [Events](http://spinejs.com/mobile/docs/events)
