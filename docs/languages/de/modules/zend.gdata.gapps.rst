.. EN-Revision: none
.. _zend.gdata.gapps:

Google Apps Provisionierung verwenden
=====================================

Google Apps ist ein Service der es Domain Administratoren erlaubt Ihren Benutzern einen gemanagten Zugriff auf
Google Services wie Mail, Kalender und Dokumente & Tabellenkalkulationen zu bieten. Die Provisionierungs *API*
bietet ein programmmäßiges Interface um dieses Service zu konfigurieren. Im speziellen erlaubt es diese *API* den
Administratoren Benutzerzugänge, Nicknamen, Gruppen und Email Listen zu erstellen, zu empfangen, zu verändern und
zu löschen.

Diese Bibliothek implementiert die Version 2.0 der Provisionierungs *API*. Zugriff zum eigenen Konto über die
Provisionierungs *API* muß manuell für jede Domain aktiviert werden die das Google Apps Kontrollpanel verwendet.
Nur bestimmte Kontotpen sind fähig dieses Feature einzuschalten.

Für weitere Information zur Google Apps Provisionierungs *API*, inklusive Anleitungen für das Einschalten des
*API* Zugriffs, kann in die `Provisionierungs API V2.0 Referenz`_ gesehen werden.

.. note::

   **Authentifizierung**

   Die Provisionierungs *API* unterstützt keine Authentifizierung über AuthSub und anonymer Zugriff ist nicht
   gestattet. Alle *HTTP* Verbindungen müssen mit Hilfe der ClientAuth Authentifizierung authentifiziert werden.

.. _zend.gdata.gapps.domain:

Die aktuelle Domain setzen
--------------------------

Um die Provisionierungs *API* zu verwenden muß die Domain, die administriert werden soll, in allen Anfrage *URI*\
s spezifiziert werden. Um die Entwicklung zu vereinfachen, wird diese Information sowohl im Gapps Service und den
Abfrageklassen gespeichert um Sie zu verwenden wenn Abfragen erstellt werden.

.. _zend.gdata.gapps.domain.service:

Setzen der Domain für die Serviceklasse
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um die Domain für die von der Serviceklasse durchgeführten Anfragen zu setzen kann entweder ``setDomain()``
aufgerufen oder die Domain bei der Instanzierung der Serviceklasse spezifiziert werden. Zum Beispiel:

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new ZendGData\Gapps($client, $domain);

.. _zend.gdata.gapps.domain.query:

Die Domain für die Abfrageklasse setzen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Setzen der Domain für Anfrage die durch die Abfrageklasse durchgeführt werden ist ähnlich dem setzen für
die Serviceklasse-entweder wird ``setDomain()`` aufgerufen, oder die Domain wird bei der Erstellung der Abfrage
angegeben. Zum Beispiel:

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $query = new ZendGData_Gapps\UserQuery($domain, $arg);

Wenn eine Serviceklassen Factorymethode verwendet wird um eine Abfrage zu erstellen, setzt die Serviceklasse die
Domain der Abfrage automatisch so das Sie ihrer eigenen Domain entspricht. Als Ergebnis ist es nicht notwendig die
Domain als Teil der Konstruktorargumente zu spezifizieren.

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new ZendGData\Gapps($client, $domain);
   $query = $gdata->newUserQuery($arg);

.. _zend.gdata.gapps.users:

Interaktion mit Benutzern
-------------------------

Jeder Benutzerzugang zu einer Google Apps gehosteten Domain wird als Instanz von ``ZendGData_Gapps\UserEntry``
repräsentiert. Diese Klasse bietet Zugriff zu allen Zugangseigenschaften inklusive Name, Benutzername, Passwort,
Zugriffsrechte und aktuellen Quoten.

.. _zend.gdata.gapps.users.creating:

Erstellen eines Benutzerzugangs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benutzerzugänge können durch den Aufruf der einfachen ``createUser()`` Methode erstellt werden:

.. code-block:: php
   :linenos:

   $gdata->createUser('foo', 'Random', 'User', '••••••••');

Benutzer können durch das Instanzieren eines UserEntry erstellt werden, indem ein Benutzername, ein Name, ein
Familienname und ein Passwort angegeben werden und anschließend ``insertUser()`` am Serviceobjekt aufgerufen wird
um den Eintrag zum Server zu laden.

