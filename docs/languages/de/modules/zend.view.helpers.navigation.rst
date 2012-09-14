.. EN-Revision: none
.. _zend.view.helpers.initial.navigation:

Navigations Helfer
==================

Die Navigations Helfer werden von :ref:`Zend\Navigation\Container <zend.navigation.containers>` für die
Darstellung von Navigations Elementen verwendet.

Es gibt 2 eingebaute Helfer:

- :ref:`Breadcrumbs <zend.view.helpers.initial.navigation.breadcrumbs>`, wird für die Darstellung des Pfades der
  aktuell aktiven Seite verwendet.

- :ref:`Links <zend.view.helpers.initial.navigation.links>`, wird für die Darstellung von Navigations Header Links
  (z.B. ``<link rel="next" href="..." />``) verwendet.

- :ref:`Menu <zend.view.helpers.initial.navigation.menu>`, wird für die Darstellung von Menüs verwendet.

- :ref:`Sitemap <zend.view.helpers.initial.navigation.sitemap>`, wird für die Darstellung von Sitemaps verwendet
  die dem `Sitemaps XML Format`_ entsprechen.

- :ref:`Navigation <zend.view.helpers.initial.navigation.navigation>`, wird für die Weiterleitung von Aufrufen zu
  anderen Navigations Helfern verwendet.

Alle eingebauten Helfer erweitern ``Zend\View\Helper\Navigation\HelperAbstract``, welches die Integration von
:ref:`ACL <zend.permissions.acl>` und :ref:`Übersetzung <zend.translator>` hinzufügt. Die abstrakte Klasse implementiert das
Interface ``Zend\View\Helper\Navigation\Helper`` welches die folgenden Methoden definiert:

- ``getContainer()`` und ``setContainer()`` empfängt/setzt den Navigations Container mit dem der Helfer
  standardmäßig arbeiten soll, und ``hasContainer()`` prüft ob der Helfer Container registriert hat.

- ``getTranslator()`` und ``setTranslator()`` empfängt und setzt den Übersetzer der für die Übersetzung von
  Überschriften und Titelm verwendet wird, und ``getUseTranslator()`` sowie ``setUseTranslator()`` kontrollieren
  ob der Übersetzer aktiviert werden soll. Die Methode ``hasTranslator()`` prüft ob der Helfer einen Übersetzer
  registriert hat.

- ``getAcl()``, ``setAcl()``, ``getRole()`` und ``setRole()`` empfangen und setzen *ACL* (``Zend\Permissions\Acl``) Instanzen
  und Rollen (``String`` oder ``Zend\Permissions\Acl\Role\RoleInterface``) die bei der Darstellung für das Filtern von Seiten
  verwendet werden. ``getUseAcl()`` und ``setUseAcl()`` kontrolliert ob *ACL* aktiviert werden soll. Die Methoden
  ``hasAcl()`` und ``hasRole()`` prüfen ob der Helfer eine *ACL* Instanz oder Rolle registriert hat.

- ``__toString()``, die magische Methode stellt sicher das der Helfer, durch die direkte Ausgabe an der Instanz des
  Helfers, dargestellt werden kann.

- ``render()``, muß von konkreten Helfern implementiert werden um die Darstellung durchzuführen.

Zusätzlich zu den Methoden die vom Interface kommen, implementiert die abstrakte Klasse die folgenden Methoden:



- ``getIndent()`` und ``setIndent()`` empfängt und setzt die Einrückung. Der Setzer akzeptiert einen ``String``
  oder ein ``Integer``. Im Fall eines ``Integer``'s verwendet der Helfer die angegebene Zahl als Leerzeichen für
  die Einrückung. Z.B. bedeutet ``setIndent(4)`` eine Einrückung von initial 4 Leerzeichen. Die Einrückung kann
  für alle Helfer außer dem Sitemap Helfer spezifiziert werden.

- ``getMinDepth()`` und ``setMinDepth()`` empfängt und setzt die minimale Tiefe die eine Seite haben muß um vom
  Helfer eingefügt zu werden. Das Setzen von ``NULL`` bedeutet keine minimale Tiefe.

- ``getMaxDepth()`` und ``setMaxDepth()`` empfängt und setzt die maximale Tiefe die eine Seite haben muß um vom
  Helfer eingefügt zu werden. Das Setzen von ``NULL`` bedeutet keine maximale Tiefe.

- ``getRenderInvisible()`` und ``setRenderInvisible()`` empfängt und setzt ob Elemente die als unsichtbar markiert
  sind, dargestellt werden oder nicht.

- ``__call()`` wird verwendet um Aufrufe zum Container, der im Helfer registriert ist, weiterzuleiten, was bedeutet
  das man Methoden in einem Helfer aufrufen kann wie wenn Sie im Container wären. Siehe das folgende
  :ref:`Beispiel <zend.view.helpers.initial.navigation.proxy.example>`.

- ``findActive($container, $minDepth, $maxDepth)`` wird verwendet um die tiefste aktive Seite im angegebenen
  Container zu finden. Wenn keine Tiefe angegeben wird, verwendet diese Methode die Werte die sie von
  ``getMinDepth()`` und ``getMaxDepth()`` erhält. Die tiefste aktive Seite muß zwischen ``$minDepth`` und
  ``$maxDepth`` inklusive liegen. Gibt ein Array zurück das Referenzen zu der gefundenen Instanz der Seite
  enthält, und die Tiefe bei der die Seite gefunden wurde.

- ``htmlify()`` stellt ein **'a'** *HTML* Element von einer ``Zend\Navigation\Page`` Instanz dar.

- ``accept()`` wird verwendet um zu erkennen ub eine Seite akzeptiert werden soll wenn durch Container iteriert
  wird. Diese Methode prüft die Sichtbarkeit der Seite und verifiziert das die Rolle des Helfers auf die
  Ressourcen und Privilegien der Seite zugreifen darf.

- Die statische Methode ``setDefaultAcl()`` wird für das Setzen des standardmäßigen *ACL* Objekts verwendet, das
  dann von Helfern verwendet wird.

- Die statische Methode ``setDefaultRole()`` wird für das Setzen der standardmäßigen *ACL* verwendet, die dann
  von Helfern verwendet wird.

Wenn ein Navigations Container nicht explizit in einem Helfer durch Verwendung von ``$helper->setContainer($nav)``
gesetzt ist, schaut der Helfer in :ref:`der Registry <zend.registry>` nach einer Container Instanz mit dem
Schlüssel ``Zend\Navigation``. Wenn ein Container nicht explizit gesetzt wurde, oder nicht in der Registry
gefunden wird, erstellt der Helfer einen leeren ``Zend\Navigation`` Container wenn ``$helper->getContainer()``
aufgerufen wird.

.. _zend.view.helpers.initial.navigation.proxy.example:

.. rubric:: Aufrufe an den Navigations Container weiterleiten

Navigations View Helfer verwenden die magisch ``__call()`` Methode um Methodenaufrufe an den Navigationscontainer
weiterzuleiten der im View Helfer registriert ist.

