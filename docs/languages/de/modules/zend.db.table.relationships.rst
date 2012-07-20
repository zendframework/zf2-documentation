.. _zend.db.table.relationships:

Zend_Db_Table Relationships
===========================

.. _zend.db.table.relationships.introduction:

Einführung
----------

In einer relationalen Datenbank haben Tabellen Relationen zueinander. Eine Entität in einer Tabelle kann zu einer
oder mehrerer Entitäten in einer anderen Tabelle, durch Verwendung von referentiellen Integritätsverknüpfungen
die im Datenbank Schema definiert sind, verknüpft werden.

Die ``Zend_Db_Table_Row`` Klasse besitzt Methoden für die Abfrage von verknüpften Zeilen in anderen Tabellen.

.. _zend.db.table.relationships.defining:

Verknüpfungen definieren
------------------------

Die Klassen für jede eigene Tabelle müssen durch das Erweitern der abstrakten Klasse ``Zend_Db_Table_Abstract``,
wie in :ref:`diesem Kapitel <zend.db.table.defining>` beschrieben, definiert werden. Siehe auch in :ref:`diesem
Kapitel <zend.db.adapter.example-database>` für die Beschreibung einer Beispieldatenbank für welche der folgende
Beispielcode designed wurde.

Anbei sind die *PHP* Klassendefinitionen für diese Tabellen:

.. code-block:: php
   :linenos:

   class Accounts extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'accounts';
       protected $_dependentTables = array('Bugs');
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'products';
       protected $_dependentTables = array('BugsProducts');
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'bugs';

       protected $_dependentTables = array('BugsProducts');

       protected $_referenceMap    = array(
           'Reporter' => array(
               'columns'           => 'reported_by',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Engineer' => array(
               'columns'           => 'assigned_to',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Verifier' => array(
               'columns'           => array('verified_by'),
               'refTableClass'     => 'Accounts',
               'refColumns'        => array('account_name')
           )
       );
   }

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';

       protected $_referenceMap    = array(
           'Bug' => array(
               'columns'           => array('bug_id'),
               'refTableClass'     => 'Bugs',
               'refColumns'        => array('bug_id')
           ),
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id')
           )
       );

   }

Wenn ``Zend_Db_Table`` verwendet wird um kaskadierende ``UPDATE`` und ``DELETE`` Operationen zu emulieren, muß das
``$_dependentTables`` Array in der Klasse für die Eltern-Tabelle definiert werden. Der Klassenname muß für jede
abhängige Komponente aufgelistet werden. Hierbei muß der Klassenname und nicht der physikalische Name der *SQL*
Tabelle verwendet werden.

.. note::

   Die Deklaration von ``$_dependentTables`` sollte übergangen werden wenn referentielle
   Integritätsverknüpfungen im *RDBMS* Server verwendet werden um kaskadierende Operationen zu implementieren.
   Siehe :ref:`dieses Kapitel <zend.db.table.relationships.cascading>` für weitere Informationen.

Das ``$_referenceMap`` Array muß in der Klasse für jede abhängige Tabelle deklariert werden. Das ist ein
assoziatives Array von Referenz-"Regeln". Eine Referenzregel identifiziert welche Tabelle in der Relation die
Elterntabelle ist, und listet auch welche Spalten in der abhängigen Tabelle welche Spalten in der Elterntabelle
referenzieren.

Der Schlüssel der Regel ist ein String der als Index zum ``$_referenceMap`` Array verwendet wird. Dieser
Regelschlüssel wird verwendet um jede Referenzen von Abhängigkeiten zu idenzifizieren. Es sollte ein sprechender
Name für diesen Regelschlüssel ausgewählt werden. Deshalb ist es das beste einen String zu verwendet welcher
Teil eines *PHP* Methodennamens sein kann, wie man später sieht.

