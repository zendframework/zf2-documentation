.. _zend.measure.introduction:

Úvod
====

Triedy *Zend_Measure_** poskytujú jednoduchú možnosť pre prácu z výsledkami. Pomocou *Zend_Measure_** je
možné konvertovať výsledok do rozličných jednotiek rovnakého typu. Výsledky môžu byt sčitované,
odčitované a porovnávané medzi sebou. Z užívateľského vstupu je možné automaticky získať jednotku
výsledku. Je podporované veľké množstvo jednotiek.

.. rubric:: Zmena výsledku merania

Nasledujúci úvodný príklad ukazuje možnosť zmeny jednotky výsledku merania. Pre zmenu jednotky výsledku
merania je potrebné vedieť hodnotu a jednotku hodnoty. Hodnota môže byt celé číslo, desatinné číslo,
alebo reťazec ktorý obsahuje číslo. Konvertovať je možné lem medzi jednotkami rovnakého typu (hmotnosť,
plocha, teplota, rýchlosť, atď.) a nie vzájomne.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Measure/Length.php';

   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Length(100, Zend_Measure_Length::METER, $locale);

   // Konverzia meterov to yardy
   echo $unit->convertTo(Zend_Measure_Length::YARD);
   ?>
*Zend_Measure_** zahŕňa podporu pre rôzne druhy jednotiek meraní. Jednotky majú vždy rovnakú sémantiku:
*Zend_Measure_<TYP>::MENO_JEDNOTKY*, kde <TYP> zodpovedá jednotlivým fyzikálnym veličinám, alebo číselným
vlastnostiam. Každá jednotka pozostáva z konverzného faktoru a označenia jednotky. Podrobný zoznam sa
nachádza v časti :ref:`Typy meraní <zend.measure.types>`.

.. rubric:: Použitie jednotky *meter*

Meranie pomocou jednotky *meter*\ je určené na meranie vzdialeností, a teda jej konštanta je obsiahnutá v
triede *Length*. Pre použitie tejto jednotky je potrebné použiť zápis *Length::METER*. Zobrazenie jednotky je
*m*.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Measure/Length.php';

   echo Zend_Measure_Length::STANDARD;  // outputs 'Length::METER'
   echo Zend_Measure_Length::KILOMETER; // outputs 'Length::KILOMETER'

   $unit = new Zend_Measure_Length(100,'METER');
   echo $unit;
   // výsledok: '100 m'
   ?>

