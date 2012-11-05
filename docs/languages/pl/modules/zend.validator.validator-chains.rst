.. EN-Revision: none
.. _zend.validator.validator_chains:

Łańcuchy weryfikatorów
======================

Często do pewnej wartości potrzebujemy zastosować wiele weryfikatorów w określonej kolejności. Poniższy kod
demonstruje sposób rozwiązania przykładu z :ref:`wprowadzenia <zend.validator.introduction>`, gdzie nazwa
użytkownika musi mieć długość między 6 a 12 alfanumerycznych znaków:

   .. code-block:: php
      :linenos:

      // Tworzymy łańcuch weryfikatorów i dodajemy do niego weryfikatory
      $validatorChain = new Zend\Validate\Validate();
      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12))
                     ->addValidator(new Zend\Validate\Alnum());

      // Sprawdzamy nazwę użytkownika
      if ($validatorChain->isValid($username)) {
          // nazwa użytkownika jest poprawna
      } else {
          // nazwa użytkownika nie jest poprawna; wyświetlamy komunikaty
          foreach ($validatorChain->getMessages() as $message) {
              echo "$message\n";
          }
      }


Weryfikatory są uruchamiane w takiej kolejności, w jakiej zostały dodane do *Zend_Validate*. W powyższym
przykładzie, wpierw jest sprawdzane jest to, czy długość nazwy użytkownika mieści się miedzy 6 a 12 znaków,
a następnie sprawdzane jest czy zawiera ona tylko znaki alfanumeryczne. Druga weryfikacja, dla alfanumerycznych
znaków, jest przeprowadzana niezależnie od tego, czy pierwsza weryfikacja, dla długości pomiędzy 6 a 12
znaków udała się. Oznacza to, że jeśli nie udadzą się obie weryfikacje, to metoda *getMessages()* zwróci
wiadomości błędów pochodzące od obu weryfikatorów.

W niektórych przypadkach sensowna może być możliwość przerwania łańcucha weryfikatorów w przypadku, gdy
proces weryfikacji nie uda się. *Zend_Validate* obsługuje takie przypadki za pomocą ustawienia drugiego
parametru w metodzie *addValidator()*. Ustawiając wartość zmiennej *$breakChainOnFailure* na *true*, dodany
weryfikator przerwie łańcuchowe wywoływanie przy wystąpieniu błędu, co zapobiegnie uruchamianiu innych
weryfikacji, które w danej sytuacji zostaną uznane za bezużyteczne. Jeśli powyższy przykład byłby napisany
tak jak poniżej, wtedy weryfikacja znaków alfanumerycznych nie byłaby przeprowadzona jeśli długość
łańcucha znaków byłaby nieodpowiednia:

   .. code-block:: php
      :linenos:

      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12), true)
              ->addValidator(new Zend\Validate\Alnum());




W łańcuchu weryfikatorów może być użyty dowolny obiekt, który implementuje interfejs
*Zend\Validate\Interface*.


