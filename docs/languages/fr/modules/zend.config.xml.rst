.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` permet aux développeurs de stocker des données de configuration dans un format simple *XML*
et de les lire grâce à une syntaxe de propriétés d'objets imbriquées. Le nom de l'élément racine du fichier
*XML* n'a pas d'importance et peut être nommé arbitrairement. Le premier niveau des éléments *XML* correspond
aux sections des données de configuration. Le format *XML* supporte l'organisation hiérarchique par
l'emboîtement des éléments *XML* à l'intérieur des éléments de niveau section. Le contenu d'un élément
*XML* de niveau le plus bas correspond aux données de configuration. L'héritage des sections est supportée par
un attribut spécial de *XML* nommé **extends**, et la valeur de cet attribut correspond à la section de laquelle
des données doivent être héritées.

.. note::

   **Type retourné**

   Les données de configuration lues grâce à ``Zend_Config_Xml`` sont toujours des chaînes de caractères. La
   conversion des données à partir des chaînes de caractères vers d'autres types de données est laissée aux
   développeurs en fonction de leurs besoins.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Utiliser Zend_Config_Xml

Cet exemple illustre une utilisation de base de ``Zend_Config_Xml`` pour le chargement des données de
configuration à partir d'un fichier *XML*. Dans cet exemple il y a des données de configuration pour un
environnement de production et pour un environnement de test. Puisque les données de configuration de
l'environnement de test sont très semblables à celles de la production, la section de test hérite de la section
de production. Dans ce cas, la décision est arbitraire et pourrait avoir été écrite réciproquement, avec la
section de production héritant de la section de test, bien que ceci ne doit pas être le cas pour des situations
plus complexes. Supposons, que les données suivantes de configuration sont contenues dans
``/chemin/vers/config.xml``\  :

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter>pdo_mysql</adapter>
               <params>
                   <host>db.example.com</host>
                   <username>dbuser</username>
                   <password>secret</password>
                   <dbname>dbname</dbname>
               </params>
           </database>
       </production>
       <test extends="production">
           <database>
               <params>
                   <host>dev.example.com</host>
                   <username>devuser</username>
                   <password>devsecret</password>
               </params>
           </database>
       </test>
   </configdata>

Ensuite, supposons que le développeur a besoin des données de configuration de test issues du fichier *XML*. Il
est facile de charger ces données en indiquant le fichier *XML* et la section de test :

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/chemin/vers/config.xml', 'test');

   echo $config->database->params->host;   // affiche "dev.example.com"
   echo $config->database->params->dbname; // affiche "dbname"

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Utilisation des attributs de balise avec Zend_Config_Xml

``Zend_Config_Xml`` supporte aussi 2 autres manières de définir des noeuds dans la configuration. Celles-ci
utilisent les attributs de balises. Puisque les attributs **extends** et **value** sont des mots réservés (ce
dernier par la seconde manière d'utiliser les attributs), ils ne doivent pas être utilisés. La première
manière d'utiliser les attributs est de les ajouter au noeud parent, ils seront ainsi interprétés en tant
qu'enfant de ce noeud :

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com"
                       username="dbuser"
                       password="secret"
                       dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com"
                       username="devuser"
                       password="devsecret"/>
           </database>
       </staging>
   </configdata>

La seconde manière ne permet pas vraiment de raccourcir la configuration, mais la rend plus facile à maintenir
puisque vous n'avez pas à écrire les noms de balises deux fois. Vous créez simplement une balise vide ayant sa
valeur dans **value**\  :

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter value="pdo_mysql"/>
               <params>
                   <host value="db.example.com"/>
                   <username value="dbuser"/>
                   <password value="secret"/>
                   <dbname value="dbname"/>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host value="dev.example.com"/>
                   <username value="devuser"/>
                   <password value="devsecret"/>
               </params>
           </database>
       </staging>
   </configdata>

.. note::

   **Chaînes de caractères XML**

   ``Zend_Config_Xml`` est capable de charger une chaîne de caractères *XML* directement, par exemple si elle est
   issue d'une base de données. La chaîne est fournie en tant que premier paramètre du constructeur et doit
   commencer par les caractères **'<?xml'**\  :

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config>
          <production>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      $config = new Zend_Config_Xml($string, 'staging');

.. note::

   **Espace de noms XML de Zend_Config**

   ``Zend_Config`` possède son propre espace de noms *XML*, qui ajoute des fonctionnalités additionnelles lors du
   processus d'analyse. Pour tirer avantage de celui-ci, vous devez définir l'espace de noms avec l'*URI*
   ``http://framework.zend.com/xml/zesnd-config-xml/1.0/`` dans votre noeud racine de configuration.

   Avec l'espace de noms activé, vous pouvez maintenant utiliser les constantes *PHP* à l'intérieur de vos
   fichiers de configuration. De plus l'attribut **extends** a été déplacé dans ce nouvel espace de noms et
   déprécié de l'espace de noms ``NULL``. Il en sera complétement effacé dans Zend Framework 2.0.

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config xmlns:zf="http://framework.zend.com/xml/zend-config-xml/1.0/">
          <production>
              <includePath>
                  <zf:const zf:name="APPLICATION_PATH"/>/library</includePath>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging zf:extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      define('APPLICATION_PATH', dirname(__FILE__));
      $config = new Zend_Config_Xml($string, 'staging');

      echo $config->includePath; // Affiche "/var/www/something/library"


