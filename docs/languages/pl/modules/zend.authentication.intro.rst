.. EN-Revision: none
.. _zend.authentication.introduction:

Wprowadzenie
============

``Zend_Auth`` zapewnia *API* do uwierzytelniania oraz zawiera konkretne adaptery uwierzytelniania dla
najczęstszych przypadków użycia.

Komponent ``Zend_Auth`` jest związany tylko z **uwierzytelnianiem**, a nie z **autoryzacją**. Uwierzytelnianie
luźno definiujemy jako określanie w oparciu o pewien zestaw danych tego, czy dana jednostka jest tym na co
wygląda (np. identyfikacja). Autoryzacja, proces decydowania o tym, czy zezwolić danej jednostce na dostęp lub
przeprowadzanie operacji na innych jednostkach, jest poza polem działania ``Zend_Auth``. Aby uzyskać więcej
informacji o autoryzacji i kontroli dostępu za pomocą Zend Framework, proszę zobacz :ref:`Zend\Permissions\Acl <zend.permissions.acl>`.

.. note::

   Klasa ``Zend_Auth`` implementuje wzorzec singletona, czyli dostępna jest tylko jej jedna instancja - za pomocą
   statycznej metody ``getInstance()``. Oznacza to, że użycie operatorów **new** oraz **clone** nie będzie
   możliwe z klasą ``Zend_Auth``; zamiast nich użyj metody ``Zend_Auth::getInstance()``.

.. _zend.authentication.introduction.adapters:

Adaptery
--------

Adapter ``Zend_Auth`` jest używany do uwierzytelniania na podstawie serwisu konkretnego typu, takiego jak *LDAP*,
*RDBMS*, lub system plików. Różne adaptery mogą mieć różne opcje i mogą inaczej się zachowywać, ale
niektóre podstawowe funkcjonalności są wspólne dla wszystkich adapterów. Na przykład akceptowanie danych
uwierzytelniania, przeprowadzanie zapytań do serwisu uwierzytelniania i zwracanie rezultatów są wspólne dla
adapterów ``Zend_Auth``.

Każda klasa adaptera ``Zend_Auth`` implementuje interfejs ``Zend_Auth_Adapter_Interface``. Ten interfejs definiuje
jedną metodę, ``authenticate()``, którą klasa adaptera musi implementować dla zastosowań przeprowadzania
zapytania uwierzytelniania. Każda klasa adaptera musi być przygotowana przed wywołaniem metody
``authenticate()``. Przygotowanie takiego adaptera obejmuje ustawienie danych uwierzytelniania (np. nazwy
użytkownika i hasła) oraz zdefiniowanie wartości dla specyficznych opcji adaptera, na przykład ustawienie
połączenia do bazy danych dla adaptera tabeli bazy danych.

Poniżej jest przykładowy adapter uwierzytelniania, który do przeprowadzenia procesu wymaga ustawionej nazwy
użytkownika oraz hasła. Inne szczegóły, takie jak sposób przeprowadzania zapytania uwierzytelniającego,
zostały pominięte w celu zwiększenia czytelności:

.. code-block:: php
   :linenos:

   class MyAuthAdapter implements Zend_Auth_Adapter_Interface
   {
       /**
        * Ustawia nazwę użytkownika oraz hasła dla uwierzytelniania
        *
        * @return void
        */
       public function __construct($username, $password)
       {
           // ...
       }

       /**
        * Przeprowadza próbę uwierzytelniania
        *
        * @throws Zend_Auth_Adapter_Exception Jeśli uwierzytelnianie
        *                                     nie może być przeprowadzone
        * @return Zend_Auth_Result
        */
       public function authenticate()
       {
           // ...
       }
   }

Jak pokazano w bloku dokumentacyjnym, metoda ``authenticate()`` musi zwracać instancję ``Zend_Auth_Result`` (lub
instancję klasy rozszerzającej ``Zend_Auth_Result``). Jeśli z jakiegoś powodu przeprowadzenie zapytania
uwierzytelniającego jest niemożliwe, metoda ``authenticate()`` powinna wyrzucić wyjątek rozszerzający
``Zend_Auth_Adapter_Exception``.

