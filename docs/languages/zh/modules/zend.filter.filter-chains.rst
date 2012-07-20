.. _zend.filter.filter_chains:

过滤器链
====

通常，多个过滤器可以以一个特定的顺序应用到某个值上。例如，登录表单的用户名，应为英文字符且小写。
*Zend_Filter*\
提供了一个简单的方法，使过滤器可以链接在一起。下面的代码描述了怎样把2个过滤器链接起来且应用到提交上来的用户名值上：


   .. code-block::
      :linenos:

      // Create a filter chain and add filters to the chain
      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new Zend_Filter_Alpha())
                  ->addFilter(new Zend_Filter_StringToLower());

      // Filter the username
      $username = $filterChain->filter($_POST['username']);


过滤器按照他们被添加到 *Zend_Filter*\
中去的顺序依次执行。上面的例子中，用户名首先被移除任何非英文字母的字符，然后将所有大写字符转化为小写字符。

任何实现了 *Zend_Filter_Interface*\ 接口的，都可被添加到过滤器链中。


