.. EN-Revision: none
.. _learning.quickstart.intro:

Zend Framework & wprowadzenie do MVC
====================================

.. _learning.quickstart.intro.zf:

Zend Framework
--------------

Zend Framework to otwarty, zorientowany obiektowo framework aplikacji webowych przeznaczony dla *PHP* 5. ZF jest
często określany mianem 'biblioteki komponentów' ponieważ składa się z wielu, luźno powiązanych części,
których można używać niezależnie od siebie. Dodatkowo Zend Framework oferuje zaawansowaną implementację
wzorca projektowego Model-Widok-Kontroler (Model-View-Controller -*MVC*), która może zostać użyta do
skonstruowania podstawowej struktury aplikacji. Pełna lista komponentów Zend Framework razem z krótkim opisem
znajduje się w dziale `omówienie komponentów`_. Wprowadzenie "QuickStart" stanowi wstęp do poznania
najczęściej używanych komponentów Zend Framework, takich jak: ``Zend_Controller``, ``Zend_Layout``,
``Zend_Config``, ``Zend_Db``, ``Zend_Db_Table``, ``Zend_Registry``, oraz kilku klas pomocniczych (view helpers).

Za pomocą tych komponentów w ciągu kilkudziesięciu minut zostanie utworzona prosta aplikacja oparta na bazie
danych - księga gości (guest book). Pełny kod źródłowy tej aplikacji jest dostępny w następujących
archiwach:

- `zip`_

- `tar.gz`_

.. _learning.quickstart.intro.mvc:

Model-View-Controller
---------------------

Tak więc, czym dokładnie jest ten będący na ustach wszystkich wzorzec *MVC*? I dlaczego miałoby to mnie
obchodzić? *MVC* to o wiele więcej niż kolejny skrót, który można mimowolnie wplatać w wypowiedź aby
spróbować wywrzeć wrażenie na innych; z biegiem czasu *MVC* nie bez przyczyny stał się standardem
projektowania nowoczesnych aplikacji webowych. Większość aplikacji sieciowych opiera się w znacznej mierze na
funkcjonalnościach, które można podzielić na trzy kategorie: warstwa prezentacji, logika biznesowa, dostęp do
danych. Wzorzec *MVC* ułatwia zaprojektowanie oprogramowania z zachowaniem odrębności każdej z tych warstw. W
efekcie kod prezentacji może zostać umieszczony w jednej części aplikacji, logika biznesowa w drugiej, a
dostęp do danych w trzeciej. Wielu programistów przekonało się, że dobrze zdefiniowane odseparowanie jest
nieodzowne dla utrzymania kodu w zorganizowanej strukturze, zwłaszcza przy projektach wieloosobowych.

.. note::

   **Więcej informacji**

   Omawiany wzorzec można podzielić na następujące części:

   .. image:: ../images/learning.quickstart.intro.mvc.png
      :width: 321
      :align: center

   - **Model**- Ta część aplikacji definiuje jej podstawowe funkcjonalności w sposób mniej lub bardziej
     abstrakcyjny. Sposób dostępu do danych oraz logika biznesowa również mogą być zdefiniowane w tym
     miejscu.

   - **View (Widok)**- Ten element definiuje wszystko to co zostaje zaprezentowane użytkownikowi. Najczęściej
     kontrolery przekazują dane do każdego z widoków do uformowania i przedstawienia w określonym formacie.
     Poprzez widoki następuje również odebranie danych od użytkownika. W tej części będzie się znajdował
     kod HTML aplikacji *MVC*.

   - **Controller (Kontroler)**- Ten składnik łączy cały wzorzec razem. Kontrolery manipulują modelami,
     decydują o widoku, jaki zostanie zaprezentowany (na podstawie interakcji z użytkownikiem). Odpowiadają
     także za przekazanie danych do widoków lub przekazanie kontroli do innego kontrolera. Większość
     ekspertów MVC zaleca `tworzenie możliwie jak najmniejszych kontrolerów`_.

   Oczywiście, aby zgłębić temat wzorca *MVC* `należałoby go rozwinąć`_ ale dla zrozumienia opisywanej
   aplikacji - księgi gości - powyższy, minimalny opis powinien wystarczyć.



.. _`omówienie komponentów`: http://framework.zend.com/about/components
.. _`zip`: http://framework.zend.com/demos/ZendFrameworkQuickstart.zip
.. _`tar.gz`: http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz
.. _`tworzenie możliwie jak najmniejszych kontrolerów`: http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model
.. _`należałoby go rozwinąć`: http://ootips.org/mvc-pattern.html
