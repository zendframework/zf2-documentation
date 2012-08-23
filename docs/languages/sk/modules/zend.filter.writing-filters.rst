.. EN-Revision: none
.. _zend.filter.writing_filters:

Písanie filtrov
===============

Zend_Filter poskytuje často používané filtre, ale vývojári často potrebujú napísať filtre pre
špecifické prípady. Úloha napísania filtra je zjednodušená implementáciou rozhrania
*Zend_Filter_Interface*.

Rozhranie *Zend_Filter_Interface* definuje len jednu metodu *filter()* ktorá je implementovaná odvodenou triedou.
Objekt, ktorý implementuje rozhranie môže byť zaradený do postupnosti filtrov pomocou
*Zend_Filter::addFilter()*.

Nasledujúci príklad ukazuje ako vytvoriť vlastný filter:

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Filter/Interface.php';

      class MyFilter implements Zend_Filter_Interface
      {
          public function filter($value)
          {
              // vykonanie príkazov na $value pre získanie $valueFiltered

              return $valueFiltered;
          }
      }


Pridanie inštancie uvedeného filtra do postupnosti filtrov:

   .. code-block:: php
      :linenos:

      <?php
      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new MyFilter());