.. code-block:: php
   :linenos:

   $user = $gdata->newUserEntry();
   $user->login = $gdata->newLogin();
   $user->login->username = 'foo';
   $user->login->password = '••••••••';
   $user->name = $gdata->newName();
   $user->name->givenName = 'Irgendwer';
   $user->name->familyName = 'Benutzer';
   $user = $gdata->insertUser($user);

Das Passwort den Benutzers sollte normalerweise als Klartext angegeben werden. Operional kann das Passwort als
*SHA-1* Schlüssel angegeben werden wenn ``login->passwordHashFunction`` auf '``SHA-1``' gesetzt ist.

.. _zend.gdata.gapps.users.retrieving:

Einen Benutzerzugang erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Individuelle Benutzerzugänge kann man erhalten indem die einfache ``retrieveUser()`` Methode aufgerufen wird. Wenn
der Benutzer nicht gefunden wird, wird ``NULL`` zurückgegeben.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');

   echo 'Benutzername: ' . $user->login->userName . "\n";
   echo 'Name: ' . $user->name->givenName . "\n";
   echo 'Familienname: ' . $user->name->familyName . "\n";
   echo 'Unterbrochen: ' . ($user->login->suspended ? 'Ja' : 'Nein') . "\n";
   echo 'Administrator: ' . ($user->login->admin ? 'Ja' : 'Nein') . "\n"
   echo 'Muss das Passwort ändern: ' .
        ($user->login->changePasswordAtNextLogin ? 'Ja' : 'Nein') . "\n";
   echo 'Hat den Regeln zugestimmt: ' .
        ($user->login->agreedToTerms ? 'Ja' : 'Nein') . "\n";

Benutzer kann man auch erhalten indem eine Instanz von ``ZendGData_Gapps\UserQuery`` erstellt wird, und dessen
username Eigenschaft dem Benutzernamen des Benutzers entspricht den man erhalten will und ``getUserEntry()`` auf
einem Serviceobjekt mit dieser Abfrage aufruft.

.. code-block:: php
   :linenos:

   $query = $gdata->newUserQuery('foo');
   $user = $gdata->getUserEntry($query);

   echo 'Benutzername: ' . $user->login->userName . "\n";
   echo 'Name: ' . $user->login->givenName . "\n";
   echo 'Familien Name: ' . $user->login->familyName . "\n";
   echo 'Unterbrochen: ' . ($user->login->suspended ? 'Ja' : 'Nein') . "\n";
   echo 'Administrator: ' . ($user->login->admin ? 'Ja' : 'Nein') . "\n"
   echo 'Muss das Passwort ändern: ' .
        ($user->login->changePasswordAtNextLogin ? 'Ja' : 'Nein') . "\n";
   echo 'Hat den Regeln zugestimmt: ' .
        ($user->login->agreedToTerms ? 'Ja' : 'Nein') . "\n";

Wenn der spezifizierte Benutzer nicht gefunden werden kann wird eine ServiceException mit einem Fehlercode von
``ZendGData_Gapps\Error::ENTITY_DOES_NOT_EXIST`` geworfen. ServiceExceptions werden in :ref:`dem Kapitel über
Exceptions <zend.gdata.gapps.exceptions>` behandelt.

.. _zend.gdata.gapps.users.retrievingAll:

Alle Benutzer in einer Domain erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Benutzer in einer Domäne zu erhalten kann die einfache ``retrieveAllUsers()`` Methode aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllUsers();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }

Das wird ein ``ZendGData_Gapps\UserFeed`` Objekt erstellen welches jeden Benutzer dieser Domain enthält.

Alternativ kann ``getUserFeed()`` ohne Optionen aufgerufen werden. Es ist zu beachten das dieser Feed bei
größeren Domains durch den Server in Seiten ausgegeben werden kann. Über weitere Informationen der Ausgabe in
Seiten siehe :ref:`das Kapitel über Seiten <zend.gdata.introduction.paging>`.

.. code-block:: php
   :linenos:

   $feed = $gdata->getUserFeed();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }

.. _zend.gdata.gapps.users.updating:

Einen Benutzerzugang aktualisieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der einfachste Weg um einen Benutzerzugang zu aktualisieren ist es den Benutzer wie in der vorherigen Sektion
beschrieben zu empfangen, jegliche gewünschte Änderungen durchzuführen und anschließend ``save()`` auf diesem
Benutzer aufzurufen. Jede gemachte Änderung wird an den Server weitergegeben.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->name->givenName = 'Foo';
   $user->name->familyName = 'Bar';
   $user = $user->save();

