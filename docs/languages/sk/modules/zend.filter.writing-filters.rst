.. EN-Revision: none
.. _zend.filter.writing_filters:

Písanie filtrov
===============

Zend_Filter poskytuje často používané filtre, ale vývojári často potrebujú napísať filtre pre
špecifické prípady. Úloha napísania filtra je zjednodušená implementáciou rozhrania
*Zend\Filter\Interface*.

Rozhranie *Zend\Filter\Interface* definuje len jednu metodu *filter()* ktorá je implementovaná odvodenou triedou.
Objekt, ktorý implementuje rozhranie môže byť zaradený do postupnosti filtrov pomocou
*Zend\Filter\Filter::addFilter()*.

Nasledujúci príklad ukazuje ako vytvoriť vlastný filter:

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Filter/Interface.php';

      class MyFilter implements Zend\Filter\Interface
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
      $filterChain = new Zend\Filter\Filter();
      $filterChain->addFilter(new MyFilter());