.. code-block:: php
   :linenos:

   $this->navigation()->addPage(array(
       'type' => 'uri',
       'label' => 'New page'));

Der obige Aufruf fügt eine Seite zum Container im ``Navigation`` Helfer hinzu.

.. _zend.view.helpers.initial.navigation.i18n:

Übersetzung von Labels und Titeln
---------------------------------

Der Navigations Helfer unterstützt die Übersetzung von SeitenLabels und Überschriften. Man kann einen
Übersetzer vom Typ ``Zend\Translator`` oder ``Zend\Translator\Adapter`` im Helfer setzen indem
``$helper->setTranslator($translator)`` verwendet wird, oder wie in allen anderen I18n-fähigen Komponenten; durch
das Hinzufügen des Übersetzers in :ref:`die Registry <zend.registry>` indem der Schlüssel ``Zend\Translator``
verwendet wird.

Wenn man die Übersetzung ausschalten will, sollte man ``$helper->setUseTranslator(false)`` verwenden.

Der :ref:`Proxy Helfer <zend.view.helpers.initial.navigation.navigation>` injiziert seinen eigenen Übersetzer in
den Helfer auf den er weiterleitet wenn der weitergeleitete Helfer nicht bereits einen Übersetzer hat.

.. note::

   Es gibt keinen Übersetzer im Sitemap Helfer, da keine SeitenLabels oder Überschriften in einer *XML* Sitemap
   enthalten sind.

.. _zend.view.helpers.initial.navigation.acl:

Integration mit ACL
-------------------

Alle navigatorischen View Helfer unterstützen *ACL* abgeleitet von der
``Zend\View\Helper\Navigation\HelperAbstract`` Klasse. Ein ``Zend\Permissions\Acl`` Objekt kann einer Instanz eines Helfers mit
*$helper->setAcl($acl)* hinzugefügt werden, und eine Rolle mit *$helper->setRole('member')* oder
*$helper->setRole(new Zend\Permissions\Acl\Role\GenericRole('member'))*. Wenn *ACL* im Helfer verwendet wird, muß es der Rolle im Helfer
vom *ACL* erlaubt sein auf die *Ressourcen* zuzugreifen und/oder das die *Privilegien* für diese Seite bei der
Darstellung eingefügt werden dürfen.

Wenn eine Seite vom *ACL* nicht akzeptiert ist, wird auch jede untergeordnete Seite von der Darstellung ausgenommen
sein.

Der :ref:`Proxy Helfer <zend.view.helpers.initial.navigation.navigation>` injiziert seine eigene *ACL* und Rolle in
den Helfer zu dem er weiterleitet wenn der weitergeleitete Helfer nicht bereits einen hat.

Das Beispiel von unten zeigt wie *ACL* die Darstellung beeinflusst.

.. _zend.view.helpers.initial.navigation.setup:

Setup der Navigation das in Beispielen verwendet wird
-----------------------------------------------------

Dieses Beispiel zeigt das Setup eines Navigations Container für eine fiktive Software Firma.

Notizen zum Setup:

- Die Domain der Site ist *www.example.com*.

- Interessante Eigenschaften der Seite sind mit einem Kommentar markiert.

- Solange im Beispiel nicht anders erwähnt, fragt der Benutzer nach der *URL*
  *http://www.example.com/products/server/faq/*, welche auf die Seite mit dem Label ``FAQ`` unter *Foo Server*
  übersetzt wird.

- Das angenommene *ACL* und Route Setup wird unter dem Container Setup gezeigt.

.. code-block:: php
   :linenos:

   /*
    * Navigations Container (config/array)

    * Jedes Element im Array wird an Zend\Navigation\Page::factory()
    * übergeben wenn der unten angezeigt Navigations Container
    * erstellt wird.
    */
   $pages = array(
       array(
           'label'      => 'Home',
           'title'      => 'Geh zu Home',
           'module'     => 'default',
           'controller' => 'index',
           'action'     => 'index',
           'order'      => -100 // Sicherstellen das Home die erste Seite ist
       ),
       array(
           'label'      => 'Spezielles Angebot nur diese Woche!',
           'module'     => 'store',
           'controller' => 'offer',
           'action'     => 'amazing',
           'visible'    => false // nicht sichtbar
       ),
       array(
           'label'      => 'Produkte',
           'module'     => 'products',
           'controller' => 'index',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'Foo Server',
                   'module'     => 'products',
                   'controller' => 'server',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'FAQ',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'faq',
                           'rel'        => array(
                               'canonical' => 'http://www.example.com/?page=faq',
                               'alternate' => array(
                                   'module'     => 'products',
                                   'controller' => 'server',
                                   'action'     => 'faq',
                                   'params'     => array('format' => 'xml')
                               )
                           )
                       ),
                       array(
                           'label'      => 'Editionen',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'editions'
                       ),
                       array(
                           'label'      => 'System Anforderungen',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'requirements'
                       )
                   )
               ),
               array(
                   'label'      => 'Foo Studio',
                   'module'     => 'products',
                   'controller' => 'studio',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'Kunden Stories',
                           'module'     => 'products',
                           'controller' => 'studio',
                           'action'     => 'customers'
                       ),
                       array(
                           'label'      => 'Support',
                           'module'     => 'prodcts',
                           'controller' => 'studio',
                           'action'     => 'support'
                       )
                   )
               )
           )
       ),
       array(
           'label'      => 'Firma',
           'title'      => 'Über uns',
           'module'     => 'company',
           'controller' => 'about',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'Investor Relations',
                   'module'     => 'company',
                   'controller' => 'about',
                   'action'     => 'investors'
               ),
               array(
                   'label'      => 'News',
                   'class'      => 'rss', // Klasse
                   'module'     => 'company',
                   'controller' => 'news',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'Für die Presse',
                           'module'     => 'company',
                           'controller' => 'news',
                           'action'     => 'press'
                       ),
                       array(
                           'label'      => 'Archiv',
                           'route'      => 'archive', // Route
                           'module'     => 'company',
                           'controller' => 'news',
                           'action'     => 'archive'
                       )
                   )
               )
           )
       ),
       array(
           'label'      => 'Community',
           'module'     => 'community',
           'controller' => 'index',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'Mein Account',
                   'module'     => 'community',
                   'controller' => 'account',
                   'action'     => 'index',
                   'resource'   => 'mvc:community.account' // Ressource
               ),
               array(
                   'label' => 'Forum',
                   'uri'   => 'http://forums.example.com/',
                   'class' => 'external' // Klasse
               )
           )
       ),
       array(
           'label'      => 'Administration',
           'module'     => 'admin',
           'controller' => 'index',
           'action'     => 'index',
           'resource'   => 'mvc:admin', // Ressource
           'pages'      => array(
               array(
                   'label'      => 'Neuen Artikel schreiben',
                   'module'     => 'admin',
                   'controller' => 'post',
                   'aciton'     => 'write'
               )
           )
       )
   );

   // Container von einem Array erstellen
   $container = new Zend\Navigation($pages);

   // Den Container im Proxy Helfer speichern
   $view->getHelper('navigation')->setContainer($container);

   // ...oder einfach:
   $view->navigation($container);

   // ...oder ihn einfach in der Registry speichern:
   Zend_Registry::set('Zend\Navigation', $container);

