.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

Wprowadzenie
------------

Obiekt ``Zend_Db_Select`` reprezentuje pojedyncze polecenie *SQL* *SELECT*. Klasa posiada metody służące do
umieszczenia poszczególnych części zapytania. Za jej pomocą można zapisać elementy zapytania poprzez metody i
struktur danych *PHP* a klasa sama tworzy poprawne polecenie *SQL*. Po zbudowaniu zapytania można go użyć tak
jakby było napisane w postaci zwykłego łańcucha znaków.

Wartość ``Zend_Db_Select`` zawiera się w poniższych cechach:

- Metody obiektowe służące tworzeniu zapytań *SQL* krok po kroku;

- Poziom abstrakcji umożliwiający używanie określonych części zapytania *SQL* są w sposób niezależny od
  rodzaju bazy danych;

- Automatyczne umieszczanie identyfikatorów metadanych w cudzysłowach ułatwia używanie identyfikatorów
  zawierających zarezerwowane słowa i specjalne znaki *SQL*;

- Umieszczanie identyfikatorów i wartości w cudzysłowach pomaga ograniczyć ryzyko ataków wstrzykiwania kodu
  *SQL* (*SQL* injection);

Używanie ``Zend_Db_Select`` nie jest obowiązkowe. Dla najprostszych zapytań *SELECT* z reguły łatwiej jest
zapisać całe polecenie *SQL* w postaci łańcucha znaków i wywołać je za pomocą metod Adaptera takich jak
``query()`` lub ``fetchAll()``. Użycie ``Zend_Db_Select`` jest przydatne jeśli zajdzie potrzeba połączenia
części złożonego zapytania w kodzie np. w zależności od wystąpienia dodatkowych warunków logicznych.

.. _zend.db.select.creating:

Tworzenie obiektu Select
------------------------

Instancję klasy ``Zend_Db_Select`` można utworzyć poprzez metodę ``select()`` obiektu
``Zend_Db_Adapter_Abstract``.

.. _zend.db.select.creating.example-db:

.. rubric:: Przykład metody select() adaptera bazy danych

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = $db->select();

Innym sposobem utworzenia obiektu ``Zend_Db_Select`` jest użycie konstruktora, podając adapter bazy danych w
argumencie.

.. _zend.db.select.creating.example-new:

.. rubric:: Przykład tworzenia nowego obiektu Select

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = new Zend_Db_Select($db);

.. _zend.db.select.building:

Tworzenie poleceń Select
------------------------

Budując zapytanie można dodawać jego części jedna po drugiej. Obiekt ``Zend_Db_Select`` posiada odrębne
metody dla każdej klauzuli *SQL*.

.. _zend.db.select.building.example:

.. rubric:: Przykład użycia metod służących dodawaniu części zapytania

.. code-block:: php
   :linenos:

   // Utworzenie obiektu Zend_Db_Select
   $select = $db->select();

   // Dodanie klauzuli FROM
   $select->from( ...podanie tabel i kolumn... )

   // Dodanie klauzuli WHERE
   $select->where( ...podanie kryteriów ograniczenia... )

   // Dodanie klauzuli ORDER BY
   $select->order( ...podanie kryteriów sortowania... );

Większości metod obiektu ``Zend_Db_Select`` można używać za pomocą przyjaznego płynnego interfejsu (fluent
interface). Interfejs płynny oznacza, że każda z metod zwraca referencję do obiektu wywołującego więc można
od razu użyć następnej metody.

.. _zend.db.select.building.example-fluent:

.. rubric:: Przykład użycia płynnego interfejsu

.. code-block:: php
   :linenos:

   $select = $db->select()
       ->from( ...podanie tabel i kolumn... )
       ->where( ...podanie kryteriów ograniczenia... )
       ->order( ...podanie kryteriów sortowania... );

Przykłady w tym rozdziale używają płynnego interfejsu ale zawsze można z niego zrezygnować. Często może
się to okazać niezbędne w przypadku gdy należy wykonać operacje zgodne z logiką biznesową aplikacji przed
umieszczeniem dodatkowej klauzuli w zapytaniu.

.. _zend.db.select.building.from:

Dodawanie klauzuli FROM
^^^^^^^^^^^^^^^^^^^^^^^

Można wybrać tabelę dla zapytania używając metody ``from()``. Aby tego dokonać należy podać nazwę tabeli
jako łańcuch znaków. ``Zend_Db_Select`` umieszcza cudzysłowy wokół podanej nazwy, więc można używać
znaków specjalnych.

.. _zend.db.select.building.from.example:

.. rubric:: Przykład użycia metody from()

.. code-block:: php
   :linenos:

   // Utworzenie zapytania:
   //   SELECT *
   //   FROM "products"

   $select = $db->select()
                ->from( 'products' );