.. _zend.authentication.introduction.results:

Resultat
--------

Adaptery ``Zend_Auth`` zwracają instancję ``Zend_Auth_Result`` za pomocą metody ``authenticate()`` w celu
przekazania rezultatu próby uwierzytelniania. Adaptery wypełniają obiekt ``Zend_Auth_Result`` podczas
konstrukcji, dlatego poniższe cztery metody zapewniają podstawowy zestaw operacji, które są wspólne dla
rezultatów adapterów ``Zend_Auth``:

- ``isValid()``- zwraca logiczną wartość true tylko wtedy, gdy rezultat reprezentuje udaną próbę
  uwierzytelniania.

- ``getCode()``- zwraca identyfikator w postaci stałej klasy ``Zend_Auth_Result`` dla określenia powodu
  nieudanego uwierzytelniania lub sprawdzenia czy uwierzytelnianie się udało. Metoda może być użyta w
  sytuacjach gdy programista chce rozróżnić poszczególne typy wyników uwierzytelniania. Pozwala to na
  przykład programiście na zarządzanie szczegółowymi statystykami na temat wyników uwierzytelniania. Innym
  przykładem użycia tej funkcjonalności może być potrzeba zapewnienia wiadomości informujących użytkownika
  o przebiegu uwierzytelniania, ale jednak zalecane jest rozważenie ryzyka jakie zachodzi przy przekazywaniu
  użytkownikowi takich szczegółowych informacji, zamiast podstawowej informacji o błędzie. Aby uzyskać
  więcej informacji, zobacz poniżej.

- ``getIdentity()``- zwraca tożsamość próby uwierzytelniania

- ``getMessages()``- zwraca tablicę wiadomości odnoszących się do nieudanej próby uwierzytelniania

Programista może chcieć przeprowadzić jakieś specyficzne akcje zależne od typu wyniku uwierzytelniania.
Przykładami operacji, które programiści mogą uznać za użyteczne, mogą być: blokowanie kont po zbyt dużej
ilości nieudanych próbach logowania, zapiywanie adresów IP po wpisaniu przez użytkownika nieistnięjącej nazwy
tożsamości czy zapewnienie własnych zdefiniowanych komunikatów po próbie uwierzytelniania. Dostępne są takie
kody wyników:

.. code-block:: php
   :linenos:

   Zend_Auth_Result::SUCCESS
   Zend_Auth_Result::FAILURE
   Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND
   Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS
   Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID
   Zend_Auth_Result::FAILURE_UNCATEGORIZED

Poniższy przykład pokazuje w jaki sposób programista może obsłużyć to kodzie:

.. code-block:: php
   :linenos:

   // wewnątrz akcji loginAction kontrolera AuthController
   $result = $this->_auth->authenticate($adapter);

   switch ($result->getCode()) {

       case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
           /** obsługujemy nieistniejącą tożsamość **/
           break;

       case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
           /** obsługujemy nieprawidłowe hasło **/
           break;

       case Zend_Auth_Result::SUCCESS:
           /** obsługujemy udane uwierzytelnianie **/
           break;

       default:
           /** obsługujemy inne błędy **/
           break;
   }

.. _zend.authentication.introduction.persistence:

Trwałość uwierzytelnionej tożsamości
------------------------------------

Uwierzytelnianie żądania, które zawiera dane uwierzytelniające jest samo w sobie użyteczne, ale ważna jest
także obsługa uwierzytelnionej tożsamości bez konieczności dołączania danych uwierzytelniających do
każdego żądania.

*HTTP* jest protokołem niezachowującym stanu pomiędzy żądaniami, a techniki takie jak pliki cookie oraz sesje
zostały stworzone w celu ułatwienia zarządzania stanem pomiędzy żądaniami w aplikacjach serwerowych.

.. _zend.authentication.introduction.persistence.default:

