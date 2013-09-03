.. _zend.view.helpers.initial.flashmessenger:

FlashMessenger Helper
---------------------

.. rubric:: FlashMessenger Basic Usage

When only using the default ``namespace`` for the ``FlashMessenger`` all you need to do is this:

.. code-block:: php
   :lineos:

   // Usable in any of your .phtml files
   echo $this->flashMessenger()->render();

The first argument of the ``render()``-function is the ``namespace``. If no ``namespace`` is defined, the following
default will be used ``Zend\Mvc\Controller\Plugin\FlashMessenger::NAMESPACE_DEFAULT``, which translates to ``default``.

.. code-block:: php
   :lineos:

   //Usable in any of your .phtml files
   echo $this->flashMessenger()->render('error');

   // Alternatively use one of the pre-defined namespaces ( use Zend\Mvc\Controller\Plugin\FlashMessenger )
   echo $this->flashMessenger()->render(FlashMessenger::NAMESPACE_SUCCESS);

.. rubric:: FlashMessenger Layout ( CSS )

The ``FlashMessenger`` default rendering adds a CSS-Class to the generated ``HTML``, that matches the defined
``namespace`` that should be rendered. While it may work well for the default cases, every so often you may want to add
specific ``CSS``-Classes to the ``HTML``-Output. This can be done while making use of the 2nd parameter of the
``render()``-function.

.. code-block:: php
   :lineos:

   // Usable in any of your .phtml files
   echo $this->flashMessenger()->render('error', array('alert', 'alert-danger'));

The output of this example, using the default ``HTML`` rendering settings, would look like this:

.. code-block:: html
   :lineos:

   <ul class="alert alert-danger">
       <li>Some FlashMessenger Content</li>
       <li>You, the developer, are AWESOME!</li>
   </ul>

.. rubric:: FlashMessenger Layout ( HTML )

Aside from modifying the rendered ``CSS``-Classes of the ``FlashMessenger``, you are furthermore able to modify the
generated ``HTML`` as a whole to create even more distinct visuals for your ``FlashMessages``. The default output-format
is defined within the source-code of the ``FlashMessenger`` ViewHelper itself.

.. code-block:: php
   :lineos:

   // Zend/View/Helper/FlashMessenger.php#L41-L43
   protected $messageCloseString     = '</li></ul>';
   protected $messageOpenFormat      = '<ul%s><li>';
   protected $messageSeparatorString = '</li><li>';

These defaults exactly match what we're trying to do. The placeholder ``%s`` will be filled with the ``CSS``-Classes
output.

To change this, all we need to do is call the respective Setter-Methods of these variables and give them new ``Strings``,
for example:

.. code-block:: php
   :lineos:

   // Any of your .phtml files
   echo $this->flashMessenger()
     ->setMessageOpenFormat('<div%s><p>')
     ->setMessageSeparatorString('</p><p>')
     ->setMessageCloseString('</p></div>')
     ->render('success');

The above Code-sample then would then generate the following output

.. code-block:: html
   :lineos:

   <div class="success">
       <p>Some FlashMessenger Content</p>
       <p>You, who's reading the docs, are AWESOME!</p>
   </div>

.. rubric:: FlashMessenger Sample Modification Twitter Bootstrap 3

Taking all the above knowledge into account, we can create a nice, highly usable and user-friendly rendering strategy
using the Twitter Bootstrap v3 layouts

.. code-block:: php

    // Any of your .phtml files
    $flash = $this->flashMessenger();
    $flash->setMessageOpenFormat('<div%s><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><ul><li>')
          ->setMessageSeparatorString('</li><li>')
          ->setMessageCloseString('</li></ul></div>');

    echo $flash->render('error',   array('alert', 'alert-dismissable', 'alert-danger'));
    echo $flash->render('info',    array('alert', 'alert-dismissable', 'alert-info'));
    echo $flash->render('default', array('alert', 'alert-dismissable', 'alert-warning'));
    echo $flash->render('success', array('alert', 'alert-dismissable', 'alert-success'));

The output of the above example would create dismissable ``FlashMessages`` using the following ``HTML``-Sources. The
Example only covers one type of ``FlashMessenger``-Output. If you would have several ``FlashMessages`` available in
each of the rendered ``Namespaces``, then you would receive the same output multiple times only having different
``CSS``-Classes applied.

.. code-block:: html
   :lineos:

   <div class="alert alert-dismissable alert-success">
       <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
       <ul>
           <li>Some FlashMessenger Content</li>
           <li>You, who's reading the docs, are AWESOME!</li>
       </ul>
   </div>
