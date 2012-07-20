.. _zend.currency.calculation:

Calculs avec les monnaies
=========================

Il est possible en travaillant avec des monnaies, d'effectuer des calculs. ``Zend_Currency`` permet d'effectuer de
tels calculs très facilement. Les méthodes suivantes sont supportées:

- **add()**: Ajoute la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet

- **sub()**: Soustrait la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet

- **div()**: Divise la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet.

- **mul()**: Multiplie la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet.

- **mod()**: Calcul le modulo de la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet.

- **compare()**: Compare la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet. Si les
  deux valeurs sont égales, '0' est retourné. Si la monnaie actuelle est plus grande que celle fournie, '1' sera
  retourné. Dans l'autre cas, '-1' sera retourné.

- **equals()**: Compare la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet. Si les
  deux valeurs sont égales, ``TRUE`` est retourné, ``FALSE`` sinon.

- **isMore()**: Compare la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet. Si la
  monnaie interne à l'objet est supérieure à la valeur passée, ``TRUE`` est retourné, ``FALSE`` sinon.

- **isLess()**: Compare la valeur de la monnaie à celle actuellement stockée en mémoire dans l'objet. Si la
  monnaie interne à l'objet est inférieure à la valeur passée, ``TRUE`` est retourné, ``FALSE`` sinon.

Comme vous le voyez ces méthodes permettent n'importe quel calcul avec ``Zend_Currency``. Voici quelques exemples:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Pourrait retourner '$ 1.000,00'

   $currency->add(500);
   print $currency; // Pourrait retourner '$ 1.500,00'

.. code-block:: php
   :linenos:

   $currency_2 = new Zend_Currency(
       array(
           'value'    => 500,
           'currency' => 'USD',
       )
   );

   if ($currency->isMore($currency_2)) {
       print "First is more";
   }

   $currency->div(5);
   print $currency; // Pourrait retourner '$ 200,00'


