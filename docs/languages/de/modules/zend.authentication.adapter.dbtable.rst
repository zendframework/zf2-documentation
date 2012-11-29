.. EN-Revision: none
.. _zend.authentication.adapter.dbtable:

Datenbanktabellen Authentifizierung
===================================

.. _zend.authentication.adapter.dbtable.introduction:

Einführung
----------

``Zend\Auth_Adapter\DbTable`` bietet die Möglichkeit, sich gegenüber Zeugnissen zu authentifizieren, die in einer
Datenbank Tabelle gespeichert sind. Weil ``Zend\Auth_Adapter\DbTable`` eine Instanz von
``Zend\Db_Adapter\Abstract`` benötigt, die an den Konstruktor übergeben wird, ist jede Instanz an eine spezielle
Datenbank Verbindung verknüpft. Andere Konfigurationsoptionen können durch den Konstruktor gesetzt werden und
durch die Methoden der Instanz. Eine für jede Option.

Die vorhandenen Konfigurationsoptionen beinhalten:

- **tableName**: Das ist der Name der Datenbanktabelle, welche die Authentifikations Zeugnisse enthält, und gegen
  die jene Datenbank-Authentifikations-Abfrage durchgeführt wird.

- **identityColumn**: Ist der Name der Spalte der Datenbanktabelle, welche die Identität repräsentiert. Die Spalte
  der Identität muß eindeutige und einmalige Werte enthalten, wie einen Benutzernamen oder eine Email Adresse.

- **credentialColumn**: Das ist der Name der Spalte der Datenbanktabelle, die verwendet wird, um die Zeugnisse zu
  repräsentieren. Bei einem einfachen Identitäts- und Passwort-Authentifizierungs-Schema korrespondieren die
  Zeugnisse mit dem Passwort. Siehe auch die ``credentialTreatment`` Option.

- **credentialTreatment**: In vielen Fällen sind Passwörter und andere sensitive Daten verschlüsselt, gehasht,
  kodiert, gesalted, verschleiert oder auf andere Weise durch irgendeine Funktion oder einen Algorithmus behandelt.
  Durch die Spezifikation eines parametrisierbaren Behandlungsstrings mit dieser Methode, wie '``MD5(?)``' oder
  '``PASSWORD(?)``', könnte ein Entwickler beliebiges *SQL* an den Eingabe- Zeugnis-Daten anwenden. Da diese
  Funktionen der darunter liegenden *RDBMS* speziell gehören, sollte das Handbuch der Datenbank auf das
  Vorhandensein solcher Funktionen im eigenen Datenbank System geprüft werden.

.. _zend.authentication.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: Grundsätzliche Verwendung

Wie bereits in der Einführung beschrieben benötigt der ``Zend\Auth_Adapter\DbTable`` Konstruktor eine Instanz von
``Zend\Db_Adapter\Abstract`` die als Datenbank Verbindung fungiert zu welcher die Instanz des
Authentifizierungs-Adapters gebunden ist. Zuerst sollte die Datenbankverbindung erstellt werden.

Der folgende Code erstellt einen Adapter für eine In-Memory Datenbank, erstellt ein einfaches Datenbankschema, und
fügt eine Zeile ein gegen die später eine Authentifizierungs-Abfrage durchgeführt werden kann. Dieses Beispiel
benötigt die *PDO* SQLite Erweiterung:

.. code-block:: php
   :linenos:

   // Erstellt eine In-Memory SQLite Datenbankverbindung
   $dbAdapter = new Zend\Db\Adapter\Pdo\Sqlite(array('dbname' =>
                                                     ':memory:'));

   // Erstellt eine einfache Datenbank-Erstellungs-Abfrage
   $sqlCreate = 'CREATE TABLE [users] ('
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // Erstellt die Tabelle für die Authentifizierungs Zeugnisse
   $dbAdapter->query($sqlCreate);

   // Erstellt eine Abfrage um eine Zeile einzufügen für die eine
   // Authentifizierung erfolgreich sein kann
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // Daten einfügen
   $dbAdapter->query($sqlInsert);

Mit der Datenbankverbindung und den vorhandenen Tabellendaten, kann eine Instanz von ``Zend\Auth_Adapter\DbTable``
erstellt werden. Die Werte der Konfigurationsoptionen können dem Konstruktor übergeben werden, oder als Parameter
der setzenden Methoden nach der Instanziierung:

.. code-block:: php
   :linenos:

   // Die Instanz mit Konstruktor Parametern konfiurieren...
   $authAdapter = new Zend\Auth_Adapter\DbTable(
       $dbAdapter,
       'users',
       'username',
       'password'
   );

   // ...oder die Instanz mit den setzenden Methoden konfigurieren
   $authAdapter = new Zend\Auth_Adapter\DbTable($dbAdapter);
   $authAdapter
       ->setTableName('users')
       ->setIdentityColumn('username')
       ->setCredentialColumn('password');

An diesem Punkt ist die Instanz des Authentifizierungsadapters bereit um Authentifierungsabfragen zu akzeptieren.
Um eine Authentifierungsabfrage zu formulieren, werden die Eingabezeugnis Werte dem Adapter vor dem Aufruf der
``authenticate()`` Methode, übergeben:

.. code-block:: php
   :linenos:

   // Die Eingabezeugnis Werte setzen (z.B. von einem Login Formular)
   $authAdapter
       ->setIdentity('my_username')
       ->setCredential('my_password');

   // Die Authentifizierungsabfrage durchführen, das Ergebnis speichern
   $result = $authAdapter->authenticate();

Zusätzlich zum Vorhandensein der ``getIdentity()`` Methode über das Authentifizierungs Ergebnisobjekt,
unterstützt ``Zend\Auth_Adapter\DbTable`` auch das empfangen der Tabellenzeile wenn die Authentifizierung
erfolgeich war:

