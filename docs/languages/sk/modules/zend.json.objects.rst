.. EN-Revision: none
.. _zend.json.objects:

JSON objekty
============

Keď sa serializuje PHP objekt na JSON objekt všetky verejné vlastnosti sú zahrnuté vo výslednom objekte.

JSON nedovoľuje referencie na objekty a teda je potrebné dať pozor na objekty s rekurzívnymi referenciami. Ak
máte problém s rekurziou, môžete nastaviť druhy nepovinný parameter pri volaniach *Zend\Json\Json::encode()* a
*Zend\Json\Encoder::encode()*, ktorý zisťuje rekurziu - ak je objekt serializovaný druhý raz bude vyvolaná
výnimka.

Deserializácia JSON objektov nie je jednoduchá, pretože Javascript objekty sú podobné asociatívnym poliam v
PHP. Niekto navrhuje odovzdať meno triedy a následnej vytvoriť jej inštanciu, ktorá bude obsahovať vlastnosti
a hodnoty z JSON objektu - ostatným sa to zdá ako značná bezpečnostná diera.

*Zend_Json* primárne vracia asociatívne pole, ak chcete aby bol vrátený objekt, môžete to urobiť nasledovne:

.. code-block:: php
   :linenos:

   <?php
   // Decode objects as objects
   $phpNative = Zend\Json\Json::decode($encodedValue, Zend\Json\Json::TYPE_OBJECT);
   ?>
Všetky objekty sú takto deserializované ako *StdClass* a ich vlastnosti zodpovedajú vlastnostiam a ich
hodnotám z JSON objektu.

Zend Framework prenecháva rozhodnutie ako nakladať z deserializovanými objektami na vývojára. Ak je potrebné
vytvoriť špecifický objekt, stále je to možné urobiť priamo v kóde a použiť hodnoty získane z
*Zend_Json*


