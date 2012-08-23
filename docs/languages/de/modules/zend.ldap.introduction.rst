.. EN-Revision: none
.. _zend.ldap.introduction:

Einführung
==========

``Zend_Ldap`` ist eine Klasse, mit der *LDAP* Operationen, wie das Durchsuchen, das Bearbeiten oder die Bindung an
Einträge im *LDAP* Verzeichnis, durchgeführt werden können.

.. _zend.ldap.introduction.theory-of-operations:

Theorie der Verwendung
----------------------

Diese Komponente besteht aus der Hauptklasse ``Zend_Ldap`` welche konzeptionell eine Bindung an einen einzelnen
*LDAP* Server repräsentiert und die Ausführung von Operationen an diesem *LDAP* Server erlaubt, wie zum Beispiel
OpenLDAP oder ActiveDirectory (AD) Server. Die Parameter für das Binden können explizit oder in der Form eines
Options Arrays angegeben werden. ``Zend_Ldap_Node`` bietet ein Objektorientiertes Interface für einen einzelnen
*LDAP* Node und kann verwendet werden um eine Basis für ein Active-Record artiges Interface für ein *LDAP*
basiertes Domain-Modell zu bieten.

Die Komponente bietet verschiedene Helfer Klassen um Operationen auf *LDAP* Einträgen (``Zend_Ldap_Attribute``)
durchzuführen, wie das Setzen und Empfangen von Attributen (Datumswerte, Passwörter, Boolsche Werte, ...), um
*LDAP* Filter Strings (``Zend_Ldap_Filter``) zu Erstellen und zu Ändern, und um *LDAP* Distinguished Names (DN)
(``Zend_Ldap_Dn``) zu manipulieren.

Zusätzlich abstrahiert die Komponente das Suchen im *LDAP* Schema für OpenLDAP und ActiveDirectory Server
``Zend_Ldap_Node_Schema`` und das empfangen von Server Informationen für OpenLDAP-, ActiveDirectory- und Novell
eDirectory Server (``Zend_Ldap_Node_RootDse``).

Die Verwendung der ``Zend_Ldap`` Klasse hängt vom Typ des *LDAP* Servers ab und wird am besten mit einigen
einfachen Beispielen gezeigt.

Wenn man OpenLDAP Verwendet sieht ein einfaches Beispiel wie folgt aus (es ist zu beachten das die
**bindRequiresDn** Option wichtig ist wenn man **nicht** AD verwendet):

