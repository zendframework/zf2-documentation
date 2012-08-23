.. EN-Revision: none
.. _zend.json.advanced:

Fortgeschrittene Verwendung von Zend_Json
=========================================

.. _zend.json.advanced.objects1:

JSON Objekte
------------

Bei der Kodierung von *PHP* Objekten nach *JSON* werden alle öffentlichen Eigenschaften dieses Objektes im *JSON*
Objekt kodiert.

*JSON* erlaubt keine Objektreferenzen, deshalb sollte dafür Sorge getragen werden, dass keine Objekte mit
rekursiver Referenz kodiert werden. Wenn man Probleme mit Rekursion hat, erlauben ``Zend_Json::encode()`` und
``Zend_Json_Encoder::encode()`` die Angabe eines optionalen, zweiten Parameters, um auf Rekursion zu prüfen; wenn
ein Objekt doppelt serialisiert wird, wird eine Ausnahme geworfen.

Das Dekodieren von *JSON* Objekten stellt eine weitere Schwierigkeit dar, allerdings entsprechen Javascript Objekte
sehr einem assoziativen Array in *PHP*. Einige schlagen vor, dass ein Klassenbezeichner übergeben werden soll und
eine Objektinstanz dieser Klasse erstellt und mit den Schlüssel/Wert Paaren des *JSON* Objektes bestückt werden
soll; andere denken, dies könnte ein erhebliches Sicherheitsrisiko darstellen.

Standardmäßig wird ``Zend_Json`` die *JSON* Objekte als assoziative Arrays dekodieren. Wenn du allerdings
wünscht, dass ein Objekt zurück gegeben wird, kannst du dies angeben:

.. code-block:: php
   :linenos:

   // Dekodiere JSON Objekte als PHP Objekte
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);

Jedes dekodierte Objekte wird als ``StdClass`` Objekt mit Eigenschaften entsprechend der Schlüssel/Wert Paare der
*JSON* Notation zuürckgegeben.

Die Empfehlung des Zend Framework ist, dass der einzelne Entwickler selber entscheiden sollte, wie er *JSON*
Objekte dekodiert. Wenn ein Objekt eines bestimmten Typs erstellt werden soll, kann es im Code des Entwicklers
erstellt werden und mit den dekodierten Werten unter Verwendung von ``Zend_Json`` bestückt werden.

.. _zend.json.advanced.objects2:

Kodierung von PHP Objekten
--------------------------

Wenn man *PHP* Objekte kodiert, kann der Kodierungsmechanismus standardmäßig nur auf public Eigenschaften dieser
Objekte zugreifen. Wenn eine Methode ``toJson()`` an einem Objekte für die Kodierung implementiert ist, ruft
``Zend_Json`` diese Methode auf und erwartet dass das Objekt eine *JSON* Repräsentation seines internen Status
zurückgibt.

.. _zend.json.advanced.internal:

Interner Encoder/Decoder
------------------------

``Zend_Json`` hat zwei unterschiedliche Modi abhängig davon ob ext/json in der *PHP* Installation aktiviert ist
oder nicht. Wenn ext/json installiert ist, werden standardmäßig die Funktionen ``json_encode()`` und
``json_decode()`` für die Kodierung und Dekodierung von *JSON* verwendet. Wenn ext/json nicht installiert ist wird
eine Implentierung vom Zend Framework in *PHP* Code für die De-/Kodierung verwendet. Das ist naturgemäß
langsamer als die Verwendung der *PHP* Erweiterung, verhält sich aber identisch.

Machmal will man trotzdem den internen De-/Kodierer verwenden, selbst wenn man ext/json installiert hat. Man kann
das durch folgenden Aufruf erzwingen:

.. code-block:: php
   :linenos:

   Zend_Json::$useBuiltinEncoderDecoder = true:

.. _zend.json.advanced.expr:

JSON Ausdrücke
--------------

Javascript macht häufige Verwendung von anonymen Funktions-Callbacks, welche in *JSON* Objektvariablen gespeichert
werden können. Trotzdem funktionieren Sie nur wenn Sie nicht in doppelten Anführungszeichen gesetzt werden, was
``Zend_Json`` natürlich macht. Mit der Unterstützung von Ausdrücken für ``Zend_Json`` können *JSON* Objekte
mit gültigen Javascript Callbacks kodiert werden. Das funktioniert sowohl für ``json_encode()`` als auch den
internen Kodierer.

Ein Javascript Callback wird repräsentiert indem das ``Zend_Json_Expr`` Objekt verwendet wird. Es implementiert
das Wert-Objekt Pattern und ist nicht änderbar. Man kann den Javascript Ausdruck als erstes Argument des
Konstruktors setzen. Standardmäßig kodiert ``Zend_Json::encode`` keine Javascript Callbacks, wenn man die Option
``enableJsonExprFinder`` auf ``TRUE`` setzt und der ``encode()`` Funktion übergibt. Aktiviert, unterstützt
arbeiten Ausdrücke für alle enthaltenen Ausdrücke in großen Objektstrukturen. Ein Verwendungsbeispiel würde
wie folgt aussehen:

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend_Json_Expr('function() { '
                 . 'alert("Ich bin ein gültiger Javascript Callback '
                 . 'erstellt von Zend_Json"); }'),
       'other' => 'no expression',
   );
   $jsonObjectWithExpression = Zend_Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


