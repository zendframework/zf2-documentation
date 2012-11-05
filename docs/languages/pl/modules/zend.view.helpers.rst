.. EN-Revision: none
.. _zend.view.helpers:

Klasy helperów
==============

W skryptach widoków często potrzebne jest przeprowadzanie złożonych funkcji: na przykład formatowanie daty,
generowanie elementów formularzy, czy wyświetlanie odnośników akcji. Możesz użyć klas helperów w tym celu.

Klasa helpera jest prostą klasą. Powiedzmy, że potrzebujemy klasę helpera o nazwie 'fooBar'. Domyślnie nazwa
klasy jest poprzedzona przedrostkiem *'Zend\View_Helper\'* (możesz określić własny przedrostek podczas
ustawiania ścieżki do klas helperów), a ostatni segment nazwy klasy jest nazwą klasy helpera; ten segment
powinien być w postaci TitleCapped; pełna nazwa klasy wygląda więc tak: *Zend\View_Helper\FooBar*. Ta klasa
powinna zawierać przynajmniej jedną metodę, nazwaną tak jak klasa helpera, ale już w postaci camelCased:
*fooBar()*.

.. note::

   **Zwróć uwagę na wielkość liter**

   Nazwy klas helperów są zawsze w postaci camelCased, czyli nigdy nie zaczynają się wielką literą. Nazwa
   klasy jest w postaci MixedCased, ale wywoływana metoda zawsze ma postać camelCased.

.. note::

   **Domyślne ścieżki helperów**

   Domyślna ścieżka helperów zawsze wskazuje na ścieżkę helperów widoków Zend Framework np.,
   'Zend/View/Helper/'. Nawet jeśli wywołasz metodę *setHelperPath()* aby nadpisać istniejące ścieżki,
   domyślna ścieżka zawsze będzie ustawiona aby być pewnym, że domyślne helpery będą zawsze działać.

Aby użyć helpera w swoim skrypcie widoku, wywołaj go za pomocą *$this->nazwaHelpera()*. Obiekt *Zend_View*
załaduje klasę *Zend\View_Helper\NazwaHelpera*, utworzy obiekt tej klasy i wywoła metodę *nazwaHelpera()*.
Instancja obiektu istnieje teraz w instancji *Zend_View* i będzie ona ponownie używana przy następnych
wywołaniach *$this->nazwaHelpera()*.

.. _zend.view.helpers.initial:

Wbudowane klasy helperów
------------------------

*Zend_View* posiada wbudowany zbiór klas helperów, z których większość odnosi się do generowania formularzy,
a każda z nich automatycznie filtruje dane wyjściowe. Dodatkowo dostępne są klasy helperów służące do
tworzenia adresów URL na podstawie tras, do tworzenia list HTML oraz do deklarowania zmiennych. Obecnie dostępne
klasy helperów to:

- *declareVars():* Głównie używana gdy używamy metody *strictVars()*, ta klasa helpera może być użyta do
  zadeklarowania zmiennych szablonu, które zostały ustawione lub nie, w obiekcie widoku. Możemy też użyć jej
  do ustawienia domyślnych wartości. Tablice przekazane do metody jako argumenty zostaną użyte do ustawienia
  domyślnych wartości; w przeciwnym razie, gdy zmienna nie istnieje, zostanie ustawiona jako pusty łańcuch
  znaków.

- *fieldset($name, $content, $attribs):* Tworzy element fieldset. Jeśli tablica *$attribs* zawiera klucz 'legend',
  ta wartość zostanie użyta jako legenda pola fieldset. Pole fieldset będzie zawierać zawartość przekazaną
  do tego helpera przez zmienną *$content*.

- *form($name, $attribs, $content):* Generuje formularz. Wszystkie atrybuty z tablicy *$attribs* będą
  zabezpieczone i renderowane jako atrybuty XHTML znacznika form. Jeśli przekazana jest zmienna *$content* i ma
  inną wartość niż false, to zawartość tej zmiennej zostanie renderowana wraz ze znacznikiem otwierającym i
  zamykającym formularz; jeśli zmienna *$content* ma wartość false (domyślnie), zostanie zrenderowany tylko
  znacznik otwierający.

- *formButton($name, $value, $attribs):* Tworzy element <button />.