Zusätzlich zum obigen Container, wird das folgende Setup angenommen:

.. code-block:: php
   :linenos:

   // Router Setup (Standardrouten und 'archive' Route):
   $front = Zend_Controller_Front::getInstance();
   $router = $front->getRouter();
   $router->addDefaultRoutes();
   $router->addRoute(
       'archive',
       new Zend_Controller_Router_Route(
           '/archive/:year',
           array(
               'module'     => 'company',
               'controller' => 'news',
               'action'     => 'archive',
               'year'       => (int) date('Y') - 1
           ),
           array('year' => '\d+')
       )
   );

   // ACL Setup:
   $acl = new Zend\Permissions\Acl\Acl();
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('member'));
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('admin'));
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('mvc:admin'));
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('mvc:community.account'));
   $acl->allow('member', 'mvc:community.account');
   $acl->allow('admin', null);

   // ACL und Rolle im Proxy Helfer speichern:
   $view->navigation()->setAcl($acl)->setRole('member');

   // ...oder ein standard ACL und Rolle statisch setzen:
   Zend\View\Helper\Navigation\HelperAbstract::setDefaultAcl($acl);
   Zend\View\Helper\Navigation\HelperAbstract::setDefaultRole('member');

.. _zend.view.helpers.initial.navigation.breadcrumbs:

Breadcrumbs Helfer
------------------

Breadcrumbs werden verwendet um anzuzeigen wo in einer Sitemap ein Benutzer aktuell browst, und werden
typischerweise wie folgt angezeigt: "Du bist hier: Home > Produkte > FantastischesProdukt 1.0". Der BreakCrumbs
Helfer folgt den Richtlinien von `Breadcrumbs Pattern - Yahoo! Design Pattern Library`_, und erlaubt eine einfache
Anpassung (Minimale/Maximale Tiefe, Einrückung, Trennzeichen, und ob das letzte Element verlinkt sein soll), oder
die Darstellung durch Verwendung eines partiellen View Skripts.

Der Breabcrumbs Helfer funktioniert wie folgt; er findet die tiefste aktive Seite in einem Navigations Container,
und stellt den aufwärtsgerichteten Pfad zum Root dar. Für *MVC* Seiten wird die "Aktivität" einer Seite erkannt
indem das Anfrage Objekt angeschaut wird, wie im Kapitel :ref:`Zend\Navigation\Page\Mvc
<zend.navigation.pages.mvc>` beschrieben.

Der Helfer setzt die Eigenschaft *minDepth* standardmäßig auf 1, was bedeutet das Breadcrumbs nicht dargestellt
werden wenn die tiefste aktive Seite eine Root Seite ist. Wenn *maxDepth* spezifiziert ist, beendet der Helfer die
Darstellung bei der spezifizierten Tiefe (z.B. stopp bei Level 2 selbst wenn die tiefste aktive Seite auf Level 3
ist).

Methoden im Breakcrumbs Helfer sind:

- *{get|set}Separator()* empfängt/setzt das Trennzeichen das zwischen Breakcrumbs verwendet wird. Der Standardwert
  ist *' &gt; '*.

- *{get|set}LinkLast()* empfängt/setzt ob der letzte Breabcrumb als Anker dargestellt werden soll oder nicht. Der
  Standardwert ist ``FALSE``.

- *{get|set}Partial()* empfängt/setzt ein partielles View Skript das für die Darstellung von Breadcrumbs
  verwendet werden soll. Wenn ein partielles View Skript gesetzt ist, verwendet die ``render()`` Methode des
  Helfers die ``renderPartial()`` Methode. Wenn kein partielles gesetzt ist, wird die ``renderStraight()`` Methode
  verwendet. Der Helfer erwartet das der partielle ein ``String`` oder ein ``Array`` mit zwei Elementen ist. Wen
  der Partielle ein ``String`` ist, benennt er den Namen des partiellen Skripts das zu verwenden ist. Wenn er ein
  ``Array`` ist, wird das erste Element als Name des partiellen View Skripts verwendet, und das zweite Element ist
  das Modul in dem das Skript zu finden ist.

- ``renderStraight()`` ist die standardmäßige render Methode.

- ``renderPartial()`` wird für die Darstellung verwendet wenn ein partielles View Skript verwendet wird.

.. _zend.view.helpers.initial.navigation.breadcrumbs.example1:

.. rubric:: Darstellung von Breadcrumbs

Dieses Beispiel zeigt wie Breadcrumbs mit Standardsettings dargestellt werden.

.. code-block:: php
   :linenos:

   In einem View Skript oder Layout:
   <?php echo $this->navigation()->breadcrumbs(); ?>

   Die zwei obigen Aufrufe verwenden die magische __toString() Methode,
   und sind identisch mit:
   <?php echo $this->navigation()->breadcrumbs()->render(); ?>

   Ausgabe:
   <a href="/products">Produkte</a> > <a href="/products/server">Foo Server</a> > FAQ

.. _zend.view.helpers.initial.navigation.breadcrumbs.example2:

.. rubric:: Einrückung spezifizieren

Dieses Beispiel zeigt wie Breadcrumbs mit anfänglicher Einrückung dargestellt werden können.

.. code-block:: php
   :linenos:

   Darstellung mit 8 Leerzeichen Einrückung:
   <?php echo $this->navigation()->breadcrumbs()->setIndent(8); ?>

   Ausgabe:
           <a href="/products">Products</a> > <a href="/products/server">Foo Server</a> > FAQ

.. _zend.view.helpers.initial.navigation.breadcrumbs.example3:

.. rubric:: Eigene Ausgabe für Breakcrumbs

Dieses Beispiel zeigt wie man eine eigene Breadcrumbs Ausgabe durch die Spezifizierung diverser Optionen erstellt.

.. code-block:: php
   :linenos:

   In einem View Skript oder Layout:

   <?php
   echo $this->navigation()
             ->breadcrumbs()
             ->setLinkLast(true)                   // Letzte Seite verlinken
             ->setMaxDepth(1)                      // Bei Level 1 stoppen
             ->setSeparator(' ▶' . PHP_EOL); // Cooler Seperator mit Umbruch
   ?>

   Output:
   <a href="/products">Produkte</a> ▶
   <a href="/products/server">Foo Server</a>

   /////////////////////////////////////////////////////

   Minimale notwendige Tiefe für die Darstellung von Breadcrumbs setzen:

   <?php
   $this->navigation()->breadcrumbs()->setMinDepth(10);
   echo $this->navigation()->breadcrumbs();
   ?>

   Ausgabe:
   Nichts, weil die tiefste aktive Seite nicht auf Level 10 oder tiefer ist.

.. _zend.view.helpers.initial.navigation.breadcrumbs.example4:

.. rubric:: Darstellung von Breadcrumbs mit Verwendung eines partiellen View Skripts

Dieses Beispiel zeigt wir eigene Breakcrumbs durch Verwendung eines partiellen View Skripts dargestellt werden
können. Durch den Aufruf von ``setPartial()`` kann man ein partielles View Skript spezifizieren das verwendet wird
wenn die ``render()`` Methode aufgerufen wird. Wenn ein partielles spezifiziert ist wird die Methode
``renderPartial()`` aufgerufen. Diese Methode findest die tiefste aktive Seite und übergibt ein Array von Seiten
die zur aktiven Seite des partiellen View Skripts weiterleitet.

Im Layout:

.. code-block:: php
   :linenos:

   $partial = ;
   echo $this->navigation()->breadcrumbs()
                           ->setPartial(array('breadcrumbs.phtml', 'default'));

Inhalt von *application/modules/default/views/breadcrumbs.phtml*:

.. code-block:: php
   :linenos:

   echo implode(', ', array_map(
           create_function('$a', 'return $a->getLabel();'),
           $this->pages));

Ausgabe:

.. code-block:: php
   :linenos:

   Produkte, Foo Server, FAQ

.. _zend.view.helpers.initial.navigation.links:

Link Helfer
-----------

Der Link Helfer wird für die Darstellung von *HTML* ``LINK`` Elementen verwendet. Links werden für die
Beschreibung von Dokument-Beziehungen der aktuell aktiven Seite verwendet. Mehr über Links und Linktypen kann
unter `Dokument-Beziehung: Das LINK Element (HTML4 W3C Rec.)`_ und `Link Typen (HTML4 W3C Rec.)`_ in der *HTML*\ 4
W3C Empfehlung nachgelesen werden.

Es gibt zwei Typen von Beziehungen; vorwärts und rückwärts, angezeigt durch die Schlüsselwörter *'rel'* und
*'rev'*. Die meisten Methoden im Helfer nehmen einen ``$rel`` Parameter entgegen, welcher entweder *'rel'* oder
*'rev'* sein muß. Die meisten Methoden nehmen auch einen ``$type`` Parameter entgegen welcher für die
Spezifikation des Linktyps (z.B. alternate, start, next, prev, chapter, usw.) verwendet wird.

Beziehungen können dem Seitenobjekt manuell hinzugefügt werden, oder werden durch das Durchlaufen des Containers,
der im Helfer registriert ist, gefunden. Die Methode ``findRelation($page, $rel, $type)`` versucht zuerst den
gegebenen ``$rel`` von ``$type`` von der ``$page`` durch den Aufruf von *$page->findRel($type)* oder
*$page->findRel($type)* zu finden. Wenn ``$page`` eine Beziehung hat die zu der Instanz einer Seite konvertiert
werden kann, wird diese Beziehung verwendet. Wenn die Instanz von ``$page`` keinen ``$type`` spezifiziert hat,
schaut der Helfer nach einer Methode im Helfer die *search$rel$type* heißt (z.B. ``searchRelNext()`` oder
``searchRevAlternate()``). Wenn so eine Methode existiert, wird Sie für die Erkennung der Beziehung der ``$page``
verwendet indem der Container durchlaufen wird.

Nicht alle Beziehungen können durch das Durchlaufen des Containers erkannt werden. Das sind die Beziehungen die
durch eine Suche gefunden werden können:

- ``searchRelStart()``, Vorwärts Beziehung 'start': Die erste Seite im Container.

- ``searchRelNext()``, Vorwärts Beziehung 'next'; findet die nächste Seite im Container, z.B. die Seite nach der
  aktiven Seite.

- ``searchRelPrev()``, Vorwärts Beziehung 'prev'; findet die vorhergehende Seite, z.B. die Seite vor der aktiven
  Seite.

- ``searchRelChapter()``, Vorwärts Beziehung 'chapter'; findet alle Seiten auf Level 0 ausser der 'start'
  Beziehung oder der aktiven Seite wenn diese auf Level 0 ist.

- ``searchRelSection()``, Vorwärts Beziehung 'section'; findet alle Kind-Seiten der aktiven Seite wenn die aktive
  Seite auf Level 0 ist (ein 'chapter').

- ``searchRelSubsection()``, Vorwärts Beziehung 'subsection'; findet alle Kind-Seiten der aktiven Seite wenn die
  aktive Seite auf Level 1 sind (ein 'section').

- ``searchRevSection()``, Rückwärts Beziehung 'section'; findet den Elternteil der aktiven Seite wenn die aktive
  Seite auf Level 1 ist (ein 'section').

- ``searchRevSubsection()``, Rückwärts Beziehung 'subsection'; findet den Elternteil der aktiven Seite wenn die
  aktive Seite auf Level 2 ist (ein 'subsection').

