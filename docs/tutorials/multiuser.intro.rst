
.. _learning.multiuser.intro:

Building Multi-User Applications With Zend Framework
====================================================


.. _learning.multiuser.intro.zf:

Zend Framework
--------------

When the original "web" was created, it was designed to be a publishing platform for predominantly static content. As demand for content on the web grew, as did the number of consumers on the internet for web content, the demand for using the web as an application platform also grew. Since the web is inherently good at delivering a simultaneous experience to many consumers from a single location, it makes it an ideal environment for building dynamically driven, multi-user, and more commonly today, social systems.

*HTTP* is the protocol of the web: a stateless, typically short lived, request and response protocol. This protocol was designed this way because the original intent of the web was to serve or publish static content. It is this very design that has made the web as immensely successful as it is. It is also exactly this design that brings new concerns to developers who wish to use the web as an application platform.

These concerns and responsibilities can effectively be summed up by three questions:

- How do you distinguish one application consumer from another?

- How do you identify a consumer as authentic?

- How do you control what a consumer has access to?

.. note::
   **Consumer Vs. User**

   Notice we use the term "consumer" instead of person. Increasingly, web applications are becoming service driven. This means that not only are real people ("users") with real web browsers consuming and using your application, but also other web applications through machine service technologies such as *REST*, *SOAP*, and *XML-RPC*. In this respect, people, as well as other consuming applications, should all be treated in same with regard to the concerns outlined above.


In the following chapters, we'll take a look at these common problems relating to authentication and authorization in detail. We will discover how 3 main components: ``Zend_Session``, ``Zend_Auth``, and ``Zend_Acl``; provide an out-of-the-box solution as well as the extension points each have that will cater to a more customized solution.


