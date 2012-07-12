
Zend_Navigation_Page_Mvc
========================

*MVC* pages are defined using *MVC* parameters known from the ``Zend_Controller`` component. An *MVC* page will use ``Zend_Controller_Action_Helper_Url`` internally in the ``getHref()`` method to generate hrefs, and the ``isActive()`` method will intersect the ``Zend_Controller_Request_Abstract`` params with the page's params to determine if the page is active.

.. note::
    ****

    The three examples below assume a default *MVC* setup with thedefaultroute in place.

    The *URI* returned is relative to thebaseUrlin ``Zend_Controller_Front`` . In the examples, the baseUrl is '/' for simplicity.


