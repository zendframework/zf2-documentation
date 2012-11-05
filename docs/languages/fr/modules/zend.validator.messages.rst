.. EN-Revision: none
.. _zend.validator.messages:

Messages de validation
======================

Chaque validateur basé sur ``Zend_Validate`` propose un ou plusieurs messages dans le cas d'un échec. Vous pouvez
utiliser ces informations pour créer vos propres messages ou pour traduire les messages présents.

Ces messages sont représentés par des constantes se trouvant en haut de chaque classe de validateur. Voyons
``Zend\Validate\GreaterThan`` pour un exemple complet:

.. code-block:: php
   :linenos:

   protected $_messageTemplates = array(
       self::NOT_GREATER => "'%value%' n'est pas plus grande que '%min%'",
   );

Comme vous le voyez, la constante ``self::NOT_GREATER`` fait référence à un échec et est utilisée comme clé,
le message lui-même est utilisé comme valeur dans le tableau des messages.

Vous pouvez récupérer les templates de messages d'un validateur en utilisant la méthode
``getMessageTemplates()``. Elle vous retourne le tableau comme vu ci-dessus qui contient tous les messages que le
validateur pourrait retourner en cas d'échec de validation.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\GreaterThan();
   $messages  = $validator->getMessageTemplates();

La méthode ``setMessage()`` permet de modifier un message unique correspondant à un cas particulier d'échec de
validation.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\GreaterThan();
   $validator->setMessage('Entrez une valeur plus petite', Zend\Validate\GreaterThan::NOT_GREATER);

Le deuxième paramètre indique le cas d'échec à surcharger. Lorsque vous omettez ce paramètre, alors le message
précisé sera affecté comme message pour tous les cas d'échec possibles du validateur.

.. _zend.validator.messages.pretranslated:

Utiliser les messages de validations pré-traduits
-------------------------------------------------

Zend Framework est livré avec plus de 45 validateurs différents et plus de 200 messages d'échecs. Cela
peut-être pénible de tous les traduire. Pour votre convenance, Zend Framework est livré avec des messages
d'échec pré-traduits. Vous les trouverez dans ``/resources/languages`` de votre installation de Zend Framework.

.. note::

   **Chemin utilisé**

   Les fichiers de ressources sont en dehors du dossier library car les traductions sont sensées être en dehors
   de ce chemin.

Donc pour traduire les messages de validation en français par exemple, tout ce qu'il y a à faire est d'attacher
un objet de traduction à ``Zend_Validate`` en utilisant les fichiers de ressources (pré-traductions).

.. code-block:: php
   :linenos:

   $translator = new Zend\Translator\Translator(
       array(
           'adapter' => 'array',
           'content' => '/resources/languages',
           'locale'  => $language,
           'scan' => Zend\Translator\Translator::LOCALE_DIRECTORY
       )
   );
   Zend\Validate\Abstract::setDefaultTranslator($translator);

.. note::

   **Adaptateur de traduction utilisé**

   L'adaptateur array a été utilisé, ceci pour permettre une modification simple des messages pré-traduits.

.. note::

   **Langues supportées**

   Cette caractéristique de pré-traduction est jeune, donc le nombre de langues supportées peut ne pas être
   complet. De nouvelles langues seront ajoutées dans les sorties futures.

   Vous pouvez aussi partir de ces fichiers pré-traduits pour créer vos propres traductions, par exemple.

.. _zend.validator.messages.limitation:

Limiter la taille d'un message de validation
--------------------------------------------

Il peut être nécessaire parfois de limiter la taille en caractères des messages d'erreur retournés. par exemple
si une vue n'autorise que 100 caractères par ligne. ``Zend_Validate`` propose une telle option.

La taille actuelle est ``Zend\Validate\Validate::getMessageLength()``. -1 signifie que le message ne sera pas tronqué et
entièrement retourné, c'est le comportement par défaut.

Pour limiter la taille, utilisez ``Zend\Validate\Validate::setMessageLength()``. Lorsque la taille excède cette valeur, le
message sera alors tronqué et suivi de '**...**'.

.. code-block:: php
   :linenos:

   Zend\Validate\Validate::setMessageLength(100);

.. note::

   **Où ce paramètre est-il utilisé ?**

   La taille des messages affecte aussi les messages personnalisés enregistrés, dès que le validateur
   considéré étend ``Zend\Validate\Abstract``.


