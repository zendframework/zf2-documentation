.. EN-Revision: none
.. _zend.form.quickstart:

Szybki start z Zend_Form
========================

Ten przewodnik opisuje podstawy tworzenia, weryfikacji oraz renderowania formularzy za pomocą komponentu
``Zend_Form``.

.. _zend.form.quickstart.create:

Tworzenie obiektu formularza
----------------------------

Tworzenie obiektu formularza jest bardzo proste: należy, po prostu, utworzyć egzemplarz klasy ``Zend_Form``:

.. code-block:: php
   :linenos:

   $form = new Zend_Form;


W zaawansowanych przypadkach można rozszerzyć klasę ``Zend_Form``, ale dla prostych formularzy wystarczy
utworzenie i skonfigurowanie formularza za pomocą obiektu ``Zend_Form``.

Dla określenia akcji oraz metody wywołania formularza, można użyć metod dostępowych ``setAction()`` oraz
``setMethod()``:

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');


Powyższy kod ustawia akcję formularza na adres *URL*"``/resource/process``" oraz metodę wykonania formularza na
*HTTP* *POST*. Będzie to wzięte pod uwagę podczas renderowania formularza.

Można ustawić dodatkowe atrybuty dla znacznika **<form>** używając metod ``setAttrib()`` lub ``setAttribs()``.
Przykładowo aby ustawić identyfikator, należy ustawić atrybut "``id``":

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');


.. _zend.form.quickstart.elements:

Dodawanie elementów do formularza
---------------------------------

Formularz jest bezużyteczny jeśli nie posiada elementów. Komponent ``Zend_Form`` posiada kilkanaście
domyślnych elementów które mogą być renderowane do postaci *XHTML* za pomocą klas pomocniczych
``Zend_View``. Te elementy to:

- button (przycisk)

- checkbox (pole wyboru lub wiele pól za pomocą multiCheckbox)

- hidden (pole ukryte)

- image (obrazek)

- password (hasło)

- radio (pole opcji)

- reset (przycisk resetujący)

- select (lista zwykła oraz lista wielokrotnego wyboru)

- submit (przycisk wysyłający)

- text (pole tekstowe)

- textarea (wieloliniowe pole tekstowe)

Istnieją dwie możliwości dodania elementów do formularza: utworzenie egzemplarza konkretnego elementu i
przekazanie go do obiektu formularza lub po prostu przekazanie typu elementu i pozwolenie obiektowi ``Zend_Form``
na automatyczne utworzenie egzemplarzy obiektów określonego typu.

Kilka przykładów:

.. code-block:: php
   :linenos:

   // Utworzenie egzemplarza elementu i przekazanie go do obiektu formularza:
   $form->addElement(new Zend_Form_Element_Text('username'));

   // Przekazanie typu elementu do obiektu:
   $form->addElement('text', 'username');


Domyślnie, elementy te nie posiadają filtrów ani walidatorów. Oznacza to że należy samodzielnie
skonfigurować dla nich walidatory i opcjonalnie filtry. Można to zrobić (a) przed przekazaniem elementu do
formularza, (b) za pomocą opcji konfiguracyjnych przekazanych podczas tworzenia elementu poprzez obiekt
``Zend_Form`` lub (c) pobierając istniejący element z obiektu formularza i konfigurując go.

Najpierw należy przyjrzeć się tworzeniu walidatorów dla konkretnego egzemplarza elementu. Można przekazać
obiekt ``Zend_Validate_*`` lub nazwę walidatora który ma zostać użyty:

.. code-block:: php
   :linenos:

   $username = new Zend_Form_Element_Text('username');

   // Przekazanie obiektu Zend_Validate_*:
   $username->addValidator(new Zend_Validate_Alnum());

   // Przekazanie nazwy walidatora:
   $username->addValidator('alnum');


Dla drugiego sposobu, można przekazać w trzecim parametrze metody tablicę z argumentami konstruktora wybranego
walidatora.

