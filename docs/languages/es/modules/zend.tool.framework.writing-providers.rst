.. _zend.tool.framework.writing-providers:

Creando Proveedores para usar con Zend_Tool_Framework
=====================================================

In general, a provider, on its own, is nothing more than the shell for a developer to bundle up some capabilities
they wish to dispatch with the command line (or other) clients. It is an analogue to what a "controller" is inside
of your *MVC* application.

.. _zend.tool.framework.writing-providers.loading:

How Zend Tool finds your Providers
----------------------------------

By default Zend Tool uses the IncludePathLoader to find all the providers that you can run. It recursivly iterates
all include path directories and opens all files that end with "Manifest.php" or "Provider.php". All classes in
these files are inspected if they implement either ``Zend_Tool_Framework_Provider_Interface`` or
``Zend_Tool_Framework_Manifest_ProviderManifestable``. Instances of the provider interface make up for the real
functionality and all their public methods are accessible as provider actions. The ProviderManifestable interface
however requires the implementation of a method ``getProviders()`` which returns an array of instantiated provider
interface instances.

The following naming rules apply on how you can access the providers that were found by the IncludePathLoader:

- The last part of your classname split by underscore is used for the provider name, e.g. "My_Provider_Hello" leads
  to your provider being accessible by the name "hello".

- If your provider has a method ``getName()`` it will be used instead of the previous method to determine the name.

- If your provider has "Provider" as prefix, e.g. it is called ``My_HelloProvider`` it will be stripped from the
  name so that the provider will be called "hello".

.. note::

   The IncludePathLoader does not follow symlinks, that means you cannot link provider functionality into your
   include paths, they have to be physically present in the include paths.

.. _zend.tool.framework.writing-providers.loading.example:

.. rubric:: Exposing Your Providers with a Manifest

You can expose your providers to Zend Tool by offering a manifest with a special filename ending with
"Manifest.php". A Provider Manifest is an implementation of the
``Zend_Tool_Framework_Manifest_ProviderManifestable`` and requires the ``getProviders()`` method to return an array
of instantiated providers. In anticipation of our first own provider ``My_Component_HelloProvider`` we will create
the following manifest:

.. code-block:: php
   :linenos:

   class My_Component_Manifest
       implements Zend_Tool_Framework_Manifest_ProviderManifestable
   {
       public function getProviders()
       {
           return array(
               new My_Component_HelloProvider()
           );
       }
   }

.. _zend.tool.framework.writing-providers.basic:

Basic Instructions for Creating Providers
-----------------------------------------

As an example, if a developer wants to add the capability of showing the version of a datafile that his 3rd party
component is working from, there is only one class the developer would need to implement. Assuming the component is
called ``My_Component``, he would create a class named ``My_Component_HelloProvider`` in a file named
``HelloProvider.php`` somewhere on the ``include_path``. This class would implement
``Zend_Tool_Framework_Provider_Interface``, and the body of this file would only have to look like the following:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say()
       {
           echo 'Hello from my provider!';
       }
   }

Given that code above, and assuming the developer wishes to access this functionality through the console client,
the call would look like this:

.. code-block:: sh
   :linenos:

   % zf say hello
   Hello from my provider!

.. _zend.tool.framework.writing-providers.response:

The response object
-------------------

As discussed in the architecture section Zend Tool allows to hook different clients for using your Zend Tool
providers. To keep compliant with different clients you should use the response object to return messages from your
providers instead of using ``echo()`` or a similiar output mechanism. Rewritting our hello provider with this
knowledge it looks like:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $this->_registry->getResponse
                           ->appendContent("Hello from my provider!");
       }
   }

As you can see one has to extend the ``Zend_Tool_Framework_Provider_Abstract`` to gain access to the Registry which
holds the ``Zend_Tool_Framework_Client_Response`` instance.

.. _zend.tool.framework.writing-providers.advanced:

Advanced Development Information
--------------------------------

.. _zend.tool.framework.writing-providers.advanced.variables:

Passing Variables to a Provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The above "Hello World" example is great for simple commands, but what about something more advanced? As your
scripting and tooling needs grow, you might find that you need the ability to accept variables. Much like function
signatures have parameters, your tooling requests can also accept parameters.

