.. EN-Revision: none
.. _zend.validator.set.email_address:

EmailAddress
============

``Zend\Validate\EmailAddress`` permet de valider une adresse émail. Ce validateur éclate d'abord l'adresse émail
entre partie locale et domaine et essaie de valider ces deux parties conformément aux spécifications des adresses
émail et des noms de domaine.

.. _zend.validator.set.email_address.basic:

Utilisation de base
-------------------

Vous trouverez ci-dessous un exemple d'utilisation basique 

.. code-block:: php
   :linenos:

   $validateur = new Zend\Validate\EmailAddress();
   if ($validateur->isValid($email)) {
       // l'email est valide
   } else {
       // l'email est invalide ; afficher pourquoi
       foreach ($validateur->getMessages() as $message) {
           echo "$message\n";
       }
   }

Ceci validera l'adresse émail ``$email`` et, en cas d'échec, fournira des messages d'erreur informatifs via
*$validator->getMessages()*.

.. _zend.validator.set.email_address.options:

Options for validating Email Addresses
--------------------------------------

``Zend\Validate\EmailAddress`` supports several options which can either be set at initiation, by giving an array
with the related options, or afterwards, by using ``setOptions()``. The following options are supported:

- **allow**: Defines which type of domain names are accepted. This option is used in conjunction with the hostname
  option to set the hostname validator. For more informations about possible values of this option, look at
  :ref:`Hostname <zend.validator.set.hostname>` and possible ``ALLOW``\ * constants. This option defaults to
  ``ALLOW_DNS``.

- **deep**: Defines if the servers MX records should be verified by a deep check. When this option is set to
  ``TRUE`` then additionally to MX records also the A, A6 and ``AAAA`` records are used to verify if the server
  accepts emails. This option defaults to ``FALSE``.

- **domain**: Defines if the domain part should be checked. When this option is set to ``FALSE``, then only the
  local part of the email address will be checked. In this case the hostname validator will not be called. This
  option defaults to ``TRUE``.

- **hostname**: Sets the hostname validator with which the domain part of the email address will be validated.

- **mx**: Defines if the MX records from the server should be detected. If this option is defined to ``TRUE`` then
  the MX records are used to verify if the server accepts emails. This option defaults to ``FALSE``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setOptions(array('domain' => false));

.. _zend.validator.set.email_address.complexlocal:

Parties locales complexes
-------------------------

``Zend\Validate\EmailAddress`` validera toute adresse émail conforme à la RFC2822. Comme par exemple
*bob@domaine.com*, *bob+jones@domaine.fr*, *"bob@jones"@domaine.com* et *"bob jones"@domaine.com*. Quelques formats
d'émail obsolètes ne seront pas validés (comme tout émail contenant un retour chariot ou un caractère "\\").

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

Validation de différents types de noms de domaine
-------------------------------------------------

La partie domaine d'une adresse émail est validée via :ref:`Zend\Validate\Hostname <zend.validator.set.hostname>`.
Par défaut, seules les domaines qualifiés sous la forme *domaine.com* sont acceptés, même si, il vous est
possible d'accepter les adresses IP et les domaines locaux également.

Afin de réaliser cette opération, il vous faut instancier ``Zend\Validate\EmailAddress`` en lui passant un
paramètre indiquant le type de nom de domaine à accepter. Les détails sont disponibles dans
``Zend\Validate\EmailAddress`` mais vous trouverez ci-dessous un exemple illustrant comment accepter les noms de
domaines qualifiés et les hôtes locaux :

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
                       Zend\Validate\Hostname::ALLOW_DNS |
                       Zend\Validate\Hostname::ALLOW_LOCAL);
   if ($validator->isValid($email)) {
       // l'email est valide
   } else {
       // l'email est invalide ; afficher pourquoi
       foreach ($validateur->getMessages() as $message) {
           echo "$message\n";
       }
   }

.. _zend.validator.set.email_address.checkacceptance:

Vérification que le nom de domaine accepte réellement l'émail
-------------------------------------------------------------

Le fait qu'une adresse électronique est dans un format correct, ne signifie pas nécessairement que l'adresse
électronique existe en réalité. Pour aider résoudre ce problème, vous pouvez utiliser la validation MX pour
vérifier si une entrée MX (l'émail) existe dans le l'enregistrement du DNS pour le nom de domaine de l'émail.
Cela vous dit que le nom de domaine accepte l'émail, mais ne vous dit pas que l'adresse électronique elle-même
est valable.

La vérification MX n'est pas active par défaut et est seulement supporté par des plates-formes UNIX pour
l'instant. Pour activer la vérification MX vous pouvez passer un deuxième paramètre au constructeur
``Zend\Validate\EmailAddress``.

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

Alternativement vous pouvez passer soit ``TRUE`` soit ``FALSE`` à *$validator->setValidateMx()* pour activer ou
désactiver la validation MX.

En activant ce paramètre, les fonctions de réseau seront utilisés pour vérifier la présence d'un
enregistrement MX sur le nom de domaine de l'adresse électronique que vous voulez valider. Faîtes cependant
attention, cela ralentira probablement votre scénario.

Sometimes validation for MX records returns ``FALSE``, even if emails are accepted. The reason behind this
behaviour is, that servers can accept emails even if they do not provide a MX record. In this case they can provide
A, A6 or ``AAAA`` records. To allow ``Zend\Validate\EmailAddress`` to check also for these other records, you need
to set deep MX validation. This can be done at initiation by setting the ``deep`` option or by using
``setOptions()``.

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

Valider les noms de domaines internationaux
-------------------------------------------

``Zend\Validate\EmailAddress`` peut aussi vérifier les caractères internationaux qui existent dans quelques
domaines. Ceci est connu comme le support de Nom de Domaine International (IDN). Celui-ci est activé par défaut,
quoique vous puissiez le mettre hors service en changeant le paramètre via l'objet interne
``Zend\Validate\Hostname`` qui existe dans ``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->hostnameValidator->setValidateIdn(false);

De plus amples informations concernant l'utilisation de ``setValidateIdn()`` sont présentes dans la
:ref:`documentation de Zend\Validate\Hostname <zend.validator.set.hostname>`.

Notez cependant que les IDNs sont seulement validés si vous autorisez la validation des nom de domaines.

.. _zend.validator.set.email_address.validatetld:

Validation des "Top Level Domains"
----------------------------------

Par défaut un nom de domaine sera vérifié grâce à une liste de TLDs connus. Ceci est activé par défaut,
quoique vous puissiez le mettre hors service en changeant le paramètre via l'objet ``Zend\Validate\Hostname``
interne qui existe dans ``Zend\Validate\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->hostnameValidator->setValidateTld(false);

De plus amples informations concernant l'utilisation de ``setValidateTld()`` sont présentes dans la
:ref:`documentation de Zend\Validate\Hostname <zend.validator.set.hostname>`.

Notez cependant que les TLDs sont seulement validés si vous autorisez la validation des nom de domaines.

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


