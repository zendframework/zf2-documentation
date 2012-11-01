.. EN-Revision: none
.. _zend.filter.input:

Zend\Filter\Input
=================

``Zend\Filter\Input`` propose une manière générique de déclarer des filtres et des validateurs, de les
appliquer comme un ensemble, à une collection de données, et enfin de récupérer ces données validées et
filtrées. Les valeurs sont retournées échappées par défaut, pour une meilleure sécurité relative au HTML.

Considérez cette classe comme une boite noire dans laquelle va passer une variable de collection, typiquement un
tableau *PHP* représentant des données externes. Les données arrivent dans l'application depuis une source
externe, donc potentiellement dangereuse, comme des variables de requête *HTTP*, d'un service Web, d'un fichier,
ou autre. L'application demande alors à la boite noire l'accès à une ou plusieurs données, en spécifiant sous
quelle forme elle s'attend à voir la donnée. La boite inspecte alors la donnée pour la valider, et ne la laisse
sortir que si celle-ci respecte les règles que l'application demande. Grâce à une simple classe et un mécanisme
facile, ceci encourage les développeurs à prendre des bonnes pratiques au regard de la sécurité des
applications.

- **Les filtres** transforment les entrées en supprimant ou changeant des caractères dans leurs valeurs. Le but
  est de "normaliser" les valeurs jusqu'à ce qu'elles correspondent aux attentes exigées. Par exemple si une
  chaine d'entiers (numériques) est attendue, et que la donnée d'entrée est "abc123", alors en sortie du filtre
  la valeur "123" sera proposée.

- **Les validateurs** vérifient la validité d'une donnée, sans la transformer. Si la validation échoue, le
  validateur renseignera sur les problèmes rencontrés.

- **Les échappeurs** transforment une valeur en supprimant certains caractères qui peuvent avoir une
  signification spéciale dans un contexte donné. Par exemple, les caractères '<' et '>' délimitent les balises
  HTML, ainsi si une donnée contenant ces caractères est affichée directement dans un navigateur, la sortie peut
  être corrompue et mener à des problèmes de sécurité. Échapper les caractères est le fait de leur enlever
  toute signification spéciale, ils seront traités comme des caractères tout à fait normaux.

Pour utiliser ``Zend\Filter\Input``\  :

. Déclarez des règles de filtre et de validateur

. Ajoutez des filtres et des validateurs dans ``Zend\Filter\Input``

. Passer les données d'entrée à ``Zend\Filter\Input``

. Récupérez les données valides et/ou des rapports divers

Les sections suivantes expliquent comment manipuler la classe.

.. _zend.filter.input.declaring:

Déclarer des règles de filtre et de validateur
----------------------------------------------

Avant de créer une instance de ``Zend\Filter\Input``, déclarez deux tableaux de règles pour les filtres, et les
validateurs. Ce tableau associatif met en relation le champ de la donnée dans le tableau originel et le nom du
filtre/validateur.

L'exemple qui suit indique que le champ "month" est filtré par un ``Zend\Filter\Digits``, et le champ "account"
est filtré par un ``Zend\Filter\StringTrim``. Puis, une règle de validation s'appliquera au champ "account",
celui-ci sera validé s'il ne contient que des caractères alphabétiques (lettres).

.. code-block:: php
   :linenos:

   $filters = array(
       'month'   => 'Digits',
       'account' => 'StringTrim'
   );

   $validators = array(
       'account' => 'Alpha'
   );

Chaque clé du tableau ``$filters`` représente une donnée à laquelle sera appliqué le filtre correspondant en
valeur de tableau.

Le filtre peut être déclaré selon différents formats :

- Une chaine de caractères, qui sera transformée en nom de classe.

     .. code-block:: php
        :linenos:

        $validators = array(
            'month'   => 'Digits',
        );



- Un objet instance d'une classe implémentant ``Zend\Filter\Interface`` ou ``Zend\Validate\Interface``.

     .. code-block:: php
        :linenos:

        $digits = new Zend\Validate\Digits();

        $validators = array(
            'month'   => $digits
        );



