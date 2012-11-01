.. EN-Revision: none
.. _zend.authentication.adapter.dbtable:

Uwierzytelnianie w oparciu o tabelę bazy danych
===============================================

.. _zend.authentication.adapter.dbtable.introduction:

Wprowadzenie
------------

``Zend\Auth_Adapter\DbTable`` zapewnia możliwość przeprowadzenia uwierzytelniania w oparciu o dane przechowywane
w tabeli bazy danych. Z tego względu, że klasa ``Zend\Auth_Adapter\DbTable`` wymaga przekazania instancji klasy
``Zend\Db_Adapter\Abstract`` do jej konstruktora, każda ta instancja jest powiązana z konkretnym połączeniem do
bazy danych. Inne opcje konfiguracyjne mogą być ustawione za pomocą konstruktora lub za pomocą metod instancji,
po jednej dla każdej z opcji.

Dostępne opcje konfiguracyjne to:

- **tableName**: Jest to nazwa tabeli bazy danych, która zawiera dane uwierzytelniania i do której jest
  przeprowadzane zapytanie uwierzytelniające.

- **identityColumn**: Jest to nazwa kolumny tabeli bazy danych, która reprezentuje tożsamość. Kolumna
  tożsamości musi zawierać unikalne wartości, na przykład takie jak nazwa użytkownika czy adres e-mail.

- **credentialColumn**: Jest to nazwa kolumny tabeli bazy danych, która reprezentuje wartość
  uwierzytelniającą. W prostym schemacie uwierzytelniania opartym o nazwę tożsamości i hasło, wartość
  uwierzytelniająca odpowiada hasłu. Zobacz także opcję **credentialTreatment**.

- **credentialTreatment**: W wielu przypadkach, hasło i inne wrażliwe dane są zszyfrowane, haszowane, zakodowane
  lub w inny sposób przetworzone przez jakąś funkcję lub algorytm. Określając metodę przerobienia danych,
  taką jak na przykład 'MD5(?)' czy 'PASSWORD(?)', programista może użyć konkretnej funkcji SQL na danych
  uwierzytelniających. Z tego względu, że te funkcje są specyficzne dla konkretnych systemów baz danych,
  zajrzyj do odpowiednich dokumentacji aby sprawdzić dostępność takich funkcji dla twojego systemu bazy danych.

.. _zend.authentication.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: Podstawowe użycie

Jak wyjaśniono we wprowadzeniu, konstruktor klasy ``Zend\Auth_Adapter\DbTable`` wymaga przekazania mu instancji
klasy ``Zend\Db_Adapter\Abstract``, zapewniającej połączenie do bazy danych, z którym powiązana jest instancja
adaptera uwierzytelniania. Na początku powinno być utworzone połączenie do bazy danych.

Poniższy kod tworzy adapter bazy danych przechowywanej w pamięci, tworzy prostą strukturę tabeli, a następnie
wstawia wiersz, w oparciu o który przeprowadzimy później zapytanie uwierzytelniające. Ten przykład wymaga
dostępnego rozszerzenia PDO SQLite:

.. code-block:: php
   :linenos:

   // Tworzymy połączenie do bazy danych SQLite przechowywanej w pamięci
   $dbAdapter = new Zend\Db\Adapter\Pdo\Sqlite(array('dbname' =>
                                                     ':memory:'));

   // Budujemy zapytanie tworzące prostą tabelę
   $sqlCreate = 'CREATE TABLE [users] ('
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // Tworzymy tabelę z danymi uwierzytelniania
   $dbAdapter->query($sqlCreate);

   // Budujemy zapytanie wstawiające wiersz, dla którego możemy przeprowadzić
   // próbę uwierzytelniania
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // Wstawiamy dane
   $dbAdapter->query($sqlInsert);

Gdy połączenie do bazy danych oraz dane w tabeli są już dostępne, możesz utworzyć instancję klasy
``Zend\Auth_Adapter\DbTable``. Opcje konfiguracyjne mogą być przekazane do konstruktora lub przekazane jako
parametry do metod dostępowych już po utworzeniu instancji:

.. code-block:: php
   :linenos:

   // Konfigurujemy instancję za pomocą parametrów konstruktora
   $authAdapter = new Zend\Auth_Adapter\DbTable(
       $dbAdapter,
       'users',
       'username',
       'password'
   );

   // ...lub konfigurujemy instancję za pomocą metod dostępowych
   $authAdapter = new Zend\Auth_Adapter\DbTable($dbAdapter);
   $authAdapter
       ->setTableName('users')
       ->setIdentityColumn('username')
       ->setCredentialColumn('password')
   ;

W tym momencie intancja adaptera uwierzytelniania jest gotowa do przeprowadzenia zapytań uwierzytelniających. W
celu utworzenia zapytania, wejściowe dane uwierzytelniania są przekazywane do adaptera przed wywołaniem metody
``authenticate()``:

.. code-block:: php
   :linenos:

   // Ustawiamy wartości danych uwierzytelniania (np., z formularza logowania)
   $authAdapter
       ->setIdentity('my_username')
       ->setCredential('my_password');

   // Przeprowadzamy zapytanie uwierzytelniające, zapisując rezultat
   $result = $authAdapter->authenticate();

Oprócz możliwości użycia metody ``getIdentity()`` obiektu rezultatu uwierzytelniania, obiekt
``Zend\Auth_Adapter\DbTable`` pozwala także na odebranie wiersza tabeli po udanym uwierzytelnieniu.

