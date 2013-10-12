.. _zendamf.server:

ZendAmf\Server
===============

``ZendAmf\Server`` provides an *RPC*-style server for handling requests made from the Adobe Flash Player using the
*AMF* protocol. Like all Zend Framework server classes, it follows the SoapServer *API*, providing an easy to
remember interface for creating servers.

.. _zendamf.server.basic:

.. rubric:: Basic AMF Server

Let's assume that you have created a class ``Foo`` with a variety of public methods. You may create an *AMF* server
using the following code:

.. code-block:: php
   :linenos:

   $server = new ZendAmf\Server();
   $server->setClass('Foo');
   $response = $server->handle();
   echo $response;

Alternately, you may choose to attach a simple function as a callback instead:

.. code-block:: php
   :linenos:

   $server = new ZendAmf\Server();
   $server->addFunction('myUberCoolFunction');
   $response = $server->handle();
   echo $response;

You could also mix and match multiple classes and functions. When doing so, we suggest namespacing each to ensure
that no method name collisions occur; this can be done by simply passing a second string argument to either
``addFunction()`` or ``setClass()``:

.. code-block:: php
   :linenos:

   $server = new ZendAmf\Server();
   $server->addFunction('myUberCoolFunction', 'my')
          ->setClass('Foo', 'foo')
          ->setClass('Bar', 'bar');
   $response = $server->handle();
   echo $response;

The ``ZendAmf\Server`` also allows services to be dynamically loaded based on a supplied directory path. You may
add as many directories as you wish to the server. The order that you add the directories to the server will be the
order that the *LIFO* search will be performed on the directories to match the class. Adding directories is
completed with the ``addDirectory()`` method.

.. code-block:: php
   :linenos:

   $server->addDirectory(dirname(__FILE__) .'/../services/');
   $server->addDirectory(dirname(__FILE__) .'/../package/');

When calling remote services your source name can have underscore ("\_") and dot (".") directory delimiters. When
an underscore is used *PEAR* and Zend Framework class naming conventions will be respected. This means that if you
call the service com_Foo_Bar the server will look for the file ``Bar.php`` in the each of the included paths at
``com/Foo/Bar.php``. If the dot notation is used for your remote service such as ``com.Foo.Bar`` each included path
will have ``com/Foo/Bar.php`` append to the end to autoload ``Bar.php``

All *AMF* requests sent to the script will then be handled by the server, and an *AMF* response will be returned.

.. note::

   **All Attached Methods and Functions Need Docblocks**

   Like all other server components in Zend Framework, you must document your class methods using *PHP* docblocks.
   At the minimum, you need to provide annotations for each required argument as well as the return value. As
   examples:

   .. code-block:: php
      :linenos:

      // Function to attach:

      /**
       * @param  string $name
       * @param  string $greeting
       * @return string
       */
      function helloWorld($name, $greeting = 'Hello')
      {
          return $greeting . ', ' . $name;
      }

   .. code-block:: php
      :linenos:

      // Attached class

      class World
      {
          /**
           * @param  string $name
           * @param  string $greeting
           * @return string
           */
          public function hello($name, $greeting = 'Hello')
          {
              return $greeting . ', ' . $name;
          }
      }

   Other annotations may be used, but will be ignored.

.. _zendamf.server.flex:

Connecting to the Server from Flex
----------------------------------

Connecting to your ``ZendAmf\Server`` from your Flex project is quite simple; you simply need to point your
endpoint *URI* to your ``ZendAmf\Server`` script.

Say, for instance, you have created your server and placed it in the ``server.php`` file in your application root,
and thus the *URI* is ``http://example.com/server.php``. In this case, you would modify your
``services-config.xml`` file to set the channel endpoint uri attribute to this value.

If you have never created a ``service-config.xml`` file you can do so by opening your project in your Navigator
window. Right click on the project name and select 'properties'. In the Project properties dialog go into 'Flex
Build Path' menu, 'Library path' tab and be sure the '``rpc.swc``' file is added to your projects path and Press Ok
to close the window.

You will also need to tell the compiler to use the ``service-config.xml`` to find the RemoteObject endpoint. To do
this open your project properties panel again by right clicking on the project folder from your Navigator and
selecting properties. From the properties popup select 'Flex Compiler' and add the string: ``-services
"services-config.xml"``. Press Apply then OK to return to update the option. What you have just done is told the
Flex compiler to look to the ``services-config.xml`` file for runtime variables that will be used by the
RemotingObject class.

We now need to tell Flex which services configuration file to use for connecting to our remote methods. For this
reason create a new '``services-config.xml``' file into your Flex project src folder. To do this right click on the
project folder and select 'new' 'File' which will popup a new window. Select the project folder and then name the
file '``services-config.xml``' and press finish.

