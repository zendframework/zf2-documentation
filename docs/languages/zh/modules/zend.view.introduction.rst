.. _zend.view.introduction:

简介
======

*Zend_View*\
是用来在MVC模式中处理View（视图）部份的一个类。也就是说它用来使视图部份的代码与Model及controller部分分离。它提供了helper,output
filter,variable escaping等几个功能组件。

*Zend_View*\
使用PHP本身作为你的模板，或者你也可以建立其它模板引擎的实例，并用你的view代码来对其进行操作。

使用 *Zend_View*\ 主要有两步： 1. 你的Controller建立一个 *Zend_View*\
实例，并将需要的变量传递给它； 2. Controller告诉 *Zend_View*\
解析一个特定的视图，生成View输出的内容。

.. _zend.view.introduction.controller:

控制器脚本
---------------

下面是一个简单的例子。假设你有一个书籍清单，想把它打印出来。控制器代码可能看起来是这样的：

.. code-block::
   :linenos:
   <?php
   //使用一个模型来获取书籍作者和标题相关数据。
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   //传递数据给Zend_View类的实例　
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   //解析一段View代码"booklist.php"来显示数据
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

视图脚本
------------

现在我们看看相关的视图代码"booklist.php"。这是一段普通的代码，但是有一点特别：它是在
*Zend_View*\ 实例的内部运行的，所以$this指向的是 *Zend_View*\
实例和类方法。(controller传递给 *Zend_View*\
实例的变量是public的)。一段非常基本的视图代码看起来是这样的：

.. code-block::
   :linenos:
   <?php if ($this->books): ?>

       <!-- 包含几本书信息的HTML表格. -->
       <table>
           <tr>
               <th>Author</th>
               <th>Title</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>There are no books to display.</p>

   <?php endif; ?>

注意我们使用escape()来转义输出。

.. _zend.view.introduction.options:

选项
------

*Zend_View*\ 有若干选项来配置视图脚本的运行。

- *basePath*: 指示一个基本路径，可以在下面设置script、 helper 和 filter
  路径。目录结构如下：

  .. code-block::
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/

  可以通过 *setBasePath()*\ 、 *addBasePath()*\ 、或 *basePath*\ 设置给构造器。

- *encoding*: 指定 *htmlentities()*\ 、 *htmlspecialchars()*\ 和其它操作所采用的字符集，缺省为
  ISO-8859-1 (latin1)。也可以通过 *setEncoding()* 或 *encoding* 设置给构造器。

- *escape*: 指定 *escape()*\ 所使用的回调函数（callback）。也可以通过 *setEscape()*\ 或
  *escape*\ 设置给构造器。

- *filter*: 指示在解析视图脚本后使用的过滤器。可以通过 *setFilter()*\ 、 *addFilter()*\
  或者 *filter*\ 设置给构造器。

- *strictVars*: 指定某些未初始化的视图变量被访问时， *Zend_View*\
  必须发出通知和警告。可以通过调用 *strictVars(true)* 或传递 *strictVars*\
  给构造器来设置。

.. _zend.view.introduction.accessors:

实用访问器
---------------

一般来说，你只需要调用 *assign()*\ 、 *render()*\
或其中之一来设置/添加过滤器、助手类、和脚本路径。然而，如果希望扩展 *Zend_View*\
或需要访问它的内部，有许多访问器（Accessor）可用：

- *getVars()* 将返回所有已赋值的变量。

- *clearVars()*
  将清除所有已赋值的变量；当你想重新使用同一个视图对象，并决定哪些变量可用时，这个功能很有用。

- *getScriptPath($script)* 将获取指定的视图脚本的路径。

- *getScriptPaths()* 将获取所有注册的脚本路径。

- *getHelperPath($helper)* 将获取已命名的助手类的路径。

- *getHelperPaths()* 将获取所有注册的助手路径。

- *getFilterPath($filter)* 将获取已命名的过滤器类的路径。

- *getFilterPaths()* 将获取所有注册的过滤器文件的路径。


