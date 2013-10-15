.. EN-Revision: none
.. _zend.filter.inflector:

Zend\Filter\Inflector
=====================

``Zend\Filter\Inflector`` est un outil de conversion de règles (sous forme de chaîne de caractères), vers une
cible. Ce procédé est appelé inflexion.

Par exemple, transformer des MotsEnCasseMélangée ou des motsEnCamelCase vers un chemin. Vous pourriez avoir
besoin de passer les caractères en minuscules, et séparer les mots en utilisant un tiret ("-"). Un inflecteur
sert à ceci.

``Zend\Filter\Inflector`` implémente ``Zend\Filter\Interface``\  ; pour utiliser l'inflexion, vous appelez
``filter()`` sur votre instance.

.. _zend.filter.inflector.camel_case_example:

.. rubric:: Transformer du texteEncasseMelangée ou du texteCamelCase vers un autre format

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector('pages/:page.:suffix');
   $inflector->setRules(array(
       ':page'  => array('Word_CamelCaseToDash', 'StringToLower'),
       'suffix' => 'html'
   ));

   $string   = 'motsEnNotationCamel';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/mots-en-notation-camel.html

   $string   = 'ceci_n_est_pas_en_notation_camel';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/ceci_n_est_pas_en_notation_camel.html

.. _zend.filter.inflector.operation:

Opération
---------

Un inflecteur a besoin d'une **cible** et d'une ou plusieurs **règles**. Une cible est une chaîne dans laquelle
des jokers pour les variables à remplacer sont présents. Ils sont préfixés de doubles-points, par exemple
*:script*.

L'appel à ``filter()``, nécessite un tableau de clés/valeurs pour les jokers présents dans la cible.

Chaque variable dans la cible peut avoir zéro ou plusieurs règles associées. Les règles peuvent être
**statiques** ou faire référence à une classe ``Zend_Filter``. Les règles statiques sont des remplacements purs
et simples. Sinon, la classe qui correspond à la règle sera utilisée pour analyser le texte. Ces classes sont
spécifiées par leur nom (du filtre), non préfixé.

Par exemple, vous pouvez utiliser n'importe quelle instance de ``Zend_Filter``. Cependant, plutôt que d'y faire
référence via "``Zend\Filter\Alpha``" ou "``Zend\Filter\StringToLower``", vous spécifierez seulement "*Alpha*"
ou encore "*StringToLower*".

.. _zend.filter.inflector.paths:

Créer des chemins vers des filtres alternatifs
----------------------------------------------

``Zend\Filter\Inflector`` utilise ``Zend\Loader\PluginLoader`` pour gérer les filtres chargés. Par défaut,
n'importe quel filtre préfixé par ``Zend_Filter`` sera disponible. Pour accéder aux filtres ayant d'autres
préfixes plus profonds, enlevez leur préfixe "``Zend_Filter``" tout simplement :

.. code-block:: php
   :linenos:

   // utilise Zend\Filter\Word\CamelCaseToDash comme règle
   $inflector->addRules(array('script' => 'Word_CamelCaseToDash'));

Pour spécifier d'autres chemins, ``Zend\Filter\Inflector`` possède une méthode qui proxie vers le plugin loader,
``addFilterPrefixPath()``\  :

.. code-block:: php
   :linenos:

   $inflector->addFilterPrefixPath('Mes_Filtres', 'Mes/Filtres/');

Il est possible également de récupérer le plugin loader, et d'intervenir sur son instance de manière directe :

.. code-block:: php
   :linenos:

   $loader = $inflector->getPluginLoader();
   $loader->addPrefixPath('Mes_Filtres', 'Mes/Filtres/');