Im Beispiel *PHP* Code von oben, sind die Regelschlüssel in der Bugs Tabelle folgende: ``'Reporter'``,
``'Engineer'``, ``'Verifier'``, und ``'Product'``.

Die Werte von jedem Regeleintrag im ``$_referenceMap`` Array sind auch ein assoziatives Array. Die Elemente dieses
Regeleintrages werden im folgenden beschrieben:

- **columns** => Ein String oder ein Array von Strings welche die Namen der entfernten Schlüsselspalte der
  abhängigen Tabelle benennen.

  Es ist üblich das dies eine einzelne Spalte ist, aber einige Tabellen haben mehr-spaltige Schlüssel.

- **refTableClass** => Der Klassenname der Elterntabelle. Es sollte der Klassenname und nicht der physikalische
  Name der *SQL* Tabelle verwendet werden.

  Es ist für eine abhängige Tabelle üblich eine eigene Referenz zu Ihrer Elterntabelle zu haben, aber einige
  Tabellen haben mehrfache Referenzen zu der gleichen Elterntabelle. In der Beispieldatenbank gibt es eine Referenz
  von der ``bugs`` Tabelle zu der ``products`` Tabelle, aber drei Referenzen von der ``bugs`` Tabelle zur
  ``accounts`` Tabelle. Jede Referenz sollte in einen separaten Eintrag im ``$_referenceMap`` Array gegeben werden.

- **refColumns** => Ein String oder ein Array von Strings die den Spaltennamen des primären Schlüssels in der
  Elterntabelle benennen.

  Es ist üblich das dies eine einzelne Spalte ist, aber einige Tabellen haben mehr-spaltige Schlüssel. Wenn die
  Referenz einen mehr-spaltigen Schlüssel verwendet, muß die Reihenfolge der Spalten im ``'columns'`` Eintrag der
  Reihenfolge der Spalten im ``'refColumns'`` Eintrag entsprechen.

  Dieses Element kann optional spezifiziert werden. Wenn ``refColumns`` nicht spezifiziert wird, werden
  standardmäßig die Spalten verwendet, die als primäre Schlüsselspalten in der Elterntabelle bekannt sind.

- **onDelete** => Eine Regel für eine Aktion die ausgeführt wird wenn eine Zeile in der Elterntabelle gelöscht
  wird. Siehe auch :ref:`dieses Kapitel <zend.db.table.relationships.cascading>` für weitere Informationen.

- **onUpdate** => Eine Regel für eine Aktion die ausgeführt wird wenn Werte in der primären Schlüsselspalte der
  Elterntabelle aktualisiert werden. Siehe auch :ref:`dieses Kapitel <zend.db.table.relationships.cascading>` für
  weitere Informationen.

.. _zend.db.table.relationships.fetching.dependent:

Eine abhängige Zeile holen
--------------------------

Wenn man ein Zeilen Objekt als Ergebnis einer Abfrage auf einer Elterntabelle hat, können Zeilen der abhängigen
Tabellen geholt werden, welche die aktuelle Zeile referenzieren. Hierbei kann die folgende Methode verwendet
werden:

.. code-block:: php
   :linenos:

   $row->findDependentRowset($table, [$rule]);

Diese Methode gibt ein ``Zend_Db_Table_Rowset_Abstract`` Objekt zurück, welche ein Set von Zeilen der abhängigen
Tabelle ``$table`` enthält die die Zeile referenzieren die durch das ``$row`` Objekt identifiziert werden.

Das erste Argument ``$table`` kann ein String sein, der die abhängige Tabelle durch Ihren Klassennamen
spezifiziert. Man kann die abhängige Tabelle auch durch Verwendung eines Objekts dieser Tabellenklasse
spezifizieren.

.. _zend.db.table.relationships.fetching.dependent.example:

.. rubric:: Eine abhängige Zeile holen

