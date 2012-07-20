.. _learning.view.placeholders.basics:

Grundsätzliche Verwendung von Platzhaltern
==========================================

Zend Framework definiert einen generischen ``placeholder()`` View Helfer den man für so viele eigene Platzhalter
verwenden kann wie man will. Er bietet auch eine Vielzahl an Platzhalter Implementationen für oft benötigte
Funktionalitäten, wie die Spezifikation der **DocType** Deklaration, den Titel des Dokuments und mehr.

Alle Platzhalter arbeiten einigermaßen auf die selbe Art und Weise. Sie sind Container und erlauben es deshalb das
man mit Ihnen als Kollektion arbeitet. Mit Ihnen kann man:

- **Anhängen** oder **voranstellen** von Elementen an die Kollektion.

- **Ersetzen** der kompletten Kollektion mit einem einzelnen Wert.

- Einen String spezifizieren welcher der **Ausgaben vorangestellt** wird wenn die Kollektion dargestellt wird.

- Einen String spezifizieren welcher der **Ausgaben angehängt** wird wenn die Kollektion dargestellt wird.

- Einen String spezifizieren mit dem **Elemente geteilt** werden wenn die Kollektion dargestellt wird.

- **Inhalte holen** die sich in der Kollektion befinden.

- **Darstellen** der gesammelten Inhalte.

Typischerweise ruft man den Helper ohne Argumente auf, damit er einen Container zurückgibt mit dem man arbeiten
kann. Man gibt diesen Container aus (echo) um Ihn darzustellen, oder ruft auf Ihm Methoden auf um Ihn zu
konfigurieren oder auszugeben. Wenn der Container leer ist, wird seine Darstellung einfach einen leeren String
zurückgeben; andernfalls wird der Inhalt zusammengefasst entsprechend der Regeln welche konfiguriert worden sind.

Als Beispiel erstellen wir eine Sidebar die aus einer Anzahl an "Blöcken" von Inhalten besteht. Man wird
normalerweise die Struktur jeden Blocks aus dem Bauch heraus wissen; nehmen wir für dieses Beispiel an dass Sie
wie folgt aussieht:

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <p>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus
               consectetur aliquet odio ac consectetur. Nulla quis eleifend
               tortor. Pellentesque varius, odio quis bibendum consequat, diam
               lectus porttitor quam, et aliquet mauris orci eu augue.
           </p>
       </div>
       <div class="block">
           <ul>
               <li><a href="/some/target">Link</a></li>
               <li><a href="/some/target">Link</a></li>
           </ul>
       </div>
   </div>

Der Inhalt veriiert basieren auf dem Controller und der Aktion, aber die Struktur ist die gleiche. Zuerst stellen
wir die Sidebar in der Sidebar einer Ressource Methode unserer Bootstrap ein:

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initSidebar()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');

           $view->placeholder('sidebar')
                // "prefix" -> Markup der einmalig vor allen Elementen
                // der Kollektion auszugeben ist
                ->setPrefix("<div class=\"sidebar\">\n    <div class=\"block\">\n")
                // "separator" -> Markup der zwischen Elementen
                // der Kollektion auszugeben ist
                ->setSeparator("</div>\n    <div class=\"block\">\n")
                // "postfix" -> Markup der einmalig nach allen Elementen
                // der Kollektion auszugeben ist
                ->setPostfix("</div>\n</div>");
       }

       // ...
   }

Das obige definiert den Platzhalter "sidebar" der keine Elemente hat. Er konfiguriert die grundsätzliche Struktur
des Markups dieses Platzhalter, aber basieren auf unseren Anforderungen.

Jetzt nehmen wir für den "user" Controller an das wir für alle Aktionen einen Block ganz oben wollen der einige
Informationen enthält. Wir können das auf zwei Wegen erreichen: (a) wir könnten den Inhalt direkt dem
Platzhalter mit der Methode ``preDispatch()`` des Controllers hinzufügen, oder (b) wir könnten ein View Skript in
der ``preDispatch()`` Methode darstellen. Wir verwenden (b) da es einer besseren Trennung der Wünsche folgt (indem
es View-betreffende Logik und Funktionalität im View Skript behält).

Wir benennen das View Skript "``user/_sidebar.phtml``", und machen es wir folgt bekannt:

.. code-block:: php
   :linenos:

   <?php $this->placeholder('sidebar')->captureStart() ?>
   <h4>Benutzer Administration</h4>
   <ul>
       <li><a href="<?php $this->url(array('action' => 'list')) ?>">
           Liste</a></li>
       <li><a href="<?php $this->url(array('action' => 'create')) ?>">
           Erstellen</a></a></li>
   </ul>
   <?php $this->placeholder('sidebar')->captureEnd() ?>

Das obige Beispiel verwendet das Capture Feature für den Inhalt des Platzhalters. Standardmäßig wird Inhalt dem
Container als neues Element angehängt, was es erlaubt Ihn zu sammeln. Dieses Beispiel verwendet View Helfer und
statisches *HTML* um Markup zu erzeugen. Der Inhalt wird anschließend gefangen und dem Platzhalter selbst
angehängt.

Um das oben stehende View Skript einzubinden würden wir das folgende in unserer ``preDispatch()`` Methode
schreiben:

.. code-block:: php
   :linenos:

   class UserController extends Zend_Controller_Action
   {
       // ...

       public function preDispatch()
       {
           // ...

           $this->view->render('user/_sidebar.phtml');

           // ...
       }

       // ...
   }

Es ist zu beachten das wir den dargestellten Wert nicht fangen; es gibt keine Notwendigkeit dafür da die komplette
View in einem Platzhalter gefangen wird.

Nehmen wir also an das unsere "view" Aktion die im selben Controlle ist einige Informationen anzeigen muss. Im View
Skript "``user/view.phtml``" könnten wie den folgende Inhalts Abschnitt haben:

.. code-block:: php
   :linenos:

   $this->placeholder('sidebar')
        ->append('<p>Benutzer: ' . $this->escape($this->username) .  '</p>');

Dieses Beispiel verwendet die ``append()`` Methode und übergibt Ihr etwas einfachen Markup zum sammeln.

Letztendlich verändern wir das Layout View Skript und stellen den Platzhalter dar.

.. code-block:: php
   :linenos:

   <html>
   <head>
       <title>Meine Site</title>
   </head>
   <body>
       <div class="content">
           <?php echo $this->layout()->content ?>
       </div>
       <?php echo $this->placeholder('sidebar') ?>
   </body>
   </html>

Für Controller und Aktionen welche den "sidebar" Platzhalter nicht verwenden wird kein Inhalt dargestellt; für
jene die es tun wird, wenn der Platzhalter ausgegeben wird der Inhalt, entsprechend der Regeln die in unserer
Bootstrap erstellt wurden, dargestellt als auch der Inhalt den wir über die Anwendung hinaus sammeln. Im Falle der
"``/user/view``" Aktion, und der Annahme des Benutzernamens "matthew" würden wir den folgenden Inhalt der Sidebar
erhalten (aus Gründen der Lesbarkeit formatiert):

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <h4>Benutzer Administration</h4>
           <ul>
               <li><a href="/user/list">Liste</a></li>
               <li><a href="/user/create">Erstellen</a></a></li>
           </ul>
       </div>
       <div class="block">
           <p>Benutzer: matthew</p>
       </div>
   </div>

Es gibt eine große Anzahl an Dinge die man tun kann wenn Platzhalter und Layout Skripte kombiniert werden; man
sollte mit Ihnen experimentieren und das :ref:`betreffende Kapitel im Handbuch
<zend.view.helpers.initial.placeholder>` für weitere Informationen lesen.


