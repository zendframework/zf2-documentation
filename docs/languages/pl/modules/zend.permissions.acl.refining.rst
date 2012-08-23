.. EN-Revision: none
.. _zend.permissions.acl.refining:

Analiza kontroli dostępu
========================

.. _zend.permissions.acl.refining.precise:

Precyzyjna kontrola dostępu
---------------------------

Podstawowe *ACL* zdefiniowane w :ref:`poprzedniej sekcji <zend.permissions.acl.introduction>` pokazują jakie rozmaite
uprawnienia mogą być dozwolone dla *ACL* (dla wszystkich zasobów). W praktyce, kontrola dostępu ma skłonność
do posiadania wyjątków od reguł oraz różnych stopni skomplikowania. ``Zend\Permissions\Acl`` pozwoli ci przeprowadzić te
analizy w przystępny i elastyczny sposób.

W przykładowej aplikacji *CMS*, zostało zdecydowane, że podczas gdy grupa 'staff' pokryje potrzeby większości
użytkowników, potrzebna jest jeszcze jedna nowa grupa 'marketing', która wymaga dostępu do newslettera oraz
ostatnich nowości w *CMS*. Ta grupa jest naprawdę samowystarczalna i będzie dawała możliwość publikowania
oraz archiwizowania zarówno newsletterów jak i ostatnich nowości.

Dodatkowo, zażądano także aby grupa 'staff' miała pozwolenie do przeglądania nowości, ale żeby nie mogła
przeglądać ostatnich nowości. Dodatkowo, archiwizowanie 'zapowiedzi' nie powinno być w ogóle możliwe (nawet
przez administratora), ponieważ ich okres ważności to 1-2 dni.

Wpierw przejrzymy rejestr ról, aby rozważyć te zmiany. Określiliśmy, że grupa 'marketing' ma te same
podstawowe uprawnienia co grupa 'staff', więc zdefiniujemy grupę 'marketing' w taki sposób, aby dziedziczyła
uprawnienia od grupy 'staff':

.. code-block:: php
   :linenos:

   // Nowa grupa marketing dziedziczy uprawnienia od grupy staff
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');

Zauważ, że powyższa kontrola dostępu odnosi się do określonych zasobów (np., "newsletter", "ostatnie
nowości", "zapowiedzi"). Teraz dodamy te zasoby:

.. code-block:: php
   :linenos:

   // Utwórz zasoby dla reguł

   // newsletter
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // nowości
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // ostatnie nowości
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // zapowiedzi
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');

Teraz prostą sprawą jest zdefiniowanie bardziej specyficznych reguł na docelowych obszarach *ACL*:

.. code-block:: php
   :linenos:

   // Grupa marketing musi mieć możliwość publikowania i archiwizowania
   // newsletterów oraz ostatnich nowości
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Grupa Staff (oraz marketing przez dziedziczenie), ma zabroniony dostęp
   // do przeglądania ostatnich nowości
   $acl->deny('staff', 'latest', 'revise');

   // Każdy (włączając w to administratorów) ma zabroniony dostęp do
   // archiwizowania zapowiedzi
   $acl->deny(null, 'announcement', 'archive');

Teraz możemy przeprowadzić zapytanie do *ACL* z uwzględnieniem ostatnich zmian:

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied";
   // zabronione

.. _zend.permissions.acl.refining.removing:

Usuwanie kontroli dostępu
-------------------------

Aby usunąć jedną lub więcej reguł z *ACL*, po prostu użyj dostępnych metod ``removeAllow()`` lub
``removeDeny()``. Podobnie jak w metodach ``allow()`` oraz ``deny()``, możesz podać wartość ``NULL`` aby
oznaczyć wszystkie role, wszystkie zasoby i/lub wszystkie przywileje:

.. code-block:: php
   :linenos:

   // Usunięcie zabronienia możliwości przeglądania ostatnich nowości
   // przez grupę staff (oraz marketing, przez dziedziczenie)
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // dozwolone

   // Usunięcie wszystkich pozwoleń publikowania i archiwizowania newsletterów
   // przez grupę marketing
   $acl->removeAllow('marketing', 'newsletter', array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied";
   // zabronione

Przywileje mogą być modyfikowane inkrementalnie jak pokazano wyżej, ale wartość ``NULL`` dla przywilejów
nadpisuje te inkrementalne zmiany:

.. code-block:: php
   :linenos:

   // Nadanie grupie marketing wszystkich uprawnień związanych z ostatnimi nowościami
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied";
   // dozwolone