Dieses Beispiel zeigt wie man ein Zeilenobjekt von der Tabelle ``Accounts`` erhält und die ``Bugs`` findet die
durch diesen Account mitgeteilt wurden.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsReportedByUser = $user1234->findDependentRowset('Bugs');

Das zweite Argument ``$rule`` ist optional. Es ist ein String der den Regelschlüssel im ``$_referenceMap`` Array
der abhängigen Tebellenklasse benennt. Wenn keine Regel spezifiziert wird, wird die erste Regel im Array verwendet
welche die Elterntabelle referenziert. Wenn eine andere Regel als die erste verwendet werden soll, muß der
Schlüssel spezifiziert werden.

Im obigen Beispiel wird der Regelschlüssel nicht spezifiziert, sodas standardmäßig die Regel verwendet wird die
als erste der Elterntabelle entspricht. Das ist die Regel ``'Reporter'``.

.. _zend.db.table.relationships.fetching.dependent.example-by:

.. rubric:: Eine anhängige Zeile durch eine spezifische Regel erhalten

Das Beispiel zeigt wie ein Zeilenobjekt von der ``Accounts`` Tabelle erhalten werden kann, und die zugeordneten
``Bugs`` die vom Benutzer dieses Accounts bereits gefixed wurden, gefunden werden können. Der String des
Regelschlüssels der zu dieser Referenziellen Abhängigkeit in dem Beispiel korrespondiert ist ``'Engineer'``.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsAssignedToUser = $user1234->findDependentRowset('Bugs', 'Engineer');

Es können auch Kriterien, Sortierungen und Limits zur Relation hinzugefügt werden indem das Select Objekt der
Elternzeilen verwendet wird.

.. _zend.db.table.relationships.fetching.dependent.example-by-select:

.. rubric:: Ein anhängiges Zeilenset erhalten indem Zend_Db_Table_Select verwendet wird

Dieses Beispiel zeigt wir ein Zeilenobjekt von der Tabelle ``Accounts`` empfangen werden kann, und die zugeordneten
``Bugs`` die vom Benutzer dieses Zugangs zu beheben sind, gefunden werden können, beschränkt auf 3 Zeilen und
nach Name sortiert.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();
   $select = $accountsTable->select()->order('name ASC')
                                     ->limit(3);

   $bugsAssignedToUser = $user1234->findDependentRowset('Bugs',
                                                        'Engineer',
                                                        $select);

Alternativ können Zeilen von einer abhängigen Tabelle abgefragt werden indem ein spezieller Mechanismus verwendet
wird der "magische Methode" genannt wird. ``Zend_Db_Table_Row_Abstract`` ruft die Methode:
``findDependentRowset('<TabellenKlasse>', '<Regel>')`` auf wenn eine Methode am Zeilenobjekt aufgerufen wird die
einem der folgenden Patterns entspricht:

- ``$row->find<TabellenKlasse>()``

- ``$row->find<TabellenKlasse>By<Regel>()``

In den obigen Patterns, sind ``<TabellenKlasse>`` und ``<Regel>`` Strings die mit dem Klassennamen der abhängigen
Tabelle korrespondieren, und der Regelschlüssel der abhängigen Tabelle der die Enterntabelle referenziert.

.. note::

   Einige Applikationsframeworks, wie Ruby on Rails, verwenden einen Mechanismus der "inflection" genannt wird um
   die Änderung der Schreibweise von Identifizierern abhängig von der Verwendung zu erlauben. Der Einfachheit
   halber, bietet ``Zend_Db_Table_Row`` keinen Inflection Mechanismus an. Die Identität der Tabelle und der
   Regelschlüssel die im Methodenaufruf genannt werden müssen der Schreibweise der Klasse und des
   Regelschlüssels exakt entsprechen.

.. _zend.db.table.relationships.fetching.dependent.example-magic:

.. rubric:: Holen von abhängigen Zeilen durch Verwendung der magischen Methode

