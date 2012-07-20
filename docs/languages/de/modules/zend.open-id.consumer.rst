.. _zend.openid.consumer:

Zend_OpenId_Consumer Grundlagen
===============================

``Zend_OpenId_Consumer`` kann verwendet werden um OpenID Authentifizierung auf Webseiten zu implementieren.

.. _zend.openid.consumer.authentication:

OpenID Authentifikation
-----------------------

Aus der Sicht eines Website Entwicklers, geschieht die Authentifikation von OpenID in drei Schritten:

. Zeige das OpenID Authentifikations Formular

. Akzeptiere die OpenID Identität und übergib Sie an den OpenID Provider

. Überprüfe die Antwort des OpenID Providers

Das OpenID Authentifikations Protokoll benötigt aktuell mehrere, aber viele von Ihnen sind innerhalb von
``Zend_OpenId_Consumer`` gekapselt, und deshalb für den Entwickler transparent.

Der End-Benutzer initiiert den OpenID Authentifikations Prozess indem er Seine oder Ihre Identifikations Daten in
der entsprechenden Form übermittelt. Das folgende Beispiel zeigt ein einfaches Formular das einen OpenID
Identifikator akzeptiert. Es gilt zu beachten dass das Beispiel nur einen Login demonstriert.

.. _zend.openid.consumer.example-1:

.. rubric:: Das einfache OpenID Login Formular

.. code-block:: php
   :linenos:

   <html><body>
   <form method="post" action="example-1_2.php"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier">
   <input type="submit" name="openid_action" value="login">
   </fieldset></form></body></html>

Dieses Formular übergibt bei der Übertragung eine OpenID Identität an das folgende *PHP* Skript welches den
zweiten Schritt der Authentifizierung durchführt. Das *PHP* Skript muss in diesem Schritt nur die
``Zend_OpenId_Consumer::login()`` Methode aufrufen. Das erste Argument dieser Methode akzeptiert eine OpenID
Identität, und das zweite ist die *URL* des Skripts das den dritten und letzten Schritt der Authentifizierung
behandelt.

.. _zend.openid.consumer.example-1_2:

.. rubric:: Der Authentifizierungs Anfrage Handler

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'], 'example-1_3.php')) {
       die("OpenID Login fehlgeschlagen.");
   }

Die ``Zend_OpenId_Consumer::login()`` Methode führt eine Suche nach einem gegebenen Identifikator durch und
findet, bei Erfolg, die Adresse des Identitäts Providers und dessen Lokalen Idenzifizierer durch. Dann erstellt es
eine Assoziation zum gegebenen Provider sodas beide, die Site und der Provider, um das gleiche Geheimnis teilen das
verwendet wird um nachfolgende Nachrichten zu verschlüsseln. Letztendlich wird eine Authentifikations Anfrage an
den Provider übergeben. Diese Anfrage leitet den Web-Browser des End-Benutzers zu einer OpenID Server Site um, wo
der Benutzer die Möglichkeit habt den Authentifizierungs Prozess fortzuführen.

Ein OpenID Provider fragt nochmalerweise Benutzer nach Ihrem Passwort (wenn Sie vorher noch nicht angemeldet
waren), wenn der Benutzer dieser Site vertraut und welche Informationen zu der Site zurückgegeben werden können.
Diese Interaktionen sind für den OpenID Konsument nicht sichtbar sodas es für Ihn keine Möglichkeit gibt das
Benutzerpasswort oder andere Informationen zu bekommen bei denen der Benutzer nicht gesagt hat das der OpenId
Provider Sie teilen darf.

Bei Erfolg wird ``Zend_OpenId_Consumer::login()`` nicht zurückkommen, sondern eine *HTTP* Umleitung durchführt.
Trotzdem wird im Falle eine Fehler ein ``FALSE`` zurückgeben wird. Fehler können durch eine ungültige
Identität, einen Provider der nicht antwortet, Kommunikations Fehler, usw. auftreten.