Można podać również nazwę korelacyjną (nazywaną również aliasem tabeli) danej tabeli. Aby to zrobić w
argumencie należy podać tablicę asocjacyjną, która będzie zawierała mapowanie nazwy aliasu na nazwę tabeli.
W pozostałych częściach zapytania *SQL* będzie można używać tej nazwy zamiast tabeli. Jeśli dane zapytanie
łączy wiele tabel ``Zend_Db_Select`` utworzy unikalne aliasy na podstawie prawdziwych nazw dla każdej tabeli dla
której nie zrobi tego użytkownik.

.. _zend.db.select.building.from.example-cname:

.. rubric:: Przykład użycia aliasu

.. code-block:: php
   :linenos:

   // Utworzenie zapytania:
   //   SELECT p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->from( array('p' => 'products') );

Niektóre silniki bazy danych (*RDBMS*) wspierają podawanie nazw schematu przed nazwą tabeli. W takim przypadku
należy podać nazwę tabeli jako "``nazwaSchematu.nazwaTabeli``" a ``Zend_Db_Select`` umieści w cudzysłowach
każdą z części takiej nazwy indywidualnie. Można też podać nazwę schematu oddzielnie. Nazwa schematu podana
przy nazwie tabeli ma pierwszeństwo wobec nazwy schematu podanej osobno (jeśli obie występują).

.. _zend.db.select.building.from.example-schema:

.. rubric:: Przykład podawania nazwy schematu

.. code-block:: php
   :linenos:

   // Utworzenie zapytania:
   //   SELECT *
   //   FROM "myschema"."products"

   $select = $db->select()
                ->from( 'myschema.products' );

   // lub

   $select = $db->select()
                ->from('products', '*', 'myschema');

.. _zend.db.select.building.columns:

Dodawanie kolumn
^^^^^^^^^^^^^^^^

Drugi argument metody ``from()`` może zawierać kolumny, które mają zostać pobrane z odpowiedniej tabeli.
Jeśli nie poda się tego argumentu domyślną wartością jest "*****" czyli znak specjalny *SQL* odpowiadający
wszystkim kolumnom.

Kolumny można podawać w prostej tablicy łańcuchów tekstowych lub jako asocjacyjnej tablicy aliasów kolumn do
nazw kolumn. Jeśli potrzebna jest tylko jedna kolumna to można ją podać w prostym stringu - nie trzeba używać
tablicy.

Jeśli w tym argumencie zostanie podana pusta tablica to żadna kolumna z odpowiedniej tabeli nie zostanie
dołączona do wyniku zapytania. Zobacz :ref:`przykład kodu <zend.db.select.building.join.example-no-columns>`
znajdujący się pod rozdziałem dotyczącym metody ``join()``.

Nazwę kolumny można podać w formie "``nazwaAliasu.nazwaKolumny``". ``Zend_Db_Select`` umieści każdą z
części nazwy oddzielnie w cudzysłowach, używając aliasu wcześniej ustalonego w metodzie ``from()`` (jeśli
nie został podany bezpośrednio).

.. _zend.db.select.building.columns.example:

.. rubric:: Przykład dodawania kolumn

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'));

   // Tworzenie podobnego zapytania z użyciem aliasów tabeli:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('p.product_id', 'p.product_name'));

   // Tworzenie podobnego zapytania z aliasem dla jednej kolumny:
   //   SELECT p."product_id" AS prodno, p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('prodno' => 'product_id', 'product_name'));

.. _zend.db.select.building.columns-expr:

Dodawanie kolumn z wyrażeniami
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

W zapytaniach *SQL* często zachodzi potrzeba użycia wyrażeń zamiast zwykłych kolumn tabeli. Wyrażenia nie
powinny być otoczone cudzysłowami ani zawierać aliasów tabel. Jeśli podana kolumna zawiera nawiasy
``Zend_Db_Select`` rozpoznaje ją jako wyrażenie.

Można również samemu utworzyć obiekt klasy ``Zend_Db_Expr`` aby łańcuch znaków nie został potraktowany jak
zwykła nazwa kolumny. ``Zend_Db_Expr`` jest małą klasą zawierającą jeden string. ``Zend_Db_Select``
rozpoznaje instancje klasy ``Zend_Db_Expr`` i zamienia je na łańcuchy znaków ale nie wprowadza zmian takich jak
cudzysłowy czy aliasy tabel.

.. note::

   Używanie ``Zend_Db_Expr`` dla wyrażeń nie jest obowiązkowe jeśli zawiera ono nawiasy. ``Zend_Db_Select``
   rozpoznaje nawiasy i traktuje dany łańcuch jak wyrażenie (nie umieszcza w cudzysłowach ani nie dodanie nazw
   alias tabel).

.. _zend.db.select.building.columns-expr.example:

