.. _zend.measure.introduction:

Introduction
============

Les classes ``Zend_Measure_*`` fournissent un moyen générique et facile de travailler avec les mesures. En
utilisant des classes de ``Zend_Measure_*``, vous pouvez convertir des mesures en différentes unités du même
type. Elles peuvent être ajoutées, soustraites et comparées les uns contre les autres. À partir d'une entrée
donnée faite dans la langue maternelle de l'utilisateur, l'unité de la mesure peut être automatiquement
extraite. Des unités de mesure supportées sont nombreuses.

.. _zend.measure.introduction.example-1:

.. rubric:: Convertir des mesures

L'exemple d'introduction suivant montre la conversion automatique des unités de mesure. Pour convertir une mesure,
sa valeur et son type doivent être connus. La valeur peut être un nombre entier, un nombre à virgule flottante
("float"), ou même une chaîne contenant un nombre. Les conversions sont seulement possibles aux unités du même
type (la masse, secteur, température, vitesse, etc.), pas entre les types.

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Length(100,
                                   Zend_Measure_Length::METER,
                                   $locale);

   // Converti les mètres en yards
   echo $unit->convertTo(Zend_Measure_Length::YARD);

``Zend_Measure_*`` inclut le support de beaucoup de différentes unités de mesure. Toutes les unités de mesure
ont une notation unifiée : ``Zend_Measure_<TYPE>::NAME_OF_UNIT``, où <TYPE> correspond à une propriété
physique ou numérique bien connue. Chaque unité de mesure se compose d'un facteur de conversion et d'une unité
de visualisation. Une liste détaillée peut être trouvée dans le chapitre des :ref:`types de mesures
<zend.measure.types>`.

.. _zend.measure.introduction.example-2:

.. rubric:: La mesure de la longueur

Le mètre est utilisé pour mesurer des longueurs, ainsi son type constante peut être trouvé dans la classe des
longueurs. Pour se rapporter à cette unité de mesure, la notation ``Length::METER`` doit être utilisée.
L'unité de visualisation est *m*.

.. code-block:: php
   :linenos:

   echo Zend_Measure_Length::STANDARD;
   // affiche 'Length::METER'
   echo Zend_Measure_Length::KILOMETER;
   // affiche 'Length::KILOMETER'

   $unit = new Zend_Measure_Length(100,'METER');
   echo $unit;
   // affiche '100 m'


