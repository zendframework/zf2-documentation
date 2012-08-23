.. EN-Revision: none
.. _zend.validator.introduction:

Wprowadzenie
============

Komponent Zend_Validate zapewnia zestaw najczęściej potrzebnych weryfikatorów. Zapewnia też prosty mechanizm
łańcuchowego wywoływania weryfikatorów, dzięki ktoremu wiele filtrów może być dodanych do jednej danej w
kolejności zdefiniowanej przez programistę.

.. _zend.validator.introduction.definition:

Czym jest weryfikator?
----------------------

Weryfikator bada dane wejściowe w oparciu o pewne wymagania i tworzy wynik w postaci wartości logicznej -
wartość ta mówi czy dane wejściowe spełniają te wymagania. Jeśli dane wejściowe nie spełniają wymagań,
weryfikator może dodatkowo przekazać informacje o tym, które z wymagań nie zostały spełnione.

Na przykład, aplikacja web może wymagać, aby długość nazwy użytkownika mieściła się pomiędzy sześcioma
a dwunastoma znakami, a znaki te były jedynie z grupy znaków alfanumerycznych. Weryfikator może być użyty do
sprawdzenia czy nazwa użytkownika spełnia te wymagania. Jeśli wybrana nazwa użytkownika nie spełni jednego lub
obu tych wymagań, użytecznie by było wiedzieć, które z wymagań nie zostało spełnione.

.. _zend.validator.introduction.using:

Podstawowe użycie weryfikatorów
-------------------------------

Mająć ustaloną w ten sposób definicję weryfikacji, możemy zapewnić podstawę dla interfejsu
*Zend_Validate_Interface*, który wymaga zaimplementowania przez klasę weryfikatora dwóch metod, *isValid()* oraz
*getMessages()*. Metoda *isValid()* przeprowadza weryfikację podanej wartości, zwracając *true* wtedy i tylko
wtedy, gdy wartość spełnia kryteria weryfikacji.

Jeśli metoda *isValid()* zwróci *false*, za pomocą metody *getMessages()* można pobrać tablicę wiadomości
wyjaśniających powody niepowodzenia weryfikacji. Klucze elementów tablicy są krótkimi łańcuchami znaków,
które identyfikują powody nieudanej weryfikacji, a wartości elementów odpowiadają pełnym treściom
komunikatów. Klucze i wartości są zależne od klasy; każda klasa weryfikatora definiuje własny zestaw
komunikatów o nieudanej weryfikacji, a także klucze identyfikujące je. Każda klasa posiada także definicje
stałych *const*, które odpowiadają identyfikatorom komunikatów o nieudanej weryfikacji.

.. note::

   Metoda *getMessages()* zwracaja informacje o nieudanej weryfikacji tylko dla ostatniego wywołania metody
   *isValid()*. Każde wywołanie metody *isValid()* czyści wszystkie komunikaty i błędy, które wystąpiły
   podczas poprzedniego wywołania metody *isValid()*, ponieważ najczęściej jest tak, że każde wywołanie
   metody *isValid()* występuje dla innej wartości danych przychodzących.

Poniższy przykład pokazuje weryfikację adresu e-mail:

   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_EmailAddress();

      if ($validator->isValid($email)) {
          // adres email jest prawidłowy
      } else {
          // adres email jest nieprawidłowy; wyświetlamy komunikat
          foreach ($validator->getMessages() as $messageId => $message) {
              echo "Weryfikacja nieudana '$messageId': $message\n";
          }
      }




.. _zend.validator.introduction.messages:

Własne komunikaty
-----------------

Klasy weryfikatorów zapewniają metodę *setMessage()* za pomocą które możesz określić format komunikatu
zwracanego przez metodę *getMessages()* w przypadku nieudanej weryfikacji. Pierwszy argument tej metody jest
łańcuchem znaków zawierającym treść komunikatu błędu. W tym łańcuchu znaków możesz użyć
identyfikatorów, które zostaną zastąpione odpowiednimi danymi pochodzącymi z weryfikatora. Identyfikator
*%value%* jest obsługiwany przez wszystkie weryfikatory; będzie on zastąpiony wartością, która została
przekazana do metody *isValid()*. Inne identyfikatory mogą być obsługiwane indywidualnie w każdej klasie
weryfikatora. Na przykład identyfikator *%max%* jest obsługiwany przez klasę *Zend_Validate_LessThan*. Metoda
*getMessageVariables()* zwraca tablicę identyfikatorów obsługiwanych przez weryfikator.

