.. _zend.text.figlet:

Zend\\Text\\Figlet
==================

.. _zend.text.figlet.introduction:

Introduction
------------

``Zend\Text\Figlet`` is a component which enables developers to create a so called FIGlet text. A FIGlet text is a
string, which is represented as *ASCII* art. FIGlets use a special font format, called FLT (FigLet Font). By
default, one standard font is shipped with ``Zend\Text\Figlet``, but you can download additional fonts at
http://www.figlet.org.

.. note::

   **Compressed fonts**

   ``Zend\Text\Figlet`` supports gzipped fonts. This means that you can take an ``.flf`` file and gzip it. To allow
   ``Zend\Text\Figlet`` to recognize this, the gzipped font must have the extension ``.gz``. Further, to be able to
   use gzipped fonts, you have to have enabled the GZIP extension of *PHP*.

.. note::

   **Encoding**

   ``Zend\Text\Figlet`` expects your strings to be UTF-8 encoded by default. If this is not the case, you can
   supply the character encoding as second parameter to the ``render()`` method.

You can define multiple options for a FIGlet. When instantiating ``Zend\Text\Figlet\Figlet``, you can supply an 
array or an instance of ``Zend\Config``.

   - ``font``- Defines the font which should be used for rendering. If not defines, the built-in font will be used.

   - ``outputWidth``- Defines the maximum width of the output string. This is used for word-wrap as well as
     justification. Beware of too small values, they may result in an undefined behaviour. The default value is 80.

   - ``handleParagraphs``- A boolean which indicates, how new lines are handled. When set to ``TRUE``, single new
     lines are ignored and instead treated as single spaces. Only multiple new lines will be handled as such. The
     default value is ``FALSE``.

   - ``justification``- May be one of the values of ``Zend\Text\Figlet\Figlet::JUSTIFICATION_*``. There is
     ``JUSTIFICATION_LEFT``, ``JUSTIFICATION_CENTER`` and ``JUSTIFICATION_RIGHT`` The default justification is
     defined by the ``rightToLeft`` value.

   - ``rightToLeft``- Defines in which direction the text is written. May be either
     ``Zend\Text\Figlet\Figlet::DIRECTION_LEFT_TO_RIGHT`` or ``Zend\Text\Figlet\Figlet::DIRECTION_RIGHT_TO_LEFT``.
     By default the setting of the font file is used. When justification is not defined, a text written from 
     right-to-left is automatically right-aligned.

   - ``smushMode``- An integer bitfield which defines, how the single characters are smushed together. Can be the
     sum of multiple values from ``Zend\Text\Figlet\Figlet::SM_*``. There are the following smush modes: ``SM_EQUAL``,
     ``SM_LOWLINE``, ``SM_HIERARCHY``, ``SM_PAIR``, ``SM_BIGX``, ``SM_HARDBLANK``, ``SM_KERN`` and ``SM_SMUSH``.
     A value of 0 doesn't disable the entire smushing, but forces SM_KERN to be applied, while a value of -1 disables
     it. An explanation of the different smush modes can be found `here`_. By default the setting of the font file is
     used. The smush mode option is normally used only by font designers testing the various layoutmodes with a new
     font.

.. _zend.text.figlet.basic-usage:

Basic Usage
-----------

This example illustrates the basic use of ``Zend\Text\Figlet`` to create a simple FIGlet text:

.. code-block:: php
   :linenos:

   $figlet = new Zend\Text\Figlet\Figlet();
   echo $figlet->render('Zend');

Assuming you are using a monospace font, this would look as follows:

.. code-block:: text
   :linenos:

     ______    ______    _  __   ______
    |__  //   |  ___||  | \| || |  __ \\
      / //    | ||__    |  ' || | |  \ ||
     / //__   | ||___   | .  || | |__/ ||
    /_____||  |_____||  |_|\_|| |_____//
    `-----`'  `-----`   `-` -`'  -----`



.. _`here`: http://www.jave.de/figlet/figfont.txt