Domyślne przechowywanie w sesji PHP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Domyślnie ``Zend_Auth`` zapewnia trwały pojemnik do przechowywania tożsamości pochodzącej z udanej próby
uwierzytelniania używając sesji *PHP*. Po udanej próbie uwierzytelniania, metoda ``Zend_Auth::authenticate()``
przechowuje wtrwałym pojemniku tożsamość pochodzącą z wyniku uwierzytelniania. Jeśli nie skonfigurujemy tego
inaczej, klasa ``Zend_Auth`` użyje klasy pojemnika o nazwie ``Zend_Auth_Storage_Session``, który używa klasy
:ref:`Zend_Session <zend.session>`. Zamiast tego za pomocą metody ``Zend_Auth::setStorage()`` może być ustawiona
własna klasa implementująca interfejs ``Zend_Auth_Storage_Interface``.

.. note::

   Jeśli automatyczne przechowywanie tożsamości w trwałym pojemniku nie jest odpowiednie dla konkretnego
   przypadku użycia, to programiści mogą obyć się bez klasy ``Zend_Auth``, a zamiast niej użyć bezpośrednio
   klasy adaptera.

.. _zend.authentication.introduction.persistence.default.example:

.. rubric:: Modyfikowanie przestrzeni nazw sesji

``Zend_Auth_Storage_Session`` używa przestrzeni nazw sesji o nazwie '``Zend_Auth``'. Ta przestrzeń nazw może
być nadpisana przez przekazanie innej wartości do konstruktora klasy ``Zend_Auth_Storage_Session``, a ta
wartość wewnętrznie jest przekazywana do konstruktora klasy ``Zend_Session_Namespace``. Powinno to nastąpić
zanim przeprowadzone zostanie uwierzytelnianie, ponieważ metoda ``Zend_Auth::authenticate()`` automatycznie
zapisuje dane tożsamości.

.. code-block:: php
   :linenos:

   // Zapisujemy referencję do pojedynczej instancji Zend_Auth
   $auth = Zend_Auth::getInstance();

   // Używamy przestrzeni nazw 'someNamespace' zamiast 'Zend_Auth'
   $auth->setStorage(new Zend_Auth_Storage_Session('someNamespace'));

   /**
    * @todo Ustawić adapter uwierzytelniania, $authAdapter
    */

   // Uwierzytelniamy, zapisując wynik i przechowując tożsamość
   // po udanym uwierzytelnieniu
   $result = $auth->authenticate($authAdapter);

.. _zend.authentication.introduction.persistence.custom:

Implementacja własnego pojemnika
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Czasem programiści mogą potrzebować użyć innego sposobu trwałego przechowywania tożsamości niż ten
zapewniony przez ``Zend_Auth_Storage_Session``. W takich przypadkach programiści mogą po prostu zaimplementować
interfejs ``Zend_Auth_Storage_Interface`` i przekazać instancję klasy do metody ``Zend_Auth::setStorage()``.

.. _zend.authentication.introduction.persistence.custom.example:

.. rubric:: Użycie własnej klasy do przechowywania tożsamości

W celu użycia klasy trwale przechowującej tożsamość innej niż ``Zend_Auth_Storage_Session``, programista
implementuje interfejs ``Zend_Auth_Storage_Interface``:

.. code-block:: php
   :linenos:

   class MyStorage implements Zend_Auth_Storage_Interface
   {
       /**
        * Zwraca wartość logiczną true tylko wtedy gdy pojemnik jest pusty
        *
        * @throws Zend_Auth_Storage_Exception Jeśli okreslenie czy pojemnik
        *                                     jest pusty jest niemożliwe
        * @return boolean
        */
       public function isEmpty()
       {
           /**
            * @todo implementacja
            */
       }

       /**
        * Zwraca zawartość pojemnika
        *
        * Zachowanie jest nieokreślone w przypadku gdy pojemnik jest pusty.
        *
        * @throws Zend_Auth_Storage_Exception Jeśli odczyt zawartości
        *                                     pojemnika jest niemożliwy
        * @return mixed
        */
       public function read()
       {
           /**
            * @todo implementacja
            */
       }

       /**
        * Zapisuje zawartość $contents w pojemniku
        *
        * @param  mixed $contents
        * @throws Zend_Auth_Storage_Exception Jeśli zapisanie zawartości $contents
        *                                     do pojemnika jest niemożliwe
        * @return void
        */
       public function write($contents)
       {
           /**
            * @todo implementacja
            */
       }

       /**
        * Czyści zawartość pojemnika
        *
        * @throws Zend_Auth_Storage_Exception Jeśli wyczyszczenie zawartości
        *                                     pojemnika jest niemożliwe
        * @return void
        */
       public function clear()
       {
           /**
            * @todo implementacja
            */
       }

   }

