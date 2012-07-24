.. _zend.permissions.acl.advanced:

Zaawansowane użycie
===================

.. _zend.permissions.acl.advanced.storing:

Trwałe przechowywanie danych ACL
--------------------------------

Klasa ``Zend\Permissions\Acl`` została zaprojektowana w taki sposób, aby nie wymagała żadnej szczególnej technologii
backendu do przechowywania danych *ACL* takiej jak np. baza danych czy serwer buforujący. Kompletna implementacja
w *PHP* pozwala na podstawie *Zend\Permissions\Acl* budować dostosowane narzędzia administracyjne, które są relatywnie
łatwe oraz elastyczne. Wiele sytuacji wymaga pewnej formy interaktywnego zarządzania *ACL*, a ``Zend\Permissions\Acl``
zapewnia metody do ustawiania oraz odpytywania kontroli dostępu aplikacji.

Przechowywanie danych *ACL* jest zadaniem pozostawionym dla programisty, dlatego, że przykłady użycia mogą się
bardzo różnić w rozmaitych sytuacjach. Ponieważ możliwe jest serializowanie ``Zend\Permissions\Acl``, obiekty *ACL* mogą
być serializowane za pomocą funkcji *PHP* `serialize()`_, a wyniki mogą być przechowane tam gdzie określi to
programista, na przykład w pliku, w bazie danych lub w mechanizmie buforowania.

.. _zend.permissions.acl.advanced.assertions:

Tworzenie warunkowych reguł ACL z zapewnieniami
-----------------------------------------------

Czasem reguła przyznawania lub zabraniania dostępu roli do zasobu nie powinna być absolutna, ale powinna być
oparta na różnych kryteriach. Na przykład załóżmy, że pewien dostęp powinien być przyznany, ale jedynie
między godziną 8:00 a 17:00. Innym przykładem może być zabranie dostępu adresom IP, które zostały oznaczone
jako źródło nadużyć. ``Zend\Permissions\Acl`` ma wbudowaną obsługę implementowania reguł opartych na dowolnych
warunkach, wedle potrzeb programisty.

``Zend\Permissions\Acl`` zapewnia obsługę warunkowych reguł za pomocą interfejsu ``Zend\Permissions\Acl\Assert\AssertInterface``. W celu
użycia interfejsu zapewnień reguł, programista pisze klasę, ktora implementuje metodę ``assert()`` interfejsu:

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

Kiedy klasa zapewnień jest już dostępna, programista musi przekazać klasę zapewnień kiedy przypisuje regułę
warunkową. Reguła, która jest utworzona z klasą zapewnienia będzie jedynie stosowana wtedy, gdy metoda
zapewnienia zwróci logiczną wartośc ``TRUE``.

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());

Powyższy kod tworzy warunkową regułę dostępu, ktora pozwala na dostęp do wszystkich przywilejów do
wszystkich zasobów dla wszystkich ról, z wyjątkiem adresów IP, będących na czarnej liście. Jeśli żądanie
pochodzi z adresu IP, który nie jest uznany jako "czysty", wtedy reguła nie ma zastosowania. Z tego względu, że
reguła ma zastosowanie do wszystkich ról, zasobów oraz przywilejów, zablokowany adres IP będzie miał
zabroniony cały dostęp. Jest to specjalny przypadek i powinien być zrozumiany tak, że we wszystkich innych
przypadkach (np., tam gdzie specyficzna rola, zasób lub przywilej są określone w regule), nieudane zapewnienie
spowoduje, że reguła nie zostanie zastosowana i inne reguły powinny być zastosowane aby określić czy dostęp
jest dozwolony czy zabroniony.

Metoda ``assert()`` obiektu zapewnienia jest przekazywana do ACL, roli, zasobu, oraz przywileju do których stosuje
się zapytanie autoryzacyjne (np., ``isAllowed()``), w celu dostarczenia kontekstu dla klasy zapewnienia aby
określić warunki zapewnienia tam gdzie są one potrzebne.



.. _`serialize()`: http://php.net/serialize
