.. _zend.filter.filter_chains:

Łańcuchy filtrów
================

Często do pewnej wartości potrzebujemy zastosować wiele filtrów w określonej kolejności. Przykładem może
być formularz logowania akceptujący jedynie małe znaki alfabetu. *Zend_Filter* zapewnia prostą metodę dzięki
której filtry mogą być wywoływane łańcuchowo. Poniższy kod ilustruje łańcuchowe wywołanie dwóch filtrów
dla wysłanej nazwy użytkownika:

   .. code-block:: php
      :linenos:

      // Tworzymy łańcuch filtrów i dodajemy filtry do łańcucha
      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new Zend_Filter_Alpha())
                  ->addFilter(new Zend_Filter_StringToLower());

      // Filtrujemy nazwę użytkownika
      $username = $filterChain->filter($_POST['username']);


Filtry są uruchamiane w takiej kolejności, w jakiej zostają dodane do *Zend_Filter*. W powyższym przykładzie z
nazwy użytkownika wpierw są usuwane wszystkie niealfabetyczne znaki, a następnie wszystkie wielkie litery są
zamieniane na małe.

W łańcuchu filtrów może być użyty dowolny obiekt, który implementuje interfejs *Zend_Filter_Interface*.


