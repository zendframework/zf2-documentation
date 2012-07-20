.. _zend.view.scripts:

View Scripte
============

Sobald dein Controller die Variablen übergeben und die ``render()`` Methode aufgerufen hat, inkludiert
``Zend_View`` das angeforderte View Skript und führt es "innerhalb" des Gültigkeitsbereichs der ``Zend_View``
Instanz aus. Deshalb weisen Referenzen auf $this in deinem View Skript auf die ``Zend_View`` Instanz selber.

Auf Variablen, die vom Controller an den View übergeben worden sind, kann als Eigenschaften der Instanz
zurückgegriffen werden. Wenn der Controller zum Beispiel eine Variable 'irgendwas' übergeben hat, würdest du in
deinem View Skript über $this->irgendwas darauf zugreifen können. (Dies erlaubt es dir, den Überblick darüber
zu behalten, welche Variablen an das Skript übergeben worden sind und welche Variablen intern zum Skript selber
gehören.)

Zur Erinnerung hier noch einmal das Beispiel View Skript aus der ``Zend_View`` Einführung.

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- Eine Tabelle mit einigen Büchern. -->
       <table>
           <tr>
               <th>Autor</th>
               <th>Titel</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Es gibt keine Bücher zum Anzeigen.</p>

   <?php endif; ?>

.. _zend.view.scripts.escaping:

Ausgaben maskieren
------------------

Eine der wichtigsten Aufgaben, die in einem View Skript zu erledigen sind, ist es sicherzustellen, dass die
Ausgaben auch richtig maskiert sind; neben anderen Dingen hilft dies auch Cross-Site Scripting Attacken zu
vermeiden. Sofern du keine Funktion, Methode oder einen Helfer verwendest, der die Maskierungen selber durchführt,
solltest Du Variablen immer maskieren, wenn du sie ausgeben möchtest.

``Zend_View`` stellt eine Methode escape() bereit, die das Maskieren für dich übernimmt.

.. code-block:: php
   :linenos:

   // schlechte View Skript Praxis:
   echo $this->variable;

   // gute View Skript Praxis:
   echo $this->escape($this->variable);

Standardmäßig verwendet escape() die *PHP* htmlspecialchars() Funktion für die Maskierung. Allerdings könntest
du abhängig von deiner Umgebung den Wunsch haben, die Maskierung anders durchzuführen. Verwende die setEscape()
Methode auf der Controller Ebene, um ``Zend_View`` mitzuteilen, welche Maskierungsmöglichkeit als Callback
verwendet werden soll.

.. code-block:: php
   :linenos:

   // erstelle eine Zend_View Instanz
   $view = new Zend_View();

   // teile ihr mit, dass htmlentities für die Maskierung
   // verwendet werden soll
   $view->setEscape('htmlentities');

   // oder teile ihr mit, eine statische Klassenmethode für
   // die Maskierung zu verwenden
   $view->setEscape(array('SomeClass', 'methodName'));

   // sogar Instanzmethoden sind möglich
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // und dann erstelle die Ausgabe
   echo $view->render(...);

Diese Callback Funktion oder Methode sollte den zu maskierenden Wert als ersten Parameter übernehmen und alle
anderen Parameter sollten optional sein.

.. _zend.view.scripts.templates:

Verwendung alternativer Templatesysteme
---------------------------------------

Obwohl *PHP* selber eine mächtiges Templatesystem ist, haben viele Entwickler das Gefühl, dass es zu mächtig
oder komplex für die Template Designer ist und möchten ein alternatives Templatesystem verwenden. ``Zend_View``
stellt zwei Mechanismen bereit, um dies zu realisieren, die erste durch Viewskripte und die zweite durch
Implementierung von ``Zend_View_Interface``.

.. _zend.view.scripts.templates.scripts:

Template Systeme die View Scripte verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Viewskript kann verwendet werden, um ein separats Templateobjekt zu instanzieren und anzupassen, z.B. für eine
PHPLIB-style Template. Das Viewskript für solch eine Aufgabe könnte so aussehen:

.. code-block:: php
   :linenos:

   include_once 'template.inc';
   $tpl = new Template();

   if ($this->books) {
       $tpl->setFile(array(
           "booklist" => "booklist.tpl",
           "eachbook" => "eachbook.tpl",
       ));

       foreach ($this->books as $key => $val) {
           $tpl->set_var('author', $this->escape($val['author']);
           $tpl->set_var('title', $this->escape($val['title']);
           $tpl->parse("books", "eachbook", true);
       }

       $tpl->pparse("output", "booklist");
   } else {
       $tpl->setFile("nobooks", "nobooks.tpl")
       $tpl->pparse("output", "nobooks");
   }

Dies wären die zugehörigen Template Dateien:

.. code-block:: html
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>Autor</th>
           <th>Titel</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>Es gibt keine Bücher zum Anzeigen.</p>

.. _zend.view.scripts.templates.interface:

Ein Templatesystem mit Hilfe von Zend_View_Interface verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Manche finden es einfacher, ein ``Zend_View`` kompatibles Templatesystem zu verwenden. ``Zend_View_Interface``
definiert die minimale Schnittstelle, die zur Kompatibilität benötigt wird.

.. code-block:: php
   :linenos:

   /**
    * Gebe das aktuelle Template Engine Objekt zurück
    */
   public function getEngine();

   /**
    * Setze den Pfad zu den Viewskripten / Templates
    */
   public function setScriptPath($path);

   /**
    * Setze den Pfad zu allen View Ressourcen
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Füge einen zusätzlichen Basispfad den View ressourcen hinzu
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Empfange die aktuellen Skript Pfade
    */
   public function getScriptPaths();

   /**
    * Überladungsmethoden zum Zuordnen von Templatevariablen
    * als Objekteigenschaften
    */
   public function __set($key, $value);
   public function __isset($key);
   public function __unset($key);

   /**
    * Manuelle Zuweisung von Templatevariablen oder die Möglichkeit,
    * mehrere Variablen in einem Durchgang zuzuordnen.
    */
   public function assign($spec, $value = null);

   /**
    * Alle zugewiesenen Templatevariablen zurücksetzen
    */
   public function clearVars();

   /**
    * Rendern des Templates mit dem Namen $name
    */
   public function render($name);

Durch Verwendung dieses Interfaces ist es relativ einfach, das Templatesystem eines Dritten in eine ``Zend_View``
kompatible Klasse zu umhüllen. Als Beispiel folgt ein möglicher Wrapper für Smarty:

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Smarty object
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Constructor
        *
        * @param string $tmplPath
        * @param array $extraParams
        * @return void
        */
       public function __construct($tmplPath = null, $extraParams = array())
       {
           $this->_smarty = new Smarty;

           if (null !== $tmplPath) {
               $this->setScriptPath($tmplPath);
           }

           foreach ($extraParams as $key => $value) {
               $this->_smarty->$key = $value;
           }
       }

       /**
        * Gebe das aktuelle Template Engine Objekt zurück
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Setze den Pfad zu den Templates
        *
        * @param string $path Das Verzeichnis, das als Pfad gesetzt werden soll.
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('Invalid path provided');
       }

       /**
        * Empfange das aktuelle template Verzeichnis
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Alias für setScriptPath
        *
        * @param string $path
        * @param string $prefix nicht verwendet
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Alias für setScriptPath
        *
        * @param string $path
        * @param string $prefix nicht verwendet
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Weise dem Template eine Variable zu
        *
        * @param string $key der Variablenname.
        * @param mixed $val der Variablenwert.
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Erlaubt das Testen von empty() und isset()
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Erlaubt das Zurücksetzen von Objekteigenschaften
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Weise dem Template Variablen zu
        *
        * Erlaubt das Zuweisen eines bestimmten Wertes zu einem bestimmten
        * Schlüssel, ODER die Übergabe eines Array mit Schlüssel => Wert
        * Paaren zum Setzen in einem Rutsch.
        *
        * @see __set()
        * @param string|array $spec Die zu verwendene Zuweisungsstrategie
        * (Schlüssel oder Array mit Schlüssel => Wert paaren)
        * @param mixed $value (Optional) Wenn ein Variablenname verwendet wurde,
        *                                verwende diesen als Wert
        * @return void
        */
       public function assign($spec, $value = null)
       {
           if (is_array($spec)) {
               $this->_smarty->assign($spec);
               return;
           }

           $this->_smarty->assign($spec, $value);
       }

       /**
        * Setze alle zugewiesenen Variablen zurück.
        *
        * Setzt alle Variablen zurück, die Zend_View entweder durch
        * {@link assign()} oder Überladen von Eigenschaften
        * ({@link __get()}/{@link __set()}) zugewiesen worden sind.
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Verarbeitet ein Template und gibt die Ausgabe zurück
        *
        * @param string $name Das zu verarbeitende Template
        * @return string Die Ausgabe.
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

In diesem Beispiel kannst du die ``Zend_View_Smarty`` anstelle von ``Zend_View`` instanzieren und es dann ungefähr
wie ``Zend_View`` verwenden:

.. code-block:: php
   :linenos:

   // Beispiel 1. In initView() des Initialisers.
   $view = new Zend_View_Smarty('/Pfad/der/Templates');
   $viewRenderer =
       Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
   $viewRenderer->setView($view)
                ->setViewBasePathSpec($view->_smarty->template_dir)
                ->setViewScriptPathSpec(':controller/:action.:suffix')
                ->setViewScriptPathNoControllerSpec(':action.:suffix')
                ->setViewSuffix('tpl');

   // Beispiel 2. Die Verwendung im Action Controller bleibt die gleiche...
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           $this->view->book   = 'Zend PHP 5 Zertifizierungs Study Guide';
           $this->view->author = 'Davey Shafik und Ben Ramsey'
       }
   }

   // Beispiel 3. Initialisierung der View im Action Controller
   class FooController extends Zend_Controller_Action
   {
       public function init()
       {
           $this->view   = new Zend_View_Smarty('/path/to/templates');
           $viewRenderer = $this->_helper->getHelper('viewRenderer');
           $viewRenderer->setView($this->view)
                        ->setViewBasePathSpec($view->_smarty->template_dir)
                        ->setViewScriptPathSpec(':controller/:action.:suffix')
                        ->setViewScriptPathNoControllerSpec(':action.:suffix')
                        ->setViewSuffix('tpl');
       }
   }