Flex has created the new ``services-config.xml`` and has it open. Use the following example text for your
``services-config.xml`` file. Make sure that you update your endpoint to match that of your testing server. Make
sure you save the file.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <services-config>
       <services>
           <service id="zend-service"
               class="flex.messaging.services.RemotingService"
               messageTypes="flex.messaging.messages.RemotingMessage">
               <destination id="zend">
                   <channels>
                       <channel ref="zend-endpoint"/>
                   </channels>
                   <properties>
                       <source>*</source>
                   </properties>
               </destination>
           </service>
       </services>
       <channels>
           <channel-definition id="zend-endpoint"
               class="mx.messaging.channels.AMFChannel">
               <endpoint uri="http://example.com/server.php"
                   class="flex.messaging.endpoints.AMFEndpoint"/>
           </channel-definition>
       </channels>
   </services-config>

There are two key points in the example. First, but last in the listing, we create an *AMF* channel, and specify
the endpoint as the *URL* to our ``ZendAmf\Server``:

.. code-block:: xml
   :linenos:

   <channel-definition id="zend-endpoint"
       <endpoint uri="http://example.com/server.php"
           class="flex.messaging.endpoints.AMFEndpoint"/>
   </channel-definition>

Notice that we've given this channel an identifier, "zend-endpoint". The example create a service destination that
refers to this channel, assigning it an ID as well -- in this case "zend".

Within our Flex *MXML* files, we need to bind a RemoteObject to the service. In *MXML*, this might be done as
follows:

.. code-block:: xml
   :linenos:

   <mx:RemoteObject id="myservice"
       fault="faultHandler(event)"
       showBusyCursor="true"
       destination="zend">

Here, we've defined a new remote object identified by "myservice" bound to the service destination "zend" we
defined in the ``services-config.xml`` file. We then call methods on it in our ActionScript by simply calling
"myservice.<method>". As an example:

.. code-block:: actionscript
   :linenos:

   myservice.hello("Wade");

When namespacing, you would use "myservice.<namespace>.<method>":

.. code-block:: actionscript
   :linenos:

   myservice.world.hello("Wade");

For more information on Flex RemoteObject invocation, `visit the Adobe Flex 3 Help site`_.

.. _zendamf.server.errors:

Error Handling
--------------

By default, all exceptions thrown in your attached classes or functions will be caught and returned as *AMF*
ErrorMessages. However, the content of these ErrorMessage objects will vary based on whether or not the server is
in "production" mode (the default state).

When in production mode, only the exception code will be returned. If you disable production mode -- something that
should be done for testing only -- most exception details will be returned: the exception message, line, and
backtrace will all be attached.

To disable production mode, do the following:

.. code-block:: php
   :linenos:

   $server->setProduction(false);

To re-enable it, pass a ``TRUE`` boolean value instead:

.. code-block:: php
   :linenos:

   $server->setProduction(true);

.. note::

   **Disable production mode sparingly!**

   We recommend disabling production mode only when in development. Exception messages and backtraces can contain
   sensitive system information that you may not wish for outside parties to access. Even though *AMF* is a binary
   format, the specification is now open, meaning anybody can potentially deserialize the payload.

One area to be especially careful with is *PHP* errors themselves. When the ``display_errors`` *INI* directive is
enabled, any *PHP* errors for the current error reporting level are rendered directly in the output -- potentially
disrupting the *AMF* response payload. We suggest turning off the ``display_errors`` directive in production to
prevent such problems

.. _zendamf.server.response:

AMF Responses
-------------

Occasionally you may desire to manipulate the response object slightly, typically to return extra message headers.
The ``handle()`` method of the server returns the response object, allowing you to do so.

.. _zendamf.server.response.messageHeaderExample:

.. rubric:: Adding Message Headers to the AMF Response

In this example, we add a 'foo' MessageHeader with the value 'bar' to the response prior to returning it.

.. code-block:: php
   :linenos:

   $response = $server->handle();
   $response->addAmfHeader(new ZendAmf\Value\MessageHeader('foo', true, 'bar'))
   echo $response;

.. _zendamf.server.typedobjects:

Typed Objects
-------------

Similar to *SOAP*, *AMF* allows passing objects between the client and server. This allows a great amount of
flexibility and coherence between the two environments.

``ZendAmf`` provides three methods for mapping ActionScript and *PHP* objects.

- First, you may create explicit bindings at the server level, using the ``setClassMap()`` method. The first
  argument is the ActionScript class name, the second the *PHP* class name it maps to:

  .. code-block:: php
     :linenos:

     // Map the ActionScript class 'ContactVO' to the PHP class 'Contact':
     $server->setClassMap('ContactVO', 'Contact');

