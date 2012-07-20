.. _zend.measure.creation:

Création d'une mesure
=====================

En créant un objet de mesure, les méthodes ``Zend_Measure_*`` prévoient que l'entrée ou la mesure originale
soit le premier paramètre. Ceci peut être un :ref:`argument numérique <zend.measure.creation.number>`, une
:ref:`chaîne <zend.measure.creation.string>` sans unités, ou une :ref:`chaîne régionale
<zend.measure.creation.localized>` avec une (des) unité(s) spécifiée(s). Le deuxième paramètre définit le
type de la mesure. Les deux paramètres sont obligatoires. La langue peut être indiquée comme troisième
paramètre optionnel.

.. _zend.measure.creation.number:

Créer des mesures à partir de nombres entiers et décimaux
---------------------------------------------------------

En plus des valeurs de données en nombre entier, des nombre décimaux peuvent être employés, mais `"il est
fréquent que de simples fractions décimales telles que 0.1 ou 0.7 ne puissent être converties au format interne
binaire sans une légère perte de précision"`_ parfois en donnant des résultats étonnants. En outre, il ne faut
pas comparer l'égalité de deux nombres décimaux.

.. _zend.measure.creation.number.example-1:

.. rubric:: Création de mesure en utilisant des nombres entiers et décimaux

.. code-block:: php
   :linenos:

   $mesure = 1234.7;
   $unite = new Zend_Measure_Length((integer)$mesure,
                                     Zend_Measure_Length::STANDARD);
   echo $unite;
   // affiche '1234 m' (mètres)

   $unite = new Zend_Measure_Length($mesure, Zend_Measure_Length::STANDARD);
   echo $unite;
   // affiche '1234.7 m' (mètres)

.. _zend.measure.creation.string:

Créer des mesures à partir de chaînes de caractères
---------------------------------------------------

Beaucoup de mesures reçues comme entrée des applications Zend Framework peuvent seulement être passées aux
classes ``Zend_Measure_*`` comme des chaînes, telles que des nombres écrits en utilisant les `chiffres romains`_
ou les valeurs binaires extrêmement grandes qui excèdent la précision native de *PHP* des nombres entiers ou
décimaux. Puisque les nombres entiers peuvent être indiqués en utilisant des chaînes, s'il y a un quelconque
risque de perdre la précision à cause des limitations des types natifs (nombre entier et décimaux), il faut
utiliser des chaînes à la place. ``Zend_Measure_Number`` emploie l'extension BCMath pour supporter la précision
arbitraire, afin d'éviter les limitations dans beaucoup de fonctions de *PHP*, telle que `bin2dec()`_.

.. _zend.measure.creation.string.example-1:

.. rubric:: Création de mesure en utilisant des chaînes

.. code-block:: php
   :linenos:

   $machaine = "10010100111010111010100001011011101010001";
   $unit = new Zend_Measure_Number($machaine, Zend_Measure_Number::BINARY);

   echo $unit;

.. _zend.measure.creation.localized:

Mesures à partir de chaînes localisées
--------------------------------------

Quand une corde est présentée dans une notation régionalisée, l'interprétation correcte ne peut pas être
déterminée sans connaître la région attendue. La division des chiffres décimaux avec "." et grouper des
milliers avec "," est commun en l'anglais, mais pas dans d'autres langues. Par exemple, le nombre anglais
"1,234.50" serait interprété comme "1.2345" en allemand. Pour traiter de tels problèmes, la famille des classes
``Zend_Measure_*`` offrent la possibilité d'indiquer une langue ou une région pour lever l'ambiguïté les
données d'entrée et pour interpréter correctement la valeur sémantique prévue.

.. _zend.measure.creation.localized.example-1:

.. rubric:: Chaînes localisées

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $machaine = "1,234.50";
   $unite = new Zend_Measure_Length($machaine,
                                    Zend_Measure_Length::STANDARD, $locale);
   echo $unite; // affiche "1.234 m"

   $machaine = "1,234.50";
   $unite = new Zend_Measure_Length($machaine,
                                    Zend_Measure_Length::STANDARD, 'en_US');
   echo $unite; // affiche "1234.50 m"

Depuis la version 1.7.0 de Zend Framework, ``Zend_Measure`` supporte aussi l'utilisation d'une application
pleinement localisée. Vous pouvez simplement paramétrer une instance ``Zend_Locale`` dans le registre comme
présenté ci-dessous. Avec cette notation vous pouvez ne pas paramétrer cette valeur manuellement à chaque fois
quand vous utilisez la même localisation plusieurs fois.

.. code-block:: php
   :linenos:

   // in your bootstrap file
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // somewhere in your application
   $length = new Zend_Measure_Length(Zend_Measure_Length::METER();



.. _`"il est fréquent que de simples fractions décimales telles que 0.1 ou 0.7 ne puissent être converties au format interne binaire sans une légère perte de précision"`: http://www.php.net/float
.. _`chiffres romains`: http://fr.wikipedia.org/wiki/Num%C3%A9ration_romaine
.. _`bin2dec()`: http://php.net/bin2dec
