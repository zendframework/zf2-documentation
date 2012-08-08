.. EN-Revision: none
.. _performance.view:

Darstellen der View
===================

Wenn man den *MVC* Layer vom Zend Framework verwendet, sind die Chancen das man ``Zend_View`` verwendet recht hoch.
``Zend_View`` ist performant verglichen mit anderen View oder Templating Engines; da View Skripte in *PHP*
geschrieben sind muß man weder den Overhead eines Kompilierungssystems zu *PHP* auf sich nehmen, noch muß man
darauf achten dass das kompilierte *PHP* nicht optimiert ist. Trotzdem zeigt ``Zend_View`` seine eigenen Probleme:
Erweiterungen werden durch überladen (View Helfer) durchgeführt, und eine Anzahl von View Helfern, die dadurch
Schlüsselfunktionalitäten bieten machen das auch, mit einem Verlust von Geschwindigkeit.

.. _performance.view.pluginloader:

Wie kann ich die Auflösung von View Helfern schneller machen?
-------------------------------------------------------------

Die meisten ``Zend_View``"Methoden" werden in Wirklichkeit durch Überladen des Helfersystems angeboten. Das bietet
``Zend_View`` wichtige Flexibilität; statt der Notwendigkeit ``Zend_View`` zu erweitern und alle Helfermethoden
anzubieten die man in der eigenen Anwendung verwenden will, kann man eigene Helfermethoden in separaten Klassen
definieren und Sie bei Bedarf konsumieren wie wenn es direkte Methoden von ``Zend_View`` wären. Das hält das View
Objekt selbst relativ dünn, und stellt sicher das Objekte nur erstellt werden wenn Sie auch benötigt werden.

Intern verwendet ``Zend_View`` den :ref:`PluginLoader <zend.loader.pluginloader>` um nach Helferklassen zu sehen.
Das bedeutet das für jeden Helfer den man aufruft, ``Zend_View`` den Helfernamen zum PluginLoader übergeben muß,
welcher dann den Klassennamen erkennen muß damit er instanziiert werden kann. Nachfolgende Aufrufe des Helfers
sind viel schneller, da ``Zend_View`` eine interne Registry von geladenen Helfern behält, aber wenn man viele
Helfer verwendet, werden die Aufrufe hinzuaddiert.

Die Frage ist also: Wie kann man die Auflösung der Helfer schneller machen?

.. _performance.view.pluginloader.cache:

Verwenden des PluginLoader Include-File Caches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die einfachste, billigste Lösung ist die gleiche für die :ref:`generelle PluginLoader Geschwindigkeit
<performance.classloading.pluginloader>`: :ref:`Verwenden des PluginLoader Include-File Caches
<zend.loader.pluginloader.performance.example>`. Einzelberichte und aussagen haben gezeigt das diese Technik eine
Geschwindigkeitssteigerung von 25-30% auf Systemen ohne Opcode Cache bringt, und eine 40-64% Steigerung auf
Systemen mit Opcode Cache.

.. _performance.view.pluginloader.extend:

Erweitern von Zend_View um oft verwendet Helfermethoden anzubieten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eine andere Lösung für jene welche die Geschwindigkeit sogar noch mehr steigern wollen ist es ``Zend_View`` zu
erweitern um manuell die Helfermethoden die man am meisten in seiner Anwendung verwendet hinzuzufügen. Solche
Helfermethoden können einfach manuell die betreffenden Helferklassen instanziiert und auf Sie verwesen wird, oder
indem die komplette Implementation des Helfers in die Methode eingefügt wird.

