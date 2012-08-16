.. EN-Revision: none
.. _zend.permissions.acl.introduction:

Wprowadzenie
============

``Zend\Permissions\Acl`` zapewnia lekką i elastyczną obsługę implementacji list kontroli dostępu (*ACL*) do zarządzania
uprawnieniami. Ogólnie rzecz biorąc, aplikacja może używać list *ACL* do kontrolowania dostępu do
określonych chronionych obiektów przez inne obiekty.

Dla celów tej dokumentacji:

- **zasób** jest obiektem do którego dostęp jest kontrolowany.

- **rola** jest obiektem, który może zażądać dostępu do zasobu.

Przystępnie mówiąc, **role żądają dostępu do zasobów**. Na przykład, jeśli obsługujący parking
samochodow zażąda dostępu do samochodu, to ta osoba jest rolą, a samochód jest zasobem, więc dostęp do
samochodu nie musi zostać przyznany każdemu.

Dzięki określeniu i użyciu list kontroli dostępu (*ACL*), aplikacja może kontrolować to, w jaki sposób
żądające obiekty (role) mają przydzielany dostęp do chronionych obiektów (zasobów).

.. _zend.permissions.acl.introduction.resources:

O zasobach
----------

Tworzenie zasobu w Zend\Permissions\Acl jest bardzo proste. ``Zend\Permissions\Acl`` zapewnia interfejs ``Zend\Permissions\Acl\Resource\ResourceInterface`` aby
ułatwić programistom tworzenie zasobów w aplikacji. Klasa jedynie implementuje ten interfejs, który składa
się z jednej metody, ``getResourceId()``, dzięki ktorej ``Zend\Permissions\Acl`` wie, że obiekt jest zasobem. Dodatkowo w
``Zend\Permissions\Acl`` dołączona jest klasa ``Zend\Permissions\Acl\Resource``, która jest podstawową implementacją zasobu do użycia
przez programistów gdy jest to potrzebne.

