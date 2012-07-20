.. _learning.quickstart.create-project:

Das Projekt erstellen
=====================

Um das eigene Projekt zu erstellen muss man zuerst Zend Framework herunterladen und extrahieren.

.. _learning.quickstart.create-project.install-zf:

Zend Framework installieren
---------------------------

Der einfachste Weg um Zend Framework zusammen mit einem kompletten *PHP* Stack zu erhalten ist durch die
Installation von `Zend Server`_. Zend Server hat native Installationsroutinen für Mac OSX, Windows, Fedora Core
und Ubuntu, sowie ein universelles Installationspaket das mit den meisten Linux Distributionen kompatibel ist.

Nachdem Zend Server installiert wurde, können die Framework Dateien bei Max OSX und Linux unter
``/usr/local/zend/share/ZendFramework``, und bei Windows unter ``C:\Program
Files\Zend\ZendServer\share\ZendFramework`` gefunden werden. Der ``include_path`` ist dann bereits konfiguriert um
Zend Framework zu verwenden.

Alternativ kann man `die letzte Version vom Zend Framework downloaden`_ und dessen Inhalt extrahieren; man sollte
sich notieren wo man das tut.

Optional kann der Pfad zum Unterverzeichnis ``library/`` des Archivs den eigenen ``include_path`` Einstellung in
der ``php.ini`` hinzugefügt werden.

Das ist es! Zend Framework ist jetzt installiert und bereit zur Verwendung.

.. _learning.quickstart.create-project.create-project:

Das Projekt erstellen
---------------------

.. note::

   **zf Kommandozeilen Tool**

   In der eigenen Zend Framework Installation ist ein Unterverzeichnis ``bin/`` welches die Skripte ``zf.sh`` und
   ``zf.bat``, für Unix-basierende und Windows-basierende Benutzer enthält. Der absolute Pfad zu diesem Skript
   sollte notiert werden.

   Wo immer man einer Referenz auf den Befehl ``zf`` sieht, sollte der absolute Pfad zum Skript substituiert
   werden. Auf Unix-basierenden Systemen, könnte man die Alias Funktionalität der Shell verwenden: ``alias
   zf.sh=path/to/ZendFramework/bin/zf.sh``.

   Wenn man Probleme hat das ``zf`` Kommandozeilen Tool zu konfigurieren sollte man in :ref:`das Handbuch
   <zend.tool.framework.clitool>` sehen.

Ein Terminal öffnen (in Windows, ``Start -> Run`` und anschließend ``cmd`` verwenden). Zum Verzeichnis in dem man
das Projekt beginnen will navigieren. Anschließend den Pfad zum richtigen Skript verwenden und eines der folgenden
ausführen:

.. code-block:: console
   :linenos:

   % zf create project quickstart

Die Ausführung dieses Kommandos erstellt die grundsätzliche Site Struktur, inklusive den initialen Controllern
und Views. Der Baum sieht wie folgt aus:

.. code-block:: text
   :linenos:

   quickstart
   |-- application
   |   |-- Bootstrap.php
   |   |-- configs
   |   |   `-- application.ini
   |   |-- controllers
   |   |   |-- ErrorController.php
   |   |   `-- IndexController.php
   |   |-- models
   |   `-- views
   |       |-- helpers
   |       `-- scripts
   |           |-- error
   |           |   `-- error.phtml
   |           `-- index
   |               `-- index.phtml
   |-- library
   |-- public
   |   |-- .htaccess
   |   `-- index.php
   `-- tests
       |-- application
       |   `-- bootstrap.php
       |-- library
       |   `-- bootstrap.php
       `-- phpunit.xml

Wenn man an diesem Punkt, Zend Framework dem eigenen ``include_path`` nicht hunzugefügt hat, empfehlen wir Ihn
entweder in das eigene ``library/`` Verzeichnis zu kopieren oder zu symlinken. In jedem Fall sollte man entweder
das ``library/Zend/`` Verzeichnis der Zend Framework Installation rekursiv in das ``library/`` Verzeichnis des
Projekts kopieren oder symlinken. Auf unix-artigen Systemen würde das wie folgt aussehen:

