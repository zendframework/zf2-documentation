.. EN-Revision: none
.. _zend.auth.adapter.openid:

Autenticación con Open ID
=========================

.. _zend.auth.adapter.openid.introduction:

Introducción
------------

El adaptador ``Zend\Auth_Adapter\OpenId`` se puede usar para autentificar usuarios usando un servidor remoto de
OpenID. Este método de autenticación supone que el usuario sólo envia su OpenID a la aplicacion web, luego se
redirecciona (envia) a su proveedor de OpenID para su verificacion mediante su contraseña o algún otro metodo.
Esta contraseña no se le proporciona a la aplicacion web.

El OpenID solo es un *URI* que apunta a un sitio con información del usuari, así como información especiales que
describe que servidor usar y que información (identidad) se debe enviar. Puedes leer más información acerca de
OpenID en el `sitio oficial de OpenId`_.

La clase ``Zend\Auth_Adapter\OpenId`` encapsula al componente ``ZendOpenId\Consumer``, el cual implementa el
protocolo de autentificación OpenID.

.. note::

   ``ZendOpenId`` aprovecha las `GMP extension`_, cuando estén disponibles. Considere la posibilidad de usar
   *GMP* extension para un mejor rendimiento cuando use ``Zend\Auth_Adapter\OpenId``.

.. _zend.auth.adapter.openid.specifics:

Características
---------------

Como es el caso de todos los adaptadores ``Zend_Auth``, la clase ``Zend\Auth_Adapter\OpenId`` implementa
``Zend\Auth_Adapter\Interface``, el cual define un metodo ``authenticate()``. Este método realiza la
autenticación en sí, pero el objeto debe estar configurado antes de ser llamado. La configuracion del adaptador
requiere la creacion de un OpenID y otras opciones de ``ZendOpenId`` específicos.

Sin embargo, a diferencia de otros adaptadores de ``Zend_Auth``, ``Zend\Auth_Adapter\OpenId`` realiza la
autenticación en un servidor externo en dos peticiones *HTTP* separadas. Así que el método
``Zend\Auth_Adapter\OpenId::authenticate()`` debe ser llamado dos veces. En la primera invocación del método no
regresará nada, sino que redirige al usuario a su servidor de OpenID. Luego, después de que el usuario se
autentica en el servidor remoto, este te regresará desde donde lo invocaste (a tu código) y deberás invocar a
``Zend\Auth_Adapter\OpenId::authenticate()`` de nuevo para verificar la firma que acompaña a la petición de
re-direccionamiento del servidor para completar el proceso de autenticación . En esta segunda invocación, el
método devolverá el objeto ``Zend\Auth\Result`` como se esperaba.

El siguiente ejemplo muestra el uso de ``Zend\Auth_Adapter\OpenId``. Como se mencionó anteriormente,
``Zend\Auth_Adapter\OpenId::autenticar()`` debe ser llamada dos veces. La primera vez es cuando el usuario envía
el formulario *HTML* con el ``$_POST['openid_action']`` en **"Login"**, y la segunda es posterior a la redirección
*HTTP* del servidor OpenID con ``$_GET['openid_mode']`` o ``$_POST['openid_mode']``.

.. code-block:: php
   :linenos:

   <?php
   $status = "";
   $auth = Zend\Auth\Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode']) ||
       isset($_POST['openid_mode'])) {
       $result = $auth->authenticate(
           new Zend\Auth_Adapter\OpenId(@$_POST['openid_identifier']));
       if ($result->isValid()) {
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
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
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
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


Puede personalizar el proceso de autenticación OpenID de varias formas. Por ejemplo, recibir la redirección del
servidor de OpenID en una página aparte, especificando la "raíz" del sitio web y utilizar un
``ZendOpenId_Consumer\Storage`` o un ``Zend\Controller\Response``. Usted también puede utilizar el simple
registro de extensiones para recuperar información sobre el usuario desde el servidor de OpenID. Todas estas
posibilidades se describen con más detalle en el capítulo ``ZendOpenId\Consume``.



.. _`sitio oficial de OpenId`: http://www.openid.net/
.. _`GMP extension`: http://php.net/gmp
