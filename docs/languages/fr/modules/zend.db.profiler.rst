.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Introduction
------------

``Zend_Db_Profiler`` peut être activé pour permettre le profilage de requête. Les profils incluent les requêtes
exécutées par l'adaptateur, ainsi que leur temps d'exécution, permettant l'inspection des requêtes qui ont
été exécutées sans avoir besoin de rajouter le code spécifique de débogage aux classes. L'utilisation
avancée permet aussi au développeur de filtrer quelles requêtes il souhaite profiler.

Le profileur s'active soit en passant une directive au constructeur de l'adaptateur, soit en spécifiant à
l'adaptateur de l'activer plus tard.

.. code-block:: php
   :linenos:

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test',
       'profiler' => true  // active le profileur ;
                           // mettre à false pour désactiver
                           // (désactivé par défaut)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // stoppe le profileur :
   $db->getProfiler()->setEnabled(false);

   // active le profileur :
   $db->getProfiler()->setEnabled(true);

La valeur de l'option ``profiler`` est souple. Elle est interprétée différemment suivant son type. La plupart du
temps, vous devriez simplement utiliser une variable booléenne, mais d'autres valeurs vous permettent de
personnaliser le comportement du profileur.

Un argument booléen active le profileur si c'est une valeur ``TRUE``, ou le désactive si ``FALSE``. La classe de
profileur est celle par défaut, par exemple ``Zend_Db_Profiler``.

.. code-block:: php
   :linenos:

   $params['profiler'] = true;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Une instance d'un objet profileur fait que l'adaptateur utilise cet objet. L'objet doit être de type
``Zend_Db_Profiler`` ou une sous-classe. L'activation du profileur est faite séparément.

.. code-block:: php
   :linenos:

   $profiler = Mon_Db_Profiler();
   $profiler->setEnabled(true);
   $params['profiler'] = $profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

L'argument peut être un tableau associatif contenant une ou toutes les clés suivantes : "``enabled``",
"``instance``", et "``class``". Les clés "``enabled``" et "``instance``" correspondent aux types booléen et
instance décrites ci-dessus. La clé "``class``" est utilisée pour nommer une classe à prendre en tant que
profileur personnalisé. La classe doit être de type ``Zend_Db_Profiler`` ou une sous-classe. La classe est
instanciée sans aucun argument de constructeur. L'option "``class``" est ignorée quand l'option "``instance``"
est fournie.

.. code-block:: php
   :linenos:

   $params['profiler'] = array(
       'enabled' => true,
       'class'   => 'Mon_Db_Profiler'
   );
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Enfin, l'argument peut être un objet de type ``Zend_Config`` contenant des propriétés, qui sont traitées comme
les clés de tableaux décrites ci-dessus. Par exemple, un fichier "``config.ini``" peut contenir les données
suivantes :

.. code-block:: ini
   :linenos:

   [main]
   db.profiler.class   = "Mon_Db_Profiler"
   db.profiler.enabled = true

Cette configuration peut être appliquée par le code *PHP* suivant :

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('config.ini', 'main');
   $params['profiler'] = $config->db->profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

La propriété "``instance``" peut être utilisée comme ceci :

.. code-block:: php
   :linenos:

   $profiler = new Mon_Db_Profiler();
   $profiler->setEnabled(true);
   $configData = array(
       'instance' => $profiler
       );
   $config = new Zend_Config($configData);
   $params['profiler'] = $config;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

.. _zend.db.profiler.using:

Utiliser le profileur
---------------------

A n'importe quel moment, vous pouvez récupérer le profileur en utilisant la méthode ``getProfiler()`` de
l'adaptateur :

.. code-block:: php
   :linenos:

   $profileur = $db->getProfiler();

Ceci retourne une instance de ``Zend_Db_Profiler``. Avec cette instance, le développeur peut examiner les
requêtes en utilisant un éventail de méthodes :

- ``getTotalNumQueries()`` retourne le nombre total de requêtes profilées.

- ``getTotalElapsedSecs()`` retourne le nombre total de secondes écoulées pour chaque requête profilée.

- ``getQueryProfiles()`` retourne un tableau de tous les profils de requêtes.

- ``getLastQueryProfile()`` retourne le profil de requête le plus récent, peut importe si la requête à fini de
  s'exécuter ou pas (si l'exécution n'est pas finie, le temps de fin sera ``NULL``).

- ``clear()`` nettoie tous les anciens profils de la pile.

La valeur de retour de ``getLastQueryProfile()`` et les éléments individuels de ``getQueryProfiles()`` sont des
objets de type ``Zend_Db_Profiler_Query`` qui permettent d'inspecter les requêtes :

- ``getQuery()`` retourne le *SQL* de la requête sous forme de texte. Le texte de *SQL* d'une requête préparée
  avec des paramètres est le texte au moment où la requête a été préparée, donc il contient les emplacements
  de paramètre, mais pas les valeurs utilisées quand la déclaration est exécutée.

- ``getQueryParams()`` retourne un tableau des valeurs de paramètres utilisées lors de l'exécution d'une
  requête préparée. Ceci inclue à la fois les paramètres attachés et les arguments de la méthode
  ``execute()``. Les clés du tableau sont les positions (base 1) ou les noms des paramètres.

- ``getElapsedSecs()`` retourne le nombre de secondes d'exécution de la requête.

L'information que ``Zend_Db_Profiler`` fourni est utile pour profiler des goulots d'étranglement dans les
applications, ainsi que pour déboguer les requêtes qui viennent d'être exécutées. Par exemple, pour voir la
dernière requête qui vient de s'exécuter :

