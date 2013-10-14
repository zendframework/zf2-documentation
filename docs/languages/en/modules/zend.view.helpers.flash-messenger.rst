.. _zend.view.helpers.initial.flashmessenger:

FlashMessenger Helper
=====================

.. _zend.view.helpers.initial.flashmessenger.introduction:

Introduction
------------

The ``FlashMessenger`` helper is used to render the messages of the
:ref:`FlashMessenger MVC plugin <zend.mvc.controller-plugins.flashmessenger>`.

.. _zend.view.helpers.initial.flashmessenger.basic-usage:

Basic Usage
-----------

When only using the default ``namespace`` for the ``FlashMessenger`` all you need to do is this:

.. code-block:: php
   :linenos:

   // Usable in any of your .phtml files
   echo $this->flashMessenger()->render();

The first argument of the ``render()``-function is the ``namespace``. If no ``namespace`` is
defined, the default ``Zend\Mvc\Controller\Plugin\FlashMessenger::NAMESPACE_DEFAULT`` will be used,
which translates to ``default``.

.. code-block:: php
   :linenos:

   // Usable in any of your .phtml files
   echo $this->flashMessenger()->render('error');

   // Alternatively use one of the pre-defined namespaces 
   // (aka: use Zend\Mvc\Controller\Plugin\FlashMessenger;)
   echo $this->flashMessenger()->render(FlashMessenger::NAMESPACE_SUCCESS);

.. _zend.view.helpers.initial.flashmessenger.css-layout:

CSS Layout
----------

The ``FlashMessenger`` default rendering adds a CSS class to the generated ``HTML``, that matches
the defined ``namespace`` that should be rendered. While it may work well for the default cases,
every so often you may want to add specific ``CSS`` classes to the ``HTML`` output. This can be done
while making use of the second parameter of the ``render()`` function.

.. code-block:: php
   :linenos:

   // Usable in any of your .phtml files
   echo $this->flashMessenger()->render('error', array('alert', 'alert-danger'));

The output of this example, using the default ``HTML`` rendering settings, would look like this:

.. code-block:: html
   :linenos:

   <ul class="alert alert-danger">
       <li>Some FlashMessenger Content</li>
       <li>You, the developer, are AWESOME!</li>
   </ul>

.. _zend.view.helpers.initial.flashmessenger.html-layout:

HTML Layout
-----------

Aside from modifying the rendered ``CSS`` classes of the ``FlashMessenger``, you are furthermore
able to modify the generated ``HTML`` as a whole to create even more distinct visuals for your
``FlashMessages``. The default output format is defined within the source code of the
``FlashMessenger`` view helper itself.

.. code-block:: php
   :linenos:

   // Zend/View/Helper/FlashMessenger.php#L41-L43
   protected $messageCloseString     = '</li></ul>';
   protected $messageOpenFormat      = '<ul%s><li>';
   protected $messageSeparatorString = '</li><li>';

These defaults exactly match what we're trying to do. The placeholder ``%s`` will be filled with the
``CSS`` classes output.

To change this, all we need to do is call the respective setter methods of these variables and give
them new strings; for example:

.. code-block:: php
   :linenos:

   // In any of your .phtml files:
   echo $this->flashMessenger()
       ->setMessageOpenFormat('<div%s><p>')
       ->setMessageSeparatorString('</p><p>')
       ->setMessageCloseString('</p></div>')
       ->render('success');

The above code sample then would then generate the following output:

.. code-block:: html
   :linenos:

   <div class="success">
       <p>Some FlashMessenger Content</p>
       <p>You, who's reading the docs, are AWESOME!</p>
   </div>

.. _zend.view.helpers.initial.flashmessenger.modification-for-twitter-bootstrap:

Sample Modification for Twitter Bootstrap 3
-------------------------------------------

Taking all the above knowledge into account, we can create a nice, highly usable and user-friendly
rendering strategy using the `Bootstrap front-end framework <http://getbootstrap.com/>`_  version 3
layouts:

.. code-block:: php
   :linenos:

    // In any of your .phtml files:
    $flash = $this->flashMessenger();
    $flash->setMessageOpenFormat('<div%s>
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">
            &times;
        </button>
        <ul><li>')
        ->setMessageSeparatorString('</li><li>')
        ->setMessageCloseString('</li></ul></div>');

    echo $flash->render('error',   array('alert', 'alert-dismissable', 'alert-danger'));
    echo $flash->render('info',    array('alert', 'alert-dismissable', 'alert-info'));
    echo $flash->render('default', array('alert', 'alert-dismissable', 'alert-warning'));
    echo $flash->render('success', array('alert', 'alert-dismissable', 'alert-success'));

The output of the above example would create dismissable ``FlashMessages`` with the following
``HTML`` markup. The example only covers one type of ``FlashMessenger`` output; if you would have
several ``FlashMessages`` available in each of the rendered ``namespaces``, then you would receive
the same output multiple times only having different ``CSS`` classes applied.

.. code-block:: html
   :linenos:

   <div class="alert alert-dismissable alert-success">
       <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
       <ul>
           <li>Some FlashMessenger Content</li>
           <li>You, who's reading the docs, are AWESOME!</li>
       </ul>
   </div>