Der dritte Schritt der Authentifikation wird durch die Antwort vom OpenID Provider initiiert, nachdem dieser das
Benutzerpasswort authentifiziert hat. Diese Antwort wird indirekt, als *HTTP* Umleitung übergeben, indem der
Webbrowsers des End-Benutzers verwendet wird. Der Konsument muß nun einfach prüfen ob die Antwort gültig ist.

.. _zend.openid.consumer.example-1_3:

.. rubric:: Der Authentifizierungs Antwort Prüfer

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if ($consumer->verify($_GET, $id)) {
       echo "GÜLTIG ". htmlspecialchars($id);
   } else {
       echo "UNGÜLTIG" . htmlspecialchars($id);
   }

Diese Prüfung wird durchgeführt indem die ``Zend_OpenId_Consumer::verify`` Methode verwendet wird, welche ein
ganzes Array von HTTP Anfrage Argumenten entgegennimmt und prüft ob diese Antwort durch den OpenID Provider
richtig signiert wurde. Sie kann die erhaltete OpenID Identität, die vom Endbenutzer im ersten Schritt angegeben
wurde, zuordnen, indem ein zweites, optionales, Argument eingegeben wird.

.. _zend.openid.consumer.combine:

Alle Schritte in einer Seite kombinieren
----------------------------------------

Das folgende Beispiel kombiniert alle drei Schritte in einem Skript. Es bietet keine neuen Funktionalitäten. Der
Vorteil der Verwendung eines einzelnen Skripts ist, das Entwickler keine *URL*'s für das Skript definieren muss,
das den nächsten Schritt durchführt. Standardmäßig verwenden alle Schritte die gleiche *URL*. Trotzdem enthält
das Skript nun etwas Dispatchcode um den korrekten Code für jeden Schritt der Authentifikation aufzurufen.

.. _zend.openid.consumer.example-2:

.. rubric:: Das komplette Skript für ein OpenID Login

.. code-block:: php
   :linenos:

   $status = "";
   if (isset($_POST['openid_action']) &&
       $_POST['openid_action'] == "login" &&
       !empty($_POST['openid_identifier'])) {

       $consumer = new Zend_OpenId_Consumer();
       if (!$consumer->login($_POST['openid_identifier'])) {
           $status = "OpenID Login fehlgeschlagen.";
       }
   } else if (isset($_GET['openid_mode'])) {
       if ($_GET['openid_mode'] == "id_res") {
           $consumer = new Zend_OpenId_Consumer();
           if ($consumer->verify($_GET, $id)) {
               $status = "GÜLTIG " . htmlspecialchars($id);
           } else {
               $status = "UNGÜLTIG " . htmlspecialchars($id);
           }
       } else if ($_GET['openid_mode'] == "cancel") {
           $status = "ABGEBROCHEN";
       }
   }
   ?>
   <html><body>
   <?php echo "$status<br>" ?>
   <form method="post">
   <fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value=""/>
   <input type="submit" name="openid_action" value="login"/>
   </fieldset>
   </form>
   </body></html>

Zusätzlich unterscheidet dieser Code zwischen abgebrochen und ungültigen Authentifizierungs Antworten. Der
Provider gibt eine abgebrochene Antwort zurück, wenn der Identitäts Provider die gegebene Identität nicht
unterstützt, der Benutzer nicht angemeldet ist, oder der Benutzer der Seite nicht vertraut. Eine ungültige
Antwort zeigt an das die Antwort dem OpenId Protokoll nicht entspricht oder nicht korrekt signiert wurde.

.. _zend.openid.consumer.realm:

Konsumenten Bereiche
--------------------