.. code-block:: php
   :linenos:

   $query = $profileur->getLastQueryProfile();
   echo $query->getQuery();

Si une page se génère lentement, utilisez le profileur pour déterminer le nombre total de requêtes, et ensuite
passer d'une requête à l'autre pour voir laquelle a été la plus longue :

.. code-block:: php
   :linenos:

   $tempsTotal       = $profileur->getTotalElapsedSecs();
   $nombreRequetes   = $profileur->getTotalNumQueries();
   $tempsLePlusLong  = 0;
   $requeteLaPlusLongue = null;

   foreach ($profileur->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $tempsLePlusLong) {
           $tempsLePlusLong  = $query->getElapsedSecs();
           $requeteLaPlusLongue = $query->getQuery();
       }
   }

   echo 'Exécution de '
      . $nombreRequetes
      . ' requêtes en '
      . $tempsTotal
      . ' secondes' . "\n";
   echo 'Temps moyen : '
      . $tempsTotal / $nombreRequetes
      . ' secondes' . "\n";
   echo 'Requêtes par seconde: '
      . $nombreRequetes / $tempsTotal
      . ' seconds' . "\n";
   echo 'Requête la plus lente (secondes) : '
      . $tempsLePlusLong . "\n";
   echo "Requête la plus lente (SQL) : \n"
      . $requeteLaPlusLongue . "\n";

.. _zend.db.profiler.advanced:

Utilisation avancée du profileur
--------------------------------

En plus de l'inspection de requête, le profileur permet aussi au développeur de filtrer quelles requêtes il veut
profiler. Les méthodes suivantes fonctionnent avec une instance de ``Zend_Db_Profiler``\  :

.. _zend.db.profiler.advanced.filtertime:

Filtrer par temps d'exécution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterElapsedSecs()`` permet au développeur de définir un temps minimum d'exécution de la requête avant
que celle-ci soit profilée. Pour retirer le filtre, passez une valeur ``NULL`` à la méthode.

.. code-block:: php
   :linenos:

   // Seules les requêtes qui durent au moins 5 secondes sont profilées :
   $profileur->setFilterElapsedSecs(5);

   // Profil de toutes les requêtes, peu importe leur durée :
   $profileur->setFilterElapsedSecs(null);

.. _zend.db.profiler.advanced.filtertype:

Filtrer par type de requête
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterQueryType()`` permet au développeur de définir quels types de requêtes doivent être profilées ;
pour profiler des types multiples vous pouvez utiliser le OU logique. Les types de requêtes sont définis sous
forme de constantes de ``Zend_Db_Profiler``\  :

- ``Zend_Db_Profiler::CONNECT``\  : opérations de connexion ou de sélection de base de données.

- ``Zend_Db_Profiler::QUERY``\  : requête générale qui ne correspond pas aux autres types.

- ``Zend_Db_Profiler::INSERT``\  : toute requête qui ajoute des données dans la base de données, généralement
  du *SQL* *INSERT*.

- ``Zend_Db_Profiler::UPDATE``\  : toute requête qui met à jour des données, généralement du *SQL* *UPDATE*.

- ``Zend_Db_Profiler::DELETE``\  : toute requête qui efface des données, généralement du *SQL* ``DELETE``.

- ``Zend_Db_Profiler::SELECT``\  : toute requête qui récupère des données, généralement du *SQL* *SELECT*.

- ``Zend_Db_Profiler::TRANSACTION``\  : toute requête qui concerne des opérations de transaction, comme start
  transaction, commit, ou rollback.

Comme avec ``setFilterElapsedSecs()``, vous pouvez retirer tous les filtres en passant ``NULL`` comme unique
argument.

.. code-block:: php
   :linenos:

   // profile uniquement les requêtes SELECT
   $profileur->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // profile les requêtes SELECT, INSERT, et UPDATE
   $profileur->setFilterQueryType(Zend_Db_Profiler::SELECT
                                | Zend_Db_Profiler::INSERT
                                | Zend_Db_Profiler::UPDATE);

   // profile les requêtes DELETE
   $profileur->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Efface tous les filtres
   $profileur->setFilterQueryType(null);

.. _zend.db.profiler.advanced.getbytype:

Récupérer les profils par type de requête
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Utiliser ``setFilterQueryType()`` peut réduire les profils générés. Cependant il est parfois utile de garder
tous les profils et voir uniquement ceux dont on a besoin, à un moment donné. Une autre possibilité de
``getQueryProfiles()`` est qu'il est possible de filtrer à la volée, en passant un type de requête (ou une
combinaison logique de types de requête) comme premier argument ; voir :ref:`cette section
<zend.db.profiler.advanced.filtertype>` pour la liste des constantes de types de requête.

.. code-block:: php
   :linenos:

   // Récupère uniquement les profils des requêtes SELECT
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Récupère uniquement les profils des requêtes :
   // SELECT, INSERT, et UPDATE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT
                                         | Zend_Db_Profiler::INSERT
                                         | Zend_Db_Profiler::UPDATE);

   // Récupère uniquement les profils des requêtes DELETE
   // (on peut donc comprendre pourquoi les données disparaissent)
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);

.. _zend.db.profiler.profilers:

Profileurs spécialisés
----------------------

Un profileur spécialisé est un objet qui hérite de ``Zend_Db_Profiler``. Les profileurs spécialisés traitent
les informations de profilage de manière spécifique.

.. include:: zend.db.profiler.firebug.rst