.. rubric:: Przykłady podawania kolumn zawierających wyrażenia

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", LOWER(product_name)
   //   FROM "products" AS p
   // Wyrażenie z nawiasami staje się obiektem klasy Zend_Db_Expr.

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'LOWER(product_name)'));

   // Tworzenie zapytania:
   //   SELECT p."product_id", (p.cost * 1.08) AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' => '(p.cost * 1.08)')
                      );

   // Tworzenie zapytania używając Zend_Db_Expr:
   //   SELECT p."product_id", p.cost * 1.08 AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' =>
                                 new Zend_Db_Expr('p.cost * 1.08'))
                       );

W powyższych przykładach ``Zend_Db_Select`` nie zmienia stringa i nie dodaje aliasów tabel ani nie używa
cudzysłowów. Jeśli takie zmiany są niezbędne (np. z powodu dwuznaczności nazw) należy je wprowadzić
ręcznie.

Jeśli podane nazwy kolumn zawierają słowa kluczowe *SQL* lub znaki specjalne należy użyć metody adaptera
połączenia o nazwie ``quoteIdentifier()`` i rezultat umieścić w stringu. Metoda ``quoteIdentifier()`` używa
cudzysłowów dzięki czemu można być pewnym, że podany łańcuch znaków jest identyfikatorem tabeli lub
kolumny a nie częścią składni polecenia *SQL*.

Dzięki użyciu metody ``quoteIdentifier()`` zamiast ręcznego wpisywania cudzysłowów kod staje się niezależny
od rodzaju bazy danych. Niektóre systemy zarządzania bazą danych (*RDBMS*) używają niestandardowych znaków do
ograniczania identyfikatorów. Metoda ``quoteIdentifier()`` jest przystosowana do używania odpowiednich symboli
ograniczających w zależności od typu używanego adaptera. Metoda ``quoteIdentifier()`` dokonuje również
unikania znaków cudzysłowu, które pojawią się w argumencie wejściowym.

.. _zend.db.select.building.columns-quoteid.example:

.. rubric:: Przykłady umieszczania wyrażeń w cudzysłowach

.. code-block:: php
   :linenos:

   // Tworzenie zapytania,
   // umieszczając kolumnę o nazwie "from" w cudzysłowach:
   //   SELECT p."from" + 10 AS origin
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('origin' =>
                                 '(p.' . $db->quoteIdentifier('from') . ' + 10)')
                      );

.. _zend.db.select.building.columns-atomic:

Dodawanie kolumn do wcześniej utworzonej klauzuli FROM lub JOIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Może powstać sytuacja w której niezbędne okazuje się dodanie kolumn do klauzuli *FROM* lub *JOIN*, która
została utworzona wcześniej (za pomocą odpowiedniej metody). Metoda ``columns()`` pozwala na dodanie kolumn w
dowolnym momencie przed wykonaniem zapytania. Kolumny można podać jako łańcuchy znaków, obiekty
``Zend_Db_Expr`` lub jako tablice tych elementów. Drugi argument tej metody może zostać pominięty co oznacza,
że kolumny powinny zostać dodane do tabeli z klauzuli *FROM*. W przeciwnym razie należy podać alias lub nazwę
tabeli.

.. _zend.db.select.building.columns-atomic.example:

.. rubric:: Przykłady dodawania kolumn metodą columns()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'product_id')
                ->columns('product_name');

   // Tworzenie zapytania używając nazwy alias:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'p.product_id')
                ->columns('product_name', 'p');
                // Alternatywnie można użyć columns('p.product_name')

.. _zend.db.select.building.join:

Dodawanie tabeli do zapytania za pomocą JOIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wiele użytecznych zapytań zawiera klauzulę *JOIN* służącą do łączenia wierszy z wielu tabel. Aby dodać
tabele do obiektu ``Zend_Db_Select`` należy użyć metody ``join()``. Używanie jej jest podobne do użycia metody
``from()`` z tym, że tu można również użyć warunek łączenia tabel.

.. _zend.db.select.building.join.example:

.. rubric:: Przykład użycia metody join()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name", l.*
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id');

Drugi argument metody ``join()`` to string stanowiący warunek połączenia. Jest to wyrażenie określające
kryteria wg. których wiersze z jednej tabeli łączą się z wierszami drugiej tabeli. W tym miejscu można użyć
aliasów tabel.

.. note::

   Do warunku połączenia nie są stosowane cudzysłowy; Jeśli występuje konieczność umieszczenia nazwy
   kolumny w cudzysłowach, należy użyć metody adaptera ``quoteIdentifier()`` przy formowaniu wyrażenia warunku
   połączenia.

Trzeci argument metody ``join()`` to tablica nazw kolumn (tak jak przy metodzie ``from()``). Domyślną wartością
jest "*****". Można w nim podawać aliasy kolumn, wyrażenia lub obiekty ``Zend_Db_Expr`` w taki sam sposób jak w
metodzie ``from()``.

