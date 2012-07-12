
Introduction
============

The ``Zend_Markup`` component provides an extensible way for parsing text and rendering lightweight markup languages like BBcode and Textile. It is available as of Zend Framework version 1.10.

``Zend_Markup`` uses a factory method to instantiate an instance of a renderer that extends ``Zend_Markup_Renderer_Abstract`` . The factory method accepts three arguments. The first one is the parser used to tokenize the text (e.g. BbCode). The second (optional) parameter is the renderer to use, *HTML* by default. Thirdly an array with options to use for the renderer can be specified.


