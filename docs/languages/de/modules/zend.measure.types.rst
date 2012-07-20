.. _zend.measure.types:

Arten von Maßeinheiten
======================

Alle unterstützten Arten von Maßeinheiten sind anbei aufgelistet, jede mit einem Beispiel anhand der
standardmäßigen Benutzung Ihrer Maßeinheiten.

.. _zend.measure.types.table-1:

.. table:: Liste der Arten von Maßeinheiten

   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Typ                     |Klasse                          |Standardeinheit                     |Beschreibung                                                                                                                                                             |
   +========================+================================+====================================+=========================================================================================================================================================================+
   |Beschleunigung          |Zend_Measure_Acceleration       |Meter pro Sekunde zum Quadrat | m/s²|Zend_Measure_Acceleration behandelt den physikalischen Faktor der Beschleunigung                                                                                         |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Winkel                  |Zend_Measure_Angle              |Radiant | rad                       |Zend_Measure_Angle behandelt Winkelmaße                                                                                                                                  |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Fläche                  |Zend_Measure_Area               |Quadratmeter | m²                   |Zend_Measure_Area behandelt quadratische Maßeinheiten                                                                                                                    |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Binär                   |Zend_Measure_Binary             |Byte | b                            |Zend_Measure_Binary behandelt binäre Umwandlungen                                                                                                                        |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Kapazität               |Zend_Measure_Capacitance        |Farad | F                           |Zend_Measure_Capacitance behandelt den physikalischen Faktor der Kapazität                                                                                               |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Volumen für das Kochen  |Zend_Measure_Cooking_Volume     |Kubikmeter | m³                     |Zend_Measure_Cooking_Volume behandelt Volumen die für das Kochen in Kochbüchern Verwendung finden                                                                        |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Masse für das Kochen    |Zend_Measure_Cooking_Weight     |Gramm | g                           |Zend_Measure_Cooking_Weight behandelt die Masse / das Gewicht welches für das Kochen in Kochbüchern Verwendung findet                                                    |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Strom                   |Zend_Measure_Current            |Ampere | A                          |Zend_Measure_Current behandelt den physikalischen Faktor des Stromes                                                                                                     |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Dichte                  |Zend_Measure_Density            |Kilogramm pro Kubikmeter | kg/m³    |Zend_Measure_Density behandelt den physikalischen Faktor der Dichte                                                                                                      |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Energie                 |Zend_Measure_Energy             |Joule | J                           |Zend_Measure_Energy behandelt den physikalischen Faktor der Energie                                                                                                      |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Kraft                   |Zend_Measure_Force              |Newton | N                          |Zend_Measure_Force behandelt den physikalischen Faktor der Kraft                                                                                                         |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Strömung (Gewicht)      |Zend_Measure_Flow_Mass          |Kilogramm pro Sekunde | kg/s        |Zend_Measure_Flow_Mass behandelt den physikalischen Faktor der Strömung. Das Gewicht der fließenden Masse wird als Referenz für diese Klasse verwendet                   |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Strömung (Mol)          |Zend_Measure_Flow_Mole          |Mol pro Sekunde | mol/s             |Zend_Measure_Flow_Mole behandelt den physikalischen Faktor der Strömung. Die Dichte der fließenden Masse wird als Referenz für diese Klasse verwendet                    |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Strömung (Volumen)      |Zend_Measure_Flow_Volume        |Kubikmeter pro Sekunde | m³/s       |Zend_Measure_Flow_Mole behandelt den physikalischen Faktor der Strömung. Das Volumen der fließenden Masse wird als Referenz für diese Klasse verwendet                   |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Frequenz                |Zend_Measure_Frequency          |Hertz | Hz                          |Zend_Measure_Frequency behandelt den physikalischen Faktor der Frequenz                                                                                                  |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Beleuchtungsstärke      |Zend_Measure_Illumination       |Lux | lx                            |Zend_Measure_Illumination behandelt den physikalischen Faktor der Beleuchtungsstärke                                                                                     |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Länge                   |Zend_Measure_Length             |Meter | m                           |Zend_Measure_Length behandelt den physikalischen Faktor der Länge                                                                                                        |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Helligkeit              |Zend_Measure_Lightness          |Candela pro Quadratmeter | cd/m²    |Zend_Measure_Ligntness behandelt den physikalischen Faktor der Lichtenergie                                                                                              |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Zahl                    |Zend_Measure_Number             |Dezimal | (10)                      |Zend_Measure_Number konvertiert zwischen Zahlenformaten                                                                                                                  |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Leistung                |Zend_Measure_Power              |Watt | W                            |Zend_Measure_Power behandelt den physikalischen Faktor der Leistung                                                                                                      |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Druck                   |Zend_Measure_Pressure           |Newton pro Quadratmeter | N/m²      |Zend_Measure_Pressure behandelt den physikalischen Faktor des Druckes                                                                                                    |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Geschwindigkeit         |Zend_Measure_Speed              |Meter pro Sekunde | m/s             |Zend_Measure_Speed behandelt den physikalischen Faktor des Geschwindigkeit                                                                                               |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Temperatur              |Zend_Measure_Temperature        |Kelvin | K                          |Zend_Measure_Temperature behandelt den physikalischen Faktor der Temperatur                                                                                              |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Time                    |Zend_Measure_Time               |Sekunde | s                         |Zend_Measure_Time behandelt den physikalischen Faktor der Zeit                                                                                                           |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Drehmoment              |Zend_Measure_Torque             |Newtonmeter | Nm                    |Zend_Measure_Torque behandelt den physikalischen Faktor des Drehmoments                                                                                                  |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Viskosität (Dynamisch)  |Zend_Measure_Viscosity_Dynamic  |Kilogramm pro Metersekunde | kg/ms  |Zend_Measure_Viscosity_Dynamic behandelt den physikalischen Faktor der Viskosität. Das Gewicht der Flüssigkeit wird als Referenz für diese Klasse verwendet              |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Viskosität (Kinematisch)|Zend_Measure_Viscosity_Kinematic|Quadratmeter pro Sekunde | m²/s     |Zend_Measure_Viscosity_Kinematic behandelt den physikalischen Faktor der Viskosität. Die Distanz der geflossenen Flüssigkeit wird als Referenz für diese Klasse verwendet|
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Volumen                 |Zend_Measure_Volume             |Kubikmeter | m³                     |Zend_Measure_Volume behandelt den physikalischen Faktor des Volumens (Inhalt)                                                                                            |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Gewicht                 |Zend_Measure_Weight             |Kilogramm | kg                      |Zend_Measure_Weight behandelt den physikalischen Faktor des Gewichts                                                                                                     |
   +------------------------+--------------------------------+------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.measure.types.binary:

Hinweise für Zend_Measure_Binary
--------------------------------

Einige übliche Binäre Konventionen beinhalten Terme wie Kilo-, Mega-, Giga-, usw. die im normalen Sprachgebrauch
zur Basis 10, wie 1000 oder 10³ bedeuten. Trotzdem werden diese Terme in den Binärformaten für Computer mit dem
Faktor 1024 statt 1000 benutzt. Um Ungereimtheiten auszuräumen wurde vor einigen Jahren die Schreibweise BI
eingeführt. Statt Kilobyte sollte KiBiByte für Kilo-Binär-Byte verwendet werden.

In der Klasse BINARY können beide Schreibweisen gefunden werden wie *KILOBYTE = 1024 - Binäre Computer
Konvertierung KIBIBYTE = 1024 - Neue Schreibweise KILO_BINARY_BYTE = 1024 - Neu* und auch die Schreibweisen
*KILOBYTE_SI = 1000 - SI Schreibweise für Kilo (1000)* im langen Format. DVD's zum Beispiel werden in der
SI-Schreibweise beschriftet, aber fast alle Festplatten werden in Computer Binär Schreibweise beschriftet.

.. _zend.measure.types.decimal:

Hinweise für Zend_Measure_Number
--------------------------------

Das bekannteste Zahlenformat ist das Dezimalsystem. Zusätzlich unterstützt diese Klasse das Oktalsystem, das
Hexadezimalsystem, das Binärsystem, das Römische Zahlensystem und einige andere nicht so bekannte Systeme. Es
wird aber nur der Dezimalteil der Zahl behandelt. Der Bruchteil wird entfernt.

.. _zend.measure.types.roman:

Römische Zahlen
---------------

Für das Römische Zahlensystem werden Ziffern größer als 4000 unterstützt. In Wirklichkeit werden diese Zahlen
mit einem Überstrich über der Ziffer dargestellt. Da der Überstrich nicht mit dem Computer dargestellt werden
kann, muß stattdessen ein Unterstrich benutzt werden.

.. code-block:: php
   :linenos:

   $great = '_X';
   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Number($great,Zend_Measure_Number::ROMAN, $locale);

   // Konvertierung in das Dezimalsystem
   echo $unit->convertTo(Zend_Measure_Number::DECIMAL);