Aby nie wybierać żadnej kolumny należy podać pustą tablicę zamiast nazw kolumn. Ten sposób działa również
w metodzie ``from()`` ale z podstawowych tabel przeważnie kolumny są potrzebne, co nie zawsze jest prawdą dla
kolumn tabeli połączonej.

.. _zend.db.select.building.join.example-no-columns:

.. rubric:: Przykład nie podawania kolumn

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array() ); // pusta lista kolumn

W miejscu listy kolumn tabeli połączonej występuje pusta tablica (``array()``).

*SQL* dysponuje wieloma rodzajami klauzul JOIN. Poniżej znajduje się lista metod klasy ``Zend_Db_Select``
obsługująca je.

- ``INNER JOIN`` za pomocą ``join(tabela, warunek, [kolumny])`` lub ``joinInner(tabela, warunek, [kolumny])``

  To jest najbardziej popularny rodzaj połączenia JOIN. Wiersze z każdej tabeli są porównywane za pomocą
  podanego warunku. Zbiór wyjściowy zawiera jedynie wiersze, które spełniają warunek połączenia. Jeśli
  żadna para wierszy nie spełnia warunku to zbiór pozostanie pusty.

  Wszystkie systemy zarządzania bazą danych (*RDBMS*) posiadają implementację tego rodzaju polecenia JOIN.

- ``LEFT JOIN`` za pomocą metody ``joinLeft(tabela, warunek, [kolumny])``.

  Wszystkie wiersze z tabeli znajdującej się po lewej stronie "wchodzą" do wyniku. Te, które nie mają
  odpowiadającego wiersza w tabeli znajdującej się po stronie prawej - zostają wypełnione wartościami
  ``NULL`` (w kolumnach z prawej tabeli).

  Wszystkie systemy zarządzania bazą danych (*RDBMS*) posiadają implementację tego rodzaju polecenia JOIN.

- ``RIGHT JOIN`` za pomocą metody ``joinRight(tabela, warunek, [kolumny])``

  RIGHT JOIN to przeciwieństwo LEFT JOIN. Wszystkie wiersze z tabeli znajdującej się po prawej stronie są
  umieszczone w wyniku. Te, które nie posiadają odpowiednika w tabeli lewej otrzymują wartości ``NULL`` w
  kolumnach z lewej tabeli.

  Niektóre systemy zarządzania bazą danych (*RDBMS*) nie wspierają tego typu polecenia JOIN ale generalnie
  każdy ``RIGHT JOIN`` może zostać zaprezentowany jako ``LEFT JOIN`` poprzez odwrócenie kolejności dodawania
  tabel.

- ``FULL JOIN`` za pomocą metody ``joinFull(tabela, warunek, [kolumny])``

  To polecenie jest jak połączenie ``LEFT JOIN`` oraz ``RIGHT JOIN``. Wszystkie wiersze z obu tabel są
  włączane do wyniku. Jeśli dany wiersz nie posiada odpowiednika spełniającego warunek połączenia w drugiej
  tabeli to w kolumnach z tej tabeli umieszczony jest ``NULL``.

  Niektóre systemy zarządzania bazą danych (*RDBMS*) nie wspierają tego typu polecenia JOIN.

- ``CROSS JOIN`` za pomocą metody ``joinCross(tabela, [kolumny])``.

  Cross join to iloczyn kartezjański tabel. Każdy wiersz z pierwszej tabeli zostaje połączony z każdym
  wierszem z tabeli drugiej. Ilość wierszy w zbiorze wynikowym jest równa iloczynowi ilości wierszy w obu
  tabelach. Poprzez użycie warunku *WHERE* można ograniczyć wiersze wynikowe przez co cross join może być
  podobny do składni polecenia join ze standardu *SQL*-89.

  Metoda ``joinCross()`` nie ma parametru odnoszącego się do warunku połączenia. Niektóre systemy zarządzania
  bazą danych (*RDBMS*) nie wspierają tego typu polecenia *JOIN*.

- ``NATURAL JOIN`` za pomocą metody ``joinNatural(tabela, [kolumny])``.

  Polecenie natural join łączy wiersze pod względem wszystkich kolumn, które mają taką samą nazwę w obydwu
  tabelach. Warunkiem połączenia jest zgodność wartości wszystkich tak samo nazwanych kolumn tabel.
  Porównywanie wartości na zasadzie niezgodności (różnicy) nie stanowi polecenia natural join. Jedynie
  polecenia typu natural inner join są zaimplementowane w tym API pomimo tego że standard *SQL* definiuje też
  polecenia natural outer join.

  Metoda ``joinCross()`` nie ma parametru odnoszącego się do warunku połączenia.