W celu użycia własnej klasy pojemnika, wywołaj metodę ``Zend_Auth::setStorage()`` przed przeprowadzeniem
zapytania uwierzytelniającego:

.. code-block:: php
   :linenos:

   <?php
   // Instruujemy klasę Zend_Auth aby użyła niestandardowej klasy pojemnika
   Zend_Auth::getInstance()->setStorage(new MyStorage());

   /**
    * @todo Ustawić adapter uwierzytelniania, $authAdapter
    */

   // Uwierzytelniamy, zapisując wynik i przechowując tożsamość po udanym uwierzytelnieniu
   $result = Zend_Auth::getInstance()->authenticate($authAdapter);

.. _zend.authentication.introduction.using:

Użycie
------

Są dwa możliwe sposoby użycia adapterów ``Zend_Auth``:

. pośrednio, za pomocą metody ``Zend_Auth::authenticate()``

. bezpośrednio, za pomocą metody ``authenticate()`` adaptera

Poniższy przykład pokazuje jak użyć adaptera ``Zend_Auth`` pośrednio, poprzez użycie klasy ``Zend_Auth``:

.. code-block:: php
   :linenos:

   // Pobieramy instancję Zend_Auth
   $auth = Zend_Auth::getInstance();

   // Ustawiamy adapter uwierzytelniania
   $authAdapter = new MyAuthAdapter($username, $password);

   // Przeprowadzamy uwierzytelnianie, zapisując rezultat
   $result = $auth->authenticate($authAdapter);

   if (!$result->isValid()) {
       // Uwierzytelnianie nieudane; wyświetlamy powody
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Uwierzytelnianie udane; tożsamość ($username) jest zapisana w sesji
       // $result->getIdentity() === $auth->getIdentity()
       // $result->getIdentity() === $username
   }
Jeśli uwierzytelnianie zostało przeprowadzone w żądaniu tak jak w powyższym przykładzie, prostą sprawą jest
sprawdzenie czy istnieje pomyślnie uwierzytelniona tożsamość:

.. code-block:: php
   :linenos:

   $auth = Zend_Auth::getInstance();
   if ($auth->hasIdentity()) {
       // Tożsamość istnieje; pobieramy ją
       $identity = $auth->getIdentity();
   }

Aby usunąć tożsamość z trwałego pojemnika, użyj po prostu metody ``clearIdentity()``. Typowo może być to
użyte do implementacji w aplikacji operacji wylogowania:

.. code-block:: php
   :linenos:

   Zend_Auth::getInstance()->clearIdentity();

Gdy automatyczne użycie trwałego pojemnika jest nieodpowiednie w konkretnym przypadku, programista może w prostu
sposób ominąć użycie klasy ``Zend_Auth``, używając bezpośrednio klasy adaptera. Bezpośrednie użycie klasy
adaptera powoduje skonfigurowanie i przygotowanie obiektu adaptera, a następnie wywołanie metody
``authenticate()``. Szczegóły specyficzne dla adaptera są opisane w dokumentacji dla każdego z adapterów.
Poniższy przykład bezpośrednio używa **MyAuthAdapter**:

.. code-block:: php
   :linenos:

   // Ustawiamy adapter uwierzytelniania
   $authAdapter = new MyAuthAdapter($username, $password);

   // Przeprowadzamy uwierzytelnianie, zapisując rezultat
   $result = $authAdapter->authenticate();

   if (!$result->isValid()) {
       // Uwierzytelnianie nieudane; wyświetlamy powody
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Uwierzytelnianie udane
       // $result->getIdentity() === $username
   }