Just as each tooling request can be isolated to a method within a class, the parameters of a tooling request can
also be isolated in a very well known place. Parameters of the action methods of a provider can include the same
parameters you want your client to utilize when calling that provider and action combination. For example, if you
wanted to accept a name in the above example, you would probably do this in OO code:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           echo 'Hello' . $name . ', from my provider!';
       }
   }

The above example can then be called via the command line ``zf say hello Joe``. "Joe" will be supplied to the
provider as a parameter of the method call. Also note, as you see that the parameter is optional, that means it is
also optional on the command line, so that ``zf say hello`` will still work, and default to the name "Ralph".

.. _zend.tool.framework.writing-providers.advanced.prompt:

Prompt the User for Input
^^^^^^^^^^^^^^^^^^^^^^^^^

There are cases when the workflow of your provider requires to prompt the user for input. This can be done by
requesting the client to ask for more the required input by calling:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say($name = 'Ralph')
       {
           $nameResponse = $this->_registry
                                ->getClient()
                                ->promptInteractiveInput("Whats your name?");
           $name = $name->getContent();

           echo 'Hello' . $name . ', from my provider!';
       }
   }

This command throws an exception if the current client is not able to handle interactive requests. In case of the
default Console Client however you will be asked to enter the name.

.. _zend.tool.framework.writing-providers.advanced.pretendable:

Pretending to execute a Provider Action
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Another interesting feature you might wish to implement is **pretendability**. Pretendabilty is the ability for
your provider to "pretend" as if it is doing the requested action and provider combination and give the user as
much information about what it **would** do without actually doing it. This might be an important notion when doing
heavy database or filesystem modifications that the user might not otherwise want to do.

Pretendability is easy to implement. There are two parts to this feature: 1) marking the provider as having the
ability to "pretend", and 2) checking the request to ensure the current request was indeed asked to be "pretended".
This feature is demonstrated in the code sample below.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends    Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Pretendable
   {
       public function say($name = 'Ralph')
       {
           if ($this->_registry->getRequest()->isPretend()) {
               echo 'I would say hello to ' . $name . '.';
           } else {
               echo 'Hello' . $name . ', from my provider!';
           }
       }
   }

To run the provider in pretend mode just call:

.. code-block:: sh
   :linenos:

   % zf --pretend say hello Ralph
   I would say hello Ralph.

.. _zend.tool.framework.writing-providers.advanced.verbosedebug:

Verbose and Debug modes
^^^^^^^^^^^^^^^^^^^^^^^

You can also run your provider actions in "verbose" or "debug" modes. The semantics in regard to this actions have
to be implemented by you in the context of your provider. You can access debug or verbose modes with:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           if($this->_registry->getRequest()->isVerbose()) {
               echo "Hello::say has been called\n";
           }
           if($this->_registry->getRequest()->isDebug()) {
               syslog(LOG_INFO, "Hello::say has been called\n");
           }
       }
   }

.. _zend.tool.framework.writing-providers.advanced.configstorage:

Accessing User Config and Storage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the Enviroment variable ``ZF_CONFIG_FILE`` or the .zf.ini in your home directory you can inject configuration
parameters into any Zend Tool provider. Access to this configuration is available via the registry that is passed
to your provider if you extend ``Zend_Tool_Framework_Provider_Abstract``.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $username = $this->_registry->getConfig()->username;
           if(!empty($username)) {
               echo "Hello $username!";
           } else {
               echo "Hello!";
           }
       }
   }

The returned configuration is of the type ``Zend_Tool_Framework_Client_Config`` but internally the ``__get()`` and
``__set()`` magic methods proxy to a ``Zend_Config`` of the given configuration type.

The storage allows to save arbitrary data for later reference. This can be useful for batch processing tasks or for
re-runs of your tasks. You can access the storage in a similar way like the configuration:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $aValue = $this->_registry->getStorage()->get("myUsername");
           echo "Hello $aValue!";
       }
   }

The API of the storage is very simple:

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Client_Storage
   {
       public function setAdapter($adapter);
       public function isEnabled();
       public function put($name, $value);
       public function get($name, $defaultValue=null);
       public function has($name);
       public function remove($name);
       public function getStreamUri($name);
   }

.. important::

   When designing your providers that are config or storage aware remember to check if the required user-config or
   storage keys really exist for a user. You won't run into fatal errors when none of these are provided though,
   since empty ones are created upon request.


