.. _zend.tool.framework.architecture:

Architektur
===========

.. _zend.tool.framework.architecture.registry:

Registry
--------

Weil Provider und Manifeste von überall im ``include_path`` kommen können, wird eine Registry angeboten um den
Zugriff auf die verschiedenen Teile der Toolchain zu vereinfachen. Diese Registry wird in Komponenten eingefügt
die registry-aware sind, und damit Abhängigkeiten entfernen können, wenn das notwendig ist. Die meisten
Abhängigkeiten die in der Registry registriert werden sind Unter-Komponenten spezifische Repositories.

Das Interface für die Registry besteht aus der folgenden Definition:

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Registry_Interface
   {
       public function setClient(Zend_Tool_Framework_Client_Abstract $client);
       public function getClient();
       public function setLoader(Zend_Tool_Framework_Loader_Abstract $loader);
       public function getLoader();
       public function setActionRepository(
           Zend_Tool_Framework_Action_Repository $actionRepository
       );
       public function getActionRepository();
       public function setProviderRepository(
           Zend_Tool_Framework_Provider_Repository $providerRepository
       );
       public function getProviderRepository();
       public function setManifestRepository(
           Zend_Tool_Framework_Manifest_Repository $manifestRepository
       );
       public function getManifestRepository();
       public function setRequest(Zend_Tool_Framework_Client_Request $request);
       public function getRequest();
       public function setResponse(Zend_Tool_Framework_Client_Response $response);
       public function getResponse();
   }

Die verschiedenen Objekte welche die Registry managt werden in deren betreffenden Kapiteln besprochen.

Klassen welche Registry-aware sind sollten ``Zend_Tool_Framework_Registry_EnabledInterface`` implementieren. Dieses
Interface erlaubt hauptsächlich die Initialisierung der Registry in der Zielklasse.

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Registry_EnabledInterface
   {
       public function setRegistry(
           Zend_Tool_Framework_Registry_Interface $registry
       );
   }

.. _zend.tool.framework.architecture.providers:

Provider
--------

``Zend_Tool_Framework_Provider`` repräsentiert den funktionalen oder "möglichen" Aspekt des Frameworks.
Grundsätzlich bietet ``Zend_Tool_Framework_Provider`` das Interface um "Provider" zu erstellen, oder Teile für
Werkzeug-Funktionalität die aufgerufen werden können und in der ``Zend_Tool_Framework`` Toolchain verwendet
werden. Die einfache Natur der Implementation dieses Provider Interfaces erlaubt es dem Entwickler ein
"One-Stop-Shop" für das Hinzufügen von Funktionalitäten oder Möglichkeiten zu ``Zend_Tool_Framework``.

Das Provider Interface ist ein leeres Interface und erzwingt keine Methoden (das ist das Marker Interface Pattern):

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Provider_Interface
   {}

Oder, wenn man das will, kann man den Basis (oder Abstrakten) Provider implementieren, welcher einem Zugriff auf
``Zend_Tool_Framework_Registry`` bietet:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Interface,
                  Zend_Tool_Registry_EnabledInterface
   {
       protected $_registry;
       public function setRegistry(
           Zend_Tool_Framework_Registry_Interface $registry
       );
   }

.. _zend.tool.framework.architecture.loaders:

Loader
------

Der Zweck eines Loaders ist es Provider und Manifest Datei zu finden die Klassen enthalten welche entweder
``Zend_Tool_Framework_Provider_Interface`` oder ``Zend_Tool_Framework_Manifest_Interface`` implementieren. Sobald
diese Dateien vom Loader gefunden wurden, werden die Provider in das Provider Repository geladen und die Manifest
Metadaten in das Manifest Repository.

Um einen Loader zu implementieren muß man die folgende abstrakte Klasse erweitern:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Loader_Abstract
   {

       abstract protected function _getFiles();

       public function load()
       {
           /** ... */
       }
   }