- Un tableau, pour déclarer une chaine de filtres ou validateurs. Les éléments de ce tableau peuvent être des
  chaînes représentant des noms de classe, ou des objets directement. Aussi, vous pouvez utiliser comme valeur un
  tableau contenant le nom du filtre ou validateur, et d'éventuels arguments à passer à son constructeur.

     .. code-block:: php
        :linenos:

        $validators = array(
            'month'   => array(
                'Digits',                // chaine
                new Zend\Validate\Int(), // objet
                array('Between', 1, 12)  // chaine + arguments pour le constructeur
            )
        );



.. note::

   Si vous choisissez de déclarer un filtre ou validateur avec des arguments de constructeur, alors la règle
   générale devra elle aussi utiliser un tableau pour sa/ses déclarations de filtres ou validateurs.

Un joker "***" peut être utilisé dans le tableau des filtres ou des validateurs. Ceci aura pour effet d'appliquer
le validateur ou le filtre à toutes les entrées du tableau traité. Notez que l'ordre des filtres / validateurs
est important dans le tableau, car il seront appliqués dans l'ordre dans lequel ils ont été déclarés.

.. code-block:: php
   :linenos:

   $filters = array(
       '*'     => 'StringTrim',
       'month' => 'Digits'
   );

.. _zend.filter.input.running:

Créer le processeur de filtres et validateurs
---------------------------------------------

Lorsque vos tableaux de filtres et de validateurs ont été construits, passez les en argument au constructeur de
``Zend\Filter\Input``. Ceci va retourner un objet pré-configuré qui saura alors traiter tout un tableau de
données d'entrée.

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators);

Les données d'entrée peuvent être placées dans le troisième paramètre du constructeur. Ces données
possèdent en clé leur nom, et en valeur leur valeur. Typiquement, les tableaux superglobaux ``$_GET`` et
``$_POST`` possèdent la structure idéale pour passer dans ``Zend\Filter\Input``.

.. code-block:: php
   :linenos:

   $data = $_GET;
   $input = new Zend\Filter\Input($filters, $validators, $data);

Aussi, la méthode ``setData()`` accepte les données de la même manière que le troisième argument du
constructeur.

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators);
   $newData = $_POST;
   $input->setData($newData);

La méthode ``setData()`` réaffecte une nouveau tableau de valeurs d'entrée dans l'objet ``Zend\Filter\Input``,
en écrasant toute autre source s'y trouvant. Ceci est pratique afin de réutiliser des règles communes de filtres
/ validateurs, sur différentes sources.

.. _zend.filter.input.results:

Récupérer les champs validés/filtré, et les éventuels rapports
--------------------------------------------------------------

Une fois l'objet configuré, et le tableau de données d'entrée passé, vous pouvez récupérer les rapports
concernant les champs absents, invalides ou inconnus. Vous pouvez évidemment aussi récupérer les valeurs
validées/filtrées des champs d'entrée valides.

.. _zend.filter.input.results.isvalid:

Demander si l'entrée est valide
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si toutes les données d'entrée passent les règles de validation la méthode ``isValid()`` retourne ``TRUE``. Si
n'importe quelle donnée d'entrée n'est pas validée, ou est manquante, alors ``isValid()`` retourne ``FALSE``.

.. code-block:: php
   :linenos:

   if ($input->isValid()) {
     echo "OK\n";
   }

Cette méthode accepte aussi un paramètre facultatif nommant un champ particulier dans la donnée d'entrée. Ceci
permet une vérification individuelle.

.. code-block:: php
   :linenos:

   if ($input->isValid('month')) {
     echo "Le champ 'month' est OK\n";
   }

.. _zend.filter.input.results.reports:

Récupérer les infos des champs invalides, absents ou inconnus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Les champs **invalides** sont ceux qui ne passent pas un ou plusieurs critères définis par les validateurs.

- Les champs **absents** sont ceux qui ne sont pas présents dans la donnée d'entrée, alors que la méta commande
  *'presence'=>'required'* était présente (voyez :ref:`la section <zend.filter.input.metacommands.presence>` sur
  les méta commandes).

