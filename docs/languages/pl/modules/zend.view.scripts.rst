.. _zend.view.scripts:

Skrypty widoków
===============

Kiedy już kontroler przypisze zmienne i wywoła metodę render(), Zend_View dołącza wymagany skrypt widoku i
wykonuje go "wewnątrz" instancji Zend_View. Dlatego w skrypcie widoku, odwołania do zmiennych i metod
obsługiwane są za pomocą $this.

Zmienne przypisane do widoku przez kontroler odnoszą się do właściwości tej instancji. Na przykład, jeśli
kontroler przypisał zmienną 'cos', w skrypcie widoku możesz odwołać się do niej za pomocą $this->cos. (To
pozwala Ci na śledzenie zmiennych które zostały przypisane do skryptu i tych które są zmiennymi wewnętrznymi
skryptu).

W celu przypomnienia, oto przykład skryptu widoku pokazanego we wprowadzeniu do Zend_View.

.. code-block:: php
   :linenos:

   if ($this->books): ?>

       <!-- Tabela z książkami. -->
       <table>
           <tr>
               <th>Autor</th>
               <th>Tytuł</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Nie ma żadnych książek do wyświetlenia.</p>

   <?php endif;


.. _zend.view.scripts.escaping:

Filtrowanie danych wyjściowych
------------------------------

Jedną z najważniejszych rzeczy do zrobienia w skrypcie widoku jest uzyskanie pewności, że dane wyjściowe
zostały prawidłowo przefiltrowane. Pomaga to w przeciwdziałaniu atakom XSS. Jeśli nie używasz funkcji, metody
lub helpera w celu filtrowania danych wyjściowych, powinieneś zawsze je filtrować wtedy gdy chcesz je
wyświetlić.

Zend_View dostarcza metodę zwaną escape() która filtruje dane wyjściowe.

.. code-block:: php
   :linenos:

   // zły zwyczaj wyświetlania zmiennej:
   echo $this->variable;

   // dobry zwyczaj wyświetlania zmiennej:
   echo $this->escape($this->variable);


Domyślnie metoda escape() używa funkcji PHP htmlspecialchars() do filtrowania danych wyjściowych. Jakkolwiek,
zależenie od Twojego środowiska możesz chcieć filtrować dane wyjściowe w inny sposób. Użyj metody
setEscape() na poziomie kontrolera by przekazać instancji Zend_View informację o tym, jakiej metody filtrowania
ma używać.

.. code-block:: php
   :linenos:

   // utwórz instancje Zend_View
   $view = new Zend_View();

   // wybierz funkcję htmlentities() jako metodę filtrowania
   $view->setEscape('htmlentities');

   // lub wybierz statyczną klasę jako metodę filtrowania
   $view->setEscape(array('SomeClass', 'methodName'));

   // lub instancję
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // a teraz wygeneruj skrypt widoku
   echo $view->render(...);


Metoda lub funkcja filtrująca powinna przyjmować wartość do przefiltrowania jako pierwszy parametr, a wszystkie
inne parametry powinny być opcjonalne.

.. _zend.view.scripts.templates:

Użycie alternatywnych systemów szablonów
----------------------------------------

Chociaż PHP jest sam w sobie potężnym systemem szablonów, wielu programistów czuje, że jest on jednak zbyt
potężny lub skomplikowany dla projektantów szablonów i mogą chcieć użyć alternatywnego systemu szablonów.
Zend_View zapewnia do tego dwa mechanizmy, pierwszy przez skrypty widoku, drugi przez zaimplementowanie interfejsu
Zend_View_Interface.

.. _zend.view.scripts.templates.scripts:

Systemy szablonów używające skryptów widoku
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Skrypt widoku może być użyty w celu utworzenia instancji i manipulowania osobnym obiektem szablonu, takim jak
np. szablon PHPLIB. Skrypt widoku w takim przypadku mógłby wyglądać mniej więcej tak:

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


I mogłoby to być powiązane z takim plikiem szablonu:

.. code-block:: php
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>Autor</th>
           <th>Tytuł</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>Nie ma żadnych książek do wyświetlenia.</p>