Die ``_getFiles()`` Methode sollte ein Array von Dateien zurückgeben (absolute Pfade). Der mit Zend Framework
ausgelieferte Loader wird IncludePath Loader genannt. Standardmäßig verwendet das Tooling Framework einen Loader
der auf dem Include Pfad basiert um Dateien zu finden die Provider oder Manifest Metadaten Objekte enthalten
können. ``Zend_Tool_Framework_Loader_IncludePathLoader`` sucht, ohne irgendeine Option, nach Dateien im Include
Pfad die mit ``Mainfest.php``, ``Tool.php`` oder ``Provider.php`` enden. Sobald Sie gefunden wurden, werden Sie
(durch die ``load()`` Methode von ``Zend_Tool_Framework_Loader_Abstract``) getestet um zu erkennen ob Sie
irgendeines der unterstützten Interfaces implementieren. Wenn Sie das tun, wird eine Instanz der gefundenen Klasse
instanziiert, und dann dem richtigen Repository angehängt.

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Loader_IncludePathLoader
       extends Zend_Tool_Framework_Loader_Abstract
   {

       protected $_filterDenyDirectoryPattern = '.*(/|\\\\).svn';
       protected $_filterAcceptFilePattern = '.*(?:Manifest|Provider)\.php$';

       protected function _getFiles()
       {
           /** ... */
       }
   }

Wie man sieht, durchsucht der IncludePath Loader alle include_paths nach den Dateien die
``$_filterAcceptFilePattern`` entsprechen und ``$_filterDenyDirectoryPattern`` **nicht** entsprechen.

.. _zend.tool.framework.architecture.manifests:

Manifests
---------

Kurz gesagt, sollte ein Manifest spezielle oder eigene Metadaten enthalten, die für jeden Provider oder Client
nützlich sind, sowie dafür verantwortlich sein alle zusätzlichen Provider in das Provider Repository zu laden.

Um Metadaten in ein Manifest Repository einzuführen, müssen alle das leere
``Zend_Tool_Framework_Manifest_Interface`` implementieren, und eine ``getMetadata()`` Methode anbieten die ein
Array von Objekten zurückgeben sollte, welches ``Zend_Tool_Framework_Manifest_Metadata`` implementiert.

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Manifest_Interface
   {
       public function getMetadata();
   }

Metadaten Objekte werden in das Manifest Repository (``Zend_Tool_Framework_Manifest_Repository``) geladen (durch
einen wie unten definierten Loader). Manifeste werden ausgeführt nachdem alle Provider gefunden und in das
Provider Repository geladen wurden. Das sollte es Manifeste erlauben Metadaten Objekte, basierend auf dem was
aktuell im Provider Repository ist, zu erstellen.

Es gibt ein paar andere Metadaten Klassen die dazu verwendet werden können um Metadaten zu beschreiben.
``Zend_Tool_Framework_Manifest_Metadata`` ist das Basis Metadaten Objekt. Wie man durch das folgende Code Snippet
sieht, ist die grundsätzliche Metadaten Klasse recht leichtgewichtig und von Natur aus abstrakt:

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Manifest_Basic
   {

       protected $_type        = 'Global';
       protected $_name        = null;
       protected $_value       = null;
       protected $_reference   = null;

       public function getType();
       public function getName();
       public function getValue();
       public function getReference();
       /** ... */
   }

Es gibt andere eingebaute Metadaten Klassen für das beschreiben von spezialisierteren Metadaten:
``ActionMetadata`` und ``ProviderMetadata``. Diese Klassen helfen dabei Metadaten detailierter zu beschreiben die
spezifisch für Actions oder Provider ist, und von der Referenz wird erwartet das Sie entweder eine Referenz zu
einer Action oder einem Provider ist. Diese Klassen werden im folgenden Code Snippet beschrieben.

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Manifest_ActionMetadata
       extends Zend_Tool_Framework_Manifest_Metadata
   {

       protected $_type = 'Action';
       protected $_actionName = null;

       public function getActionName();
       /** ... */
   }

   class Zend_Tool_Framework_Manifest_ProviderMetadata
       extends Zend_Tool_Framework_Manifest_Metadata
   {

       protected $_type = 'Provider';
       protected $_providerName  = null;
       protected $_actionName    = null;
       protected $_specialtyName = null;

       public function getProviderName();
       public function getActionName();
       public function getSpecialtyName();
       /** ... */
   }

