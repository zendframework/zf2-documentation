.. _project-structure:

***********************************************************************************
Vorgeschlagene Struktur für die Projekt Struktur von Zend Framework MVC Anwendungen
***********************************************************************************

.. _project-structure.overview:

Übersicht
---------

Viele Entwickler suchen Hilfe für die beste Projekt Struktur für ein Zend Framework Projekt in einer relativ
flexiblen Umgebung. Eine "flexible" Umgebung ist eine, in welcher der Entwickler seine Dateisysteme und
Konfigurationen des Webservers wie benötigt manipulieren kann um die idealste Projektstruktur zu erhalten damit
Ihre Anweungen ausgeführt werden können und sicher sind. Die standardmäßige Projektstruktur stellt sicher das
der Entwickler diese Flexibilität zu seiner Verfügung hat.

Die folgende Verzeichnisstruktur wurde designt um für komplexe Projekt maximal erweiterbar zu sein, wärend Sie
ein einfaches Subset von Verzeichnissen und Dateien für Projekte mit einfacheren Notwendigkeiten anbietet. Diese
Struktur arbeitet auch ohne Änderung sowohl für modulare und nicht-modulare Zend Framework Anwendungen. Die
``.htaccess`` Dateien benötigen *URL* Rewrite Funktionalität im Web Server wie im :ref:`Rewrite Konfigurations
Guide <project-structure.rewrite>` beschrieben, der auch in diesem Anhang enthalten ist.

Es ist nicht angedacht das diese Projekt Struktur alle möglichen Notwendigkeiten für Zend Framework Projekte
unterstützt. Das standardmäßige Projekt Profil welches von ``Zend_Tool`` verwendet wird, reflektiert diese
Projekt Struktur. Aber Anwendungen mit Notwendigkeiten die nicht von dieser Struktur unterstützt werden, sollten
ein eigenes Projekt Profil verwenden.

.. _project-structure.project:

Vorgeschlagene Verzeichnis Struktur für Projekte
------------------------------------------------

.. code-block:: text
   :linenos:

   <project name>/
       application/
           configs/
               application.ini
           controllers/
               helpers/
           forms/
           layouts/
               filters/
               helpers/
               scripts/
           models/
           modules/
           services/
           views/
               filters/
               helpers/
               scripts/
           Bootstrap.php
       data/
           cache/
           indexes/
           locales/
           logs/
           sessions/
           uploads/
       docs/
       library/
       public/
           css/
           images/
           js/
           .htaccess
           index.php
       scripts/
           jobs/
           build/
       temp/
       tests/

Nachfolgend ist der Verwendungszweck für jedes Verzeichnis angeführt.

