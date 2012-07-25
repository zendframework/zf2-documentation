.. _zend.json.objects:

Obiekty JSON
============

Kiedy kodujemy obiekt PHP jako JSON, wszystkie publiczne właściwości tego obiektu zostaną zakodowane w obiekcie
JSON.

JSON nie pozwala na referencje obiektów, więc musisz uważać abyś nie próbował kodować obiektów z
rekurencyjnymi referencjami. Jeśli masz problemy z rekurencją, metody *Zend_Json::encode()* oraz
*Zend_Json_Encoder::encode()* przyjmują opcjonalny drugi parametr, określający czy ma być sprawdzana
rekurencja; jeśli obiekt jest kodowany drugi raz, zostanie wyrzucony wyjątek.

Odkodowanie obiektów JSON sprawia dodatkową trudność, ponieważ obiekty Javascript prawie dokładnie
odpowiadają tablicom asocjacyjnym PHP. Jedni proponują aby przekazywać identyfikator klasy, a następnie
tworzyć instancję obiektu tej klasy i wypełniać ją parami klucz/wartość obiektu JSON; inni ostrzegają, że
mogłoby to być istotną luką w bezpieczeństwie.

Domyślnie *Zend_Json* odkoduje obiekty JSON jako tablice asocjacyjne. Jednak jeśli chcesz odebrać obiekt,
możesz to określić w ten sposób:

.. code-block:: php
   :linenos:

   // Odkoduj obiekty JSON jako obiekty PHP
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);


Wszystkie dekodowane obiekty są zwracane jako obiekty klasy *StdClass* z właściwościami odpowiadającymi parom
klucz/wartość z obiektu JSON.

Zalecane jest aby to programista decydował o tym w jaki sposób mają być odkodowane obiekty JSON. Jeśli
powinien być utworzony obiekt konkretnego typu, może być on utworzony w kodzie aplikacji, a następnie
wypełniony wartościami odkodowanymi za pomocą *Zend_Json*.


