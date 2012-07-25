.. _zend.filter.filter_chains:

Postupnosť filtrov
==================

Často je požadované aplikovanie viacerých filtrov v požadovanom poradí. Napríklad prihlasovacií formulár
akceptuje iba prihlasovacie meno ktoré môže byť len z malých písmen. Trieda *Zend_Filter* poskytuje
jednoduchý spôsob ako vytvoriť postupnosť filtrov. Nasledujúci príklad ukazuje vytvorenie postupnosti dvoch
filtrov pre prihlasovacie meno:

   .. code-block:: php
      :linenos:

      <?php
      // Provides filter chaining capability
      require_once 'Zend/Filter.php';

      // Filters needed for the example
      require_once 'Zend/Filter/Alpha.php';
      require_once 'Zend/Filter/StringToLower.php';

      // Create a filter chain and add filters to the chain
      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new Zend_Filter_Alpha())
                  ->addFilter(new Zend_Filter_StringToLower());

      // Filter the username
      $username = $filterChain->filter($_POST['username']);
Filtre sú volané v poradí v ktorom boli pridané do *Zend_Filter*. V predchádzajúcom príklade sú najprv
odstránené všetky znaky okrem alfabetických a následne prevedené na malé pismená.

Každý objekt ktorý implementuje *Zend_Filter_Interface* môže byť použitý v postupnosti filtrov.