Oprócz powyższych metod można uprościć zapytania używając metod JoinUsing. Zamiast podawania pełnego
warunku można wybrać nazwę kolumny, na podstawie której połączenie będzie przeprowadzone a obiekt
``Zend_Db_Select`` dopisze niezbędną część polecenia warunku.

.. _zend.db.select.building.joinusing.example:

.. rubric:: Przykład użycia metody joinUsing()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT *
   //   FROM "table1"
   //   JOIN "table2"
   //   ON "table1".column1 = "table2".column1
   //   WHERE column2 = 'foo'

   $select = $db->select()
                ->from('table1')
                ->joinUsing('table2', 'column1')
                ->where('column2 = ?', 'foo');

Każda z metod połączenia klasy ``Zend_Db_Select`` ma odpowiednią metodę 'using'.

- ``joinUsing(tabela, [kolumny])`` and ``joinInnerUsing(tabela, [kolumny])``

- ``joinLeftUsing(tabela, [kolumny])``

- ``joinRightUsing(tabela, [kolumny])``

- ``joinFullUsing(tabela, [kolumny])``

.. _zend.db.select.building.where:

Dodawanie klauzuli WHERE
^^^^^^^^^^^^^^^^^^^^^^^^

Za pomocą metody ``where()`` można określić kryteria ograniczające ilość wierszy zwracanych przez zapytanie.
Pierwszy argument tej metody to wyrażenie *SQL* które zostanie użyte w klauzuli WHERE zapytania *SQL*.

.. _zend.db.select.building.where.example:

.. rubric:: Przykład użycia metody where()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE price > 100.00

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > 100.00');

.. note::

   Wyrażenia w metodach ``where()`` lub ``orWhere()`` nie zostają umieszczone w cudzysłowach. Jeśli nazwa
   kolumny tego wymaga należy użyć metody ``quoteIdentifier()`` podczas tworzenia parametru warunku.

Drugi argument metody ``where()`` jest opcjonalny. Stanowi on wartość umieszczaną w warunku. ``Zend_Db_Select``
ogranicza tą wartość cudzysłowami i za jej pomocą podmienia symbol znaku zapytania ("**?**") w warunku.

.. _zend.db.select.building.where.example-param:

.. rubric:: Przykład użycia parametru w metodzie where()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)

   $minimumPrice = 100;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice);

Drugi parametr metody ``where()`` przyjmuje również tablicę w przypadku gdy używa się operatora IN.

.. _zend.db.select.building.where.example-array:

.. rubric:: Przykład użycia tablicy w metodzie where()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (product_id IN (1, 2, 3))

   $productIds = array(1, 2, 3);

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('product_id IN (?)', $productIds);

Metoda ``where()`` może być wywoływana wiele razy dla jednego obiektu ``Zend_Db_Select``. Zapytanie wynikowe
łączy wszystkie warunki używając wyrażenia *AND*.

.. _zend.db.select.building.where.example-and:

.. rubric:: Przykład wywołania metody where() wiele razy

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)
   //     AND (price < 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice)
                ->where('price < ?', $maximumPrice);

Jeśli istnieje potrzeba połączenia warunków za pomocą wyrażenia *OR* należy użyć metody ``orWhere()``.
Można jej używać w taki sam sposób jak metody ``where()``. W wynikowym poleceniu warunki zostaną połączone
wyrażeniem *OR* zamiast *AND*.

.. _zend.db.select.building.where.example-or:

.. rubric:: Przykład użycia metody orWhere()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00)
   //     OR (price > 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price < ?', $minimumPrice)
                ->orWhere('price > ?', $maximumPrice);

``Zend_Db_Select`` automatycznie umieszcza wyrażenia podane do metod ``where()`` lub ``orWhere()`` w nawiasach.
Dzięki temu kolejność wykonywania działań logicznych nie spowoduje nieoczekiwanych rezultatów.

.. _zend.db.select.building.where.example-parens:

.. rubric:: Przykład umieszczania wyrażeń w nawiasach

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00 OR price > 500.00)
   //     AND (product_name = 'Apple')

   $minimumPrice = 100;
   $maximumPrice = 500;
   $prod = 'Apple';

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where("price < $minimumPrice OR price > $maximumPrice")
                ->where('product_name = ?', $prod);

W powyższym przykładzie zapytanie bez nawiasów przyniosłoby inny rezultat ponieważ *AND* ma wyższy priorytet
niż *OR*. Dzięki nawiasom ``Zend_Db_Select`` sprawia, że każde wywołanie metody ``where()`` łączy zawarte w
niej warunki z wyższym priorytetem niż *AND* który łączy poszczególne warunki.

.. _zend.db.select.building.group:

Dodanie klauzuli GROUP BY
^^^^^^^^^^^^^^^^^^^^^^^^^

