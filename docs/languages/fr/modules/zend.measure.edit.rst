.. _zend.measure.edit:

Manipuler des mesures
=====================

L'analyse et la normalisation de l'entrée, combinées avec la récupération suivant les notations régionalisées
rend des données accessibles aux utilisateurs dans différentes régions. Beaucoup de méthodes additionnelles
existent dans les composants ``Zend_Measure_*`` pour manipuler et travailler ces données, après qu'elles aient
été normalisées.

- :ref:`Convertir <zend.measure.edit.convert>`

- :ref:`Ajouter et soustraire <zend.measure.edit.add>`

- :ref:`Comparer avec un booléen <zend.measure.edit.equal>`

- :ref:`Comparer "plus/moins grand que" <zend.measure.edit.compare>`

- :ref:`Changer manuellement des valeurs <zend.measure.edit.changevalue>`

- :ref:`Changer manuellement de type <zend.measure.edit.changetype>`

.. _zend.measure.edit.convert:

Convertir
---------

Le dispositif le plus important est probablement la conversion dans différentes unités de la mesure. La
conversion d'une unité peut être faite à tout moment en utilisant la méthode ``convertTo()``. Des unités de
mesure peuvent seulement être converties en d'autres unités du même type (classe). Par conséquent, il n'est pas
possible de convertir (par exemple : une longueur en poids), qui encouragerait des pratiques de programmation
pauvres et entraînerait la propagation d'erreurs sans lever d'exception.

La méthode *convertTo* accepte un paramètre facultatif. Avec ce paramètre vous pouvez définir une précision
pour l'élément retourné. La précision par défaut est "*2*".

.. _zend.measure.edit.convert.example-1:

.. rubric:: Convertir

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $machaine = "1.234.567,89";
   $unite = new Zend_Measure_Weight($machaine,'POND', $locale);

   print "Kilo : ".$unite->convertTo('KILOGRAM');
   // affiche "Kilo : 617283.945 kg"

   // l'utilisation de constantes est considérée comme
   // une meilleure pratique que les chaînes
   print "Tonne : ".$unite->convertTo(Zend_Measure_Weight::TON);
   // affiche "Tonne : 617.283945 t"

   // définition de la précision pour l'affichage
   print "Tonne :".$unit->convertTo(Zend_Measure_Weight::TON, 3);

.. _zend.measure.edit.add:

Ajouter et soustraire
---------------------

Les mesures peuvent être ajoutées en utilisant ``add()`` et soustraites en utilisant ``sub()``. Le résultat sera
du même type que l'objet original. Les objets dynamiques supportent un interface fluide de programmation, où des
ordres complexes d'opération peuvent être imbriqués sans risque d'effets secondaires changeant les objets
d'entrée.





      .. _zend.measure.edit.add.example-1:

      .. rubric:: Ajouter des mesures

      .. code-block:: php
         :linenos:

         // Définition des objets
         $unite1 = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unite2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // ajouter l'$unite2 à l'$unite1
         $somme = $unite1->add($unite2);

         echo $somme; // affiche "300 cm"



.. note::

   **Conversion automatique**

   Ajouter un objet à l'autre le convertira automatiquement dans l'unité correcte. Il n'est pas nécessaire
   d'appeler :ref:`convertTo() <zend.measure.edit.convert>` avant d'ajouter des unités différentes.





      .. _zend.measure.edit.add.example-2:

      .. rubric:: Soustraire des mesures

      La soustraction des mesures fonctionne comme l'addition.

      .. code-block:: php
         :linenos:

         // Définition des objets
         $unite1 = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unite2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // soustriare l'$unite2 de l'$unite1
         $somme = $unite1->sub($unite2);

         echo $somme; // affiche "100 cm"



.. _zend.measure.edit.equal:

Vérifier l'égalité des mesures
------------------------------

Les mesures peuvent également être comparées, mais sans conversion automatique de l'unité. De plus,
``equals()`` retourne ``TRUE``, seulement si la valeur et l'unité de mesure sont identiques.





      .. _zend.measure.edit.equal.example-1:

      .. rubric:: Mesures différentes

      .. code-block:: php
         :linenos:

         // Définition des mesures
         $unite1 = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unite2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         if ($unite1->equals($unite2)) {
             print "Les mesures sont identiques";
         } else {
             print "Les mesures sont différentes";
         }
         // affiche "Les mesures sont différentes"





      .. _zend.measure.edit.equal.example-2:

      .. rubric:: Mesures identiques

      .. code-block:: php
         :linenos:

         // Définition des mesures
         $unite1 = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unite2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         $unite2->setType(Zend_Measure_Length::CENTIMETER);

         if ($unite1->equals($unite2)) {
             print "Les mesures sont identiques";
         } else {
             print "Les mesures sont différentes";
         } // affiche "Les mesures sont identiques"



.. _zend.measure.edit.compare:

Comparer les mesures
--------------------

Pour déterminer si une mesure est plus ou moins grande qu'une autre, il faut utiliser ``compare()``, qui renvoie
0, -1 ou 1 selon la différence entre les deux objets. Les mesures identiques retourneront 0. Plus petit retournera
-1 et plus grand retournera +1.





      .. _zend.measure.edit.compare.example-1:

      .. rubric:: Différence

      .. code-block:: php
         :linenos:

         $unite1 = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unite2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);
         $unite3 = new Zend_Measure_Length(1.2, Zend_Measure_Length::METER);

         print "Egalité : ".$unite2->compare($unite1);
         // affiche "Egalité : 0"
         print "Plus petit que : ".$unite2->compare($unite3);
         // affiche "Plus petit que : -1"
         print "Plus grand que : ".$unite3->compare($unite2);
         // affiche "Plus grand que : 1"



.. _zend.measure.edit.changevalue:

Changer manuellement des valeurs
--------------------------------

Pour changer explicitement la valeur d'une mesure, il faut utiliser ``setValue()`` pour surcharger la valeur
courante. Les paramètres sont identiques à ceux du constructeur.





      .. _zend.measure.edit.changevalue.example-1:

      .. rubric:: Changer une valeur

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de_AT');
         $unite = new Zend_Measure_Length(1,Zend_Measure_Length::METER);

         $unite->setValue(1.2);
         echo $unite; // affiche "1.2 m"

         $unite->setValue(1.2, Zend_Measure_Length::KILOMETER);
         echo $unite; // affiche "1200 km"

         $unite->setValue("1.234,56", Zend_Measure_Length::MILLIMETER,$locale);
         echo $unite; // affiche "1234.56 mm"



.. _zend.measure.edit.changetype:

Changer manuellement de type
----------------------------

Pour changer le type d'une mesure sans altérer sa valeur, il faut utiliser ``setType()``.

.. _zend.measure.edit.changetype.example-1:

.. rubric:: Changer de type

.. code-block:: php
   :linenos:

   $unite = new Zend_Measure_Length(1,Zend_Measure_Length::METER);
   echo $unite; // affiche "1 m"

   $unite->setType(Zend_Measure_Length::KILOMETER);
   echo $unite; // affiche "1000 km"


