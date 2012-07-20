.. _learning.view.placeholders.standard:

Standard Platzhalter
====================

In der :ref:`vorherigen Sektion <learning.view.placeholders.basics>`, haben wir den ``placeholder()`` View Helfer
kennengelernt, und wie er für das Sammeln eigener Inhalte verwendet werden kann. In dieser Sektion sehen wir uns
einige konkrete Platzhalter an die mit Zend Framework ausgeliefert werden, und wie Sie für den eigenen Vorteil
verwendet werden können wenn komplexe kombinierte Layouts erstellt werden.

Die meisten mitgelieferten Platzhalter sind für die Erstellung von Inhalten der **<head>** Sektion des Layout
Inhalts -- ein Areal das man normalerweise nicht direkt über Anwendungs View Skripte manipuliert, aber eines das
man beeinflussen will. Als Beispiel: Wenn man will das der Titel auf jeder Seite bestimmte Inhalte enthält, aber
spezifische Inhalte auf dem Controller und/oder der Aktion basieren; wenn man *CSS* Dateien spezifizieren will um
Sie basieren auf der Sektion in der man sich befindet zu Laden; wenn man spezifische JavaScript Skripts zu
unterschiedlichen Zeiten laden will; oder wenn man die **DocType** Deklaration setzen will.

Zend Framework wird mit einer Platzhalter Implementation für jede dieser Situationen ausgeliefert, und
verschiedenen mehr.

.. _learning.view.placeholders.standard.doctype:

Setzen vom DocType
------------------

Die **DocType** Deklaration ist problematisch zu merken, und oft ist es essentiell Sie in die Dokumente einzubinden
um sicherzustellen das der Browser den Inhalt richtig darstellt. Der ``doctype()`` View Helfer erlaubt es einfache
String Merkmale zu verwenden um den gewünschten **DocType** zu spezifizieren; zusätzlich fragen andere Helfer den
``doctype()`` ab, um sicherzustellen dass die erzeugte Ausgabe mit dem angefragten **DocType** übereinstimmt.

Wenn man als Beispiel *XHTML1* Strict *DTD* verwenden will kann man einfach folgendes spezifizieren:

.. code-block:: php
   :linenos:

   $this->doctype('XHTML1_STRICT');

Neben anderen vorhandenen Gedächnishilfen sind die folgenden Typen zu finden:

**XHTML1_STRICT**
   *XHTML* 1.0 Strict

**XHTML1_TRANSITIONAL**
   *XHTML* 1.0 Transitional

**HTML4_STRICT**
   *HTML* 4.01 Strict

**HTML4_Loose**
   *HTML* 4.01 Loose

**HTML5**
   *HTML* 5

Man kann den Typ zuordnen und die Deklaration in einem einzelnen Aufruf darstellen:

.. code-block:: php
   :linenos:

   echo $this->doctype('XHTML1_STRICT');

Trotzdem ist der bessere Ansatz den Typ in der Bootstrap zuzuordnen, und Ihn dann im Layout darzustellen. Man
könnte versuchen das folgende in der Bootstrap Klasse hinzuzufügen:

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDocType()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');
       }
   }

Und dann im Layout Skript einfach auf dem Helfer am Beginn der Datei ``echo()`` ausrufen:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <!-- ... -->

Das stellt sicher dass DocType-beachtende View Helfer das richtige Markup darstellen, das der Typ richtig gesetzt
ist bevor das Layout dargestellt wird, und bietet einen einzelnen Ort an dem der DocType geändert werden kann.

.. _learning.view.placeholders.standard.head-title:

Den Titel der Seite spezifizieren
---------------------------------

Oft will eine Site den Namen der Site oder der Firma als Teil des Seitentitels einfügen, und dann zusätzliche
Informationen basieren auf dem Ort in dieser Site einfügen. Als Beispiel enthält die Website ``zend.com`` den
String "``Zend.com``" auf allen Seiten und fügt Informationen basierend auf der Seite voran: "Zend Server
-``Zend.com``". Im Zend Framework kann der ``headTitle()`` View Helfer helfen diese Aufgabe zu vereinfachen.

