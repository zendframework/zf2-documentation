.. _zend.validate.set.iban:

Iban
====

``Zend_Validate_Iban`` valide si un nombre donnée est un numéro *IBAN* number. *IBAN* est l'abréviation de
"International Bank Account Number".

.. _zend.validate.set.iban.options:

Options supportées par Zend_Validate_Iban
-----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Iban``:

- **locale**: Affecte la locale à utiliser pour la validation du format du numéro *IBAN*.

.. _zend.validate.set.iban.basic:

Validation IBAN
---------------

Les numéros *IBAN* sont toujours relatifs à un pays. Ceci signifie que différents pays utilisent des formats
différents de numéros *IBAN*. C'est la raison pour laquelle les numéros *IBAN* ont toujours besoin d'une locale.
Sachant cela, nous savons déja utiliser ``Zend_Validate_Iban``.

.. _zend.validate.set.iban.basic.application:

Locale globale à l'application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nous pourrions utiliser la locale globale à l'application. Ainsi si on ne passe aucune option à l'initialisation
de ``Zend_Validate_Iban``, celui-ci va chercher la locale globale. Voyez le code qui suit:

.. code-block:: php
   :linenos:

   // dans le bootstrap
   Zend_Registry::set('Zend_Locale', new Zend_Locale('de_AT'));

   // dans le module
   $validator = new Zend_Validate_Iban();

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN est valide
   } else {
       // IBAN n'est pas valide
   }

.. note::

   **Locale globale à l'application**

   Bien sûr cela ne fonctionne que lorsqu'une locale globale a été spécifiée et enregistrée dans le registre.
   Sinon, ``Zend_Locale`` va essayer d'utiliser la locale que le client envoie, si aucune n'a été envoyée, la
   locale de l'environnement sera utilisée. Méfiez-vous cela peut mener à des comportements non voulus lors de
   la validation.

.. _zend.validate.set.iban.basic.false:

Validation IBAN simplifiée
^^^^^^^^^^^^^^^^^^^^^^^^^^

Il peut arriver parfois que vous ayiez juste besoin de vérifier le format du numéro et s'il **est** un numéro
*IBAN*. Vous ne voudriez pas utiliser un pays particulier pour valider. Ceci peut être réalisé en passant
``FALSE`` en tant que locale.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban(array('locale' => false));
   // Note: Vous pouvez aussi passer FALSE comme paramètre unique (sans tableau)

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN est valide
   } else {
       // IBAN n'est pas valide
   }

Ainsi **tout** numéro *IBAN* sera valide. Notez que ceci ne devrait pas être utilisé si vous ne supportez qu'un
seul pays.

.. _zend.validate.set.iban.basic.aware:

Validation IBAN en fonction d'un pays
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour valider par rapport à un pays/région, passez simplement la locale désirée. L'option ``locale`` peut alors
être utilisée ou la méthode ``setLocale()``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban(array('locale' => 'de_AT'));

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN est valide
   } else {
       // IBAN n'est pas valide
   }

.. note::

   **Utilisez des locales pleinement qualifiées**

   Vous devez passer une locale pleinement qualifiée sinon le nom de la région ne pourra être trouvé et
   utilisé.


