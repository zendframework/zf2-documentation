.. EN-Revision: none
.. _zend.json.xml2json:

Conversione da XML a JSON
=========================

*Zend_Json* fornisce un metodo di supporto per la trasformazione di dati XML nel formato JSON. Questa funzione è
stata ispirata dall'`articolo IBM developerWorks`_.

*Zend_Json* include una funzione statica chiamata *Zend\Json\Json::fromXml()*. Questa funzione genera codice JSON da un
input XML. Accetta una qualsiasi stringa XML arbitraria come parametro di input. Accetta inoltre un parametro
booleano opzionale per istruire la logica della conversione ad ignorare o no gli attributi XML nel processo di
trasformazione. Se non si fornisce questo parametro opzionale il comportamento predefinito consiste nell'ignorare
gli attributi XML. La chiamata a questo funzione avviene nel modo seguente:

.. code-block:: php
   :linenos:

           // la funzione fromXml accetta semplicemente una stringa
           // con contenuto XML come input
           $contenutoJson = Zend\Json\Json::fromXml($stringaContenutoXml, true);?>

La funzione *Zend\Json\Json::fromXml()* esegue la conversione del parametro stringa contenente l'XML e restituisce
l'equivalente contenuto nel formato JSON. In caso di errori nel formato XML o errori nella logica di conversione,
questa funzione genera un'eccezione. La logica della funzione utilizza inoltre una tecnica ricorsiva per scorrere
l'albero XML. Supporta una ricorsione fino a 25 livelli di profondità. Oltre a questo livello sarà generata
un'eccezione *Zend\Json\Exception*. Ci sono diversi file con vari livelli di difficoltà forniti nella directory di
test del Framework Zend. Possono essere usati per verificare le caratteristiche della funzionalità xml2json.

L'esempio seguente mostra sia la stringa XML passata come parametro, sia la stringa JSON restituita come risultato
della funzione *Zend\Json\Json::fromXml()*. Questo esempio utilizza il parametro opzionale per indicare di non ignorare
gli attributi XML in fase di conversione. Di conseguenza, è possibile notare come la stringa JSON risultante
includa una rappresentazione degli attributi XML presenti nella stringa XML iniziale.

La stringa XML passata alla funzione *Zend\Json\Json::fromXml()*:

.. code-block:: php
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <books>
       <book id="1">
           <title>Code Generation in Action</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>Manning</publisher>
       </book>

       <book id="2">
           <title>PHP Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>

       <book id="3">
           <title>Podcasting Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>
   </books> ?>

La stringa JSON restituita dalla funzione *Zend\Json\Json::fromXml()*:

.. code-block:: php
   :linenos:

   {
      "books" : {
         "book" : [ {
            "@attributes" : {
               "id" : "1"
            },
            "title" : "Code Generation in Action",
            "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "Manning"
         }, {
            "@attributes" : {
               "id" : "2"
            },
            "title" : "PHP Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }, {
            "@attributes" : {
               "id" : "3"
            },
            "title" : "Podcasting Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }
      ]}
   }  ?>

E' possibile trovare maggiori dettagli su questa funzionalità xml2json nella proposta originale. Si consiglia di
dare uno sguardo alla `proposta Zend_xml2json`_.



.. _`articolo IBM developerWorks`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`proposta Zend_xml2json`: http://tinyurl.com/2tfa8z