``Zend\Permissions\Acl`` zapewnia drzewiastą strukturę, w której mogą być dodawane zasoby (lub inaczej "obszary będące
pod kontrolą"). Dzięki temu, że zasoby są przechowywane w strukturze drzewiastej, mogą być one organizowane
od ogólnych (od korzeni) do szczegółowych (do gałęzi). Zapytanie do konkretnego zasobu automatycznie przeszuka
całą hierarchię zasobów, dla reguł przypisanych do przodka zasobów, pozwalając na proste dziedziczenie
reguł. Na przykład, jeśli domyślna reguła ma być zastosowana do każdego budynku w mieście, wystarczy
przypisać regułę do miasta, zamiast przypisywać regułę to każdego z budynków z osobna. Niektóre z
budynków mogą wymagać wyjątków od tej reguły i może być to osiągnięte w łatwy sposób w ``Zend\Permissions\Acl``
poprzez przypisanie takiej wyjątkowej reguły dla każdego z budynków wymagających wyjątku. Zasób może
dziedziczyć tylko od jednego zasobu rodzica, a ten rodzic może także dziedziczyć tylko od jednego zasobu itd.

``Zend\Permissions\Acl`` także obsługuje przywileje dla zasobów (np., "create", "read", "update", "delete") i programista
może przypisać reguły, które mają zastosowanie do wszystkich przywilejów, lub dla konkretnych przywilejów
dla jednego lub więcej zasobów.

.. _zend.permissions.acl.introduction.roles:

O rolach
--------

Tak jak tworzenie zasobów, tworzenie ról także jest bardzo proste. Wszystkie role muszą implementować
interfejs ``Zend\Permissions\Acl\Role\RoleInterface`` Ten interfejs składa się z jednej metody, ``getRoleId()``, dzięki ktorej
Zend\Permissions\Acl wie, że obiekt jest rolą. Dodatkowo w Zend\Permissions\Acl dołączona jest klasa ``Zend\Permissions\Acl\Role``, która jest
podstawową implementacją roli do użycia przez programistów gdy jest to potrzebne.

W ``Zend\Permissions\Acl`` rola może dziedziczyć z jednej lub więcej ról. Jest to po to, aby możliwe było dziedziczenie
zasad dla ról. Na przykład rola, użytkownik "sally", może dziedziczyć z jednej lub więcej ról rodziców,
takich jak na przykład "editor" oraz "administrator". Programista może przypisać reguły dla ról "editor" oraz
"administrator" osobno, a "sally" będzie dziedziczyć te reguły od obu ról, bez konieczności przypisania reguł
bezpośrednio dla "sally".

Chociaż możliwość dziedziczenia po wielu rolach jest bardzo użyteczna, to takie dziedziczenie wprowadza pewien
stopień złożoności. Poniższy przykład ilustruje niejasny przypadek dziedziczenia i pokazuje w jaki sposób
``Zend\Permissions\Acl`` go rozwiązuje.

.. _zend.permissions.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Dziedziczenie po wielu rolach

Poniższy kod definiuje trzy podstawowe role, po których inne role mogą dziedziczyć - "guest", "member", oraz
"admin". Następnie definiowana jest rola o nazwie "someUser", ktora dziedziczy po zdefiniowanych wcześniej trzech
rolach. Ważna jest kolejność zdefiniowania tych trzech ról w tablicy ``$parents``. Gdy sprawdzamy reguły
dostępu, ``Zend\Permissions\Acl`` szuka reguł zdefiniowanych nie tylko dla danej roli (w tym przypadku someUser"), ale także
dla ról, po których ta rola dziedziczy (w tym przypadku "guest", "member" oraz "admin"):

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('guest'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('member'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('someUser'), $parents);

   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

Z tego względu, że nie ma zdefiniowanych reguł konkretnie dla roli "someUser" oraz dla zasobu "someResource",
``Zend\Permissions\Acl`` musi szukać zasad, ktore mogą być zdefiniowane dla ról, po których dziedziczy rola "someUser>".
Wpierw sprawdzana jest rola "admin", a dla niej nie ma zdefiniowanej żadnej reguły dostępu. Następnie
sprawdzana jest rola "member" i ``Zend\Permissions\Acl`` znajduje zdefiniowaną regułę zezwalająca roli "member" na dostęp
do zasobu "someResource".

Jeśli ``Zend\Permissions\Acl`` kontynuowałby sprawdzanie reguł zdefiniowanych dla innych ról rodziców, znalazłby regułę
zabraniającą roli "guest" dostępu do zasobu "someResource". Ten fakt wprowadza niejaność, ponieważ teraz rola
"someUser" ma zarówno dozwolony jak i zabroniony dostęp do zasobu "someResource", z tego powodu, że posiada
odziedziczone po dwóch rolach reguły, które są ze sobą sprzeczne.

``Zend\Permissions\Acl`` rozwiązuje tę niejaśność kończąc zapytanie wtedy, gdy znajdzie pierwszą regułę, wprost
pasującą do zapytania. W tym przypadku, z tego względu, że rola "member" jest sprawdzana przed rolą "guest",
przykładowy kod wyświetliłby "allowed".

.. note::

   Gdy określasz wielu rodziców dla roli, pamiętaj, że ostatni rodzic na liście jest pierwszym przeszukiwanym
   rodzicem w celu znalezienia ról pasujących do zapytania autoryzacyjnego.

.. _zend.permissions.acl.introduction.creating:

Tworzenie list kontroli dostępu
-------------------------------

*ACL* może reprezentować dowolny zestaw fizycznych lub wirtualnych obiektów których potrzebujesz. Dla celów
prezentacji utworzymy *ACL* dla prostego Systemu Zarządzania Treścią (Content Management System -*CMS*), w
którym różnymi obszarami zarządza kilka poziomów grup. Aby utworzyć nowy obiekt *ACL*, utwórzmy instancję
*ACL* bez parametrów:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

.. note::

   Dopóki programista nie określi reguły "allow", ``Zend\Permissions\Acl`` zabroni dostępu wszystkim rolom do wszystkich
   przywilejów dla wszystkich zasobów.

.. _zend.permissions.acl.introduction.role_registry:

Rejestrowanie ról
-----------------

System Zarządzania Treścią prawie zawsze potrzebuje hierarchii uprawnień aby określić możliwości jego
użytkowników. Może być tu grupa 'Guest' aby pozwolić na limitowany dostęp dla celów demonstracyjnych, grupa
'Staff' dla większości użytkowników aplikacji *CMS*, którzy przeprowadzają najczęstsze codzienne operacje,
grupa 'Editor' dla tych odpowiedzialnych za publikowanie, przeglądanie, archiwizowanie i usuwanie zawartości i
ostatecznie grupa 'Administrator', której zadania obejmują zarówno zadania wszystkich innych grup, jak i
zarządzanie ważnymi informacjami, zarządzanie użytkownikami, konfigurację baz danych oraz przeprowadzanie
kopii zapasowych/eksportu danych. Ten zestaw pozwoleń może być reprezentowany w rejestrze ról, pozwalając
każdej grupie dziedziczyć uprawnienia z grup rodziców, a także umożliwiając każdej z grup posiadanie
własnych unikalnych uprawnień. Uprawnienia mogą być wyrażone w taki sposób:

.. _zend.permissions.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Kontrola dostępu dla przykładowego CMS

   +-------------+------------------------+------------------------+
   |Nazwa        |Unikalne uprawnienia    |Dzidziczy uprawnienia od|
   +=============+========================+========================+
   |Guest        |View                    |N/A                     |
   +-------------+------------------------+------------------------+
   |Staff        |Edit, Submit, Revise    |Guest                   |
   +-------------+------------------------+------------------------+
   |Editor       |Publish, Archive, Delete|Staff                   |
   +-------------+------------------------+------------------------+
   |Administrator|(posiada cały dostęp)   |N/A                     |
   +-------------+------------------------+------------------------+

W tym przykładzie użyty jest obiekt ``Zend\Permissions\Acl\Role``, ale dozwolony jest dowolny obiekt, który implementuje
interfejs ``Zend\Permissions\Acl\Role\RoleInterface``. Te grupy mogą być dodane do rejestru ról w taki sposób:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   // Dodajemy grupy do rejestru ról używając obiektu Zend\Permissions\Acl\Role
   // Grupa guest nie dziedziczy kontroli dostępu
   $roleGuest = new Zend\Permissions\Acl\Role\GenericRole('guest');
   $acl->addRole($roleGuest);

   // Grupa staff dzidziczy od grupy guest
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), $roleGuest);

   /*
   alternatywnie, powyższe mogłoby wyglądać tak:
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), 'guest');
   */

   // Grupa editor dziedziczy od grupy staff
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'staff');

   // Administrator nie dziedziczy kontroli dostępu
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));

