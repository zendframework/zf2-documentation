.. _zend.view.helpers.initial.action:

Action View Helper
==================

The ``Action`` view helper enables view scripts to dispatch a given controller action; the result of the response object following the dispatch is then returned. These can be used when a particular action could generate re-usable content or "widget-ized" content.

Actions that result in a ``_forward()`` or redirect are considered invalid, and will return an empty string.

The *API* for the ``Action`` view helper follows that of most *MVC* components that invoke controller actions: ``action($action, $controller, $module = null, array $params = array())``. ``$action`` and ``$controller`` are required; if no module is specified, the default module is assumed.

.. _zend.view.helpers.initial.action.usage:

.. rubric:: Basic Usage of Action View Helper

As an example, you may have a ``CommentController`` with a ``listAction()`` method you wish to invoke in order to pull a list of comments for the current request:

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?php echo $this->action('list',
                                    'comment',
                                    null,
                                    array('count' => 10)); ?>
       </div>
   </div>


