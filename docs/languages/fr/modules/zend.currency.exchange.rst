.. _zend.currency.exchange:

Echanger (convertir) des monnaies
=================================

Dans la section précédente, nous avons parlé des calculs sur les monnaies. Mais comme vous pouvez imaginer,
calculer des monnaies peut vite mener à des calculs internationnaux (entre pays différents).

Dans un tel cas, les monnaies doivent être converties avec un taux. Les taux officiels sont conservés par les
banques ou encore les journaux. Dans le Web, des services de conversion existent. ``Zend_Currency`` permet leur
utilisation par fonction de rappel.

D'abord, écrivons un service de change simple.

.. code-block:: php
   :linenos:

   class SimpleExchange implements Zend_Currency_CurrencyInterface
   {
       public function getRate($from, $to)
       {
           if ($from !== "USD") {
               throw new Exception('On ne change que des USD');
           }

           switch ($to) {
               case 'EUR':
                   return 2;
               case 'JPE':
                   return 0.7;
          }

          throw new Exception('Impossible de changer vers $to');
       }
   }

Nous venons de créer un service de change manuellement.

Votre classe de service de change doit implémenter ``Zend_Currency_CurrencyInterface``. Cette interface définit
une seule méthode ``getRate()``, qui prend deux paramètres : les noms courts des monnaies. ``Zend_Currency`` a
besoin que le taux de change soit retourné.

Dans un service réel, vous demanderiez au fournisseur les taux de change, dans notre exemple nous les codons en
dur.

Attachons maintenant notre classe avec ``Zend_Currency``. Ceci se fait de deux manières , soit en attachant
l'objet ou en attachant le nom de sa classe.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'EUR',
       )
   );

   $service  = new SimpleExchange();

   // attachons le service de change
   $currency->setService($service);

   $currency2 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency->add($currency2);

L'exemple ci-dessus retournera '$ 3.000' car 1.000 *USD* seront convertis avec un taux de 2 vers 2.000 *EUR*.

.. note::

   **Calcul sans service de change**

   Si vous tentez des calculs avec deux monnaies de types différents et qu'aucun service de change n'a été
   précisé, une exception sera levée. ``Zend_Currency`` ne sait pas nativement passer d'une monnaie à une
   autre.


