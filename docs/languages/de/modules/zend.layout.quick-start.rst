.. _zend.layout.quickstart:

Zend_Layout Schnellstart
========================

Es gibt zwei primäre Verwendungen für ``Zend_Layout``: Mit dem Zend Framework *MVC*, und ohne.

.. _zend.layout.quickstart.layouts:

Layout Skripte
--------------

In beiden Fällen, müssen trotzdem Layout Skripte erstellt werden. Layout Sktipte verwenden einfach ``Zend_View``
(oder welche View Implementation auch immer verwendet wird). Layout Variablen werden mit einem ``Zend_Layout``
:ref:`Platzhalter <zend.view.helpers.initial.placeholder>` registriert, und es kann auf Sie über den Platzhalter
Helfer zugegriffen werden oder dadurch das Sie als Objekt Eigenschaften vom Layout Objekt über den Layout Helfer
geholt werden.

Als Beispiel:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>Meine Seite</title>
   </head>
   <body>
   <?php
       // Holt den 'content' Schlüssel durch Verwendung des Layout Helfers:
       echo $this->layout()->content;

       // Holt den 'foo' Schlüssel durch Verwendung des Platzhalter Helfers:
       echo $this->placeholder('Zend_Layout')->foo;

       // Holt das Layout Objekt und empfängt verschiedene Schlüssel von Ihm:
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

Weil ``Zend_Layout`` ``Zend_View`` für die Darstellung verwendet, kann auch jeder registrierte View Helfer
verwendet werden, und auch auf jede zuvor zugeordnete View Variable kann zugegriffen werden. Sehr hilfreich sind
die verschiedenen :ref:`Platzhalter Helfer <zend.view.helpers.initial.placeholder>`, da diese das Empfangen von
Inhalt für einen Bereich wie die <head> Sektion, Navigation usw. erlauben:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <?php echo $this->headTitle() ?>
       <?php echo $this->headScript() ?>
       <?php echo $this->headStyle() ?>
   </head>
   <body>
       <?php echo $this->render('header.phtml') ?>

       <div id="nav"><?php echo $this->placeholder('nav') ?></div>

       <div id="content"><?php echo $this->layout()->content ?></div>

       <?php echo $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

Zend_Layout mit dem Zend Framework MVC verwenden
------------------------------------------------

``Zend_Controller`` bietet ein reiches Set von Funktionalitäten für Erweiterung mit seinen :ref:`Front Controller
Plugins <zend.controller.plugins>` und :ref:`Action Controller Helfern <zend.controller.actionhelpers>`.
``Zend_View`` hat auch :ref:`Helfer <zend.view.helpers>`. ``Zend_Layout`` nimmt Vorteile wahr von diesen
verschiedenen Erweiterungspunkten wenn es mit den *MVC* Komponenten verwendet wird.

``Zend_Layout::startMvc()`` erstellt eine Instanz von ``Zend_Layout`` mit jeder optionalen Konfiguration die
angegeben wird. Anschließend wird ein Front Controller Plugin registriert welches das Layout mit jedem
Anwendungsinhalt darstellt sobald die Dispatch Schleife fertiggestellt ist, und registriert einen Action Helfer der
den Zugriff auf das Layout Objekt vom Action Controller aus gestattet. Zusätzlich kann jederzeit die Layout
Instanz vom View Skript geholt werden indem der ``Layout`` View Helfer verwendet wird.

Zuerst sehen wir uns an wie ``Zend_Layout`` initialisiert wird um es mit dem *MVC* zu verwenden:

.. code-block:: php
   :linenos:

   // In der Bootstrap Datei:
   Zend_Layout::startMvc();

``startMvc()`` kann ein optionales Array von Optionen oder ein ``Zend_Config`` Objekt entgegennehmen um die Instanz
anzupassen; diese Optionen werden detailiert in :ref:`diesem Abschnitt <zend.layout.options>` beschrieben.

In einem Action Controller, kann anschließend auf die Layout Instanz als Action Helfer zugegriffen werden:

.. code-block:: php
   :linenos:

   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // Layouts in dieser Aktion deaktivieren:
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // Ein anderes Layout Skript in dieser Action verwenden:
           $this->_helper->layout->setLayout('foobaz');
       };
   }

