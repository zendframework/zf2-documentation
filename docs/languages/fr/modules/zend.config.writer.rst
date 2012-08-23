.. EN-Revision: none
.. _zend.config.writer.introduction:

Zend_Config_Writer
==================

``Zend_Config_Writer`` vous donne la possibilité d'écrire des fichiers de configuration à partir d'objets
``Zend_Config``. Il fonctionne avec des adaptateurs détachés du système et est donc très simple à utiliser.
Par défaut ``Zend_Config_Writer`` embarque trois adaptateurs, qui fonctionnent tous sur la base de fichiers. Vous
instanciez un rédacteur ("writer") avec des options spécifiques, qui peuvent être **filename** et **config**.
Ensuite vous pouvez appeler la méthode ``write()`` du rédacteur et le fichier de configuration est créé. Vous
pouvez aussi fournir ``$filename`` et ``$config`` directement à la méthode ``write()``. Actuellement les
rédacteurs suivants sont embarqués avec ``Zend_Config_Writer``\  :

- ``Zend_Config_Writer_Array``

- ``Zend_Config_Writer_Ini``

- ``Zend_Config_Writer_Xml``

Le rédacteur *INI* possède deux modes de rendu en fonction des sections. Par défaut la configuration de premier
niveau est toujours écrite dans des noms de section. En appelant ``$writer->setRenderWithoutSections();``, toutes
les options sont écrites dans l'espace de noms global du fichier *INI* et aucune section n'est appliquée.

De plus, ``Zend_Config_Writer_Ini`` a un paramètre optionnel additionnel **nestSeparator**, définissant le
caractère séparant les profondeurs d'imbrication. Par défaut il s'agit du point, comme ``Zend_Config_Ini``
l'accepte par défaut.

Lors de la modification ou la création d'objet ``Zend_Config``, il y a quelques informations à garder en
mémoire. Pour créer ou modifier une valeur, vous appelez simplement le réglage d'un paramètre d'un objet
``Zend_Config`` grâce à l'accesseur de paramètre ("**->**"). Pour créer une section à la racine ou pour créer
une branche, vous avez juste à créer un nouveau tableau (``$config->branch = array();``). Pour définir quelle
section en étend une autre, vous devez appeler la méthode ``setExtend()`` sur l'objet ``Zend_Config`` racine.

.. _zend.config.writer.example.using:

.. rubric:: Utilisation de Zend_Config_Writer

Cet exemple illustre une utilisation basique ``Zend_Config_Writer_Xml`` pour créer un nouveau fichier de
configuration :

.. code-block:: php
   :linenos:

   // Créer l'objet de configuration
   $config = new Zend_Config(array(), true);
   $config->production = array();
   $config->staging    = array();

   $config->setExtend('staging', 'production');

   $config->production->db = array();
   $config->production->db->hostname = 'localhost';
   $config->production->db->username = 'production';

   $config->staging->db = array();
   $config->staging->db->username = 'staging';

   // Ecrire le fichier de l'une des manières suivantes :
   // a)
   $writer = new Zend_Config_Writer_Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // b)
   $writer = new Zend_Config_Writer_Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // c)
   $writer = new Zend_Config_Writer_Xml();
   $writer->write('config.xml', $config);

Ceci créera un fichier de configuration *XML* avec les sections "production" et "staging", où "staging" étend
"production".

.. _zend.config.writer.modifying:

.. rubric:: Modifier une configuration existante

Cet exemple montre comment modifier un fichier de configuration existant :

.. code-block:: php
   :linenos:

   // Charger toutes les sections d'un fichier de configuration existant,
   // tout en évitant les sections étendues.
   $config = new Zend_Config_Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // Modifier une valeur
   $config->production->hostname = 'foobar';

   // Ecrire le fichier
   $writer = new Zend_Config_Writer_Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **Chargement d'un fichier de configuration**

   Lors du chargement d'un fichier de configuration existant afin de le modifier, il est très important de charger
   toutes les sections et d'éviter les sections étendues, évitant ainsi toute fusion de valeurs. Ceci est
   réalisé en fournissant l'option **skipExtends** au constructeur.

Pour tous les rédacteurs à base de fichiers (*INI*, *XML* et tableau *PHP*), en interne la méthode ``render()``
est utilisée pour construire la chaîne de configuration. Cette méthode peut être utilisée en dehors de la
classe si vous souhaitez accéder à une représentation textuelle de vos données de configuration.


