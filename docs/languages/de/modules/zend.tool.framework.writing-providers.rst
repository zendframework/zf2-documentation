.. _zend.tool.framework.writing-providers:

Erstellen von Providern für die Verwendung mit Zend_Tool_Framework
==================================================================

Generell ist ein Provider für sich selbst nichts mehr als die Shell für einen Entwickler um einige Fähigkeiten
zu bündeln die man mit dem Kommandozeilen (oder einem anderen) Client ausliefern will. Das ist analog zu dem was
ein "Controller" in einer *MVC* Anwendung ist.

.. _zend.tool.framework.writing-providers.loading:

Wie Zend_Tool eigene Provider findet
------------------------------------

Standardmäßig verwendet ``Zend_Tool`` den IncludePathLoader um alle Provider zu finden die man ausführen kann.
Er iteriert rekursiv alle Verzeichnisse des Include Pfads und öffnet alle Dateien die mit "Manifest.php" oder
"Provider.php" enden. Alle Klassen in diesen Dateien werden angeschaut ob Sie entweder
``Zend_Tool_Framework_Provider_Interface`` oder ``Zend_Tool_Framework_Manifest_ProviderManifestable``
implementieren. Instanzen des Provider Interfaces machen die wirkliche Funtionalität aus und auf alle Ihre
öffentlichen Methoden kann man als Provider Aktionen zugreifen. Das Interface ProviderManifestable benötigt
trotzdem eine Implementation einer ``getProviders()`` Methode welche ein Array der instanziierten Provider
Interface Instanzen zurückgibt.

Die folgenden Namensregeln zeigen wir man auf die Provider zugreifen kann die vom IncludePathLoader gefunden
wurden:

- Der letzte Teil des Klassennamens der durch einen Unterstrich geteilt wird, wird für den Provider Namen
  verwendet, z.B. führt "My_Provider_Hello" dazu dass auf den eigenen Provider mit dem Namen "hello" zugegriffen
  werden kann.

- Wenn der eigene Provider eine ``getName()`` Methode hat, wird diese statt der vorhergehenden Methode verwendet um
  den Namen zu erkennen.

- Wenn der eigene Provider "Provider" als Präfix hat, er z.B. ``My_HelloProvider`` genannt wird, dann wird dieser
  vom Namen entfernt sodass der Provider "hello" genannt wird.

.. note::

   Der IncludePathLoader folgt Symlinks nicht, was bedeutet das man Provider Funktionalitäten nicht im eigenen
   Include Pfad verlinken kann, da diese physikalisch im Include Pfad vorhanden sein müssen.

.. _zend.tool.framework.writing-providers.loading.example:

.. rubric:: Eigene Provider mit einem Manifest bekanntmachen

Man kann eigene Provider bei ``Zend_Tool`` bekannt machen indem man ein Manifest mit einem speziellen Dateinamen
anbietet der mit "Manifest.php" endet. Ein Provider Manifest ist eine Implementation von
``Zend_Tool_Framework_Manifest_ProviderManifestable`` und benötigt die Methode ``getProviders()`` welche ein Array
von instanziierten Providern zurückgibt. Anders als unser erster eigener Provider erstellt
``My_Component_HelloProvider`` das folgende Manifest:

.. code-block:: php
   :linenos:

   class My_Component_Manifest
       implements Zend_Tool_Framework_Manifest_ProviderManifestable
   {
       public function getProviders()
       {
           return array(
               new My_Component_HelloProvider()
           );
       }
   }

.. _zend.tool.framework.writing-providers.basic:

Grundsätzliche Anweisungen für die Erstellung von Providern
-----------------------------------------------------------

Wenn, als Beispiel, ein Entwickler die Fähigkeit hinzufügen will, die Version einer Datendatei anzuzeigen, mit
der seine 3rd Party Komponente arbeitet, gibt es nur eine Klasse die der Entwickler implementieren muss. Angenommen
die Komponente heisst ``My_Component``, dann würde er eine Klasse erstellen die ``My_Component_HelloProvider``
heisst und in einer Datei ist die ``HelloProvider.php`` heisst und irgendwo im ``include_path`` ist. Diese Klasse
würde ``Zend_Tool_Framework_Provider_Interface`` implementieren, und der Body dieser Datei würde nur wie folgt
auszusehen haben:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say()
       {
           echo 'Hallo von meinem Provider!';
       }
   }