- *formCheckbox($name, $value, $attribs, $options):* Tworzy element <input type="checkbox" />.

  Domyślnie, jeśli zmienne $value oraz $options nie są przekazane, dla pola niezaznaczonego zostanie przyjęta
  wartość '0', a dla zaznaczonego wartość '1'. Jeśli zostanie przekazana zmienna $value, ale nie zostanie
  przekazana zmienna $options, dla pola zaznaczonego zostanie przyjęta wartość zmiennej $value.

  Zmienna $options powinna być tablicą. Jeśli tablica jest indeksowana, dla pola zaznaczonego zostanie przyjęta
  pierwsza wartość, a druga wartość dla pola niezaznaczonego; wszystkie inne wartości zostaną zignorowane.
  Możesz także przekazać tablicę asocjacyjną z kluczami 'checked' oraz 'unChecked'.

  Jeśli zmienna $options zostanie przekazana, a wartość $value jest równa wartości określonej dla pola
  zaznaczonego, to element zostanie zaznaczony. Możesz także określić czy element ma być zaznaczony
  przekazując logiczną wartość dla atrybutu 'checked'.

  Powyższe najlepiej podsumować za pomocą przykładów:

  .. code-block:: php
     :linenos:

     // '1' oraz '0' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest niezaznaczone
     echo $this->formCheckbox('foo');

     // '1' oraz '0' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest zaznaczone
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // 'bar' oraz '0' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest niezaznaczone
     echo $this->formCheckbox('foo', 'bar');

     // 'bar' oraz '0' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest zaznaczone
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // 'bar' oraz 'baz' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest niezaznaczone
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz');

     // 'bar' oraz 'baz' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest niezaznaczone
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // 'bar' oraz 'baz' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest zaznaczone
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz');
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => true),
                              array('bar', 'baz');

     // 'bar' oraz 'baz' jako opcje dla pola zaznaczonego/niezaznaczonego;
     // pole jest niezaznaczone
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz');
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => false),
                              array('bar', 'baz');


  We wszystkich przypadkach zostanie dołączony ukryty element z wartością dla pola niezaznaczonego; w ten
  sposób uzyskamy pewność, że nawet jeśli pole nie będzie zaznaczone, to do formularza zostanie przekazana
  poprawna wartość.

- *formErrors($errors, $options):* Generuje listę nieuporządkowaną zawierająca informacje o błędach. Zmienna
  *$errors* powinna być łańcuchem znaków lub tablicą łańcuchów znaków; Zmienna *$options* powinna
  zawierać atrybuty jakie chcesz umieścić w znaczniku otwierającym listę.

  Możesz określić alternatywny sposób otwarcia, zamknięcia i oddzielania informacji o błędach wywołując
  metody helpera:

  - *setElementStart($string)*; domyślną wartością jest '<ul class="errors"%s"><li>', gdzie %s jest zastąpione
    atrybutami zdefiniowanymi w zmiennej *$options*.

  - *setElementSeparator($string)*; domyślną wartością jest '</li><li>'.

  - *setElementEnd($string)*; domyślną wartością jest '</li></ul>'.

- *formFile($name, $value, $attribs):* Tworzy element <input type="file" />.

- *formHidden($name, $value, $attribs):* Tworzy element <input type="hidden" />.

- *formLabel($name, $value, $attribs):* Tworzy element <label>, nadając atrybutowi *for* wartość zmiennej
  *$name* i ustawiając jako etykietę wartość zmiennej *$value*. Jeśli opcja *disable* zostanie przekazana w
  zmiennej *$attribs*, żaden kod nie zostanie zwrócony.

- *formMultiCheckbox($name, $value, $attribs, $options, $listsep):* Tworzy listę elementów checkbox. Zmienna
  *$options* powinna być asocjacyjną tablicą, i może mieć dowolne rozmiary. Zmienna *$value* może być
  pojedynczą wartością lub tablicą wartości, które odpowiadają kluczom tablicy *$options*. Zmienna
  *$listsep* jest separatorem elementów, domyślnie ma wartość <br />. Domyślnie ten element jest traktowany
  jako tablica; wszystkie pola mają te samą nazwę i będą wysłane jako tablica.

- *formPassword($name, $value, $attribs):* Tworzy element <input type="password" />.

- *formRadio($name, $value, $attribs, $options):* Tworzy serię elementów <input type="radio" />, po jednym dla
  każdego elementu tablicy $options. W tablicy $options, klucz jest wartością przycisku radio, a wartość
  elementu tablicy jest etykietą przycisku radio. Zmienna $value określa wartość przycisku, który ma być
  początkowo zaznaczony.

- *formReset($name, $value, $attribs):* Tworzy element <input type="reset" />.

- *formSelect($name, $value, $attribs, $options):* Tworzy blok <select>...</select>, z elementami <option> po
  jednym dla każdego elementu tablicy $options. W tablicy $options klucz jest wartością elementu, a wartość
  jest etykietą. Zmienna $value określa wartość elementu (lub elementów), który ma być początkowo
  zaznaczony.

