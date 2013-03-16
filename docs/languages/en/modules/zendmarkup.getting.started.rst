.. _zendmarkup.getting-started:

Getting Started With ZendMarkup
================================

This guide to get you started with ``ZendMarkup`` uses the BBCode parser and *HTML* renderer. The principles
discussed can be adapted to other parsers and renderers.

.. _zendmarkup.getting-started.basic-usage:

.. rubric:: Basic ZendMarkup Usage

We will first instantiate a ``Zend\Markup\Renderer\Html`` class using the ``Zend\Markup\Markup::factory()`` method. This
will also create a ``Zend\Markup\Parser\Bbcode`` object which will be added to the renderer object.

After that, we will use the ``render()`` method to convert a piece of BBCode to *HTML*.

.. code-block:: php
   :linenos:

   // Creates instance of Zend\Markup\Renderer\Html,
   // with Zend\Markup\Parser\BbCode as its parser
   $bbcode = Zend\Markup\Markup::factory('Bbcode');

   echo $bbcode->render('[b]bold text[/b] and [i]cursive text[/i]');
   // Outputs: '<strong>bold text</strong> and <em>cursive text</em>'

.. _zendmarkup.getting-started.complicated-example:

.. rubric:: A more complicated example of ZendMarkup

This time, we will do exactly the same as above, but with more complicated BBCode markup.

.. code-block:: php
   :linenos:

   $bbcode = Zend\Markup\Markup::factory('Bbcode');

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

.. _zendmarkup.getting-started.incorrect-input:

.. rubric:: Processing incorrect input

Besides simply parsing and rendering markup such as BBCode, ``ZendMarkup`` is also able to handle incorrect input.
Most BBCode processors are not able to render all input to *XHTML* valid output. ``ZendMarkup`` corrects input
that is nested incorrectly, and also closes tags that were not closed:

.. code-block:: php
   :linenos:

   $bbcode = Zend\Markup\Markup::factory('Bbcode');

   echo $bbcode->render('some [i]wrong [b]sample [/i] text');
   // Note that the '[b]' tag is never closed, and is also incorrectly
   // nested; regardless, ZendMarkup renders it correctly as:
   // some <em>wrong <strong>sample </strong></em><strong> text</strong>