.. _zend.gdata.gapps.users.updating.resettingPassword:

Ein Benutzerpasswort zurücksetzen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Benutzerpasswort kann auf einen neuen Wert zurückgesetzt werden indem die ``login->password`` Eigenschaft
aktualisiert wird.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->password = '••••••••';
   $user = $user->save();

Es ist zu beachten das es nicht möglich ist ein Passwort auf diesem Weg wiederherzustellen da gespeicherte
Passwörter aus Sicherheitsgründern nicht über die Provisionierungs *API* verfügbar gemacht werden.

.. _zend.gdata.gapps.users.updating.forcingPasswordChange:

Einen Benutzer zwingen sein Passwort zu ändern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Benutzer kann dazu gezwungen werden sein Passwort bei seinem nächsten Login zu ändern, indem die
``login->changePasswordAtNextLogin`` Eigenschaft auf ``TRUE`` gesetzt wird.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->changePasswordAtNextLogin = true;
   $user = $user->save();

Genauso kann das rückgängig gemacht werden indem die ``login->changePasswordAtNextLogin`` Eigenschaft auf
``FALSE`` gesetzt wird.

.. _zend.gdata.gapps.users.updating.suspendingAccount:

Einen Benutzerzugang unterbrechen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benutzer können daran gehindert werden sich anzumelden ohne das Ihr Benutzerzugang gelöscht wird indem Ihr
Benutzerzugang **unterbrochen** wird. Zugänge können unterbrochen oder wiederhergestellt werden indem die
einfachen ``suspendUser()`` und ``restoreUser()`` Methoden verwendet werden:

.. code-block:: php
   :linenos:

   $gdata->suspendUser('foo');
   $gdata->restoreUser('foo');

Alternativ kann die Eigenschaft ``login->suspended`` des Benutzerzugangs auf ``TRUE`` gesetzt werden.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->suspended = true;
   $user = $user->save();

Um den Benutzerzugang wiederherzustellen muß die ``login->suspended`` Eigenschaft auf ``FALSE`` gesetzt werden.

.. _zend.gdata.gapps.users.updating.grantingAdminRights:

Administrative Rechte vergeben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benutzern kann die Möglichkeit gegeben werden die Domain zu verwalten durch das setzen Ihrer ``login->admin``
Eigenschaft auf ``TRUE``.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->admin = true;
   $user = $user->save();

Und wie erwartet, entfernt das Setzen der Eigenschaft ``login->admin``, des Benutzers auf ``FALSE``, dessen
administrative Rechte.

.. _zend.gdata.gapps.users.deleting:

Löschen eines Benutzerzugangs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Einen Benutzerzugang zu löschen zu dem man bereits ein UserEntry hat, ist so einfach wie der Aufruf von
``delete()`` auf diesem Eintrag.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->delete();

Wenn man keinen Zugriff auf ein UserEntry Objekt für einen Zugang hat, kann die einfache ``deleteUser()`` Methode
verwendet werden.

.. code-block:: php
   :linenos:

   $gdata->deleteUser('foo');

.. _zend.gdata.gapps.nicknames:

Mit Spitznamen interagieren
---------------------------

Spitznamen arbeiten als Email Aliase für bestehende Benutzer. Jeder Spitzname enthält genau zwei
Schlüsseleigenschaften: Seinen Namen und seinen Eigentümer. Jede Email die zu einem Spitznamen adressiert wurde
wird zu dem Benutzer weitergeleitet der diesen Spitznamen besitzt.

Spitznamen werden repräsentiert als Instanz von ``ZendGData_Gapps\NicknameEntry``.

.. _zend.gdata.gapps.nicknames.creating:

Erstellen eines Spitznamens
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Spitznamen können durch den Aufruf der einfachen ``createNickname()`` Methode erstellt werden:

.. code-block:: php
   :linenos:

   $gdata->createNickname('foo', 'bar');

Spitznamen können auch durch das instanzieren eines NichnameEntry erstellt werden, wobei der Spitzname mit einem
Namen und einem Eigentümer ausgestattet wird, und dann ``insertNickname()`` auf einem Service Objekt aufgerufen
wird, um den Eintrag zu einem Server hochzuladen.

.. code-block:: php
   :linenos:

   $nickname = $gdata->newNicknameEntry();
   $nickname->login = $gdata->newLogin('foo');
   $nickname->nickname = $gdata->newNickname('bar');
   $nickname = $gdata->insertNickname($nickname);

