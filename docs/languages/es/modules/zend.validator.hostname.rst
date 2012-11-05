.. EN-Revision: none
.. _zend.validator.set.hostname:

Hostname (Nombre de Host)
=========================

``Zend\Validate\Hostname`` le permite validar un nombre de host contra una serie de especificaciones conocidas. Es
posible comprobar por tres diferentes tipos de nombres: el DNS Hostname (domain.com por ejemplo), dirección IP (es
decir 1.2.3.4), y nombres de host locales (localhost, por ejemplo). Por defecto sólo se comprobarán nombres de
host DNS.

**Uso básico**

El siguiente es un ejemplo de uso básico:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname();
      if ($validator->isValid($hostname)) {
          // hostname parece ser válido
      } else {
          // hostname es inválido; muestre las razones
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }

Comprobará el nombre de host ``$hostname`` y si fracasa alimentará a ``getMessages()`` con mensajes de error.

**Validar diferentes tipos de nombres de host**

También se puede encontrar coincidencias de direcciones IP, nombres de host locales, o una combinación de todos
los tipos permitidos. Esto puede hacerse pasando un parámetro a ``Zend\Validate\Hostname`` cuando lo instancia. El
parámetro debe ser un entero que determina qué tipos de nombres de host están permitidos. Se recomienda el uso
de las constantes de ``Zend\Validate\Hostname`` para hacerlo.

Las constantes de ``Zend\Validate\Hostname`` son: ``ALLOW_DNS`` para permitir sólo nombres de host DNS,
``ALLOW_IP`` para permitir direcciones IP, ``ALLOW_LOCAL`` para permitir nombres de host de la red local, y
``ALLOW_ALL`` para permitir todos estos tres tipos. Para comprobar que direcciones IP puede utilizar, vea el
siguiente ejemplo:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_IP);
      if ($validator->isValid($hostname)) {
          // hostname parece ser válido
      } else {
          // hostname es inválido; muestre las razones
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }



Usando ``ALLOW_ALL`` para aceptar todos los tipos de nombres de host, también puede combinar estos tipos para
realizar combinaciones. Por ejemplo, para aceptar nombres de host DNS y locales, instancie el objeto
``Zend\Validate\Hostname`` como:

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS |
                                              Zend\Validate\Hostname::ALLOW_IP);



**Validación de Nombres de Dominio Internacionales**

Algunos (ccTLD), es decir países "Country Code Top Level Domains" , como 'de' (Alemania), aceptan caracteres
internacionales como nombres de dominio. Estos son conocidos como Nombres de Dominio Internacionales (IDN, por sus
siglas en inglés). Se puede buscar una coincidencia de estos dominios con ``Zend\Validate\Hostname``, a través de
caracteres extendidos que se utilizan en el proceso de validación.

Until now more than 50 ccTLDs support IDN domains.

Cotejar dominios IDN es tan simple como usar el validador estándar Hostname, ya que este viene habilitado por
defecto. Si desea desactivar la validación IDN, se puede hacer ya sea pasando un parámetro al constructor
``Zend\Validate\Hostname`` o a través del método ``setValidateIdn()``.

Puede deshabilitar la validación IDN, pasando un segundo parámetro al constructor Zend\Validate\Hostname de la
siguiente manera.

.. code-block:: php
   :linenos:

   $validator =
       new Zend\Validate\Hostname(
           array(
               'allow' => Zend\Validate\Hostname::ALLOW_DNS,
               'idn'   => false
           )
       );

Alternativamente puede pasar ``TRUE`` o ``FALSE`` a ``setValidateIdn()`` para activar o desactivar la validación
IDN. Si está tratando de cotejar un nombre de host IDN que actualmente no está soportado, es probable que falle
la validación si tiene caracteres internacionales en el nombre de host. Cuando un archivo ccTLD no existe en
Zend/Validate/Hostname, especificando los caracteres adicionales se puede realizar una validación normal.

Tenga en cuenta que una validación IDN solo se realizará si tiene habilidada la validación para nombres de host
DNS.

**Validacuión de dominios de nivel superior**

Por defecto un nombre de host se cotejará con una lista de TLDs conocidos. Si esta funcionalidad no es necesaria,
puede ser desactivada en la misma forma que deshabilita el soporte IDN. Puede deshabilitar la validación TLD
pasando un tercer parámetro al constructor Zend\Validate\Hostname. En el siguiente ejemplo estamos dando respaldo
a la validación IDN a través del segundo parámetro.

.. code-block:: php
   :linenos:

   $validator =
       new Zend\Validate\Hostname(
           array(
               'allow' => Zend\Validate\Hostname::ALLOW_DNS,
               'idn'   => true,
               'tld'   => false
           )
       );

Alternativamente puede pasar ``TRUE`` o ``FALSE`` a ``setValidateTld()`` para activar o desactivar la validación
TLD.

Tenga en cuenta que una validación de TLDs solo se realizará si tiene habilidada la validación para nombres de
host DNS.