- Les champs **inconnus** sont ceux présents dans la donnée d'entrée alors que aucun validateur ni filtre ne lui
  avait attribué de règle.

.. code-block:: php
   :linenos:

   if ($input->hasInvalid() || $input->hasMissing()) {
     $messages = $input->getMessages();
   }

   // getMessages() retourne la fusion de getInvalid() et getMissing()

   if ($input->hasInvalid()) {
     $invalidFields = $input->getInvalid();
   }

   if ($input->hasMissing()) {
     $missingFields = $input->getMissing();
   }

   if ($input->hasUnknown()) {
     $unknownFields = $input->getUnknown();
   }

Les valeurs retournées par ``getMessages()`` sont sous la forme d'un tableau dont la clé est la règle concernée
et la valeur un tableau d'erreurs la concernant. Le tableau d'erreurs comporte en clé le nom de la règle
déclarée qui peut être différent des noms de champs vérifiés par la règle.

La méthode ``getMessages()`` retourne la fusion des tableaux retournés par ``getInvalid()`` et ``getMissing()``.
Ces méthodes retournent une sous-partie des messages correspondant soit aux échecs de validation, soit aux champs
qui sont déclarés requis mais qui sont absents.

La méthode ``getErrors()`` retourne un tableau associatif dont les clés sont des noms de règles et les valeurs
associées des tableaux identifiants les erreurs. Les identifiants d'erreurs sont des chaînes constantes et
figées, qui permettent d'identifier la raison de l'échec de validation, tandis que les messages associés sont
eux-mêmes personnalisables. Voir :ref:` <zend.validate.introduction.using>` pour plus d'information.

Vous pouvez spécifier le message retourné par ``getMissing()`` en utilisant l'option "missingMessage", en tant
qu'argument du constructeur de ``Zend\Filter\Input`` ou en utilisant l'option ``setOptions()``.