Am einfachsten erlaubt es der ``headTitle()`` Helfer den Inhalt zu für das **<title>** Tag zu sammeln; wenn man es
ausgibt, wird es basierend auf der Reihenfolge mit der es hinzugefügt wurde zusammengefügt. Man kann die
Reihenfolge kontrollieren indem ``prepend()`` und ``append()`` verwendet werden, und einen Separator angegeben
welcher zwischen den Segmenten zu verwenden ist, indem die Methode ``setSeparator()`` verwendet wird.

Typischerweise sollten jene Segmente die in allen Seiten gemeinsam sind in der Bootstrap spezifiziert werden,
ähnlich wie wir den DocType definiert haben. In diesem Fall definieren wir eine ``_initPlaceholders()`` Methode um
auf den verschiedenen Platzhaltern zu arbeiten, und einen initialen Titel sowie einen Separator zu spezifizieren.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Setzt den initialen Titel und Separator:
           $view->headTitle('Meine Site')
                ->setSeparator(' :: ');
       }

       // ...
   }

Im View Skript könnten wir ein weiteres Segment hinzufügen:

.. code-block:: php
   :linenos:

   <?php $this->headTitle()->append('Eine Seite');  // Nach anderen Segmenten platzieren ?>
   <?php $this->headTitle()->prepend('Eine Seite'); // Davor platzieren ?>

In unserem Layout geben wie den ``headTitle()`` Helfer einfach aus:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <!-- ... -->

Das erzeugt die folgende Ausgabe:

.. code-block:: html
   :linenos:

   <!-- Wenn append() verwendet wurde: -->
   <title>Meine Site :: Eine Seite</title>

   <!-- Wenn prepend() verwendet wurde: -->
   <title>Eine Seite :: Meine Site</title>

.. _learning.view.placeholders.standard.head-link:

Stylesheets mit HeadLink spezifizieren
--------------------------------------

Gute *CSS* Entwickler erstellen oft ein generisches Stylesheet für Siteweite Stile, und individuelle Stylesheets
für spezifische Sektionen oder Seite der Website, und laden die zweiteren über Konditionen um die Menge der Daten
zu verringern die bei jeder Anfrage übertragen werden müssen. Der ``headLink()`` Platzhalter macht die Sammlung
von solchen konditionellen Stylesheets in der Anwendung trivial.

Um das zu ermöglichen definiert ``headLink()`` eine Anzahl von "virtuellen" Methoden (durch Überladen) welche den
Prozess trivial machen. Jene mit denen wir uns befassen sind ``appendStylesheet()`` und ``prependStylesheet()``.
Jede nimmt bis zu vier Argumente, ``$href`` (den relativen Pfad zum Stylesheet), ``$media`` (den *MIME* Typ, der
standardmäßig "text/css" ist), ``$conditionalStylesheet`` (kann verwendet werden um eine "Kondition" zu
spezifizieren bei dem das Stylesheet evaluiert wird), und ``$extras`` (ein assoziatives Array von Schlüssel und
Werte Paare, üblicherweise verwendet um einen Schlüssel für "media" zu definieren). In den meisten Fällen muss
man nur das erste Argument spezifizieren, den relativen Pfad zum Stylesheet.

In unserem Beispiel nehmen wir an das alle Seiten das Stylesheet laden mussen welches in "``/styles/site.css``"
vorhanden ist (relativ zum Dokument Root); wir spezifizieren dass in unserer Bootstrap Methode
``_initPlaceholders()``.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Setzt den initialen Titel und Separator:
           $view->headTitle('Meine Site')
                ->setSeparator(' :: ');

           // Setzt das initiale Stylesheet:
           $view->headLink()->prependStylesheet('/styles/site.css');
       }

       // ...
   }

Später, im Controller oder einem Action-spezifischen View Skript, können wir weitere Stylesheets hinzufügen:

.. code-block:: php
   :linenos:

   <?php $this->headLink()->appendStylesheet('/styles/user-list.css') ?>

In unserem Layout View Skript geben wir den Platzhalter einfach wieder aus:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <!-- ... -->

Das erzeugt die folgende Ausgabe:

.. code-block:: html
   :linenos:

   <link rel="stylesheet" type="text/css" href="/styles/site.css" />
   <link rel="stylesheet" type="text/css" href="/styles/user-list.css" />

.. _learning.view.placeholders.standard.head-script:

