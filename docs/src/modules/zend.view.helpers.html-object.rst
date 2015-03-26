.. _zend.view.helpers.initial.object:

View Helper - HTML Object
=========================

.. _zend.view.helpers.initial.object.introduction:

Introduction
------------

The *HTML* **<object>** element is used for embedding media like Flash or QuickTime in web pages. The object view
helpers take care of embedding media with minimum effort.

There are four initial Object helpers:

- ``htmlFlash()`` Generates markup for embedding Flash files.

- ``htmlObject()`` Generates markup for embedding a custom Object.

- ``htmlPage()`` Generates markup for embedding other (X)HTML pages.

- ``htmlQuicktime()`` Generates markup for embedding QuickTime files.

All of these helpers share a similar interface. For this reason, this documentation will only contain examples of
two of these helpers.

.. _zend.view.helpers.initial.object.flash:

Flash helper
------------

Embedding Flash in your page using the helper is pretty straight-forward. The only required argument is the
resource *URI*.

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>

This outputs the following *HTML*:

.. code-block:: html
   :linenos:

   <object data="/path/to/flash.swf"
           type="application/x-shockwave-flash"
           classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
           codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>

Additionally you can specify attributes, parameters and content that can be rendered along with the **<object>**.
This will be demonstrated using the ``htmlObject()`` helper.

.. _zend.view.helpers.initial.object.object:

Customizing the object by passing additional arguments
------------------------------------------------------

The first argument in the object helpers is always required. It is the *URI* to the resource you want to embed. The
second argument is only required in the ``htmlObject()`` helper. The other helpers already contain the correct
value for this argument. The third argument is used for passing along attributes to the object element. It only
accepts an array with key-value pairs. ``classid`` and ``codebase`` are examples of such attributes. The fourth
argument also only takes a key-value array and uses them to create **<param>** elements. You will see an example of
this shortly. Lastly, there is the option of providing additional content to the object. Now for an example which
utilizes all arguments.

.. code-block:: php
   :linenos:

   echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   );

This would output:

.. code-block:: html
   :linenos:

   <object data="/path/to/file.ext" type="mime/type"
       attr1="aval1" attr2="aval2">
       <param name="param1" value="pval1" />
       <param name="param2" value="pval2" />
       some content
   </object>