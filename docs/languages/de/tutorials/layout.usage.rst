.. _learning.layout.usage:

Zend_Layout verwenden
=====================

Die grundsätzliche Verwendung von ``Zend_Layout`` ist recht trivial. Angenommen man verwendet bereits
``Zend_Application``, dann kann man einfach ein paar Konfigurations Optionen übergeben und ein Layout View Skript
erstellen.

.. _learning.layout.usage.configuration:

Layout Konfiguration
--------------------

Der empfohlene Ort für Layouts ist im Unterverzeichnis "``layouts/scripts/``" in der eigenen Anwendung:

.. code-block:: text
   :linenos:

   application
   |-- Bootstrap.php
   |-- configs
   |   `-- application.ini
   |-- controllers
   |-- layouts
   |   `-- scripts
   |       |-- layout.phtml

Um ``Zend_Layout`` zu initialisieren muss das folgende in die eigene Konfigurationsdatei eingefügt werden
("``application/configs/application.ini``"):

.. code-block:: dosini
   :linenos:

   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"
   resources.layout.layout = "layout"

Die erste Zeile zeigt wo nach Layout Skripten nachgesehen werden soll; die zweite Zeile gibt den Namen des Layouts
an, welches verwendet werden soll, abzüglich der Erweiterung für View Skripts (welche standardmäßig mit
"``.phtml``" angenommen wird).

.. _learning.layout.usage.layout-script:

Ein Layout Skript erstellen
---------------------------

Jetzt da man die Konfiguration gesetzt hat, muss man sein Layout Skript erstellen. Zuerst muss man sicherstellen
dass das Verzeichnis "``application/layouts/scripts``" erstelt wurde; dann ist ein Editor zu öffnen und das Markup
für das eigene Layout zu erstellen. Layout Skripte sind einfach View Skripte, mit einigen kleinen Unterschieden.

.. code-block:: php
   :linenos:

   <html>
   <head>
       <title>Meine Site</title>
   </head>
   <body>
       <?php echo $this->layout()->content ?>
   </body>
   </html>

Im obigen Beispiel ist der Aufruf zum ``layout()`` View Helper zu sehen. Wenn man die ``Zend_Layout`` Ressource
registriert, erhält man auch Zugriff zum Action und zum View Helper welche es erlauben die ``Zend_Layout`` Instanz
anzusprechen; man kann anschließend Befehle auf dem Layout Objekt aufrufen. In diesem Fall wird eine benannte
Variable, ``$content``, empfangen und ausgegeben. Standardmäßig wird die Variable ``$content`` vom
Anwendungs-View Skript dargestellt. Andererseits ist alles was man normalerweise in einem View Skript macht perfekt
gültig -- aufrufen von Helfern oder View Methoden wie man es will.

An diesem Punkt hat man ein funktionierendes Layout Skript, und die eigene Anwendung ist über seinen Ort
informiert und weis wie es darzustellen ist.

.. _learning.layout.usage.access:

Auf das Layout Objekt zugreifen
-------------------------------

Manchmal ist ein Direktzugriff auf das Layout Objekt notwendig. Es gibt drei Wege wie man das tun kann:

- **In den View Skripten:** der ``layout()`` View Helfer ist zu verwenden, der die Instanz von ``Zend_Layout``
  zurückgibt welche im Front Controller Plugin registriert ist.

  .. code-block:: php
     :linenos:

     <?php $layout = $this->layout(); ?>

  Da er die Layout Instanz zurückgibt, kann man also einfach Methoden auf Ihm aufrufen statt Ihn einer Variablen
  zuordnen zu müssen.

- **In Action Controllern**: der ``layout()`` Action Helfer ist zu verwenden, welcher wie der View Helfer arbeitet.

  .. code-block:: php
     :linenos:

     // Aufruf des Helfers als eine Methode auf dem Helfer Broker:
     $layout = $this->_helper->layout();

     // Oder etwas komplizierter:
     $helper = $this->_helper->getHelper('Layout');
     $layout = $helper->getLayoutInstance();

  Wie mit dem View Helfer gibt der Action Helfer die Instanz des Layouts zurück, man kann also einfach Methoden
  auf Ihm aufrufen, statt diese einer Variable zuordnen zu müssen.

- **Andernorts**: verwenden der statischen Methode ``getMvcInstance()``. Das gibt die Layout Instanz zurück,
  welche durch die Bootstrap Ressource registriert wurde.

  .. code-block:: php
     :linenos:

     $layout = Zend_Layout::getMvcInstance();

- **Über die Bootstrap**: empfangen der Layout Ressource, welche die ``Zend_Layout`` Instanz ist.

  .. code-block:: php
     :linenos:

     $layout = $bootstrap->getResource('Layout');

  Überall wo man auf das Bootstrap Objekt Zugriff hat, wird diese Methode empfohlen und nicht die statische
  ``getMvcInstance()`` Methode.

.. _learning.layout.usage.other-operations:

Andere Operationen
------------------

In den meisten Fällen empfängt die obige Konfiguration und das Layout Skript (mit Änderungen) das, was benötigt
wird. Trotzdem existieren einigen andere Funktionalitäten die man früher oder später verwenden wird. In allen
der folgenden Beispiele kann man eine der :ref:`oben aufgeführten Methoden <learning.layout.usage.access>`
verwenden um das Layout Objekt zu erhalten.

- **Setzen von Layout Variablen**: ``Zend_Layout`` hat seine eigene Registry von Layout-spezifischen View Variablen
  auf die man zugreifen kann; der ``$content`` Schlüssel welche im ursprünglichen Layout Skript gezeigt wird, ist
  so ein Beispiel. Man kann diese zuweisen und empfangen indem ein normaler Zugriff auf Eigenschaften verwendet
  wird, oder über die ``assign()`` Methode.

  .. code-block:: php
     :linenos:

     // Inhalt setzen:
     $layout->somekey = "foo"

     // Den selben Inhalt ausgeben:
     echo $layout->somekey; // 'foo'

     // Verwenden der assign() Methode:
     $layout->assign('someotherkey', 'bar');

     // Der Zugriff auf assign()'ed Variablen bleibt der gleiche:
     echo $layout->someotherkey; // 'bar'

- ``disableLayout()``: Üblicherweise wird man Layouts ausschalten wollen; zum Beispiel wenn eine Ajax Anfrage
  beantwortet wird, oder eine RESTvolle Darstellung einer Ressource angeboten wird. In diesem Fällen kann man die
  ``disableLayout()`` Methode auf dem Layout Objekt ausführen.

  .. code-block:: php
     :linenos:

     $layout->disableLayout();

  Das Gegenteil dieser Methode ist natürlich ``enableLayout()``, welches jederzeit aufgerufen werden kann um
  Layouts für die angefragte Aktion wieder einzuschalten.

- **Ein alternatives Layout auswählen**: Wenn man mehrere Layouts für die eigene Site oder Anwendung hat, kann
  das Layout welches verwendet werden soll jederzeit ausgewählt werden indem einfach die ``setLayout()`` Methode
  aufgerufen wird. Es ist aufzurufen indem der Name des Layout Skripts ohne die Dateiendung spezifiziert wird.

  .. code-block:: php
     :linenos:

     // Verwendung des Layout Skripts "alternate.phtml":
     $layout->setLayout('alternate');

  Das Layout Skript sollte im ``$layoutPath`` Verzeichnis enthalten sein, welche in der eigenen Konfiguration
  spezifiziert ist. ``Zend_Layout`` wird anschließend dieses neue Layout bei der Darstellung verwenden.


