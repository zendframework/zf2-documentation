.. _zend.permissions.acl.advanced:

Fortgeschrittene Verwendung
===========================

.. _zend.permissions.acl.advanced.storing:

Dauerhafte Speicherung von ACL-Daten
------------------------------------

``Zend\Permissions\Acl`` wurde so entwickelt, dass keine spezielle Backend Technologie benötigt wird, wie z.B. eine Datenbank
oder ein Cache Server, um die *ACL*-Daten zu speichern. Ihre vollständige *PHP*-Implementation ermöglicht
angepasste Administrationstools, die relativ einfach und flexibel auf ``Zend\Permissions\Acl`` aufbauen. Viele Situationen
erfordern eine interaktive Wartung der *ACL* und ``Zend\Permissions\Acl`` stellt Methoden für das Einrichten und Abfragen der
Zugriffskontrolle einer Anwendung.

Die Speicherung der *ACL*-Daten ist deshalb die Aufgabe des Entwicklers, da sich die Anwendungsfälle für
verschiedene Situationen erwartungsgemäß stark unterscheiden. Da ``Zend\Permissions\Acl`` serialisierbar ist, können
*ACL*-Objekte mit der *PHP*-Funktion `serialize()`_ serialisiert werden und das Ergebnis kann überall gespeichert
werden, wo es der Entwickler möchte, wie z.B. in einer Datei, in einer Datenbank oder mit einem Cache-Mechanismus.

.. _zend.permissions.acl.advanced.assertions:

Schreiben von bedingten ACL-Regeln mit Zusicherungen
----------------------------------------------------

Manchmal soll eine Regel für das Erlauben oder Verbieten des Zugriffs auf eine Ressource nicht absolut sein,
sondern von verschiedenen Kriterien abhängen. Nehmen wir zum Beispiel an, dass ein bestimmter Zugriff erlaubt sei,
aber nur zwischen 08:00 und 17:00 Uhr. Ein anderes Beispiel könnte sein, dass der Zugriff verboten wird, weil eine
Anfrage von einer bestimmten IP-Adresse kommt, die als Missbrauchsquelle markiert worden ist. ``Zend\Permissions\Acl`` bietet
eine eingebaute Unterstützung für die Implementierung von Regeln, die auf Bedingungen basieren, die der
Entwickler benötigt.

``Zend\Permissions\Acl`` bietet Unterstützung für bedingte Regeln mit dem ``Zend\Permissions\Acl\Assert\AssertInterface``. Um das
Regelzusicherungsinterface benutzen zu können, schreibt der Entwickler eine Klasse, welche die Methode
``assert()`` des Interfaces implementiert:

.. code-block:: php
   :linenos:

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null,
                              $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isCleanIP($ip)
       {
           // ...
       }
   }

Sobald eine Zusicherungsklasse verfügbar ist, muss der Entwickler eine Instanz dieser Zusicherungsklasse bei der
Zuordnung bedingter Regeln übergeben. Eine Regel, die mit einer Zusicherung angelegt wird, wird nur angewendet,
wenn die Zusicherungsmethode ``TRUE`` zurück gibt.

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());

Der obige Code legt eine bedingte Erlaubnisregel an, die den Zugriff für alle Rechte auf alles und von jedem
erlaubt, außer wenn die anfordernde IP auf einer "Blacklist" ist. Wenn die Anfrage von einer IP kommt, die nicht
als "sauber" betrachtet wird, wird die Erlaubnisregel nicht angewandt. Da die Regel auf alle Rollen, alle
Ressourcen und alle Rechte zutrifft, würde eine "unsaubere" IP zu einem Zugriffsverbot führen. Dies ist ein
besonderer Fall und es sollte verstanden werden, dass in allen anderen Fällen (d.h. wenn eine spezielle Rolle,
Ressource oder Recht für die Regel spezifiziert wird) eine fehlerhafte Zusicherung dazu führt, dass die Regel
nicht angewandt wird und andere Regeln verwendet werden um zu ermitteln, ob der Zugriff erlaubt oder verboten ist.

Der Methode ``assert()`` eines Zusicherungsobjektes werden die *ACL*, Rolle, Ressource und die Rechte übergeben,
auf welche die Autorisierungsabfrage (d.h., ``isAllowed()``) passt, um den Kontext für die Zusicherungsklasse
bereit zu stellen, um die Bedingungen zu ermitteln wo erforderlich.



.. _`serialize()`: http://php.net/serialize