.. code-block:: console
   :linenos:

   # Symlink:
   % cd library; ln -s path/to/ZendFramework/library/Zend .

   # Copy:
   % cd library; cp -r path/to/ZendFramework/library/Zend .

Auf Windows Systemen ist es am einfachsten das vom Explorer zu tun.

Jetzt da das Projekt erstellt wurde, sind die hauptsächlichen Artefakte die man verstehen sollte, die Bootstrap,
die Konfiguration, die Action Controller und die Views.

.. _learning.quickstart.create-project.bootstrap:

Die Bootstrap
-------------

Die ``Bootstrap`` Klasse definiert welche Ressourcen und Komponenten zu initialisieren sind. Standardmäßig wird
Zend Framework's :ref:`Front Controller <zend.controller.front>` initialisiert und er verwendet
``application/controllers/`` als Standardverzeichnis in dem nach Action Controllern nachgesehen wird (mehr davon
später). Die Klasse sieht wie folgt aus:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
   }

Wie man sieht ist nicht viel notwendig um zu beginnen.

.. _learning.quickstart.create-project.configuration:

Konfiguration
-------------

Wärend Zend Framework selbst konfigurationslos ist, ist es oft notwendig die eigene Anwendung zu konfigurieren.
Die Standardkonfiguration wird in ``application/configs/application.ini`` platziert und enthält einige
grundsätzliche Direktiven für die Einstellung der *PHP* Umgebung (zum Beispiel ein- und ausschalten der
Fehlermeldungen), zeigt den Pfad zur eigenen Bootstrap Klasse (wie auch dessen Klassenname), und den Pfad zu den
eigenen Action Controllern. Das sieht wie folgt aus:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Verschiedene Dinge sollten über diese Datei gesagt werden. Erstens kann man, wenn *INI*-artige Konfigurationen
verwendet werden, direkt auf Konstanten referenzieren und Sie erweitern; ``APPLICATION_PATH`` selbst ist eine
Konstante. Zusätzlich ist zu beachten das es verschiedene definierte Sektionen gibt: production, staging, testing,
und development. Die letzten drei verweisen auf Einstellungen der "production" Umgebung. Das ist ein nützlicher
Weg die Konfiguration zu organisieren und stellt sicher das die richtigen Einstellungen in jeder Stufe der
Anwendungsentwicklung vorhanden sind.

.. _learning.quickstart.create-project.action-controllers:

Action Controller
-----------------

Die **Action Controller** der Anwendung enthalten den Workflow der Anwendung und mappen eigene Anfragen auf die
richtigen Modelle und Views.

Ein Action Controller sollte ein oder mehrere Methoden haben die auf "Action" enden; diese Methoden können über
das Web abgefragt werden. Standardmäßig folgen Zend Framework URL's dem Schema ``/controller/action`` wobei
"controller" auf den Namen des Action Controllers verweist (ohne den "Controller" Suffix) und "action" auf eine
Action Methode verweist (ohne den "Action" Suffix).

Typischerweise benötigt man immer einen ``IndexController``, der ein Fallback Controller ist und auch als Homepage
der Site arbeitet, und einen ``ErrorController`` der verwendet wird um Dinge wie *HTTP* 404 Fehler zu zeigen (wenn
der Controller oder die Action nicht gefunden wird) und *HTTP* 500 Fehler (Anwendungsfehler).

Der standardmäßige ``IndexController`` ist wie folgt:

.. code-block:: php
   :linenos:

   // application/controllers/IndexController.php

   class IndexController extends Zend_Controller_Action
   {

       public function init()
       {
           /* Den Action Controller hier initialisieren */
       }

       public function indexAction()
       {
           // Action Body
       }
   }

Und der standardmäßige ``ErrorController`` ist wie folgt:

.. code-block:: php
   :linenos:

   // application/controllers/ErrorController.php

   class ErrorController extends Zend_Controller_Action
   {

       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:

                   // 404 Fehler -- Controller oder Action nicht gefunden
                   $this->getResponse()->setHttpResponseCode(404);
                   $this->view->message = 'Page not found';
                   break;
               default:
                   // Anwendungsfehler
                   $this->getResponse()->setHttpResponseCode(500);
                   $this->view->message = 'Application error';
                   break;
           }

           $this->view->exception = $errors->exception;
           $this->view->request   = $errors->request;
       }
   }

Es ist zu sehen das (1) der ``IndexController`` keinen echten Code enthält, und (2) der ``ErrorController`` auf
eine "view" Eigenschaft verweist. Das führt schon zu unserem nächsten Subjekt.

.. _learning.quickstart.create-project.views:

Views
-----

Views werden im Zend Framework in reinem alten *PHP* geschrieben. View Skripte werden unter
``application/views/scripts/`` platziert, wo Sie weiters kategorisiert werden indem der Name des Controllers
verwendet wird. In unserem Fall haben wir einen ``IndexController`` und einen ``ErrorController``, und deshalb
haben wir entsprechende ``index/`` und ``error/`` Unterverzeichnisse in unserem View Skript Verzeichnis. In diesem
Unterverzeichnissen finden und erstellen wir anschließend View Skripte die jeder ausgeführten Controller Action
entsprechen; im Standardfall haben wir die View Skripte ``index/index.phtml`` und ``error/error.phtml``.

View Skripte können jedes Markup enthalten das man haben will, und verwenden das öffnende **<?php** Tag und das
schließende **?>** Tag um *PHP* Direktiven einzufügen.

