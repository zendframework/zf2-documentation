.. _zend.http.overview:

Overview of Zend\\Http
======================

.. _zend.http.overview.intro:

Overview
--------

``Zend\Http`` is a primary foundational component of Zend Framework. Since much of what PHP does is web-based,
specifically HTTP, it makes sense to have a performant, extensible, concise and consistent API to do all things
HTTP. In nutshell, there are several parts of ``Zend\Http``:

- Context-less ``Request`` and ``Response`` classes that expose a fluent API for introspecting several aspects of
  HTTP messages:

  - Request line information and response status information

  - Parameters, such as those found in *POST* and *GET*

  - Message Body

  - Headers

- A Client implementation with various adapters that allow for sending requests and introspecting responses.

.. _zend.http.overview.request-response-and-headers:

Zend\\Http Request, Response and Headers
----------------------------------------

The Request, Response and Headers portion of the ``Zend\Http`` component provides a fluent, object-oriented
interface for introspecting information from all the various parts of an HTTP request or HTTP response. The two
main objects are ``Zend\Http\Request`` and ``Zend\Http\Response``. These two classes are "context-less", meaning
that they model a request or response in the same way whether it is presented by a client (to **send** a request
and **receive** a response) or by a server (to **receive** a request and **send** a response). In other words,
regardless of the context, the API remains the same for introspecting their various respective parts. Each attempts
to fully model a request or response so that a developer can create these objects from a factory, or create and
populate them manually.


