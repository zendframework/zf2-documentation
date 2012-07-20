.. _zend.view.introduction:

Wprowadzenie
============

Zend_View jest klasą zapewniającą obsługę części widoku ("view") we wzorcu projektowym MVC
(model-view-controller). Istnieje ona w celu oddzielenia wyglądu aplikacji od kontrolerów i danych. Zapewnia
system skryptów helperów i filtrów.

Zend_View jest bardzo prostym systemem; możesz użyć PHP jako języka szablonów lub utworzyć instancje innych
systemów szablonów, a następnie manipulować nimi wewnątrz skryptu widoku.

Zasadniczo użycie Zend_View składa się z dwóch kroków: 1. Twój skrypt kontrolera tworzy instancję klasy
Zend_View i przekazuje zmienne do tej instancji. 2. Kontroler mówi obiektowi Zend_View aby przetworzył określony
skrypt widoku, skutkiem tego jest wygenerowanie wyjściowego widoku.

.. _zend.view.introduction.controller:

Skrypt kontrolera
-----------------

Aby pokazać prosty przykład załóżmy, że kontroler ma dane w postaci listy książek i chcemy aby były one
przetworzone jako widok. Skrypt kontrolera mógłby wyglądać tak:

.. code-block::
   :linenos:

   // użyjmy modelu aby uzyskać dane o autorach książek i ich tytułach
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // przekażmy dane o książkach do instancji Zend_View
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // wygenerujemy wyjściowy widok o nazwie "booklist.php"
   echo $view->render('booklist.php');


.. _zend.view.introduction.view:

Skrypt widoku
-------------

Teraz potrzebujemy skryptu widoku "booklist.php". Jest to skrypt PHP jak każdy inny, z jednym wyjątkiem: jest on
wykonywany w przestrzeni instancji Zend_View, co oznacza, że odnosi się on do właściwości i metod klasy
Zend_View za pomocą $this. Zmienne przekazane do tej instancji przez kontroler są publicznymi właściwościami
instancji Zend_View) więc bardzo prosty skrypt mógłby wyglądać tak:

.. code-block::
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


Zauważ, że używamy metody "escape()" aby przefiltrować zmienne wyjściowe.

.. _zend.view.introduction.options:

Opcje
-----

*Zend_View* posiada kilka opcji, które mogą być użyte do skonfigurowania zachowania skryptów widoków.

- *basePath:* określa bazową ścieżkę, wewnątrz której znajdują się skrypty widoków, klasy helperów oraz
  klasy filtrów. Zakładane jest, że struktura katalogów wygląda tak:

  .. code-block::
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/


  Ta opcja może być ustawiona za pomocą metody *setBasePath()*, metody *addBasePath()*, lub jako opcja
  *basePath* przekazana do konstruktora.

- *encoding:* określa kodowanie znaków, które ma być użyte przez metody *htmlentities()*, *htmlspecialchars()*
  oraz w innych operacjach. Domyślnie jest to ISO-8859-1 (latin1). Może być ustawione za pomocą metody
  *setEncoding()* lub jako opcja *encoding* konstruktora.

- *escape:* określa funkcję używaną przez metodę *escape()*. Może być ustawiona za pomocą metody
  *setEscape()* lub za pomocą opcji *escape* konstruktora.

- *filter:* określa filtr, który ma być użyty po renderowaniu skryptu widoku. Może być ustawiony za pomocą
  metody *setFilter()*, metody *addFilter()*, lub za pomocą opcji *filter* konstruktora.

- *strictVars:* zmusza *Zend_View* do wyświetlania not i ostrzeżeń, wtedy gdy zdarzy się próba uzyskania
  dostępu do niezainicjowanych zmiennych widoków. Może to być ustawione przez wywołanie metody
  *strictVars(true)* lub przekazanie opcji *strictVars* do konstruktora.

.. _zend.view.introduction.shortTags:

Krótkie znaczniki wewnątrz skryptów widoków
-------------------------------------------

W naszych przykładach i dokumentacji używamy krótkich znaczników PHP: *<?* oraz *<?=*. Dodatkowo używamy
`alternatywnej składni instrukcji kontrolnych`_. Te wygodne skróty, których można użyć w skryptach widoków,
pozwalają na zwiększenie czytelności kodu

Jednak wielu programistów woli używać pełnych znaczników dla celów poprawności czy przenośności aplikacji.
Przykładowo dyrektywa *short_open_tag* jest wyłączona w rekomendowanym pliku konfiguracyjnym
php.ini.recommended, a także jeśli używasz w skryptach widoków języka XML, krótkie znaczniki mogłyby
powodować błędy.

Dodatkowo, jeśli użyjesz krótkich znaczników gdy ich obsługa jest wyłączona, to mogą wystąpić błędy w
skryptach widoków lub po prostu kod może zostać wyświetlony użytkownikom.

W przypadku gdy chcesz użyć krótkich znaczników, a ich obsługa jest wyłączona, masz dwa rozwiązania:

- Włączyć krótkie znaczniki w pliku *.htaccess*:

  .. code-block::
     :linenos:

     php_value "short_open_tag" "on"


  To będzie możliwe tylko jeśli posiadasz uprawnienia pozwalające na tworzenie i użycie plików *.htaccess*.
  Ta dyrektywa może być także dodana do pliku *httpd.conf*.

- Włączyć alternatywną obsługę strumienia danych, aby w locie konwertować krótkie znaczniki na pełne:

  .. code-block::
     :linenos:

     $view->setUseStreamWrapper(true);


  Rejestruje to klasę *Zend_View_Stream* jako klasę obsługującą strumień danych dla skryptów widoków i
  umożliwia dalsze działanie skryptów widoków, tak jakby obsługa krótkich znaczników była aktywna.

.. note::

   **Alternatywna obsługa strumienia danych zmniejsza wydajność**

   Użycie strumienia danych **zmniejszy** wydajność aplikacji, ale obecnie nie są dostępne testy które
   mogłyby pokazać jak bardzo zmniejszy. Zalecamy włączenie obsługi krótkich znaczników, konwersję
   skryptów widoków aby używały pełnych znaczników lub wprowadzenie dobrego buforowania części lub
   całości widoków.

.. _zend.view.introduction.accessors:

Narzędziowe metody dostępowe
----------------------------

W większości przypadków będziesz używał tylko metod *assign()*, *render()*, lub jednej z metod do
ustawiania/dodawania filtrów, klas helperów oraz ścieżek skryptów widoków. Jednak jeśli chcesz samodzielnie
rozszerzyć klasę *Zend_View*, lub potrzebujesz dostępu do jej pewnych wewnętrznych funkcjonalności, to możesz
użyć kilku istniejących metod dostępowych:

- *getVars()* zwraca wszystkie przypisane zmienne.

- *clearVars()* wyczyści wszystkie przypisane zmienne; użyteczne gdy chcesz ponownie użyć obiektu widoku, ale
  chcesz zachować kontrolę nad tym, które zmienne mają być dostępne.

- *getScriptPath($script)* zwraca ścieżkę dla podanego skryptu widoku.

- *getScriptPaths()* zwraca wszystkie zarejestrowane ścieżki skryptów widoków.

- *getHelperPath($helper)* zwraca ścieżkę dla podanej klasy helpera.

- *getHelperPaths()* zwraca wszystkie zarejestrowane ścieżki klas helperów.

- *getFilterPath($filter)* zwraca ścieżkę dla podanej klasy filtra.

- *getFilterPaths()* zwraca wszystkie zarejestrowane ścieżki klas filtrów.



.. _`alternatywnej składni instrukcji kontrolnych`: http://us.php.net/manual/en/control-structures.alternative-syntax.php