Wenn eine OpenID-aktivierte Site eine Authentifikations Anfrage an einen Provider übergibt, identifiziert diese
sich selbst mit einer Bereichs *URL*. Diese *URL* kann als Root der vertrauten Site betrachtet werden. Wenn der
Benutzer der Bereichs *URL* vertraut, dann sollte er oder Sie das auch bei der passenden und den untergeordneten
*URL*\ s tun.

Standardmäßig wird die Bereichs *URL* automatisch auf die *URL* des Verzeichnisses gesetzt indem das Login Skript
ist. Dieser Standardwert ist für die meisten, aber nicht alle, Fälle ausreichend. Manchmal sollte einer komplette
Domain, und nicht einem Verzeichnis vertraut werden. Oder sogar einer Kombination von verschiedenen Servern in
einer Domain.

Um den Standardwert zu überschreiben müssen Entwickler die Bereichs *URL* als drittes Argument an die
``Zend_OpenId_Consumer::login`` Methode übergeben. Im folgenden Beispiel fragt eine einzelne Interaktion nach
vertrauten Zugriff auf alle php.net Sites.

.. _zend.openid.consumer.example-3_2:

.. rubric:: Authentifizierungs Anfrage für spezielle Bereiche

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-3_3.php',
                         'http://*.php.net/')) {
       die("OpenID Login fehlgeschlagen.");
   }

Dieses Beispiel implementiert nur den zweiten Schritt der Authentifikation; der erste und dritte Schritt sind die
identisch mit dem ersten Beispiel.

.. _zend.openid.consumer.check:

Sofortige Prüfung
-----------------

In einigen Fällen muß eine Anwendung nur prüfen ob ein Benutzer bereits auf einem vertrauten OpenID Server
eingeloggt ist ohne einer Interaktion mit dem Benutzer. Die ``Zend_OpenId_Consumer::check`` Methode führt genau
das durch. Sie wird mit den gleichen Argumenten wie ``Zend_OpenId_Consumer::login`` ausgeführt, aber Sie zeigt dem
Benutzer keine OpenID Serverseiten. Aus Sicht des Benutzers ist dieser Prozess transparent, und es scheint als ob
er die Site nie verlässt. Der dritte Schritt ist erfolgreich wenn der Benutzer bereits angemeldet ist und der Site
vertraut, andernfalls ist er erfolglos.

.. _zend.openid.consumer.example-4:

.. rubric:: Sofortige Prüfung ohne Interaktion

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->check($_POST['openid_identifier'], 'example-4_3.php')) {
       die("OpenID Login fehlgeschlaten.");
   }

Das Beispiel implementiert nur den zweiten Schritt der Authentifikation; der erste und dritte Schritt sind dem
obigen Beispiel ähnlich.

.. _zend.openid.consumer.storage:

Zend_OpenId_Consumer_Storage
----------------------------

Es gibt drei Schritte beim Authentifizierungs Prozess von OpenID, und jeder wird durch eine separate *HTTP* Anfrage
durchgeführt. Um die Informationen zwischen den Anfragen zu speichern verwendet ``Zend_OpenId_Consumer`` einen
internen Speicher.

Entwickler müssen sich nicht notwendigerweise um die Speicherung kümmern weil ``Zend_OpenId_Consumer``
standardmäßig einen dateibasierten Speicher im temporären Verzeichnis verwendet, ähnlich wie *PHP* Sessions.
Trotzdem ist dieser Speicher nicht in allen Situationen richtig. Einige Entwickler wollen Informationen in einer
Datenbank speichern, wärend andere einen üblichen Speicher für große Server-Farmen verwenden wollen.
Glücklicherweise können Entwickler den Standardspeicher sehr einfach mit Ihrem eigenen tauschen. Um einen eigenen
Speichermechanismus zu spezifizieren muß nur die ``Zend_OpenId_Consumer_Storage`` Klasse erweitert werden und
diese Unterklasse dem ``Zend_OpenId_Consumer`` Konstruktor im ersten Argument übergeben werden.

