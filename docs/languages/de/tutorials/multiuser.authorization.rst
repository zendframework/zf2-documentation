.. _learning.multiuser.authorization:

Erstellung eines Authorisations Systems in Zend Framework
=========================================================

.. _learning.multiuser.authorization.intro:

Einführung in Authorisation
---------------------------

Nachdem ein Benutzer als authentisch identifiziert wurde, kann eine Anwendung mit Ihrem Geschäft weitermachen und
einige nützliche und gewünschte Ressourcen an den Konsumenten liefern. In vielen Fällen können Anwendungen
andere Ressource Typen enthalten, wobei einige Ressourcen auch striktere Regeln betreffend Zugriff haben können.
Dieser Prozess der Erkennung, wer Zugriff zu welchen Ressourcen hat, ist der Prozess der "Authorisierung".
Authorisierung in seiner einfachsten Form ist die Komposition der folgenden Elemente:

- die Identität von dem der Zugriff wünscht

- die Ressource für welche die Identität den Zugriff anfragt um Sie zu konsumieren

- und optional, was der Identität erlaubt ist mit der Ressource zu tun

Im Zend Framework behandelt die Komponente ``Zend\Permissions\Acl`` die Arbeit der Erstellung eines Baums von Rollen,
Ressourcen und Privilegien um Authorisationsanfragen zu managen und abzufragen.

.. _learning.multiuser.authorization.basic-usage:

Grundsätzliche Verwendung von Zend\Permissions\Acl
--------------------------------------

Wenn ``Zend\Permissions\Acl`` verwendet wird können beliebige Modelle als Rollen oder Ressourcen fungieren indem einfach das
richtige Interface implementiert wird. Um als Rolle verwendet zu werden muss die Klasse ``Zend\Permissions\Acl\Role\RoleInterface``
implementieren, welche nur ``getRoleId()`` benötigt. Um als Ressource zu verwenden muss eine Klasse
``Zend\Permissions\Acl\Resource\ResourceInterface`` implementieren wofür die Klasse so ähnlich die ``getResourceId()`` Methode
implementieren muss.

Anbei wird ein einfaches Benutzermodell demonstriert. Dieses Modell kann einen Teil in unserem *ACL* System
übernehmen indem einfach ``Zend\Permissions\Acl\Role\RoleInterface`` implementiert wird. Die Methode ``getRoleId()`` gibt die Id
"guest" zurück wenn die Id nicht bekannt ist, oder die Id der Rolle welche mit dem aktuellen Benutzerobjekt
verknüpft ist. Dieser Wert kann effektiv von überall kommen, eine statische Definition oder vielleicht dynamisch
von der Datenbankrolle des Benutzers selbst.

.. code-block:: php
   :linenos:

   class Default_Model_User implements Zend\Permissions\Acl\Role\RoleInterface
   {
       protected $_aclRoleId = null;

       public function getRoleId()
       {
           if ($this->_aclRoleId == null) {
               return 'guest';
           }

           return $this->_aclRoleId;
       }
   }

Wärend das Konzept eines Benutzers als Rolle recht gerade heraus ist, könnte die Anwendung ein anderes Modell
wählen welches im eigenen System als potentielle "Ressource" im *ACL* System verwendet wird. Der Einfachheit
halber verwenden wir das Beispiel eines Blog Posts. Da der Typ der Ressource mit dem Typ des Objekts verknüpft
ist, gibt diese Klasse nur 'blogPost' als Ressource ID im System zurück. Natürlich kann dieser Wert dynamisch
sein wenn das System dies benötigt.

.. code-block:: php
   :linenos:

   class Default_Model_BlogPost implements Zend\Permissions\Acl\Resource\ResourceInterface
   {
       public function getResourceId()
       {
           return 'blogPost';
       }
   }

Jetzt da wir zumindest eine Rolle und eine Ressource haben können wir mit der Definition der Regeln des *ACL*
Systems weitermachen. Diese Regeln werden konsultiert wenn das System eine Abfrage darüber erhält was
möglicherweise eine bestimmte Rolle, eine Ressource und optional ein Privileg ist.

Nehmen wir die folgenden Regeln an:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   // Die verschiedenen Rollen im System einstellen
   $acl->addRole('guest');
   // Der Eigentümer erbt alle Regeln vom Gast
   $acl->addRole('owner', 'guest');

   // Die Ressource hinzufügen
   $acl->addResource('blogPost');

   // Die Privilegien den Rollen- und Ressourcekombinationen hinzufügen
   $acl->allow('guest', 'blogPost', 'view');
   $acl->allow('owner', 'blogPost', 'post');
   $acl->allow('owner', 'blogPost', 'publish');

