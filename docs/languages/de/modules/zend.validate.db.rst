.. _zend.validate.Db:

Db_RecordExists und Db_NoRecordExists
=====================================

``Zend_Validate_Db_RecordExists`` und ``Zend_Validate_Db_NoRecordExists`` bieten die Möglichkeit zu testen ob ein
Eintrag in einer angegebenen Tabelle einer Datenbank, mit einem gegebenen Wert, existiert.

.. _zend.validate.set.db.options:

Unterstützte Optionen für Zend_Validate_Db_*
--------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Db_NoRecordExists`` und ``Zend_Validate_Db_RecordExists``
unterstützt:

- **adapter**: Der Datenbank-Adapter welcher für die Suche verwendet wird.

- **exclude**: Setzt die Einträge welche von der Suche ausgenommen werden.

- **field**: Das Datenbank-Feld in dieser Tabelle welches nach dem Eintrag durchsucht wird.

- **schema**: Setzt das Schema welches für die Suche verwendet wird.

- **table**: Die Tabelle welche nach dem Eintrag durchsucht wird.

.. _zend.validate.db.basic-usage:

Grundsätzliche Verwendung
-------------------------

Ein Beispiel der rundsätzlichen Verwendung der Validatoren:

.. code-block:: php
   :linenos:

   // Prüft ob die Email Adresse in der Datenbank existiert
   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table' => 'users',
           'field' => 'emailaddress'
       )
   );

   if ($validator->isValid($emailaddress)) {
       // Die Email Adresse scheint gültig zu sein
   } else {
       // Die Email Adresse ist ungültig; gib die Gründe an
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Das oben stehende testet ob eine gegebene Email Adresse in der Datenbanktabelle vorhanden ist. Wenn kein Eintrag
gefunden wird der den Wert von ``$emailaddress`` in der spezifizierten Spalte hat, wird eine Fehlermeldung
angezeigt.

.. code-block:: php
   :linenos:

   // Prüft ob der Benutzername in der Datenbank existiert
   $validator = new Zend_Validate_Db_NoRecordExists(
       array(
           'table' => 'users',
           'field' => 'username'
       )
   );
   if ($validator->isValid($username)) {
       // Der Benutzername scheint gültig zu sein
   } else {
       // Der Benutzername ist ungültig; gib die Gründe an
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

Das oben stehende testet ob ein angegebener Benutzername nicht in der Datenbanktabelle vorhanden ist. Wenn ein
Eintrag gefunden wird, der den der von ``$username`` in der spezifizierten Spalte enthält, dann wird eine
Fehlermeldung angezeigt.

.. _zend.validate.db.excluding-records:

Ausnehmen von Einträgen
-----------------------

``Zend_Validate_Db_RecordExists`` und ``Zend_Validate_Db_NoRecordExists`` bieten auch die Möglichkeit die
Datenbank zu testen, wobei Teile der Tabelle hiervon ausgenommen werden, entweder indem eine where Klausel als
String angegeben wird, oder ein Array mit den Schlüsseln "field" und "value".

Wenn ein Array für die Ausnahmeklausel angegeben wird, dann wird der **!=** Operator verwenden. Damit kann der
Rest einer Tabelle auf einen Wert geprüft werden bevor ein Eintrag geändert wird (zum Beispiel in einem Formular
für ein Benutzerprofil).

.. code-block:: php
   :linenos:

   // Prüft ob kein anderer Benutzer diesen Benutzernamen hat
   $user_id   = $user->getId();
   $validator = new Zend_Validate_Db_NoRecordExists(
       array(
           'table'   => 'users',
           'field'   => 'username',
           'exclude' => array(
               'field' => 'id',
               'value' => $user_id
           )
       )
   );

   if ($validator->isValid($username)) {
       // Der Benutzername scheint gültig zu sein
   } else {
       // Der Benutzername ist ungültig; zeige den Grund
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

Das obige Beispiel prüft die Tabelle um sicherzustellen das keine anderen Einträge existieren bei denen ``id =
$user_id`` als Wert $username enthalten.

Man kann auch einen String an die Ausnahmeklausel angeben damit man einen anderen Operator als **!=** verwenden
kann. Das kann nützlich sein um bei geteilten Schlüsseln zu testen.

.. code-block:: php
   :linenos:

   $email     = 'user@example.com';
   $clause    = $db->quoteInto('email = ?', $email);
   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table'   => 'users',
           'field'   => 'username',
           'exclude' => $clause
   );

   if ($validator->isValid($username)) {
       // Der Benutzername scheint gültig zu sein
   } else {
       // Der Benutzername ist ungültig; die Gründe ausgeben
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

Das obige Beispiel prüft die Tabelle 'users' und stellt sicher das nur ein Eintrag mit beidem, sowohl dem
Benutzernamen ``$username`` als auch der Email ``$email`` gültig ist.

.. _zend.validate.db.database-adapters:

Datenbank Adapter
-----------------

Man kann auch einen Adapter spezifizieren wenn man die Prüfung instanziiert. Das erlaubt es mit Anwendungen zu
arbeiten die mehrere Datenbankadapter verwenden, oder wo kein Standardadapter gesetzt wird. Als Beispiel:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table'   => 'users',
           'field'   => 'id',
           'adapter' => $dbAdapter
       )
   );

.. _zend.validate.db.database-schemas:

Datenbank Schemas
-----------------

Man kann für die eigene Datenbank bei Adaptern wie PostgreSQL und DB/2 ein Schema spezifizieren indem einfach ein
Array mit den Schlüsseln ``table`` und ``schema`` angegeben wird. Anbei ein Beispiel:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table'  => 'users',
           'schema' => 'my',
           'field'  => 'id'
       )
   );