.. code-block:: php
   :linenos:

   $options = array(
       'missingMessage' => "Field '%field%' is required"
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   // alternative method:

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setOptions($options);

And you can also add a translator which gives you the ability to provide multiple languages for the messages which
are returned by ``Zend\Filter\Input``.

.. code-block:: php
   :linenos:

   $translate = new Zend\Translator_Adapter\Array(array(
       'content' => array(
           Zend\Filter\Input::MISSING_MESSAGE => "Where is the field?"
       )
   );

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setTranslator($translate);

When you are using an application wide translator, then it will also be used by ``Zend\Filter\Input``. In this case
you will not have to set the translator manually.

Le résultat de la méthode ``getUnknown()`` est un tableau associatif dont les clés sont des noms de champs et
les valeurs sont les valeurs de champs correspondants. Les noms de champs sont dans ce cas les clés du tableau au
lieu des noms de règles, car tout champs n'ayant pas de règles définies est considéré comme un champs inconnu.

.. _zend.filter.input.results.escaping:

Récupérer les champs valides
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tout champ non invalide, non absent et non inconnu, est considéré comme valide. Vous pouvez alors en récupérer
la valeur via un accesseur magique. Des méthodes classiques existent aussi, comme ``getEscaped()`` et
``getUnescaped()``.

.. code-block:: php
   :linenos:

   $m = $input->month;                 // donnée échappée (accesseur magique)
   $m = $input->getEscaped('month');   // donnée échapée
   $m = $input->getUnescaped('month'); // donnée non échappée

Par défaut, récupérer un champ le passe automatiquement au travers de ``Zend\Filter\HtmlEntities``. Ce
comportement est considéré comme défaut pour un affichage en HTML. Le filtre *HtmlEntities* réduit de manière
significative les risques de sécurité liés à un affichage involontaire d'une valeur.

.. note::

   La méthode ``getUnescaped()`` retourne le champ brut, vous devez alors prendre vos précautions lors d'un
   affichage HTML. Attention aux problèmes de sécurité XSS (Cross Site Scripting).

.. warning::

   **Escaping unvalidated fields**

   As mentioned before ``getEscaped()`` returns only validated fields. Fields which do not have an associated
   validator can not be received this way. Still, there is a possible way. You can add a empty validator for all
   fields.

   .. code-block:: php
      :linenos:

      $validators = array('*' => array());

      $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   But be warned that using this notation introduces a security leak which could be used for cross-site scripting
   attacks. Therefor you should always set individual validators for each field.

Il est possible de définir un autre filtre comme filtre par défaut pour récupération des champs. Ceci se fait
via le constructeur :

.. code-block:: php
   :linenos:

   $options = array('escapeFilter' => 'StringTrim');
   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Aussi, la méthode ``setDefaultEscapeFilter()`` fait la même chose :

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setDefaultEscapeFilter(new Zend\Filter\StringTrim());

Il est possible de passer une chaine, ou directement un objet instance de ``Zend_Filter``.

Les filtres d'échappement comme vus juste précédemment, doivent être spécifiés de cette manière là. S'ils
avaient été spécifiés comme filtres dans le tableau de ``Zend\Filter\Input``, ils auraient pu faire échouer
les validateurs, car les filtres sont exécutés **AVANT** les validateurs. Aussi, il n'aurait plus été possible
de proposer la donnée de sortie de manière échappée et non échappée. Ainsi, déclarer un filtre
d'échappement des données devrait toujours être effectué en utilisant la méthode ``setDefaultEscapeFilter()``,
et non pas le tableau ``$filters``.

Comme il n'y a qu'une seule méthode ``getEscaped()``, il ne peut y avoir qu'un seul filtre utilisé pour
l'échappement. Il est cependant possible d'utiliser une chaine de filtre, ou encore de dériver la classe
``Zend\Filter\Input`` en créant d'autres méthodes de récupération de données, plus spécifiques.

.. _zend.filter.input.metacommands:

Utiliser des méta commandes pour contrôler les règles des filtres et validateurs
--------------------------------------------------------------------------------

En plus de déclarer un mapping entre des champs d'un tableau, et des validateurs et des filtres, il est possible
d'utiliser des méta commandes pour contrôler le comportement de Zend\Filter\Input. Les méta commandes se
présentent sous la forme de chaînes dans le tableau des filtres ou des validateurs.

.. _zend.filter.input.metacommands.fields:

La méta commande FIELDS
^^^^^^^^^^^^^^^^^^^^^^^

Si le nom de la règle d'un filtre ou validateur est différente du champs auquel elle doit s'appliquer, vous
pouvez spécifier le nom du champ avec la méta commande "fields".

Vous pouvez spécifier cette méta commande en utilisant la constante de classe ``Zend\Filter\Input::FIELDS``.

.. code-block:: php
   :linenos:

   $filters = array(
       'month' => array(
           'Digits',        // nom du filtre à l'index [0]
           'fields' => 'mo' // nom du champ à l'index ['fields']
       )
   );

Dans l'exemple ci dessus, la règle applique le filtre "digits" au champ d'entrée nommé "mo". La chaine "month"
devient alors un simple mnémonique pour cette règle, elle n'est pas utilisée comme nom de champ si celui-ci est
renseigné avec la méta commande "fields", mais elle est utilisée comme nom de règle.

La valeur par défaut de la méta commande "fields" est l'index de la règle courante. Dans l'exemple ci dessus, si
la méta commande "fields" est omise, la règle s'appliquerait au champ "month".

Un autre usage de la méta commande "fields" est pour préciser les champs aux filtres ou validateurs qui en
attendent plusieurs en entrée. Si la méta commande "fields" est un tableau, alors le filtre/validateur
correspondant aura comme argument la valeur des champs. Pensez au cas où l'on demande à l'utilisateur de saisir 2
fois son mot de passe. Imaginons un validateur qui prend en paramètre un tableau de champs et retourne ``TRUE`` si
les champs sont égaux.

.. code-block:: php
   :linenos:

   $validators = array(
       'password' => array(
           'StringEquals',
           'fields' => array('password1', 'password2')
       )
   );
   // Invoque la classe Zend\Validate\StringEquals,
   // en lui passant un tableau contenant les valeurs
   // des champs 'password1' and 'password2'.

Si la validation échoue, alors le nom de la règle (*'password'*) est utilisé dans le retour de ``getInvalid()``,
et non pas les noms des champs spécifiés dans "fields".

.. _zend.filter.input.metacommands.presence:

Méta commande PRESENCE
^^^^^^^^^^^^^^^^^^^^^^

Si la valeur de cette méta commande est "required", alors le champ doit exister dans la donnée d'entrée.
Autrement, il est reporté comme étant un champ manquant.

Vous pouvez spécifier cette méta commande avec la constante de classe ``Zend\Filter\Input::PRESENCE``.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'presence' => 'required'
       )
   );

