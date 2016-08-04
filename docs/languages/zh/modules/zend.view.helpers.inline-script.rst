.. _zend.view.helpers.initial.inlinescript:

View Helper - InlineScript
==========================

.. _zend.view.helpers.initial.inlinescript.introduction:

Introduction
------------

The *HTML* **<script>** element is used to either provide inline client-side scripting elements or link to a remote
resource containing client-side scripting code. The ``InlineScript`` helper allows you to manage both. It is
derived from :ref:`HeadScript <zend.view.helpers.initial.headscript>`, and any method of that helper is available;
however, use the ``inlineScript()`` method in place of ``headScript()``.

.. note::

   **Use InlineScript for HTML Body Scripts**

   ``InlineScript``, should be used when you wish to include scripts inline in the *HTML* **body**. Placing scripts
   at the end of your document is a good practice for speeding up delivery of your page, particularly when using
   3rd party analytics scripts.

   Some JS libraries need to be included in the *HTML* **head**; use :ref:`HeadScript
   <zend.view.helpers.initial.headscript>` for those scripts.

.. _zend.view.helpers.initial.inlinescript.basicusage:

Basic Usage
-----------

Add to the layout script:

.. code-block:: php
   :linenos:

   <body>
       <!-- Content -->

       <?php
       echo $this->inlineScript()->prependFile($this->basePath('js/vendor/foundation.min.js'))
                                 ->prependFile($this->basePath('js/vendor/jquery.js'));
       ?>
   </body>

Output:

.. code-block:: html
   :linenos:

   <body>
       <!-- Content -->

       <script type="text/javascript" src="/js/vendor/jquery.js"></script>
       <script type="text/javascript" src="/js/vendor/foundation.min.js"></script>
   </body>

.. _zend.view.helpers.initial.inlinescript.capture:

Capturing Scripts
-----------------

Add in your view scripts:

.. code-block:: php
   :linenos:

   $this->inlineScript()->captureStart();
   echo <<<JS
       $('select').change(function(){
           location.href = $(this).val();
       });
   JS;
   $this->inlineScript()->captureEnd();

Output:

.. code-block:: html
   :linenos:

   <body>
       <!-- Content -->

       <script type="text/javascript" src="/js/vendor/jquery.js"></script>
       <script type="text/javascript" src="/js/vendor/foundation.min.js"></script>
       <script type="text/javascript">
           //<!--
           $('select').change(function(){
               location.href = $(this).val();
           });
           //-->
       </script>
   </body>