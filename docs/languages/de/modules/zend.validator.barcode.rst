.. EN-Revision: none
.. _zend.validate.set.barcode:

Barcode
=======

``Zend\Validate\Barcode`` erlaubt es zu prüfen ob ein gegebener Wert als Barcode repräsentiert werden kann.

``Zend\Validate\Barcode`` unterstützt viele Barcode Standards und kann sehr einfach mit prorietären Barcode
Implementationen erweitert werden. Die folgenden Barcode Standards werden unterstützt:

- **CODE25**: Oft auch "Two of Five" oder "Code 25 Industrial" genannt.

  Dieser Barcode hat keine Begrenzung der Länge. Es unterstützt nur Ziffern, und die letzte Ziffer kann eine
  optionale Checksumme sein welche durch Modulo 10 berechnet wird. Dieser Standard sehr alt und wird heutzutage
  nicht oft verwendet. Übliche Anwendungsfälle liegen in der Industrie.

- **CODE25INTERLEAVED**: Oft auch "Code 2 of 5 Interleaved" genannt.

  Dieser Standard ist eine Variante von CODE25. Er hat keine Begrenzung der Länge, muss aber eine gerade Anzahl an
  Zeichen enthalten. Es unterstützt nur Ziffern, und die letzte Ziffer kann eine optionale Checksumme sein welche
  durch Modulo 10 berechnet wird. Dieser Standard wird weltweit verwendet und üblicherweise im Handel.

- **CODE39**: CODE39 ist einer der ältesten vorhandenen Codes.

  Dieser Barcode hat eine variable Länge. Er unterstützt Ziffern, großgeschriebene alphabetische Zeichen und 7
  spezielle Zeichen wie Leerzeichen, Punkte und Dollarzeichen. Er kann eine optionale Checksumme enthalten welche
  durch Modulo 43 berechnet wird. Dieser Standard wird weltweit verwendet und üblicherweise in der Industrie.

- **CODE39EXT**: CODE39EXT ist eine Erweiterung von CODE39.

  Dieser Barcode hat die gleichen Eigenschaften wie CODE39. Zusätzlich erlaubt er die Verwendung aller 128 ASCII
  Zeichen. Dieser Standard wird weltweit verwendet und ist in der Industrie üblich.

- **CODE93**: CODE93 ist der Nachfolger von CODE39.

  Dieser Barcode hat eine variable Länge. Er unterstützt Ziffern, alphabetische Zeichen und 7 spezielle Zeichen.
  Er enthält eine optionale Checksumme welche durch Modulo 47 berechnet wird und aus 2 Zeichen besteht. Dieser
  Standard produziert einen kompakteren Code als CODE39 und ist sicherer.

- **CODE93EXT**: CODE93EXT ist eine Erweiterung von CODE93.

  Dieser Barcode hat die gleichen Eigenschaften wie CODE93. Zusätzlich erlaubt er die Verwendung aller 128 ASCII
  Zeichen. Dieser Standard wird weltweit verwendung und ist in der Industrie üblich.

- **EAN2**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss 2 Zeichen haben. Er unterstützt nur Ziffern und hat keine Checksumme. Dieser Standard wird
  hauptsächlich als Zusatz zu EAN13 (ISBN) verwendet wenn diese auf Bücher gedruckt werden.

- **EAN5**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss 5 Zeichen haben. Er unterstützt nur Ziffern und hat keine Checksumme. Dieser Standard wird
  hauptsächlich als Zusatz zu EAN13 (ISBN) verwendet wenn diese auf Bücher gedruckt werden.

- **EAN8**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode kann eine Länge von 7 oder 8 Zeichen haben. Er unterstützt nur Ziffern. Wenn er 8 Zeichen lang
  ist enthält er eine Checksumme. Dieser Standard wird weltweit verwendet, hat aber eine sehr begrenzte
  Reichweite. Er kann auf kleinen Artikeln gefunden werden wo ein längerer Barcode nicht gedruckt werden könnte.

