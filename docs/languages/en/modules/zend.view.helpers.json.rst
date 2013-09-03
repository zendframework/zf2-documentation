.. _zend.view.helpers.initial.json:

View Helper - JSON
==================

.. _zend.view.helpers.initial.json.introduction:

Introduction
------------

When creating views that return *JSON*, it's important to also set the appropriate response header. The *JSON* view
helper does exactly that. In addition, by default, it disables layouts (if currently enabled), as layouts generally
aren't used with *JSON* responses.

The *JSON* helper sets the following header:

.. code-block:: text
   :linenos:

   Content-Type: application/json

Most *AJAX* libraries look for this header when parsing responses to determine how to handle the content.

.. _zend.view.helpers.initial.json.basicusage:

Basic Usage
-----------

Usage of the *JSON* helper is very straightforward:

.. code-block:: php
   :linenos:

   <?php echo $this->json($this->data) ?>

.. note::

   **Enabling encoding using Zend\\Json\\Expr**

   The *JSON* helper accepts an array of options that will be passed to
   ``Zend\Json\Json::encode()`` and used internally to encode data.

   ``Zend\Json\Json::encode`` allows the encoding of native *JSON* expressions
   using ``Zend\Json\Expr`` objects. This option is disabled by default. To
   enable this option, pass a boolean ``TRUE`` to the ``enableJsonExprFinder``
   key of the options array:

   .. code-block:: php
      :linenos:

      <?php echo $this->json($this->data, array(
          'enableJsonExprFinder' => true,
      )) ?>