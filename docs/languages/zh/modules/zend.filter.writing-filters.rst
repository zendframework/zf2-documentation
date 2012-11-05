.. EN-Revision: none
.. _zend.filter.writing_filters:

编写过滤器
=====

Zend_Filter提供了一系列常用的过滤器，但是开发者经常需要为他们特殊的用例编写定制的过滤器。编写定制的过滤器很容易，只要实现
*Zend\Filter\Interface*\ 接口。

*Zend\Filter\Interface*\ 接口定义了一个方法 *filter()*\ ，可被用户的类实现。使用
*Zend\Filter\Filter::addFilter()*\ 方法，可以把一个实现了这个接口的对象添加到过滤器链中。

下面的例子，示范了怎样编写一个定制的过滤器：

   .. code-block:: php
      :linenos:

      class MyFilter implements Zend\Filter\Interface
      {
          public function filter($value)
          {
              // perform some transformation upon $value to arrive on $valueFiltered

              return $valueFiltered;
          }
      }




添加上述过滤器的实例到过滤器链中：

   .. code-block:: php
      :linenos:

      $filterChain = new Zend\Filter\Filter();
      $filterChain->addFilter(new MyFilter());