Dieses Beispiel zeigt wie abhängige Zeilen gefunden werden, entsprechend des vorherigen Beispiel. In diesem Fall,
verwendet die Anwendung den magischen Methodenaufruf anstatt die Tabelle und Regel als String zu spezifizieren.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   // Verwendung der standard Referenzregel
   $bugsReportedBy = $user1234->findBugs();

   // Eine Referenzregel spezifizieren
   $bugsAssignedTo = $user1234->findBugsByEngineer();

.. _zend.db.table.relationships.fetching.parent:

Eine Elternzeile holen
----------------------

Wenn man ein Zeilenobjekt als Ergebnis einer Abfrage auf eine abhängige Tabelle hat, kann man die Zeile vom
Elternteil zu der die abhängige Zeile referenziert holen. Hierbei verwendet man die Methode:

.. code-block:: php
   :linenos:

   $row->findParentRow($table, [$rule]);

Es sollte immer exakt eine Zeile in der Elterntabelle durch eine abhängige Zeile referenziert sein, deshalb gibt
diese Methode ein Zeilen Objekt und kein Zeilenset Objekt zurück.

Das erste Argument ``$table`` kann ein String sein der die Elterntabelle durch Ihren Klassennamen spezifiziert. Man
kann die Elterntabelle auch durch Verwendung eines Objektes dieser Tabellenklasse spezifizieren.

.. _zend.db.table.relationships.fetching.parent.example:

.. rubric:: Eine Elternzeile holen

Dieses Beispiel zeigt wie ein Zeilen Objekt von der Tabelle ``Bugs`` geholt werden kann (zum Beispiel einer dieser
Fehler mit Status 'NEW'), und die Zeile in der ``Accounts`` Tabelle für diesen Benutzer, der den Fehler gemeldet
hat, gefunden werden kann.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?' => 'NEW'));
   $bug1 = $bugsRowset->current();

   $reporter = $bug1->findParentRow('Accounts');

Das zweite Argument ``$rule`` ist optional. Es ist ein Strung der den Regelschlüssel im ``$_referenceMap`` Array
der abhängigen Tabellenklasse benennt. Wenn diese Regel nicht spezifiziert wird, wird die erste Regel im Array
genommen das die Elterntabelle referenziert. Wenn eine andere Regel als der erste genommen werden muß, dann muß
der Schlüssel spezifiziert werden.

Im obigen Beispiel wird der Regelschlüssel nicht spezifiziert, sodas standardmäßig die Regel verwendet wird die
als erste der Elterntabelle entspricht. Das ist die Regel ``'Reporter'``.

.. _zend.db.table.relationships.fetching.parent.example-by:

.. rubric:: Eine Elternzeile durch eine spezifizierte Regel holen

Dieses Beispiel zeigt wie ein Zeilenobjekt von der Tabelle ``Bugs`` geholt werden kann, und der Account für den
Ingenieur der zugeordnet wurde, diesen Fehler zu beheben, gefunden werden kann. Der Regelschlüssel der in diesem
Beispiel der referenzierten Abhängigkeit entspricht ist ``'Engineer'``.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   $engineer = $bug1->findParentRow('Accounts', 'Engineer');

Alternativ, können Zeilen von der Elterntabelle abgefragt werden indem eine "magische Methode" verwendet wird.
``Zend_Db_Table_Row_Abstract`` ruft die Methode: ``findParentRow('<TableClass>', '<Rule>')`` auf wenn eine Methode
auf dem Zeilenobjekt aufgerufen wird die einer der folgenden Pattern entspricht:

- ``$row->findParent<TabellenKlasse>([Zend_Db_Table_Select $select])``

- ``$row->findParent<TabellenKlasse>By<Regel>( [Zend_Db_Table_Select $select])``

In den obigen Pattern sind, ``<TabellenKlasse>`` und ``<Regel>`` Strings die dem Klassennamen der Elterntabelle
entsprechen, und der Regelname der abhängigen Tabelle der die Elterntabelle referenziert.

