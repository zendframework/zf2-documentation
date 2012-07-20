.. _zend.acl.introduction:

Einführung
==========

``Zend_Acl`` stellt eine Implementation von leichtgewichtigen und flexiblen Zugriffskontrolllisten (englisch
"access control list", *ACL*) für die Rechteverwaltung bereit. Im Allgemeinen kann eine Anwendung derartige *ACL*\
s verwenden, um den Zugriff auf bestimmte, geschützte Objekte durch andere anfordernde Objekte zu kontrollieren.

In dieser Dokumentation:

- ist eine **Ressource** ein Objekt, auf das der Zugriff kontrolliert wird.

- ist eine **Rolle** ein Objekt, das den Zugriff auf eine Ressource anfordern kann.

Einfach ausgedrückt **fordern Rollen den Zugriff auf Ressourcen an**. Wenn z.B. ein Parkplatzwächter den Zugriff
auf ein Auto anfordert, ist der Parkplatzwächter die anfordernde Rolle und das Auto die Ressource, weil der
Zugriff auf das Auto nicht jedem erlaubt ist.

Durch die Spezifikation und die Verwendung einer *ACL* kann eine Anwendung kontrollieren, wie Rollen den Zugriff
auf Ressourcen eingeräumt bekommen.

.. _zend.acl.introduction.resources:

Ressourcen
----------

Das Erstellen einer Ressource ist in ``Zend_Acl`` sehr einfach. ``Zend_Acl`` stellt die Ressource
``Zend_Acl_Resource_Interface`` bereit, um das Erstellen von Ressourcen in Anwendungen zu ermöglichen. Eine Klasse
muss nur dieses Interface implementieren, das nur aus einer einzelnen Methode, ``getResourceId()``, besteht, damit
``Zend_Acl`` das Objekt als Ressource erkennen kann. Zusätzlich ist ``Zend_Acl_Resource`` in ``Zend_Acl`` als
einfache Ressourcen-Implementation enthalten, damit Entwickler sie wenn nötig erweitern können.

``Zend_Acl`` stellt eine Baumstruktur bereit, in die mehrere Ressourcen aufgenommen werden können. Weil Ressourcen
in solch einer Baumstruktur abgelegt werden, können sie vom Allgemeinen (von der Baumwurzel) bis zum Speziellen
(zu den Baumblättern) organisiert werden. Abfragen auf einer bestimmten Ressource durchsuchen automatisch die
Ressourcenhierarchie nach Regeln, die einer übergeordneten Ressource zugeordnet wurden, um die einfache Vererbung
von Regeln zu ermöglichen. Wenn zum Beispiel eine Standardregel für jedes Gebäude einer Stadt gelten soll,
würde man diese Regel einfach der Stadt zuordnen, anstatt die selbe Regel jedem Gebäude zuzuordnen. Einige
Gebäude können dennoch Ausnahmen zu solch einer Regel erfordern, und dies kann in ``Zend_Acl`` einfach durch die
Zuordnung solcher Ausnahmeregeln zu jedem der Gebäude erreicht werden, die eine Ausnahme erfordern. Eine Ressource
kann nur von einer einzigen übergeordneten Ressource erben, obwohl diese übergeordnete Ressource ihre eigenen
übergeordneten Ressourcen haben kann, und so weiter.

``Zend_Acl`` unterstützt außerdem Rechte auf Ressourcen (z.B. "erstellen", "lesen", "aktualisieren", "löschen")
damit der Entwickler Regeln zuordnen kann, die alle Rechte oder bestimmte Rechte von einer oder mehreren Ressourcen
beeinflussen.

.. _zend.acl.introduction.roles:

Rollen
------

Wie bei den Ressourcen ist auch das Erstellen einer Rolle sehr einfach. Alle Rollen müssen
``Zend_Acl_Role_Interface`` implementieren. Dieses Interface besteht aus einer einzelnen Methode, ``getRoleId()``,
zusätzlich wird ``Zend_Acl_Role`` von ``Zend_Acl`` als einfache Rollen Implementation angeboten, damit Entwickler
sie bei Bedarf erweitern können.

In ``Zend_Acl`` kann eine Rolle von einer oder mehreren Rollen erben. Dies soll die Vererbung von Regeln zwischen
den Rollen ermöglichen. Zum Beispiel kann eine Benutzerrolle, wie "Sally" zu einer oder mehreren übergeordneten
Rollen gehören, wie "Editor" und "Administrator". Der Entwickler kann zu "Editor" und "Administrator" getrennt
Regeln zuordnen und "Sally" würde diese Regeln von beiden erben, ohne dass "Sally" direkt Regeln zugeordnet werden
müssen.

