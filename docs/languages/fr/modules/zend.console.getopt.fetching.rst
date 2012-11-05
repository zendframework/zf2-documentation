.. EN-Revision: none
.. _zend.console.getopt.fetching:

Extraire les options et les arguments
=====================================

Après avoir déclaré les options que l'objet ``Zend\Console\Getopt`` doit identifier, et fourni les arguments de
la ligne de commande ou un tableau, vous pouvez interroger l'objet pour connaître les options indiquées par un
utilisateur lors d'un appel à votre programme en ligne de commande. La classe implémente les méthodes magiques
ainsi vous pouvez interroger directement par les noms d'options.

L'analyse des données est reportée jusqu'à ce que vous invoquiez pour la première fois l'objet
``Zend\Console\Getopt`` pour découvrir si une option était renseignée, l'objet exécute alors son analyse. Ceci
permet plusieurs appels de méthode pour configurer les options, arguments, messages d'aide, et les options de
configuration, avant que l'analyse ne soit lancée.

.. _zend.console.getopt.fetching.exceptions:

Manipuler les exceptions Getopt
-------------------------------

Si l'utilisateur a donné des options invalides sur la ligne de commande, la fonction d'analyse syntaxique lève
une ``Zend\Console_Getopt\Exception``. Vous devrez récupérer cette exception dans votre code d'application. Vous
pouvez utiliser la méthode ``parse()`` pour forcer l'objet à analyser les arguments. C'est utile parce que vous
pouvez invoquer ``parse()`` dans un bloc **try**. S'il passe, vous pouvez être sûrs que l'analyse syntaxique ne
lèvera pas d'exception de nouveau. L'exception est lancée via une méthode personnalisée ``getUsageMessage()``,
qui retourne comme une chaîne de caractère l'ensemble formaté des messages d'utilisation pour toutes les options
déclarées.

.. _zend.console.getopt.fetching.exceptions.example:

.. rubric:: Récupérer une exception Getopt

.. code-block:: php
   :linenos:

   try {
       $opts = new Zend\Console\Getopt('abp:');
       $opts->parse();
   } catch (Zend\Console_Getopt\Exception $e) {
       echo $e->getUsageMessage();
       exit;
   }

Les cas, où l'analyse syntaxique lève une exception, incluent :

- L'option passée n'est pas reconnue.

- L'option nécessite un paramètre mais aucun n'est fourni.

- Le paramètre d'option n'a pas le bon type. Par exemple, une chaîne de caractères non-numérique quand un
  nombre entier a été exigé.

.. _zend.console.getopt.fetching.byname:

Extraire les options par nom
----------------------------

Vous pouvez employer la méthode ``getOption()`` pour connaître la valeur d'une option. Si l'option avait un
paramètre, cette méthode retourne la valeur du paramètre. Si l'option n'avait aucun paramètre mais que
l'utilisateur en indiquait sur dans la ligne de commande, la méthode retournerait ``TRUE``. Sinon la méthode
retournerait ``NULL``.

.. _zend.console.getopt.fetching.byname.example.setoption:

.. rubric:: Utiliser getOption()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $b = $opts->getOption('b');
   $p_parameter = $opts->getOption('p');

De manière alternative, vous pouvez employer la fonction magique ``__get()`` pour rechercher la valeur d'une
option comme si c'était une variable de membre de classe. La méthode magique ``__isset()`` est également
implémentée.

.. _zend.console.getopt.fetching.byname.example.magic:

.. rubric:: Utiliser les méthodes magiques \__get() et \__isset()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   if (isset($opts->b)) {
       echo "J'ai recu l'option b.\n";
   }
   $p_parameter = $opts->p; // null si non fourni

Si vos options sont déclarées avec des alias, vous pouvez employer n'importe quel alias de l'option dans les
méthodes ci-dessus.

.. _zend.console.getopt.fetching.reporting:

Extraire les options
--------------------

Il y a plusieurs méthodes pour extraire l'ensemble complet des options fournies par l'utilisateur dans la ligne de
commande courante.

- Comme pour une chaîne de caractères : employez la méthode ``toString()``. Les options sont retournées sous
  la forme d'une chaîne de caractère où les paires ``drapeau=valeur`` sont séparées par des espaces. La valeur
  d'une option qui n'a pas de paramètre est la chaîne "``TRUE``".

- Comme un tableau : employez la méthode ``toArray()``. Les options sont retournées dans un tableau de chaînes
  de caractères indexé par des nombres, les chaînes de drapeau sont suivies par les chaînes de paramètres
  éventuels.

- Comme une chaîne au format *JSON*\  : employez la méthode ``toJson()``.

- Comme une chaîne au format *XML*\  : employez la méthode ``toXml()``.

Dans toutes les méthodes de déchargement ci-dessus, la chaîne du drapeau est la première chaîne dans la liste
des alias correspondants. Par exemple, si les noms d'alias d'option étaient déclarés comme "``verbose|v``",
alors la première chaîne, "``verbose``", est employé comme nom de l'option. Le nom du drapeau d'option n'inclut
pas le tiret précédent.

.. _zend.console.getopt.fetching.remainingargs:

Extraction des arguments sans option
------------------------------------

Après que les arguments d'option et ainsi que les paramètres de la ligne de commande ont été analysés, il peut
exister des arguments additionnels restants. Vous pouvez interroger ces arguments en utilisant la méthode
``getRemainingArgs()``. Cette méthode renvoie un tableau de chaîne qui ne fait partie d'aucune option.

.. _zend.console.getopt.fetching.remainingargs.example:

.. rubric:: Utiliser getRemainingArgs()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setArguments(array('-p', 'p_parameter', 'nomdefichier'));
   $args = $opts->getRemainingArgs(); // retourne array('nomdefichier')

``Zend\Console\Getopt`` supporte la convention *GNU* selon laquelle un argument se composant d'un double-tiret
signifie la fin des options. Tous les arguments suivant celui-ci doivent être traités en tant qu'arguments sans
options. C'est utile si vous avez un argument sans options qui commence par un tiret. Par exemple : "``rm --
-nomdefichier-avec-tiret``".