Im View Skript kann dann auf das Layout Objekt über den ``Layout`` View Helfer zugegriffen werden. Dieser View
Helfer ist etwas anders als andere da er keine Argumente entgegennimmt und ein Objekt statt einem Stringwert
zurückgibt. Das erlaubt sofortige Methodenaufrufe auf dem Layout Objekt:

.. code-block:: php
   :linenos:

   $this->layout()->setLayout('foo'); // alternatives Layout setzen

Die im *MVC* registrierte ``Zend_Layout`` Instanz kann jederzeit über die statische ``getMvcInstance()`` Methode
geholt werden:

.. code-block:: php
   :linenos:

   // Gibt null zurück wenn startMvc() nicht zuerst aufgerufen wurde
   $layout = Zend_Layout::getMvcInstance();

Letztendlich hat das Front Controller Plugin von ``Zend_Layout`` ein wichtiges Feature zusätzlich zur Darstellung
des Layouts: Es empfängt alle benannte Segmente vom Antwortobjekt und ordnet diese als Layout Variablen zu, wobei
das 'default' Segment der 'content' Variable zugeordnet wird. Das erlaubt es auf den Anwendungsinhalt zugreifen zu
können und es in View Skripten darzustellen.

Als Beispiel, nehmen wir an das der Code zuerst ``FooController::indexAction()`` auslöst, welches einige Inhalte
im standardmäßigen Antwortobjekt darstellt, und dann zu ``NavController::menuAction()`` weiterleitet, welches
Inhalt im 'nav' Antwortobjekt darstellt. Letztendlich wird auf ``CommentController::fetchAction()`` weitergeleitet
und einige Kommentare geholt, aber diese werden auch im standard Antwortobjekt dargestellt. (was Inhalt zu diesem
Segment anfügt). Das View Skript kann dann jedes separat darstellen:

.. code-block:: php
   :linenos:

   <body>
       <!-- Darstellung von /nav/menu -->
       <div id="nav"><?php echo $this->layout()->nav ?></div>

       <!-- Darstellung von /foo/index + /comment/fetch -->
       <div id="content"><?php echo $this->layout()->content ?></div>
   </body>

Dieses Feature ist teilweise nützlich wenn es in Verbindung mit dem ActionStack :ref:`Action Helfer
<zend.controller.actionhelpers.actionstack>` und :ref:`Plugin <zend.controller.plugins.standard.actionstack>`
verwendet wird, welche verwendet werden können um einen Stack von Aktionen zu definieren der durchgelaufen wird,
und welcher angepasste Seiten erstellt.

.. _zend.layout.quickstart.standalone:

Zend_Layout als eienständige Komponente verwenden
-------------------------------------------------

Als eigenständige Komponente bietet ``Zend_Layout`` nicht annähernd so viele Features oder so viel Bequemlichkeit
wie wenn es mit *MVC* verwendet wird. Trotzdem hat es zwei grundsätzliche Vorteile:

- Abgrenzung von Layout Variablen.

- Isolation vom Layout View Skript von anderen View Skripten.

Wenn es als eigenständige Komponente verwendet wird, muß einfach das Layout Objekt instanziiert werden, die
unterschiedlichen Zugriffsmethoden verwendet werden um Stati zu setzen, Variablen als Objekt Eigenschaften gesetzt,
und das Layout dargestellt werden:

.. code-block:: php
   :linenos:

   $layout = new Zend_Layout();

   // Einen Layout Skript Pfad setzen:
   $layout->setLayoutPath('/path/to/layouts');

   // Einige Variablen setzen:
   $layout->content = $content;
   $layout->nav     = $nav;

   // Ein unterschiedliches Layout Skript auswählen:
   $layout->setLayout('foo');

   // Letztendlich das Layout darstellen
   echo $layout->render();

.. _zend.layout.quickstart.example:

Beispiel Layout
---------------

Machmal ist ein Bild mehr Wert als tausend Wörter. Das folgende ist ein Beispiel Layout Skript das zeigt wie alles
zusammenkommen könnte.

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

Die aktuelle Reihenfolge der Elemente kann variieren, abhängig vom *CSS* das eingestellt wurde; zum Beispiel, wenn
absolute Positionen verwendet werden, kann es möglich sein das die Navigation später im Dokument angezeigt wird,
aber immer noch ganz oben gezeigt wird; das selbe könnte für die Sidebar oder den Header gelten. Der aktuelle
Mechanismum des Holens von Inhalt bleibt trotzdem der selbe.


