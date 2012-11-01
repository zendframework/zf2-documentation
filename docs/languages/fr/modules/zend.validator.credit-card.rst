.. EN-Revision: none
.. _zend.validator.set.creditcard:

CreditCard
==========

``Zend\Validate\CreditCard`` permet de valider si une valeur est susceptible de représenter un numéro de carte de
crédit.

Une carte de crédit contient plein de données, incluant un hologramme, un numéro de compte, un logo, une date
d'expiration, un code de sécurité et le nom du détenteur. L'algorithme qui vérifie la combinaison de ces
données n'est connu que des entreprises délivrant les cartes et devrait être vérifié lors d'un paiement.
Cependant, il est utile de savoir si le numéro de la carte est valable **avant** d'effectuer de telles
vérifications complexes. ``Zend\Validate\CreditCard`` vérifie simplement que le numéro est bien formé.

Dans les cas où vous possederiez un service capable d'effectuer des vérifications complètes,
``Zend\Validate\CreditCard`` vous permet de passer une fonction de rappel à utiliser si le numéro a été
vérifié comme valide. Le retour de la fonction de rappel servira alors de retour général du validateur.

Les institutions suivantes sont acceptées:

- **American Express**

  **China UnionPay**

  **Diners Club Card Blanche**

  **Diners Club International**

  **Diners Club US & Canada**

  **Discover Card**

  **JCB**

  **Laser**

  **Maestro**

  **MasterCard**

  **Solo**

  **Visa**

  **Visa Electron**

.. note::

   **Institutions non valides**

   **Bankcard** et **Diners Club enRoute** n'existent plus, elles sont donc considérées non valides.

   **Switch** est rattaché à **Visa** et est donc considérée comme non valide.

.. _zend.validator.set.creditcard.options:

Options supportées par Zend\Validate\CreditCard
-----------------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\CreditCard``\  :

- **service**\  : une fonction de rappel vers un service en ligne qui sera utilisé en plus pour la validation.

- **type**\  : le type de carte crédit qui sera validée. Voir ci-dessous la liste des institutions pour de plus
  amples détails.

.. _zend.validator.set.creditcard.basic:

Utilisation classique
---------------------

Il y a plusieurs institutions qui peuvent être validées par ``Zend\Validate\CreditCard``. Par défaut, toutes les
institutions connues sont acceptées:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\CreditCard();
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }

L'exemple ci-dessus valide le numéro pour toutes les institutions connues.

.. _zend.validator.set.creditcard.institute:

Accepter seulement certains types de cartes
-------------------------------------------

Il peut arriver que vous ne vouliez valider que certains types de cartes plutôt que toutes les institutions
connues. ``Zend\Validate\CreditCard`` permet ceci.

Pour utiliser une limite, spécifiez les institutions accéptées à l'initialisation ou après, grâce à
``setType()``. Plusieurs arguments sont utilisables.

Vous pouvez préciser une seule institution:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\CreditCard(
       Zend\Validate\CreditCard::AMERICAN_EXPRESS
   );

Plusieurs institutions se précisent au moyen d'un tableau:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\CreditCard(array(
       Zend\Validate\CreditCard::AMERICAN_EXPRESS,
       Zend\Validate\CreditCard::VISA
   ));

Et comme pour tout validateur, vous pouvez passer un tableau global ou un objet ``Zend_Config``. Dans ce cas, les
institutions se précisent au moyen de la clé ``type``:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\CreditCard(array(
       'type' => array(Zend\Validate\CreditCard::AMERICAN_EXPRESS)
   ));

.. _zend.validator.set.creditcard.institute.table:

.. table:: Constante représentant les institutions

   +-------------------------+----------------+
   |Institution              |Constante       |
   +=========================+================+
   |American Express         |AMERICAN_EXPRESS|
   +-------------------------+----------------+
   |China UnionPay           |UNIONPAY        |
   +-------------------------+----------------+
   |Diners Club Card Blanche |DINERS_CLUB     |
   +-------------------------+----------------+
   |Diners Club International|DINERS_CLUB     |
   +-------------------------+----------------+
   |Diners Club US & Canada  |DINERS_CLUB_US  |
   +-------------------------+----------------+
   |Discover Card            |DISCOVER        |
   +-------------------------+----------------+
   |JCB                      |JCB             |
   +-------------------------+----------------+
   |Laser                    |LASER           |
   +-------------------------+----------------+
   |Maestro                  |MAESTRO         |
   +-------------------------+----------------+
   |MasterCard               |MASTERCARD      |
   +-------------------------+----------------+
   |Solo                     |SOLO            |
   +-------------------------+----------------+
   |Visa                     |VISA            |
   +-------------------------+----------------+
   |Visa Electron            |VISA            |
   +-------------------------+----------------+

Vous pouvez aussi configurer les institutions valides après la construction, au moyen des méthodes ``setType()``,
``addType()`` et ``getType()``.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\CreditCard();
   $valid->setType(array(
       Zend\Validate\CreditCard::AMERICAN_EXPRESS,
       Zend\Validate\CreditCard::VISA
   ));

.. note::

   **Institution par défaut**

   Si vous ne précisez pas d'institution à la construction, alors ``ALL`` sera utilisée, et donc toutes les
   institutions seront utilisées.

   Dans ce cas, utiliser ``addType()`` ne sert à rien.

.. _zend.validator.set.creditcard.servicecheck:

Validation par fonction de rappel
---------------------------------

Comme déja dit, ``Zend\Validate\CreditCard`` ne valide que le numéro de la carte. Heureusement, certaines
institutions proposent des *API*\ s pour valider des numéros de carte de crédit qui ne sont pas publiques. Ces
services sont très souvent payants, ainsi cette vérification est par défaut désactivée.

Lorsque vous avez accès à de telles *API*\ s, vous pouvez les utiliser comme fonctions additionnelles à
``Zend\Validate\CreditCard`` et ainsi augmenter la sécurité de la validation.

Pour ce faire, vous devez simplement préciser une fonction de rappel qui sera appelée après que la validation
"classique" ait réussi. Ceci évite un appel à l'*API* avec un numéro de toute façon non valide et augmentera
ainsi les performances de la validation et donc de l'application.

``setService()`` et ``getService()`` sont utilisée pour la fonction de rappel. La clé de configuration à
utiliser, si vous le souhaitez, est '``service``' (à la construction). Des détails peuvent être trouvés sur la
documentation du validateur :ref:`Callback <zend.validator.set.callback>`.

.. code-block:: php
   :linenos:

   // Votre classe de service
   class CcService
   {
       public function checkOnline($cardnumber, $types)
       {
           // Processus de validation ici
       }
   }

   // La validation
   $service = new CcService();
   $valid   = new Zend\Validate\CreditCard(Zend\Validate\CreditCard::VISA);
   $valid->setService(array($service, 'checkOnline'));

Ici le service sera appelé avec le numéro de carte comme premier paramètre, et les types accéptés comme
second.