.. code-block:: php
   :linenos:

   // Przekazanie wzoru
   $username->addValidator('regex', false, array('/^[a-z]/i'));


(Drugi parametr jest używany aby określić czy niepowodzenie w weryfikacji ma przerwać następne weryfikacje czy
nie; domyślnie ma wartość ``FALSE``.)

Można także określić element jako wymagany. Aby to osiągnąć należy użyć metody dostępowej lub przekazać
opcję podczas tworzenia elementu. Oto pierwszy sposób:

.. code-block:: php
   :linenos:

   // Ustawienie elementu jako wymaganego:
   $username->setRequired(true);


Gdy element jest wymagany, dodawany jest walidator 'NotEmpty' na sam początek łańcucha walidatorów, dzięki
czemu można być pewnym, że element będzie posiadał wartość.

Filtry są rejestrowane w taki sam sposób jak walidatory. Aby pokazać jak działają, można dodać filtr
zamieniający znaki na małe litery:

.. code-block:: php
   :linenos:

   $username->addFilter('StringtoLower');


Finalnie konfiguracja elementu może wyglądać tak:

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // lub bardziej zwięźle:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));


Tworzenie obiektu dla każdego z elementów formularza może być nieco kłopotliwe. Można spróbować użyć
sposobu (b) przedstawionego wyżej. Podczas tworzenia nowego elementu metodą ``Zend_Form::addElement()`` jako
fabryki, można opcjonalnie przekazać również opcje konfiguracyjne. Obejmuje to także konfigurację filtrów i
walidatorów. Aby to zrobić można użyć kodu:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array(
       'validators' => array(
           'alnum',
           array('regex', false, '/^[a-z]/i')
       ),
       'required' => true,
       'filters'  => array('StringToLower'),
   ));


.. note::

   Jeśli w kilku miejscach konfigurowane są elementy za pomocą tych samych opcji, można rozważyć stworzenie
   własnej klasy rozszerzającej klasę ``Zend_Form_Element`` i następnie użycie tej klasy do tworzenia
   własnych elementów. Może to oszczędzić nieco pracy.

.. _zend.form.quickstart.render:

Renderowanie formularza
-----------------------

Renderowanie formularza jest proste. Większość elementów używa do tego klas pomocniczych ``Zend_View``, więc
potrzebny będzie do tego także obiekt widoku. Istnieją dwie możliwości: użycie metody formularza render() lub
po prostu wyświetlenie formularza za pomocą konstrukcji echo.

.. code-block:: php
   :linenos:

   // Jawnie wywołanie metody render() i przekazanie opcjonalnego obiektu widoku:
   echo $form->render($view);

   // Zakładając że obiekt widoku został wcześniej ustawiony za pomocą setView():
   echo $form;


Domyślnie obiekty ``Zend_Form`` oraz ``Zend_Form_Element`` używają obiektu widoku zainicjowanego w obiekcie
``ViewRenderer``, co oznacza, że nie trzeba go ręcznie ustawiać dla wzorca MVC Zend Framework. Renderowanie
formularza w skrypcie widoku jest wtedy bardzo proste:

.. code-block:: php
   :linenos:

   <? echo $this->form ?>


``Zend_Form`` używa "dekoratorów" do przeprowadzania renderowania. Te dekoratory mogą zastępować zawartość,
dodawać treść na początku lub na końcu, a także mieć pełny wgląd w element przekazany do nich. Można
użyć kilku dekoratorów aby uzyskać wymagany efekt. Domyślnie ``Zend_Form_Element`` używa czterech
dekoratorów aby wygenerować kod wyjściowy. Wygląda to w taki sposób:

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));


(Gdzie <HELPERNAME> jest nazwą klasy pomocniczej widoku, która ma być użyta. Może ona różnić się dla
różnych elementów.)

Układ dekoratorów przedstawiony powyżej generuje następujący kod:

.. code-block:: html
   :linenos:

   <dt><label for="username" class="required">Username</dt>
   <dd>
       <input type="text" name="username" value="123-abc" />
       <ul class="errors">
           <li>'123-abc' has not only alphabetic and digit characters</li>
           <li>'123-abc' does not match against pattern '/^[a-z]/i'</li>
       </ul>
   </dd>

(Jednak kod jest inaczej sformatowany.)

Można zmienić dekoratory używane przez element jeśli pożądany jest inny kod wyjściowy. Należy zapoznać
się z rozdziałem poświęconym dekoratorom aby uzyskać więcej informacji.

Formularz przechodzi poprzez wszystkie elementy i umieszcza je wewnątrz znacznika *HTML* **<form>**. Akcja i
metoda wysyłania formularza podane podczas jego konfigurowania zostaną dołączone do znacznika **<form>**, tak
samo jak inne atrybuty ustawione za pomocą metody ``setAttribs()``.

Formularz przechodzi przez elementy w takiej kolejności w jakiej były one zarejestrowane lub jeśli określony
element zawiera odpowiedni atrybut, zostanie on użyty w celu ustalenia kolejności. Można ustawiać kolejność
elementów używając metody:

.. code-block:: php
   :linenos:

   $element->setOrder(10);

Innym sposobem jest przekazanie kolejności jako opcji podczas tworzenia elementu:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));

.. _zend.form.quickstart.validate:

Sprawdzanie poprawności formularza
----------------------------------

Po tym jak formularz zostanie wysłany, należy sprawdzić czy pomyślnie przeszedł walidację. Każdy element
jest sprawdzany w oparciu o podane dane. Jeśli nie ma klucza odpowiadającego nazwie elementu, a element jest
oznaczony jako wymagany, weryfikacja zostanie przeprowadzona w oparciu o pustą wartość ``NULL``.

Skąd pochodzą dane? Możesz użyć tablic ``$_POST``, ``$_GET`` lub dowolnych innych źródeł danych (np.
żądań do web serwisów):

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // dane są poprawne
   } else {
       // dane nie są poprawne
   }

Przy korzystaniu z żądań AJAX, może zajść potrzeba przeprowadzenia weryfikacji pojedynczego elementu lub
grupy elementów. Metoda ``isValidPartial()`` częściowo sprawdza formularz. W przeciwieństwie do metody
``isValid()``, nie przeprowadza ona weryfikacji pól dla elementów których wartości nie zostały podane:

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // dane we wszystkich elementach pomyślnie przyszły weryfikację
   } else {
       // jeden lub więcej elementów nie przeszło poprawnie weryfikacji
   }


Do częściowej weryfikacji formularza można także użyć metody ``processAjax()``. W przeciwieństwie do metody
``isValidPartial()``, zwraca ona łańcuch znaków w formacie JSON zawierający informacje o błędach.

Zakładając że elementy zostały zweryfikowane i są poprawne, można pobrać przefiltrowane wartości:

.. code-block:: php
   :linenos:

   $values = $form->getValues();


Jeśli potrzeba niefiltrowanych wartości, należy użyć:

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();


.. _zend.form.quickstart.errorstatus:

Pobieranie informacji o błędach
-------------------------------

Formularz nie przeszedł weryfikacji? W większości przypadków można po prostu powtórnie wyświetlić
formularz, a błędy zostaną pokazane używając dekoratorów:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // przekazanie go do obiektu widoku i renderowanie widoku
       $this->view->form = $form;
       return $this->render('form');
   }


Dostępne są dwie metody do sprawdzania błędów. Metoda ``getErrors()`` zwraca tablicę asocjacyjną
zawierającą informacje o błędach w postaci nazwa elementu / kody (gdzie kody są tablicami kodów błędów).
Metoda ``getMessages()`` zwraca tablicę asocjacyjną zawierającą informacje o błędach w postaci nazwa elementu
/ komunikaty (gdzie komunikaty są asocjacyjną tablicą w postaci kod / komunikat). Jeśli dany element nie
zawiera błędów, nie będzie zawarty w tablicy.