W *SQL*, klauzula ``GROUP BY`` pozwala na ograniczenie wierszy wyników zapytania do jednego wiersza na każdą
unikalną wartość znalezioną w kolumnie podanej przy klauzuli ``GROUP BY``.

Aby określić kolumny używane do podzielenia wyników na grupy w ``Zend_Db_Select`` należy użyć metody
``group()``. Jako argument podaje się kolumnę lub tablicę kolumn, które mają trafić do klauzuli ``GROUP BY``.

.. _zend.db.select.building.group.example:

.. rubric:: Przykład użycia metody group()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id');

Podobnie jak w przypadku metody ``from()`` w argumencie można używać aliasów tabel a nazwy są umieszczane w
cudzysłowach jako identyfikatory chyba że łańcuch znaków zawiera nawiasy lub jest obiektem ``Zend_Db_Expr``.

.. _zend.db.select.building.having:

Dodanie klauzuli HAVING
^^^^^^^^^^^^^^^^^^^^^^^

W *SQL*, klauzula ``HAVING`` wprowadza ograniczenie w stosunku do grup wierszy. Jest to podobne do sposobu w jaki
klauzula ``WHERE`` ogranicza wiersze ogólnie. Te klauzule są różne ponieważ warunki ``WHERE`` są oceniane
prze definiowaniem grup, podczas gdy warunki ``HAVING`` nakładane są po uformowaniu grup.

W ``Zend_Db_Select`` można określić warunki dotyczące grup wierszy za pomocą metody ``having()``. Użycie jej
jest podobne do metody ``where()``. Pierwszy argument to string zawierający wyrażenie *SQL*. Opcjonalny drugi
argument to wartość używana do zamienienia pozycyjnych parametrów w wyrażeniu *SQL*. Wyrażenia umieszczone w
wielu wywołaniach metody ``having()`` są łączone za pomocą operatora *AND* lub *OR*- jeśli zostanie użyta
metoda ``orHaving()``.

.. _zend.db.select.building.having.example:

.. rubric:: Przykład użycia metody having()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   HAVING line_items_per_product > 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->having('line_items_per_product > 10');

.. note::

   W metodach ``having()`` oraz ``orHaving()`` nie jest stosowane umieszczanie identyfikatorów w cudzysłowach.
   Jeśli nazwa kolumny tego wymaga należy użyć metody ``quoteIdentifier()`` podczas tworzenia parametru
   warunku.

.. _zend.db.select.building.order:

Dodanie klauzuli ORDER BY
^^^^^^^^^^^^^^^^^^^^^^^^^

W *SQL*, klauzula *ORDER BY* określa jedną bądź więcej kolumn lub wyrażeń według których zbiór wynikowy
jest posortowany. Jeśli poda się wiele kolumn to sortowanie odbywa się w pierwszej kolejności na podstawie
wcześniej podanej kolumny. Jeśli istnieją wiersze o takiej samej wartości w danej kolumnie to do sortowania
używana jest kolejna klumna klauzuli *ORDER BY*. Domyślny kierunek sortowania to od najmniejszej wartości do
największej. Można sortować w przeciwnym kierunku przez użycie słowa kluczowego ``DESC`` po nazwie kolumny
sortowania.

W ``Zend_Db_Select`` można użyć metody ``order()`` i podać kolumnę lub tablicę kolumn według których
sortowanie ma przebiegać. Każdy z elementów tablicy powinien być łańcuchem znaków określającym kolumnę.
Opcjonalnie można dodać słowa kluczowe ``ASC`` lub ``DESC`` oddzielone od kolumny spacją.

Podobnie jak przy metodach ``from()`` oraz ``group()`` nazwy kolumn są otaczane cudzysłowami, chyba że
zawierają nawiasy lub są obiektami klasy ``Zend_Db_Expr``.

.. _zend.db.select.building.order.example:

.. rubric:: Przykład użycia metody order()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   ORDER BY "line_items_per_product" DESC, "product_id"

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->order(array('line_items_per_product DESC',
                              'product_id'));

.. _zend.db.select.building.limit:

Dodanie klauzuli LIMIT
^^^^^^^^^^^^^^^^^^^^^^

Niektóre systemy zarządzania bazą danych (*RDBMS*) rozszerzają *SQL* za pomocą klauzuli ``LIMIT``. Za jej
pomocą można ograniczyć ilość wierszy zwracanych w zapytaniu do podanej ilości. Można również określić
ilość wierszy, która ma zostać opuszczona przed rozpoczęciem zwracania wyników zapytania. Dzięki temu można
w łatwy sposób uzyskać podzbiór ze zbioru wynikowego. Może to być przydatne np. przy wyświetlaniu
rezultatów zapytania z podziałem na strony.