.. code-block:: php
   :linenos:

   class My_View extends Zend_View
   {
       /**
        * @var array Registry der verwendeten Helferklasse
        */
       protected $_localHelperObjects = array();

       /**
        * Proxy zum URL View Helfer
        *
        * @param  array $url  Options Optionen die an die Assemble Methode des
        *                     Route Objekts übergeben werden
        * @param  mixed $name Der Name der zu verwendenden Route. Wenn null wir
        *                     die aktuelle Route verwendet
        * @param  bool $reset Ob die Routenstandard mit den angegebenen
        *                     zurückgesetzt werden sollen oder nicht
        * @return string Url für das Link Href Attribut.
        */
       public function url(array $urlOptions = array(), $name = null,
           $reset = false, $encode = true
       ) {
           if (!array_key_exists('url', $this->_localHelperObjects)) {
               $this->_localHelperObjects['url'] = new Zend_View_Helper_Url();
               $this->_localHelperObjects['url']->setView($this);
           }
           $helper = $this->_localHelperObjects['url'];
           return $helper->url($urlOptions, $name, $reset, $encode);
       }

       /**
        * Eine Meldung ausgeben
        *
        * Direkte Implementierung.
        *
        * @param  string $string
        * @return string
        */
       public function message($string)
       {
           return "<h1>" . $this->escape($message) . "</h1>\n";
       }
   }

Wie auch immer, diese Techik reduziert den Overhead des Helfersystems substanziell indem es den Aufruf vom
PluginLoader komplett vermeidet, und entweder vom Autoloader profitiert, oder durch dessen Überbrückung.

.. _performance.view.partial:

Wie kann ich partielle View schneller machen?
---------------------------------------------

Jene die Partielle sehr oft verwenden und die Ihre Anwendungen profilieren werden oft sofort feststellen das der
``partial()`` View Helfer viel des Overheads verwendet, durch die Notwendigkeit das View Objekt zu klonen. Ist es
möglich das schneller zu machen?

.. _performance.view.partial.render:

Verwende partial() nur wenn es wirklich notwendig ist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der ``partial()`` View Helfer akzeptiert drei Argumente:

- ``$name``: Den Namen des View Skripts das dargestellt werden soll

- ``$module``: Der Name des Moduls in dem das View Skript sitzt; oder, wenn kein drittes Argument angegeben wurde
  und es ein Array oder Objekt ist, wird es als ``$model`` Argument verwendet.

- ``$model``: Ein Array oder Objekt das dem Partial übergeben wird, und die reinen Daten repräsentiert die der
  View übergeben werden.

Die Power der Verwendung von ``partial()`` kommen vom zweiten und dritten Argument. Das ``$module`` Argument
erlaubt es ``partial()`` temporär einen Skriptpfad für die angegebenen Module hinzuzufügen damit das partielle
Viewskript es zu diesem Modul auflöst; das ``$model`` Argument erlaubt es Variablen explizit für die Verwendung
in der partiellen View zu übergeben. Wenn man keines der Argumente übergibt, kann man **stattdessen render()
verwenden**!

Grundsätzlich, solange man nicht Variablen an das Partial übergibt und einen reinen Variablenraum benötigt, oder
ein Viewskript von einem anderen *MVC* Modul darstellt, gibt es keinen Grund den Overhead von ``partial()`` zu
verwenden; stattdessen sollte man ``Zend_View``'s eingebaute ``render()`` Methode verwendet um das Viewskript
darzustellen.

.. _performance.view.action:

Wie kann ich Aufrufe zu action() vom View Helfers schneller machen?
-------------------------------------------------------------------

Version 1.5.0 führte die ``action()`` des View Helfers ein, welche es erlaubt eine *MVC* Aktion abzuschicken und
deren dargestellten Inhalt aufzufangen. Das biete einen wichtigen Schritt in die Prinzipien von *DRY*, und erlaubt
die Wiederverwendung von Code. Trotzdem, wie jede die Ihre Anwendung profilieren schnell feststellen werden, ist es
auch eine sehr teure Operation. Intern muß der ``action()`` Viewhelfer neue Anfrage und Antwort Objekte klonen,
den Dispatcher aufrufen, den angefragten Controller und die Aktion aufrufen, usw.

Wie kann man das schneller machen?

.. _performance.view.action.actionstack:

Verwende den ActionStack wenn möglich
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zur selben Zeit die der ``action()`` View Helfer eingeführt, besteht der :ref:`ActionStack
<zend.controller.actionhelpers.actionstack>` auf einem Action Helfer und einem Front Controller Plugin. Zusammen
erlauben Sie es zusätzliche Aktionen einzufügen die wärend des Dispatch Zyklus auf den Stack aufgerufen werden.
Wenn man ``action()`` von eigenen Layout View Skripts aufruft, kann es sein das man stattdessen den ActionStack
verwenden will, und die Views zu diskreten Antwortsegmenten darstellen will. Als Beispiel könnte man ein
``dispatchLoopStartup()`` Plugin wie das folgende schreiben um eine Login Formularbox bei jeder Seite
hinzuzufügen:

.. code-block:: php
   :linenos:

   class LoginPlugin extends Zend_Controller_Plugin_Abstract
   {
       protected $_stack;

       public function dispatchLoopStartup(
           Zend_Controller_Request_Abstract $request
       ) {
           $stack = $this->getStack();
           $loginRequest = new Zend_Controller_Request_Simple();
           $loginRequest->setControllerName('user')
                        ->setActionName('index')
                        ->setParam('responseSegment', 'login');
           $stack->pushStack($loginRequest);
       }

       public function getStack()
       {
           if (null === $this->_stack) {
               $front = Zend_Controller_Front::getInstance();
               if (!$front->hasPlugin('Zend_Controller_Plugin_ActionStack')) {
                   $stack = new Zend_Controller_Plugin_ActionStack();
                   $front->registerPlugin($stack);
               } else {
                   $stack = $front->getPlugin('ActionStack')
               }
               $this->_stack = $stack;
           }
           return $this->_stack;
       }
   }

Die ``UserController::indexAction()`` Methode könnte dann den ``$responseSegment`` Parameter verwenden um
anzuzeigen welches Antwortsegment darzustellen ist. Im Layoutskript, würde man dann einfach das Antwortsegment
darstellen:

.. code-block:: php
   :linenos:

   <?php $this->layout()->login ?>

Wärend der ActionStack trotzdem noch einen Dispatch Zyklus benötigt, ist das trotzdem immer noch billiger als der
``action()`` View Helfer da er Objekte nicht klonen und den internen Status zurücksetzen muß. Zustzlich stellt es
sicher das alle Pre und Post Dispatch Plugins aufgerufen werden, was von spezieller Wichtigkeit ist wenn man
Frontcontroller Plugins für die Behandlung von *ACL*'s in speziellen Aktionen verwendet.

.. _performance.view.action.model:

Helfer bevorzugen die das Modell vor action() abfragen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In den meisten Fällen ist die Verwendung von ``action()`` einfach nur Overkill. Wenn man die meiste Businesslogik
in eigenen Modellen verschachtelt hat das Modell einfach abfragt und die Ergebnisse an das View Skript übergibt,
ist es typischerweise schneller und sauberer einfach einen View Helfer zu schreiben der das Modell holt, es abfragt
und mit der Information irgendwas macht.

Nehmen wir als Beispiel die folgende Controller Action und das View Skript an:

.. code-block:: php
   :linenos:

   class BugController extends Zend_Controller_Action
   {
       public function listAction()
       {
           $model = new Bug();
           $this->view->bugs = $model->fetchActive();
       }
   }

   // bug/list.phtml:
   echo "<ul>\n";
   foreach ($this->bugs as $bug) {
       printf("<li><b>%s</b>: %s</li>\n",
              $this->escape($bug->id),
              $this->escape($bug->summary));
   }
   echo "</ul>\n";

Mit Verwendung von ``action()``, würde man es einfach wie folgt einfügen:

.. code-block:: php
   :linenos:

   <?php $this->action('list', 'bug') ?>

Das könnte zu einem View helfer geändert werden die wie folgt aussieht:

.. code-block:: php
   :linenos:

   class My_View_Helper_BugList extends Zend_View_Helper_Abstract
   {
       public function bugList()
       {
           $model = new Bug();
           $html  = "<ul>\n";
           foreach ($model->fetchActive() as $bug) {
               $html .= sprintf("<li><b>%s</b>: %s</li>\n",
                   $this->view->escape($bug->id),
                   $this->view->escape($bug->summary)
               );
           }
           $html .= "</ul>\n";
           return $html;
       }
   }

Der Helfer würde dann wie folgt aufgerufen werden:

.. code-block:: php
   :linenos:

   <?php $this->bugList() ?>

Das hat zwei Vorteile: Es übernimmt nicht länger den Overhead vom ``action()`` View Helfer, und präsentiert eine
bessere und semantisch verständlichere *API*.