.. note::

   Wenn in der Instanz der Seite nach Beziehungen gesehen wird ( (*$page->getRel($type)* oder
   *$page->getRev($type)*), akzeptiert der Helfer Wert vom Typ ``String``, ``Array``, ``Zend\Config``, oder
   ``Zend\Navigation\Page``. Wenn ein String gefunden wird, wird dieser zu einer ``Zend\Navigation\Page\Uri``
   konvertiert. Wenn ein Array oder eine Config gefunden wird, wird diese in ein oder mehrere Seiteninstanzen
   konvertiert, und jedes Element wird an die :ref:`Seiten Factory <zend.navigation.pages.factory>` übergeben.
   Wenn der erste Schlüssel nicht nummerische ist, wird das Array/Config direkt an die Seiten Factory übergeben,
   und eine einzelne Seite wird retourniert.

Der Helfer unterstützt auch magische Methoden für das Finden von Beziehungen. Um z.B. alternative vorwärts
Beziehungen zu finden muß *$helper->findRelAlternate($page)* aufgerufen werden, und um rückwärts gerichtete
Kapitel Beziehungen zu finden *$helper->findRevSection($page)*. Diese Aufrufe korrespondieren mit
*$helper->findRelation($page, 'rel', 'alternate');* und *$helper->findRelation($page, 'rev', 'section');*.

Um zu Steuern welche Beziehung dargestellt werden soll, verwendet der Helfer ein render Flag. Das render Flag ist
ein Integer Wert, und kann in `binären und (&) Operationen`_ mit den render Konstanten des Helfers verwendet
werden um festzustellen ob die Beziehung zu der die render Konstante gehört, dargestellt werden soll.

Siehe das :ref:`folgende Beispiel <zend.view.helpers.initial.navigation.links.example3>` für weitere
Informationen.

- ``Zend\View\Helper\Navigation\Links::RENDER_ALTERNATE``

- ``Zend\View\Helper\Navigation\Links::RENDER_STYLESHEET``

- ``Zend\View\Helper\Navigation\Links::RENDER_START``

- ``Zend\View\Helper\Navigation\Links::RENDER_NEXT``

- ``Zend\View\Helper\Navigation\Links::RENDER_PREV``

- ``Zend\View\Helper\Navigation\Links::RENDER_CONTENTS``

- ``Zend\View\Helper\Navigation\Links::RENDER_INDEX``

- ``Zend\View\Helper\Navigation\Links::RENDER_GLOSSARY``

- ``Zend\View\Helper\Navigation\Links::RENDER_COPYRIGHT``

- ``Zend\View\Helper\Navigation\Links::RENDER_CHAPTER``

- ``Zend\View\Helper\Navigation\Links::RENDER_SECTION``

- ``Zend\View\Helper\Navigation\Links::RENDER_SUBSECTION``

- ``Zend\View\Helper\Navigation\Links::RENDER_APPENDIX``

- ``Zend\View\Helper\Navigation\Links::RENDER_HELP``

- ``Zend\View\Helper\Navigation\Links::RENDER_BOOKMARK``

- ``Zend\View\Helper\Navigation\Links::RENDER_CUSTOM``

- ``Zend\View\Helper\Navigation\Links::RENDER_ALL``

Die Konstanten von ``RENDER_ALTERNATE`` bis ``RENDER_BOOKMARK`` stellen standardmäßige *HTML* Linktypen dar.
``RENDER_CUSTOM`` stellt eine nicht-standardmäßige Beziehung dar die in der Seite spezifiziert ist.
``RENDER_ALL`` stellt standardmäßige und nicht-standardmäßige Beziehungen dar.

Methoden im Link Helfer:

- *{get|set}RenderFlag()* empfängt/setzt das render Flag. Standardwert ist ``RENDER_ALL``. Siehe das folgende
  Beispiel dafür wie das render Flag zu setzen ist.

- ``findAllRelations()`` findet alle Beziehungen von allen Typen einer angegebenen Seite.

- ``findRelation()`` findet alle Beziehungen eines angegebenen Typs einer angegebenen Seite.

- *searchRel{Start|Next|Prev|Chapter|Section|Subsection}()* durchsucht einen Container um vorwärtsgerichtete
  Beziehungen zu Startseite, nächster Seite, voriger Seite, Kapitel, Sektion und Untersektion zu finden.

- *searchRev{Section|Subsection}()* durchsucht einen Container um rückwärtsgerichtete Beziehungen zu Sektionen
  oder Untersektionen zu finden.

- ``renderLink()`` stellt ein einzelnes *link* Element dar.

.. _zend.view.helpers.initial.navigation.links.example1:

.. rubric:: Beziehungen in Seiten spezifizieren

Dieses Beispiel zeigt wir Beziehungen in Seiten spezifiziert werden können.

.. code-block:: php
   :linenos:

   $container = new Zend\Navigation(array(
       array(
           'label' => 'Strings für Beziehungen verwenden',
           'rel'   => array(
               'alternate' => 'http://www.example.org/'
           ),
           'rev'   => array(
               'alternate' => 'http://www.example.net/'
           )
       ),
       array(
           'label' => 'Arrays für Beziehungen verwenden',
           'rel'   => array(
               'alternate' => array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               )
           )
       ),
       array(
           'label' => 'Konfigurationen für Beziehungen verwenden',
           'rel'   => array(
               'alternate' => new Zend\Config(array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               ))
           )
       ),
       array(
           'label' => 'Instanzen von Seiten für Beziehungen verwenden',
           'rel'   => array(
               'alternate' => Zend\Navigation\Page::factory(array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               ))
           )
       )
   ));

.. _zend.view.helpers.initial.navigation.links.example2:

.. rubric:: Standardmäßige Darstellung von Links

Dieses Beispiel zeigt wie ein Menü von einem Container dargestellt wird, der im View Helfer registriert/gefunden
wurde.

.. code-block:: php
   :linenos:

   Im View Skript oder Layout:
   <?php echo $this->view->navigation()->links(); ?>

   Ausgabe:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editionen">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="chapter" href="/products" title="Produkte">
   <link rel="chapter" href="/company/about" title="Firma">
   <link rel="chapter" href="/community" title="Community">
   <link rel="canonical" href="http://www.example.com/?page=server-faq">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. _zend.view.helpers.initial.navigation.links.example3:

.. rubric:: Spezifizieren welche Beziehungen dargestellt werden sollen

Dieses Beispiel zeigt wie spezifiziert werden kann, welche Beziehungen zu finden und darzustellen sind.

.. code-block:: php
   :linenos:

   Nur start, next und prev darstellen:
   $helper->setRenderFlag(Zend\View\Helper\Navigation\Links::RENDER_START |
                          Zend\View\Helper\Navigation\Links::RENDER_NEXT |
                          Zend\View\Helper\Navigation\Links::RENDER_PREV);

   Ausgabe:
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editionen">
   <link rel="prev" href="/products/server" title="Foo Server">

.. code-block:: php
   :linenos:

   Nur native Linktypen darstellen:
   $helper->setRenderFlag(Zend\View\Helper\Navigation\Links::RENDER_ALL ^
                          Zend\View\Helper\Navigation\Links::RENDER_CUSTOM);

   Ausgabe:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editionen">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="chapter" href="/products" title="Produkte">
   <link rel="chapter" href="/company/about" title="Firma">
   <link rel="chapter" href="/community" title="Community">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. code-block:: php
   :linenos:

   Alles ausser Kapitel darstellen:
   $helper->setRenderFlag(Zend\View\Helper\Navigation\Links::RENDER_ALL ^
                          Zend\View\Helper\Navigation\Links::RENDER_CHAPTER);

   Ausgabe:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editionen">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="canonical" href="http://www.example.com/?page=server-faq">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. _zend.view.helpers.initial.navigation.menu:

Menu Helfer
-----------

Der Menu Helfer wird für die Darstellung von Menüs aus Navigations Containern verwendet. Standardmäßig wird das
Menü durch Verwendung der *HTML* Tags *UL* und *LI* dargestellt. Der Helfer erlaubt aber auch die Verwendung eines
partiellen View Skripts.

Methoden im Menu Helfer:

- *{get|set}UlClass()* empfängt/setzt die *CSS* Klasse zur Verwendung in ``renderMenu()``.

- *{get|set}OnlyActiveBranch()* empfängt/setzt ein Flag das spezifiziert ob der aktive Zweig eines Containers
  dargestellt werden soll.

- *{get|set}RenderParents()* empfängt/setzt ein Flag das spezifiziert ob Eltern nur dargestellt werden sollen wenn
  nur der aktive Zweig eines Containers dargestellt wird. Wenn es auf ``FALSE`` gesetzt wird, wird nur das tiefste
  aktive Menü dargestellt.

- *{get|set}Partial()* empfängt/setzt ein partielles View Skript das für die Darstellung des Menüs verwendet
  werden soll. Wenn ein partielles Skript gesetzt ist, verwendet die ``render()`` Methode des Helfers die
  ``renderPartial()`` Methode. Wenn kein Partieller gesetzt ist, wird die ``renderMenu()`` Methode verwendet. Der
  Helfer erwartet das der Partielle ein ``String``, oder ein ``Array`` mit zwei Elementen, ist. Wenn der Partielle
  ein ``String`` ist bezeichnet er den Namen des partiellen Skripts das zu verwenden ist. Wenn er ein ``Array`` ist
  wird das erste Element als Name des partiellen View Skripts verwendet, und das zweite Element ist das Modul indem
  das Skript gefunden wird.

