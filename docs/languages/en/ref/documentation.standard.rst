.. _doc-standard:

*************************************
Zend Framework Documentation Standard
*************************************

.. _doc-standard.overview:

Overview
--------

.. _doc-standard.overview.scope:

Scope
^^^^^

This document provides guidelines for creation of the end-user documentation found within Zend Framework. It is
intended as a guide to Zend Framework contributors, who must write documentation as part of component
contributions, as well as to documentation translators. The standards contained herein are intended to ease
translation of documentation, minimize visual and stylistic differences between different documentation files, and
make finding changes in documentation easier with ``diff`` tools.

You may adopt and/or modify these standards in accordance with the terms of our `license`_.

Topics covered in Zend Framework's documentation standards include documentation file formatting and
recommendations for documentation quality.

.. _doc-standard.file-formatting:

Documentation File Formatting
-----------------------------

.. _doc-standard.file-formatting.xml-tags:

XML Tags
^^^^^^^^

Each manual file must include the following *XML* declarations at the top of the file:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- Reviewed: no -->

*XML* files from translated languages must also include a revision tag containing the revision of the corresponding
English-language file the translation was based on.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- EN-Revision: 14978 -->
   <!-- Reviewed: no -->

.. _doc-standard.file-formatting.max-line-length:

Maximum Line Length
^^^^^^^^^^^^^^^^^^^

The maximum line length, including tags, attributes, and indentation, is not to exceed 100 characters. There is
only one exception to this rule: attribute and value pairs are allowed to exceed the 100 chars as they are not
allowed to be separated.

.. _doc-standard.file-formatting.indentation:

Indentation
^^^^^^^^^^^

Indentation should consist of 4 spaces. Tabs are not allowed.

Tags which are at the same level must have the same indentation.

.. code-block:: xml
   :linenos:

   <section>
   </section>

   <section>
   </section>

Tags which are one level under the previous tag must be indented with 4 additional spaces.

.. code-block:: xml
   :linenos:

   <section>
       <section>
       </section>
   </section>

Multiple block tags within the same line are not allowed; multiple inline tags are allowed, however.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED: -->
   <section><section>
   </section></section>

   <!-- ALLOWED -->
   <para>
       <classname>Zend_Magic</classname> does not exist. <classname>Zend\Permissions\Acl</classname> does.
   </para>

.. _doc-standard.file-formatting.line-termination:

Line Termination
^^^^^^^^^^^^^^^^

Line termination follows the Unix text file convention. Lines must end with a single linefeed (LF) character.
Linefeed characters are represented as ordinal 10, or hexadecimal 0x0A.

Note: Do not use carriage returns (*CR*) as is the convention in Apple OS's (0x0D) or the carriage return -
linefeed combination (*CRLF*) as is standard for the Windows OS (0x0D, 0x0A).

.. _doc-standard.file-formatting.empty-tags:

Empty tags
^^^^^^^^^^

Empty tags are not allowed; all tags must contain text or child tags.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <para>
       Some text. <link></link>
   </para>

   <para>
   </para>

.. _doc-standard.file-formatting.whitespace:

Usage of whitespace within documents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.whitespace.trailing:

Whitespace within tags
^^^^^^^^^^^^^^^^^^^^^^

Opening block tags should have no whitespace immediately following them other than line breaks (and indentation on
the following line).

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <section>WHITESPACE
   </section>

Opening inline tags should have no whitespace immediately following them.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   This is the class <classname> Zend_Class</classname>.

   <!-- OK -->
   This is the class <classname>Zend_Class</classname>.

Closing block tags may be preceded by whitespace equivalent to the current indentation level, but no more than that
amount.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
       <section>
        </section>

   <!-- OK -->
       <section>
       </section>

Closing inline tags must not be preceded by any whitespace.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   This is the class <classname>Zend_Class </classname>

   <!-- OK -->
   This is the class <classname>Zend_Class</classname>

.. _doc-standard.file-formatting.whitespace.multiple-line-breaks:

Multiple line breaks
^^^^^^^^^^^^^^^^^^^^