Auch wenn die Möglichkeit der Vererbung von verschiedenen Rollen sehr nützlich ist, führt die mehrfache
Vererbung auch einen gewissen Grad an Komplexität ein. Das folgende Beispiel illustriert die mehrdeutigen
Bedingungen und wie ``Zend_Acl`` sie auflöst.

.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Mehrfache Vererbung zwischen Rollen

Der folgende Code definiert drei Basisrollen - "guest", "member" und "admin" - von denen andere Rollen erben
können. Dann wird eine Rolle "someUser" eingerichtet, die von den drei anderen Rollen erbt. Die Reihenfolge, in
der diese Rollen im ``$parents`` Array erscheinen, ist wichtig. Wenn notwendig, sucht ``Zend_Acl`` nach
Zugriffsregeln nicht nur für die abgefragte Rolle (hier "someUser"), sondern auch für die Rollen, von denen die
abgefragte Rolle erbt (hier "guest", "member" und "admin"):

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $acl->addRole(new Zend_Acl_Role('guest'))
       ->addRole(new Zend_Acl_Role('member'))
       ->addRole(new Zend_Acl_Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend_Acl_Role('someUser'), $parents);

   $acl->add(new Zend_Acl_Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

Da keine Regel speziell für die Rolle "someUser" und "someResource" definiert wurde, muss ``Zend_Acl`` nach Regeln
suchen, die für Rollen definiert wurden, von denen "someUser" erbt. Zuerst wird die "admin"-Rolle besucht, aber
dort ist keine Zugriffsregel definiert. Als nächste wird die "member"-Rolle besucht und ``Zend_Acl`` findet hier
eine Regel, die angibt, dass "member" der Zugriff auf "someResource" erlaubt ist.

Wenn ``Zend_Acl`` fortfahren würde, die für weitere übergeordnete Rollen definierten Regeln zu untersuchen,
würde herausgefunden werden, dass "guest" der Zugriff auf "someResource" verboten ist. Diese Tatsache führt eine
Mehrdeutigkeit ein, weil nun "someUser" der Zugriff auf "someResource" sowohl verboten als auch erlaubt ist,
aufgrund der vererbten Regeln von verschiedenen übergeordnete Rollen, die miteinander im Konflikt stehen.

``Zend_Acl`` löst diese Mehrdeutigkeit dadurch auf, dass eine Abfrage beendet wird, wenn die erste Regel gefunden
wird, die direkt auf die Abfrage passt. In diesem Fall würde der Beispiel Code "allowed" ausgeben, weil die
"member"-Rolle vor der "guest"-Rolle untersucht wird.

.. note::

   Wenn man mehrere übergeordnete Rollen angibt, sollte man beachten, dass die zuletzt gelistete Rolle als erstes
   nach Regeln durchsucht wird, die auf die Autorisierungsabfrage passen.

.. _zend.acl.introduction.creating:

Erstellen einer Zugriffskontrollliste
-------------------------------------

Eine Zugriffskontrollliste (*ACL*) kann jeden gewünschten Satz von körperlichen oder virtuellen Objekten
repräsentieren. Zu Demonstrationszwecken werden wir eine grundlegende *ACL* für ein Redaktionssystem (*CMS*)
erstellen, die mehrere Schichten von Gruppen über eine Vielzahl von Bereichen verwaltet soll. Um ein *ACL*-Objekt
zu erstellen, instanzieren wir die *ACL* ohne Parameter:

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

.. note::

   Solange der Entwickler keine "allow"-Regel spezifiziert, verweigert ``Zend_Acl`` den Zugriff auf jegliche Rechte
   für jede Ressource durch jede Rolle.

.. _zend.acl.introduction.role_registry:

Rollen registrieren
-------------------

*CMS* brauchen fast immer eine Hierarchie von Genehmigungen, um die Autorenfähigkeiten seiner Benutzer
festzulegen. Es kann eine 'Guest'-Gruppe geben, um beschränkten Zugriff zur Demonstration zu ermöglichen, eine
'Staff'-Gruppe für die Mehrheit der *CMS* Nutzer, welche die meisten der alltäglichen Aufgaben erledigen, eine
'Editor'-Gruppe für diejenigen, die für das Veröffentlichen, Überprüfen, Archivieren und Löschen von Inhalten
zuständig sind, sowie eine 'Administrator'-Gruppe, dessen Aufgaben alle der anderen Gruppen sowie die Pflege
sensibler Informationen, die Benutzerverwaltung, die Backend-Konfigurationsdaten, die Datensicherung und den Export
beinhalten. Diese Genehmigungen können durch eine Rollenregistrierung repräsentiert werden, die es jeder Gruppe
erlaubt, die Rechte von 'übergeordneten' Gruppen zu erben sowie eindeutige Rechte nur für deren Gruppe bereit zu
stellen. Diese Genehmigungen können wie folgt ausgedrückt werden:

.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Zugangsbeschränkung für ein Beispiel-CMS

   +-------------+------------------------------------+----------------------+
   |Name         |Eindeutige Genehmigung              |Erbe Genehmigungen von|
   +=============+====================================+======================+
   |Guest        |View                                |N/A                   |
   +-------------+------------------------------------+----------------------+
   |Staff        |Edit, Submit, Revise                |Guest                 |
   +-------------+------------------------------------+----------------------+
   |Editor       |Publish, Archive, Delete            |Staff                 |
   +-------------+------------------------------------+----------------------+
   |Administrator|(bekommt kompletten Zugriff gewährt)|N/A                   |
   +-------------+------------------------------------+----------------------+

Für dieses Beispiel wird ``Zend_Acl_Role`` verwendet, aber jedes Objekt wird akzeptiert, das
``Zend_Acl_Role_Interface`` implementiert. Diese Gruppen können zur Rollenregistrierung wie folgt hinzugefügt
werden:

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   // Fügt Gruppen zur Rollenregistrierung hinzu unter Verwendung von Zend_Acl_Role
   // Gast erbt keine Zugriffsrechte
   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);

   // Mitarbeiter erbt von Gast
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);

   /*
   Alternativ kann das obige wie folgt geschrieben werden:
   $acl->addRole(new Zend_Acl_Role('staff'), 'guest');
   */

   // Redakteur erbt von Mitarbeiter
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');

   // Administrator erbt keine Zugriffsrechte
   $acl->addRole(new Zend_Acl_Role('administrator'));

