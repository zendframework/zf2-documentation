.. EN-Revision: none
.. _zend.validator.Db:

Db_RecordExists et Db_NoRecordExists
====================================

``Zend\Validate_Db\RecordExists`` et ``Zend\Validate_Db\NoRecordExists`` permettent de vérifier si un
enregistrement existe (ou pas) dans une table de base de données.

.. _zend.validator.set.db.options:

Options supportées par Zend\Validate_Db\*
-----------------------------------------

Les options suivantes sont supportées par ``Zend\Validate_Db\NoRecordExists`` et
``Zend\Validate_Db\RecordExists``\  :

- **adapter**\  : l'adaptateur de base de données qui sera utilisé pour la recherche.

- **exclude**\  : jeu d'enregistrements qui seront exclus de la recherche.

- **field**\  : le champs dans la table de la base de données dans lequel sera effectué la recherche.

- **schema**\  : le schéma utilisé pour la recherche.

- **table**\  : la table qui sera utilisée pour la recherche.

.. _zend.validator.db.basic-usage:

Utilisation de base
-------------------

Voici un exemple basique:

.. code-block:: php
   :linenos:

   //Vérifie que l'email existe bien dans la base de données
   $validator = new Zend\Validate_Db\RecordExists('users', 'emailaddress');
   if ($validator->isValid($emailaddress)) {
       // l'adresse email existe
   } else {
       // l'adresse email n'existe pas, affichons les messages d'erreur
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Le code ci-dessus vérifie la présence d'une adresse email ``$emailaddress`` vis à vis d'un champ d'une table de
base de données.

.. code-block:: php
   :linenos:

   //Vérifie que le nom d'utilisateur n'est pas présent dans la table
   $validator = new Zend\Validate_Db\NoRecordExists('users', 'username');
   if ($validator->isValid($username)) {
       // Le nom d'utilisateur semble absent de la table
   } else {
       // invalide : l'utilisateur est probablement présent dans la table
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

Le code ci-dessus vérifie l'absence d'un nom d'utilisateur ``$username`` vis à vis d'un champ d'une table de base
de données.

.. _zend.validator.db.excluding-records:

Exclure des enregistrement
--------------------------

``Zend\Validate_Db\RecordExists`` et ``Zend\Validate_Db\NoRecordExists`` proposent aussi un moyen de tester la base
de données en excluant certaines parties de table, en passant une clause where ou un tableau de paires "champs"
"valeur".

Lorsqu'un tableau est passé, l'opérateur *!=* est utilisé et vous pouvez ainsi tester le reste de la table.

.. code-block:: php
   :linenos:

   //Vérifie qu'aucun autre utilisateur que celui dont l'id est spécifié, ne possède ce nom
   $user_id   = $user->getId();
   $validator = new Zend\Validate_Db\NoRecordExists(
       'users',
       'username',
       array(
           'field' => 'id',
           'value' => $user_id
       )
   );

   if ($validator->isValid($username)) {
       // OK
   } else {
       // KO
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

L'exemple ci dessus va vérifier qu'aucun utilisateur dont l'id n'est pas celui spécifié, possède ce nom là
``$username``.

La clause d'exclusion peut aussi être renseignée avec une chaine afin de pouvoir utiliser un opérateur autre que
*!=*.

.. code-block:: php
   :linenos:

   $post_id   = $post->getId();
   $clause    = $db->quoteInto('post_id = ?', $category_id);
   $validator = new Zend\Validate_Db\RecordExists(
       'posts_categories',
       'post_id',
       $clause
   );

   if ($validator->isValid($username)) {
       // OK
   } else {
       // KO
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

L'exemple ci-dessus vérifie la table *posts_categories* pour s'assurer qu'un enregistrement avec *post_id*
corresponde à ``$category_id``

.. _zend.validator.db.database-adapters:

Adaptateurs de base de données
------------------------------

Un adaptateur spécifique peut être passé au validateur. Dans le cas contraire, il utilisera l'adaptateur
déclaré comme étant celui par défaut:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate_Db\RecordExists('users', 'id', null, $dbAdapter);

.. _zend.validator.db.database-schemas:

Nom des bases de données
------------------------

Vous pouvez spécifier un nom de base de données (schéma) pour l'adaptateur PostgreSQL et DB/2 simplement grâce
à un tableau possédant les clés *table* et *schema*. Voici un exemple:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate_Db\RecordExists(array('table' => 'users',
                                                        'schema' => 'my'), 'id');


