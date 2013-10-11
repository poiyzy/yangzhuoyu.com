---
title: "关于rails笔记一"
date: 2011-10-24 11:46
author: roy
---
最近使用Rails写一个练习项目，关于一些基础的东西，做一点笔记。

###首先是 _Params_

**params** 在代码中 `find(params[:id])` 是查找http链接中的元素id。

> 参考：[传送门](http://apidock.com/rails/ActionDispatch/Http/Parameters/params)

###其次是 _Find_

关于 **find** 的用法，起始于想要在查询的内容中按照时间降序排序。

```ruby
find(:all, :order => "created_up DECS")
```

其中

* **:all** 是指在查询的内容中查找全部。也可以改为 **:first** 查找数据库中第一条记录。

* **:order** 指顺序，后面的部分就是所要实现的功能，按照 **created_up** 的降序（**DECS**）排序。

另外，还可以直接写成去掉 **find** 的简洁模式。例如，要查询表里的第一条记录，并按照创建时间排序可以写成：

``` ruby
Test.first.order("created_at DESC")
```

关于 **find** 还有许多属性，再有就是条件查询。

两种写法:

``` ruby
Test.find(:condition => ["user_name = :user_name", { :user_name => user_name }])
```
简写:

``` ruby
Test.where(["user_name = ?", user_name])
```

> 简写必须 **model** 后面，既 `Test.where.order` 后面，不可写在其他 **def** 后面，既 `Test.test.order` 就会报错！！！切记！！！


> 参考：[传送门](http://apidock.com/rails/ActiveRecord/FinderMethods/find)


###其次关于 _self_ 和 _protected_

两者具体的用法还不太清除，日后有时间继续补充，大概的一下了解笔记如下：

* **self** 属性

在 **model** 中创建 **def**

``` ruby ./model/test.rb
def self.test
  ...
end
```

在 **controller** 中可以调用这个带有 **SELF** 属性的 **def**

``` ruby ./controller/tests_controller.rb
def index
  @test = Some.test
end
```

* **protected** 属性

目前仅知道，在 `:before_filter` 中声明使用，起到安全作用。

``` ruby test_controller.rb
before_filter :find_test
…
…
protected
  def find_test
  …
  end
```


###最后是 **Controller** 中的调用 **model**

在 **controller** 中调用 **model** 的内容，可以用首字母大写的形式。

``` ruby test_controller.rb
def index
  @test1 = Project.test
  @test2 = Activity.test
end
```

在上面的代码中，**@test1** 调用了写在 **./model/project.rb** 中的 **def test** ，而在 **@test2** 中调用了 **./model/activity.rb** 中的 **def test** 。
