.. EN-Revision: none
.. _zend.authentication.adapter.digest:

Autenticación "Digest"
======================

.. _zend.authentication.adapter.digest.introduction:

Introducción
------------

La `Autenticación "Digest"`_ es un método de la autenticación *HTTP* que mejora la `Autenticación Básica`_
proporcionando una manera de autenticar sin tener que transmitir la contraseña de manera clara a través de la
red.

Este adaptador permite la autentificación contra archivos de texto que contengan líneas que tengan los elementos
básicos de la autenticación "Digest":

- username, tal como "**joe.user**"

- realm, tal como "**Administrative Area**"

- Hash *MD5* del username, realm y password, separados por dos puntos

Los elementos anteriores están separados por dos puntos, como en el ejemplo siguiente (en el que la contraseña es
"**somePassword**"):

.. code-block:: text
   :linenos:

   someUser:Some Realm:fde17b91c3a510ecbaf7dbd37f59d4f8

.. _zend.authentication.adapter.digest.specifics:

Detalles Específicos
--------------------

El adaptador de autenticación "Digest", ``Zend_Auth_Adapter_Digest``, requiere varios parámetros de entrada:

- filename - Nombre del archivo contra el que se realiza la autenticación de las consultas

- realm - Domino de la autenticación "Digest"

- username - Usuario de la autenticación "Digest"

- password - Contraseña para el usuario del dominio

Estos parámetros deben ser establecidos antes de llamar a ``authenticate()``.

.. _zend.authentication.adapter.digest.identity:

Identidad
---------

El adaptador de autenticación "Digest" devuelve un objeto ``Zend_Auth_Result``, que ha sido rellenado con la
identidad como un array que tenga claves **realm** y **username**. Los respectivos valores del array asociados con
esas claves correspondes con los valores fijados andes de llamar a ``authenticate()``.

.. code-block:: php
   :linenos:

   $adapter = new Zend_Auth_Adapter_Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Some Realm
       [username] => someUser
   )
   */



.. _`Autenticación "Digest"`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`Autenticación Básica`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
