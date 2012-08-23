.. EN-Revision: none
.. _zend.filter.filter_chains:

Chaînes de filtrage
===================

Souvent, de multiples filtres doivent être appliqués à une valeur dans un ordre particulier. Par exemple, un
formulaire d'authentification accepte un identifiant qui doit être en minuscule et composé uniquement de
caractères alphabétiques. ``Zend_Filter`` fournit un moyen simple permettant de chaîner des filtres. Le code
suivant illustre comment chaîner deux filtres pour l'identifiant soumis :

   .. code-block:: php
      :linenos:

      // Création d'une chaine de filtrage et ajout de filtres à celle-ci
      $filtreChaine = new Zend_Filter();
      $filtreChaine->addFilter(new Zend_Filter_Alpha())
                   ->addFilter(new Zend_Filter_StringToLower());

      // Filtrage de l'identifiant
      $identifiant = $filtreChaine->filter($_POST['identifiant']);

Les filtres sont exécutés dans leur ordre d'ajout à ``Zend_Filter``. Dans l'exemple ci-dessus, l'identifiant se
voit d'abord retirer tout caractère non-alphabétique, les caractère majuscules éventuels sont ensuite convertis
en minuscules.

Tout objet implémentant ``Zend_Filter_Interface`` peut être utilisé comme chaîne de filtrage.

.. _zend.filter.filter_chains.order:

Changing filter chain order
---------------------------

Since 1.10, the ``Zend_Filter`` chain also supports altering the chain by prepending or appending filters. For
example, the next piece of code does exactly the same as the other username filter chain example:

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend_Filter();

   // this filter will be appended to the filter chain
   $filterChain->appendFilter(new Zend_Filter_StringToLower());

   // this filter will be prepended at the beginning of the filter chain.
   $filterChain->prependFilter(new Zend_Filter_Alpha());

   // Filter the username
   $username = $filterChain->filter($_POST['username']);