W ``Zend_Db_Select`` można użyć metody ``limit()`` aby określić ilość wierszy do zwrócenia oraz do
opuszczenia. **Pierwszy** argument metody to ilość wierszy jaka maksymalnie ma zostać zwrócona. **Drugi**
argument to ilość wierszy do opuszczenia.

.. _zend.db.select.building.limit.example:

.. rubric:: Przykład użycia metody limit()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20
   // Equivalent to:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 20 OFFSET 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limit(20, 10);

.. note::

   Polecenie ``LIMIT`` nie jest wspierane przez wszystkie rodzaje baz danych. Niektóre z nich wymagają innej
   składni dla uzyskania podobnego efektu. Każda z klas ``Zend_Db_Adapter_Abstract`` zawiera metodę tworzącą
   polecenie *SQL* odpowiednie dla danego *RDBMS*.

Można użyć metody ``limitPage()`` jako alternatywy do określania ilości wierszy do zwrotu i do pominięcia. Ta
metoda pozwala na podzielenie zbioru wynikowego na wiele podzbiorów o stałej wielkości i zwrócenie jednego z
nich. Innymi słowy należy określić długość jednej "strony" z wynikami zapytania oraz liczbę porządkową
określającą stronę, która ma zostać zwrócona. Numer strony stanowi pierwszy argument metody ``limitPage()``
a długość strony to drugi argument. Obydwa argumenty są wymagane - nie mają wartości domyślnych.

.. _zend.db.select.building.limit.example2:

.. rubric:: Przykład użycia metody limitPage()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limitPage(2, 10);

.. _zend.db.select.building.distinct:

Dodanie słowa kluczowego DISTINCT do zapytania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``distinct()`` pozwala na dodanie słowa kluczowego ``DISTINCT`` do zapytania *SQL*.

.. _zend.db.select.building.distinct.example:

.. rubric:: Przykład użycia metody distinct()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT DISTINCT p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->distinct()
                ->from(array('p' => 'products'), 'product_name');

.. _zend.db.select.building.for-update:

Dodanie słowa kluczowego FOR UPDATE do zapytania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``forUpdate()`` pozwala na dodanie słowa kluczowego *FOR UPDATE* do zapytania *SQL*.

.. _zend.db.select.building.for-update.example:

.. rubric:: Przykład użycia metody forUpdate()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT FOR UPDATE p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->forUpdate()
                ->from(array('p' => 'products'));

.. _zend.db.select.building.union:

Tworzenie zapytania z UNION
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Z ``Zend_Db_Select`` można łączyć zapytania poprzez przekazanie tablicy obiektów ``Zend_Db_Select`` lub
łańcuchów zapytań *SQL* do metody ``union()``. Jako drugi parametr można podać stałe
``Zend_Db_Select::SQL_UNION`` lub ``Zend_Db_Select::SQL_UNION_ALL`` aby określić rodzaj połączenia jaki chce
się uzyskać.

.. _zend.db.select.building.union.example:

.. rubric:: Przykład użycia metody union()

.. code-block:: php
   :linenos:

   $sql1 = $db->select();
   $sql2 = "SELECT ...";

   $select = $db->select()
       ->union(array($sql1, $sql2))
       ->order("id");

.. _zend.db.select.execute:

Wykonywanie zapytań Select
--------------------------

Poniższa część opisuje jak wywołać zapytanie zawarte w obiekcie ``Zend_Db_Select``.

.. _zend.db.select.execute.query-adapter:

Wykonywanie zapytań Select z poziomu adaptera bazy danych
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zapytanie zawarte w obiekcie ``Zend_Db_Select`` można wywołać poprzez podanie obiektu jako pierwszego argumentu
metody ``query()`` obiektu ``Zend_Db_Adapter_Abstract``. Zalecane jest używanie obiektów ``Zend_Db_Select``
zamiast łańcuchów znaków z zapytaniem.

Metoda ``query()`` w zależności od typu adaptera bazy danych zwraca obiekt klasy ``Zend_Db_Statement`` lub
PDOStatement.

.. _zend.db.select.execute.query-adapter.example:

.. rubric:: Przykład użycia metody query() adaptera bazy danych

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $db->query($select);
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.query-select:

Wykonywanie zapytań Select z samego obiektu
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jako alternatywny sposób w stosunku do użycia metody ``query()`` adaptera bazy danych, można użyć metody o
takiej samej nazwie obiektu ``Zend_Db_Select``. Obydwie metody zwracają obiekt klasy ``Zend_Db_Statement`` lub
PDOStatement w zależności od typu użytego adaptera.

.. _zend.db.select.execute.query-select.example:

.. rubric:: Przykład użycia metody obiektu Zend_Db_Select

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $select->query();
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.tostring:

Zamiana obiektu Select w łańcuch polecenia SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jeśli niezbędny jest dostęp do polecenia *SQL* w postaci łańcucha znaków zawartego w obiekcie
``Zend_Db_Select``, należy użyć metody ``__toString()``.