Die oben stehenden Regeln sund recht einfach: eine Gastrolle und eine Eigentümerrolle existieren; sowie ein
blogPost Ressourcetyp. Gästen ist es erlaubt Blogposts anzusehen, und Eigentümern ist es erlaubt zu posten und
Blogposts zu veröffentlichen. Um dieses System abzufragen könnte man das folgende machen:

.. code-block:: php
   :linenos:

   // Wir nehmen an dass das Benutzermodell vom Ressourcetyp Gast ist
   $guestUser = new Default_Model_User();
   $ownerUser = new Default_Model_Owner('OwnersUsername');

   $post = new Default_Model_BlogPost();

   $acl->isAllowed($guestUser, $post, 'view'); // true
   $acl->isAllowed($ownerUser, $post, 'view'); // true
   $acl->isAllowed($guestUser, $post, 'post'); // false
   $acl->isAllowed($ownerUser, $post, 'post'); // true

Wie man sieht können bei Ausführung der obigen Regeln entweder Eigentümer und Gäste Posts ansehen, oder neue
Posts erstellen, was Eigentümer können und Gäste nicht. Aber wie man erwarten kann ist diese Art von System
nicht so dynamisch wie man es wünschen könnte. Was, wenn wir sicherstellen wollen das einem spezifischen Benutzer
ein sehr spezifischer Blogpost gehört bevor Ihm erlaubt wird Ihn zu veröffentlichen? In anderen Worten wollen wir
sicherstellen das nur Blogpost Eigentümer nur die Möglichkeit haben Ihre eigenen Posts zu veröffentlichen.

Hier kommen Annahmen zum Einsatz. Annahmen sind Methoden welche aufgerufen werden wenn das prüfen einer statischen
Regel einfach nicht genug ist. Wenn ein Annahmeobjekt registriert wird, dann wird dieses Objekt konsultiert um,
typischerweise dynamisch, zu ermitteln ob einige Rollen Zugriff auf einige Ressourcen, mit einigen optionalen
Privilegien haben was nur durch die Logik in der Annahme beantwortet werden kann. Für dieses Beispiel verwenden
wir die folgende Annahme:

.. code-block:: php
   :linenos:

   class OwnerCanPublishBlogPostAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       /**
        * Diese Annahme sollte die aktuellen Benutzer und BlogPost Objekte
        * empfangen
        *
        * @param Zend\Permissions\Acl $acl
        * @param Zend\Permissions\Acl\Role\RoleInterface $user
        * @param Zend\Permissions\Acl\Resource\ResourceInterface $blogPost
        * @param $privilege
        * @return bool
        */
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $user = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $blogPost = null,
                              $privilege = null)
       {
           if (!$user instanceof Default_Model_User) {
               throw new Exception(__CLASS__
                                 . '::'
                                 . __METHOD__
                                 . ' erwartet das die Rolle eine'
                                 . ' Instanz von user ist');
           }

           if (!$blogPost instanceof Default_Model_BlogPost) {
               throw new Exception(__CLASS__
                                 . '::'
                                 . __METHOD__
                                 . ' erwartet das die Ressource eine'
                                 . ' Instanz von BlogPost ist');
           }

           // Wenn die Rolle ein publisher ist kann Sie einen Post immer verändern
           if ($user->getRoleId() == 'publisher') {
               return true;
           }

           // Prüfen um sicherzustellen das alle anderen nur deren eigene Posts
           // verändern
           if ($user->id != null && $blogPost->ownerUserId == $user->id) {
               return true;
           } else {
               return false;
           }
       }
   }

Um dies mit unserem *ACL* System zu verknüpfen würden wir das folgende tun:

.. code-block:: php
   :linenos:

   // Dies ersetzen:
   //   $acl->allow('owner', 'blogPost', 'publish');
   // Mit diesem:
   $acl->allow('owner',
               'blogPost',
               'publish',
               new OwnerCanPublishBlogPostAssertion());

   // Auch die Rolle"publisher" hinzufügen der auf alles Zugriff hat
   $acl->allow('publisher', 'blogPost', 'publish');

Jetzt wird jedesmal wenn *ACL* darüber konsultiert wird ob ein Benutzer einen spezifischen Blogpost
veröffentlichen kann diese Annahme ausgeführt. Diese Annahme stellt sicher dass, solange der Rollentyp nicht
'publisher' ist, die Benutzerrolle der Anfrage logisch mit dem Blogpost verbunden sein muss. In diesem Beispiel
haben wir geprüft das die Eigenschaft ``ownerUserId`` des Blogposts mit der übergebenen Id des Benutzers
übereinstimmt.