- **EAN12**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss eine Länge von 12 Zeichen haben. Er unterstützt nur Ziffern wobei die letzte Ziffer immer
  eine Checksumme ist welche durch Modulo 10 berechnet wird. Dieser Standard wird in der USA verwendet und hierbei
  üblicherweise im Handel. Er wurde ersetzt durch EAN13.

- **EAN13**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss eine Länge von 13 Zeichen haben. Er unterstützt nur Ziffern wobei die letzte Ziffer immer
  eine Checksumme ist welche durch Modulo 10 berechnet wird. Dieser Standard wird weltweit verwendet,
  üblicherweise im Handel.

- **EAN14**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss eine Länge von 14 Zeichen haben. Er unterstützt nur Ziffern wobei die letzte Ziffer immer
  eine Checksumme ist welche durch Modulo 10 berechnet wird. Dieser Standard wird weltweit verwendet,
  üblicherweise im Handel. Er ist der Nachfolger von EAN13.

- **EAN18**: EAN ist die Abkürzung für "European Article Number".

  Dieser Barcode muss eine Länge von 18 Zeichen haben. Er unterstützt nur Ziffern. Die letzte Ziffer ist immer
  eine Checksumme welche durch Modulo 10 berechnet wird. Dieser Code wird ost für die Identifizierung von
  Transport Containern verwendet.

- **GTIN12**: GTIN ist die Abkürzung für "Global Trade Item Number".

  Dieser Barcode verwendet den gleichen Standard wie EAN12 und ist sein Nachfolger. Er wird üblicherweise in den
  USA verwendet.

- **GTIN13**: GTIN ist die Abkürzung für "Global Trade Item Number".

  Dieser Barcode verwendet den gleichen Standard wie EAN13 und ist sein Nachfolger. Er wird weltweit von der
  Industrie verwendet.

- **GTIN14**: GTIN ist die Abkürzung für "Global Trade Item Number".

  Dieser Barcode verwendet den gleichen Standard wie EAN14 und ist sein Nachfolger. Er wird weltweit verwendet,
  üblicherweise im Handel.

- **IDENTCODE**: Identcode wird von Deutsche Post und DHL verwendet. Es ist eine spezialisierte Implementation von
  Code25.

  Dieser Barcode muss eine Länge von 12 Zeichen haben. Er unterstützt nur Ziffern und die letzte Ziffer ist immer
  eine Checksumme die mit Modulo 10 berechnet wird. Dieser Standard wird hauptsächlich von den Firmen DP und DHL
  verwendet.

- **INTELLIGENTMAIL**: Intelligent Mail ist ein postalischer Barcode.

  Dieser Barcode kann eine Länge von 20, 25, 29 oder 31 Zeichen haben. Er unterstützt nur Ziffern und enthält
  keine Checksumme. Dieser Standard ist der Nachfolger von *PLANET* und *POSTNET*. Er wird hauptsächlich von den
  United States Post Services verwendet.

- **ISSN**: *ISSN* ist die Abkürzung für International Standard Serial Number.

  Dieser Barcode kann eine Länge von 8 oder 13 Zeichen haben. Er unterstützt nur Ziffern wobei die letzte Ziffer
  eine Checksumme ist welche durch Modulo 11 berechnet wird. Er wird weltweit für gedruckte Publikationen
  verwendet.

- **ITF14**: ITF14 ist die GS1 Implementation des Interleaved Two of Five Barcodes.

  Dieser Barcode ist eine spezielle Variante von Interleaved 2 of 5. Er muss eine Länge von 14 Zeichen haben und
  basiert auf GTIN14. Er unterstützt nur Ziffern wobei die letzte Ziffer die Ziffer einer Checksumme ist welche
  durch Modulo 10 berechnet wird. Er wird weltweit verwendet, üblicherweise im Handel.