.. _zend.db.select.execute.tostring.example:

.. rubric:: Przykład użycia metody \__toString()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $sql = $select->__toString();
   echo "$sql\n";

   // Wyjściowy string:
   //   SELECT * FROM "products"

.. _zend.db.select.other:

Inne metody
-----------

Ta część opisuje inne metody klasy ``Zend_Db_Select``, które nie zostały wymienione wcześniej: ``getPart()``
oraz ``reset()``.

.. _zend.db.select.other.get-part:

Uzyskanie części obiektu Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``getPart()`` zwraca postać łańcucha znaków odpowiadającą jednej części polecenia *SQL*. Można
użyć tej metody aby uzyskać tablicę warunków klauzuli ``WHERE``, tablicę kolumn (lub wyrażeń) zawartych w
liście ``SELECT`` albo wartości ilości wierszy klauzuli ``LIMIT``.

Wartością zwracaną nie jest string zawierający składnię *SQL*. Zamiast tego zwracana jest wewnętrzna postać
danych, co przeważnie oznacza tablicę zawierającą wartości i wyrażenia. Każda część zapytania ma inną
strukturę.

Jedynym argumentem metody ``getPart()`` jest łańcuch znaków identyfikujący żądaną część zapytania. String
``'from'`` odpowiada części obiektu ``Zend_Db_Select``, która przechowuje informacje o tabelach (włączając w
to tabele połączone) w klauzuli ``FROM``.

Klasa ``Zend_Db_Select`` definiuje stałe, których można użyć jako oznaczeń zapytania *SQL*. Dozwolone jest
stosowanie tych stałych bądź nazw dosłownych.

.. _zend.db.select.other.get-part.table:

.. table:: Stałe używane przez metody getPart() oraz reset()

   +----------------------------+----------------+
   |Stała                       |Wartość dosłowna|
   +============================+================+
   |Zend_Db_Select::DISTINCT    |'distinct'      |
   +----------------------------+----------------+
   |Zend_Db_Select::FOR_UPDATE  |'forupdate'     |
   +----------------------------+----------------+
   |Zend_Db_Select::COLUMNS     |'columns'       |
   +----------------------------+----------------+
   |Zend_Db_Select::FROM        |'from'          |
   +----------------------------+----------------+
   |Zend_Db_Select::WHERE       |'where'         |
   +----------------------------+----------------+
   |Zend_Db_Select::GROUP       |'group'         |
   +----------------------------+----------------+
   |Zend_Db_Select::HAVING      |'having'        |
   +----------------------------+----------------+
   |Zend_Db_Select::ORDER       |'order'         |
   +----------------------------+----------------+
   |Zend_Db_Select::LIMIT_COUNT |'limitcount'    |
   +----------------------------+----------------+
   |Zend_Db_Select::LIMIT_OFFSET|'limitoffset'   |
   +----------------------------+----------------+

.. _zend.db.select.other.get-part.example:

.. rubric:: Przykład użycia metody getPart()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products')
                ->order('product_id');

   // Można użyć dosłownej nazwy żądanej części
   $orderData = $select->getPart( 'order' );

   // Alternatywnie można posłużyć się stałą
   $orderData = $select->getPart( Zend_Db_Select::ORDER );

   // Wartość zwrotna może nie być stringiem a tablicą.
   // Każda część zapytania może mieć inną strukturę.
   print_r( $orderData );

.. _zend.db.select.other.reset:

Czyszczenie części obiektu Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``reset()`` umożliwia wyczyszczenie podanej części lub całości (jeśli nie poda się argumentu)
zapytania *SQL*.

Jedyny argument jest opcjonalny. Można podać w nim część zapytania przeznaczoną do wyczyszczenia używając
tych samych łańcuchów co w przypadku metody ``getPart()``. Podana część zapytania jest ustawiana w stan
domyślny.

Jeśli nie poda się parametru, metoda ``reset()`` ustawia wszystkie części zapytania w ich stan domyślny. Przez
to używany obiekt ``Zend_Db_Select`` odpowiada nowemu obiektowi, tak jakby został on dopiero utworzony.

.. _zend.db.select.other.reset.example:

.. rubric:: Przykład użycia metody reset()

.. code-block:: php
   :linenos:

   // Tworzenie zapytania:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_name"

   $select = $db->select()
                ->from(array('p' => 'products')
                ->order('product_name');

   // Zmienione wymagania, sortowanie wg. innej kolumny:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_id"

   // Wyczyszczenie jednej części aby można było ją ponownie zdefiniować
   $select->reset( Zend_Db_Select::ORDER );

   // Podanie nowej kolumny sortowania
   $select->order('product_id');

   // Wyczyszczenie wszystkich części zapytania
   $select->reset();


