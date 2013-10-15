.. _zend.soap.autodiscovery:

AutoDiscovery
=============

.. _zend.soap.autodiscovery.introduction:

AutoDiscovery Introduction
--------------------------

*SOAP* functionality implemented within Zend Framework is intended to make all steps required for *SOAP*
communications more simple.

*SOAP* is language independent protocol. So it may be used not only for *PHP*-to-PHP communications.

There are three configurations for *SOAP* applications where Zend Framework may be utilized:

- SOAP server *PHP* application <---> *SOAP* client *PHP* application

- SOAP server non-PHP application <---> *SOAP* client *PHP* application

- SOAP server *PHP* application <---> *SOAP* client non-PHP application


We always have to know, which functionality is provided by *SOAP* server to operate with it. `WSDL`_ is used to
describe network service *API* in details.

WSDL language is complex enough (see http://www.w3.org/TR/wsdl for the details). So it's difficult to prepare
correct WSDL description.

Another problem is synchronizing changes in network service *API* with already existing WSDL.

Both these problem may be solved by WSDL autogeneration. A prerequisite for this is a *SOAP* server autodiscovery.
It constructs object similar to object used in *SOAP* server application, extracts necessary information and
generates correct WSDL using this information.

There are two ways for using Zend Framework for *SOAP* server application:

- Use separated class.

- Use set of functions.


Both methods are supported by Zend Framework Autodiscovery functionality.

The ``Zend\Soap\AutoDiscover`` class also supports datatypes mapping from *PHP* to `XSD types`_.

Here is an example of common usage of the autodiscovery functionality. The ``generate()`` function generates the
WSDL object and in conjunction with ``toXml()`` function you can posts it to the browser.

.. code-block:: php
   :linenos:

   class MySoapServerClass {
   ...
   }

   $autodiscover = new Zend\Soap\AutoDiscover();
   $autodiscover->setClass('MySoapServerClass')
                ->setUri('http://localhost/server.php')
                ->setServiceName('MySoapService');
   $wsdl = $autodiscover->generate();
   echo $wsdl->toXml();
   $wsdl->dump("/path/to/file.wsdl");
   $dom = $wsdl->toDomDocument();

.. note::

   **Zend\Soap\Autodiscover is not a Soap Server**

   It is very important to note, that the class ``Zend\Soap\AutoDiscover`` does not act as a *SOAP* Server on its
   own.

   .. code-block:: php
      :linenos:

      if (isset($_GET['wsdl'])) {
          $autodiscover = new Zend\Soap\AutoDiscover();
          $autodiscover->setClass('HelloWorldService')
                       ->setUri('http://example.com/soap.php');
          echo $autodiscover->toXml();
      } else {
          // pointing to the current file here
          $soap = new Zend\Soap\Server("http://example.com/soap.php?wsdl");
          $soap->setClass('HelloWorldService');
          $soap->handle();
      }

.. _zend.soap.autodiscovery.class:

Class autodiscovering
---------------------

If a class is used to provide SOAP server functionality, then the same class should be provided to
``Zend\Soap\AutoDiscover`` for WSDL generation:

.. code-block:: php
   :linenos:

   $autodiscover = new Zend\Soap\AutoDiscover();
   $autodiscover->setClass('My_SoapServer_Class')
                ->setUri('http://localhost/server.php')
                ->setServiceName('MySoapService');
   $wsdl = $autodiscover->generate();

The following rules are used while WSDL generation:


- Generated WSDL describes an RPC/Encoded style Web Service. If you want to use a document/literal server use the 
  ``setBindingStyle()`` and ``setOperationBodyStyle()`` methods.

- Class name is used as a name of the Web Service being described unless ``setServiceName()`` is used explicitly to
  set the name. When only functions are used for generation the service name has to be set explicitly or an exception
  is thrown during generation of the WSDL document.

- You can set the endpoint of the actual SOAP Server via the ``setUri()`` method. This is a required option.

It's also used as a target namespace for all service related names (including described complex types).

- Class methods are joined into one `Port Type`_. *$serviceName . 'Port'* is used as Port Type name.

- Each class method/function is registered as a corresponding port operation.

- Only the "longest" available method prototype is used for generation of the WSDL.

- WSDL autodiscover utilizes the *PHP* docblocks provided by the developer to determine the parameter and return 
  types. In fact, for scalar types, this is the only way to determine the parameter types, and for return types, 
  this is the only way to determine them. That means, providing correct and fully detailed docblocks is not only 
  best practice, but is required for discovered class.

.. _zend.soap.autodiscovery.functions:

Functions autodiscovering
-------------------------

If set of functions are used to provide SOAP server functionality, then the same set should be provided to
``Zend\Soap\AutoDiscovery`` for WSDL generation:

.. code-block:: php
   :linenos:

   $autodiscover = new Zend\Soap\AutoDiscover();
   $autodiscover->addFunction('function1');
   $autodiscover->addFunction('function2');
   $autodiscover->addFunction('function3');
   ...
   $wsdl = $autodiscover->generate();

The same rules apply to generation as described in the class autodiscover section above.

.. _zend.soap.autodiscovery.datatypes:

Autodiscovering Datatypes
-------------------------

Input/output datatypes are converted into network service types using the following mapping:

- PHP strings <-> *xsd:string*.

- PHP integers <-> *xsd:int*.

- PHP floats and doubles <-> *xsd:float*.

- PHP booleans <-> *xsd:boolean*.

- PHP arrays <-> *soap-enc:Array*.

- PHP object <-> *xsd:struct*.

- *PHP* class <-> based on complex type strategy (See: :ref:`this section <zend.soap.wsdl.types.add_complex>`) [#]_.

- type[] or object[] (ie. int[]) <-> based on complex type strategy

- PHP void <-> empty type.

- If type is not matched to any of these types by some reason, then *xsd:anyType* is used.

Where *xsd:* is "http://www.w3.org/2001/XMLSchema" namespace, *soap-enc:* is a
"http://schemas.xmlsoap.org/soap/encoding/" namespace, *tns:* is a "target namespace" for a service.

.. _zend.soap.autodiscovery.wsdlstyles:

WSDL Binding Styles
-------------------

WSDL offers different transport mechanisms and styles. This affects the *soap:binding* and *soap:body* tags within
the Binding section of WSDL. Different clients have different requirements as to what options really work.
Therefore you can set the styles before you call any *setClass* or *addFunction* method on the AutoDiscover class.

.. code-block:: php
   :linenos:

   $autodiscover = new Zend\Soap\AutoDiscover();
   // Default is 'use' => 'encoded' and
   // 'encodingStyle' => 'http://schemas.xmlsoap.org/soap/encoding/'
   $autodiscover->setOperationBodyStyle(
                       array('use' => 'literal',
                             'namespace' => 'http://framework.zend.com')
                   );

   // Default is 'style' => 'rpc' and
   // 'transport' => 'http://schemas.xmlsoap.org/soap/http'
   $autodiscover->setBindingStyle(
                       array('style' => 'document',
                             'transport' => 'http://framework.zend.com')
                   );
   ...
   $autodiscover->addFunction('myfunc1');
   $wsdl = $autodiscover->generate();


.. _`WSDL`: http://www.w3.org/TR/wsdl
.. _`XSD types`: http://www.w3.org/TR/xmlschema-2/
.. _`Port Type`: http://www.w3.org/TR/wsdl#_porttypes

.. [#] ``Zend\Soap\AutoDiscover`` will be created with the
       ``Zend\Soap\Wsdl\ComplexTypeStrategy\DefaultComplexType`` class as detection algorithm for complex
       types. The first parameter of the AutoDiscover constructor takes any complex type strategy implementing
       ``Zend\Soap\Wsdl\ComplexTypeStrategy\ComplexTypeStrategyInterface`` or a string with the name of the class.
       See the :ref:`Zend\\Soap\\Wsdl manual on adding complex <zend.soap.wsdl.types.add_complex>` types for more
       information.
