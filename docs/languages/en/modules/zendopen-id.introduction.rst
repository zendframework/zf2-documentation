.. _zendopenid.introduction:

Introduction
============

``ZendOpenId`` is a Zend Framework component that provides a simple *API* for building OpenID-enabled sites and
identity providers.

.. _zendopenid.introduction.what:

What is OpenID?
---------------

OpenID is a set of protocols for user-centric digital identities. These protocols allows users to create an
identity online, using an identity provider. This identity can be used on any site that supports OpenID. Using
OpenID-enabled sites, users do not need to remember traditional authentication tokens such as usernames and
passwords for each site. All OpenID-enabled sites accept a single OpenID identity. This identity is typically a
*URL*. It may be the *URL* of the user's personal page, blog or other resource that may provide additional
information about them. That mean a user needs just one identifier for all sites he or she uses. services. OpenID
is an open, decentralized, and free user-centric solution. Users may choose which OpenID provider to use, or even
create their own personal identity server. No central authority is required to approve or register OpenID-enabled
sites or identity providers.

For more information about OpenID visit the `OpenID official site`_.

.. _zendopenid.introduction.how:

How Does it Work?
-----------------

The purpose of the ``ZendOpenId`` component is to implement the OpenID authentication protocol as described in the
following sequence diagram:

.. image:: ../images/zendopenid.protocol.jpg
   :width: 559
   :align: center

. Authentication is initiated by the end user, who passes their OpenID identifier to the OpenID consumer through a
  User-Agent.

. The OpenID consumer performs normalization and discovery on the user-supplied identifier. Through this process,
  the consumer obtains the claimed identifier, the *URL* of the OpenID provider and an OpenID protocol version.

. The OpenID consumer establishes an optional association with the provider using Diffie-Hellman keys. As a result,
  both parties have a common "shared secret" that is used for signing and verification of the subsequent messages.

. The OpenID consumer redirects the User-Agent to the *URL* of the OpenID provider with an OpenID authentication
  request.

. The OpenID provider checks if the User-Agent is already authenticated and, if not, offers to do so.

. The end user enters the required password.

. The OpenID provider checks if it is allowed to pass the user identity to the given consumer, and asks the user if
  necessary.

. The user allows or disallows passing his identity.

. The OpenID Provider redirects the User-Agent back to the OpenID consumer with an "authentication approved" or
  "failed" request.

. The OpenID consumer verifies the information received from the provider by using the shared secret it got in step
  3 or by sending an additional direct request to the OpenID provider.

.. _zendopenid.introduction.structure:

ZendOpenId Structure
---------------------

``ZendOpenId`` consists of two sub-packages. The first one is ``ZendOpenId\Consumer`` for developing
OpenID-enabled sites, and the second is ``ZendOpenId\Provider`` for developing OpenID servers. They are completely
independent of each other and may be used separately.

The only common code used by these sub-packages are the OpenID Simple Registration Extension implemented by
``ZendOpenId\Extension\Sreg`` class and a set of utility functions implemented by the ``ZendOpenId`` class.

.. note::

   ``ZendOpenId`` takes advantage of the `GMP extension`_, where available. Consider enabling the GMP extension
   for enhanced performance when using ``ZendOpenId``.

.. _zendopenid.introduction.standards:

Supported OpenID Standards
--------------------------

The ``ZendOpenId`` component supports the following standards:

- OpenID Authentication protocol version 1.1

- OpenID Authentication protocol version 2.0 draft 11

- OpenID Simple Registration Extension version 1.0

- OpenID Simple Registration Extension version 1.1 draft 1



.. _`OpenID official site`: http://www.openid.net/
.. _`GMP extension`: http://php.net/gmp