- Second, you can set the public property ``$_explicitType`` in your *PHP* class, with the value representing the
  ActionScript class to map to:

  .. code-block:: php
     :linenos:

     class Contact
     {
         public $_explicitType = 'ContactVO';
     }

- Third, in a similar vein, you may define the public method ``getASClassName()`` in your *PHP* class; this method
  should return the appropriate ActionScript class:

  .. code-block:: php
     :linenos:

     class Contact
     {
         public function getASClassName()
         {
             return 'ContactVO';
         }
     }

Although we have created the ContactVO on the server we now need to make its corresponding class in *AS3* for the
server object to be mapped to.

Right click on the src folder of the Flex project and select New -> ActionScript File. Name the file ContactVO and
press finish to see the new file. Copy the following code into the file to finish creating the class.

.. code-block:: as
   :linenos:

   package
   {
       [Bindable]
       [RemoteClass(alias="ContactVO")]
       public class ContactVO
       {
           public var id:int;
           public var firstname:String;
           public var lastname:String;
           public var email:String;
           public var mobile:String;
           public function ProductVO():void {
           }
       }
   }

The class is syntactically equivalent to the *PHP* of the same name. The variable names are exactly the same and
need to be in the same case to work properly. There are two unique *AS3* meta tags in this class. The first is
bindable which makes fire a change event when it is updated. The second tag is the RemoteClass tag which defines
that this class can have a remote object mapped with the alias name in this case **ContactVO**. It is mandatory
that this tag the value that was set is the *PHP* class are strictly equivalent.

.. code-block:: as
   :linenos:

   [Bindable]
   private var myContact:ContactVO;

   private function getContactHandler(event:ResultEvent):void {
       myContact = ContactVO(event.result);
   }

The following result event from the service call is cast instantly onto the Flex ContactVO. Anything that is bound
to myContact will be updated with the returned ContactVO data.

.. _zendamf.server.resources:

Resources
---------

``ZendAmf`` provides tools for mapping resource types returned by service classes into data consumable by
ActionScript.

In order to handle specific resource type, the user needs to create a plugin class named after the resource name,
with words capitalized and spaces removed (so, resource type "mysql result" becomes MysqlResult), with some prefix,
e.g. ``My_MysqlResult``. This class should implement one method, ``parse()``, receiving one argument - the resource
- and returning the value that should be sent to ActionScript. The class should be located in the file named after
the last component of the name, e.g. ``MysqlResult.php``.

The directory containing the resource handling plugins should be registered with ``ZendAmf`` type loader:

.. code-block:: php
   :linenos:

   ZendAmf\Parse\TypeLoader::addResourceDirectory(
       "My",
       "application/library/resources/My"
   );

For detailed discussion of loading plugins, please see the :ref:`plugin loader <zend.loader.pluginloader>` section.

Default directory for ``ZendAmf`` resources is registered automatically and currently contains handlers for "mysql
result" and "stream" resources.

.. code-block:: php
   :linenos:

   // Example class implementing handling resources of type mysql result
   class ZendAmf\Parse\Resource\MysqlResult
   {
       /**
        * Parse resource into array
        *
        * @param resource $resource
        * @return array
        */
       public function parse($resource) {
           $result = array();
           while ($row = mysql_fetch_assoc($resource)) {
               $result[] = $row;
           }
           return $result;
       }
   }

Trying to return unknown resource type (i.e., one for which no handler plugin exists) will result in an exception.

.. _zendamf.server.flash:

Connecting to the Server from Flash
-----------------------------------

Connecting to your ``ZendAmf\Server`` from your Flash project is slightly different than from Flex. However once
the connection Flash functions with ``ZendAmf\Server`` the same way is flex. The following example can also be
used from a Flex *AS3* file. We will reuse the same ``ZendAmf\Server`` configuration along with the World class
for our connection.

Open Flash CS and create and new Flash File (ActionScript 3). Name the document ``ZendExample.fla`` and save the
document into a folder that you will use for this example. Create a new *AS3* file in the same directory and call
the file ``Main.as``. Have both files open in your editor. We are now going to connect the two files via the
document class. Select ZendExample and click on the stage. From the stage properties panel change the Document
class to Main. This links the ``Main.as`` ActionScript file with the user interface in ``ZendExample.fla``. When
you run the Flash file ZendExample the ``Main.as`` class will now be run. Next we will add ActionScript to make the
*AMF* call.

We now are going to make a Main class so that we can send the data to the server and display the result. Copy the
following code into your ``Main.as`` file and then we will walk through the code to describe what each element's
role is.

