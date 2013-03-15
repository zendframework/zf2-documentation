.. _zendmarkup.parsers:

ZendMarkup Parsers
===================

``ZendMarkup`` is currently shipped with two parsers, a BBCode parser and a Textile parser.

.. _zendmarkup.parsers.theory:

Theory of Parsing
-----------------

The parsers of ``ZendMarkup`` are classes that convert text with markup to a token tree. Although we are using the
BBCode parser as example here, the idea of the token tree remains the same across all parsers. We will start with
this piece of BBCode for example:

.. code-block:: text
   :linenos:

   [b]foo[i]bar[/i][/b]baz

Then the BBCode parser will take that value, tear it apart and create the following tree:

- [b]

  - foo

  - [i]

    - bar

- baz

You will notice that the closing tags are gone, they don't show up as content in the tree structure. This is
because the closing tag isn't part of the actual content. Although, this does not mean that the closing tag is just
lost, it is stored inside the tag information for the tag itself. Also, please note that this is just a simplified
view of the tree itself. The actual tree contains a lot more information, like the tag's attributes and its name.

.. _zendmarkup.parsers.bbcode:

The BBCode parser
-----------------

The BBCode parser is a ``ZendMarkup`` parser that converts BBCode to a token tree. The syntax of all BBCode tags
is:

.. code-block:: text
   :linenos:

   [name(=(value|"value"))( attribute=(value|"value"))*]

Some examples of valid BBCode tags are:

.. code-block:: text
   :linenos:

   [b]
   [list=1]
   [code file=Zend/Markup.php]
   [url="http://framework.zend.com/" title="Zend Framework!"]

By default, all tags are closed by using the format '[/tagname]'.

.. _zendmarkup.parsers.textile:

The Textile parser
------------------

The Textile parser is a ``ZendMarkup`` parser that converts Textile to a token tree. Because Textile doesn't have
a tag structure, the following is a list of example tags:

.. _zendmarkup.parsers.textile.tags:

.. table:: List of basic Textile tags

   +-------------------------------------------+---------------------------------------------------------+
   |Sample input                               |Sample output                                            |
   +===========================================+=========================================================+
   |\*foo*                                     |<strong>foo</strong>                                     |
   +-------------------------------------------+---------------------------------------------------------+
   |\_foo_                                     |<em>foo</em>                                             |
   +-------------------------------------------+---------------------------------------------------------+
   |??foo??                                    |<cite>foo</cite>                                         |
   +-------------------------------------------+---------------------------------------------------------+
   |-foo-                                      |<del>foo</del>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |+foo+                                      |<ins>foo</ins>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |^foo^                                      |<sup>foo</sup>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |~foo~                                      |<sub>foo</sub>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |%foo%                                      |<span>foo</span>                                         |
   +-------------------------------------------+---------------------------------------------------------+
   |PHP(PHP Hypertext Preprocessor)            |<acronym title="PHP Hypertext Preprocessor">PHP</acronym>|
   +-------------------------------------------+---------------------------------------------------------+
   |"Zend Framework":http://framework.zend.com/|<a href="http://framework.zend.com/">Zend Framework</a>  |
   +-------------------------------------------+---------------------------------------------------------+
   |h1. foobar                                 |<h1>foobar</h1>                                          |
   +-------------------------------------------+---------------------------------------------------------+
   |h6. foobar                                 |<h6>foobar</h6>                                          |
   +-------------------------------------------+---------------------------------------------------------+
   |!http://framework.zend.com/images/logo.gif!|<img src="http://framework.zend.com/images/logo.gif" />  |
   +-------------------------------------------+---------------------------------------------------------+

Also, the Textile parser wraps all tags into paragraphs; a paragraph ends with two newlines, and if there are more
tags, a new paragraph will be added.

.. _zendmarkup.parsers.textile.lists:

Lists
^^^^^

The Textile parser also supports two types of lists. The numeric type, using the "#" character and bullet-lists
using the "\*" character. An example of both lists:

.. code-block:: text
   :linenos:

   # Item 1
   # Item 2

   * Item 1
   * Item 2

The above will generate two lists: the first, numbered; and the second, bulleted. Inside list items, you can use
normal tags like strong (\*), and emphasized (\_). Tags that need to start on a new line (like 'h1' etc.) cannot be
used inside lists.


