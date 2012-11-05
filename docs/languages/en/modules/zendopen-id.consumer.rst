.. _zendopenid.consumer:

ZendOpenId\Consumer Basics
===========================

``ZendOpenId\Consumer`` can be used to implement OpenID authentication for web sites.

.. _zendopenid.consumer.authentication:

OpenID Authentication
---------------------

From a web site developer's point of view, the OpenID authentication process consists of three steps:

. Show OpenID authentication form

. Accept OpenID identity and pass it to the OpenID provider

. Verify response from the OpenID provider

The OpenID authentication protocol actually requires more steps, but many of them are encapsulated inside
``ZendOpenId\Consumer`` and are therefore transparent to the developer.

The end user initiates the OpenID authentication process by submitting his or her identification credentials with
the appropriate form. The following example shows a simple form that accepts an OpenID identifier. Note that the
example only demonstrates a login.

.. _zendopenid.consumer.example-1:

.. rubric:: The Simple OpenID Login form

.. code-block:: php
   :linenos:

   <html><body>
   <form method="post" action="example-1_2.php"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier">
   <input type="submit" name="openid_action" value="login">
   </fieldset></form></body></html>

This form passes the OpenID identity on submission to the following *PHP* script that performs the second step of
authentication. The *PHP* script need only call the ``ZendOpenId\Consumer::login()`` method in this step. The
first argument of this method is an accepted OpenID identity, and the second is the *URL* of a script that handles
the third and last step of authentication.

.. _zendopenid.consumer.example-1_2:

.. rubric:: The Authentication Request Handler

.. code-block:: php
   :linenos:

   $consumer = new ZendOpenId\Consumer();
   if (!$consumer->login($_POST['openid_identifier'], 'example-1_3.php')) {
       die("OpenID login failed.");
   }

The ``ZendOpenId\Consumer::login()`` method performs discovery on a given identifier, and, if successful, obtains
the address of the identity provider and its local identifier. It then creates an association to the given provider
so that both the site and provider share a secret that is used to sign the subsequent messages. Finally, it passes
an authentication request to the provider. This request redirects the end user's web browser to an OpenID server
site, where the user can continue the authentication process.

