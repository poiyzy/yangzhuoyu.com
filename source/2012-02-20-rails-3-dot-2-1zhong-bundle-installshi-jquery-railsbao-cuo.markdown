---
title: "Rails 3.2.1中bundle Install时jquery-rails报错ArgumentError:invalid byte sequence in US-ASCII"
date: 2012-02-20 11:37
author: roy
---
最近将 *Rails* 开发环境升级到 *Ruby 1.9.2* 和 *Rails 3.2.1* 后，执行 `bundle install` 时， *Jquery-rails* 报错：

```sh
"ArgumentError:invalid byte sequence in US-ASCII"
```
原因分析，由于 *locale* 设置错误。据了解，这是 *Ruby 1.9* 字符集设置时关于使用 *UTF-8* 通用问题。

###解决方法一：
在 *Gemfile* 中加入如下代码：

```ruby Gemfile
if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
```
###解决方法二：

也可以在 *Shell* 中设置 *locale*

**BASH** 修改：

在 *~/.profile* 中或者在 *~/.bash_profile*中加入：

```sh ~/.profile
export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
```

**ZSH** 修改：

在 *~/.zshrc* 中加入：

```sh ~/.zshrc
export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
```

> 参考一：[When run bundle get invalid byte sequence in US-ASCII](http://stackoverflow.com/questions/7095845/when-run-bundle-get-invalid-byte-sequence-in-us-ascii)

> 参考二：[ArgumentError: invalid byte sequence in US-ASCII](http://github.com/rails/jquery-rails/pull/35)