- *formSubmit($name, $value, $attribs):* Tworzy element <input type="submit" />.

- *formText($name, $value, $attribs):* Tworzy element <input type="text" />.

- *formTextarea($name, $value, $attribs):* Tworzy element <textarea>...</textarea>.

- *url($urlOptions, $name, $reset):* Tworzy adres URL na podstawie nazwy trasy. Parametr *$urlOptions* powinien
  być tablicą asocjacyjną zawierającą pary klucz/wartość używane przez daną trasę.

- *htmlList($items, $ordered, $attribs, $escape):* generuje uporządkowane oraz nieuporządkowane listy na
  podstawie przekazanego do niej parametru *$items*. Jeśli parametr *$items* jest wielowymiarową tablicą,
  zostanie zbudowana lista zagnieżdżona. Jeśli flaga *$escape* ma wartość true (domyślnie), każdy z
  elementów zostanie zabezpieczony za pomocą mechanizmu zarejestrowanego w obiekcie widoku; przekaż wartość
  false aby zezwolić na wyświetlanie kodu html wewnątrz elementów list.

Użycie tych metod w Twoim skrypcie jest bardzo łatwe, poniżej znajduje się przykład. Zauważ, że wszystko
czego potrzebujesz to wywołanie tych metod; załadowanie ich i utworzenie instancji odbędzie się automatycznie.

.. code-block:: php
   :linenos:

   // wewnątrz skryptu widoku, $this odnosi się do instancji Zend_View.
   //
   // załóżmy, że już przypisałeś serię elementów opcji jako tablicę
   // o nazwie $countries = array('us' => 'United States', 'il' =>
   // 'Israel', 'de' => 'Germany').
   ?>
   <form action="action.php" method="post">
       <p><label>Adres Email:
   <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>Kraj:
   <?php echo $this->formSelect('country', 'us', null, $this->countries) ?>
       </label></p>
       <p><label>Czy zgadzasz się?
   <?php echo $this->formCheckbox('opt_in', 'yes', null, array('yes', 'no')) ?>
       </label></p>
   </form>


Rezultat wyglądałby w ten sposób:

.. code-block:: php
   :linenos:

   <form action="action.php" method="post">
       <p><label>Adres Email:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>Kraj:
           <select name="country">
               <option value="us" selected="selected">United States</option>
               <option value="il">Israel</option>
               <option value="de">Germany</option>
           </select>
       </label></p>
       <p><label>Czy zgadzasz się?
           <input type="hidden" name="opt_in" value="no" />
           <input type="checkbox" name="opt_in" value="yes" checked="checked" />
       </label></p>
   </form>


.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.translator.rst
.. _zend.view.helpers.paths:

Ścieżki klas helperów
---------------------

Tak jak ze skryptami widoków, kontroler może określić stos ścieżek, w których *Zend_View* ma szukać klas
helperów. Domyślnie *Zend_View* szuka klas helperów w katalogu "Zend/View/Helper/\*". Możesz wybrać inny
katalog używając metod *setHelperPath()* oraz *addHelperPath()*. Dodatkowo możesz określić przedrostek klas
helperów znajdujących się w podanej ścieżce aby utworzyć przestrzenie nazw dla klas helperów. Domyślnie,
gdy żaden przedrostek nie zostanie określony, przyjęty zostanie przedrostek 'Zend\View\Helper\_'.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();
   // Ustaw ścieżkę na /path/to/more/helpers, z przedrostkiem 'My_View_Helper'
   $view->setHelperPath('/path/to/more/helpers', 'My_View_Helper');


Oczywiście możesz dodawać ścieżki na stos używając metody *addHelperPath()*. Gdy dodajesz ścieżki na stos,
*Zend_View* będzie szukać klasy helpera począwszy od ostatnio dodanej ścieżki. To pozwala na dodanie (lub
nawet nadpisanie) podstawowego pakietu klas helperów swoimi własnymi klasami.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();

   // Dodaj ścieżkę /path/to/some/helpers z przedrostkiem
   // klasy 'My_View_Helper'
   $view->addHelperPath('/path/to/some/helpers', 'My_View_Helper');

   // Dodaj ścieżkę /other/path/to/helpers z przedrostkiem
   // klasy 'Your_View_Helper'
   $view->addHelperPath('/other/path/to/helpers', 'Your_View_Helper');

   // teraz kiedy wywołasz $this->helperName(), Zend_View będzie
   // wpierw szukał w "/path/to/some/helpers/HelperName" używając
   // nazwy klasy "Your_View_Helper_HelperName",
   // następnie w "/other/path/to/helpers/HelperName.php" używając
   // nazwy klasy "My_View_Helper_HelperName"
   // i ostatecznie w "Zend/View/Helper/HelperName.php" używając
   // nazwy klasy "Zend\View_Helper\HelperName".


