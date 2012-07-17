
.. _zend.oauth.introduction:

Introduction to OAuth
=====================

OAuth allows you to approve access by any application to your private data stored a website without being forced to disclose your username or password. If you think about it, the practice of handing over your username and password for sites like Yahoo Mail or Twitter has been endemic for quite a while. This has raised some serious concerns because there's nothing to prevent other applications from misusing this data. Yes, some services may appear trustworthy but that is never guaranteed. OAuth resolves this problem by eliminating the need for any username and password sharing, replacing it with a user controlled authorization process.

This authorization process is token based. If you authorize an application (and by application we can include any web based or desktop application) to access your data, it will be in receipt of an Access Token associated with your account. Using this Access Token, the application can access your private data without continually requiring your credentials. In all this authorization delegation style of protocol is simply a more secure solution to the problem of accessing private data via any web service *API*.

OAuth is not a completely new idea, rather it is a standardized protocol building on the existing properties of protocols such as Google AuthSub, Yahoo BBAuth, Flickr *API*, etc. These all to some extent operate on the basis of exchanging user credentials for an Access Token of some description. The power of a standardized specification like OAuth is that it only requires a single implementation as opposed to many disparate ones depending on the web service. This standardization has not occurred independently of the major players, and indeed many now support OAuth as an alternative and future replacement for their own solutions.

Zend Framework's ``Zend_Oauth`` currently implements a full OAuth Consumer conforming to the OAuth Core 1.0 Revision A Specification (24 June 2009) via the ``Zend_Oauth_Consumer`` class.


.. include:: zend.oauth.protocol-workflow.rst
.. include:: zend.oauth.security-architecture.rst
.. include:: zend.oauth.getting-started.rst
