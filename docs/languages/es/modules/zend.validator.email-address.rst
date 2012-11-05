.. EN-Revision: none
.. _zend.validator.set.email_address:

Dirección de Email
==================

``Zend\Validate\EmailAddress`` Le permite validar una dirección de email. El validador primero divide la
dirección de email en la parte local @ nombre de host e intenta igualar a estos contra especificaciones conocidas
para direcciones y nombres de host para el correo electrónico.

.. _zend.validator.set.email_address.basic:

Utilización básica
------------------

Un ejemplo básico de uso se ve a continuación:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   if ($validator->isValid($email)) {
       // El email parece ser válido
   } else {
       // El email es inválido; muestre las razones
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Esto coincide con el correo electrónico ``$email`` y si fracasa, alimenta *$validator->getMessages()* con mensajes
de error útiles.

.. _zend.validator.set.email_address.options:

>Partes locales complejas
-------------------------

``Zend\Validate\EmailAddress`` supports several options which can either be set at initiation, by giving an array
with the related options, or afterwards, by using ``setOptions()``. The following options are supported:

- **allow**: Defines which type of domain names are accepted. This option is used in conjunction with the hostname
  option to set the hostname validator. For more informations about possible values of this option, look at
  :ref:`Hostname <zend.validator.set.hostname>` and possible ``ALLOW`` * constants. This option defaults to
  ``ALLOW_DNS``.

- **hostname**: Sets the hostname validator with which the domain part of the email address will be validated.

- **mx**: Defines if the MX records from the server should be detected. If this option is defined to ``TRUE`` then
  the MX records are used to verify if the server accepts emails. This option defaults to ``FALSE``.

- **deep**: Defines if the servers MX records should be verified by a deep check. When this option is set to
  ``TRUE`` then additionally to MX records also the A, A6 and ``AAAA`` records are used to verify if the server
  accepts emails. This option defaults to ``FALSE``.

- **domain**: Defines if the domain part should be checked. When this option is set to ``FALSE``, then only the
  local part of the email address will be checked. In this case the hostname validator will not be called. This
  option defaults to ``TRUE``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setOptions(array('domain' => false));

.. _zend.validator.set.email_address.complexlocal:

Complex local parts
-------------------

``Zend\Validate\EmailAddress`` se comparará con cualquier dirección de correo válida de acuardo a RFC2822. Por
ejemplo, correos electrónicos válidos incluyen *bob@domain.com*, *bob+jones@domain.us*, *"bob@jones"@domain.com*
y *"bob jones"@domain.com*

Algunos formatos obsoletos de email actualmente no validan (por ejemplo los retornos de carro o "\\" un caracter en
una dirección de correo electrónico).

.. _zend.validator.set.email_address.purelocal:

Validating only the local part
------------------------------

If you need ``Zend\Validate\EmailAddress`` to check only the local part of an email address, and want to disable
validation of the hostname, you can set the ``domain`` option to ``FALSE``. This forces
``Zend\Validate\EmailAddress`` not to validate the hostname part of the email address.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setOptions(array('domain' => FALSE));

.. _zend.validator.set.email_address.hostnametype:

Validating different types of hostnames
---------------------------------------

La parte nombre de host de una dirección de correo es validado contra :ref:`Zend\Validate\Hostname
<zend.validator.set.hostname>`. Por defecto sólo son aceptados nombres de host DNS de la forma ``domain.com``,
aunque si lo desea también puede aceptar direcciones IP y nombres de host locales.

Para ello necesita instanciar a ``Zend\Validate\EmailAddress`` pasando un parámetro para indicar el tipo de
nombres de host que quiere aceptar. Más detalles están incluidos en ``Zend\Validate\EmailAddress``, aunque abajo
hay un ejemplo de cómo aceptar tanto nombres de host DNS y locales:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
                       Zend\Validate\Hostname::ALLOW_DNS |
                       Zend\Validate\Hostname::ALLOW_LOCAL);
   if ($validator->isValid($email)) {
       // email parece ser válido
   } else {
       // email es inválido; muestre las razones
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

.. _zend.validator.set.email_address.checkacceptance:

Verificar si el nombre de host realmente acepta email
-----------------------------------------------------

Sólo porque una dirección de correo electrónico está en el formato correcto, no necesariamente significa que
esa dirección de correo electrónico existe realmente. Para ayudar a resolver este problema, puede usar la
validación MX para comprobar si existe una entrada MX (email) en el registro DNS para correo electrónico en ese
nombre de host. Esto le dice que el nombre de host acepta email, pero no le dice si la dirección de correo
electrónico exacta es válida en si misma.

La comprobación MX no está activada por defecto y en este momento es soportada sólo por plataformas UNIX. Para
habilitar el control MX puede pasar un segundo parámetro al constructor ``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
       array(
           'allow' => Zend\Validate\Hostname::ALLOW_DNS,
           'mx'    => true
       )
   );