An OpenID provider usually asks users for their password (if they weren't previously logged-in), whether the user
trusts this site and what information may be returned to the site. These interactions are not visible to the OpenID
consumer, so it can not obtain the user's password or other information that the user did not has not directed the
OpenID provider to share with it.

On success, ``ZendOpenId\Consumer::login()`` does not return, instead performing an *HTTP* redirection. However,
if there is an error it may return ``FALSE``. Errors may occur due to an invalid identity, unresponsive provider,
communication error, etc.

The third step of authentication is initiated by the response from the OpenID provider, after it has authenticated
the user's password. This response is passed indirectly, as an *HTTP* redirection using the end user's web browser.
The consumer must now simply check that this response is valid.

.. _zendopenid.consumer.example-1_3:

.. rubric:: The Authentication Response Verifier

.. code-block:: php
   :linenos:

   $consumer = new ZendOpenId\Consumer();
   if ($consumer->verify($_GET, $id)) {
       echo "VALID " . htmlspecialchars($id);
   } else {
       echo "INVALID " . htmlspecialchars($id);
   }

This check is performed using the ``ZendOpenId\Consumer::verify`` method, which takes an array of the *HTTP*
request's arguments and checks that this response is properly signed by the OpenID provider. It may assign the
claimed OpenID identity that was entered by end user in the first step using a second, optional argument.

.. _zendopenid.consumer.combine:

Combining all Steps in One Page
-------------------------------

The following example combines all three steps in one script. It doesn't provide any new functionality. The
advantage of using just one script is that the developer need not specify *URL*'s for a script to handle the next
step. By default, all steps use the same *URL*. However, the script now includes some dispatch code to execute the
appropriate code for each step of authentication.

.. _zendopenid.consumer.example-2:

.. rubric:: The Complete OpenID Login Script

.. code-block:: php
   :linenos:

   <?php
   $status = "";
   if (isset($_POST['openid_action']) &&
       $_POST['openid_action'] == "login" &&
       !empty($_POST['openid_identifier'])) {

       $consumer = new ZendOpenId\Consumer();
       if (!$consumer->login($_POST['openid_identifier'])) {
           $status = "OpenID login failed.";
       }
   } else if (isset($_GET['openid_mode'])) {
       if ($_GET['openid_mode'] == "id_res") {
           $consumer = new ZendOpenId\Consumer();
           if ($consumer->verify($_GET, $id)) {
               $status = "VALID " . htmlspecialchars($id);
           } else {
               $status = "INVALID " . htmlspecialchars($id);
           }
       } else if ($_GET['openid_mode'] == "cancel") {
           $status = "CANCELLED";
       }
   }
   ?>
   <html><body>
   <?php echo "$status<br>" ?>
   <form method="post">
   <fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value=""/>
   <input type="submit" name="openid_action" value="login"/>
   </fieldset>
   </form>
   </body></html>

In addition, this code differentiates between cancelled and invalid authentication responses. The provider returns
a cancelled response if the identity provider is not aware of the supplied identity, the user is not logged in, or
the user doesn't trust the site. An invalid response indicates that the response is not conformant to the OpenID
protocol or is incorrectly signed.

.. _zendopenid.consumer.realm:

Consumer Realm
--------------

When an OpenID-enabled site passes authentication requests to a provider, it identifies itself with a realm *URL*.
This *URL* may be considered a root of a trusted site. If the user trusts the realm *URL*, he or she should also
trust matched and subsequent *URL*\ s.

By default, the realm *URL* is automatically set to the *URL* of the directory in which the login script resides.
This default value is useful for most, but not all, cases. Sometimes an entire domain, and not a directory should
be trusted. Or even a combination of several servers in one domain.

To override the default value, developers may pass the realm *URL* as a third argument to the
``ZendOpenId\Consumer::login`` method. In the following example, a single interaction asks for trusted access to
all php.net sites.

.. _zendopenid.consumer.example-3_2:

.. rubric:: Authentication Request for Specified Realm

.. code-block:: php
   :linenos:

   $consumer = new ZendOpenId\Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-3_3.php',
                         'http://*.php.net/')) {
       die("OpenID login failed.");
   }

This example implements only the second step of authentication; the first and third steps are similar to the
examples above.

.. _zendopenid.consumer.check:

Immediate Check
---------------

In some cases, an application need only check if a user is already logged in to a trusted OpenID server without any
interaction with the user. The ``ZendOpenId\Consumer::check`` method does precisely that. It is executed with the
same arguments as ``ZendOpenId\Consumer::login``, but it doesn't display any OpenID server pages to the user. From
the users point of view this process is transparent, and it appears as though they never left the site. The third
step succeeds if the user is already logged in and trusted by the site, otherwise it will fail.

.. _zendopenid.consumer.example-4:

.. rubric:: Immediate Check without Interaction

.. code-block:: php
   :linenos:

   $consumer = new ZendOpenId\Consumer();
   if (!$consumer->check($_POST['openid_identifier'], 'example-4_3.php')) {
       die("OpenID login failed.");
   }

This example implements only the second step of authentication; the first and third steps are similar to the
examples above.

.. _zendopenid.consumer.storage:

ZendOpenId\Consumer\Storage
----------------------------

There are three steps in the OpenID authentication procedure, and each step is performed by a separate *HTTP*
request. To store information between requests, ``ZendOpenId\Consumer`` uses internal storage.

Developers do not necessarily have to be aware of this storage because by default ``ZendOpenId\Consumer`` uses
file-based storage under the temporary directory- similar to *PHP* sessions. However, this storage may be not
suitable in all cases. Some developers may want to store information in a database, while others may need to use
common storage suitable for server farms. Fortunately, developers may easily replace the default storage with their
own. To specify a custom storage mechanism, one need only extend the ``ZendOpenId\Consumer\Storage`` class and
pass this subclass to the ``ZendOpenId\Consumer`` constructor in the first argument.