Multiple line breaks within or between tags are not allowed.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <para>
       Some text...

       ... and more text
   </para>


   <para>
       Another paragraph.
   </para>

   <!-- OK -->
   <para>
       Some text...
       ... and more text
   </para>

   <para>
       Another paragraph.
   </para>

.. _doc-standard.file-formatting.whitespace.tag-separation:

Separation between tags
^^^^^^^^^^^^^^^^^^^^^^^

Tags at the same level must be separated by an empty line to improve readability.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <para>
       Some text...
   </para>
   <para>
       More text...
   </para>

   <!-- OK -->
   <para>
       Some text...
   </para>

   <para>
       More text...
   </para>

The first child tag should open directly below its parent, with no empty line between them; the last child tag
should close directly before the closing tag of its parent.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <section>

       <section>
       </section>

       <section>
       </section>

       <section>
       </section>

   </section>

   <!-- OK -->
   <section>
       <section>
       </section>

       <section>
       </section>

       <section>
       </section>
   </section>

.. _doc-standard.file-formatting.program-listing:

Program Listings
^^^^^^^^^^^^^^^^

The opening **<programlisting>** tag must indicate the appropriate "language" attribute and be indented at the same
level as its sibling blocks.

.. code-block:: xml
   :linenos:

   <para>Sibling paragraph.</para>

   <programlisting language="php"><![CDATA[

*CDATA* should be used around all program listings.

**<programlisting>** sections must not add linebreaks or whitespace at the beginning or end of the section, as
these are then represented in the final output.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <programlisting language="php"><![CDATA[

   $render = "xxx";

   ]]></programlisting>

   <!-- OK -->
   <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

Ending *CDATA* and **<programlisting>** tags should be on the same line, without any indentation.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]>
       </programlisting>

   <!-- NOT ALLOWED -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
       ]]></programlisting>

   <!-- OK -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

The **<programlisting>** tag should contain the "language" attribute with a value appropriate to the contents of
the program listing. Typical values include "css", "html", "ini", "javascript", "php", "text", and "xml".

