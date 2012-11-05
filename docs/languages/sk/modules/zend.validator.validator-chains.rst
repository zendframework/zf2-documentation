.. EN-Revision: none
.. _zend.validator.validator_chains:

Reťazenie validátorov
=====================

Často je potrebné aplikovať viac typov validácie na hodnotu v istom poradí. Nasledujúca ukážka objasní
princíp ako to urobiť na príklade z :ref:`úvodu <zend.validator.introduction>`, kde bolo požadované, že meno
používateľa musí mať 6 až 12 alfanumerických znakov:

   .. code-block:: php
      :linenos:

      <?php

      // Triedy na reťazenie validátorov
      require_once 'Zend/Validate.php';

      // Potrebné validátory
      require_once 'Zend/Validate/StringLength.php';
      require_once 'Zend/Validate/Alnum.php';

      // Vytvorenie zreťazenia
      $validatorChain = new Zend\Validate\Validate();
      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12))
                     ->addValidator(new Zend\Validate\Alnum());

      // Validácia username
      if ($validatorChain->isValid($username)) {
          // username zodpovedá požiadavke
      } else {
          // username nezodpovedá požiadavke; zobrazenie chýb
          foreach ($validatorChain->getMessages() as $message) {
              echo "$message\n";
          }
      }

      ?>
Validátory sú aplikované podľa podľa poradia v ktorom boli pridané do *Zend_Validate*. V uvedenom príklade
je najprv skontrolovaná dĺžka, či je medzi 6 - 12, potom či obsahuje iba alfanumerické znaky. Druhá
validácia je urobená vždy, nezávisle na výsledku prvej. Ak obidve validácie zlyhajú, potom *getMessages()*
vráti chybové správy z obidvoch validátorov.

V niektorých prípadoch je zmysluplné prerušiť validáciu ak validácia bola neúspešná. *Zend_Validate*
umožňuje takéto správanie pomocou druhého parametra metódy *addValidator()*. Nastavením
*$breakChainOnFailure* na *true* sa preruší validácia v prípade neúspešnej validácie a nebudú vykonané
všetky ostatné validácie, ktoré sú zbytočné, alebo nevhodné v danej situácii. Ak náš príklad upravíme
nasledovne, potom alfanumerická validácia neprebehne ak bude neúspešná validácia na dĺžku reťazca:

   .. code-block:: php
      :linenos:

      <?php

      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12), true)
              ->addValidator(new Zend\Validate\Alnum());

      ?>


Každý objekt ktorý implementuje *Zend\Validate\Interface* môže byť použitý v zreťazení validátorov.