.. code-block:: php
   :linenos:

   $options = array(
       'host'              => 's0.foo.net',
       'username'          => 'CN=user1,DC=foo,DC=net',
       'password'          => 'pass1',
       'bindRequiresDn'    => true,
       'accountDomainName' => 'foo.net',
       'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

Wenn man Microsoft AD verwendet ist ein einfaches Beispiel:

.. code-block:: php
   :linenos:

   $options = array(
       'host'                   => 'dc1.w.net',
       'useStartTls'            => true,
       'username'               => 'user1@w.net',
       'password'               => 'pass1',
       'accountDomainName'      => 'w.net',
       'accountDomainNameShort' => 'W',
       'baseDn'                 => 'CN=Users,DC=w,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('bcarter',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

Es ist zu beachten das die ``getCanonicalAccountName()`` Methode verwendet wird um den DN Account zu empfangen da
jenes das einige ist was das meiste in diesem kleinen Code zeigt der aktuell in dieser Klasse vorhanden ist.

.. _zend.ldap.introduction.theory-of-operations.automatic-username-canonicalization:

Automatische Kanonisierung des Benutzernamens beim Binden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn *bind()* mit einem nicht-DN Benutzernamen aufgerufen wird aber *bindRequiresDN* ``TRUE`` ist und kein
Benutzername in DN-Form als Option angegeben wurde, dann wird die Server-Bindung fehlschlagen. Wenn allerdings ein
Benutzername in DN-Form im Optionen-Array übergeben wurde, wird ``Zend_Ldap`` sich zuerst mit diesem Benutzernamen
an den Server binden, den Account DN für den Benutzernamen empfangen der bei *bind()* angegeben wurde und dann mit
diesem zum DN verbinden.

Dieses Verhalten ist kritisch für :ref:`Zend_Auth_Adapter_Ldap <zend.auth.adapter.ldap>`, welches den vom Benutzer
angegebenen Benutzernamen direkt an ``bind()`` übergibt.

Das folgende Beispiel zeigt wie der nicht-DN Benutzername '**abaker**' mit ``bind()`` verwendet werden kann:

.. code-block:: php
   :linenos:

   $options = array(
           'host'              => 's0.foo.net',
           'username'          => 'CN=user1,DC=foo,DC=net',
           'password'          => 'pass1',
           'bindRequiresDn'    => true,
           'accountDomainName' => 'foo.net',
           'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $ldap->bind('abaker', 'moonbike55');
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

Der Aufruf von ``bind()`` in diesem Beispiel sieht das der Benutzer '**abaker**' nicht in DN Form ist, findet das
**bindRequiresDn** ``TRUE`` ist, verwendet '``CN=user1,DC=foo,DC=net``' und '**pass1**' um zu Binden, empfängt den
DN für '**abaker**', entbindet und Bindet dann nochmals mit dem neu erkannten '``CN=Alice
Baker,OU=Sales,DC=foo,DC=net``'.

.. _zend.ldap.introduction.theory-of-operations.account-name-canonicalization:

Kanonisierung des Account Namens
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Optionen **accountDomainName** und **accountDomainNameShort** werden für zwei Zwecke verwendet: (1) bieten Sie
multi-Domain Authentifizierung und Failover Möglichkeiten, und (2) werden Sie auch verwendet um Benutzernamen zu
kanonisieren. Speziell Namen werden in die Form kanonisiert die in der **accountCanonicalForm** Option spezifiziert
ist. Diese Option kann einen der folgenden Werte enthalten:

.. _zend.ldap.using.theory-of-operation.account-name-canonicalization.table:

.. table:: Optionen für accountCanonicalForm

   +-----------------------+----+-----------------------------------------+
   |Name                   |Wert|Beispiel                                 |
   +=======================+====+=========================================+
   |ACCTNAME_FORM_DN       |1   |CN=Alice Baker,CN=Users,DC=example,DC=com|
   +-----------------------+----+-----------------------------------------+
   |ACCTNAME_FORM_USERNAME |2   |abaker                                   |
   +-----------------------+----+-----------------------------------------+
   |ACCTNAME_FORM_BACKSLASH|3   |EXAMPLE\\abaker                          |
   +-----------------------+----+-----------------------------------------+
   |ACCTNAME_FORM_PRINCIPAL|4   |abaker@example.com                       |
   +-----------------------+----+-----------------------------------------+

Die Standardmäßige Kanonisierung hängt davon ab welche Optionen für Account Domain Namen angegeben wurden. Wenn
**accountDomainNameShort** angegeben wurde, ist der Standardwert von **accountCanonicalForm**
``ACCTNAME_FORM_BACKSLASH``. Andernfall, wenn **accountDomainName** angegeben wurde, ist der Standardwert
``ACCTNAME_FORM_PRINCIPAL``.

Die Kanonisierung des Account Namens stellt sicher das der String der zur Identifikation des Accounts verwendet
wird konsistent ist, unabhängig davon was an ``bind()`` übergeben wurde. Wenn der Benutzer, zum Beispiel, den
Account Namen ``abaker@example.com`` oder nur **abaker** angibt, und **accountCanonicalForm** auf 3 gesetzt ist,
wird der resultierende kanonisierte Name **EXAMPLE\abaker** sein.

.. _zend.ldap.introduction.theory-of-operations.multi-domain-failover:

Multi-Domain Authentifizierung und Failover
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Komponente ``Zend_Ldap`` macht von sich aus keinen Versuch sich bei mehreren Servern zu authentifizieren.
Trotzdem wurde ``Zend_Ldap`` speziell dafür designt um einfach durch ein Array von Array von angebotenen Optionen
zu iterieren und sich mit jedem Server zu binden. Wie oben beschrieben wird ``bind()`` automatisch jeden Namen
kanonisieren, damit es egal ist ob der Benutzer ``abaker@foo.net`` oder **W\bcarter** oder **cdavis** übergibt -
die ``bind()`` Methode ist nur dann erfolgreich wenn die Benutzerdaten erfolgreich beim Binden verwendet wurden.

Nehmen wir das folgende Beispiel an das die benötigten Techniken zeigt um eine Multi-Domain Authentifizierung und
Failover zu implementieren:

.. code-block:: php
   :linenos:

   $acctname = 'W\\user2';
   $password = 'pass2';

   $multiOptions = array(
       'server1' => array(
           'host'                   => 's0.foo.net',
           'username'               => 'CN=user1,DC=foo,DC=net',
           'password'               => 'pass1',
           'bindRequiresDn'         => true,
           'accountDomainName'      => 'foo.net',
           'accountDomainNameShort' => 'FOO',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'OU=Sales,DC=foo,DC=net',
       ),
       'server2' => array(
           'host'                   => 'dc1.w.net',
           'useSsl'                 => true,
           'username'               => 'user1@w.net',
           'password'               => 'pass1',
           'accountDomainName'      => 'w.net',
           'accountDomainNameShort' => 'W',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'CN=Users,DC=w,DC=net',
       ),
   );

   $ldap = new Zend_Ldap();

   foreach ($multiOptions as $name => $options) {

       echo "Versuch zu binden un die Serveroptionen für '$name' zu verwenden\n";

       $ldap->setOptions($options);
       try {
           $ldap->bind($acctname, $password);
           $acctname = $ldap->getCanonicalAccountName($acctname);
           echo "Erfolgreich: $acctname authentifiziert\n";
           return;
       } catch (Zend_Ldap_Exception $zle) {
           echo '  ' . $zle->getMessage() . "\n";
           if ($zle->getCode() === Zend_Ldap_Exception::LDAP_X_DOMAIN_MISMATCH) {
               continue;
           }
       }
   }

Wenn das Binden aus irgendeinem Grund fehlschlägt, werden die nächsten Serveroptionen probiert.

Der Aufruf von ``getCanonicalAccountName()`` erhält den kanonisierten Accountnamen welcher der Anwendung
voraussichtlich verwendet um zugehörige Daten bevorzugt zu assoziieren. **accountCanonicalForm = 4** in allen
Serveroptionen stellt sicher das die kanonisierte Form angenommen wird, egal welcher Server letztendlich verwendet
wird.

Die spezielle Exception ``LDAP_X_DOMAIN_MISMATCH`` tritt auf wenn ein Account Name bei einer Domain Komponente
übergeben wurde (z.B. ``abaker@foo.net`` oder **FOO\abaker** und nicht nur **abaker**) aber die Domain Komponente
keiner der Domains in den aktuell ausgewählten Server Optionen entspricht. Diese Exception zeigt das der Server
keine Autorität für den Account ist. In diesem Fall wird das Binden nicht durchgeführt, und damit unnötige
Kommunikation mit dem Server verhindert. Es ist zu beachten das die **continue** Anweisung in diesem Beispiel
keinen Effekt hat, aber in der Praxis für Fehlerbehandlung und Debugging Zwecke verwendet wird, da man
warscheinlich auf ``LDAP_X_DOMAIN_MISMATCH`` sowie ``LDAP_NO_SUCH_OBJECT`` und ``LDAP_INVALID_CREDENTIALS`` prüfen
will.

Der obige Code ist dem Code der in :ref:`Zend_Auth_Adapter_Ldap <zend.auth.adapter.ldap>` verwendet wurde sehr
ähnlich. Fakt ist, das wir einfach empfehlen den Authentifizierungs Adapter für Multi-Domain und Failover
basierte *LDAP* Authentifizierung zu verwenden (oder den Code zu kopieren).