.. note::

   Die Identität der Tabelle und des Regelschlüssels die im Aufruf der Methode genannt werden, müssen der
   Schreibweise der Klasse und des Regelschlüssels exakt entsprechen.

.. _zend.db.table.relationships.fetching.parent.example-magic:

.. rubric:: Die Elternzeile durch verwenden der magischen Methode holen

Dieses Beispiel zeigt wie Elternzeilen gefunden werden, ähnlich dem vorherigen Beispiel. In diesem Fall verwendet
die Anwendung den Aufruf der magischen Methode statt der Spezifizierung von Tabelle und Regel als Strings.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   // Verwenden der standardmäßigen Referenzregel
   $reporter = $bug1->findParentAccounts();

   // Die Referenzregel spezifizieren
   $engineer = $bug1->findParentAccountsByEngineer();

.. _zend.db.table.relationships.fetching.many-to-many:

Ein Zeilenset über eine Viele-zu-Viele Verknüpfung holen
--------------------------------------------------------

Wenn man ein Zeilenobjekt als Ergebnis einer Abfrage auf eine Tabelle in einer Viele-Zu-Viele Verknüpfung hat
(für die Zwecke dieses Beispiels, nennen wir das die "Original" Tabelle), können entsprechende Zeilen in der
anderen Tabelle (nennen wir das die "Ziel" Tabelle) über eine Verknüpfungstabelle geholt werden. Hierbei wird die
folgende Methode verwendet:

.. code-block:: php
   :linenos:

   $row->findManyToManyRowset($table,
                              $intersectionTable,
                              [$rule1,
                                  [$rule2,
                                      [Zend_Db_Table_Select $select]
                                  ]
                              ]);

Diese Methode gibt ein ``Zend_Db_Table_Rowset_Abstract`` zurück welches Zeilen von der Tabelle ``$table``
enthält, und der Viele-Zu-Viele Abhängigkeit entspricht. Das aktuelle Zeilenobjekt ``$row`` von der originalen
Tabelle wird verwendet um Zeilen in der Verknüpfungstabelle zu finden, und es ist mit der Zieltabelle verbunden.

Das erste Argument ``$table`` kann ein String sein der die Zieltabelle in der Viele-Zu-Viele Verknüpfung durch
seinen Klassennamen spezifiziert. Es kann auch die Zieltabelle durch Verwendung eines Objekts dieser Tabellenklasse
spezifiziert werden.

Das zweite Argument ``$intersectionTable`` kann ein String sein, der die Verknüpfungstabelle zwischen diesen zwei
Tabellen in der Viele-Zu-Viele Verknüpfung, durch seinen Klassennamen, spezifiziert. Die Verknüpfungstabelle kann
auch durch Verwendung eines Objektes dieser Tabellenklasse spezifiziert werden.

.. _zend.db.table.relationships.fetching.many-to-many.example:

.. rubric:: Ein Zeilenset mit einer Viele-Zu-Viele Methode holen

Dieses Beispiel zeigt wie man ein Zeilenobjekt von der Originaltabelle ``Bugs`` erhält, und wie Zeilen von der
Zieltabelle ``Products`` gefunden werden können die Produkte repräsentieren welche diesem Bug zugeordnet sind.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts');

Das dritte und vierte Argument ``$rule1`` und ``$rule2`` sind optional. Das sind Strings die den Regelschlüssel im
``$_referenceMap`` Array der verknüpfungstabelle benennen.

Der ``$rule1`` Schlüssel benennt die Regel für die Verknüpfung der Verknüpfungstabelle zur Originaltabelle. In
diesem Beispiel ist das die verknüpfung von ``BugsProducts`` zu ``Bugs``.

Der ``$rule2`` Schlüssel benennt die Regel für die Verknüpfung der Verknüpfungstabelle zur Zieltabelle. In
diesem Beispiel ist der die Verknüpfung von ``Bugs`` zu ``Products``.

