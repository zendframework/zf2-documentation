
Creating custom page types
==========================

When extending ``Zend_Navigation_Page`` , there is usually no need to override the constructor or the methods ``setOptions()`` or ``setConfig()`` . The page constructor takes a single parameter, an ``Array`` or a ``Zend_Config`` object, which is passed to ``setOptions()`` or ``setConfig()`` respectively. Those methods will in turn call ``set()`` method, which will map options to native or custom properties. If the option ``internal_id`` is given, the method will first look for a method named ``setInternalId()`` , and pass the option to this method if it exists. If the method does not exist, the option will be set as a custom property of the page, and be accessible via ``$internalId = $page->internal_id;`` or ``$internalId = $page->get('internal_id');`` .