- **LEITCODE**: Leitcode wird von Deutsche Post und DHL verwendet. Er ist eine spezialisierte Implementation von
  Code25.

  Dieser Barcode muss eine Länge von 14 Zeichen haben. Er unterstützt nur Ziffern, wobei die letzte Ziffer immer
  eine Checksumme ist welche durch Modulo 10 berechnet wird. Dieser Standard wird hauptsächlich von den Firmen DP
  und DHL verwendet.

- **PLANET**: Planet ist die Abkürzung für Postal Alpha Numeric Encoding Technique.

  Dieser Barcode kann eine Länge von 12 oder 14 Zeichen haben. Er unterstützt nur Ziffern wobei die letzt Ziffer
  immer eine Checksumme ist. Dieser Standard wird hauptsächlich von den United States Post Services verwendet.

- **POSTNET**: Postnet wird vom US Post Service verwendet.

  Dieser Barcode kann eine Länge von 6, 7, 10 oder 12 Zeichen haben. Er unterstützt nur Ziffern wobei die letzte
  Ziffer immer eine Checksumme ist. Dieser Standard wird hauptsächlich von den United States Post Services
  verwendet.

- **ROYALMAIL**: Royalmail wird von Royal Mail verwendet.

  Dieser Barcode hat keine definierte Länge. Er unterstützt Ziffern, großgeschriebene Buchstaben und die letzte
  Ziffer ist immer eine Checksumme. Dieser Standard wird hauptsächlich von Royal Mail für deren Cleanmail Service
  verwendet. Er wird auch *RM4SCC* genannt.

- **SSCC**: SSCC ist die Abkürzung für "Serial Shipping Container Code".

  Dieser Barcode ist eine Variante des EAN Barcodes. Er muss eine Länge von 18 Zeichen enthalten und unterstützt
  nur Ziffern. Die letzte Ziffer muss ein Ziffer für eine Checksumme sein welche durch Modulo 10 berechnet wird.
  Er wird üblicherweise in der Transport Industrie verwendet.

- **UPCA**: UPC ist die Abkürzung für "Univeral Product Code".

  Dieser Barcode ist der Vorgänger von EAN13. Er muss eine Länge von 12 Zeichen haben und unterstützt nur
  Ziffern. Die letzte Ziffer muss die Ziffer einer Checksumme sein welche durch Modulo 10 berechnet wird. Er wird
  üblicherweise in den USA verwendet.

- **UPCE**: UPCE ist die kurze Variante von UPCA.

  Dieser Barcode ist die kleinere Variante von UPCA. Er muss eine Länge von 6, 7 oder 8 Zeichen haben und
  unterstützt nur Ziffern. Wenn der Barcode 8 Ziffern lang ist enthält er eine Checksumme die durch Modulo 10
  berechnet wird. Er wird üblicherweise bei kleinen Produkten verwendet wo ein UPCA Barcode nicht passen würde.

.. _zend.validate.set.barcode.options:

Unterstützte Optionen für Zend\Validate\Barcode
-----------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\Barcode`` unterstützt:

- **adapter**: Setzt den Barcode Adapter welcher verwendet wird. Unterstützt werden alle vorher genannten Adapter.
  Wenn ein selbst definierter Adapter verwendet werden soll, muss man den kompletten Klassennamen setzen.

- **checksum**: ``TRUE`` wenn der Barcode eine Prüfsumme enthalten soll. Der Standardwert hängt vom verwendeten
  Adapter ab. Es ist zu beachten das einige Adapter es nicht erlauben diese Option zu setzen.

- **options**: Definiert optionale Optionen für selbst geschriebene Adapter.

.. _zend.validate.set.barcode.basic:

Grundsätzliche Verwendung
-------------------------

Um zu prüfen ob ein angegebener String ein Barcode ist muss man nur dessen Typ wissen. Siehe das folgende Beispiel
für einen EAN13 Barcode:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Barcode('EAN13');
   if ($valid->isValid($input)) {
       // Die Eingabe scheint gültig zu sein
   } else {
       // Die Eingabe ist ungültig
   }

