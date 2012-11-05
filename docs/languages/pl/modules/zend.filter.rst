.. EN-Revision: none
.. _zend.filter.introduction:

Wprowadzenie
============

Komponent Zend_Filter zapewnia zestaw najczęściej potrzebnych filtrów danych. Zapewnia też prosty mechanizm
łańcuchowego wywoływania filtrów, dzięki ktoremu wiele filtrów może być dodanych do jednej danej w
kolejności zdefiniowanej przez programistę.

.. _zend.filter.introduction.definition:

Czym jest filtr?
----------------

W fizycznym świecie, filtr najczęściej jest używany do usuwania niechcianych części danych wejściowych, a
żądana część danych wejściowych przechodzi przez filtr jako dane wyjściowe (np. kawa). W takim scenariuszu
filtr jest operatorem który tworzy podzbiór danych wejściowych. Ten typ filtrowania jest użyteczny w
aplikacjach web - usuwanie niedozwolonych danych wejściowych, usuwanie niepotrzebnych białych znaków itp.

Ta podstawowa definicja filtra może być rozszerzona, aby zawierała uogólnione transformacje na danych
wejściowych. Pospolitą transformacją stosowaną w aplikacjach web jest zabezpieczanie przed encjami HTML. Na
przykład, jeśli pole formularza jest automatycznie wypełniane niefiltrowanymi danymi wejściowymi (np., z
przeglądarki internetowej), ta wartość nie może zawierać encji HTML lub posiadać jedynie zabezpieczone encje
HTML, w celu zapobiegania niechcianemu zachowaniu aplikacji oraz słabym punktom bezpieczeństwa. Aby sprostać tym
wymaganiom, encje HTML, ktore znajdują się w danych wejściowych muszą być usunięte lub zabezpieczone.
Oczywiście to, ktore podejście jest bardziej odpowiednie zależy od sytuacji. Filtr, który usuwa encje HTML
działa w kontekście pierwszej definicji filtra - operator który tworzy podzbiór danych wejściowych. Filtr,
ktory zabezpiecza encje HTML natomiast przekształca dane wejściowe (np. znak "*&*" jest zamieniany na "*&amp;*").
Wspieranie programistów przy takich przypadkach użycia jest ważne, i "filtrowanie" w kontekście użycia
Zend_Filter oznacza przeprowadzanie pewnych transformacji na danych wejściowych.

.. _zend.filter.introduction.using:

Basic usage of filters
----------------------

Mająć ustaloną w ten sposób definicję filtra, możemy zapewnić podstawę dla interfejsu
*Zend\Filter\Interface*, który wymaga zaimplementowania przez klasę filtra jednej metody nazwanej *filter()*.

Poniżej jest podstawowy przykład użycia filtra na dwóch danych wyjściowych, na znaku Et (*&*) oraz na znaku
podwójnego cudzysłowu (*"*):

   .. code-block:: php
      :linenos:

      $htmlEntities = new Zend\Filter\HtmlEntities();

      echo $htmlEntities->filter('&'); // &
      echo $htmlEntities->filter('"'); // "




.. _zend.filter.introduction.static:

Użycie statycznej metody get()
------------------------------

Jeśli niewygodne jest ładowanie danej klasy filtra i tworzenie instancji filtra, możesz użyć statycznej metody
*Zend\Filter\Filter::get()* jako alternatywnego sposobu wywołania. Pierwszym argumentem tej metody są dane wejściowe,
które chcesz przekazać do metody *filter()*. Drugi argument jest łańcuchem znaków, który odpowiada, bazowej
nazwie klasy filtra, relatywnie do przestrzeni nazw Zend_Filter. Metoda *get()* automatycznie ładuje klasę,
tworzy instancję i wywołuje metodę *filter()* na danych wejściowych.

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::get('&', 'HtmlEntities');




Możesz także przekazać tablicę argumentów konstruktora, jeśli są one potrzebne w klasie filtra.

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::get('"', 'HtmlEntities', array(ENT_QUOTES));




Użycie statyczne może być wygodne dla jednorazowego wywołania filtra, ale jeśli musisz wywołać filtr dla
większej ilości danych, bardziej efektywne jest wykorzystanie rozwiązania pokazanego w pierwszym przykładzie,
czyli utworzenie instancji obiektu filtra i wywołanie metody *filter()*.

Dodatkowo klasa Zend\Filter\Input pozwala na utworzenie instancji i wywołanie większej ilości klas filtrów i
weryfikatorów w celu przetworzenia zestawu danych wejściowych. Zobacz :ref:` <zend.filter.input>`.


