.. EN-Revision: none
.. _zend.view.helpers.initial.action:

动作视图助手
======

*Action*
视图助手允许视图脚本执行一个特定的控制器Action；在执行之后的响应对象的结果将被返回。有时候特定的Action生成可重用内容或“widget-ized”内容（在页面内生成一个带有特定功能的小面板，类似于Windows
Vista的widget，Haohappy注），这时我们就可以使用本功能。

内部调用 *_forward()* 或者转向的Action在此将无效，将返回空字符串。

*Action*\ 视图助手的API和大部分MVC组件调用控制器动作的方式一样：
*action($action,$controller, $module = null, array $params = array())*\ 。 *$action* 和 *$controller*
是必须的；如果没有指定模块，缺省模块将被使用。

.. _zend.view.helpers.initial.action.usage:

.. rubric:: 动作视图助手的基本用法

例如，假设你有一个 *CommentController*
，为了给当前请求输出评论列表，带一个可被调用的 *listAction()* 方法：

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?= $this->action('list', 'comment', null, array('count' => 10)); ?>
       </div>
   </div>



