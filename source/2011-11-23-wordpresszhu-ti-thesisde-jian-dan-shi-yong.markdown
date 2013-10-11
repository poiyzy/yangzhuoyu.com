---
title: "Wordpress主题thesis的简单使用"
date: 2011-11-23 15:46
author: roy
---

前几天帮助一个朋友修改wordpress商业版的thesis主题，通过简单的使用发现，这个东西确实强大！

主要通过两个文件来新增功能，*custom_function.php* 和 *custom.css* 。 其他的功能暂时未用到。先来说说添加功能吧。

大概的编写规则：

```php custom_function.php
<?php
function test() {
?>
<div><?php echo "test"; ?></div>
<?php }
add_action("thesis_hook_after_sidebars","test")
?> 
```

先写一个 `function` 然后调用 `add_action(调用位置,方法名称)` 。

具体的有以下可以参考：

> 传送门： [Hooks](http://diythemes.com/thesis/rtfm/customizing-with-hooks/) \ [Filters](http://diythemes.com/thesis/rtfm/customizing-with-filters/) \ [Custom Loop API](http://diythemes.com/thesis/rtfm/custom-loop-api/)
