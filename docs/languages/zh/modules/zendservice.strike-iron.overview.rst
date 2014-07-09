.. _zendservice.strikeiron:

ZendService\\StrikeIron
=======================

``ZendService\StrikeIron\StrikeIron`` provides a *PHP* 5 client to StrikeIron web services. See the following sections:



   - :ref:`ZendService\StrikeIron\StrikeIron <zendservice.strikeiron>`



   - :ref:`Bundled Services <zendservice.strikeiron.bundled-services>`



   - :ref:`Advanced Use <zendservice.strikeiron.advanced-uses>`



.. _zendservice.strikeiron.overview:

Overview
--------

`StrikeIron`_ offers hundreds of commercial data services ("Data as a Service") such as Online Sales Tax, Currency
Rates, Stock Quotes, Geocodes, Global Address Verification, Yellow/White Pages, MapQuest Driving Directions, Dun &
Bradstreet Business Credit Checks, and much, much more.

Each StrikeIron web service shares a standard *SOAP* (and REST) *API*, making it easy to integrate and manage
multiple services. StrikeIron also manages customer billing for all services in a single account, making it perfect
for solution providers. Get started with free web services at http://www.strikeiron.com/sdp.

StrikeIron's services may be used through the `PHP 5 SOAP extension`_ alone. However, using StrikeIron this way
does not give an ideal *PHP*-like interface. The ``ZendService\StrikeIron\StrikeIron`` component provides a lightweight layer
on top of the *SOAP* extension for working with StrikeIron services in a more convenient, *PHP*-like manner.

.. note::

   The *PHP* 5 *SOAP* extension must be installed and enabled to use ``ZendService\StrikeIron\StrikeIron``.

The ``ZendService\StrikeIron\StrikeIron`` component provides:



   - A single point for configuring your StrikeIron authentication credentials that can be used across many
     StrikeIron services.

   - A standard way of retrieving your StrikeIron subscription information such as license status and the number of
     hits remaining to a service.

   - The ability to use any StrikeIron service from its WSDL without creating a *PHP* wrapper class, and the option
     of creating a wrapper for a more convenient interface.

   - Wrappers for three popular StrikeIron services.



.. _zendservice.strikeiron.registering:

Registering with StrikeIron
---------------------------

Before you can get started with ``ZendService\StrikeIron\StrikeIron``, you must first `register`_ for a StrikeIron developer
account.

After registering, you will receive a StrikeIron username and password. These will be used when connecting to
StrikeIron using ``ZendService\StrikeIron\StrikeIron``.

You will also need to `sign up`_ for StrikeIron's Super Data Pack Web Service.

Both registration steps are free and can be done relatively quickly through the StrikeIron website.

.. _zendservice.strikeiron.getting-started:

Getting Started
---------------

Once you have `registered`_ for a StrikeIron account and signed up for the `Super Data Pack`_, you're ready to
start using ``ZendService\StrikeIron\StrikeIron``.

StrikeIron consists of hundreds of different web services. ``ZendService\StrikeIron\StrikeIron`` can be used with many of
these services but provides supported wrappers for three of them:

- :ref:`ZIP Code Information <zendservice.strikeiron.bundled-services.zip-code-information>`

- :ref:`US Address Verification <zendservice.strikeiron.bundled-services.us-address-verification>`

- :ref:`Sales & Use Tax Basic <zendservice.strikeiron.bundled-services.sales-use-tax-basic>`

The class ``ZendService\StrikeIron\StrikeIron`` provides a simple way of specifying your StrikeIron account information and
other options in its constructor. It also has a factory method that will return clients for StrikeIron services:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

The ``getService()`` method will return a client for any StrikeIron service by the name of its *PHP* wrapper class.
In this case, the name 'SalesUseTaxBasic' refers to the wrapper class ``ZendService\StrikeIron\SalesUseTaxBasic``.
Wrappers are included for three services and described in :ref:`Bundled Services
<zendservice.strikeiron.bundled-services>`.

The ``getService()`` method can also return a client for a StrikeIron service that does not yet have a *PHP*
wrapper. This is explained in :ref:`Using Services by WSDL
<zendservice.strikeiron.advanced-uses.services-by-wsdl>`.

.. _zendservice.strikeiron.making-first-query:

Making Your First Query
-----------------------

Once you have used the ``getService()`` method to get a client for a particular StrikeIron service, you can utilize
that client by calling methods on it just like any other *PHP* object.

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Get a client for the Sales & Use Tax Basic service
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Query tax rate for Ontario, Canada
   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
   echo $rateInfo->province;
   echo $rateInfo->abbreviation;
   echo $rateInfo->GST;

In the example above, the ``getService()`` method is used to return a client to the :ref:`Sales & Use Tax Basic
<zendservice.strikeiron.bundled-services.sales-use-tax-basic>` service. The client object is stored in
``$taxBasic``.

