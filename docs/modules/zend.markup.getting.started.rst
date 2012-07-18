.. _zend.markup.getting-started:

Getting Started With Zend_Markup
================================

This guide to get you started with ``Zend_Markup`` uses the BBCode parser and *HTML* renderer. The priciples discussed can be adapted to other parsers and renderers.

.. _zend.markup.getting-started.basic-usage:

.. rubric:: Basic Zend_Markup Usage

We will first instantiate a ``Zend_Markup_Renderer_Html`` object using the ``Zend_Markup::factory()`` method. This will also create a ``Zend_Markup_Parser_Bbcode`` object which will be added to the renderer object.

Afther that, we will use the ``render()`` method to convert a piece of BBCode to *HTML*.

.. code-block:: php
   :linenos:

   // Creates instance of Zend_Markup_Renderer_Html,
   // with Zend_Markup_Parser_BbCode as its parser
   $bbcode = Zend_Markup::factory('Bbcode');

   echo $bbcode->render('[b]bold text[/b] and [i]cursive text[/i]');
   // Outputs: '<strong>bold text</strong> and <em>cursive text</em>'

.. _zend.markup.getting-started.complicated-example:

.. rubric:: A more complicated example of Zend_Markup

This time, we will do exactly the same as above, but with more complicated BBCode markup.

.. code-block:: php
   :linenos:

   $bbcode = Zend_Markup::factory('Bbcode');

   $input = <<<EOT
   [list]
   [*]Zend Framework
   [*]Foobar
   [/list]
   EOT;

   echo $bbcode->render($input);
   /*
   Should output something like:
   <ul>
   <li>Zend Framework</li>
   <li>Foobar</li>
   </ul>
   */

.. _zend.markup.getting-started.incorrect-input:

.. rubric:: Processing incorrect input

Besides simply parsing and rendering markup such as BBCode, ``Zend_Markup`` is also able to handle incorrect input. Most BBCode processors are not able to render all input to *XHTML* valid output. ``Zend_Markup`` corrects input that is nested incorrectly, and also closes tags that were not closed:

.. code-block:: php
   :linenos:

   $bbcode = Zend_Markup::factory('Bbcode');

   echo $bbcode->render('some [i]wrong [b]sample [/i] text');
   // Note that the '[b]' tag is never closed, and is also incorrectly
   // nested; regardless, Zend_Markup renders it correctly as:
   // some <em>wrong <strong>sample </strong></em><strong> text</strong>