Ähnlich den Methoden für das finden von Eltern- und abhängigen Zeilen verwendet die Methode, wenn keine Regel
spezifiziert wird, die erste Regel im ``$_referenceMap`` Array das den Tabellen in der Verknüpfung entspricht.
Wenn eine andere Regel als die erste verwendet werden soll, muß der Schlüssel spezifiziert werden.

Im obigen Beispiel wird der Regelschlüssel nicht spezifiziert, sodas standardmäßig die ersten passenden Regeln
verwendet werden. In diesem Fall ist ``$rule1`` ``'Reporter'`` und ``$rule2`` ist ``'Product'``.

.. _zend.db.table.relationships.fetching.many-to-many.example-by:

.. rubric:: Ein Zeilenset mit einer Viele-Zu-Viele Methode durch eine spezielle Regel holen

Dieses Beispiel zeigt wie man ein Zeilenobjekt von der Originaltabelle ``Bugs`` erhält, und Zeilen von der
Zieltabelle ``Products`` findet die Produkte repräsentieren die dem Fehler zugeordnet sind.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts',
                                                    'Bug');

Alternativ können Zeilen von der Zieltabelle in einer Viele-Zu-Viele Verknüpfung abgefragt werden inden eine
"magische Methode" verwendet wird. ``Zend_Db_Table_Row_Abstract`` ruft die Methode:
``findManyToManyRowset('<TabellenKlasse>', '<VerknüpfungTabellenKlasse>', '<Regel1>', '<Regel2>')`` auf, wenn eine
Methode aufgerufen wird die einem der folgenden Pattern entspricht:

- ``$row->find<TabellenKlasse>Via<VerknüpfungsTabellenKlasse> ([Zend_Db_Table_Select $select])``

- ``$row->find<TabellenKlasse>Via<VerknüpfungsTabellenKlasse>By<Regel1> ([Zend_Db_Table_Select $select])``

- ``$row->find<TabellenKlasse>Via<VerknüpfungsTabellenKlasse>By<Regel1>And<Regel2> ([Zend_Db_Table_Select
  $select])``

In den oben gezeigten Pattern sind ``<TabellenKlasse>`` und ``<VerknüpfungsTabellenKlasse>`` Strings die den
Klassennamen der Zieltabelle und der Verknüpfungstabelle entsprechen. ``<Regel1>`` und ``<Regel2>`` sind Strings
die den Regelschlüssel in der Verknüpfungstabelle entsprechen, welche die Originaltabelle und die Zieltabelle
referenzieren.

.. note::

   Die Tabelleneinheiten und die Regelschlüssel die in der aufgerufenen Methode benannt werden, müssen exakt der
   Schreibweise der Klasse und des Regelschlüssels entsprechen.

.. _zend.db.table.relationships.fetching.many-to-many.example-magic:

.. rubric:: Zeilensets durch Verwendung der magischen Viele-Zu-Viele Methode holen

Dieses Beispiel zeigt wie Zeilen in der Zieltabelle einer Viele-Zu-Viele Verknüpfung gefunden werden können, in
der Produkte die einen Bezug zu einem angegebenen Fehler haben, entsprechen.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   // Verwendung der standardmäßigen Referenzregel
   $products = $bug1234->findProductsViaBugsProducts();

   // Spezifizieren der Referenzregel
   $products = $bug1234->findProductsViaBugsProductsByBug();

.. _zend.db.table.relationships.cascading:

Schreiboperationen kaskadieren
------------------------------

