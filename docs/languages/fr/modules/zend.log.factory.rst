.. _zend.log.factory:

Utiliser la fabrique pour créer des logs
========================================

En plus de pouvoir instancier les objets directement, il est possible d'utiliser une fabrique, la méthode
``factory()`` d'une instance Log, et il est possible de configurer les objets d'écriture (writers) et leurs
filtres. En utilisant la fabrique, vous pouvez attacher plusieurs objets d'écriture dont la configuration peut
être passée sous forme de tableau ou d'objet ``Zend_Config``.

Un exemple:

.. code-block:: php
   :linenos:

   $logger = Zend_Log::factory(array(
       'timestampFormat' => 'Y-m-d',
       array(
           'writerName'   => 'Stream',
           'writerParams' => array(
               'stream'   => '/tmp/zend.log',
           ),
           'formatterName' => 'Simple',
           'formatterParams' => array(
               'format'   => '%timestamp%: %message% -- %info%',
           ),
           'filterName'   => 'Priority',
           'filterParams' => array(
               'priority' => Zend_Log::WARN,
           ),
       ),
       array(
           'writerName'   => 'Firebug',
           'filterName'   => 'Priority',
           'filterParams' => array(
               'priority' => Zend_Log::INFO,
           ),
       ),
   ));

Le code ci-dessus instancie un objet journal et 2 objets d'écriture dont un vers un fichier local, puis un vers
Firebug. Chacun possède un filtre sur la priorité avec un niveau maximum différent.

Les évènements sont journalisés avec le format de date ISO 8601 par défaut. Vous pouvez choisir votre propre
format avec l'option **timestampFormat**.

Chaque objet d'écriture support les options suivantes:

**writerName (requis)**
   Le nom "court" de l'objet d'écriture; le nom sans le préfixe. Voyez "writerNamespace" pour plus de détails,
   des exemples sont : "Mock", "Stream", "Firebug".

**writerParams (optionnel)**
   Tableau associatif de paramètre à utiliser à l'instanciation de l'objet d'écriture. Chaque méthode
   ``factory()`` fera suivre ces paramètres.

**writerNamespace (optionnel)**
   Le préfixe de classe ou espace de nom(namespace) à utiliser pour créer le nom de classe complet de l'objet
   d'écriture. Par défault : "Zend_Log_Writer".

**formatterName (optionnel)**
   Le nom "court" d'un formateur à utiliser sur l'objet d'écriture. Voyez "formatterNamespace" pour plus de
   détails. Exemples: "Simple", "Xml".

**formatterParams (optionnel)**
   Tableau associatif de paramètre à utiliser à l'instanciation de l'objet formateur. Chaque méthode
   ``factory()`` fera suivre ces paramètres.

**formatterNamespace (optionnel)**
   Le préfixe de classe ou espace de nom(namespace) à utiliser pour créer le nom de classe complet de l'objet
   formateur. Par défault : "Zend_Log_Formatter".

**filterName (optionnel)**
   Le nom "court" d'un filtre à utiliser sur l'objet d'écriture. Voyez "filterNamespace" pour plus de détails.
   Exemples: "Message", "Priority".

**filterParams (optionnel)**
   Tableau associatif de paramètre à utiliser à l'instanciation de l'objet filtre. Chaque méthode ``factory()``
   fera suivre ces paramètres.

**filterNamespace (optionnel)**
   Le préfixe de classe ou espace de nom(namespace) à utiliser pour créer le nom de classe complet de l'objet
   filtre. Par défault : "Zend_Log_Filter".

Chaque objet d'écriture et chaque filtre possède des options.

.. _zend.log.factory.writer-options:

Options pour les objets d'écriture
----------------------------------

.. _zend.log.factory.writer-options.db:

Zend_Log_Writer_Db Options
^^^^^^^^^^^^^^^^^^^^^^^^^^

**db**
   Une instance de ``Zend_Db_Adapter``

**table**
   Nom de la table à utiliser.

**columnMap**
   Tableau associatif de correspondance entre les noms des colonnes de la table et les champs des évènements du
   journal.

.. _zend.log.factory.writer-options.firebug:

Zend_Log_Writer_Firebug Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aucune option n'est acceptée par cet objet d'écriture.

.. _zend.log.factory.writer-options.mail:

Zend_Log_Writer_Mail Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.log.factory.writer-options.mail.table:

.. table:: Zend_Log_Writer_Mail Options

   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |Option            |Type de données|Valeur par défaut|Description                                                                                                                |
   +==================+===============+=================+===========================================================================================================================+
   |mail              |String         |Zend_Mail        |Une instance de Zend_Mail                                                                                                  |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |charset           |String         |iso-8859-1       |L'encodage pour le courriel                                                                                                |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |from              |String or Array|NULL             |Expéditeur du courriel. Les paramètres pour un type Array sont : email : adresse de l'expéditeur name : nom de l'expéditeur|
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |to                |String or Array|NULL             |Destinataire(s) du courriel                                                                                                |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |cc                |String or Array|NULL             |Destinataire(s) en copie(s) du courriel                                                                                    |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |bcc               |String or Array|NULL             |Destinataire(s) en copie(s) cachée(s) du courriel                                                                          |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |subject           |String         |NULL             |Sujet du courriel                                                                                                          |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |subjectPrependText|String         |NULL             |Un résumé du nombre de chaque niveau d'erreurs sera ajouté à la suite du sujet du courriel                                 |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |layout            |String         |NULL             |Une instance de Zend_Layout                                                                                                |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |layoutOptions     |Array          |NULL             |Voir la section                                                                                                            |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+
   |layoutFormatter   |String         |NULL             |Une instance de Zend_Log_Formatter_Interface                                                                               |
   +------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------+

.. _zend.log.factory.writer-options.mock:

Zend_Log_Writer_Mock Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aucune option n'est acceptée par cet objet d'écriture.

.. _zend.log.factory.writer-options.null:

Zend_Log_Writer_Null Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aucune option n'est acceptée par cet objet d'écriture.

.. _zend.log.factory.writer-options.stream:

Zend_Log_Writer_Stream Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**stream|url**
   Un identifiant de flux *PHP* valide vers lequel journaliser.

**mode**
   Le mode I/O (Lecture/Ecriture) à utiliser; défaut : "a" pour "append".

.. _zend.log.factory.writer-options.syslog:

Zend_Log_Writer_Syslog Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**application**
   Nom de l'application utilisé par le journaliseur syslog.

**facility**
   Facility utilisée par le journal syslog.

.. _zend.log.factory.writer-options.zendmonitor:

Zend_Log_Writer_ZendMonitor Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aucune option n'est acceptée par cet objet d'écriture.

.. _zend.log.factory.filter-options:

Options des filtres
-------------------

.. _zend.log.factory.filter-options.message:

Zend_Log_Filter_Message Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**regexp**
   Expression régulière à faire correspondre par rapport au message du journal.

.. _zend.log.factory.filter-options.priority:

Zend_Log_Filter_Priority Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**priority**
   La priorité maximale à journaliser.

**operator**
   L'opérateur de comparaison (supérieur ou inférieur) à utiliser pour la comparaison, "<=" est utilisé par
   défaut.

.. _zend.log.factory.filter-options.suppress:

Zend_Log_Filter_Suppress Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aucune option n'est acceptée par cet objet d'écriture.

.. _zend.log.factory.custom:

Créer des objets d'écriture et des filtres configurés
-----------------------------------------------------

SI vous souhaitez créer vos propres objets d'écriture du journal, ou vos propres filtres, il est possible de les
rendre compatibles avec ``Zend_Log::factory()`` facilement.

Vous devez au minimum implémenter ``Zend_Log_FactoryInterface``, qui attend une méthode statique ``factory()``
accéptant un seul argument, ``$config``, de types tableau ou instance de ``Zend_Config``. Si vos objets étendent
``Zend_Log_Writer_Abstract``, ou vos filtres étendent ``Zend_Log_Filter_Abstract``, alors ce sera tout.

Après, définissez la correspondance entre les options de configuration et les arguments du constructeur. Par
exemple :

.. code-block:: php
   :linenos:

   class My_Log_Writer_Foo extends Zend_Log_Writer_Abstract
   {
       public function __construct($bar, $baz)
       {
           // ...
       }

       public static function factory($config)
       {
           if ($config instanceof Zend_Config) {
               $config = $config->toArray();
           }
           if (!is_array($config)) {
               throw new Exception(
                   'factory attend un tableau ou un Zend_Config'
               );
           }

           $default = array(
               'bar' => null,
               'baz' => null,
           );
           $config = array_merge($default, $config);

           return new self(
               $config['bar'],
               $config['baz']
           );
       }
   }

Aussi, il est possible d'appeler les setters après l'instanciation, mais avant de retourner l'instance:

.. code-block:: php
   :linenos:

   class My_Log_Writer_Foo extends Zend_Log_Writer_Abstract
   {
       public function __construct($bar = null, $baz = null)
       {
           // ...
       }

       public function setBar($value)
       {
           // ...
       }

       public function setBaz($value)
       {
           // ...
       }

       public static function factory($config)
       {
           if ($config instanceof Zend_Config) {
               $config = $config->toArray();
           }
           if (!is_array($config)) {
               throw new Exception(
                   'factory attend un tableau ou un Zend_Config'
               );
           }

           $writer = new self();
           if (isset($config['bar'])) {
               $writer->setBar($config['bar']);
           }
           if (isset($config['baz'])) {
               $writer->setBaz($config['baz']);
           }
           return $writer;
       }
   }