.. note::

   **MX Check under Windows**

   Within Windows environments MX checking is only available when *PHP* 5.3 or above is used. Below *PHP* 5.3 MX
   checking will not be used even if it's activated within the options.

Alternativamente, para activar o desactivar la validación MX puede pasar ``TRUE`` o ``FALSE`` a
``$validator->setValidateMx()``.

Al habilitarlo, se usarán las funciones de red para comprobar la presencia de un registro MX en el nombre de host
de la dirección de correo electrónico que desea validar. Tenga en cuenta esto probablemente hará más lento su
script.

Sometimes validation for MX records returns false, even if emails are accepted. The reason behind this behaviour
is, that servers can accept emails even if they do not provide a MX record. In this case they can provide A, A6 or
``AAAA`` records. To allow ``Zend\Validate\EmailAddress`` to check also for these other records, you need to set
deep MX validation. This can be done at initiation by setting the ``deep`` option or by using ``setOptions()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
       array(
           'allow' => Zend\Validate\Hostname::ALLOW_DNS,
           'mx'    => true,
           'deep'  => true
       )
   );

.. warning::

   **Performance warning**

   You should be aware that enabling MX check will slow down you script because of the used network functions.
   Enabling deep check will slow down your script even more as it searches the given server for 3 additional types.

.. note::

   **Disallowed IP addresses**

   You should note that MX validation is only accepted for external servers. When deep MX validation is enabled,
   then local IP addresses like ``192.168.*`` or ``169.254.*`` are not accepted.

.. _zend.validator.set.email_address.validateidn:

Validating International Domains Names
--------------------------------------

``Zend\Validate\EmailAddress`` también comparará caracteres internationales que existen en algunos dominios. Esto
se conoce como soporte de International Domain Name (IDN). Está activado por defecto, aunque puede deshabilitarlo
internamente cambiando el ajuste a través del objeto ``Zend\Validate\Hostname`` que existe en
``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateIdn(false);

Sobre el uso de ``setValidateIdn()`` encontrará más información en la documentación de
``Zend\Validate\Hostname``.

Tenga en cuenta que los IDNs se validarán solo si usted permite que nombres de host DNS sean validados.

.. _zend.validator.set.email_address.validatetld:

Validación de dominios de nivel superior
----------------------------------------

Por defecto, un nombre de host se cotejará con una lista conocida de TLDs. Está activado por defecto, aunque
puede deshabilitarlo cambiando el ajuste a través del objeto interno ``Zend\Validate\Hostname`` que existe en
``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateTld(false);

Encontrará más información sobre el uso de ``setValidateTld()`` en la documentación de
``Zend\Validate\Hostname``.

Tenga en cuenta que los TLDs se validarán solo si usted permite que nombres de host DNS sean validados.

.. _zend.validator.set.email_address.setmessage:

Setting messages
----------------

``Zend\Validate\EmailAddress`` makes also use of ``Zend\Validate\Hostname`` to check the hostname part of a given
email address. As with Zend Framework 1.10 you can simply set messages for ``Zend\Validate\Hostname`` from within
``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setMessages(
       array(
           Zend\Validate\Hostname::UNKNOWN_TLD => 'I don't know the TLD you gave'
       )
   );

Before Zend Framework 1.10 you had to attach the messages to your own ``Zend\Validate\Hostname``, and then set this
validator within ``Zend\Validate\EmailAddress`` to get your own messages returned.