.. _zend.gdata.gapps.nicknames.retrieving:

Einen Spitznamen empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^

Spitznamen können durch den Aufruf der bequemen ``retrieveNickname()`` Methode empfangen werden. Sie gibt ``NULL``
zurück wenn der Benutzer nicht gefunden wurde.

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');

   echo 'Spitzname: ' . $nickname->nickname->name . "\n";
   echo 'Eigentümer: ' . $nickname->login->username . "\n";

Individuelle Spitznamen können durch Erstellung einer ``ZendGData_Gapps\NicknameQuery`` Instanz erhalten werden,
indem dessen nickname Eigenschaft dem Spitznamen gleichgesetzt wird der empfangen werden soll, und
``getNicknameEntry()`` auf einem Server Objekt mit dieser Abfrage aufgerufen wird.

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery('bar');
   $nickname = $gdata->getNicknameEntry($query);

   echo 'Spitzname: ' . $nickname->nickname->name . "\n";
   echo 'Eigentümer: ' . $nickname->login->username . "\n";

Genau wie bei den Benutzern wird eine ServiceException geworfen wenn kein entsprechender Spitzname gefunden wurde
und ein Fehlercode von ``ZendGData_Gapps\Error::ENTITY_DOES_NOT_EXIST`` zurückgegeben. Auch das wird in :ref:`dem
Kapitel über Exceptions <zend.gdata.gapps.exceptions>` beschrieben.

.. _zend.gdata.gapps.nicknames.retrievingUser:

Alle Spitznamen eines Benutzers erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Spitznamen zu erhalten die einem angegebenen Benutzer assoziiert sind, kann die bequeme
``retrieveNicknames()`` Methode aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveNicknames('foo');

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

Das erzeugt ein ``ZendGData_Gapps\NicknameFeed`` Objekt welches jeden mit dem spezifizierten Benutzer assoziierten
Spitznamen enthält.

Alternativ setzt das Erstellen einer neuen ``ZendGData_Gapps\NicknameQuery`` dessen username Eigenschaft auf den
gewünschten Benutzer, und überträgt die Abfrage durch den Aufruf von ``getNicknameFeed()`` auf dem Service
Objekt.

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery();
   $query->setUsername('foo');
   $feed = $gdata->getNicknameFeed($query);

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

.. _zend.gdata.gapps.nicknames.retrievingAll:

Empfangen aller Spitznamen in einer Domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Spitznamen in einerm Feed zu empfangen, muß einfach die bequeme Methode ``retrieveAllNicknames()``
aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllNicknames();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

Das wird ein ``ZendGData_Gapps\NicknameFeed`` Objekt erstellen welches jeden Spitznamen in der Domain enthält.

Alternativ kann ``getNicknameFeed()`` auf einem Service Objekt ohne Argumente aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->getNicknameFeed();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

.. _zend.gdata.gapps.nicknames.deleting:

Löschen eines Spitznamens
^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Spitznamen zu löschen zu dem man bereits einen NicknameEntry hält muß einfach nur ``delete()`` auf
diesem Eintrag aufgerufen werden.

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');
   $nickname->delete();

Für Spitznamen zu denen man keinen NicknameEntry hält, kann die bequeme ``deleteNickname()`` Methode verwendet
werden.

.. code-block:: php
   :linenos:

   $gdata->deleteNickname('bar');

.. _zend.gdata.gapps.groups:

Mit Gruppen interagieren
------------------------

Google Gruppen erlauben es Personen Nachrichten zu senden so wie eine Email Liste. Google missbilligt die *API* der
Email Listen. Google Gruppen bieten einige nette Features wie verschachtelte Gruppen und Gruppen Besitzer. Wenn man
mit einer neuen Email Liste beginnen will, ist es empfehlenswert statt dessen Google Gruppen zu verwenden. Google's
Email Liste ist nicht mit Google Gruppen kompatibel. Wenn man also eine Email Liste erstellt, scheint Sie nicht als
Gruppe auf. Das Gegenteil ist natürlich genauso wahr.

Jede Gruppe an einer Domain wird als Instanz von ``ZendGData_Gapps\GroupEntry`` repräsentiert.

.. _zend.gdata.gapps.groups.creating:

Erstellen einer Gruppe
^^^^^^^^^^^^^^^^^^^^^^

Gruppen können erstellt werden indem die bequeme Methode ``createGroup()`` aufgerufen wird:

.. code-block:: php
   :linenos:

   $gdata->createGroup('friends', 'Freundeskreis');

Gruppen können erstellt werden indem GroupEntry instanziert wird, eine Gruppen ID und ein Name für die Gruppe
angegeben wird, und dann ``insertGroup()`` auf dem Service Objekt aufgerufen wird um den Eintrag zum Server
hochzuladen.

.. code-block:: php
   :linenos:

   $group = $gdata->newGroupEntry();

   $properties[0] = $this->newProperty();
   $properties[0]->name = 'groupId';
   $properties[0]->value = 'friends';
   $properties[1] = $this->newProperty();
   $properties[1]->name = 'groupName';
   $properties[1]->value = 'Freundeskreis';

   $group->property = $properties;

   $group = $gdata->insertGroup($group);

.. _zend.gdata.gapps.groups.retrieveGroup:

Eine individuelle Gruppe empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um eine individuelle Gruppe zu erhalten, muss die bequeme Methode ``retrieveGroup()`` aufgerufen werden:

.. code-block:: php
   :linenos:

   $entry = $gdata->retrieveGroup('friends');

   foreach ($entry->property as $p) {
       echo "Name der Eigenschaft: " . $p->name;
       echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
   }

Das erstellt ein ``ZendGData_Gapps\GroupEntry`` Objekt welches die Eigenschaften der Gruppe enthält.

Alternativ kann ein neuer ``ZendGData_Gapps\GroupQuery`` erstellt, seine groupId Eigenschaft auf die gewünschte
Gruppen Id gesetzt werden, und die Abfrage übermittelt werden indem ``getGroupEntry()`` auf dem Service Objekt
aufgerufen wird.

.. code-block:: php
   :linenos:

   $query = $gdata->newGroupQuery();
   $query->setGroupId('friends');
   $entry = $gdata->getGroupEntry($query);

   foreach ($entry->property as $p) {
       echo "Name der Eigenschaft: " . $p->name;
       echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
   }

.. _zend.gdata.gapps.groups.retrievingAll:

Alle Gruppen einer Domäne empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Gruppen in einer Domäne zu erhalten muss die bequeme Methode ``retrieveAllGroups()`` aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllGroups();

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

Dies erstellt ein ``ZendGData_Gapps\GroupFeed`` Objekt welches jede Gruppe der Domain enthält.

Alternativ kann ``getGroupFeed()`` auf einem Service Objekt ohne Argumente aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->getGroupFeed();

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

.. _zend.gdata.gapps.groups.deleting:

Eine Gruppe löschen
^^^^^^^^^^^^^^^^^^^

Um eine Gruppe zu löschen kann die bequeme Methode ``deleteGroup()`` aufgerufen werden:

.. code-block:: php
   :linenos:

   $gdata->deleteGroup('friends');

.. _zend.gdata.gapps.groups.updating:

Eine Gruppe aktualisieren
^^^^^^^^^^^^^^^^^^^^^^^^^

Gruppen können aktualisiert werden indem die bequeme Methode ``updateGroup()`` aufgerufen wird:

.. code-block:: php
   :linenos:

   $gdata->updateGroup('group-id-here', 'Name der Gruppe hier');

Der erste Parameter wird benötigt. Der zweite, dritte und vierte Parameter welche den Namen der Gruppe, die
Beschreibung der Gruppe und die Email Erlaubnis repräsentieren, sind alle Optional. Wenn eine dieser optionalen
Parameter auf null gesetzt wird, dann wird dieses Element nicht aktualisiert.

.. _zend.gdata.gapps.groups.retrieve:

Empfangen aller Gruppen bei denen eine Person Mitglied ist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Gruppen zu erhalten bei denen eine Spezielle Person Mitglied ist, kann die bequeme Methode
``retrieveGroups()`` aufgerufen werden:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveGroups('baz@somewhere.com');

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

Dies erstellt ein ``ZendGData_Gapps\GroupFeed`` Objekt welches jede Gruppe enthält die mit dem spezifizierten
Mitglied assoziiert ist.

Alternativ kann eine neue ``ZendGData_Gapps\GroupQuery`` erstellt werden, die Eigenschaft member auf die
gewünschte Email Adresse gesetzt, und die Abfrage durch Aufruf von ``getGroupFeed()`` auf dem Service Objekt
übermittelt werden.