The following example demonstrates a simple storage mechanism that uses ``Zend\Db`` as its backend and exposes
three groups of functions. The first group contains functions for working with associations, while the second group
caches discovery information, and the third group can be used to check whether a response is unique. This class can
easily be used with existing or new databases; if the required tables don't exist, it will create them.

.. _zendopenid.consumer.example-5:

.. rubric:: Database Storage

.. code-block:: php
   :linenos:

   class DbStorage extends ZendOpenId\Consumer\Storage
   {
       private $_db;
       private $_association_table;
       private $_discovery_table;
       private $_nonce_table;

       // Pass in the Zend\Db\Adapter object and the names of the
       // required tables
       public function __construct($db,
                                   $association_table = "association",
                                   $discovery_table = "discovery",
                                   $nonce_table = "nonce")
       {
           $this->_db = $db;
           $this->_association_table = $association_table;
           $this->_discovery_table = $discovery_table;
           $this->_nonce_table = $nonce_table;
           $tables = $this->_db->listTables();

           // If the associations table doesn't exist, create it
           if (!in_array($association_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $association_table (" .
                   " url     varchar(256) not null primary key," .
                   " handle  varchar(256) not null," .
                   " macFunc char(16) not null," .
                   " secret  varchar(256) not null," .
                   " expires timestamp" .
                   ")");
           }

           // If the discovery table doesn't exist, create it
           if (!in_array($discovery_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $discovery_table (" .
                   " id      varchar(256) not null primary key," .
                   " realId  varchar(256) not null," .
                   " server  varchar(256) not null," .
                   " version float," .
                   " expires timestamp" .
                   ")");
           }

           // If the nonce table doesn't exist, create it
           if (!in_array($nonce_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $nonce_table (" .
                   " nonce   varchar(256) not null primary key," .
                   " created timestamp default current_timestamp" .
                   ")");
           }
       }

       public function addAssociation($url,
                                      $handle,
                                      $macFunc,
                                      $secret,
                                      $expires)
       {
           $table = $this->_association_table;
           $secret = base64_encode($secret);
           $this->_db->insert($table, array(
               'url'     => $url,
               'handle'  => $handle,
               'macFunc' => $macFunc,
               'secret'  => $secret,
               'expires' => $expires,
           ));
           return true;
       }

       public function getAssociation($url,
                                      &$handle,
                                      &$macFunc,
                                      &$secret,
                                      &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ?', time())
           );
           $select = $this-_db->select()
                   ->from($table, array('handle', 'macFunc', 'secret', 'expires'))
                   ->where('url = ?', $url);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $handle  = $res['handle'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function getAssociationByHandle($handle,
                                              &$url,
                                              &$macFunc,
                                              &$secret,
                                              &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ', time())
           );
           $select = $this->_db->select()
                   ->from($table, array('url', 'macFunc', 'secret', 'expires')
                   ->where('handle = ?', $handle);
           $res = $select->fetchRow($select);

           if (is_array($res)) {
               $url     = $res['url'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delAssociation($url)
       {
           $table = $this->_association_table;
           $this->_db->query("delete from $table where url = '$url'");
           return true;
       }

       public function addDiscoveryInfo($id,
                                        $realId,
                                        $server,
                                        $version,
                                        $expires)
       {
           $table = $this->_discovery_table;
           $this->_db->insert($table, array(
               'id'      => $id,
               'realId'  => $realId,
               'server'  => $server,
               'version' => $version,
               'expires' => $expires,
           ));

           return true;
       }

       public function getDiscoveryInfo($id,
                                        &$realId,
                                        &$server,
                                        &$version,
                                        &$expires)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->quoteInto('expires < ?', time()));
           $select = $this->_db->select()
                   ->from($table, array('realId', 'server', 'version', 'expires'))
                   ->where('id = ?', $id);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $realId  = $res['realId'];
               $server  = $res['server'];
               $version = $res['version'];
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delDiscoveryInfo($id)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->_db->quoteInto('id = ?', $id));
           return true;
       }

       public function isUniqueNonce($nonce)
       {
           $table = $this->_nonce_table;
           try {
               $ret = $this->_db->insert($table, array(
                   'nonce' => $nonce,
               ));
           } catch (Zend\Db\Statement\Exception $e) {
               return false;
           }
           return true;
       }

       public function purgeNonces($date=null)
       {
       }
   }

   $db = Zend\Db\Db::factory('Pdo_Sqlite',
       array('dbname'=>'/tmp/openid_consumer.db'));
   $storage = new DbStorage($db);
   $consumer = new ZendOpenId\Consumer($storage);

This example doesn't list the OpenID authentication code itself, but this code would be the same as that for other
examples in this chapter. examples.

.. _zendopenid.consumer.sreg:

Simple Registration Extension
-----------------------------

In addition to authentication, the OpenID standard can be used for lightweight profile exchange to make information
about a user portable across multiple sites. This feature is not covered by the OpenID authentication
specification, but by the OpenID Simple Registration Extension protocol. This protocol allows OpenID-enabled sites
to ask for information about end users from OpenID providers. Such information may include:

- **nickname**- any UTF-8 string that the end user uses as a nickname

- **email**- the email address of the user as specified in section 3.4.1 of RFC2822

- **fullname**- a UTF-8 string representation of the user's full name

- **dob**- the user's date of birth in the format 'YYYY-MM-DD'. Any values whose representation uses fewer than the
  specified number of digits in this format should be zero-padded. In other words, the length of this value must
  always be 10. If the end user does not want to reveal any particular part of this value (i.e., year, month or
  day), it must be set to zero. For example, if the user wants to specify that his date of birth falls in 1980, but
  not specify the month or day, the value returned should be '1980-00-00'.

- **gender**- the user's gender: "M" for male, "F" for female

- **postcode**- a UTF-8 string that conforms to the postal system of the user's country

- **country**- the user's country of residence as specified by ISO3166

- **language**- the user's preferred language as specified by ISO639

- **timezone**- an *ASCII* string from a TimeZone database. For example, "Europe/Paris" or "America/Los_Angeles".

An OpenID-enabled web site may ask for any combination of these fields. It may also strictly require some
information and allow users to provide or hide additional information. The following example instantiates the
``ZendOpenId\Extension\Sreg`` class, requiring a **nickname** and optionally requests an **email** and a
**fullname**.

.. _zendopenid.consumer.example-6_2:

.. rubric:: Sending Requests with a Simple Registration Extension

.. code-block:: php
   :linenos:

   $sreg = new ZendOpenId\Extension\Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new ZendOpenId\Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-6_3.php',
                         null,
                         $sreg)) {
       die("OpenID login failed.");
   }

As you can see, the ``ZendOpenId\Extension\Sreg`` constructor accepts an array of OpenID fields. This array has
the names of fields as indexes to a flag indicating whether the field is required; ``TRUE`` means the field is
required and ``FALSE`` means the field is optional. The ``ZendOpenId\Consumer::login`` method accepts an extension
or an array of extensions as its fourth argument.

On the third step of authentication, the ``ZendOpenId\Extension\Sreg`` object should be passed to
``ZendOpenId\Consumer::verify``. Then on successful authentication the
``ZendOpenId\Extension\Sreg::getProperties`` method will return an associative array of requested fields.

.. _zendopenid.consumer.example-6_3:

.. rubric:: Verifying Responses with a Simple Registration Extension

.. code-block:: php
   :linenos:

   $sreg = new ZendOpenId\Extension\Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new ZendOpenId\Consumer();
   if ($consumer->verify($_GET, $id, $sreg)) {
       echo "VALID " . htmlspecialchars($id) ."<br>\n";
       $data = $sreg->getProperties();
       if (isset($data['nickname'])) {
           echo "nickname: " . htmlspecialchars($data['nickname']) . "<br>\n";
       }
       if (isset($data['email'])) {
           echo "email: " . htmlspecialchars($data['email']) . "<br>\n";
       }
       if (isset($data['fullname'])) {
           echo "fullname: " . htmlspecialchars($data['fullname']) . "<br>\n";
       }
   } else {
       echo "INVALID " . htmlspecialchars($id);
   }

If the ``ZendOpenId\Extension\Sreg`` object was created without any arguments, the user code should check for the
existence of the required data itself. However, if the object is created with the same list of required fields as
on the second step, it will automatically check for the existence of required data. In this case,
``ZendOpenId\Consumer::verify`` will return ``FALSE`` if any of the required fields are missing.

``ZendOpenId\Extension\Sreg`` uses version 1.0 by default, because the specification for version 1.1 is not yet
finalized. However, some libraries don't fully support version 1.0. For example, www.myopenid.com requires an SREG
namespace in requests which is only available in 1.1. To work with such a server, you must explicitly set the
version to 1.1 in the ``ZendOpenId\Extension\Sreg`` constructor.

The second argument of the ``ZendOpenId\Extension\Sreg`` constructor is a policy *URL*, that should be provided to
the user by the identity provider.

.. _zendopenid.consumer.auth:

Integration with Zend\Auth
--------------------------

Zend Framework provides a special class to support user authentication: ``Zend\Auth``. This class can be used
together with ``ZendOpenId\Consumer``. The following example shows how ``OpenIdAdapter`` implements the
``Zend\Auth\Adapter\Interface`` with the ``authenticate()`` method. This performs an authentication query and
verification.

The big difference between this adapter and existing ones, is that it works on two *HTTP* requests and includes a
dispatch code to perform the second or third step of OpenID authentication.

.. _zendopenid.consumer.example-7:

.. rubric:: Zend\Auth Adapter for OpenID

.. code-block:: php
   :linenos:

   <?php
   class OpenIdAdapter implements Zend\Auth\Adapter\Interface {
       private $_id = null;

       public function __construct($id = null) {
           $this->_id = $id;
       }

       public function authenticate() {
           $id = $this->_id;
           if (!empty($id)) {
               $consumer = new ZendOpenId\Consumer();
               if (!$consumer->login($id)) {
                   $ret = false;
                   $msg = "Authentication failed.";
               }
           } else {
               $consumer = new ZendOpenId\Consumer();
               if ($consumer->verify($_GET, $id)) {
                   $ret = true;
                   $msg = "Authentication successful";
               } else {
                   $ret = false;
                   $msg = "Authentication failed";
               }
           }
           return new Zend\Auth\Result($ret, $id, array($msg));
       }
   }

   $status = "";
   $auth = Zend\Auth\Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode'])) {
       $adapter = new OpenIdAdapter(@$_POST['openid_identifier']);
       $result = $auth->authenticate($adapter);
       if ($result->isValid()) {
           ZendOpenId\OpenId::redirect(ZendOpenId\OpenId::selfURL());
       } else {
           $auth->clearIdentity();
           foreach ($result->getMessages() as $message) {
               $status .= "$message<br>\n";
           }
       }
   } else if ($auth->hasIdentity()) {
       if (isset($_POST['openid_action']) &&
           $_POST['openid_action'] == "logout") {
           $auth->clearIdentity();
       } else {
           $status = "You are logged in as " . $auth->getIdentity() . "<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>

With ``Zend\Auth`` the end-user's identity is saved in the session's data. It may be checked with
``Zend\Auth\Auth::hasIdentity`` and ``Zend\Auth\Auth::getIdentity``.

.. _zendopenid.consumer.mvc:

Integration with Zend\Controller
--------------------------------

Finally a couple of words about integration into Model-View-Controller applications: such Zend Framework
applications are implemented using the ``Zend\Controller`` class and they use objects of the
``Zend\Controller\Response\Http`` class to prepare *HTTP* responses and send them back to the user's web browser.

``ZendOpenId\Consumer`` doesn't provide any GUI capabilities but it performs *HTTP* redirections on success of
``ZendOpenId\Consumer::login`` and ``ZendOpenId\Consumer::check``. These redirections may work incorrectly or not
at all if some data was already sent to the web browser. To properly perform *HTTP* redirection in *MVC* code the
real ``Zend\Controller\Response\Http`` should be sent to ``ZendOpenId\Consumer::login`` or
``ZendOpenId\Consumer::check`` as the last argument.