.. _zend.validate.set.barcode.checksum:

Optionale Checksumme
--------------------

Einige Barcodes können mit einer optionalen Checksumme angegeben werden. Diese Barcodes würden gültig sein,
selbst ohne Checksumme. Trotzdem, wenn eine Checksumme angegeben wird, dann sollte man Sie auch prüfen.
Standardmäßig führen diese Barcode Typen keine Prüfung der Checksumme durch. Durch Verwendung der Option
``checksum`` kann man definieren ob die Checksumme geprüft oder ignoriert wird.

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Barcode(array(
       'adapter'  => 'EAN13',
       'checksum' => false,
   ));
   if ($valid->isValid($input)) {
       // Die Eingabe scheint gültig zu sein
   } else {
       // Die Eingabe ist ungültig
   }

.. note::

   **Reduzierte Sicherheit durch ausgeschaltete Prüfung der Checksumme**

   Indem die Prüfung der Checksumme ausgeschaltet wird, verringert man auch die Sicherheit der verwendeten
   Barcodes. Zusätzlich sollte man beachten dass man die Prüfung der Checksumme für jene Barcode Typen
   ausschalten kann welche einen Wert für die Checksumme enthalten müssen. Barcodes welche nicht gültig wären
   könnten dann als gültig zurückgegeben werden, selbst wenn Sie es nicht sind.

.. _zend.validate.set.barcode.custom:

Schreiben eigener Adapter
-------------------------

Man kann eigene Barcode Prüfungen für die Verwendung mit ``Zend\Validate\Barcode`` schreiben; das ist oft
notwendig wenn man mit proprietären Barcodes arbeiten muss. Um eine eigene Barcode Prüfung zu schreiben benötigt
man die folgenden Informationen.

- **Length**: Die Länge welche der Barcode haben muss. Diese kann einen der folgenden Werte haben:

  - **Integer**: Ein Wert größer als 0, was bedeutet das der Barcode diese Länge haben muss.

  - **-1**: Es gibt keine Begrenzung der Länge für diesen Barcode.

  - **"even"**: Die Länge dieses Barcodes muss eine gerade Anzahl an Ziffern enthalten.

  - **"odd"**: Die Länge dieses Barcodes muss eine ungerade Anzahl an Ziffern enthalten.

  - **array**: Ein Array von Integer Werten. Die Länge dieses Barcodes muss einer der gesetzten Array Werte haben.

- **Characters**: Ein String der die erlaubten Zeichen für diesen Barcode enthält. Auhc der Integer Wert 128 ist
  erlaubt, was für die ersten 128 Zeichen der ASCII Tabelle steht.

- **Checksum**: Ein Strung der als Callback für eine Methode verwendet wird, welche die Prüfung der Checksumme
  durchführt.

Die eigene Barcode Prüfung muss ``Zend\Validate_Barcode\AdapterAbstract`` erweitern oder
Zend\Validate_Barcode\AdapterInterface implementieren.

Als Beispiel, erstellen wir eine Prüfung welche eine gerade Anzahl an Zeichen erwartet welche alle Ziffern und die
Zeichen 'ABCDE' enthalten kann, und die eine Checksumme benötigt.

.. code-block:: .validator.
   :linenos:

   class My_Barcode_MyBar extends Zend\Validate_Barcode\AdapterAbstract
   {
       protected $_length     = 'even';
       protected $_characters = '0123456789ABCDE';
       protected $_checksum   = '_mod66';

       protected function _mod66($barcode)
       {
           // Mach einige Prüfungen und gib ein Boolean zurück
       }
   }

   $valid = new Zend\Validate\Barcode('My_Barcode_MyBar');
   if ($valid->isValid($input)) {
       // Die Eingabe scheint gültig zu sein
   } else {
       // Die Eingabe ist ungültig
   }


