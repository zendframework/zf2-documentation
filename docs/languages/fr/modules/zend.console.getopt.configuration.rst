.. EN-Revision: none
.. _zend.console.getopt.configuration:

Configurer Zend\Console\Getopt
==============================

.. _zend.console.getopt.configuration.addrules:

Ajouter des règles d'options
----------------------------

Vous pouvez ajouter de nouvelles règles d'option en complément de celles indiquées dans le constructeur de
``Zend\Console\Getopt``, en utilisant la méthode ``addRules()``. L'argument d'``addRules()`` est identique au
premier argument du constructeur de classe. C'est soit une chaîne dans le format d'options de syntaxe courte, soit
un tableau associatif dans le format d'options de syntaxe longue. Voir :ref:`"Déclarer les règles Getopt"
<zend.console.getopt.rules>` pour les détails sur la syntaxe de déclaration des options.

.. _zend.console.getopt.configuration.addrules.example:

.. rubric:: Utilisation d'addRules()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->addRules(
     array(
       'verbose|v' => 'Print verbose output'
     )
   );

L'exemple au-dessus montre comment ajouter l'option "``--verbose``" avec l'alias "``-v``" à un ensemble d'options
définies dans l'appel au constructeur. Notez que vous pouvez mélanger des options de syntaxe courte et de syntaxe
longue dans la même instance de ``Zend\Console\Getopt``.

.. _zend.console.getopt.configuration.addhelp:

Ajouter des messages d'aide
---------------------------

En plus d'indiquer les messages d'aide en déclarant les règles d'option dans le long format, vous pouvez associer
des messages d'aide aux règles d'option en utilisant la méthode ``setHelp()``. L'argument de la méthode
``setHelp()`` est un tableau associatif, dans laquelle la clé est un drapeau, et la valeur est le message d'aide
correspondant.

.. _zend.console.getopt.configuration.addhelp.example:

.. rubric:: Utiliser setHelp()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setHelp(
       array(
           'a' => 'option abricot, sans paramètres',
           'b' => 'option banane, avec un paramètre entier obligatoire',
           'p' => 'option pear, avec un paramètre chaîne de caractères optionel'
       )
   );

Si vous déclarez des options avec des alias, vous pouvez employer n'importe quel alias comme clé du tableau
associatif.

La méthode ``setHelp()`` est la seule manière de définir des messages d'aide si vous déclarez les options en
utilisant la syntaxe courte.

.. _zend.console.getopt.configuration.addaliases:

Ajouter des alias aux options
-----------------------------

Vous pouvez déclarer des alias pour des options en utilisant la méthode ``setAliases()``. L'argument est un
tableau associatif, dont la clé est une chaîne de drapeau déclaré auparavant, et dont la valeur est un nouvel
alias pour ce drapeau. Ces alias sont fusionnés avec tous les alias existants. En d'autres termes, les alias que
vous avez déclarés plus tôt sont toujours actifs.

Un alias ne peut être déclaré qu'une seule fois. Si vous essayez de redéfinir un alias, une
``Zend\Console\Getopt\Exception`` est levée.

.. _zend.console.getopt.configuration.addaliases.example:

.. rubric:: Utiliser setAliases()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setAliases(
       array(
           'a' => 'apple',
           'a' => 'apfel',
           'p' => 'pear'
       )
   );

Dans l'exemple ci-dessus, après leurs déclarations, "``-a``", "``--apple``" et "``--apfel``" sont des alias les
un pour les autres. En outre "``-p``" et "``--pear``" sont des alias l'un pour l'autre.

La méthode ``setAliases()`` est la seule manière de définir des alias si vous déclarez les options en utilisant
la syntaxe courte.

.. _zend.console.getopt.configuration.addargs:

Ajouter des listes d'arguments
------------------------------

Par défaut, ``Zend\Console\Getopt`` utilise ``$_SERVER['argv']`` comme tableau des arguments de ligne de commande
à analyser. De manière alternative, vous pouvez indiquer le tableau d'arguments comme deuxième argument de
constructeur. En conclusion, vous pouvez ajouter de nouveaux d'arguments à ceux déjà utilisés en utilisant la
méthode ``addArguments()``, ou vous pouvez remplacer le choix courant d'arguments en utilisant la méthode
``setArguments()``. Dans les deux cas, le paramètre de ces méthodes est un simple tableau de chaîne. L'ancienne
méthode ajoutait le tableau aux arguments courants, et la nouvelle méthode substitue le tableau aux arguments
courants.

.. _zend.console.getopt.configuration.addargs.example:

.. rubric:: Utilisation de addArguments() et setArguments()

.. code-block:: php
   :linenos:

   // Par défaut, le constructeur utilise $_SERVER['argv']
   $opts = new Zend\Console\Getopt('abp:');

   // Ajoute un tableau aux arguments existants
   $opts->addArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

   // Remplace les arguments existants par un nouveau tableau
   $opts->setArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

.. _zend.console.getopt.configuration.config:

Ajouter une configuration
-------------------------

Le troisième paramètre du constructeur de ``Zend\Console\Getopt`` est un tableau d'options de configuration qui
affectent le comportement de l'instance d'objet retournée. Vous pouvez également indiquer des options de
configuration en utilisant la méthode ``setOptions()``, ou vous pouvez placer une option individuelle en utilisant
la méthode ``setOption()``.

.. note::

   **Clarifier le terme "option"**

   Le terme "option" est employé pour la configuration de la classe ``Zend\Console\Getopt`` afin de correspondre
   à la terminologie utilisée dans le reste de Zend Framework. Ce n'est pas la même chose que les options de la
   ligne de commande qui sont analysées par la classe ``Zend\Console\Getopt``.

Les options actuellement supportées ont des définitions de constantes dans la classe. Les options, leurs
constantes (avec des valeurs littérales entre parenthèses) sont énumérées ci-dessous :

- ``Zend\Console\Getopt::CONFIG_DASHDASH`` ("dashDash"), si ``TRUE``, utilise le drapeau spécial "``--``" pour
  signifier la fin des drapeaux. Les arguments de la ligne de commande suivant le double-tiret ne sont pas
  interprétées comme options, même si les arguments commencent par un tiret. Cette option de configuration vaut
  ``TRUE`` par défaut.

- ``Zend\Console\Getopt::CONFIG_IGNORECASE`` ("ignoreCase"), si ``TRUE``, fait correspondre des alias même s'ils
  différent en terme de casse. C'est-à-dire, "``-a``" et "``-A``" seront considérés comme des synonymes. Cette
  option de configuration vaut ``FALSE`` par défaut.

- ``Zend\Console\Getopt::CONFIG_RULEMODE`` ("ruleMode") peut avoir les valeurs ``Zend\Console\Getopt::MODE_ZEND``
  ("zend") ou ``Zend\Console\Getopt::MODE_GNU`` ("gnu"). Il ne devrait pas être nécessaire d'employer cette
  option à moins que vous n'étendiez la classe avec les formes additionnelles de syntaxe. Les deux modes
  supportés dans la classe ``Zend\Console\Getopt`` de base sont sans équivoque. Si le spécificateur est une
  chaîne de caractère, la classe passe en ``MODE_GNU``, autrement elle est en ``MODE_ZEND``. Mais si vous
  étendez la classe et ajoutez de nouvelles formes de syntaxe, vous pouvez avoir à indiquer le mode en utilisant
  cette option.

Plus d'options de configuration pourront être ajoutées en tant que futurs perfectionnements de cette classe.

Les deux arguments de la méthode ``setOption()`` sont un nom d'option de configuration et une valeur d'option.

.. _zend.console.getopt.configuration.config.example.setoption:

.. rubric:: Utilisation de setOption()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setOption('ignoreCase', true);

L'argument de la méthode ``setOptions()`` est un tableau associatif. Les clés de ce tableau sont les noms
d'option de configuration, et les valeurs sont des valeurs de configuration. C'est également le format de tableau
utilisé par le constructeur de classe. Les valeurs de configuration que vous indiquez sont fusionnées avec la
configuration courante ; vous n'avez pas à énumérer toutes les options.

.. _zend.console.getopt.configuration.config.example.setoptions:

.. rubric:: Utilisation de setOptions()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setOptions(
       array(
           'ignoreCase' => true,
           'dashDash'   => false
       )
   );