Das folgende Beispiel demonstriert einen einfachen Speicher Mechanismus der ``Zend_Db`` als sein Backend verwendet
und drei Gruppen von Funktionen bereitstellt. Der erste Gruppe enthält Funktionen für die Arbeit mit
Assoziationen, wärend die zweite Gruppe erkannte Informationen cacht, und die dritte Gruppe kann verwendet werden
um zu prüfen ob die Antwort eindeutig ist. Die Klasse kann einfach mit bestehenden oder neuen Datenbanken
verwendet werden; wenn die benötigten Tabellen nicht existieren, wird er Sie erstellen.

.. _zend.openid.consumer.example-5:

.. rubric:: Datenbank Speicher

.. code-block:: php
   :linenos:

   class DbStorage extends Zend_OpenId_Consumer_Storage
   {
       private $_db;
       private $_association_table;
       private $_discovery_table;
       private $_nonce_table;

       // Übergib das Zend_Db_Adapter Objekt und die Namen der
       // benötigten Tabellen
       public function __construct($db,
                                   $association_table = "association",
                                   $discovery_table = "discovery",
                                   $nonce_table = "nonce")
       {
           $this->_db = $db;
           $this->_association_table = $association_table;
           $this->_discovery_table = $discovery_table;
           $this->_nonce_table = $nonce_table;
           $tables = $this->_db->listTables();

           // Erstelle die Assoziationstabellen wenn Sie nicht existieren
           if (!in_array($association_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $association_table (" .
                   " url     varchar(256) not null primary key," .
                   " handle  varchar(256) not null," .
                   " macFunc char(16) not null," .
                   " secret  varchar(256) not null," .
                   " expires timestamp" .
                   ")");
           }

           // Erstelle die Discoverytabellen wenn Sie nicht existieren
           if (!in_array($discovery_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $discovery_table (" .
                   " id      varchar(256) not null primary key," .
                   " realId  varchar(256) not null," .
                   " server  varchar(256) not null," .
                   " version float," .
                   " expires timestamp" .
                   ")");
           }

           // Erstelle die Nouncetabellen wenn Sie nicht existieren
           if (!in_array($nonce_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $nonce_table (" .
                   " nonce   varchar(256) not null primary key," .
                   " created timestamp default current_timestamp" .
                   ")");
           }
       }

       public function addAssociation($url,
                                      $handle,
                                      $macFunc,
                                      $secret,
                                      $expires)
       {
           $table = $this->_association_table;
           $secret = base64_encode($secret);
           $this->_db->insert($table, array(
               'url'     => $url,
               'handle'  => $handle,
               'macFunc' => $macFunc,
               'secret'  => $secret,
               'expires' => $expires,
           ));
           return true;
       }

       public function getAssociation($url,
                                      &$handle,
                                      &$macFunc,
                                      &$secret,
                                      &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ?', time())
           );
           $select = $this-_db->select()
                   ->from($table, array('handle', 'macFunc', 'secret', 'expires'))
                   ->where('url = ?', $url);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $handle  = $res['handle'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function getAssociationByHandle($handle,
                                              &$url,
                                              &$macFunc,
                                              &$secret,
                                              &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ', time())
           );
           $select = $this->_db->select()
                   ->from($table, array('url', 'macFunc', 'secret', 'expires')
                   ->where('handle = ?', $handle);
           $res = $select->fetchRow($select);

           if (is_array($res)) {
               $url     = $res['url'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delAssociation($url)
       {
           $table = $this->_association_table;
           $this->_db->query("delete from $table where url = '$url'");
           return true;
       }

       public function addDiscoveryInfo($id,
                                        $realId,
                                        $server,
                                        $version,
                                        $expires)
       {
           $table = $this->_discovery_table;
           $this->_db->insert($table, array(
               'id'      => $id,
               'realId'  => $realId,
               'server'  => $server,
               'version' => $version,
               'expires' => $expires,
           ));

           return true;
       }

       public function getDiscoveryInfo($id,
                                        &$realId,
                                        &$server,
                                        &$version,
                                        &$expires)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->quoteInto('expires < ?', time()));
           $select = $this->_db->select()
                   ->from($table, array('realId', 'server', 'version', 'expires'))
                   ->where('id = ?', $id);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $realId  = $res['realId'];
               $server  = $res['server'];
               $version = $res['version'];
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delDiscoveryInfo($id)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->_db->quoteInto('id = ?', $id));
           return true;
       }

       public function isUniqueNonce($nonce)
       {
           $table = $this->_nonce_table;
           try {
               $ret = $this->_db->insert($table, array(
                   'nonce' => $nonce,
               ));
           } catch (Zend_Db_Statement_Exception $e) {
               return false;
           }
           return true;
       }

       public function purgeNonces($date=null)
       {
       }
   }

   $db = Zend_Db::factory('Pdo_Sqlite',
       array('dbname'=>'/tmp/openid_consumer.db'));
   $storage = new DbStorage($db);
   $consumer = new Zend_OpenId_Consumer($storage);

Dieses Beispiel zeigt keinen OpenID Authentifikations Code, aber dieser Code würde der gleiche sein wie der für
die anderen Beispiel in diesem Kapitel.

.. _zend.openid.consumer.sreg:

Einfache Registrations Erweiterung
----------------------------------

Zusätzlich zur Authentifikation kann OpenID Standard für einen leichtgewichtigen Profiltausch verwendet werden,
um Informationen über einen Benutzer über mehrere Sites hinweg portabel zu machen. Dieses Feature wird nicht
durch die OpenID Authentifikations Spezifikation abgedeckt, aber vom OpenID Einfachen Registrierungs Erweiterungs
Protokoll unterstützt. Dieses Protokoll erlaubt es OpenID-aktivierten Sites nach Informationen über End-Benutzern
von OpenID Providers zu fragen. Diese Informationen können folgendes beinhalten:

- **nickname**- ein UTF-8 String den der End-Benutzer als Spitzname verwendet.

- **email**- die Email Adresse des Benutzers wie in Sektion 3.4.1 von RFC2822 spezifiziert.

- **fullname**- eine UTF-8 String Repräsentation des kompletten Namens des Benutzers.

- **dob**- das Geburtsdatum des Benutzers im Format 'YYYY-MM-DD'. Jeder Wert dessen Repräsentation weniger als die
  speifizierte Anzahl an Ziffern in diesem Format verwendet sollte mit Nullen aufgefüllt werden. In anderen
  Worten, die Länge dieses Wertes muß immer 10 sein. Wenn der Benutzer irgendeinen Teil dieses Wertes (z.B. Jahr,
  Monat oder Tag) nicht angeben will, dann muß dieser auf Null gesetzt werden. Wenn ein Benutzer zum Beispiel
  angeben will das sein Geburtsdatum in das Jahr 1980 fällt, aber nicht den Monat oder Tag angeben will, dann
  sollte der zurückgegebene Wert '1980-00-00' sein.

- **gender**- das Geschlecht des Benutzers: "M" für männlich, "F" für weiblich

- **postcode**- ein UTF-8 String der dem Postleitzahl System des Landes des End-Benutzers entspricht

- **country**- das Land des Wohnsitzes des Benutzers wie in ISO3166 spezifiziert

- **language**- die bevorzugte Sprache des Benutzers wie in ISO639 spezifiziert

- **timezone**- ein *ASCII* String von der Zeitzonen Datenbank. Zum Beispiel, "Europe/Paris" oder
  "America/Los_Angeles".

Eine OpenID-aktivierte Web-Seite kann nach jeder beliebigen Kombination dieser Felder fragen. Sie kann auch einige
Informationen strikt fordern und es Benutzern erlauben zusätzliche Informationen anzubieten oder zu verstecken.
Das folgende Beispiel Instanziiert die ``Zend_OpenId_Extension_Sreg`` Klasse die einen **nickname** (Spitzname)
benötigt und optional eine **email** (E-Mail) und einen **fullname** (vollständigen Namen) benötigt.

.. _zend.openid.consumer.example-6_2:

.. rubric:: Anfragen mit einer einfachen Registrations Erweiterung senden

.. code-block:: php
   :linenos:

   $sreg = new Zend_OpenId_Extension_Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-6_3.php',
                         null,
                         $sreg)) {
       die("OpenID Login fehlgeschlagen.");
   }

Wie man sieht akzeptiert der ``Zend_OpenId_Extension_Sreg`` Konstruktor ein Array von OpenId Feldern. Das Array hat
den Namen der Felder als Indezes zu einem Flag das anzeigt ob das Feld benötigt wird oder nicht. ``TRUE`` bedeutet
der Wert wird benötigt und ``FALSE`` bedeutet das Feld ist optional. Die Methode ``Zend_OpenId_Consumer::login``
akzeptiert eine Erweiterung oder ein Array von Erweiterungen als sein viertes Argument.

Im dritten Schritt der Authentifikation sollte das ``Zend_OpenId_Extension_Sreg`` Objekt an
``Zend_OpenId_Consumer::verify`` übergeben werden. Anschließend wird die Methode
``Zend_OpenId_Extension_Sreg::getProperties``, bei erfolgreicher Authentifizierung, ein assoziatives Array von
benötigten Feldern zurückgeben.

.. _zend.openid.consumer.example-6_3:

.. rubric:: Antworten mit einer einfachen Registierungs Erweiterung prüfen

.. code-block:: php
   :linenos:

   $sreg = new Zend_OpenId_Extension_Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new Zend_OpenId_Consumer();
   if ($consumer->verify($_GET, $id, $sreg)) {
       echo "GÜLTIG " . htmlspecialchars($id) . "<br>\n";
       $data = $sreg->getProperties();
       if (isset($data['nickname'])) {
           echo "Spitzname: " . htmlspecialchars($data['nickname']) . "<br>\n";
       }
       if (isset($data['email'])) {
           echo "Email: " . htmlspecialchars($data['email']) . "<br>\n";
       }
       if (isset($data['fullname'])) {
           echo "Vollständiger Name: " . htmlspecialchars($data['fullname'])
              . "<br>\n";
       }
   } else {
       echo "UNGÜLTIG " . htmlspecialchars($id);
   }

Wenn das ``Zend_OpenId_Extension_Sreg`` Objekt ohne Argumente erstellt wurde, sollte der Benutzercode selbst das
Vorhandensein der benötigten Daten prüfen. Trotzdem, wenn das Objekt mit der gleichen Liste an benötigten
Feldern wie im zweiten Schritt erstellt wird, wird es automatisch die Existenz der benötigten Daten prüfen. In
diesem Fall wird ``Zend_OpenId_Consumer::verify`` ``FALSE`` zurückgeben wenn irgendeines der benötigten Felder
fehlt.

``Zend_OpenId_Extension_Sreg`` verwendet standardmäßig die Version 1.0 weil die Spezifikation der Version 1.1
noch nicht fertiggestellt wurde. Trotzdem unterstützen einige Bibliotheken die Version 1.0 nicht vollständig. Zum
Beispiel benötigt www.myopenid.com einen SREG Namensraum in den Anfragen der nur in 1.1 vorhanden ist. Um mit so
einem Server zu Arbeiten muß man die Version 1.1 explizit im ``Zend_OpenId_Extension_Sreg`` Konstruktor setzen.

Das zweite Argument des ``Zend_OpenId_Extension_Sreg`` Konstruktors ist eine Policy *URL*, die dem Benutzer durch
den Identitäts Provider zur Verfügung gestellt werden sollte.

.. _zend.openid.consumer.auth:

Integration mit Zend_Auth
-------------------------

Zend Framework bietet eine spezielle Klasse für die Unterstützung von Benutzer Authentifikation: ``Zend_Auth``.
Diese Klasse kann zusammen mit ``Zend_OpenId_Consumer`` verwendet werden. Das folgende Beispiel zeigt wie
``OpenIdAdapter`` das ``Zend_Auth_Adapter_Interface`` mit der ``authenticate()`` Methode implementiert. Diese
führt eine Authentifikations Anfrage und Verifikation durch.

Der große Unterschied zwischen diesem Adapter und dem bestehenden ist, das er mit zwei *HTTP* Anfragen arbeitet
und einen Dispatch code enthält um den zweiten oder dritten Schritt der OpenID Authentifikation durchzuführen.

.. _zend.openid.consumer.example-7:

.. rubric:: Zend_Auth Adapter für OpenID

.. code-block:: php
   :linenos:

   class OpenIdAdapter implements Zend_Auth_Adapter_Interface {
       private $_id = null;

       public function __construct($id = null) {
           $this->_id = $id;
       }

       public function authenticate() {
           $id = $this->_id;
           if (!empty($id)) {
               $consumer = new Zend_OpenId_Consumer();
               if (!$consumer->login($id)) {
                   $ret = false;
                   $msg = "Authentifizierung fehlgeschlagen.";
               }
           } else {
               $consumer = new Zend_OpenId_Consumer();
               if ($consumer->verify($_GET, $id)) {
                   $ret = true;
                   $msg = "Authentifizierung erfolgreich";
               } else {
                   $ret = false;
                   $msg = "Authentifizierung fehlgeschlagen";
               }
           }
           return new Zend_Auth_Result($ret, $id, array($msg));
       }
   }

   $status = "";
   $auth = Zend_Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode'])) {
       $adapter = new OpenIdAdapter(@$_POST['openid_identifier']);
       $result = $auth->authenticate($adapter);
       if ($result->isValid()) {
           Zend_OpenId::redirect(Zend_OpenId::selfURL());
       } else {
           $auth->clearIdentity();
           foreach ($result->getMessages() as $message) {
               $status .= "$message<br>\n";
           }
       }
   } else if ($auth->hasIdentity()) {
       if (isset($_POST['openid_action']) &&
           $_POST['openid_action'] == "logout") {
           $auth->clearIdentity();
       } else {
           $status = "Du bist angemeldet als " . $auth->getIdentity() . "<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>

Mit ``Zend_Auth`` wird die Identität des End-Benutzes in den Session Daten gespeichert. Sie kann mit
``Zend_Auth::hasIdentity`` und ``Zend_Auth::getIdentity`` geprüft werden.

.. _zend.openid.consumer.mvc:

Integration mit Zend_Controller
-------------------------------

Zuletzt ein paar Worte über die Integration in Model-View-Controller Anwendungen: Solche Zend Framework
Anwendungen werden implementiert durch Verwenden der ``Zend_Controller`` Klasse und Sie verwenden die
``Zend_Controller_Response_Http`` Klasse um *HTTP* Antworten vorzubereiten und an den Web Browser des Benutzers
zurückzusenden.

``Zend_OpenId_Consumer`` bietet keine GUI Möglichkeiten aber es führt *HTTP* Umleitungen bei erflgreichen
``Zend_OpenId_Consumer::login`` und ``Zend_OpenId_Consumer::check`` durch. Diese Umleitungen könnten nicht richtig
funktionieren, oder sogar überhaupt nicht, wenn einige Daten bereits an den Web Browser gesendet wurden. Um *HTTP*
Umleitungen im *MVC* Code richtig durchzuführen sollte die echte ``Zend_Controller_Response_Http`` als letztes
Argument an ``Zend_OpenId_Consumer::login`` oder ``Zend_OpenId_Consumer::check`` gesendet werden.