.. note::

   **Deklarieren von DRI in der Datenbank:**

   Die Deklaration von kaskadierenden Operationen in ``Zend_Db_Table`` **nur** für *RDBMS* Marken gedacht die
   keine deklarative referentielle Integrität unterstützen (*DRI*).

   Zum Beispiel, bei der Verwendung von MySQL's MyISAM Speicherengine oder SQLite. Diese Lösungen unterstützen
   kein *DRI*. Hierbei ist es hilfreich die kaskadierenden Operationen mit ``Zend_Db_Table`` zu deklarieren.

   Wenn die eigene *RDBMS* *DRI* implementiert sowie die ON ``DELETE`` und ON ``UPDATE`` Klauseln, sollten diese
   Klauseln im eigenen Datenbank Schema deklariert werden, anstatt das kaskadierende Feature von ``Zend_Db_Table``
   zu verwenden. Die Deklaration von *DRI* Regeln in der *RDBMS* ist besser für die Geschwindigkeit der Datenbank,
   Konsistenz und Integrität.

   Am wichtigsten ist aber das die kaskadierenden Operationen nicht in beiden, der *RDBMS* und der eigenen
   ``Zend_Db_Table`` Klasse deklariert werden.

Kaskadierende Operationen können deklariert werden um anhand einer abhängigen Tabelle ausgeführt zu werden wenn
ein ``UPDATE`` oder ein ``DELETE`` an einer Zeile in einer Elterntabelle ausgeführt wird.

.. _zend.db.table.relationships.cascading.example-delete:

.. rubric:: Beispiel für ein kaskadierendes Löschen

Dieses Beispiel zeigt das Löschen einer Zeile in der ``Products`` Tabelle, welche konfiguriert ist um automatisch
abhängige Zeilen in der ``Bugs`` Tabelle zu löschen.

.. code-block:: php
   :linenos:

   $productsTable = new Products();
   $productsRowset = $productsTable->find(1234);
   $product1234 = $productsRowset->current();

   $product1234->delete();
   // Kaskadiert automatisch zur Bugs Tabelle und löscht abhängige Zeilen.

Genauso kann es gewünscht sein, wenn man ein ``UPDATE`` verwendet um den Wert eines primären Schlüssels in einer
Elterntabelle zu verändern, das sich auch den Wert im entfernten Schlüssel der abhängigen Tabellen automatisch
von selbst aktualisiert um dem neuen Wert zu entsprechen, sodas solche Referenzen aktuel gehalten werden.

Normalerweise ist es nicht notwendig die Werte eines primären Schlüssels, der durch eine Sequenz von anderen
Mechanismen erstellt wurde, zu aktualisieren. Aber wenn man einen **natürlichen Schlüssel** verwendet, der den
Wert plötzlich ändert, ist es besser kaskadierende Aktualisierungen auf abhängigen Tabellen durchzuführen.

Um eine kaskadierende Abhängigkeit in ``Zend_Db_Table`` zu deklarieren, müssen die Regeln in ``$_referenceMap``
bearbeitet werden. Die assoziativen Arrayschlüssel ``'onDelete'`` und ``'onUpdate'`` müssen auf den String
'cascade' (oder die Konstante ``self::CASCADE``) gesetzt werden. Bevor eine Zeile von der Elterntabelle gelöscht
wird oder dessen Wert des primären Schlüssels aktualisiert wird, werden alle Zeilen in der abhängigen Tabelle,
welche die Eltern-Zeilen referenzieren, zuerst gelöscht oder aktualisiert.

.. _zend.db.table.relationships.cascading.example-declaration:

.. rubric:: Beispieldeklaration einer kaskadierenden Operation

Im unten angeführten Beispiel, werden die Zeilen in der ``Bugs`` Tabelle automatisch gelöscht wenn eine Zeile in
der ``Products`` Tabelle zu der Sie referenzieren gelöscht wird. Das ``'onDelete'`` Element des Referenzplan
Eintrages wird auf ``self::CASCADE`` gesetzt.