La valeur par défaut de cette méta commande est "optional".

.. _zend.filter.input.metacommands.default:

La méta commande DEFAULT_VALUE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si le champ n'est pas présent dans la donnée d'entrée mais que celui-ci possède une méta commande "default",
alors il obtient la valeur de la méta commande.

Vous pouvez spécifier cette méta commande avec la constante de classe ``Zend\Filter\Input::DEFAULT_VALUE``.

La valeur de cette méta commande ne s'applique qu'avant l'invocation des validateurs, et seulement pour la règle
en cours.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'default' => '1'
       )
   );

   // pas de valeur pour le champ 'month'
   $data = array();

   $input = new Zend\Filter\Input(null, $validators, $data);
   echo $input->month; // affiche 1

Si vous utilisez pour une règle la méta commande ``FIELDS`` afin de définir un tableau de champs, vous pouvez
définir un tableau pour la méta commande ``DEFAULT_VALUE``. Les valeurs par défaut seront alors les clés
correspondantes à chaque champ manquant. Si ``FIELDS`` définit de multiples champs mais que ``DEFAULT_VALUE`` est
un scalaire, alors cette valeur scalaire sera utilisée pour tous les champs manquants.

Il n'y a pas de valeur par défaut pour cette méta commande.

.. _zend.filter.input.metacommands.allow-empty:

La méta commande ALLOW_EMPTY
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, si un champ existe dans le tableau d'entrées, alors les validateurs lui sont appliqués, même si la
valeur de ce champs est la chaine vide (*''*). Ceci peut mener à des échecs de validation. Par exemple un
validateur digits (chiffres) va échouer sur une chaine vide (laissant croire que la donnée puisse être composée
de lettres).

Si la chaine vide doit pouvoir être considérée comme valide, utilisez la méta commande "allowEmpty" avec la
valeur ``TRUE``.

Vous pouvez spécifier cette méta commande avec la constante de classe ``Zend\Filter\Input::ALLOW_EMPTY``

.. code-block:: php
   :linenos:

   $validators = array(
       'address2' => array(
           'Alnum',
           'allowEmpty' => true
       )
   );

La valeur par défaut de cette méta commande est ``FALSE``.

Dans la cas peut commun ou vous déclarez une règle de validation avec aucun validateurs, mais que la méta
commande "allowEmpty" est mise à ``FALSE`` (le champ est considéré invalide s'il est vide),
``Zend\Filter\Input`` retourne un message d'erreur par défaut que vous pouvez récupérer avec la méthode
``getMessages()``. Ce message se change grâce à l'option "notEmptyMessage" spécifiée en constructeur de
``Zend\Filter\Input`` ou via la méthode ``setOptions()``.

.. code-block:: php
   :linenos:

   $options = array(
       'notEmptyMessage' =>
           "Une valeur non vide est requise pour le champ '%field%'"
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   // Autre méthode :

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setOptions($options);

.. _zend.filter.input.metacommands.break-chain:

La méta commande BREAK_CHAIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, si une règle possède plus d'un validateur, tous sont appliqués à la donnée d'entrée, et les
éventuels messages d'erreur résultants sont la somme de tous les messages individuels des validateurs.

Si la valeur de la méta commande "*breakChainOnFailure*" est ``TRUE``, la chaine de validation va se terminer dès
lors qu'un des validateur termine sur un échec.

Vous pouvez spécifier cette méta commande au moyen de la constante de classe ``Zend\Filter\Input::BREAK_CHAIN``

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'Digits',
           new Zend\Validate\Between(1,12),
           new Zend\Validate\GreaterThan(0),
           'breakChainOnFailure' => true
       )
   );
   $input = new Zend\Filter\Input(null, $validators);