.. code-block:: xml
   :linenos:

   <!-- PHP -->
   <programlisting language="php"><![CDATA[

   <!-- Javascript -->
   <programlisting language="javascript"><![CDATA[

   <!-- XML -->
   <programlisting language="xml"><![CDATA[

For program listings containing only *PHP* code, *PHP* tags (e.g., "<?php", "?>") are not required, and should not
be used. They simply clutter the narrative, and are implied by the use of the **<programlisting>** tag.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <programlisting language="php"<![CDATA[<?php
       // ...
   ?>]]></programlisting>

   <programlisting language="php"<![CDATA[
   <?php
       // ...
   ?>
   ]]></programlisting>

Line lengths within program listings should follow the :ref:`coding standards recommendations
<coding-standard.php-file-formatting.max-line-length>`.

Refrain from using ``require_once()``, ``require()``, ``include_once()``, and ``include()`` calls within *PHP*
listings. They simply clutter the narrative, and are largely obviated when using an autoloader. Use them only when
they are essential to the example.

.. note::

   **Never use short tags**

   Short tags (e.g., "<?", "<?=") should never be used within **programlisting** or the narrative of a document.

.. _doc-standard.file-formatting.inline-tags:

Notes on specific inline tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.inline-tags.classname:

classname
^^^^^^^^^

The tag **<classname>** must be used each time a class name is represented by itself; it should not be used when
combined with a method name, variable name, or constant, and no other content is allowed within the tag.

.. code-block:: xml
   :linenos:

   <para>
       The class <classname>Zend_Class</classname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.varname:

varname
^^^^^^^

Variables must be wrapped in the **<varname>** tag. Variables must be written using the "$" sigil. No other content
is allowed within this tag, unless a class name is used, which indicates a class variable.

.. code-block:: xml
   :linenos:

   <para>
       The variable <varname>$var</varname> and the class variable
       <varname>Zend\Class\Class::$var</varname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.methodname:

methodname
^^^^^^^^^^

Methods must be wrapped in the **<methodname>** tag. Methods must either include the full method signature or at
the least a pair of closing parentheses (e.g., "()"). No other content is allowed within this tag, unless a class
name is used, which indicates a class method.

.. code-block:: xml
   :linenos:

   <para>
       The method <methodname>foo()</methodname> and the class method
       <methodname>Zend\Class\Class::foo()</methodname>. A method with a full signature:
       <methodname>foo($bar, $baz)</methodname>
   </para>

.. _doc-standard.file-formatting.inline-tags.constant:

constant
^^^^^^^^

Use the **<constant>** tag when denoting constants. Constants must be written in *UPPERCASE*. No other content is
allowed within this tag, unless a class name is used, which indicates a class constant.

.. code-block:: xml
   :linenos:

   <para>
       The constant <constant>FOO</constant> and the class constant
       <constant>Zend\Class\Class::FOO</constant>.
   </para>

.. _doc-standard.file-formatting.inline-tags.filename:

filename
^^^^^^^^

Filenames and paths must be wrapped in the **<filename>** tag. No other content is allowed in this tag.

.. code-block:: xml
   :linenos:

   <para>
       The filename <filename>application/Bootstrap.php</filename>.
   </para>

.. _doc-standard.file-formatting.inline-tags.command:

command
^^^^^^^

Commands, shell scripts, and program calls must be wrapped in the **<command>** tag. If the command includes
arguments, these should also be included within the tag.

.. code-block:: xml
   :linenos:

   <para>
       Execute <command>zf.sh create project</command>.
   </para>

.. _doc-standard.file-formatting.inline-tags.code:

code
^^^^

Usage of the **<code>** tag is discouraged, in favor of the other inline tasks discussed previously.

.. _doc-standard.file-formatting.block-tags:

Notes on specific block tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.block-tags.title:

title
^^^^^

The **<title>** tag is not allowed to hold other tags.

.. code-block:: xml
   :linenos:

   <!-- NOT ALLOWED -->
   <title>Using <classname>Zend_Class</classname></title>

   <!-- OK -->
   <title>Using Zend_Class</title>

.. _doc-standard.recommendations:

Recommendations
---------------

.. _doc-standard.recommendations.editors:

Use editors without autoformatting or with configurable formatting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The style guidelines were written in large part to assist translators in recognizing the lines that have changed
using normal ``diff`` tools.

Many formal *XML* editors autoformat existing and new documents. Often, this formatting either does not strictly
follow the docbook standard, or does not follow the standards outlined in this document. As examples, we have seen
them erase the *CDATA* tags, change 4 space separation to tabs or 2 spaces, etc. Such changes can often make
identification of actual content changes difficult for translators.

If possible, configure your editor's formatting settings such that they follow the guidelines outlined in this
document. If you cannot do so, please disable autoformatting, or find a different tool that allows such
configurability.

.. _doc-standard.recommendations.images:

Use Images
^^^^^^^^^^

Good images and diagrams can improve readability and comprehension. Use them whenever they will assist in these
goals. Images should be placed in the ``documentation/manual/en/figures/`` directory, and be named after the
section identifier in which they occur.

.. _doc-standard.recommendations.examples:

Use Case Examples
^^^^^^^^^^^^^^^^^

Look for good use cases submitted by the community, especially those posted in proposal comments or on one of the
mailing lists. Examples often illustrate usage far better than the narrative does.

When writing your examples for inclusion in the manual, follow all coding standards and documentation standards.

.. _doc-standard.recommendations.links:

Use Links
^^^^^^^^^

Link to other sections of the manual or to external sources instead of recreating documentation.

Linking to other sections of the manual may be done using the **<link>** tag (to which you must provide link text).

.. code-block:: xml
   :linenos:

   <para>
       "Link" links to a section, using descriptive text: <link
           linkend="doc-standard.recommendations.links">documentation on
           links</link>.
   </para>

To link to an external resource, use the **<link>** tag with the "xmlns:xlink" and "xlink:href" attributes:

.. code-block:: xml
   :linenos:

   <para>
       The <link xmlns:xlink="http://www.w3.org/1999/xlink"
           xlink:href="http://framework.zend.com/">Zend Framework site</link>.
   </para>



.. _`license`: http://framework.zend.com/license