Es wird in diesem Beispiel keine kaskadierende Aktualisierung durchgeführt wenn der primäre Schlüsselwert in der
Elternklasse verändert wird. Das ``'onUpdate'`` Element des Referenzplan Eintrages ist ``self::RESTRICT``. Das
gleiche Ergebnis erhält man durch Unterdrückung des ``'onUpdate'`` Eintrages.

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       ...
       protected $_referenceMap = array(
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id'),
               'onDelete'          => self::CASCADE,
               'onUpdate'          => self::RESTRICT
           ),
           ...
       );
   }

.. _zend.db.table.relationships.cascading.notes:

Notizen betreffend kaskadierenden Operationen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Kaskadierende Operationen die durch Zend_Db_Table aufgerufen werden sind nicht atomar.**

Das bedeutet, das wenn die eigene Datenbank referentielle integrative Verknüpfungen implementiert und erzwingt,
ein kaskadierends ``UPDATE`` das durch eine ``Zend_Db_Table`` Klasse ausgeführt wird mit der Verknüpfung
kollidiert, und in einem referentiellen integrativen Verstoß mündet. Ein kaskadierendes ``UPDATE`` kann in
``Zend_Db_Table`` **nur** dann verwendet werden wenn die eigene Datenbank die referentielle integrative
Verknüpfung nicht erzwingt.

Ein kaskadierendes ``DELETE`` erleidet weniger durch das Problem des referentiellen integrativen Verstoßes.
Abhängige Zeilen können genauso gelöscht werden wie durch eine nicht-atomare Aktion bevor die Elternzeile welche
diese referenziert gelöscht wird.

Trotzdem, für beide ``UPDATE`` und ``DELETE``, erzeugt die Änderung der Datenbank in einem nicht-atomaren Weg
auch das Risiko das ein anderer Datenbankbenutzer die Daten in einem inkonsistenten Status sieht. Wenn, zum
Beispiel, eine Zeile und alle Ihre abhängigen Zeilen, gelöscht werden, gibt es eine kleine Chance das ein anderes
Datenbank Clientprogramm die Datenbank abfragen kann nachdem die abhängigen Zeilen gelöscht wurden, aber bevor
die Elternzeilen gelöscht wurden. Dieses Clientprogramm kann die Elternzeilen ohne abhängige Zeilen sehen, und
diese als gewünschten Status der Daten annehmen. Es gibt keinen Weg für diesen Clienten herauszufinden das die
Abfrage der Datenbank mitten wärend einer Änderung gelesen wurde.

Der Fall von nicht-atomaren Änderungen kann durch die Verwendung von Transaktionen entschärft werden indem die
Änderungen isoliert werden. Aber einige *RDBMS* Marken unterstützen keine Transaktionen, oder erlauben dem
Clienten "schmutzige" Änderungen zu lesen die noch nicht fertiggestellt wurden.

**Kaskadierende Operationen in Zend_Db_Table werden nur durch Zend_Db_Table aufgerufen.**

Kaskadierendes Löschen und Aktualisieren welches in den eigenen ``Zend_Db_Table`` Klassen definiert wurde werden
ausgeführt wenn die ``save()`` oder ``delete()`` Methoden der Zeilenklasse ausgeführt werden. Trotzdem, wenn ein
Update oder Löschen von Daten durch Verwendung eines anderen Interfaces durchgeführt wird, wie durch ein
Abfragetool oder eine andere Anwendung, werden die kaskadierenden Operationen nicht ausgeführt. Selbst wenn die
``update()`` und ``delete()`` Methoden in der ``Zend_Db_Adapter`` Klasse verwendet werden, werden die
kaskadierenden Operationen die in der eigenen ``Zend_Db_Table`` Klasse definiert wurden, nicht ausgeführt.

**Kein kaskadierendes INSERT.**

Es gibt keine Unterstützung für ein kaskadierendes ``INSERT``. Man muß eine Zeile in eine Elterntabelle in einer
Operation hinzufügen, und Zeilen zu einer abhängigen Tabelle in einer unabhängigen Operation hinzufügen.


