.. EN-Revision: none
.. _learning.quickstart.create-layout:

Ein Layout erstellen
====================

Wie man festgestellen kann waren die View Skripte im vorhergehenden Kapitel *HTML* Fragmente- und keine kompletten
Seiten. Das ist so gewünscht; wir wollen das unsere Aktionen nur den Inhalt zurückgeben der für die Aktion
selbst relevant ist, und nicht die Anwendung als ganzes.

Jetzt müssen wir den erstellten Inhalt zu einer kompletten *HTML* Seite zusammenfügen. Wir wollen auch ein
konsistentes Aussehen und Feeling für die Anwendung haben. Wir wollen ein globales Sitelayout verwenden um beide
Arbeiten zu ermöglichen.

Es gibt zwei Design Pattern die Zend Framework verwendet um Layouts zu implementieren: `Two Step View`_ und
`Composite View`_. **Two Step View** wird normalerweise mit dem `Transform View`_ Pattern assoziiert; die
grundsätzliche Idee besteht darin das die View der Anwendung eine Repräsentation erstellt die dann in die Master
View für letzte Transformationen injiziert wird. Das **Composite View** Pattern arbeitet mit einer View die aus
ein oder mehreren atomischen Anwendungs Views gemacht ist.

Im Zend Framework kombiniert :ref:`Zend_Layout <zend.layout>` die Ideen hinter diesen Pattern. Statt dass jedes
Action View Skript Site-weite Artefakte einfügen muss, können Sie sich einfach auf Ihre eigenen Beantwortungen
konzentrieren.

Natürlich benötigt man trotzdem Anwendungs-spezifische Informationen im Site-weiten View Skript.
Glücklicherweise bietet Zend Framework eine Anzahl von View **Platzhaltern** die es erlauben solche Informationen
von den Action View Skripten zu bekommen.

Um mit ``Zend_Layout`` zu beginnen müssen wir als erstes die Bootstrap informieren das Sie die ``Layout``
Ressource verwenden soll. Das kann getan werden indem der Befehl ``zf enable layout`` verwendet wird:

.. code-block:: console
   :linenos:

   % zf enable layout
   Layouts have been enabled, and a default layout created at
   application/layouts/scripts/layout.phtml
   A layout entry has been added to the application config file.

Wie vom Kommando notiert wird ``application/configs/application.ini`` aktualisiert und enthält jetzt das folgende
im Abschnitt ``production``:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Zum Abschnitt [production] hinzufügen:
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

Die endgültige *INI* Datei sollte wie folgt aussehen:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   ; PHP Einstellungen die initialisiert werden sollen
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Diese Direktive sagt der Anwendung das Sie nach Layout View Skripten unter ``application/layouts/scripts``
nachschauen soll. Wenn man den Verzeichnisbaum betrachtet sieht man das dieses Verzeichnis jetzt, zusammen mit der
Datei ``layout.phtml``, erstellt wurde.

Wir wollen auch sicherstellen das wir eine XHTML DocType Deklaration für unsere Anwendung haben. Um das zu
aktivieren mussen wir eine Ressource zu unserer Bootstrap hinzufügen.

Der einfachste Weg um eine Bootstrap Ressource hinzuzufügen ist es einfach eine geschützte Methode zu erstellen
die mit der Phrase ``_init`` beginnt. In diesem Fall wollen wir den Doctype initialisieren, also erstellen wir eine
``_initDoctype()`` Methode in unserer Bootstrap Klasse:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
       }
   }

In dieser Methode müssen wir der View sagen das Sie den richtigen DocType verwenden soll. Aber wo kommt das View
Objekt her? Die einfachste Lösung ist die Initialisierung der ``View`` Ressource; sobald wir Sie haben können wir
das View Objekt aus der Bootstrap holen und verwenden.

Um die View Ressource zu initialisieren ist die folgende Zeile in der Sektion ``production`` der Datei
``application/configs/application.ini`` hinzuzufügen:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Zum Abschnitt [production] hinzufügen:
   resources.view[] =

Das sagt uns das die View ohne Optionen initialisiert werden soll ('[]' zeigt das der "view" Schlüssel ein Array
ist, und wir Ihm nichts übergeben).

Jetzt da wir die View haben, sehen wir uns die ``_initDoctype()`` Methode an. In Ihr stellen wir zuerst sicher das
die ``View`` Ressource läuft, holen das View Objekt und konfigurieren es anschließend:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
           $this->bootstrap('view');
           $view = $this->getResource('view');
           $view->doctype('XHTML1_STRICT');
       }
   }

Jetzt da wir ``Zend_Layout`` initialisiert und den DocType gesetzt haben erstellen wir unser Site-weites Layout:

.. code-block:: php
   :linenos:

   <!-- application/layouts/scripts/layout.phtml -->

   <?php echo $this->doctype() ?>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Schnellstart Anwendung</title>
     <?php echo $this->headLink()->appendStylesheet('/css/global.css') ?>
   </head>
   <body>
   <div id="header" style="background-color: #EEEEEE; height: 30px;">
       <div id="header-logo" style="float: left">
           <b>ZF Schnellstart Anwendung</b>
       </div>
       <div id="header-navigation" style="float: right">
           <a href="<?php echo $this->url(
               array('controller'=>'guestbook'),
               'default',
               true) ?>">Guestbook</a>
       </div>
   </div>

   <?php echo $this->layout()->content ?>

   </body>
   </html>

Wir holen den Inhalt der Anwendung indem der ``layout()`` View Helfer verwendet, und auf den "content" Schlüssel
zugegriffen wird. Man kann andere Antwort Segmente darstellen wenn man das möchte, aber in den meisten Fällen ist
das alles was notwendig ist.

Es ist zu beachten das wir auch den ``headLink()`` Platzhalter verwenden. Das ist ein einfacher Weg um das *HTML*
für das <link> Element zu erstellen, sowie um es durch die Anwendung hindurch zu verfolgen. Wenn man zusätzliche
CSS Blätter zur Unterstützung einer einzelnen Aktion benötigt, kann das getan werden indem man sicherstellt das
Sie in der endgültig dargestellten Seite vorhanden sind.

.. note::

   **Checkpoint**

   Jetzt gehen wir zu "http://localhost" und prüfen die Quelle. Man sieht den XHTML Header, Kopf, Titel und Body
   Abschnitte.



.. _`Two Step View`: http://martinfowler.com/eaaCatalog/twoStepView.html
.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
.. _`Transform View`: http://www.martinfowler.com/eaaCatalog/transformView.html
