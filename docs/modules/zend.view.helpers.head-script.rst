
HeadScript Helper
=================

The *HTML* <script>element is used to either provide inline client-side scripting elements or link to a remote resource containing client-side scripting code. The ``HeadScript`` helper allows you to manage both.

The ``HeadScript`` helper supports the following methods for setting and adding scripts:

In the case of the * ``File()`` methods, ``$src`` is the remote location of the script to load; this is usually in the form of a *URL* or a path. For the * ``Script()`` methods, ``$script`` is the client-side scripting directives you wish to use in the element.

.. note::
    **Setting Conditional Comments**

     ``HeadScript`` allows you to wrap the script tag in conditional comments, which allows you to hide it from specific browsers. To add the conditional tags, pass the conditional value as part of the ``$attrs`` parameter in the method calls.

.. _zend.view.helpers.initial.headscript.conditional:

Headscript With Conditional Comments
------------------------------------

.. code-block:: php
    :linenos:
    
    // adding scripts
    $this->headScript()->appendFile(
        '/js/prototype.js',
        'text/javascript',
        array('conditional' => 'lt IE 7')
    );
    

.. note::
    **Preventing HTML style comments or CDATA wrapping of scripts**

    By default ``HeadScript`` will wrap scripts with HTML comments or it wraps scripts with XHTML cdata. This behavior can be problematic when you intend to use the script tag in an alternative way by setting the type to something other then 'text/javascript'. To prevent such escaping, pass an ``noescape`` with a value of true as part of the ``$attrs`` parameter in the method calls.

.. _zend.view.helpers.initial.headscript.noescape:

Create an jQuery template with the headScript
---------------------------------------------

.. code-block:: php
    :linenos:
    
    // jquery template
    $template = '<div class="book">{{:title}}</div>';
    $this->headScript()->appendScript(
        $template,
        'text/x-jquery-tmpl',
        array('id='tmpl-book', 'noescape' => true)
    );
    
    

``HeadScript`` also allows capturing scripts; this can be useful if you want to create the client-side script programmatically, and then place it elsewhere. The usage for this will be showed in an example below.

Finally, you can also use the ``headScript()`` method to quickly add script elements; the signature for this is ``headScript($mode = 'FILE', $spec, $placement = 'APPEND')`` . The ``$mode`` is either 'FILE' or 'SCRIPT', depending on if you're linking a script or defining one. ``$spec`` is either the script file to link or the script source itself. ``$placement`` should be either 'APPEND', 'PREPEND', or 'SET'.

``HeadScript`` overrides each of ``append()`` , ``offsetSet()`` , ``prepend()`` , and ``set()`` to enforce usage of the special methods as listed above. Internally, it stores each item as a ``stdClass`` token, which it later serializes using the ``itemToString()`` method. This allows you to perform checks on the items in the stack, and optionally modify these items by simply modifying the object returned.

The ``HeadScript`` helper is a concrete implementation of the :ref:`Placeholder helper <zend.view.helpers.initial.placeholder>` .

.. note::
    **Use InlineScript for HTML Body Scripts**

     ``HeadScript`` 's sibling helper, :ref:`InlineScript <zend.view.helpers.initial.inlinescript>` , should be used when you wish to include scripts inline in the *HTML* body. Placing scripts at the end of your document is a good practice for speeding up delivery of your page, particularly when using 3rd party analytics scripts.

.. note::
    **Arbitrary Attributes are Disabled by Default**

    By default, ``HeadScript`` only will render<script>attributes that are blessed by the W3C. These include 'type', 'charset', 'defer', 'language', and 'src'. However, some javascript frameworks, notably `Dojo`_ , utilize custom attributes in order to modify behavior. To allow such attributes, you can enable them via the ``setAllowArbitraryAttributes()`` method:

.. code-block:: php
    :linenos:
    
    $this->headScript()->setAllowArbitraryAttributes(true);
    


.. _`Dojo`: http://www.dojotoolkit.org/