Sammeln von Skripten durch Verwendung von HeadScript
----------------------------------------------------

Eine andere gemeinsame Taktik um lange Ladezeiten bei Seiten zu verhindern besteht darin JavaScript nur dann zu
Laden wenn es notwendig ist. So gesehen benötigt man verschiedene Layer von Skripten: möglicherweise einen für
die fortlaufende Verbesserung der Menüs der Site, und einen weiteren für Seiten-spezifische Inhalte. In diesen
Situationen bietet der ``headScript()`` Helfer eine Lösung.

Ähnlich wie der ``headLink()`` Helfer bietet ``headScript()`` die Möglichkeit Skripte der Sammlung anzuhängen
oder voranzustellen, und dann das komplette Set auszugeben. Es bietet die Flexibilität Skriptdateien zu
spezifizieren damit diese selbst geladen werden, als auch explizit JavaScript. Man hat auch die Option JavaScript
über ``captureStart()``/``captureEnd()`` einzufangen, was es erlaubt JavaScript einfach im Code zu haben statt
notwendigerweise einen zusätzlichen Aufruf zum Server zu machen.

So wie ``headLink()`` bietet ``headScript()``"virtuelle" Methoden durch Überladen als Bequemlichkeit wenn Elemente
spezifiziert werden um Sie zu sammeln; übliche Methoden sind ``prependFile()``, ``appendFile()``,
``prependScript()``, und ``appendScript()``. Die ersten zwei erlauben es Dateien zu spezifizieren auf die im
``$src`` Attribut des **<script>** Tags referenziert wird; die letzteren zwei nehmen den angegebenen Inhalt und
stellen Ihn als literales JavaScript im **<script>** Tag dar.

In diesem Beispiel spezifizieren wir ein Skript, "``/js/site.js``" muss bei jeder Seite geladen werden; wir
aktualisieren die ``_initPlaceholders()`` Methode in der Bootstrap um das zu tun.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Setzt den initialen Titel und Separator:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');

           // Setzt das initiale Stylesheet:
           $view->headLink()->prependStylesheet('/styles/site.css');

           // Setzt das initiale JS das geladen werden soll:
           $view->headScript()->prependFile('/js/site.js');
       }

       // ...
   }

In einem View Skript können wir dann eine extra Skript Datei der Quelle hinzufügen um etwas JavaScript zu sammeln
und es in unserem Dokument einzufügen.

.. code-block:: php
   :linenos:

   <?php $this->headScript()->appendFile('/js/user-list.js') ?>
   <?php $this->headScript()->captureStart() ?>
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   <?php $this->headScript()->captureEnd() ?>

In unserem Layout Skript wird der Platzhalter dann einfach ausgegeben, wie wir es bereits bei den anderen gemacht
haben:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <?php echo $this->headScript() ?>
       <!-- ... -->

Das erstellt die folgende Ausgabe:

.. code-block:: html
   :linenos:

   <script type="text/javascript" src="/js/site.js"></script>
   <script type="text/javascript" src="/js/user-list.js"></script>
   <script type="text/javascript">
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   </script>

.. note::

   **InlineScript Variante**

   Viele Browser blockieren oft die Anzeige von Seiten bis alle Skripte und Stylesheets geladen wurden auf die in
   der **<head>** Sektion referenziert wird. Wenn man eine Anzahl solcher Direktiven hat, kann das Einfluß darauf
   haben wie bald jemand damit beginnen kann sich die Seite anzuschauen:

   Ein Weg darum zu kommen besteht darin die **<script>** Tags einfach nach dem schließenden **<body>** Tag des
   Dokuments auszugeben. (Das ist eine Praxis die speziell vom `Y! Slow Projekt`_ empfohlen wird)

   Zend Framework unterstützt das auf zwei unterschiedlichen Wegen:

   - Man kann das ``headScript()`` Tag im Layout Skript überall wo man will darstellen; nur weil der Titel auf
     "head" referenziert heißt das nicht dass er an dieser Position dargestellt werden muss.

   - Alternativ kann der ``inlineScript()`` Helfer verwendet werden der einfach eine Variante von ``headScript()``
     ist und das selbe Verhalten hat, aber eine eigene Registry verwendet.



.. _`Y! Slow Projekt`: http://developer.yahoo.com/yslow/