.. _zend.form.quickstart.puttingtogether:

Złożenie w całość
-----------------

Teraz można przystąpić do budowy prostego formularza logowania. Potrzebne będą elementy:

- nazwa użytkownika

- hasło

- przycisk wysyłający

Na potrzeby przykładu można załóżyć że poprawna nazwa użytkownika powinna składać się jedynie ze znaków
alfanumerycznych, powinna zaczynać się od litery, jej długość powinna zawierać się między 6 a 12 znakami.
Litery powinny zostać zamienione na małe. Hasło musi składać się minimalnie z 6 znaków. Wartość przycisku
wysyłającego formularz można zignorować, więc nie musi podlegać walidacji.

Aby zbudować formularz można skorzystać z metod konfiguracyjnych obiektu ``Zend_Form``:

.. code-block:: php
   :linenos:

   $form = new Zend_Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // Utworzenie i skonfigurowanie elementu zawierającego nazwę użytkownika:
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // Utworzenie i skonfigurowanie elementu zawierającego hasło:
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Dodanie elementów do formularza:
   $form->addElement($username)
        ->addElement($password)
        // użycie metody addElement() jako fabryki tworzącej przycisk 'Zaloguj':
        ->addElement('submit', 'login', array('label' => 'Zaloguj'));

Następnie należy utworzyć kontroler obsługujący formularz:

.. code-block:: php
   :linenos:

   class UserController extends Zend_Controller_Action
   {
       public function getForm()
       {
           // tworzenie formularza jak wyżej
           return $form;
       }

       public function indexAction()
       {
           // renderowanie skryptu user/form.phtml
           $this->view->form = $this->getForm();
           $this->render('form');
       }

       public function loginAction()
       {
           if (!$this->getRequest()->isPost()) {
               return $this->_forward('index');
           }
           $form = $this->getForm();
           if (!$form->isValid($_POST)) {
               // Weryfikacja nieudana, ponowne wyświetlenie formularza
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // Weryfikacja udana, można próbować uwierzytelnić
       }
   }

Utworzenie skryptu widoku wyświetlającego formularz:

.. code-block:: php
   :linenos:

   <h2>Zaloguj się:</h2>
   <?= $this->form ?>

Jak nietrudno zauważyć, w kod kontrolera może wymagać trochę dodatkowej pracy: jeśli wysłane dane będą
poprawne, należy przeprowadzić uwierzytelnienie używając np. klasy ``Zend_Auth``.

.. _zend.form.quickstart.config:

Użycie obiektu Zend_Config
--------------------------

Wszystkie klasy ``Zend_Form`` można skonfigurować za pomocą komponentu ``Zend_Config``. Można przekazać obiekt
klasy ``Zend_Config`` do konstruktora lub przekazać go za pomocą metody ``setConfig()``. Oto jak można utworzyć
powyższy formularz używając pliku INI. Najpierw, biorąc pod uwagę zalecenia, należy umieścić konfigurację
w sekcjach odnoszących się do typu wdrożenia aplikacji i skupić się na sekcji 'development'. Następnie
należy utwórzyć sekcję dla danego kontrolera ('user'), oraz klucz dla formularza ('login'):

.. code-block:: ini
   :linenos:

   [development]
   ; ogólna konfiguracja formularza
   user.login.action = "/user/login"
   user.login.method = "post"

   ; nazwa użytkownika
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; hasło
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; przycisk wysyłający
   user.login.elements.submit.type = "submit"

Powyższe można przekazać do konstruktora obiektu formularza:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini($configFile, 'development');
   $form   = new Zend_Form($config->user->login);

w ten sposób cały formularz został zdefiniowany.

.. _zend.form.quickstart.conclusion:

Podsumowanie
------------

Dzięki temu przewodnikowi czytelnik powinien być na dobrej drodze do wykorzystania mocy i elastyczności
komponentu ``Zend_Form``. Aby uzyskać bardziej szczegółowe informacje należy zapoznać się z dalszymi
częściami dokumentacji.


