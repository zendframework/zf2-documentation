.. _zend.measure.types:

Types de mesures
================

Tous les types de mesures supportées sont listées ci-dessous, chacun avec une exemple d'utilisation standard pour
ce type de mesure.

.. _zend.measure.types.table-1:

.. table:: Liste des types de mesure

   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Type                     |Classe                          |Unité standard                      |Description                                                                                                                                                                     |
   +=========================+================================+====================================+================================================================================================================================================================================+
   |Accélération             |Zend_Measure_Acceleration       |Mètres par seconde carré | m/s²     |Zend_Measure_Acceleration couvre le facteur physique d'accélération.                                                                                                            |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Angle                    |Zend_Measure_Angle              |Radiant | rad                       |Zend_Measure_Angle couvre les dimensions angulaires.                                                                                                                            |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Superficie               |Zend_Measure_Area               |Mètres carré | m²                   |Zend_Measure_Area couvre les superficies.                                                                                                                                       |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Binaire                  |Zend_Measure_Binary             |Bit | b                             |Zend_Measure_Binary couvre les conversions binaires.                                                                                                                            |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Capacité électrique      |Zend_Measure_Capacitance        |Farad | F                           |Zend_Measure_Capacitance couvre le facteur physique de capacité électrique.                                                                                                     |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Volume (de cuisine)      |Zend_Measure_Cooking_Volume     |Mètre au cube | m³                  |Zend_Measure_Cooking_Volume couvre les volumes (principalement pour la cuisine ou les livres de cuisine).                                                                       |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Poids (de cuisine)       |Zend_Measure_Cooking_Weight     |Gramme | g                          |Zend_Measure_Cooking_Weight couvre les poids (principalement pour la cuisine ou les livres de cuisine).                                                                         |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Courant électrique       |Zend_Measure_Current            |Ampère | A                          |Zend_Measure_Current couvre le facteur physique de courant électrique.                                                                                                          |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Masse volumique (densité)|Zend_Measure_Density            |Kilogramme par mètre au cube | kg/m³|Zend_Measure_Density couvre le facteur physique de la masse volumique (densité).                                                                                                |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Énergie                  |Zend_Measure_Energy             |Joule | J                           |Zend_Measure_Energy couvre le facteur physique de l'énergie.                                                                                                                    |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Force                    |Zend_Measure_Force              |Newton | N                          |Zend_Measure_Force couvre le facteur physique de la force.                                                                                                                      |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Débit (massique)         |Zend_Measure_Flow_Mass          |Kilogramme par seconde | kg/s       |Zend_Measure_Flow_Mass couvre le facteur physique de débit massique. Le poids de la masse en écoulement est utilisé comme point de référence de la classe.                      |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Débit (molaire)          |Zend_Measure_Flow_Mole          |Mole par seconde | mol/s            |Zend_Measure_Flow_Mole couvre le facteur physique de débit massique. La densité de la masse en écoulement est utilisée comme point de référence de la classe.                   |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Débit (volumique)        |Zend_Measure_Flow_Volume        |Mètres au cube par seconde | m³/s   |Zend_Measure_Flow_Volume couvre le facteur physique de débit massique. Le volume de la masse en écoulement est utilisé comme point de référence de la classe.                   |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Fréquence                |Zend_Measure_Frequency          |Hertz | Hz                          |Zend_Measure_Frequency couvre le facteur physique de fréquence.                                                                                                                 |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Éclairement lumineux     |Zend_Measure_Illumination       |Lux | lx                            |Zend_Measure_Illumination couvre le facteur physique de l'éclairement lumineux.                                                                                                 |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Longueur                 |Zend_Measure_Length             |Mètres | m                          |Zend_Measure_Length couvre le facteur physique de longueur.                                                                                                                     |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Luminosité               |Zend_Measure_Lightness          |Candela par mètre carré | cd/m²     |Zend_Measure_Ligntness couvre le facteur physique de luminosité.                                                                                                                |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Nombre                   |Zend_Measure_Number             |Décimal | (10)                      |Zend_Measure_Number permet la conversion entre les formats numériques.                                                                                                          |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Puissance                |Zend_Measure_Power              |Watt | W                            |Zend_Measure_Power couvre le facteur physique de puissance.                                                                                                                     |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Pression                 |Zend_Measure_Pressure           |Newton par mètre carré | N/m²       |Zend_Measure_Pressure couvre le facteur physique de pression.                                                                                                                   |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Vitesse                  |Zend_Measure_Speed              |Mètre par seconde | m/s             |Zend_Measure_Speed couvre le facteur physique de vitesse                                                                                                                        |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Température              |Zend_Measure_Temperature        |Kelvin | K                          |Zend_Measure_Temperature couvre le facteur physique de température                                                                                                              |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Durée                    |Zend_Measure_Time               |Seconde | s                         |Zend_Measure_Time couvre le facteur physique de la durée.                                                                                                                       |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Couple                   |Zend_Measure_Torque             |Newton mètre | Nm                   |Zend_Measure_Torque couvre le facteur physique du couple                                                                                                                        |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Viscosité (dynamique)    |Zend_Measure_Viscosity_Dynamic  |Kilogramme par mètre seconde | kg/ms|Zend_Measure_Viscosity_Dynamic couvre le facteur physique de viscosité. La masse du fluide est utilisée comme le point de référence de la classe.                               |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Viscosité (cinématique)  |Zend_Measure_Viscosity_Kinematic|Mètres carré par seconde | m²/s     |Zend_Measure_Viscosity_Kinematic couvre le facteur physique de viscosité. La distance parcouru par la masse en écoulement est utilisée comme le point de référence de la classe.|
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Volume                   |Zend_Measure_Volume             |Mètre au cube | m³                  |Zend_Measure_Volume couvre le facteur physique de volume (contenu).                                                                                                             |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Masse                    |Zend_Measure_Weight             |Kilogramme | kg                     |Zend_Measure_Weight couvre le facteur physique de masse.                                                                                                                        |
   +-------------------------+--------------------------------+------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.measure.types.binary:

Conseils pour Zend_Measure_Binary
---------------------------------

Quelques conventions binaires populaires, incluent des termes comme le kilo-, le mega-, le giga, etc. dans les
langues utilisant implicitement la base 10, tels que 1000 ou 10³. Cependant, dans le format binaire des
ordinateurs, ces limites doivent être vues comme un facteur de conversion de 1024 au lieu de 1000. Pour exclure
des confusions il y a quelques années, la notation BI a été introduite. Au lieu du "kilobyte", le kibibyte pour
le "kilo-binary-byte" devrait être employé.

Dans la classe BINARY les deux notations peuvent être trouvées, comme *KILOBYTE = 1024 - binary computer
conversion KIBIBYTE = 1024 - new notation KILO_BINARY_BYTE = 1024 - new*, ou la notation, en format long
*KILOBYTE_SI = 1000 - SI notation for kilo (1000)*. Les DVDs par exemple sont identifiés par la SI-notation, mais
presque tous les disques durs sont marqués dans la numérotation binaire des ordinateurs.

.. _zend.measure.types.decimal:

Conseils pour Zend_Measure_Number
---------------------------------

Le format de nombre le plus connu est le système décimal. De manière additionnelle, cette classe supporte le
système octal, le système hexadécimal, le système binaire, le système des chiffres romains et quelques autres
systèmes moins populaires. Noter que seulement la partie décimale des nombres est manipulée. Toute partie
fractionnelle sera effacée.

.. _zend.measure.types.roman:

Chiffres romains
----------------

Les chiffres romains plus grands que 4000 sont supportés. `Ces nombres sont écrits avec une barre au dessus`_.
Comme cette barre ne peut pas être représentée sur l'ordinateur, il faut utiliser un tiret bas en début de
chaîne.

.. code-block:: php
   :linenos:

   $valeur_grande = '_X';
   $locale = new Zend_Locale('en');
   $unite = new Zend_Measure_Number($valeur_grande,
                                    Zend_Measure_Number::ROMAN,
                                    $locale);

   // convertir en système décimal
   echo $unite->convertTo(Zend_Measure_Number::DECIMAL);
   // affiche 10000



.. _`Ces nombres sont écrits avec une barre au dessus`: http://fr.wikipedia.org/wiki/Num%C3%A9ration_romaine#Extensions_classiques