Drugi opcjonalny argument jest łańcuchem znaków, który identyfikuje szablon komunikatu który chcesz ustawić,
co jest przydatne gdy klasa definiuje więcej niż jeden komunikatów o błędach. Jeśli pominiesz drugi argument,
metoda *setMessage()* założy, że komunikat, który określisz powinien być użyty dla pierwszego szablonu
komunikatu zadeklarowanego w klasie weryfikatora. Wiele klas weryfikatorów posiada tylko jeden szablon komunikatu
błędu, więc nie ma potrzeby dokładnego określania szablonu komunikatu, który chcesz nadpisać.



   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_StringLength(8);

      $validator->setMessage(
          'Łańcuch znaków \'%value%\' jest za krotki; ' .
          'musi składać się z przynajmniej %min% znaków',
          Zend_Validate_StringLength::TOO_SHORT);

      if (!$validator->isValid('word')) {
          $messages = $validator->getMessages();
          echo current($messages);

          // "Łańcuch znaków 'word' jest za krotki;
          // musi składać się z przynajmniej 8 znaków"
      }




Możesz ustawić wiele komunikatów na raz używając metody *setMessages()*. Jej argumentem jest tablica
zawierająca pary klucz/komunikat.

   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_StringLength(8, 12);

      $validator->setMessages( array(
          Zend_Validate_StringLength::TOO_SHORT =>
              'Łańcuch znaków \'%value%\' jest za krótki',
          Zend_Validate_StringLength::TOO_LONG  =>
              'Łańcuch znaków \'%value%\' jest za długi'
      ));




Jeśli twoja aplikacja wymaga większej elastyczności w związku z raportowaniem nieudanej weryfikacji, możesz
uzyskać dostęp do właściwości używając tych samych nazw, co identyfikatory komunikatów używane przez daną
klasę weryfikatora. Właściwość *value* jest zawsze dostępna w weryfikatorze; jest to wartość, która
została podana jako argument metody *isValid()*. Inne właściwości mogą być obsługiwane indywidualnie w
każdej klasie weryfikatora.

   .. code-block:: php
      :linenos:

      $validator = new Zend_Validate_StringLength(8, 12);

      if (!validator->isValid('word')) {
          echo 'Słowo niepoprawne: '
              . $validator->value
              . '; długość nie jest pomiędzy '
              . $validator->min
              . ' i '
              . $validator->max
              . "\n";
      }




.. _zend.validator.introduction.static:

Użycie statycznej metody is()
-----------------------------

Jeśli niewygodne jest ładowanie danej klasy weryfikatora i tworzenie instancji weryfikatora, możesz użyć
statycznej metody *Zend_Validate::is()* jako alternatywnego sposobu wywołania. Pierwszym argumentem tej metody są
dane wejściowe, które chcesz przekazać do metody *isValid()*. Drugi argument jest łańcuchem znaków, który
odpowiada, bazowej nazwie klasy weryfikatora, relatywnie do przestrzeni nazw *Zend_Validate*. Metoda *is()*
automatycznie ładuje klasę, tworzy instancję i wywołuje metodę *isValid()* na danych wejściowych.

   .. code-block:: php
      :linenos:

      if (Zend_Validate::is($email, 'EmailAddress')) {
          // Tak, adres email jest poprawny
      }




Możesz także przekazać tablicę argumentów konstruktora, jeśli są one potrzebne w klasie weryfikatora.

   .. code-block:: php
      :linenos:

      if (Zend_Validate::is($value, 'Between', array(1, 12))) {
          // Tak, wartość $value jest pomiędzy 1 i 12
      }




Metoda *is()* zwraca wartość logiczną, taką samą jak metoda *isValid()*. Gdy używana jest metoda statyczna
*is()*, komunikaty o nieudanej weryfikacji są niedostępne.

Użycie statyczne może być wygodne dla jednorazowego wywołania weryfikatora, ale jeśli musisz wywołać
weryfikator dla większej ilości danych, bardziej efektywne jest wykorzystanie rozwiązania niestatycznego, czyli
utworzenie instancji obiektu weryfikatora i wywołanie metody *isValid()*.

Dodatkowo klasa *Zend_Filter_Input* pozwala na utworzenie instancji i wywołanie większej ilości klas filtrów i
weryfikatorów w celu przetworzenia zestawu danych wejściowych. Zobacz :ref:` <zend.filter.input>`.