.. _zend.view.scripts.templates.interface:

Systemy szablonów używające interfejsu Zend_View_Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Niektórzy mogą zrobić to łatwiej zapewniając w prosty sposób system szablonów kompatybilny z Zend_View.
*Zend_View_Interface* definiuje minimalny interfejs potrzebny dla kompatybilności.

.. code-block:: php
   :linenos:

   /**
    * Zwraca aktualny obiekt systemu szablonów
    */
   public function getEngine();

   /**
    * Ustawia ścieżkę do skryptów/szablonów widoku
    */
   public function setScriptPath($path);

   /**
    * Ustawia bazową ścieżkę dla wszystkich zasobów widoków
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Dodaje dodatkową ścieżkę dla wszystkich zasobów widoków
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Zwraca obecne ścieżki skryptów widoków
    */
   public function getScriptPaths();

   /**
    * Nadpisanie metod do przypisywania zmiennych
    * szablonów jako właściwości obiektu
    */
   public function __set($key, $value);
   public function __get($key);
   public function __isset($key);
   public function __unset($key);

   /**
    * Ręczne przypisywanie zmiennych szablonu,
    * lub możliwość przypisania wielu
    * zmiennych na raz.
    */
   public function assign($spec, $value = null);

   /**
    * Czyści wszystkie przypisane zmienne.
    */
   public function clearVars();

   /**
    * Renderowanie szablonu o nazwie $name
    */
   public function render($name);


Używając tego interfejsu, relatywnie proste staje się podpięcie zewnętrznego systemu szablonów jako klasy
kompatybilnej z Zend_View. Przykładowo, poniższy przykład to podpięcie systemu Smarty:

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Obiekt Smarty
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Konstruktor
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
        * Zwraca aktualny obiekt systemu szablonów
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Ustawia ścieżkę do szablonów
        *
        * @param string $path Ścieżka.
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('Nieprawidłowa ścieżka');
       }

       /**
        * Zwraca obecną ścieżkę szablonów
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Alias dla setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Alias dla setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Przypisanie zmiennej do szablonu
        *
        * @param string $key Nazwa zmiennej.
        * @param mixed $val Wartość zmiennej.
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Pobiera przypisaną zmienną
        *
        * @param string $key Nazwa zmiennej
        * @return mixed Wartość zmiennej.
        */
       public function __get($key)
       {
           return $this->_smarty->get_template_vars($key);
       }

       /**
        * Pozwala działać funkcjom empty() oraz
        * isset() na właściwościach obiektu
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Pozwala działać funkcji unset() na właściwości obiektu
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Przypisywanie zmiennych do szablonu
        *
        * Pozwala przypisać określoną wartość do określonego
        * klucza, LUB przekazać tablicę par klucz => wartość
        * aby przypisać je wszystkie na raz.
        *
        * @see __set()
        * @param string|array $spec Strategia przypisania (klucz
        * lub tablica par klucz=> wartość)
        * @param mixed $value (Opcjonalny) Gdy przypisujesz
        * nazwaną zmienną, użyj go jako wartości.
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
        * Czyści wszystkie przypisane zmienne.
        *
        * Czyści wszystkie zmienne przypisane do Zend_View za pomocą
        * {@link assign()} lub przeładowania właściwości
        * ({@link __get()}/{@link __set()}).
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Renderuje szablon i zwraca dane wyjściowe.
        *
        * @param string $name Nazwa szablonu do renderowania.
        * @return string Dane wyjściowe.
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }


W tym przykładzie powinieneś utworzyć instancję klasy *Zend_View_Smarty* zamiast *Zend_View*, a następnie
używać jej w dokładnie w ten sam sposób jak *Zend_View*:

.. code-block:: php
   :linenos:

   $view = new Zend_View_Smarty();
   $view->setScriptPath('/path/to/templates');
   $view->book = 'Zend PHP 5 Certification Study Guide';
   $view->author = 'Davey Shafik and Ben Ramsey'
   $rendered = $view->render('bookinfo.tpl');