La valeur par défaut de cette méta commande est ``FALSE``.

La classe ``Zend_Validate`` est plus flexible lors du bris de la chaine d'exécution, par rapport à
``Zend\Filter\Input``. Avec ``Zend_Validate``, vous pouvez mettre l'option pour casser la chaine indépendamment
pour chaque validateur. Avec ``Zend\Filter\Input``, la méta commande "breakChainOnFailure" s'applique à tous les
validateurs dans la règle. Pour un usage plus flexible, créez votre propre chaine de validation comme ceci :

.. code-block:: php
   :linenos:

   // Créer une chaine de validation avec un attribut
   // breakChainOnFailure non uniforme
   $chain = new Zend\Validate\Validate();
   $chain->addValidator(new Zend\Validate\Digits(), true);
   $chain->addValidator(new Zend\Validate\Between(1,12), false);
   $chain->addValidator(new Zend\Validate\GreaterThan(0), true);

   // Déclare la règloe de validation en faisant référence
   // à la chaine de validation ci dessus
   $validators = array(
       'month' => $chain
   );
   $input = new Zend\Filter\Input(null, $validators);

.. _zend.filter.input.metacommands.messages:

La méta commande MESSAGES
^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez attribuer des messages d'erreur pour chaque validateur d'une règle grâce à la méta commande
'messages'. La valeur de cette méta commande varie si vous avez plusieurs validateurs dans une règle ou si vous
voulez spécifier le message pour une erreur particulière concernant un des validateurs.

Vous pouvez utiliser la constante de classe ``Zend\Filter\Input::MESSAGES`` pour définir cette méta commande.

Voici un exemple simple qui enregistre un message d'erreur pour une validateur de chiffres.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'messages' => 'Un mois doit être un chiffre'
       )
   );

Si vous possédez plusieurs validateurs dont vous voulez personnaliser les messages d'erreur, utilisez alors un
tableau comme valeur de la méta commande 'messages'.

Chaque élément de ce tableau s'applique à un validateur au même niveau d'index. Ainsi, un validateur à l'index
**n** verra son message d'erreur modifié si vous utilisez l'index **n** dans le tableau de la méta commande. Il
est ainsi possible d'autoriser certains validateurs à faire usage de leur message d'erreur par défaut, alors que
d'autres posséderont un message personnalisé.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           new Zend\Validate\Between(1, 12),
           'messages' => array(
               // utilise le message par défaut du vaidateur [0]
               // Affecte un nouveau message pour le validateur [1]
               1 => 'Une valeur de mois doit être comprise entre 1 et 12'
           )
       )
   );

Si un des validateurs a plusieurs messages d'erreur, ils sont identifiés par une clé. Il existe différente clé
dans chaque classe de validateur, ceux-ci servent d'identifiants pour les messages d'erreur. Chaque classe
validateur définit aussi des constante pour les clés des messages d'erreur. Cette constante peut être utilisée
dans la méta commande 'messages' en lui passant un tableau associatif plutôt qu'une chaine.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits', new Zend\Validate\Between(1, 12),
           'messages' => array(
               'Un mois ne peut contenir que des chiffres',
               array(
                   Zend\Validate\Between::NOT_BETWEEN =>
                       'La valeur %value% du mois doit être comprise'
                     . ' entre %min% et %max%',
                   Zend\Validate\Between::NOT_BETWEEN_STRICT =>
                       'La valeur %value% du mois doit être comprise'
                     . ' strictement entre %min% et %max%'
               )
           )
       )
   );

Vous devriez vous référer à la documentation de chaque validateur afin de savoir s'il retourne plusieurs
messages d'erreur, les clés de ces messages et les jetons utilisables dans les modèles de message.