.. code-block:: php
   :linenos:

   // Wyświetlamy tożsamość
   echo $result->getIdentity() . "\n\n";

   // Wyświetlamy wiersz rezultatów
   print_r($authAdapter->getResultRowObject());

   /* Wyświetlone dane:
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )
   */

Z tego względu, że wiersz tabeli zawiera dane potrzebne do uwierzytelniania, ważne jest, aby dane były
zabezpieczone przed dostępem przez osoby nieuprawnione.

.. _zend.authentication.adapter.dbtable.advanced.storing_result_row:

Zaawansowane użycie: Stałe przechowywanie obiektu DbTable Result
----------------------------------------------------------------

Domyślnie ``Zend\Auth_Adapter\DbTable`` po udanym uwierzytelnieniu zwraca do obiektu uwierzytelniającego
spowrotem tę samą tożsamość. W innym przykładzie użycia programista może chcieć przechować w stałym
mechanizmie przechowywania ``Zend_Auth`` obiekt tożsamości zawierający inne użyteczne informacje. W takim
przypadku może użyć metody ``getResultRowObject()`` aby zwrócić obiekt klasy ``stdClass``. Poniższy kod
ilustruje sposób jego użycia:

.. code-block:: php
   :linenos:

   // uwierzytelniamy za pomocą Zend\Auth_Adapter\DbTable
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {

       // przechowujemy tożsamość jako obiekt, w którym zwracane są jedynie
       // pola username oraz real_name
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array(
           'username',
           'real_name'
       )));

       // przechowujemy tożsamość jako obiekt, w którym kolumna zawierająca
       // hasło została pominięta
       $storage->write($adapter->getResultRowObject(
           null,
           'password'
       ));

       /* ... */

   } else {

       /* ... */

   }

.. _zend.authentication.adapter.dbtable.advanced.advanced_usage:

Przykład zaawansowanego użycia
------------------------------

O ile głównym przeznaczeniem komponentu ``Zend_Auth`` (i odpowiednio ``Zend\Auth_Adapter\DbTable``) jest
**uwierzytelnianie** a nie **autoryzacja**, jest kilka problemów które możemy rozwiązać odrobinę
przekraczając pole zastosowań komponentu. Zależnie od tego jak zdecydujesz wyjaśnić swój problem, czasem
może być przydatne rozwiązanie problemu autoryzacji podczas uwierzytelniania.

Komponent ``Zend\Auth_Adapter\DbTable`` posiada pewien wbudowany mechanizm, który może być użyty do dodania
dodatkowych warunków podczas uwierzytelniania, dzięki czemu można rozwiązać niektóre problemy.

.. code-block:: php
   :linenos:

   // Wartość pola "status" dla tego konta nie jest równa wartości "compromised"
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND status != "compromised"'
   );

   // Wartość pola "active" dla tego konta jest równa wartości "TRUE"
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND active = "TRUE"'
   );

Innym przykładem może być implementacja mechanizmu saltingu. Jest to technika pozwalająca w znaczny sposób
zwiększyć bezpieczeństwo aplikacji. Polega ona na tym, że dołączając do każdego hasła losowy łańcuch
znaków spowodujemy, że niemożliwe będzie przeprowadzenie ataku brute force na bazę danych w oparciu o
przygotowany słownik.

Zaczniemy od zmodyfikowania schematu tabeli bazy danych, aby móc przechowywać nasz łańcuch znaków salt:

.. code-block:: php
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

   $dbAdapter->query($sqlAlter);

W prosty sposób wygenerujmy salt dla każdego rejestrującego się użytkownika:

.. code-block:: php
   :linenos:

   for ($i = 0; $i < 50; $i++)
   {
       $dynamicSalt .= chr(rand(33, 126));
   }

I skonfigurujmy sterownik bazy danych:

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       "MD5(CONCAT('"
       . Zend\Registry\Registry::get('staticSalt')
       . "', ?, password_salt))"
   );

.. note::

   Możesz jeszcze zwiększyć bezpieczeństwo używając dodatkowo statycznego fragmentu łańcucha znaków
   umieszczonego na stałe w kodzie aplikacji. W przypadku, gdy atakujący uzyska dostęp do bazy danych (np. za
   pomocą ataku *SQL* injection), a nie będzie miał dostępu do kodu źródłowego, hasła wciąż będą dla
   niego nieprzydatne.

Innym sposobem jest użycie metody ``getDbSelect()`` klasy ``Zend\Auth_Adapter\DbTable`` po utworzeniu adaptera. Ta
metoda zwróci obiekt klasy ``Zend\Db\Select``, który ma być użyty do przeprowadzenia uwierzytalniania. Ważne
jest, że ta metoda zawsze zwróci ten sam obiekt, niezależnie od tego czy metoda ``authenticate()`` została
wywołana czy nie. Ten obiekt **nie będzie** posiadał żadnych informacji dotyczących nazwy tożsamości i
hasła, ponieważ te dane będą umieszczone tam dopiero w czasie wywołania metody ``authenticate()``.

Przykładem sytuacji w której można by użyć metody getDbSelect() może być potrzeba sprawdzenia statusu
użytkownika, czyli sprawdzenia czy konto użytkownika jest aktywne.

.. code-block:: php
   :linenos:

   // Kontynuując poprzedni przykład
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?)'
   );

   // pobieramy obiekt Zend\Db\Select (przez referencję)
   $select = $adapter->getDbSelect();
   $select->where('active = "TRUE"');

   // uwierytelniamy, z warunkiem users.active = TRUE
   $adapter->authenticate();


