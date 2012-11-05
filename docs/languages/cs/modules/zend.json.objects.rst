.. EN-Revision: none
.. _zend.json.objects:

JSON Objekty
============

Při převádění PHP objektů do JSON, budou veškere vlastnosti označené jako public převedeny do JSON
objektu.

JSON nedovoluje reference na objekt, takže je třeba dávat pozor a nepřevádět objekty s rekurzivními
referencemi. Pokud máte problémy s rekurzemi, *Zend\Json\Json::encode()* a *Zend\Json\Encoder::encode()* umožňují
volitelný druhý parametr, zda se mají kontrolovat rekurze; pokud je objekt serializován dvakrát, bude vyhozena
výjimka.

Dekódování JSON objektů je komplikovanější, nicméně Javascriptové objekty jsou nejvíce podobné
asociativním polím v PHP. Někteří lidé navrhují předávání identifikátoru třídy a naplnění instance
objektu daty ve formátu klíč/hodnota z JSON objektu; jiní si myslí, že by to způsobilo značné
bezpečnostní riziko.

Defaultně, *Zend_Json* dekóduje JSON objekty jako asociativní pole. Nicméně, pokud vyžadujete vrácení
objektu, můžete to určit takto:

.. code-block:: php
   :linenos:

   <?php
   // Dekódovat JSON objekty jako PHP objekty
   $phpNative = Zend\Json\Json::decode($encodedValue, Zend\Json\Json::TYPE_OBJECT);

Jakýkoliv objekt takto převedený je typu *StdClass* s vlastnostmi odpovídajícími dvojicím klíč/hodnota z
JSON zápisu.

Doporučení Zend Frameworku je, že každý vývojář by se měl rozhodnout jak dekódovat JSON objekty. Pokud je
potřeba vytvořit objekt daného typu, tak může být vytvořen vlastním kódem a naplněn hodnotami získanými
dekódováním pomocí *Zend_Json*.