Das folgende wird standardmäßig für das ``index/index.phtml`` View Skript installiert:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/index/index.phtml -->
   <style>

       a:link,
       a:visited
       {
           color: #0398CA;
       }

       span#zf-name
       {
           color: #91BE3F;
       }

       div#welcome
       {
           color: #FFFFFF;
           background-image: url(http://framework.zend.com/images/bkg_header.jpg);
           width:  600px;
           height: 400px;
           border: 2px solid #444444;
           overflow: hidden;
           text-align: center;
       }

       div#more-information
       {
           background-image: url(http://framework.zend.com/images/bkg_body-bottom.gif);
           height: 100%;
       }

   </style>
   <div id="welcome">
       <h1>Willkommen zum <span id="zf-name">Zend Framework!</span><h1 />
       <h3>Das ist die Hauptseite unseres Projekts<h3 />
       <div id="more-information">
           <p>
               <img src="http://framework.zend.com/images/PoweredBy_ZF_4LightBG.png" />
           </p>

           <p>
               Hilfreiche Links: <br />
               <a href="http://framework.zend.com/">Zend Framework Website</a> |
               <a href="http://framework.zend.com/manual/en/">Zend Framework
                   Handbuch</a>
           </p>
       </div>
   </div>

Das ``error/error.phtml`` View Skript ist etwas interessanter da es einige *PHP* Konditionen verwendet:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/error/error.phtml -->
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN";
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Standardanwendung</title>
   </head>
   <body>
     <h1>Ein Fehler ist aufgetreten</h1>
     <h2><?php echo $this->message ?></h2>

     <?php if ('development' == $this->env): ?>

     <h3>Information der Exception:</h3>
     <p>
         <b>Nachricht:</b> <?php echo $this->exception->getMessage() ?>
     </p>

     <h3>Stack Trace:</h3>
     <pre><?php echo $this->exception->getTraceAsString() ?>
     </pre>

     <h3>Anfrage Parameter:</h3>
     <pre><?php echo var_export($this->request->getParams(), 1) ?>
     </pre>
     <?php endif ?>

   </body>
   </html>

.. _learning.quickstart.create-project.vhost:

Einen virtuellen Host erstellen
-------------------------------

Für die Zwecke dieses Quickstarts nehmen wir an das der `Apache Web Server`_ verwendet wird. Zend Framework
arbeitet auch perfekt mit anderen Web Server -- inklusive Microsoft Internet Information Server, Lighttpd, Nginx
und andere -- aber die meisten Entwickler sollten zumindest mit Apache umgehen können, und es bietet eine einfache
Einführung in Zend Framework's Verzeichnisstruktur und die Möglichkeiten des Rewritings.

Um den eigenen VHost zu erstellen muss man den Ort der eigenen ``httpd.conf`` Datei kennen und potentiell auch wo
andere Konfigurationsdateien platziert sind. Einige übliche Orte sind:

- ``/etc/httpd/httpd.conf`` (Fedora, RHEL, und andere)

- ``/etc/apache2/httpd.conf`` (Debian, Ubuntu, und andere)

- ``/usr/local/zend/etc/httpd.conf`` (Zend Server auf \*nix Maschinen)

- ``C:\Program Files\Zend\Apache2\conf`` (Zend Server auf Windows Maschinen)

In der eigenen ``httpd.conf`` (oder ``httpd-vhosts.conf`` auf anderen Systemen) muss man zwei Dinge tun. Erstens
sicherstellen das der ``NameVirtualHost`` definiert ist; typischerweise wird man Ihn auf einen Wert von "\*:80"
setzen. Zweitens einen virtuellen Host definieren:

.. code-block:: apache
   :linenos:

   <VirtualHost *:80>
       ServerName quickstart.local
       DocumentRoot /path/to/quickstart/public

       SetEnv APPLICATION_ENV "development"

       <Directory /path/to/quickstart/public>
           DirectoryIndex index.php
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
   </VirtualHost>

Es gilt verschiedene Dinge zu beachten. Erstens ist zu beachten dass die ``DocumentRoot`` Einstellung das
Unterverzeichnis ``public`` des eigenen Projekts spezifiziert; dies bedeutet das nur Dateien in diesem Verzeichnis
jemals direkt vom Server serviert werden. Zweitens sind die Direktiven ``AllowOverride``, ``Order``, und ``Allow``
zu beachten; diese erlauben uns ``htacess`` Dateien in unserem Projekt zu verwenden. Wärend der Entwicklung ist
das eine gute Praxis, da es verhindert den Web Server konstant zurücksetzen zu müssen wenn man Änderungen in den
Site Direktiven macht; trotzdem sollte man in der Produktion den Inhalt der ``htacess`` Datei in die Server
Konfiguration verschieben und diese deaktivieren. Drittens ist die ``SetEnv`` Direktive zu beachten. Was wir hier
erledigen ist das Setzen einer Umgebungsvariable für den eigenen virtuellen Host; diese Variable wird in der
``index.php`` geholt und verwendet um die Konstante ``APPLICATION_ENV`` für unsere Zend Framework Anwendung zu
setzen. In der Produktion kann diese Direktive unterdrückt werden (in diesem Fall wird es auf den Standardwert
"production" verweisen) oder Sie explizit auf "production" setzen.

Letztendlich muss man einen Eintrag in der eigenen ``hosts`` Datei hinzufügen welche mit dem Wert korrespondiert
der in der ``ServerName`` Direktive plaziert wurde. Auf \*nix-artigen Systemen ist das normalerweise
``/etc/hosts``; auf Windows findet man typischerweise ``C:\WINDOWS\system32\drivers\etc`` in Ihm. Unabhängig vom
System sieht der Eintrag wie folgt aus:

.. code-block:: text
   :linenos:

   127.0.0.1 quickstart.local

Den Webserver starten (oder ihn Restarten), und man sollte bereit sein weiterzumachen.

.. _learning.quickstart.create-project.checkpoint:

Checkpoint
----------

An diesem Punkt sollte man in der Lage sein die initiale Zend Framework Anwendung auszuführen. Der Browser sollte
auf den Servernamen zeigen welcher im vorherigen Abschnitt konfiguriert wurde; ab diesem Zeitpunkt sollte man in
der Lage sein die Startseite zu sehen.



.. _`Zend Server`: http://www.zend.com/en/products/server-ce/downloads
.. _`die letzte Version vom Zend Framework downloaden`: http://framework.zend.com/download/latest
.. _`Apache Web Server`: http://httpd.apache.org/