The ``getTaxRateCanada()`` method is then called on the service. An associative array is used to supply keyword
parameters to the method. This is the way that all StrikeIron methods are called.

The result from ``getTaxRateCanada()`` is stored in ``$rateInfo`` and has properties like ``province`` and ``GST``.

Many of the StrikeIron services are as simple to use as the example above. See :ref:`Bundled Services
<zendservice.strikeiron.bundled-services>` for detailed information on three StrikeIron services.

.. _zendservice.strikeiron.examining-results:

Examining Results
-----------------

When learning or debugging the StrikeIron services, it's often useful to dump the result returned from a method
call. The result will always be an object that is an instance of ``ZendService\StrikeIron\Decorator``. This is a
small `decorator`_ object that wraps the results from the method call.

The simplest way to examine a result from the service is to use the built-in *PHP* functions like `print_r()`_:

.. code-block:: php
   :linenos:

   <?php
   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
   print_r($rateInfo);
   ?>

   ZendService\StrikeIron\Decorator Object
   (
       [_name:protected] => GetTaxRateCanadaResult
       [_object:protected] => stdClass Object
           (
               [abbreviation] => ON
               [province] => ONTARIO
               [GST] => 0.06
               [PST] => 0.08
               [total] => 0.14
               [HST] => Y
           )
   )

In the output above, we see that the decorator (``$rateInfo``) wraps an object named ``GetTaxRateCanadaResult``,
the result of the call to ``getTaxRateCanada()``.

This means that ``$rateInfo`` has public properties like ``abbreviation``, ``province``>, and ``GST``. These are
accessed like ``$rateInfo->province``.

.. tip::

   StrikeIron result properties sometimes start with an uppercase letter such as ``Foo`` or ``Bar`` where most
   *PHP* object properties normally start with a lowercase letter as in ``foo`` or ``bar``. The decorator will
   automatically do this inflection so you may read a property ``Foo`` as ``foo``.

If you ever need to get the original object or its name out of the decorator, use the respective methods
``getDecoratedObject()`` and ``getDecoratedObjectName()``.

.. _zendservice.strikeiron.handling-errors:

Handling Errors
---------------

The previous examples are naive, i.e. no error handling was shown. It's possible that StrikeIron will return a
fault during a method call. Events like bad account credentials or an expired subscription can cause StrikeIron to
raise a fault.

An exception will be thrown when such a fault occurs. You should anticipate and catch these exceptions when making
method calls to the service:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   try {

     $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

   } catch (ZendService\StrikeIron\Exception\RuntimeException $e) {

     // error handling for events like connection
     // problems or subscription errors

   }

The exceptions thrown will always be ``ZendService\StrikeIron\Exception``.

It's important to understand the difference between exceptions and normal failed method calls. Exceptions occur for
**exceptional** conditions, such as the network going down or your subscription expiring. Failed method calls that
are a common occurrence, such as ``getTaxRateCanada()`` not finding the ``province`` you supplied, will not result
an in exception.

.. note::

   Every time you make a method call to a StrikeIron service, you should check the response object for validity and
   also be prepared to catch an exception.



.. _zendservice.strikeiron.checking-subscription:

Checking Your Subscription
--------------------------

StrikeIron provides many different services. Some of these are free, some are available on a trial basis, and some
are pay subscription only. When using StrikeIron, it's important to be aware of your subscription status for the
services you are using and check it regularly.

Each StrikeIron client returned by the ``getService()`` method has the ability to check the subscription status for
that service using the ``getSubscriptionInfo()`` method of the client:

.. code-block:: php
   :linenos:

   // Get a client for the Sales & Use Tax Basic service
   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class => 'SalesUseTaxBasic'));

   // Check remaining hits for the Sales & Use Tax Basic service
   $subscription = $taxBasic->getSubscriptionInfo();
   echo $subscription->remainingHits;

The ``getSubscriptionInfo()`` method will return an object that typically has a ``remainingHits`` property. It's
important to check the status on each service that you are using. If a method call is made to StrikeIron after the
remaining hits have been used up, an exception will occur.

Checking your subscription to a service does not use any remaining hits to the service. Each time any method call
to the service is made, the number of hits remaining will be cached and this cached value will be returned by
``getSubscriptionInfo()`` without connecting to the service again. To force ``getSubscriptionInfo()`` to override
its cache and query the subscription information again, use ``getSubscriptionInfo(true)``.



.. _`StrikeIron`: http://www.strikeiron.com
.. _`PHP 5 SOAP extension`: http://us.php.net/soap
.. _`register`: http://strikeiron.com/Register.aspx
.. _`sign up`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`registered`: http://strikeiron.com/Register.aspx
.. _`Super Data Pack`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`decorator`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`print_r()`: http://www.php.net/print_r
