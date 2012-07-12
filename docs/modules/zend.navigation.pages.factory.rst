
Creating pages using the page factory
=====================================

All pages (also custom classes), can be created using the page factory, ``Zend_Navigation_Page::factory()`` . The factory can take an array with options, or a ``Zend_Config`` object. Each key in the array/config corresponds to a page option, as seen in the section on :ref:`Pages <zend.navigation.pages>` . If the optionuriis given and no *MVC* options are given (action, controller, module, route), an *URI* page will be created. If any of the *MVC* options are given, an *MVC* page will be created.

Iftypeis given, the factory will assume the value to be the name of the class that should be created. If the value ismvcoruriand *MVC* /URI page will be created.