.. code-block:: php
   :linenos:

   // Die Identität ausgeben
   echo $result->getIdentity() . "\n\n";

   // Die Ergebniszeile ausgeben
   print_r($$authAdapter->getResultRowObject());

   /* Ausgabe:
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )
   */

Da die Zeile der Tabelle die Zeugnis Daten enthält ist es wichtig diese Werte gegenüber unberechtigten Versuchen
abzusichern.

.. _zend.authentication.adapter.dbtable.advanced.storing_result_row:

Fortgeschrittene Verwendung: Ein DbTable Ergebnis Objekt dauerhaft machen
-------------------------------------------------------------------------

Standardmäßig gibt ``Zend\Auth_Adapter\DbTable`` die unterstützte Identität an das Auth Objekt bei
erfolgreicher Authentifizierung zurück. Ein anderes Verwendungs-Szenario, bei dem Entwickler ein Identitäts
Objekt, welches andere nützliche Informationen enthält, in den dauerhaften Speichermechanismus von ``Zend_Auth``
abspeichern wollen, wird durch die Verwendung der ``getResultRowObject()`` Methode gelöst die ein **stdClass**
Objekt zurück gibt. Der folgende Code Abschnitt zeigt diese Verwendung:

.. code-block:: php
   :linenos:

   // Mit Zend\Auth_Adapter\DbTable authentifizieren
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {

       // Die Identität als Objekt speichern wobei nur der Benutzername und
       // der echte Name zurückgegeben werden
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array(
           'username',
           'real_name'
       )));

       // Die Identität als Objekt speichern, wobei die
       // Passwort Spalte unterdrückt wird
       $storage->write($adapter->getResultRowObject(
           null,
           'password'
       ));

       /* ... */

   } else {

       /* ... */

   }

.. _zend.authentication.adapter.dbtable.advanced.advanced_usage:

Fortgeschrittene Verwendung durch Beispiele
-------------------------------------------

Wärend der primäre Zweck von ``Zend_Auth`` (und konsequenter Weise ``Zend\Auth_Adapter\DbTable``) die
**Authentifizierung** und nicht die **Authorisierung** ist, gibt es ein paar Instanzen und Probleme auf dem Weg
welche Art besser passt. Abhängig davon wie man sich entscheidet ein Problem zu beschreiben, macht es manchmal
Sinn, das was wie ein Authorisierungsproblem aussieht im Authentifizierungs-Adapter zu lösen.

Mit dieser Definition, hat ``Zend\Auth_Adapter\DbTable`` einige eingebaute Mechanismen die für zusätzliche Checks
wärend der Authentifizierungszeit angepasst werden können, um einige übliche Benutzerprobleme zu lösen.

.. code-block:: php
   :linenos:

   // Der Feldwert des Status eines Accounts ist nicht gleich "compromised"
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND status != "compromised"'
   );

   // Der aktive Feldwert des Accounts ist gleich "TRUE"
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND active = "TRUE"'
   );

Ein anderes Szenario kann die Implementierung eines Saltingmachanismus sein. Salting ist ein Ausdruck der auf eine
Technik verweist welche die Sicherheit der Anwendung sehr stark erhöht. Sie basiert auf der Idee dass das Anfügen
von zufälligen Strings bei jedem Passwort es unmöglich macht eine erfolgreiche Brute-Force Attacke auf die
Datenbank durchzuführen bei der vorberechnete Hashwerte aus einem Verzeichnis genommen werden.

Hierfür muß die Tabelle so modifiziert werden das Sie unseren Salt-String enthält:

.. code-block:: php
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

   $dbAdapter->query($sqlAlter);

Hier ist ein einfacher Weg um einen Salt String für jeden Benutzer bei der Registrierung zu erstellen:

.. code-block:: php
   :linenos:

   for ($i = 0; $i < 50; $i++) {
       $dynamicSalt .= chr(rand(33, 126));
   }

Und nun erstellen wir den Adapter:

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

   Die Sicherheit kann sogar noch mehr erhöht werden indem ein statischer Salt Wert hardcoded in der Anwendung
   verwendet wird. Im Falle das die Datenbank korrumpiert wird (z.B. durch eine *SQL* Injection Attacke) aber der
   Webserver intakt bleibt sind die Daten für den Angreifer noch immer nicht verwendbar.

Eine andere Alternative besteht darin die ``getDbSelect()`` Methode von ``Zend\Auth_Adapter\DbTable`` zu verwenden
nachdem der Adapter erstellt wurde. Diese Methode gibt die Instanz des ``Zend\Db\Select`` Objekts zurück welches
verwendet wird um die ``authenticate()`` Methode zu komplettieren. Es ist wichtig anzumerken das diese Methode
immer das gleiche Objekt zurückgibt unabhängig davon ob ``authenticate()`` aufgerufen wurde oder nicht. Diese
Objekt **enthält keine** Identity oder Anmeldeinformationen in sich da diese Werte im Select Objekt wärend des
Ausführens von ``authenticate()`` platziert werden.

Als Beispiel einer Situation könnte man die ``getDbSelect()`` Methode verwenden um den Status eines Benutzers zu
prüfen, in anderen Worten sehen ob der Account des Benutzers aktiviert ist.

.. code-block:: php
   :linenos:

   // Das Beispiel von oben weiterführen
   $adapter = new Zend\Auth_Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?)'
   );

   // Das Select Objekt (durch Referenz) bekommen
   $select = $adapter->getDbSelect();
   $select->where('active = "TRUE"');

   // Authentifizieren, das stellt sicher das users.active = TRUE
   $adapter->authenticate();