Der 'Type' in diesen Klassen wird verwendet um den Typ der Metadaten zu beschreiben für den das Objekt
verantwortlich ist. Im Fall von ``ActionMetadata`` würde der Typ 'Action' sein, und für ``ProviderMetadata`` ist
der Typ natürlich 'Provider'. Diese Typen der Metadaten werden enthalten auch zusätzliche strukturierte
Informationen, sowohl über das "Ding" das Sie beschreiben, als auch über das Objekt (das ``getReference()``) auf
das Sie mit diesen neuen Metadaten referenzieren.

Um einen eigenen Metadaten Typ zu erstellen, müssen alle die grundsätzliche
``Zend_Tool_Framework_Manifest_Metadata`` Klasse erweitern und diese neuen Metadaten Objekte über die lokale
Manifest Klasse oder das Objekt zurückgeben. Diese Benutzerbasierten Klassen werden alle im Manifest Repository
leben.

Sobald diese Metadaten Objekte im Repository sind gibt es zwei unterschiedliche Methoden die verwendet werden
können um nach Ihnen im Repository zu suchen.

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Manifest_Repository
   {
       /**
        * To use this method to search, $searchProperties should contain the names
        * and values of the key/value pairs you would like to match within the
        * manifest.
        *
        * For Example:
        *     $manifestRepository->findMetadatas(array(
        *         'action' => 'Foo',
        *         'name'   => 'cliActionName'
        *         ));
        *
        * Will find any metadata objects that have a key with name 'action' value
        * of 'Foo', AND a key named 'name' value of 'cliActionName'
        *
        * Note: to either exclude or include name/value pairs that exist in the
        * search critera but do not appear in the object, pass a bool value to
        * $includeNonExistentProperties
        */
       public function findMetadatas(Array $searchProperties = array(),
                                     $includeNonExistentProperties = true);

       /**
        * The following will return exactly one of the matching search criteria,
        * regardless of how many have been returned. First one in the manifest is
        * what will be returned.
        */
       public function findMetadata(Array $searchProperties = array(),
                                    $includeNonExistentProperties = true)
       {
           $metadatas = $this->getMetadatas($searchProperties,
                                            $includeNonExistentProperties);
           return array_shift($metadatas);
       }
   }

Wenn man sich die Suchmethoden von oben anschaut, erlauben die Signaturen eine extrem flexible Suche. Um ein
Metadaten Objekt zu finden, muss man einfach ein Array von passenden Abhängigkeiten über ein Array anhängen.
Wenn auf die Daten über den Property Accessor zugegriffen werden kann (die ``getSomething()`` Methoden
implementieren das Metadaten Objekt), dann wird es an den Benutzer als "gefundenes" Metadaten Objekt zurück
gegeben.

.. _zend.tool.framework.architecture.clients:

Clienten
--------

Clienten sind das Interface welches einen Benutzer oder ein externes Tool in das System von ``Zend_Tool_Framework``
verknüpft. Clienten können in allen Formen und Größen vorkommen: *RPC* Endpunkte, Kommandozeilen Interface,
oder sogar ein Web Interface. ``Zend_Tool`` hat das Kommandozeilen Interface als standard Interface für die
Interaktion mit dem ``Zend_Tool_Framework`` System implementiert.

Um einen Client zu implementieren, muss man die folgende abstrakte Klasse erweitern:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Client_Abstract
   {
       /**
        * This method should be implemented by the client implementation to
        * construct and set custom loaders, request and response objects.
        *
        * (not required, but suggested)
        */
       protected function _preInit();

       /**
        * This method should be implemented by the client implementation to parse
        * out and setup the request objects action, provider and parameter
        * information.
        */
       abstract protected function _preDispatch();

       /**
        * This method should be implemented by the client implementation to take
        * the output of the response object and return it (in an client specific
        * way) back to the Tooling Client.
        *
        * (not required, but suggested)
        */
       abstract protected function _postDispatch();
   }

Wie man sieht gibt es 1 Methode benötigte Methode um die Notwendigkeiten eines Cliente zu erfüllen (zwei andere
sind empfohlen), die Initialisierung, Vorbehandlung (pre handling) und Nachbehandlung (post handling). Für eine
tiefere Studie darüber wie das Kommandozeilen Interface arbeitet, schauen Sie bitte im `Source Code`_.



.. _`Source Code`: http://framework.zend.com/svn/framework/standard/trunk/library/Zend/Tool/Framework/Client/Console.php