Durch den obigen Code, und der Annahme das der Entwickler den Zugriff auf diese funktionalität über den Consolen
Client will, würde der Aufruf wie folgt aussehen:

.. code-block:: sh
   :linenos:

   % zf say hello
   Hello from my provider!

.. _zend.tool.framework.writing-providers.response:

Das Antwort Objekt
------------------

Wie in der Archikektur Sektion diskutiert erlaubt ``Zend_Tool`` unterschiedliche Clients für die Verwendung in
``Zend_Tool`` Providern zu verwenden. Um mit den unterschiedlichen Clients kompatibel zu bleiben sollte man das
Antwort Objekt verwenden um Nachrichten von eigenen Providern zurückzugeben, statt ``echo()`` oder ähnliche
Ausgabe Mechanismen zu verwenden. Unser umgeschriebener Hallo Provider sieht mit dem jetzt bekannten wie folgt aus:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $this->_registry->getResponse
                           ->appendContent("Hello from my provider!");
       }
   }

Wie man sieht muss man ``Zend_Tool_Framework_Provider_Abstract`` erweitern um Zugriff auf die Registry zu erhalten,
welche die Instanz von ``Zend_Tool_Framework_Client_Response`` hält.

.. _zend.tool.framework.writing-providers.advanced:

Fortgeschrittene Informationen für die Entwicklung
--------------------------------------------------

.. _zend.tool.framework.writing-providers.advanced.variables:

Variablen an einen Provider übergeben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das obige "Hello World" Beispiel ist perfekt für einfache Kommandos, aber was ist mit etwas fortgeschrittenerem?
Wenn das Scripting und Tooling wächst, kann die Notwendigkeit entstehen Variablen zu akzeptieren. So wie
Signaturen von Funktionen Parameter haben, kann eine Tooling Anfrage auch Parameter akzeptieren.

So wie jede Tooling Anfrage in einer Methode in einer Klasse isoliert werden kann, können die Parameter einer
Tooling Anfrage auch in einem sehr bekannten Platz isoliert werden. Parameter von Action Methoden eines Providers
können die selben Parameter enthalten die man im Client verwenden will, wenn man den Namen im obigen Beispiel
akzeptieren will, und man würde das in OO Code warscheinlich wie folgt tun:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           echo 'Hallo' . $name . ', von meinem Provider!';
       }
   }

Das obige Beispiel kann über die Kommandozeile wie folgt aufgerufen werden: ``zf say hello Joe``. "Joe" wird dem
Provider als Parameter des Methodenaufrufs zur Verfügung gestellt. Es ist auch zu beachten das der Parameter
optional ist, was bedeutet das er auch auf der Kommandozeile optional ist, so das ``zf say hello`` weiterhin
funktioniert, und der Standardname "Ralph" ist.

.. _zend.tool.framework.writing-providers.advanced.prompt:

Den Benutzer nach einer Eingabe fragen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es gibt Fälle in denen der Workflow des Providers es notwendig macht, den Benutzer nach einer Eingabe zu fragen.
Das kann getan werden, indem der Client angewiesen wird nach der benötigten Eingabe zu Fragen, indem man folgendes
aufruft:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say($name = 'Ralph')
       {
           $nameResponse = $this->_registry
                                ->getClient()
                                ->promptInteractiveInput("Wie ist dein Name?");
           $name = $nameResponse->getContent();

           echo 'Hallo' . $name . ', von meinem Provider!';
       }
   }

Dieses Kommando wirft eine Exception wenn der aktuelle Client nicht in der Lage ist die Interaktive Anfrage zu
behandeln. Im Fall des standardmäßigen Konsolen Clients wird man trotzdem danach gefragt den Namen einzugeben.

.. _zend.tool.framework.writing-providers.advanced.pretendable:

Voranstellen um eine Provider Aktion auszuführen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein anderes interessantes Feature das man implementieren kann ist **Voranstellbarkeit**. Voranstellbarkeit ist die
Fähigkeit des Providers "Voranzustellen" wie wenn er die angefragte Aktion und Provider Kombination ausführt, und
dem Benutzer so viel Information wie möglich darüber gibt was er tun **würde** ohne es wirklich zu tun. Das kann
eine wichtige Option sein wenn viele Datenbank oder Dateisystem Änderungen durchzuführen sind, die der Benutzer
andernfalls nicht tun würde.

Voranstellbarkeit ist einfach zu implementieren. Es gibt zwei Teile dieses Features: 1) Markieren des Providers,
das er die Fähigkeit des "voranstellens" hat und 2) prüfen der Anfrage um Sicherzustellen das die aktuelle
Anfrage wirklich das "voranstellen" angefragt hat. Dieses Feature wird im nächsten Code Beispiel demonstriert.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends    Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Pretendable
   {
       public function say($name = 'Ralph')
       {
           if ($this->_registry->getRequest()->isPretend()) {
               echo 'Ich würde zu ' . $name . ' hallo sagen.';
           } else {
               echo 'Hallo' . $name . ', von meinem Provider!';
           }
       }
   }

Um den Provider im vorangestellten Modus auszuführen muss folgendes aufgerufen werden:

.. code-block:: sh
   :linenos:

   % zf --pretend say hello Ralph
   I würde zu Ralph hallo sagen.

.. _zend.tool.framework.writing-providers.advanced.verbosedebug:

Verbose und Debug Modi
^^^^^^^^^^^^^^^^^^^^^^

Man kann Provider Aktionen auch im "verbose" oder "debug" Modus ausführen. Die Semantik in Bezug zu diesen
Aktionen muss man selbst im Kontext des eigenen Providers implementieren. Man kann auf die Debug und Verbose Modi
wie folgt zugreifen:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           if($this->_registry->getRequest()->isVerbose()) {
               echo "Hello::say wurde aufgerufen\n";
           }
           if($this->_registry->getRequest()->isDebug()) {
               syslog(LOG_INFO, "Hello::say wurde aufgerufen\n");
           }
       }
   }

.. _zend.tool.framework.writing-providers.advanced.configstorage:

Zugriff auf Benutzer Konfiguration und Speicher
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn man die Umgebungsvariable ``ZF_CONFIG_FILE`` oder .zf.ini im Home Verzeichnis verwendet kann man
Konfigurationsparameter in jedem ``Zend_Tool`` Provider injizieren. Zugriff auf diese Konfiguration ist über die
Registry möglich die dem Provider übergeben wird, wenn man ``Zend_Tool_Framework_Provider_Abstract`` erweitert.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $username = $this->_registry->getConfig()->username;
           if(!empty($username)) {
               echo "Hallo $username!";
           } else {
               echo "Hallo!";
           }
       }
   }

Die zurückgegebene Konfiguration ist vom Typ ``Zend_Tool_Framework_Client_Config``, aber intern verweisen die
magischen Methoden ``__get()`` und ``__set()`` auf ``Zend_Config`` des angegebenen Konfigurations Typs.

Der Speicher erlaubt es eigene Daten für eine spätere Referenz zu speichern. Das kann für Batch Aufgaben oder
für ein erneutes Ausführen von Tasks nützlich sein. Man kann auf den Speicher auf eine ähnliche Art und Weise
zugreifen wie auf die Konfiguration:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $aValue = $this->_registry->getStorage()->get("myUsername");
           echo "Hallo $aValue!";
       }
   }

Die *API* des Speichers ist sehr einfach:

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Client_Storage
   {
       public function setAdapter($adapter);
       public function isEnabled();
       public function put($name, $value);
       public function get($name, $defaultValue=null);
       public function has($name);
       public function remove($name);
       public function getStreamUri($name);
   }

.. important::

   Wenn man eigene Provider designt die auf Konfguration oder Speicher rücksicht nehmen sollte man darauf achten
   ob die benötigten Benutzer-Konfigurations oder Speicher Schlüssel bereits für einen Benutzer existieren. Man
   würde keine fatalen Fehler erhalten wenn keine von ihnen angegeben werden, da leere Schlüssel bei der Anfrage
   erstellt werden.


