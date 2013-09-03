.. _zend.view.helpers.initial.doctype:

View Helper - Doctype
=====================

.. _zend.view.helpers.initial.doctype.introduction:

Introduction
------------

Valid *HTML* and *XHTML* documents should include a ``DOCTYPE`` declaration. Besides being difficult to remember,
these can also affect how certain elements in your document should be rendered (for instance, CDATA escaping in
**<script>** and **<style>** elements.

The ``Doctype`` helper allows you to specify one of the following types:

- ``XHTML11``

- ``XHTML1_STRICT``

- ``XHTML1_TRANSITIONAL``

- ``XHTML1_FRAMESET``

- ``XHTML1_RDFA``

- ``XHTML1_RDFA11``

- ``XHTML_BASIC1``

- ``XHTML5``

- ``HTML4_STRICT``

- ``HTML4_LOOSE``

- ``HTML4_FRAMESET``

- ``HTML5``

- ``CUSTOM_XHTML``

- ``CUSTOM``

You can also specify a custom doctype as long as it is well-formed.

The ``Doctype`` helper is a concrete implementation of the :ref:`Placeholder helper
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

Basic Usage
-----------

You may specify the doctype at any time. However, helpers that depend on the doctype for their output will
recognize it only after you have set it, so the easiest approach is to specify it in your bootstrap:

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View\Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

And then print it out on top of your layout script:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

Retrieving the Doctype
----------------------

If you need to know the doctype, you can do so by calling ``getDoctype()`` on the object, which is returned by
invoking the helper.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();

Typically, you'll simply want to know if the doctype is *XHTML* or not; for this, the ``isXhtml()`` method will
suffice:

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // do something differently
   }

You can also check if the doctype represents an *HTML5* document.

.. code-block:: php
   :linenos:

   if ($view->doctype()->isHtml5()) {
       // do something differently
   }

.. _zend.view.helpers.initial.doctype.xhtml1_rdfa:

Choosing a Doctype to Use with the Open Graph Protocol
------------------------------------------------------

To implement the `Open Graph Protocol`_, you may specify the XHTML1_RDFA doctype. This doctype allows a developer
to use the `Resource Description Framework`_ within an *XHTML* document.

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View\Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_RDFA');

The RDFa doctype allows XHTML to validate when the 'property' meta tag attribute is used per the Open Graph
Protocol spec. Example within a view script:

.. code-block:: html
   :linenos:

   <?php echo $this->doctype('XHTML1_RDFA'); ?>
   <html xmlns="http://www.w3.org/1999/xhtml"
         xmlns:og="http://opengraphprotocol.org/schema/">
   <head>
      <meta property="og:type" content="musician" />

In the previous example, we set the property to og:type. The og references the Open Graph namespace we specified in
the html tag. The content identifies the page as being about a musician. See the `Open Graph Protocol
documentation`_ for supported properties. The :ref:`HeadMeta helper <zend.view.helpers.initial.headmeta>` may be
used to programmatically set these Open Graph Protocol meta tags.

Here is how you check if the doctype is set to XHTML1_RDFA:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html xmlns="http://www.w3.org/1999/xhtml"
         <?php if ($view->doctype()->isRdfa()): ?>
         xmlns:og="http://opengraphprotocol.org/schema/"
         xmlns:fb="http://www.facebook.com/2008/fbml"
         <?php endif; ?>
   >

.. _zend.view.helpers.initial.doctype.mvc-view-manager:

Zend MVC View Manager
---------------------

If you're running a Zend\Mvc application, you should specify doctype via the :ref:`ViewManager <zend.mvc.services#viewmanager>` service.


.. _`Open Graph Protocol`: http://opengraphprotocol.org/
.. _`Resource Description Framework`: http://www.w3.org/TR/xhtml-rdfa-primer/
.. _`Open Graph Protocol documentation`: http://opengraphprotocol.org/