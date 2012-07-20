.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

``Zend_Config_Ini`` permet aux développeurs de stocker des données de configuration dans le format familier d'un
fichier *INI* et de les lire dans l'application en employant une syntaxe de propriétés d'objet imbriquées. Le
format *INI* est spécialisé pour fournir à la fois la capacité d'avoir une hiérarchie des données de
configuration et permettre l'héritage entre les sections de données de configuration. La hiérarchie des données
de configuration est supportée grâce au fractionnement des clés à l'aide de points (**.**). Une section peut
être étendue ou héritée d'une autre section en suivant le nom de section avec le caractère de deux points
(**:**) et le nom de la section de laquelle des données doivent être héritées.

.. note::

   **Analyse d'un fichier INI**

   ``Zend_Config_Ini`` utilise la fonction `parse_ini_file()`_ de *PHP*. Veuillez prendre connaissance de la
   documentation pour appréhender ses comportements spécifiques, qui se propagent à ``Zend_Config_Ini``, tel que
   la façon dont les valeurs spéciales : ``TRUE``, ``FALSE``, "yes", "no" et ``NULL`` sont manipulées.

.. note::

   **Séparateur de clé**

   Par défaut, le séparateur de clé est le caractère point (**.**), cependant cela peut être changé en
   changeant la clé ``nestSeparator`` de ``$options`` en construisant l'objet ``Zend_Config_Ini``. Par exemple :

   .. code-block:: php
      :linenos:

      $options['nestSeparator'] = ':';
      $options = new Zend_Config_Ini('/chemin/vers/config.ini',
                                     'test',
                                     $options);

.. _zend.config.adapters.ini.example.using:

.. rubric:: Utiliser Zend_Config_Ini

Cet exemple illustre une utilisation de base de ``Zend_Config_Ini`` pour le chargement des données de
configuration à partir d'un fichier *INI*. Dans cet exemple il y a des données de configuration pour un
environnement de production et pour un environnement de test. Puisque les données de configuration de
l'environnement de test sont très semblables à celles de la production, la section de test hérite de la section
de production. Dans ce cas, la décision est arbitraire et pourrait avoir été écrite réciproquement, avec la
section de production héritant de la section de test, bien que ceci ne doit pas être le cas pour des situations
plus complexes. Supposons, que les données suivantes de configuration sont contenues dans
``/chemin/vers/config.ini``\  :

.. code-block:: ini
   :linenos:

   ; Données de configuration du site de production
   [production]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; Données de configuration du site de test héritant du site
   ; de production et surchargeant les clés nécessaires
   [test : production]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret

Ensuite, supposons que le développeur ait besoin des données de configuration de test issues du fichier *INI*. Il
est facile de charger ces données en indiquant le fichier *INI* et la section de test :

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/chemin/vers/config.ini', 'test');

   echo $config->database->params->host;   // affiche "dev.example.com"
   echo $config->database->params->dbname; // affiche "dbname"

.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Paramètres du constructeur de Zend_Config_Ini

      +----------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Paramètres                  |Notes                                                                                                                                                                                                                                                                                     |
      +============================+==========================================================================================================================================================================================================================================================================================+
      |$filename                   |Le fichier INI à charger.                                                                                                                                                                                                                                                                 |
      +----------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section                    |La [section] dans le fichier INI qui doit être chargé. L'affectation de NULL à ce paramètre chargera toutes les sections. Alternativement, un tableau de noms de section peut être fourni pour charger des sections multiples.                                                            |
      +----------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$options (par défault FALSE)|Tableau d'options. Les clés suivantes sont supportées : allowModifications : Mettre à TRUE pour permettre la modification en mémoire des données de configuration chargées. Par défaut à FALSE. nestSeparator : Caractère à utiliser en tant que séparateur d'imbrication. Par défaut ".".|
      +----------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://fr.php.net/parse_ini_file