.. _zend.view.helpers.custom:

Pisanie własnych klas helperów
------------------------------

Pisanie własnych klas helperów jest łatwe; po prostu pisz według poniższych zasad:

- Minimalna nazwa klasy musi kończyć się nazwą helpera przy użyciu MixedCaps. Przykładowo, jeśli piszesz
  klasę helpera zwaną "twojHelper", minimalną nazwą klasy musi być "TwojHelper". Możesz, a nawet powinieneś
  nadać nazwie klasy przedrostek i jest zalecane, abyś użył 'View_Helper' jako części przedrostka:
  "My_View_Helper_TwojHelper". (Przedrostek będziesz musiał przekazać wraz z końcowym znakiem podkreślenia lub
  bez niego, do metod *addHelperPath()* oraz *setHelperPath()*).

- Nazwa klasy musi przynajmniej składać się z nazwy helpera, używając formy MixedCaps. Np. jeśli tworzysz
  helper nazwany "twojHelper", nazwą klasy musi być przynajmniej "TwojHelper". Możesz, a nawet powinieneś dać
  nazwie klasy przedrostek i jest zalecane aby znalazła się w nim część 'View_Helper' aby cała nazwa klasy
  wyglądała mniej więcej tak: "My_View_Helper_TwojHelper". (Będziesz musiał przekazać ten przedrostek, ze
  końcowym znakiem podkreślenia lub bez, do jednej z metod *addHelperPath()* lub *setHelperPath()*).

- Klasa musi posiadać publiczną metodę która jest taka jak nazwa helpera; jest to metoda która zostanie
  wywołana gdy skrypt widoku wywoła "$this->twojHelper()". W przykładzie helpera "twojHelper", wymaganą
  deklaracją metody powinno być "public function twojHelper()".

- Klasa nie powinna wyświetlać ani w inny sposób generować danych wyjściowych. Zamiast tego powinna zwrócić
  dane do wyświetlenia. Zwracane wartości powinny być odpowiednio przefiltrowane.

- Klasa musi znajdować się w pliku odpowiednio do nazwy metody helpera. Przykładowo dla helpera o nazwie
  "twojHelper", plik powinien nazywać się "TwojHelper.php".

Umieść plik klasy helpera w katalogu który był dodany do stosu ścieżek, a *Zend_View* automatycznie załaduje
klasę, utworzy instancję, i uruchomi metodę.

Poniżej przykład kodu naszego przykładowego helpera *twojHelper*:

.. code-block:: php
   :linenos:

   class My_View_Helper_TwojHelper extends Zend\View_Helper\Abstract
   {
       protected $_count = 0;
       public function twojHelper()
       {
           $this->_count++;
           $output = "I have seen 'The Jerk' {$this->_count} time(s).";
           return htmlspecialchars($output);
       }
   }


Teraz w skrypcie widoku możesz wywołać helpera *TwojHelper* tyle razy ile zechcesz; instancja zostanie utworzona
raz i będzie ona istniała przez cały okres istnienia instancji *Zend_View*.

.. code-block:: php
   :linenos:

   // pamiętaj, że w skrypcie widoku $this odnosi się do instancji Zend_View.
   echo $this->twojHelper();
   echo $this->twojHelper();
   echo $this->twojHelper();


Dane wyjściowe wyglądałyby w ten sposób:

.. code-block:: php
   :linenos:

   I have seen 'The Jerk' 1 time(s).
   I have seen 'The Jerk' 2 time(s).
   I have seen 'The Jerk' 3 time(s).


Czasem możesz potrzebować uzyskać dostęp do obiektu *Zend_View*-- na przykład, jeśli potrzebujesz użyć
zarejestrowanego kodowania, lub chcesz renderować inny skrypt widoku jako część klasy helpera. Aby uzyskać
dostęp do obiektu widoku, klasa helpera powinna posiadać metodę *setView($view)*, tak jak poniżej:

.. code-block:: php
   :linenos:

   class My_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend\View\Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }


Jeśli twoja klasa helpera posiada metodę *setView()*, będzie ona wywołana wtedy, gdy po raz pierwszy zostanie
utworzona instancja klasy helpera i przekazany zostanie obecny obiekt widoku. Jest to po to, aby przechować obiekt
widoku w klasie helpera, a także po to, aby określić w jaki sposób powinno się uzyskiwać do tego obiektu
dostęp.

Jeśli rozszerzasz klasę *Zend\View_Helper\Abstract* nie musisz definiować tej metody, ponieważ jest ona
zdefiniowana przez klasę rozszerzaną.