- ``htmlify()`` überschreibt die Methode der abstrakten Klasse damit *span* Elemente zurückgegeben werden wenn
  die Seite kein *href* hat.

- ``renderMenu($container = null, $options = array())`` ist eine standardmäßige render Methode, und stellt einen
  Container als *HTML* *UL* Liste dar.

  Wenn ``$container`` nicht angegeben wird, wird der Container der im Helfer registriert ist dargestellt.

  ``$options`` wird verwendet um temporär spezifizierte Optionen zu überschreiben ohne das die Werte in der
  Helferinstanz zurückgesetzt werden. Es ist ein assoziatives Array wobei jeder Schlüssel mit einer Option im
  Helfer korrespondiert.

  Erkannte Optionen:

  - *indent*; Einrückung. Erwartet einen ``String`` oder einen *int* Wert.

  - *minDepth*; Minimale Tiefe. Erwartet ein *int* oder ``NULL`` (keine minimale Tiefe).

  - *maxDepth*; Maximale Tiefe. Erwartet ein *int* oder ``NULL`` (keine maximale Tiefe).

  - *ulClass*; *CSS* Klasse für das *ul* Element. Erwartet einen ``String``.

  - *onlyActiveBranch*; Ob nur der aktive Branch dargestellt werden soll. Erwartet einen ``Boolean`` Wert.

  - *renderParents*; Ob eltern dargestellt werden sollen wenn nur der aktive Branch dargestellt wird. Erwartet
    einen ``Boolean`` Wert.

  Wenn keine Option angegeben wird, werden die Werte die im Helfer gesetzt sind verwendet.

- ``renderPartial()`` wird für die Darstellung des Menüs in einem partiellen View Skript verwendet.

- ``renderSubMenu()`` stellt das tiefste Menü Level des aktiven Branches eines Containers dar.

.. _zend.view.helpers.initial.navigation.menu.example1:

.. rubric:: Darstellung eines Menüs

Dieses Beispiel zeigt wie ein Menü von einem registrierten/im View Helfer gefundenen Container, dargestellt wird.
Es ist zu beachten das Seiten basierend auf Ihrer Sichtbarkeit und *ACL* ausgefiltert werden.

.. code-block:: php
   :linenos:

   In einem View Skript oder Layout:
   <?php echo $this->navigation()->menu()->render() ?>

   Oder einfach:
   <?php echo $this->navigation()->menu() ?>

   Ausgabe:
   <ul class="navigation">
       <li>
           <a title="Geh zu Home" href="/">Home</a>
       </li>
       <li class="active">
           <a href="/products">Produkte</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
                   <ul>
                       <li class="active">
                           <a href="/products/server/faq">FAQ</a>
                       </li>
                       <li>
                           <a href="/products/server/editions">Editionen</a>
                       </li>
                       <li>
                           <a href="/products/server/requirements">System Anforderungen</a>
                       </li>
                   </ul>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
                   <ul>
                       <li>
                           <a href="/products/studio/customers">Kunden Stories</a>
                       </li>
                       <li>
                           <a href="/prodcts/studio/support">Support</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
       <li>
           <a title="About us" href="/company/about">Firma</a>
           <ul>
               <li>
                   <a href="/company/about/investors">Investor Relations</a>
               </li>
               <li>
                   <a class="rss" href="/company/news">News</a>
                   <ul>
                       <li>
                           <a href="/company/news/press">Für die Presse</a>
                       </li>
                       <li>
                           <a href="/archive">Archiv</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community">Community</a>
           <ul>
               <li>
                   <a href="/community/account">Mein Account</a>
               </li>
               <li>
                   <a class="external" href="http://forums.example.com/">Forums</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example2:

.. rubric:: renderMenu() direkt aufrufen

Dieses Beispiel zeigt wie ein Menü dargestellt werden kann das nicht im View Helfer registriert ist, indem
``renderMenu()`` direkt aufgerufen wird und ein paar wenige Optionen spezifiziert werden.

.. code-block:: php
   :linenos:

   <?php
   // Nur das 'Community' Menü darstellen
   $community = $this->navigation()->findOneByLabel('Community');
   $options = array(
       'indent'  => 16,
       'ulClass' => 'community'
   );
   echo $this->navigation()
             ->menu()
             ->renderMenu($community, $options);
   ?>
   Output:
                   <ul class="community">
                       <li>
                           <a href="/community/account">Mein Account</a>
                       </li>
                       <li>
                           <a class="external" href="http://forums.example.com/">Forums</a>
                       </li>
                   </ul>

.. _zend.view.helpers.initial.navigation.menu.example3:

.. rubric:: Das tiefste aktive Menü darstellen

Dieses Beispiel zeigt wie ``renderSubMenu()`` das tiefste Untermenü des aktiven Branches dargestellt wird.

Der Aufruf von ``renderSubMenu($container, $ulClass, $indent)`` ist identisch mit dem Aufruf von
``renderMenu($container, $options)`` mit den folgenden Optionen:

.. code-block:: php
   :linenos:

   array(
       'ulClass'          => $ulClass,
       'indent'           => $indent,
       'minDepth'         => null,
       'maxDepth'         => null,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   );

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->renderSubMenu(null, 'sidebar', 4);
   ?>

   Die Ausgabe ist die gleiche wenn 'FAQ' oder 'Foo Server' aktiv sind:
       <ul class="sidebar">
           <li class="active">
               <a href="/products/server/faq">FAQ</a>
           </li>
           <li>
               <a href="/products/server/editions">Editionen</a>
           </li>
           <li>
               <a href="/products/server/requirements">System Anforderungen</a>
           </li>
       </ul>

.. _zend.view.helpers.initial.navigation.menu.example4:

.. rubric:: Darstellung eines Menüs mit maximaler Tiefe

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setMaxDepth(1);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li>
           <a title="Geh zu Home" href="/">Home</a>
       </li>
       <li class="active">
           <a href="/products">Produkte</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
               </li>
           </ul>
       </li>
       <li>
           <a title="About us" href="/company/about">Firma</a>
           <ul>
               <li>
                   <a href="/company/about/investors">Investor Relations</a>
               </li>
               <li>
                   <a class="rss" href="/company/news">News</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community">Community</a>
           <ul>
               <li>
                   <a href="/community/account">Mein Account</a>
               </li>
               <li>
                   <a class="external" href="http://forums.example.com/">Forums</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example5:

.. rubric:: Darstellung eines Menüs mit minimaler Tiefe

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setMinDepth(1);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
           <ul>
               <li class="active">
                   <a href="/products/server/faq">FAQ</a>
               </li>
               <li>
                   <a href="/products/server/editions">Editionen</a>
               </li>
               <li>
                   <a href="/products/server/requirements">System Anforderungen</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/products/studio">Foo Studio</a>
           <ul>
               <li>
                   <a href="/products/studio/customers">Kunden Stories</a>
               </li>
               <li>
                   <a href="/prodcts/studio/support">Support</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/company/about/investors">Investor Relations</a>
       </li>
       <li>
           <a class="rss" href="/company/news">News</a>
           <ul>
               <li>
                   <a href="/company/news/press">Für die Presse</a>
               </li>
               <li>
                   <a href="/archive">Archiv</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community/account">Mein Account</a>
       </li>
       <li>
           <a class="external" href="http://forums.example.com/">Forums</a>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example6:

.. rubric:: Nur den aktiven Branch eines Menüs darstellen

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li class="active">
           <a href="/products">Produkte</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
                   <ul>
                       <li class="active">
                           <a href="/products/server/faq">FAQ</a>
                       </li>
                       <li>
                           <a href="/products/server/editions">Editionen</a>
                       </li>
                       <li>
                           <a href="/products/server/requirements">System Anforderungen</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example7:

.. rubric:: Nur den aktiven Branch eines Menüs mit minimaler Tiefe darstellen

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setMinDepth(1);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
           <ul>
               <li class="active">
                   <a href="/products/server/faq">FAQ</a>
               </li>
               <li>
                   <a href="/products/server/editions">Editionen</a>
               </li>
               <li>
                   <a href="/products/server/requirements">System Anforderungen</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example8:

.. rubric:: Nur den aktiven Branch eines Menüs mit maximaler Tiefe darstellen

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setMaxDepth(1);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li class="active">
           <a href="/products">Produkte</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example9:

.. rubric:: Nur den aktiven Branch eines Menüs mit maximaler Tiefe aber ohne Eltern darstellen



.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setRenderParents(false)
             ->setMaxDepth(1);
   ?>

   Ausgabe:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
       </li>
       <li>
           <a href="/products/studio">Foo Studio</a>
       </li>
   </ul>

.. _zend.view.helpers.initial.navigation.menu.example10:

.. rubric:: Darstellen eines eigenen Menüs durch Verwendung eines partiellen View Skripts

Dieses Beispiel zeigt wie ein eigenes Menü, durch Verwendung eines partiellen View Skripts, dargestellt werden
kann. Durch Aufruf von ``setPartial()`` kann ein partielles View Skript spezifiziert werden das verwendet wird wenn
man ``render()`` aufruft. Wenn ein Partielles spezifiziert ist, wird die ``renderPartial()`` Methode aufgerufen.
Diese Methode fügt den Container in die View ein, und verwendet hierbei den Schlüssel *container*.

In a layout:

.. code-block:: php
   :linenos:

   $partial = array('menu.phtml', 'default');
   $this->navigation()->menu()->setPartial($partial);
   echo $this->navigation()->menu()->render();

In application/modules/default/views/menu.phtml:

.. code-block:: php
   :linenos:

   foreach ($this->container as $page) {
       echo $this->navigation()->menu()->htmlify($page), PHP_EOL;
   }

Ausgabe:

.. code-block:: php
   :linenos:

   <a title="Geh zu Home" href="/">Home</a>
   <a href="/products">Produkte</a>
   <a title="About us" href="/company/about">Firma</a>
   <a href="/community">Community</a>

.. _zend.view.helpers.initial.navigation.sitemap:

Sitemap Helfer
--------------

Der Sitemap Helfer wird für die Erzeugung von *XML* Sitemaps verwendet wie im `Sitemaps XML Format`_ definiert.
Mehr darüber kann unter `Sitemaps in Wikipedia`_ nachgelesen werden.

Standardmäßig verwendet der Sitemap Helfer :ref:`Sitemap Prüfungen <zend.validate.sitemap>` um jedes Element zu
prüfen das dargestellt werden soll. Das kann deaktiviert werden indem man
*$helper->setUseSitemapValidators(false)* aufruft.

.. note::

   Wenn man die Sitemap Prüfungen deaktiviert, werden die eigenen Eigenschaften (siehe Tabelle) nicht geprüft.

Der Sitemap Helfer unterstützt auch die Pürfung von `Sitemap XSD Schemas`_ der erzeugten Sitemap. Das ist
standardmäßig deaktiviert, da es eine Anfrage auf die Schema Datei benötigt. Es kann mit
*$helper->setUseSchemaValidation(true)* aktiviert werden.

.. _zend.view.helpers.initial.navigation.sitemap.elements:

.. table:: Sitemap XML Elemente

   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Element   |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                  |
   +==========+==============================================================================================================================================================================================================================================================================================================================================================================================================================+
   |loc       |Absolute URL zur Seite. Eine absolute URL wird vom Helfer erzeugt.                                                                                                                                                                                                                                                                                                                                                            |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lastmod   |Das Datum der letzten Änderung der Datei, im W3C Datetime Format. Dieser Zeitabschnitt kann bei Bedarf unterdrückt, und nur YYYY-MM-DD verwendet werden. Der Helfer versucht den lastmod Wert von der Seiteneigenschaft lastmod zu erhalten wenn diese auf der Seite gesetzt ist. Wenn der Wert kein gültiges Datum ist, wird er ignoriert.                                                                                   |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |changefreq|Wie oft eine Seite geändert wird. Dieser Wert bietet eine generelle Information für Suchmaschinen und muß nicht exakt mit der Anzahl der Suchen auf der Seite übereinstimmen. Gültige Werte sind: alwayshourlydailyweeklymonthlyyearlynever Der Helfer versucht den changefreq Wert von der Seiteneigenschaft changefreq zu erhalten, wenn diese auf der Seite gesetzt ist. Wenn der Wert nicht gültig ist, wird er ignoriert.|
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |priority  |Die Priorität dieser URL relativ zu anderen URLs auf der eigenen Site. Der gültige Bereich für diesen Wert ist von 0.0 bis 1.0. Der Helfer versucht den priority Wert von der Seiteneigenschaft priority zu erhalten wenn dieser auf der Seite gesetzt ist. Wenn der Wert nicht gültig ist, wird er ignoriert.                                                                                                                |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Methoden im Sitemap Helfer:

- *{get|set}FormatOutput()* empfängt/setzt ein Flag das anzeigt ob *XML* Ausgaben formatiert werden sollen. Das
  entspricht der Eigenschaft *formatOutput* der nativen ``DOMDocument`` Klasse. Mehr kann man unter `PHP:
  DOMDocument - Handbuch`_ nachlesen. Der Standardwert ist ``FALSE``.

- *{get|set}UseXmlDeclaration()* empfängt/setzt ein Flag das anzeigt ob die *XML* Deklaration bei der Darstellung
  enthalten sein soll. Der Standardwert ist ``TRUE``.

- *{get|set}UseSitemapValidators()* empfängt/setzt ein Flag das anzeigt ob Sitemap Prüfungen verwendet werden
  sollen wenn die DOM Sitemap dargestellt werden soll. Der Standardwert ist ``TRUE``.