Pour plus d'informations sur la modification des chemins vers les filtres voyez :ref:`la documentation de
PluginLoader <zend.loader.pluginloader>`.

.. _zend.filter.inflector.targets:

Paramétrer la cible de l'inflecteur
-----------------------------------

La cible de l'inflecteur est un mot joker (ou un identifiant), précédé du caractère spécial, double-point.
":script", ":path", etc. La méthode ``filter()`` cherche ces identifiants pour les traiter (les remplacer).

Il est possible de changer le caractère spécial double-point avec ``setTargetReplacementIdentifier()``, ou en
troisième paramètre de constructeur :

.. code-block:: php
   :linenos:

   // Via le constructeur :
   $inflector = new Zend\Filter\Inflector('#foo/#bar.#sfx', null, '#');

   // Via l'accesseur :
   $inflector->setTargetReplacementIdentifier('#');

En général, concernant la cible, on la passe en constructeur. C'est le cas classique. Il peut être en revanche
nécessaire de pouvoir passer une cible après la construction de l'objet. (Par exemple modifier l'inflecteur des
composants Zend intégrés tels que *ViewRenderer* ou ``Zend_Layout``). ``setTarget()`` peut vous y aider :

.. code-block:: php
   :linenos:

   $inflector = $layout->getInflector();
   $inflector->setTarget('layouts/:script.phtml');

De plus, vous pouvez agréger la cible dans un membre de votre classe, si cela vous permet d'éviter trop d'appels
de méthodes. ``setTargetReference()`` permet ceci :

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Inflector target
        */
       protected $_target = 'foo/:bar/:baz.:suffix';

       /**
        * Constructor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend\Filter\Inflector();
           $this->_inflector->setTargetReference($this->_target);
       }

       /**
        * Set target; updates target in inflector
        *
        * @param  string $target
        * @return Foo
        */
       public function setTarget($target)
       {
           $this->_target = $target;
           return $this;
       }
   }

.. _zend.filter.inflector.rules:

Règles d'inflexion
------------------

Comme dit en introduction, il existe 2 types de règles : statiques et basées sur des filtres.

.. note::

   Notez bien que quelle que soit la méthode que vous utilisez pour spécifier vos règles dans l'inflecteur, leur
   ordre est très important. Vous devez ajouter de la règle la plus spécifique, à la plus générique. Par
   exemple, 2 règles nommées "moduleDir" et "module", la règle "moduleDir" devrait être ajoutée avant la
   règle "module", car cette dernière est contenue dans "moduleDir".

.. _zend.filter.inflector.rules.static:

Règles statiques
^^^^^^^^^^^^^^^^

Les règles statiques permettent des remplacements simples. Si vous avez un segment statique dans votre cible, ce
type de règle est idéal. ``setStaticRule()`` permet de les manipuler :

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector(':script.:suffix');
   $inflector->setStaticRule('suffix', 'phtml');

   // ici des opérations ...
   // changement de la règle:
   $inflector->setStaticRule('suffix', 'php');

Bien sur il est possible d'agréger la règle dans une propriété de classe, ceci permettra d'éviter l'appel de
méthodes. Ce cas se produit typiquement lorsque l'inflecteur est embarqué (encapsulé) dans une classe. Vous
pouvez à ce moment là interdire la récupération de l'inflecteur depuis l'extérieur de la classe, par exemple.
La méthode ``setStaticRuleReference()`` vous y aidera :

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Suffix
        */
       protected $_suffix = 'phtml';

       /**
        * Constructor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector =
               new Zend\Filter\Inflector(':script.:suffix');
           $this->_inflector
                ->setStaticRuleReference('suffix', $this->_suffix);
       }

       /**
        * Set suffix; updates suffix static rule in inflector
        *
        * @param  string $suffix
        * @return Foo
        */
       public function setSuffix($suffix)
       {
           $this->_suffix = $suffix;
           return $this;
       }
   }

.. _zend.filter.inflector.rules.filters:

Règles non statiques : basées sur des filtres
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Des filtres de type ``Zend_Filter`` peuvent être utilisés comme règles dans l'inflecteur. Ils sont donc liés à
des variables cibles, mais vous pouvez lier plusieurs filtres pour une même cible. Ils sont alors procédés dans
l'ordre (FIFO), prenez donc garde à ceci.

Les règles des filtres sont ajoutées avec ``setFilterRule()``. Cette méthode écrase toute règle déjà
définie. ``addFilterRule()`` au contraire, n'écrase pas mais gère une pile de filtres pour une variable. Les
noms des filtres passés à ces 2 méthodes sont de la forme :

- **String**\  : une chaîne de caractères représentant le nom de la classe du filtre, ou alors le nom de la
  classe moins le préfixe utilisé par le plugin loader. (le préfixe par défaut étant "Zend_Filter").

- **Objet filtre**\  : une instance d'objet implémentant ``Zend\Filter\Interface``.

- **Array**\  : un tableau de chaînes ou d'objets.

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector(':script.:suffix');

   // Affecte une règle pour utiliser le filtre
   //Zend\Filter\Word\CamelCaseToDash
   $inflector->setFilterRule('script', 'Word_CamelCaseToDash');

   // Ajoute une règle vers un filtre de casse minuscule
   $inflector->addFilterRule('script', new Zend\Filter\StringToLower());

   // Affectation de plusieurs règles d'un coup
   $inflector->setFilterRule('script', array(
       'Word_CamelCaseToDash',
       new Zend\Filter\StringToLower()
   ));

.. _zend.filter.inflector.rules.multiple:

Paramétrer plusieurs règles en une seule fois
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En temps normal il est plus pratique de spécifier ses règles (statiques et/ou filtres) en une seule fois, plutôt
qu'en plusieurs étapes. Les méthodes de ``Zend\Filter\Inflector`` comme ``addRules()`` et ``setRules()``
permettent ceci.

Chacune de ces 2 méthodes prend en paramètre un tableau de variable/règle. La règle peut être n'importe quel
type accepté (string, objet filtre ou array). Les noms des variables proposent une syntaxe spéciale pour
différencier les règles statiques des filtres :

- **":" prefix**\  : règle à base de filtre.

- **Pas de prefix**\  : règle statique.

.. _zend.filter.inflector.rules.multiple.example:

.. rubric:: Paramétrer plusieurs règles en une seule fois

.. code-block:: php
   :linenos:

   // setRules() accepte la même notation :
   $inflector->addRules(array(
       // règles filtres:
       ':controller' => array('CamelCaseToUnderscore','StringToLower'),
       ':action'     => array('CamelCaseToUnderscore','StringToLower'),

       // règles statiques :
       'suffix'      => 'phtml'
   ));

.. _zend.filter.inflector.utility:

Autres méthodes utilitaires
---------------------------

``Zend\Filter\Inflector`` possède d'autres méthodes pour changer le plugin loader, manipuler des règles, et
contrôler les exceptions.

- ``setPluginLoader()`` peut être utile si vous avez configuré votre propre chargeur de plugins (plugin loader)
  et que vous voulez l'utiliser avec ``Zend\Filter\Inflector``; ``getPluginLoader()`` retourne cette valeur.

- ``setThrowTargetExceptionsOn()`` accepte un booléen. Ceci spécifie qu'une exception doit être lancée si une
  variable est toujours présente dans la cible après le passage de l'inflecteur. Par défaut, ça n'est pas le
  cas. ``isThrowTargetExceptionsOn()`` retourne la valeur actuelle.

- ``getRules($spec = null)`` récupère toutes les règles, ou les règles d'une certaine variable.

- ``getRule($spec, $index)`` récupère une règle précise, même dans une chaîne de filtre. ``$index`` doit
  être précisé.

- ``clearRules()`` va effacer toutes les règles fixées préalablement.

.. _zend.filter.inflector.config:

Zend_Config avec Zend\Filter\Inflector
--------------------------------------

``Zend_Config`` peut être utilisé pour spécifier les règles, les préfixes des filtres et d'autres choses dans
vos inflecteurs. Passez un objet ``Zend_Config`` au constructeur ou à la méthode ``setOptions()``\  :

- *target* définit la cible de l'inflecteur.

- *filterPrefixPath* définit le préfixe/chemins des filtres.

- *throwTargetExceptionsOn* est un booléen. Ceci spécifie qu'une exception doit être lancée si une variable est
  toujours présente dans la cible après le passage de l'inflecteur.

- *targetReplacementIdentifier* spécifie le caractère à utiliser pour définir les variables de remplacement.

- *rules* spécifie un tableau de règles, comme accepté par ``addRules()``.

.. _zend.filter.inflector.config.example:

.. rubric:: Utiliser Zend_Config avec Zend\Filter\Inflector

.. code-block:: php
   :linenos:

   // Par le constructeur :
   $config    = new Zend\Config\Config($options);
   $inflector = new Zend\Filter\Inflector($config);

   // Ou via setOptions() :
   $inflector = new Zend\Filter\Inflector();
   $inflector->setOptions($config);