Si vous n'avez qu'un seul validateur dans vos règles de validation ou que tous les validateurs ont le même
message de paramétrer, alors ils peuvent être référencés la construction additionnelle de type tableau :

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           new Zend\Validate\Between(1, 12),
           'messages' => array(
                           Zend\Validate\Between::NOT_BETWEEN =>
                               'La valeur %value% du mois doit être comprise'
                             . ' entre %min% et %max%',
                           Zend\Validate\Between::NOT_BETWEEN_STRICT =>
                               'La valeur %value% du mois doit être comprise'
                             . ' strictement entre %min% et %max%'
           )
       )
   );

.. _zend.filter.input.metacommands.global:

Utiliser des options pour définir des méta commandes pour toutes les règles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les valeurs par défaut des méta commandes "allowEmpty", "breakChainOnFailure", et "presence" peuvent être
dictées pour toutes les règles en utilisant l'argument ``$options`` du constructeur de ``Zend\Filter\Input``.

.. code-block:: php
   :linenos:

   // Tous les champs acceptent des valeurs vides
   $options = array('allowEmpty' => true);

   // Il est possible d'écraser le comportement pour une règle précise.
   $validators = array(
       'month' => array(
           'Digits',
           'allowEmpty' => false
       )
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Les méta commandes "fields", "messages", et "default" ne bénéficient pas d'un tel raccourci.

.. _zend.filter.input.namespaces:

Ajouter des espaces de noms comme noms de classes
-------------------------------------------------

Par défaut, l'ajout d'un validateur ou d'un filtre sous forme de chaine, va faire en sort que
``Zend\Filter\Input`` cherche une correspondance sous l'espace de nom ``Zend\Filter\*`` et ``Zend\Validate\*``.

Si vous écrivez vos propres filtres (ou validateurs), la classe peut exister dans un autre espace de nom que
``Zend_Filter`` ou ``Zend_Validate``. Il est alors possible de dire à ``Zend\Filter\Input`` de chercher dans ces
espaces là. Ceci se fait via son constructeur :

.. code-block:: php
   :linenos:

   $options = array('filterNamespace' => 'My_Namespace_Filter', 'validatorNamespace' => 'My_Namespace_Validate');
   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Alternativement, vous pouvez utiliser les méthodes ``addValidatorPrefixPath($prefix, $path)`` ou
``addFilterPrefixPath($prefix, $path)``, qui proxie directement le chargeur de plugin utilisé par
``Zend\Filter\Input``:

.. code-block:: php
   :linenos:

   $input->addValidatorPrefixPath('Autre_Namespace', 'Autre/Namespace');
   $input->addFilterPrefixPath('Foo_Namespace', 'Foo/Namespace');

   // Maitenant l'ordre de recherche des validateurs est :
   // 1. My_Namespace_Validate
   // 2. Autre_Namespace
   // 3. Zend_Validate

   // L'ordre de recherche des filtres est :
   // 1. My_Namespace_Filter
   // 2. Foo_Namespace

Il n'est pas possible de supprimer les espaces de nommage ``Zend_Filter`` et ``Zend_Validate``. Les espaces
définis par l'utilisateur sont cherchés en premiers, les espaces de nom Zend sont cherchés en derniers.

.. note::

   A partir de la version 1.5, la fonction ``addNamespace($namespace)`` est dépréciée et échangée avec le
   chargeur de plugin et les méthodes *addFilterPrefixPath* et *addValidatorPrefixPath* ont été ajoutées. De
   même la constante ``Zend\Filter\Input::INPUT_NAMESPACE`` est aussi dépréciée. Les constantes
   ``Zend\Filter\Input::VALIDATOR_NAMESPACE`` et ``Zend\Filter\Input::FILTER_NAMESPACE`` sont disponibles à partir
   de la version 1.7.0.

.. note::

   A partir de la version 1.0.4, ``Zend\Filter\Input::NAMESPACE``, ayant une valeur *namespace*, a été changé
   par ``Zend\Filter\Input::INPUT_NAMESPACE``, ayant une valeur *inputNamespace*, dans le but de se conformer à la
   réservation du mot clé *namespace* par *PHP* 5.3.


