.. _zend.validate.introduction:

Introduction
============

Le composant ``Zend_Validate`` fournit un ensemble de validateurs usuels. Il fournit également un mécanisme
simple de chaînage permettant d'appliquer de multiples validateurs à une donnée dans un ordre défini par
l'utilisateur.

.. _zend.validate.introduction.definition:

Qu'est-ce qu'un validateur ?
----------------------------

Un validateur examine ce qui lui est soumis suivant certaines règles et retourne un résultat booléen, si la
donnée est conforme aux exigences. Si ce n'est pas le cas, un validateur peut de manière optionnelle fournir des
informations concernant la (ou les) règle(s) non remplie(s).

Par exemple, une application Web peut réclamer qu'un identifiant comprennent entre six et douze caractères et ne
contiennent que des caractères alphanumériques. Un validateur peut être utilisé pour s'assurer que les
identifiants remplissent ces règles. Si un identifiant donné ne respecte pas l'une ou plusieurs de ces règles,
il sera utile de savoir laquelle ou lesquelles en particulier.

.. _zend.validate.introduction.using:

Utilisation basique des validateurs
-----------------------------------

Avoir défini la validation de cette manière fournit la fondation de ``Zend_Validate_Interface``, qui définit
deux méthodes, ``isValid()`` et ``getMessages()``. La méthode ``isValid()`` réalise la validation sur la valeur
fournie, en retournant ``TRUE`` si et seulement si la valeur respecte les critères de validation.

Si ``isValid()`` retourne ``FALSE``, ``getMessages()`` retourne un tableau de messages expliquant la(es) raison(s)
de l'échec de la validation. Les clés du tableau sont des chaînes courtes qui identifient les raisons de
l'échec de la validation, et les valeurs du tableau sont les chaînes de messages humainement lisibles
correspondantes. Les clés et les valeurs sont dépendantes de la classe ; chaque classe de validation définit son
propre jeu de messages d'échec de validation et les clés uniques qui les identifient. Chaque classe possède
aussi une définition de constantes ("*const*") qui rattachent tout identificateur à une cause d'échec de
validation.

La méthode ``getErrors()`` retourne un tableau d'informations courtes qui identifient la(es) raison(s) de l'échec
de la validation. Ces chaînes sont fournies pour identifier les erreurs. Elles sont destinées à votre code
d'application, et non à être affichées pour l'utilisateur. Ces chaînes sont dépendantes de la classe ; chaque
classe de validation définit ces propres chaînes pour identifier la cause des erreurs. Chaque classe fournit de
plus des constantes (*const*) qui correspondent aux identificateurs d'erreur.

.. note::

   La méthode ``getMessages()`` retourne des informations sur l'échec de validation seulement pour l'appel le
   plus récent de ``isValid()``. Chaque appel de ``isValid()`` efface les messages et les erreurs déclenchées
   par l'appel précédent, car il est probable que chaque appel de ``isValid()`` est réalisé pour des données
   d'entrée différentes.

L'exemple suivant illustre la validation d'une adresse émail :

   .. code-block::
      :linenos:

      $validator = new Zend_Validate_EmailAddress();

      if ($validator->isValid($email)) {
          // l'email est valide
      } else {
          // l'email est invalide ; affichons pourquoi
          foreach ($validator->getMessages() as $messageId => $message) {
              echo "Echec de validation '$messageId' : $message\n";
          }
      }



.. _zend.validate.introduction.messages:

Messages personnalisés
----------------------

Les classes de validation fournissent une méthode ``setMessage()`` avec laquelle vous pouvez spécifier le format
du message retourné par ``getMessages()`` dans le cas d'un échec de validation. Le premier argument de cette
méthode est une chaîne contenant le message d'erreur. Vous pouvez inclure des balises dans cette chaîne qui
seront substituées avec les données appropriées du validateur. La balise *%value%* est supportée par tous les
validateurs ; elle est substituée par la valeur fournie à ``isValid()``. D'autres balises peuvent être
supportées aux cas par cas par chaque classe de validation. Par exemple, *%max%* est une balise supportée par
``Zend_Validate_LessThan``. La méthode ``getMessageVariables()`` retourne un tableau des balises de variables
supportées par le validateur.

Le second paramètre optionnel est une chaîne qui identifie le modèle de message d'échec de validation qui doit
être paramètré, ce qui est pratique quand une classe de validation définit plus d'une cause d'échec. Si vous
omettez ce second argument, ``setMessage()`` considère que le message, que vous spécifiez, s'applique au premier
message déclaré dans la classe de validation. La plupart des classes de validation n'ayant qu'un seul message
d'erreur, il n'est pas nécessaire de spécifier distinctement dans ce cas quel message vous affectez.



   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_StringLength(8);

      $validator->setMessage(
          'La chaîne \'%value%\' est trop courte ; '
        . 'elle doit être au moins de %min% caractères',
          Zend_Validate_StringLength::TOO_SHORT);

      if (!$validator->isValid('word')) {
          $messages = $validator->getMessages();
          echo current($messages);

          // affiche "La chaîne 'word' est trop courte ;
          // elle doit être au moins de 8 caractères"
      }



Vous pouvez régler des messages multiples en utilisant la méthode ``setMessages()``. Son argument dans ce cas est
un tableau de paires clé/message.

   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));

      $validator->setMessages( array(
          Zend_Validate_StringLength::TOO_SHORT =>
                  'La chaîne \'%value%\' est trop courte',
          Zend_Validate_StringLength::TOO_LONG  =>
                  'La chaîne \'%value%\' est trop longue'
      ));



