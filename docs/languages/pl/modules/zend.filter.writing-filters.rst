.. EN-Revision: none
.. _zend.filter.writing_filters:

Pisanie filtrów
===============

Zend_Filter zapewnia zestaw najczęściej potrzebnych filtrów, ale programiści często potrzebują napisać
własne filtry dla ich szczególnych zastosowań. Zadanie pisania własnego filtru jest ułatwione przez
implementację interfejsu *Zend\Filter\Interface*.

*Zend\Filter\Interface* definiuje jedną metodę, *filter()*, która może być implementowana przez klasy
użytkownika. Obiekt, który implementuje ten interfejs może być dodany do łańcucha filtrów za pomocą metody
*Zend\Filter\Filter::addFilter()*.

Poniższy przykład pokazuje w jaki sposób pisze się własny filtr:

   .. code-block:: php
      :linenos:

      class MyFilter implements Zend\Filter\Interface
      {
          public function filter($value)
          {
              // przeprowadź jakieś transformacje zmiennej $value do $valueFiltered

              return $valueFiltered;
          }
      }




Aby dodać instancję powyższego filtra do łańcucha filtrów:

   .. code-block:: php
      :linenos:

      $filterChain = new Zend\Filter\Filter();
      $filterChain->addFilter(new MyFilter());