.. code-block:: as
   :linenos:

   package {
     import flash.display.MovieClip;
     import flash.events.*;
     import flash.net.NetConnection;
     import flash.net.Responder;

     public class Main extends MovieClip {
       private var gateway:String = "http://example.com/server.php";
       private var connection:NetConnection;
       private var responder:Responder;

       public function Main() {
         responder = new Responder(onResult, onFault);
         connection = new NetConnection;
         connection.connect(gateway);
       }

       public function onComplete( e:Event ):void{
         var params = "Sent to Server";
         connection.call("World.hello", responder, params);
       }

       private function onResult(result:Object):void {
         // Display the returned data
         trace(String(result));
       }
       private function onFault(fault:Object):void {
         trace(String(fault.description));
       }
     }
   }

We first need to import two ActionScript libraries that perform the bulk of the work. The first is NetConnection
which acts like a by directional pipe between the client and the server. The second is a Responder object which
handles the return values from the server related to the success or failure of the call.

.. code-block:: as
   :linenos:

   import flash.net.NetConnection;
   import flash.net.Responder;

In the class we need three variables to represent the NetConnection, Responder, and the gateway *URL* to our
``ZendAmf\Server`` installation.

.. code-block:: as
   :linenos:

   private var gateway:String = "http://example.com/server.php";
   private var connection:NetConnection;
   private var responder:Responder;

In the Main constructor we create a responder and a new connection to the ``ZendAmf\Server`` endpoint. The
responder defines two different methods for handling the response from the server. For simplicity I have called
these onResult and onFault.

.. code-block:: as
   :linenos:

   responder = new Responder(onResult, onFault);
   connection = new NetConnection;
   connection.connect(gateway);

In the onComplete function which is run as soon as the construct has completed we send the data to the server. We
need to add one more line that makes a call to the ``ZendAmf\Server`` World->hello function.

.. code-block:: as
   :linenos:

   connection.call("World.hello", responder, params);

When we created the responder variable we defined an onResult and onFault function to handle the response from the
server. We added this function for the successful result from the server. A successful event handler is run every
time the connection is handled properly to the server.

.. code-block:: as
   :linenos:

   private function onResult(result:Object):void {
       // Display the returned data
       trace(String(result));
   }

The onFault function, is called if there was an invalid response from the server. This happens when there is an
error on the server, the *URL* to the server is invalid, the remote service or method does not exist, and any other
connection related issues.

.. code-block:: as
   :linenos:

   private function onFault(fault:Object):void {
       trace(String(fault.description));
   }

Adding in the ActionScript to make the remoting connection is now complete. Running the ZendExample file now makes
a connection to ``ZendAmf``. In review you have added the required variables to open a connection to the remote
server, defined what methods should be used when your application receives a response from the server, and finally
displayed the returned data to output via ``trace()``.

.. _zendamf.server.auth:

Authentication
--------------

``ZendAmf\Server`` allows you to specify authentication and authorization hooks to control access to the services.
It is using the infrastructure provided by :ref:`Zend\Authentication <zend.authentication>` and :ref:`Zend\Permissions\Acl
<zend.permissions.acl>` components.

In order to define authentication, the user provides authentication adapter extending ``ZendAmf\Auth\Abstract``
abstract class. The adapter should implement the ``authenticate()`` method just like regular :ref:`authentication
adapter <zend.authentication.introduction.adapters>`.

The adapter should use properties **_username** and **_password** from the parent ``ZendAmf\Auth\Abstract`` class
in order to authenticate. These values are set by the server using ``setCredentials()`` method before call to
``authenticate()`` if the credentials are received in the *AMF* request headers.

The identity returned by the adapter should be an object containing property ``role`` for the *ACL* access control
to work.

If the authentication result is not successful, the request is not processed further and failure message is
returned with the reasons for failure taken from the result.

The adapter is connected to the server using ``setAuth()`` method:

.. code-block:: php
   :linenos:

   $server->setAuth(new My_Amf_Auth());

Access control is performed by using ``Zend\Permissions\Acl`` object set by ``setAcl()`` method:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   createPermissions($acl); // create permission structure
   $server->setAcl($acl);

If the *ACL* object is set, and the class being called defines ``initAcl()`` method, this method will be called
with the *ACL* object as an argument. The class then can create additional *ACL* rules and return ``TRUE``, or
return ``FALSE`` if no access control is required for this class.

After *ACL* have been set up, the server will check if access is allowed with role set by the authentication,
resource being the class name (or ``NULL`` for function calls) and privilege being the function name. If no
authentication was provided, then if the **anonymous** role was defined, it will be used, otherwise the access will
be denied.

.. code-block:: php
   :linenos:

   if ($this->_acl->isAllowed($role, $class, $function)) {
       return true;
   } else {
       throw new ZendAmf\Server\Exception("Access not allowed");
   }



.. _`visit the Adobe Flex 3 Help site`: http://livedocs.adobe.com/flex/3/html/help.html?content=data_access_4.html
