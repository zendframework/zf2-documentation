
HeadMeta Helper
===============

The *HTML* <meta>element is used to provide meta information about your *HTML* document -- typically keywords, document character set, caching pragmas, etc. Meta tags may be either of the 'http-equiv' or 'name' types, must contain a 'content' attribute, and can also have either of the 'lang' or 'scheme' modifier attributes.

The ``HeadMeta`` helper supports the following methods for setting and adding meta tags:

The following methods are also supported with XHTML1_RDFA doctype set with the :ref:`Doctype helper <zend.view.helpers.initial.doctype>` :

The ``$keyValue`` item is used to define a value for the 'name' or 'http-equiv' key; ``$content`` is the value for the 'content' key, and ``$modifiers`` is an optional associative array that can contain keys for 'lang' and/or 'scheme'.

You may also set meta tags using the ``headMeta()`` helper method, which has the following signature: ``headMeta($content, $keyValue, $keyType = 'name', $modifiers = array(), $placement = 'APPEND')`` . ``$keyValue`` is the content for the key specified in ``$keyType`` , which should be either 'name' or 'http-equiv'. ``$keyType`` may also be specified as 'property' if the doctype has been set to XHTML1_RDFA. ``$placement`` can be 'SET' (overwrites all previously stored values), 'APPEND' (added to end of stack), or 'PREPEND' (added to top of stack).

``HeadMeta`` overrides each of ``append()`` , ``offsetSet()`` , ``prepend()`` , and ``set()`` to enforce usage of the special methods as listed above. Internally, it stores each item as a ``stdClass`` token, which it later serializes using the ``itemToString()`` method. This allows you to perform checks on the items in the stack, and optionally modify these items by simply modifying the object returned.

The ``HeadMeta`` helper is a concrete implementation of the :ref:`Placeholder helper <zend.view.helpers.initial.placeholder>` .


