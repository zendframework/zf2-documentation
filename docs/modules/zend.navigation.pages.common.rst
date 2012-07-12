
Common page features
====================

All page classes must extend ``Zend_Navigation_Page`` , and will thus share a common set of features and properties. Most notably they share the options in the table below and the same initialization process.

Option keys are mapped tosetmethods. This means that the optionordermaps to the method ``setOrder()`` , andreset_paramsmaps to the method ``setResetParams()`` . If there is no setter method for the option, it will be set as a custom property of the page.

Read more on extending ``Zend_Navigation_Page`` in :ref:`Creating custom page types <zend.navigation.pages.custom>` .

.. note::
    **Custom properties**

    All pages support setting and getting of custom properties by use of the magic methods ``__set($name, $value)`` , ``__get($name)`` , ``__isset($name)`` and ``__unset($name)`` . Custom properties may have any value, and will be included in the array that is returned from$page->toArray(), which means that pages can be serialized/deserialized successfully even if the pages contains properties that are not native in the page class.

    Both native and custom properties can be set using$page->set($name, $value)and retrieved using$page->get($name), or by using magic methods.


