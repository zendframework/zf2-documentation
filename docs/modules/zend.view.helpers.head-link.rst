
HeadLink Helper
===============

The *HTML* <link>element is increasingly used for linking a variety of resources for your site: stylesheets, feeds, favicons, trackbacks, and more. The ``HeadLink`` helper provides a simple interface for creating and aggregating these elements for later retrieval and output in your layout script.

The ``HeadLink`` helper has special methods for adding stylesheet links to its stack:

The ``$media`` value defaults to 'screen', but may be any valid media value. ``$conditionalStylesheet`` is a string or boolean ``FALSE`` , and will be used at rendering time to determine if special comments should be included to prevent loading of the stylesheet on certain platforms. ``$extras`` is an array of any extra values that you want to be added to the tag.

Additionally, the ``HeadLink`` helper has special methods for adding 'alternate' links to its stack:

The ``headLink()`` helper method allows specifying all attributes necessary for a<link>element, and allows you to also specify placement -- whether the new element replaces all others, prepends (top of stack), or appends (end of stack).

The ``HeadLink`` helper is a concrete implementation of the :ref:`Placeholder helper <zend.view.helpers.initial.placeholder>` .


