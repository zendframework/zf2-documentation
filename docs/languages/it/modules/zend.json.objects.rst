.. _zend.json.objects:

Oggetti JSON
============

Quando un oggetto PHP viene codificato in JSON, tutte le sue proprietà pubbliche sono convertite in un oggetto
JSON.

JSON non consente l'uso di riferimenti ad oggetti, quindi è necessario prestare attenzione a non codificare
oggetti con riferimenti ricorsivi. In caso di problemi con la ricorsione, i metodi *Zend_Json::encode()* e
*Zend_Json_Encoder::encode()* offrono un secondo parametro opzionale per verificare la presenza di una funzione
ricorsiva; un'eccezione viene generata se si codifica due volte un oggetto.

Nonostante gli oggetti JavaScript abbiano una stretta corrispondenza con gli array associativi in PHP, decodificare
un oggetto JSON aggiunge una piccola difficoltà. Alcuni suggeriscono che sia necessario passare un identificativo
di una classe e creare un'istanza della classe stessa valorizzata con le coppie di chiave/valore dell'oggetto JSON;
altri pensano che questo possa creare alcuni sostanziali rischi di sicurezza.

Per impostazione predefinita, *Zend_Json* decodifica gli oggetti JSON in array associativi, Tuttavia, se si
desidera che il metodo restituisca un oggetto, è possibile specificarlo:

.. code-block::
   :linenos:
   <?php
   // Decodifica gli oggetti JSON in oggetti PHP
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);

Ogni oggetto decodificato è restituito come oggetto istanza della classe *StdClass* dove le proprietà sono
rappresentate dalle coppie di chiave/valore nella notazione JSON.

La raccomandazione del Framework Zend è che ciascun sviluppatore decida come decodificare gli oggetti JSON. Se è
necessario creare un oggetto di un determinato tipo, lo si può creare nel codice dello sviluppatore e valorizzarlo
con i dati decodificati usando *Zend_Json*.