.. code-block:: php
   :linenos:

   $query = $gdata->newGroupQuery();
   $query->setMember('baz@somewhere.com');
   $feed = $gdata->getGroupFeed($query);

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

.. _zend.gdata.gapps.groupMembers:

Mit Gruppenmitgliedern interagieren
-----------------------------------

Jedes Mitglied welches bei einer Gruppe eingeschrieben ist wird durch eine Instanz von
``ZendGData_Gapps\MemberEntry`` repräsentiert. Durch diese Klasse können individuelle Empfänger bei Gruppen
hinzugefügt und gelöscht werden.

.. _zend.gdata.gapps.groupMembers.adding:

Ein Mitglied zu einer Gruppe hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um ein Mitglied zu einer Gruppe hinzuzufügen muss einfach die bequeme Methode ``addMemberToGroup()`` aufgerufen
werden:

.. code-block:: php
   :linenos:

   $gdata->addMemberToGroup('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.groupMembers.check:

Prüfen um zu sehen ob ein Mitglied einer Gruppe angehört
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um zu prüfen ob ein Mitglied einer Gruppe angehört, muss einfach die bequeme Methode ``isMember()`` aufgerufen
werden:

.. code-block:: php
   :linenos:

   $isMember = $gdata->isMember('bar@somewhere.com', 'friends');
   var_dump($isMember);

Die Methode gibt einen Boolschen Wert zurück. Wenn das Mitglied der spezifizierten Gruppe angehört, gibt die
Methode ein true zurück, andernfalls gibt Sie ein false zurück.

.. _zend.gdata.gapps.groupMembers.removing:

Ein Mitglied von einer Gruppe entfernen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um ein Mitglied von einer Gruppe zu entfernen muss die bequeme Methode ``removeMemberFromGroup()`` aufgerufen
werden:

.. code-block:: php
   :linenos:

   $gdata->removeMemberFromGroup('baz', 'friends');

.. _zend.gdata.gapps.groupMembers.retrieving:

Die Liste der Mitglieder einer Gruppe erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die bequeme Methode ``retrieveAllMembers()`` kann verwendet werden um die Liste der Mitglieder einer Gruppe zu
erhalten:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllMembers('friends');

   foreach ($feed as $member) {
       foreach ($member->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
   }

Alternativ kann ein neuer MemberQuery erstellt, dessen Eigenschaft groupId auf die passende und gewünschte Gruppen
Id gesetzt und ``getMemberFeed()`` auf einem Service Objekt aufgerufen werden.

.. code-block:: php
   :linenos:

   $query = $gdata->newMemberQuery();
   $query->setGroupId('friends');
   $feed = $gdata->getMemberFeed($query);

   foreach ($feed as $member) {
       foreach ($member->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
   }

Das erstellt ein ``ZendGData_Gapps\MemberFeed`` Objekt welches jedes Mitglied der ausgewählten Gruppe enthält.

.. _zend.gdata.gapps.groupOwners:

Mit Gruppen Eigentümern interagieren
------------------------------------

Jeder Eigentümer der mit einer Gruppe assoziiert ist wird durch eine Instanz von ``ZendGData_Gapps\OwnerEntry``
repräsentiert. Durch diese Klasse können individuelle Eigentümer hinzugefügt und von Gruppen entfernt werden.

.. _zend.gdata.gapps.groupOwners.adding:

Einen Eigentümer einer Gruppe hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einer Gruppe einen Eigentümer hinzuzufügen muss einfach die bequeme Methode ``addOwnerToGroup()`` aufgerufen
werden:

.. code-block:: php
   :linenos:

   $gdata->addOwnerToGroup('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.groupOwners.retrieving:

Die Liste der Eigentümer einer Gruppe erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die bequeme Methode ``retrieveGroupOwners()`` kann verwendet werden um die Liste der Eigentümer einer Gruppe zu
erhalten:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveGroupOwners('friends');

   foreach ($feed as $owner) {
       foreach ($owner->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
   }

Alternativ kann ein neuer OwnerQuery erstellt, seine Eigenschaft groupId auf die passende und gewünschte Gruppen
Id gesetzt und ``getOwnerFeed()`` auf einem Service Objekt aufgerufen werden.

.. code-block:: php
   :linenos:

   $query = $gdata->newOwnerQuery();
   $query->setGroupId('friends');
   $feed = $gdata->getOwnerFeed($query);

   foreach ($feed as $owner) {
       foreach ($owner->property as $p) {
           echo "Name der Eigenschaft: " . $p->name;
           echo "\nWert der Eigenschaft: " . $p->value . "\n\n";
       }
   }

Das erstelle ein ``ZendGData_Gapps\OwnerFeed`` Objekt welches jedes Mitglied der ausgewählten Gruppe enthält.

.. _zend.gdata.gapps.groupOwners.check:

Prüfen um zu sehen ob ein Email der Eigentümer einer Gruppe ist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um zu prüfen ob ein Email der Eigentümer einer Gruppe ist, kann einfach die bequeme Methode ``isOwner()``
aufgerufen werden:

.. code-block:: php
   :linenos:

   $isOwner = $gdata->isOwner('bar@somewhere.com', 'friends');
   var_dump($isOwner);

Die Methode gibt einen boolschen Wert zurück. Wenn die Email der Eigentümer der spezifizierten Gruppe ist, gibt
die Methode true zurück, andernfalls gibt sie false zurück.

.. _zend.gdata.gapps.groupOwners.removing:

Einen Eigentümer von einer Gruppe entfernen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Eigentümer von einer Gruppe zu entfernen kann die bequeme Methode ``removeOwnerFromGroup()`` aufgerufen
werden:

.. code-block:: php
   :linenos:

   $gdata->removeOwnerFromGroup('baz@somewhere.com', 'friends');

.. _zend.gdata.gapps.emailLists:

Mit Email Listen interagieren
-----------------------------

Email Listen erlauben verschiedenen Benutzern Emails zu empfangen die zu einer einzelnen Email Adresse adressiert
sind. Benutzer müssen keine Teilnehmer dieser Domain sein um sich in eine Email Liste einzuschreiben, wen deren
komplette Email Adresse (inklusive Domain) verwendet wird.

Jede Email Liste einer Domain wird als Instanz von ``ZendGData_Gapps\EmailListEntry`` repräsentiert.

.. _zend.gdata.gapps.emailLists.creating:

Erstellen einer Email Liste
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Email Listen können durch den Aufruf der bequemen ``createEmailList()`` Methode erstellt werden:

.. code-block:: php
   :linenos:

   $gdata->createEmailList('friends');

Email Listen können auch durch die Instanzierung von EmailListEntry erstellt werden, indem ein Name für die Liste
angegeben wird, und anschließend ``insertEmailList()`` auf dem Service Objekt aufgerufen wird um den Eintrag zum
Server hochzuladen.

.. code-block:: php
   :linenos:

   $list = $gdata->newEmailListEntry();
   $list->emailList = $gdata->newEmailList('friends');
   $list = $gdata->insertEmailList($list);

.. _zend.gdata.gapps.emailList.retrieve:

Empfangen aller Email Listen bei denen ein Empfänger eingeschrieben ist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Email Lsiten zu denen ein spezieller Empfänger eingeschrieben ist zu empfangen, muß die bequeme
``retrieveEmailLists()`` Methode aufgerufen werden:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveEmailLists('baz@somewhere.com');

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

Das erstellt ein ``ZendGData_Gapps\EmailListFeed`` Objekt welches jede Email Liste enthält die mit dem speziellen
Empfänger assoziiert ist.

Alternativ kann ein neues ``ZendGData_Gapps\EmailListQuery`` erstellt werden, dessen recipient Eigenschaft auf die
gewünschte Email Adresse gesetzt werden, und die Abfrage durch den Aufruf von ``getEmailListFeed()`` auf dem
Service Objekt übermittelt werden.

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListQuery();
   $query->setRecipient('baz@somewhere.com');
   $feed = $gdata->getEmailListFeed($query);

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zend.gdata.gapps.emailLists.retrievingAll:

Empfangen aller Email Listen in einer Domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Email Listen in einer Domain zu erhalten, muß die bequeme ``retrieveAllEmailLists()`` Methode aufgerufen
werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllEmailLists();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

Das erzeugt ein ``ZendGData_Gapps\EmailListFeed`` Objekt welches jede Email Liste der Domain enthält.

Alternativ kann ``getEmailListFeed()`` auf dem Service Objekt ohne Argumente aufgerufen werden.

.. code-block:: php
   :linenos:

   $feed = $gdata->getEmailListFeed();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zend.gdata.gapps.emailList.deleting:

Löschen einer Email Liste
^^^^^^^^^^^^^^^^^^^^^^^^^

Um eine Email Liste zu löschen, muß die bequeme ``deleteEmailList()`` Methode aufgerufen werden:

.. code-block:: php
   :linenos:

   $gdata->deleteEmailList('friends');

.. _zend.gdata.gapps.emailListRecipients:

Mit den Empfängern von Email Listen interagieren
------------------------------------------------

Jeder Empfänger der bei einer Email Liste eingeschrieben ist, wird durch eine Instanz von
``ZendGData_Gapps\EmailListRecipient`` repräsentiert. Durch diese Klasse können individuelle Empfänger
hinzugefügt und von Email Listen entfernt werden.

.. _zend.gdata.gapps.emailListRecipients.adding:

Einen Empfängern zu einer Email Liste hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Empfänger zu einer Email Liste hinzuzufügen, muß einfach die bequeme ``addRecipientToEmailList()``
Methode aufgerufen werden:

.. code-block:: php
   :linenos:

   $gdata->addRecipientToEmailList('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.emailListRecipients.retrieving:

Eine Liste von Empfängern einer Email Liste erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die bequeme ``retrieveAllRecipients()`` Methode kann verwendet werden um die Liste der Empfänger einer Email Liste
zu erhalten:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllRecipients('friends');

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

Alternativ kann ein neuer EmailListRecipientQuery erstellt werdne, dessen emailListName Eigenschaft auf die
gewünschte Email Liste gesetzt werden, und ``getEmailListRecipientFeed()`` auf dem Service Objekt aufgerufen
werden.

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListRecipientQuery();
   $query->setEmailListName('friends');
   $feed = $gdata->getEmailListRecipientFeed($query);

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

Das Erstellt ein ``ZendGData_Gapps\EmailListRecipientFeed`` Objekt welche jeden Empfänger für die ausgewählte
Email Liste enthält.

.. _zend.gdata.gapps.emailListRecipients.removing:

Einen Empfänger von einer Email Liste entfernen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Empfänger von einer Email Liste zu entfernen, muß die bequeme ``removeRecipientFromEmailList()`` Methode
aufgerufen werden:

.. code-block:: php
   :linenos:

   $gdata->removeRecipientFromEmailList('baz@somewhere.com', 'friends');

.. _zend.gdata.gapps.exceptions:

Fehler handhaben
----------------

Zusätzlich zur Standardsuite von Ausnahmen die von ``ZendGData`` geworfen werden, können Anfragen welche die
Provisionierungs *API* verwenden auch eine ``ZendGData_Gapps\ServiceException`` werfen. Diese Ausnahme zeigt das
ein *API* spezieller Fehler aufgetreten ist welche verhindert das die Anfrage fertiggestellt werden kann.

Jede ServiceException Instanz kann einen oder mehrere Fehler Objekte enthalten. Jedes dieser Objekte enthalten
einen Fehlercode, Grund und (optional) die Eingave welche die Ausnahme getriggert hat. Eine komplette Liste von
bekannten Fehlercodes wird in der Zend Framework *API* Dokumentation unter ``ZendGData_Gapps\Error`` angeboten.
Zusätzlich ist die maßgebliche Fehlerliste online unter `Google Apps Provisioning API V2.0 Reference: Appendix
D`_ vorhanden.

Wärend die komplette Liste von Fehler die empfangen wurden in ServiceException als Array vorhanden sind das man
durch den Aufruf von ``getErrors()`` erhalten kann, ist es oft bequemer zu wissen ob ein spezieller Fehler
aufgetreten ist. Für diese Fälle kann das Vorhandensein eines Fehler durch den Aufruf von ``hasError()`` erkannt
werden.

Das folgende Beispiel demonstriert wie erkannt werden kann ob eine angefragte Ressource nicht existiert und der
Fehler korrekt behandelt werden kann:

.. code-block:: php
   :linenos:

   function retrieveUser ($username) {
       $query = $gdata->newUserQuery($username);
       try {
           $user = $gdata->getUserEntry($query);
       } catch (ZendGData_Gapps\ServiceException $e) {
           // Den Benutzer auf null setzen wen er nicht gefunden wurde
           if ($e->hasError(ZendGData_Gapps\Error::ENTITY_DOES_NOT_EXIST)) {
               $user = null;
           } else {
               throw $e;
           }
       }
       return $user;
   }



.. _`Provisionierungs API V2.0 Referenz`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html
.. _`Google Apps Provisioning API V2.0 Reference: Appendix D`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html#appendix_d
