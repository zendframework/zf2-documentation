.. _zend.view.helpers.initial.headtitle:

HeadTitle Helper
================

The *HTML* **<title>** element is used to provide a title for an *HTML* document. The ``HeadTitle`` helper allows
you to programmatically create and store the title for later retrieval and output.

The ``HeadTitle`` helper is a concrete implementation of the :ref:`Placeholder helper
<zend.view.helpers.initial.placeholder>`. It overrides the ``toString()`` method to enforce generating a
**<title>** element, and adds a ``headTitle()`` method for quick and easy setting and aggregation of title
elements. The signature for that method is ``headTitle($title, $setType = null)``; by default, the value is
appended to the stack (aggregating title segments) if left at null, but you may also specify either 'PREPEND'
(place at top of stack) or 'SET' (overwrite stack).

Since setting the aggregating (attach) order on each call to ``headTitle`` can be cumbersome, you can set a default
attach order by calling ``setDefaultAttachOrder()`` which is applied to all ``headTitle()`` calls unless you
explicitly pass a different attach order as the second parameter.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: HeadTitle Helper Basic Usage

You may specify a title tag at any time. A typical usage would have you setting title segments for each level of
depth in your application: site, controller, action, and potentially resource.

.. code-block:: php
   :linenos:

    // setting the controller and action name as title segments:
   $request = Zend_Controller_Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // setting the site in the title; possibly in the layout script:
   $this->headTitle('Zend Framework');

   // setting a separator string for segments:
   $this->headTitle()->setSeparator(' / ');

When you're finally ready to render the title in your layout script, simply echo the helper:

.. code-block:: php
   :linenos:

   <!-- renders <action> / <controller> / Zend Framework -->
   <?php echo $this->headTitle() ?>


