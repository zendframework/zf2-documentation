.. _zend.view.helpers.initial.json:

JSON Helper
-----------

When creating views that return *JSON*, it's important to also set the appropriate response header. The *JSON* view
helper does exactly that. In addition, by default, it disables layouts (if currently enabled), as layouts generally
aren't used with *JSON* responses.

The *JSON* helper sets the following header:

.. code-block:: text
   :linenos:

   Content-Type: application/json

Most *AJAX* libraries look for this header when parsing responses to determine how to handle the content.

Usage of the *JSON* helper is very straightforward:

.. code-block:: php
   :linenos:

   <?php echo $this->json($this->data) ?>

.. note::

   **Keeping layouts and enabling encoding using Zend\\Json\\Expr**

   Each method in the *JSON* helper accepts a second, optional argument. This second argument can be a boolean flag
   to enable or disable layouts, or an array of options that will be passed to ``Zend\Json\Json::encode()`` and used
   internally to encode data.

   To keep layouts, the second parameter needs to be boolean ``TRUE``. When the second parameter is an array,
   keeping layouts can be achieved by including a ``keepLayouts`` key with a value of a boolean ``TRUE``.

   .. code-block:: php
      :linenos:

      // Boolean true as second argument enables layouts:
      echo $this->json($this->data, true);

      // Or boolean true as "keepLayouts" key:
      echo $this->json($this->data, array('keepLayouts' => true));

   ``Zend\Json\Json::encode`` allows the encoding of native *JSON* expressions using ``Zend\Json\Expr`` objects. This
   option is disabled by default. To enable this option, pass a boolean ``TRUE`` to the ``enableJsonExprFinder``
   key of the options array:

   .. code-block:: php
      :linenos:

      <?php echo $this->json($this->data, array(
          'enableJsonExprFinder' => true,
          'keepLayouts'          => true,
      )) ?>