Si votre application exige une flexibilité encore plus grande avec laquelle elle rapporte les échecs de
validation, vous pouvez accéder aux propriétés par le même nom que les balises de message supportées par une
classe de validation donnée. La propriété *value* est toujours accessible dans un validateur ; il s'agit de la
valeur fournie comme argument à ``isValid()``. D'autres propriétés peuvent être supportées au cas par cas par
chaque classe de validation.

   .. code-block::
      :linenos:

      $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));

      if (!validator->isValid('word')) {
          echo 'Echec du mot : '
              . $validator->value
              . ' ; sa longueur n\'est pas compris entre '
              . $validator->min
              . ' et '
              . $validator->max
              . "\n";
      }



.. _zend.validate.introduction.static:

Utilisation de la méthode statique is()
---------------------------------------

S'il est peu pratique de charger une classe de validation donnée et créer une instance de validateur, vous pouvez
utiliser la méthode statique ``Zend_Validate::is()`` comme appel alternatif. Le premier argument de cette méthode
est la donnée d'entrée, que vous passeriez à la méthode ``isValid()``. Le deuxième argument est une chaîne,
qui correspond au nom de base de la classe de validation, relativement dans l'espace de noms ``Zend_Validate``. La
méthode ``is()`` charge automatiquement la classe, crée une instance et applique la méthode ``isValid()`` à la
donnée d'entrée.

   .. code-block:: php
      :linenos:

      if (Zend_Validate::is($email, 'EmailAddress')) {
          // l'email est valide
      }



Vous pouvez aussi fournir un tableau de paramètres destinés au constructeur de la classe, s'ils sont nécessaires
pour votre classe de validation.

   .. code-block::
      :linenos:

      if (Zend_Validate::is($value,
                            'Between',
                            array(array('min' => 1, 'max' => 12)))) {
          // $value est compris entre 1 et 12
      }



La méthode ``is()`` retourne une valeur booléenne, la même que la méthode ``isValid()``. Lors de l'utilisation
de la méthode statique ``is()``, les messages d'échec de validation ne sont pas disponibles.

L'utilisation statique peut être pratique pour invoquer un validateur ad hoc, mais si vous avez besoin d'exécuter
un validateur pour des données multiples, il est plus efficace de suivre le premier exemple ci-dessus, créant une
instance de l'objet de validation et appelant sa méthode ``isValid()``.

De plus, la classe ``Zend_Filter_Input`` vous permet d'instancier et d'exécuter des filtres multiples et des
classes de validateurs sur demande pour traiter l'ensemble de données saisies. Voir :ref:` <zend.filter.input>`.

.. _zend.validate.introduction.static.namespaces:

Espaces de noms
^^^^^^^^^^^^^^^

When working with self defined validators you can give a forth parameter to ``Zend_Validate::is()`` which is the
namespace where your validator can be found.

.. code-block:: php
   :linenos:

   if (Zend_Validate::is($value,
                         'MyValidator',
                         array(array('min' => 1, 'max' => 12)),
                         array('FirstNamespace', 'SecondNamespace')) {
       // Yes, $value is ok
   }

``Zend_Validate`` allows also to set namespaces as default. This means that you can set them once in your bootstrap
and have not to give them again for each call of ``Zend_Validate::is()``. The following code snippet is identical
to the above one.

.. code-block:: php
   :linenos:

   Zend_Validate::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   if (Zend_Validate::is($value,
                         'MyValidator',
                         array(array('min' => 1, 'max' => 12))) {
       // Yes, $value is ok
   }

   if (Zend_Validate::is($value,
                         'OtherValidator',
                         array('min' => 1, 'max' => 12)) {
       // Yes, $value is ok
   }

For your convinience there are following methods which allow the handling of namespaces:

- **Zend_Validator::getDefaultNamespaces()**: Returns all set default namespaces as array.

- **Zend_Validator::setDefaultNamespaces()**: Sets new default namespaces and overrides any previous set. It
  accepts eighter a string for a single namespace of an array for multiple namespaces.

- **Zend_Validator::addDefaultNamespaces()**: Adds additional namespaces to already set ones. It accepts eighter a
  string for a single namespace of an array for multiple namespaces.

- **Zend_Validator::hasDefaultNamespaces()**: Returns true when one or more default namespaces are set, and false
  when no default namespaces are set.

.. _zend.validate.introduction.translation:

Translating messages
--------------------

Validate classes provide a ``setTranslator()`` method with which you can specify a instance of ``Zend_Translator``
which will translate the messages in case of a validation failure. The ``getTranslator()`` method returns the set
translator instance.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));
   $translate = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend_Validate_StringLength::TOO_SHORT => 'Translated \'%value%\''
           ),
           'locale' => 'en'
       )
   );

   $validator->setTranslator($translate);

With the static ``setDefaultTranslator()`` method you can set a instance of ``Zend_Translator`` which will be used
for all validation classes, and can be retrieved with ``getDefaultTranslator()``. This prevents you from setting a
translator manually for all validator classes, and simplifies your code.

.. code-block:: php
   :linenos:

   $translate = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend_Validate_StringLength::TOO_SHORT => 'Translated \'%value%\''
           ),
           'locale' => 'en'
       )
   );
   Zend_Validate::setDefaultTranslator($translate);

.. note::

   When you have set an application wide locale within your registry, then this locale will be used as default
   translator.

Sometimes it is necessary to disable the translator within a validator. To archive this you can use the
``setDisableTranslator()`` method, which accepts a boolean parameter, and ``isTranslatorDisabled()`` to get the set
value.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));
   if (!$validator->isTranslatorDisabled()) {
       $validator->setDisableTranslator();
   }

It is also possible to use a translator instead of setting own messages with ``setMessage()``. But doing so, you
should keep in mind, that the translator works also on messages you set your own.