- **application/**: Der Verzeichnis enthält die eigene Anwendung. Das wird das *MVC* System inkludieren, sowie
  Konfigurationen, verwendete Services, und die eigene Bootstrap Datei.

  - **configs/**: Das Anwendungsweite Konfigurations Verzeichnis.

  - **controllers/**, **models/**, und **views/**: Diese Verzeichnisse fungieren als Standardcontroller, Modell
    oder View Verzeichnisse. Diese drei Verzeichnisse im Anwendungsverzeichnis zu haben bietet das beste Layout
    für das Starten eines einfachen Projekts sowie als Start eines modularen Projekts das globale
    ``controllers/models/views`` hat.

  - **controllers/helpers/**: Diese Verzeichnisse enthalten Action Helfer. Action Helfer haben entweder einen
    Namespace von "``Controller_Helper_``" im Standardmodul oder "<Module>_Controller_Helper" in anderen Modulen.

  - **layouts/**: Dieses Layout Verzeichnis ist für *MVC*-basierte Layouts. Da ``Zend_Layout`` ist der Lage ist
    *MVC*- und nicht-*MVC*-basierte Layouts zu verstehen, zeigt der Ort dieses Verzeichnisses das Layouts keine
    1-zu-1 beziehung zu Controllern haben und unabhängig von Templates in ``views/`` sind.

  - **modules/**: Module erlauben einem Entwickler ein Set von zusammengehörenden Controllern in eine logisch
    organisierte Gruppe zu gruppieren. Die Struktur im Modules Verzeichnis würde die Struktur des Application
    Verzeichnisses haben.

  - **services/**: Dieses Verzeichnis ist für eigene Anwendungsspezifische Web-Service Dateien welche von der
    eigenen Anwendung angeboten werden, oder für die Implementierung eines `Service Layers`_ für eigene Modelle.

  - **Bootstrap.php**: Diese Datei ist der Eistiegspunkt für die eigene Anwendung, und sollte
    ``Zend_Application_Bootstrap_Bootstrapper`` implementieren. Das Ziel diese Datei ist es die Anwendung zu
    starten und Komponenten der Anwendung zur Verfügung zu stellen indem diese initialisiert werden.

- **data/**: Dieses Verzeichnis bietet einen Ort an dem Anwendungsdaten gespeichert werden die angreifbar und
  möglicherweise temporär sind. Die Veränderung von Daten in diesem Verzeichnis kann dazu führen das die
  Anwendung fehlschlägt. Die Informationen in diesem Verzeichnis können, oder auch nicht, in ein Subversion
  Repository übertragen werden. Beispiele von Dingen in diesem Verzeichnis sind Session Dateien, Cache Dateien,
  SQLite Datenbanken, Logs und Indezes.

- **docs/**: Dieses Verzeichnis enthält die Dokumentation, entweder erzeugt oder direkt bearbeitet

- **library/**: Dieses Verzeichnis ist für übliche Bibliotheken von denen die Anwendung abhängt, und es sollte
  im ``include_path`` von *PHP* sein. Entwickler sollten den Bibliotheks-Code Ihrer Anwendung in diesem
  Verzeichnis, unter einem eindeutigen Namespace platzieren, und den Richtlinien folgen die im Handbuch von *PHP*
  unter `Userland Naming Guide`_ beschrieben sind, sowie denen die von Zend selbst beschrieben sind.; Dieses
  Verzeichnis kann auch den Zend Framework selbst enthalten; wenn dem so ist, würde er unter ``library/Zend/``
  platziert werden.

- **public/**: Dieses Verzeichnis enthält alle öffentlichen Dateien für die eigene Anwendung. ``index.php``
  konfiguriert und startet ``Zend_Application``, welche seinerseits die Datei ``application/Bootstrap.php``
  startet, was dazu führt das der Front Controller ausgeführt wird. Der Web Root des Web Server sollte
  typischerweise auf dieses Verzeichnis gesetzt sein.

- **scripts/**: Dieses Verzeichnis enthält Maintenance und/oder Build Skripte. Solche Skripte können Commandline,
  Cron oder Phing Build Skripte enthalten die nicht wärend der Laufzeit ausgeführt werden, aber Teil für das
  korrekte Funktionieren der Anwendung sind. This directory contains maintenance and/or build scripts. Such scripts
  might include command line, cron, or phing build scripts that are not executed at runtime but are part of the
  correct functioning of the application.

- **temp/**: Das ``temp/`` Verzeichnis wird für vergängliche Anwendungsdaten gesetzt. Diese Information würde
  typischerweise nicht im SVN Repository der Anwendung gespeichert werden. Wenn Daten im ``temp/`` Verzeichnis
  gelöscht werden, sollten Anwendungsen dazu in der Lage sein weiterhin zu laufen wärend das möglicherweise die
  Geschwindigkeit reduziert bis die Daten wieder gespeichert oder neu gecacht sind.

- **tests/**: Dieses Verzeichnis enthält Anwendungstests. Diese würden hand-geschrieben sein, PHPUnit Tests,
  Selenium-RC basierte Tests oder basierend auf anderen Test Frameworks. Standardmäßig kann Library Code getestet
  werden indem die Verzeichnis Struktur des ``library/`` Verzeichnisses vorgegauckelt wird. Zusätzliche
  funktionale Tests für die eigene Anwendung können geschrieben werden indem die Verzeichnis Struktur von
  ``application/`` vorgegauckelt wird (inklusive der Unterverzeichnisse der Anwendung).

.. _project-structure.filesystem:

Modul Struktur
--------------

Die Verzeichnis Struktur für Module sollte jene des ``application/`` Verzeichnisses in der vorgeschlagenen Projekt
Struktur entsprechen:

.. code-block:: text
   :linenos:

   <modulename>/
       configs/
           application.ini
       controllers/
           helpers/
       forms/
       layouts/
           filters/
           helpers/
           scripts/
       models/
       services/
       views/
           filters/
           helpers/
           scripts/
       Bootstrap.php

Der Zweck dieses Verzeichnisse bleibt exakt der gleiche wie der für die vorgeschlagene Verzeichnis Struktur des
Projekts.

.. _project-structure.rewrite:

Leitfaden für die Rewrite Konfiguration
---------------------------------------

*URL* Rewriting ist eine der üblichen Funktionen von *HTTP* Servern. Trotzdem unterscheiden sich die Regeln und
die Konfiguration zwischen Ihnen sehr stark. Anbei sind einige der üblichen Vorschläge für eine Vielzahl der
populären Webserver zu finden, die zur der Zeit in der das hier geschrieben wurde, vorhanden sind.

.. _project-structure.rewrite.apache:

Apache HTTP Server
^^^^^^^^^^^^^^^^^^

Alle folgenden Beispiel verwenden ``mod_rewrite``, ein offizielles Modul das bebündelt mit Apache kommt. Um es zu
verwenden muss ``mod_rewrite`` entweder wärend der Zeit des Kompilierens enthalten sein, oder als Dynamic Shared
Objekt (*DSO*) aktiviert werden. Konsultieren Sie bitte die `Apache Dokumentation`_ für weitere Informationen
über Ihre Version.

.. _project-structure.rewrite.apache.vhost:

Rewriting innerhalb eines VirtualHost
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Hier ist eine sehr grundsätzliche Definition eines virtuellen Hosts. Diese Regeln leiten alle Anfragen auf
``index.php`` weiter, ausser wenn eine passende Datei im ``document_root`` gefunden wurde.

.. code-block:: text
   :linenos:

   <VirtualHost my.domain.com:80>
       ServerName   my.domain.com
       DocumentRoot /path/to/server/root/my.domain.com/public

       RewriteEngine off

       <Location />
           RewriteEngine On
           RewriteCond %{REQUEST_FILENAME} -s [OR]
           RewriteCond %{REQUEST_FILENAME} -l [OR]
           RewriteCond %{REQUEST_FILENAME} -d
           RewriteRule ^.*$ - [NC,L]
           RewriteRule ^.*$ /index.php [NC,L]
       </Location>
   </VirtualHost>

Es ist der Schrägstrich ("/") zu beachten der ``index.php`` vorangestellt ist; die Regeln für ``.htaccess``
unterscheiden sich in diesem Punkt.

.. _project-structure.rewrite.apache.htaccess:

Rewriting innerhalb einer .htaccess Datei
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Anbei ist eine einfache ``.htaccess`` Datei welche ``mod_rewrite`` verwendet. Das ist Ähnlich der Konfiguration
für virtuelle Hosts, ausser das Sie nur die Rewrite Regeln spezifiziert, und der führende Schrägstrich bei
``index.php`` nicht angegeben wird.

.. code-block:: text
   :linenos:

   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]
   RewriteRule ^.*$ index.php [NC,L]

Es gibt viele Wege um ``mod_rewrite`` zu konfigurieren; wenn man weitere Informationen haben will, dann sollte man
in Jayson Minard's `Blueprint for PHP Applications: Bootstrapping`_ sehen.

.. _project-structure.rewrite.iis:

Microsoft Internet Information Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ab Version 7.0 wird *IIS* jetzt mit einer Standardmäßigen Rewrite Engine ausgeliefert. Man kann die folgende
Konfiguration verwenden um die entsprechenden Rewrite Regeln zu erstellen.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
       <system.webServer>
           <rewrite>
               <rules>
                   <rule name="Imported Rule 1" stopProcessing="true">
                       <match url="^.*$" />
                       <conditions logicalGrouping="MatchAny">
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsFile" pattern=""
                                ignoreCase="false" />
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsDirectory"
                                pattern=""
                                ignoreCase="false" />
                       </conditions>
                       <action type="None" />
                   </rule>
                   <rule name="Imported Rule 2" stopProcessing="true">
                       <match url="^.*$" />
                       <action type="Rewrite" url="index.php" />
                   </rule>
               </rules>
           </rewrite>
       </system.webServer>
   </configuration>



.. _`Service Layers`: http://www.martinfowler.com/eaaCatalog/serviceLayer.html
.. _`Userland Naming Guide`: http://www.php.net/manual/de/userlandnaming.php
.. _`Apache Dokumentation`: http://httpd.apache.org/docs/
.. _`Blueprint for PHP Applications: Bootstrapping`: http://devzone.zend.com/a/70