.. _zend.acl.introduction.defining:

Zugangsbeschränkung definieren
------------------------------

Nun, da die *ACL* die relevanten Rollen enthält, können Regeln eingerichtet werden, die definieren, wie auf
Ressourcen durch Rollen zugegriffen werden darf. Es ist zu beachten, dass wir keine bestimmten Ressourcen in diesem
Beispiel definiert haben, das vereinfacht wurde, um zu illustrieren, dass die Regeln für alle Ressourcen gelten.
``Zend_Acl`` stellt eine Implementation bereit, bei der Regeln nur vom Allgemeinen zum Speziellen definiert werden
müssen, um die Anzahl der benötigten Regeln zu minimieren, weil Ressourcen und Rollen die Regeln erben, die in
ihren Vorfahren definiert worden sind.

.. note::

   Generell wendet ``Zend_Acl`` eine angegebene Regel dann und nur dann an, wenn eine speziellere Regel nicht
   passt.

Folglich können wir einen einigermaßen komplexen Regelsatz mit sehr wenig Code definieren. Um die grundlegenden
Genehmigungen von oben anzugeben:

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');
   $acl->addRole(new Zend_Acl_Role('administrator'));

   // Gäste dürfen Inhalte nur sehen
   $acl->allow($roleGuest, null, 'view');

   /*
   Alternativ kann das obige wie folgt geschrieben werden:
   $acl->allow('guest', null, 'view');
   */

   // Mitarbeiter erbt 'ansehen' Rechte von Gast, benötigt aber zusätzliche Rechte
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Redakteuer erbt 'ansehen', 'bearbeiten', 'absenden' und die 'revidieren'
   // Rechte vom Mitarbeiter, benötigt aber zusätzliche Rechte
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator erbt gar nichts, aber erhält alle Rechte
   $acl->allow('administrator');

Die ``NULL``-Werte in obigen ``allow()``-Aufrufen werden verwendet, um anzugeben, dass diese Regeln für alle
Ressourcen gelten.

.. _zend.acl.introduction.querying:

Abfragen einer ACL
------------------

Wir haben nun eine flexible *ACL*, die in der gesamten Anwendung verwendet werden kann, um zu ermitteln, ob
Anfragende die Genehmigung haben, Funktionen auszuführen. Abfragen durchzuführen ist recht einfach mit Hilfe der
``isAllowed()``-Methode:

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied";
   // erlaubt wegen der Vererbung von Gast

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied";
   // verweigert, weil es keine erlaubte Regel für 'update' gibt

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied";
   // erlaubt, weil Administrator alle Rechte haben

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied";
   // erlaubt, weil Administrator alle Rechte haben

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied";
   // erlaubt, weil Administrator alle Rechte haben


