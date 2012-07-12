
HeadStyle Helper
================

The *HTML* <style>element is used to include *CSS* stylesheets inline in the *HTML* <head>element.

.. note::
    **Use HeadLink to link CSS files**

     :ref:`HeadLink <zend.view.helpers.initial.headlink>` should be used to create<link>elements for including external stylesheets. ``HeadStyle`` is used when you wish to define your stylesheets inline.

The ``HeadStyle`` helper supports the following methods for setting and adding stylesheet declarations:

In all cases, ``$content`` is the actual *CSS* declarations. ``$attributes`` are any additional attributes you wish to provide to the ``style`` tag: lang, title, media, or dir are all permissible.

.. note::
    **Setting Conditional Comments**

     ``HeadStyle`` allows you to wrap the style tag in conditional comments, which allows you to hide it from specific browsers. To add the conditional tags, pass the conditional value as part of the ``$attributes`` parameter in the method calls.

.. _zend.view.helpers.initial.headstyle.conditional:

Headstyle With Conditional Comments
-----------------------------------

.. code-block:: php
    :linenos:
    
    // adding scripts
    $this->headStyle()->appendStyle($styles, array('conditional' => 'lt IE 7'));
    

``HeadStyle`` also allows capturing style declarations; this can be useful if you want to create the declarations programmatically, and then place them elsewhere. The usage for this will be showed in an example below.

Finally, you can also use the ``headStyle()`` method to quickly add declarations elements; the signature for this is ``headStyle($content$placement = 'APPEND', $attributes = array())`` . ``$placement`` should be either 'APPEND', 'PREPEND', or 'SET'.

``HeadStyle`` overrides each of ``append()`` , ``offsetSet()`` , ``prepend()`` , and ``set()`` to enforce usage of the special methods as listed above. Internally, it stores each item as a ``stdClass`` token, which it later serializes using the ``itemToString()`` method. This allows you to perform checks on the items in the stack, and optionally modify these items by simply modifying the object returned.

The ``HeadStyle`` helper is a concrete implementation of the :ref:`Placeholder helper <zend.view.helpers.initial.placeholder>` .

.. note::
    **UTF-8 encoding used by default**

    By default, Zend Framework uses *UTF-8* as its default encoding, and, specific to this case, ``Zend_View`` does as well. Character encoding can be set differently on the view object itself using the ``setEncoding()`` method (or the the ``encoding`` instantiation parameter). However, since ``Zend_View_Interface`` does not define accessors for encoding, it's possible that if you are using a custom view implementation with this view helper, you will not have a ``getEncoding()`` method, which is what the view helper uses internally for determining the character set in which to encode.

    If you do not want to utilize *UTF-8* in such a situation, you will need to implement a ``getEncoding()`` method in your custom view implementation.


