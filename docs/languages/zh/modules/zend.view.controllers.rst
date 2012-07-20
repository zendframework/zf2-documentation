.. _zend.view.controllers:

控制器脚本
===============

控制器是你实例化和配置Zend_View的地方。你可以分配变量给view，并让view使用某个特定的模板来输出。

.. _zend.view.controllers.assign:

变量赋值
------------

控制器需要向视图传递必要的变量，在它处理view的代码之前。通常你可以一次一个地完成变量赋值的工作。

.. code-block::
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";


然而这样比较麻烦，那么你可以将它们放进一个数组或对象中去。assign()方法允许你通过数组或对象进行赋值。下面这个例子和上例（一次一个赋值）的结果是一样的：

.. code-block::
   :linenos:

   $view = new Zend_View();

   //以数组的形式进行赋值，键名为View的变量名，键值为变量值

   $array = array(
       'a' => "Hay",
       'b' => "Bee",
       'c' => "Sea",
   );
   $view->assign($array);

   //也可以通过对象来赋值，但要先把对象转型为数组
   $obj = new StdClass;
   $obj->a = "Hay";
   $obj->b = "Bee";
   $obj->c = "Sea";
   $view->assign((array) $obj);


另外，你也可使用这样的方法： 第一个参数是变量名，第二个是变量的值。

.. code-block::
   :linenos:

   $view = new Zend_View();
   $view->assign('a', "Hay");
   $view->assign('b', "Bee");
   $view->assign('c', "Sea");


.. _zend.view.controllers.render:

调用视图脚本并打印输出
---------------------------------

完成所有变量赋值后，Controller通知Zend_View通过render()调用一段特定的视图代码。注意，这个方法将只返回处理后的视图，而不直接输出，所以你要用print或echo来打印输出。

.. code-block::
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   echo $view->render('someView.php');


.. _zend.view.controllers.script-paths:

视图脚本的路径
---------------------

默认地，
Zend_View希望你的View脚本和Controller脚本在同一目录下。比如说，如果你的Controller文件在
“/path/to/app/controllers”目录下，并调用$view->render('someView.php')，则Zend_View会查找"/path/to/app/controllers/someVire.php"文件。

显然，你的View代码很可能放在其它地方，那么需要告诉 Zend_View去哪里找，可使用
setScriptPath()方法。

.. code-block::
   :linenos:

   $view = new Zend_View();
   $view->setScriptPath('/path/to/app/views');


现在当你调用$view->render('someView.php')，它会去找"/path/to/app/views/someView.php"。

事实上，你可以通过addScriptPath()增加路径。Zend_View会到最近增加的路径目录下找View脚本。这样你可以改变默认的外观，通过定制和使用自己的皮肤或主题。

.. code-block::
   :linenos:

   $view = new Zend_View();
   $view->addScriptPath('/path/to/app/views');
   $view->addScriptPath('/path/to/custom/');

   // 现在如果你调用 $view->render('booklist.php'), Zend_View 将
   // 首先查找 "/path/to/custom/booklist.php", 找不到再找
   // "/path/to/app/views/booklist.php", 如果还找不到，最后查找当前目录下//的"booklist.php".



