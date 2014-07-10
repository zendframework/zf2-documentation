.. _zend.escaper.escaping-html:

Escaping HTML
=============

Probably the most common escaping happens in the **HTML Body context**. There are very few characters with special
meaning in this context, yet it is quite common to escape data incorrectly, namely by setting the wrong flags
and character encoding.

For escaping data in the HTML Body context, use ``Zend\Escaper\Escaper``'s ``escapeHtml`` method. Internally it
uses PHP's ``htmlspecialchars``, and additionally correctly sets the flags and encoding.

.. code-block:: php
    :linenos:

    // outputting this without escaping would be a bad idea!
    $input = '<script>alert("zf2")</script>';

    $escaper = new Zend\Escaper\Escaper('utf-8');

    // somewhere in an HTML template
    <div class="user-provided-input">
        <?php
        echo $escaper->escapeHtml($input); // all safe!
        ?>
    </div>

One thing a developer needs to pay special attention too, is that the encoding in which the document is served to 
the client, as it **must be the same** as the encoding used for escaping!

.. _zend.escaper.escaping-html.bad-examples:

Examples of Bad HTML Escaping
-----------------------------

An example of incorrect usage:

.. code-block:: php
    :linenos:

    <?php
    $input = '<script>alert("zf2")</script>';
    $escaper = new Zend\Escaper\Escaper('utf-8');
    ?>
    <?php header('Content-Type: text/html; charset=ISO-8859-1'); ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Encodings set incorrectly!</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    </head>
    <body>
        <?php 
        // Bad! The escaper's and the document's encodings are different!
        echo $escaper->escapeHtml($input);
        ?>
    </body>

.. _zend.escaper.escaping-html.good-examples:

Examples of Good HTML Escaping
------------------------------

An example of correct usage:

.. code-block:: php
    :linenos:

    <?php
    $input = '<script>alert("zf2")</script>';
    $escaper = new Zend\Escaper\Escaper('utf-8');
    ?>
    <?php header('Content-Type: text/html; charset=UTF-8'); ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Encodings set correctly!</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <?php 
        // Good! The escaper's and the document's encodings are same!
        echo $escaper->escapeHtml($input);
        ?>
    </body>