- *{get|set}UseSchemaValidation()* empfängt/setzt ein Flag das anzeigt ob der Helfer eine *XML* Schema Prüfung
  verwenden soll wenn die DOM Sitemap erzeugt wird. Der Standardwert ist ``FALSE``. Wenn ``TRUE``.

- *{get|set}ServerUrl()* empfängt/setzt die Server *URL* die nicht-absoluten *URL*\ s in der ``url()`` Methode
  vorangestellt werden. Wenn keine Server *URL* spezifiziert ist, wird diese vom Helfer festgestellt.

- ``url()`` wird verwendet um absolute *URL*\ s zu Seiten zu erstellen.

- ``getDomSitemap()`` erzeugt ein DOMDocument von einem angegebenen Container.

.. _zend.view.helpers.initial.navigation.sitemap.example:

.. rubric:: Eine XML Sitemap darstellen

Dieses Beispiel zeigt wie eine *XML* Sitemap, basierend auf dem Setup das wir vorher angegeben haben, dargestellt
wird.

.. code-block:: php
   :linenos:

   // In einem View Skript oder Layout:

   // Ausgabeformat
   $this->navigation()
         ->sitemap()
         ->setFormatOutput(true); // Standardwert ist false

   // Andere mögliche Methoden:
   // ->setUseXmlDeclaration(false); // Standardwert ist true
   // ->setServerUrl('http://my.otherhost.com');
   // Standard ist die automatische Erkennung

   // Sitemap ausdrucken
   echo $this->navigation()->sitemap();

Es ist zu beachten wie Seiten die unsichtbar oder Seiten mit *ACL* Rollen die mit dem View Helfer inkompatibel sin,
ausgefiltert werden:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/faq</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/editions</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/requirements</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio/customers</loc>
     </url>
     <url>
       <loc>http://www.example.com/prodcts/studio/support</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news/press</loc>
     </url>
     <url>
       <loc>http://www.example.com/archive</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://www.example.com/community/account</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

Die Sitemap ohne Verwendung einer *ACL* Rolle darstellen (sollte /community/account ausfiltern):

.. code-block:: php
   :linenos:

   echo $this->navigation()
             ->sitemap()
             ->setFormatOutput(true)
             ->setRole();

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/faq</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/editions</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/requirements</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio/customers</loc>
     </url>
     <url>
       <loc>http://www.example.com/prodcts/studio/support</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news/press</loc>
     </url>
     <url>
       <loc>http://www.example.com/archive</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

Darstellen der Sitemap mit Verwendung einer maximalen Tiefe von 1.

.. code-block:: php
   :linenos:

   echo $this->navigation()
             ->sitemap()
             ->setFormatOutput(true)
             ->setMaxDepth(1);

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://www.example.com/community/account</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

.. note::

   **Standardmäßig wird die UTF-8 Kodierung verwendet**

   Standardmäßig verwendet Zend Framework *UTF-8* als seine Standardkodierung, und speziell in diesem Fall, macht
   das ``Zend\View`` genauso. Die Zeichenkodierung kann im View Objekt selbst auf etwas anderes gesetzt werden
   indem die Methode ``setEncoding()`` verwendet wird (oder der Parameter ``encoding`` bei der Instanzierung
   angegeben wird). Trotzdem, da ``Zend\View\Interface`` keine Zugriffsmethoden für die Kodierung anbietet ist es
   möglich dass, wenn man eine eigene View Implementation verwendet, man keine ``getEncoding()`` Methode hat,
   welche der View Helfer intern für die Erkennung des Zeichensets verwendet in das kodiert werden soll.

   Wenn man *UTF-8* in solch einer Situation nicht verwenden will, muss man in der eigenen View Implementation eine
   ``getEncoding()`` Methode implementieren.

.. _zend.view.helpers.initial.navigation.navigation:

Navigation Helfer
-----------------

Der Navigation Helfer ist ein Proxy Helfer der Aufrufe zu anderen Navigations Helfern durchführt. Er kann als
Einstiegspunkt für alle navigations-basierenden View Tasks verwendet werden. Die vorher erwähnten Navigations
Helfer sind im Namespace ``Zend\View\Helper\Navigation`` und würden es deshalb benötigen, den Pfad
*Zend/View/Helper/Navigation* als Helfer Pfad der View hinzuzufügen. Mit dem Proxy Helfer der im
``Zend\View\Helper`` Namespace sitzt, ist er immer vorhanden, ohne das irgendein Helfer Pfad an der View
hinzugefügt werden muß.

Der Navigations Helfer findet andere Helfer die das ``Zend\View\Helper\Navigation\Helper`` Interface
implementieren, was bedeuet das auch auf eigene View Helfer weitergeleitet wird. Das würde trotzdem das
Hinzufügen des eigenen Helfer Pfades zur View benötigen.

Wenn auf andere Helfer weitergeleitet wird, kann der Navigations Helfer seinen Container, *ACL*/Rolle und
Übersetzer injizieren. Das bedeutet weder das man diese drei nicht explizit in allen navigatorischen Helfern
setzen muß, noch das diese in ``Zend_Registry`` oder in statische Methoden injiziert werden muß.

- ``findHelper()`` findet alle angegebenen Helfer, prüft das dieser ein navigatorischer Helfer ist, und injiziiert
  Container, *ACL*/Rolle und Übersetzer.

- *{get|set}InjectContainer()* empfängt/setzt ein Flag das anzeigt ob der Container an weitergeleitete Helfer
  injiziiert werden soll. Der Standardwert ist ``TRUE``.

- *{get|set}InjectAcl()* empfängt/setzt ein Flag das anzeigt ob die *ACL*/Rolle an weitergeleitete Helfer
  injiziiert werden soll. Der Standardwert ist ``TRUE``.

- *{get|set}InjectTranslator()* empfängt/setzt ein Flag das anzeigt ob der Übersetzer an weitergeleitete Helfer
  injiziiert werden soll. Der Standardwert ist ``TRUE``.

- *{get|set}DefaultProxy()* empfängt/setzt den Standard Proxy. Der Standardwert ist *'menu'*.

- ``render()`` leitet auf die render Methode des Standardproxies weiter.



.. _`Sitemaps XML Format`: http://www.sitemaps.org/protocol.php
.. _`Breadcrumbs Pattern - Yahoo! Design Pattern Library`: http://developer.yahoo.com/ypatterns/pattern.php?pattern=breadcrumbs
.. _`Dokument-Beziehung: Das LINK Element (HTML4 W3C Rec.)`: http://www.w3.org/TR/html4/struct/links.html#h-12.3
.. _`Link Typen (HTML4 W3C Rec.)`: http://www.w3.org/TR/html4/types.html#h-6.12
.. _`binären und (&) Operationen`: http://php.net/manual/en/language.operators.bitwise.php
.. _`Sitemaps in Wikipedia`: http://en.wikipedia.org/wiki/Sitemaps
.. _`Sitemap XSD Schemas`: http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd
.. _`PHP: DOMDocument - Handbuch`: http://php.net/domdocument
