.. _zend.measure.output:

Récupérer des mesures
=====================

Les mesures peuvent être récupérer de différentes manières.

:ref:`Récupération automatique <zend.measure.output.auto>`

:ref:`Récupération des valeurs <zend.measure.output.value>`

:ref:`Récupération de l'unité de mesure <zend.measure.output.unit>`

:ref:`Récupération en tant que chaîne régionale <zend.measure.output.unit>`

.. _zend.measure.output.auto:

Récupération automatique
------------------------

``Zend_Measure`` supporte la récupération sous formes de chaînes de caractères automatiquement.



      .. _zend.measure.output.auto.example-1:

      .. rubric:: Récupération automatique

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $machaine = "1.234.567,89";
         $unite = new Zend_Measure_Length($machaine,
                                          Zend_Measure_Length::STANDARD,
                                          $locale);

         echo $unite; // affiche "1234567.89 m"



.. note::

   **Affichage de la mesure**

   L'affichage peut être réalisé simplement en utilisant `echo`_ ou `print`_.

.. _zend.measure.output.value:

Récupération des valeurs
------------------------

La valeur d'une mesure peut être récupérée en utilisant ``getValue()``.



      .. _zend.measure.output.value.example-1:

      .. rubric:: Récupération d'une valeur

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $machaine = "1.234.567,89";
         $unite = new Zend_Measure_Length($machaine,
                                          Zend_Measure_Length::STANDARD,
                                          $locale);

         echo $unite->getValue(); // affiche "1234567.89"



La méthode ``getValue()`` accepte un paramètre facultatif "*round*" qui permet de définir la précision de la
sortie générée. La précision par défaut est de *2*.

.. _zend.measure.output.unit:

Récupération de l'unité de mesure
---------------------------------

La fonction ``getType()`` retourne l'unité de mesure courante.



      .. _zend.measure.output.unit.example-1:

      .. rubric:: Récupérer l'unité de mesure

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $machaine = "1.234.567,89";
         $unit = new Zend_Measure_Weight($machaine,
                                         Zend_Measure_Weight::POUND,
                                         $locale);

         echo $unit->getType(); // affiche "POUND"



.. _zend.measure.output.localized:

Récupération en tant que chaîne régionale
-----------------------------------------

Récupérer une chaîne dans un format habituel du pays de l'utilisateur est habituellement souhaitable. Par
exemple, la mesure "1234567.8" deviendrait "1.234.567,8" pour l'Allemagne. Cette fonctionnalité sera supportée
dans une future version.



.. _`echo`: http://php.net/echo
.. _`print`: http://php.net/print