.. _zend.permissions.acl.introduction.defining:

Definiowanie kontroli dostępu
-----------------------------

Teraz gdy *ACL* zawiera stosowne role, możemy ustalić reguły, które definiują w jaki sposób role mają
uzyskiwać dostęp do zasobów. Mogłeś zauważyć, że nie zdefiniowaliśmy w tym przykładzie żadnych
konkretnych zasobów, co jest uproszczone w celu zilustrowania, że reguły mają zastosowanie do wszystkich
zasobów. ``Zend\Permissions\Acl`` zapewnia implementację dzięki której reguły mogą być przypisane od ogólnych do
szczegółowych, minimalizując ilość potrzebnych reguł, ponieważ zasoby oraz role dziedziczą reguły, które
są definiowane dla ich przodków.

.. note::

   W zasadzie ``Zend\Permissions\Acl`` przestrzega danej reguły tylko wtedy, gdy nie ma zastosowania bardziej szczegółowa
   reguła.

Możemy więc zdefiniować rozsądny kompleksowy zestaw reguł przy minimalnej ilości kodu. Aby zastosować
podstawowe uprawnienia zdefiniowane wyżej zrób tak:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   $roleGuest = new Zend\Permissions\Acl\Role\GenericRole('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), $roleGuest);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'staff');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));

   // Grupa guest może tylko oglądać zawartość
   $acl->allow($roleGuest, null, 'view');

   /*
   alternatywnie, powyższe mogłoby wyglądać tak:
   $acl->allow('guest', null, 'view');
   */

   // Grupa staff dzidziczy uprawnienia view od grupy guest,
   // ale także potrzebuje dodatkowych uprawnień
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Grupa editor dziedziczy uprawnienia view, edit, submit,
   // oraz revise od grupy staff, ale także potrzebuje dodatkowych uprawnień
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator nie dziedziczy niczego, ale ma dostęp do wszystkich zasobów
   $acl->allow('administrator');

Wartości ``NULL`` w powyższych wywołaniach metod ``allow()`` oznaczają, że reguły dotyczą wszystkich
zasobów.

.. _zend.permissions.acl.introduction.querying:

Zapytania ACL
-------------

Posiadamy teraz elastyczne *ACL*, ktore mogą być użyte do określenia, czy żądająca osoba posiada uprawnienia
do przeprowadzenia określonej akcji w aplikacji web. Przeprowadzenie zapytań jest bardzo proste poprzez użycie
metody ``isAllowed()``:

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied";
   // zabronione

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied";
   // dozwolone

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied";
   // dozwolone ponieważ jest dziedziczone od gościa

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied";
   // zabronione ponieważ nie ma reguły dla 'update'

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied";
   // dozwolone ponieważ administrator ma wszystkie uprawnienia

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied";
   // dozwolone ponieważ administrator ma wszystkie uprawnienia

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied";
   // dozwolone ponieważ administrator ma wszystkie uprawnienia


