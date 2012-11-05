.. EN-Revision: none
.. _zend.json.xml2json:

XML zu JSON Konvertierung
=========================

``Zend_Json`` bietet eine bequeme Methode für das transformieren von *XML* formatierten Daten in das *JSON*
Format. Dieses Feature wurde inspiriert durch einen `IBM developerWorks Artikel`_.

``Zend_Json`` enthält eine statische Funktion die ``Zend\Json\Json::fromXml()`` heißt. Diese Funktion erzeugt *JSON*
von einer angegebenen *XML* Eingabe. Diese Funktion nimmt jeglichen beliebigen *XML* String als Eingabe Parameter.
Sie nimmt auch einen optionalen Boolschen Eingabe Parameter um die Konvertierungslogik zu instruieren ob *XML*
Attribute wärend des Konvertierungsprozesses ignoriert werden sollen oder nicht. Wenn dieser optionale
Eingabeparameter nicht angegeben wurde, besteht das Standardverhalten darun *XML* Attribute zu ignorieren. Der
Funktionsaufruf wird wie folgt durchgeführt:

.. code-block:: php
   :linenos:

   // Die fromXml Funktion nimmt einfach einen String der XML
   // Inhalt als Eingabe enthält.
   $jsonContents = Zend\Json\Json::fromXml($xmlStringContents, true);

Die ``Zend\Json\Json::fromXml()`` Funktion führt die Konvertierung des *XML* formatierten String Eingabeparameters
durch und gibt eine äquivalente *JSON* formatierte String Ausgabe zurück. Im Fall eines *XML* Eingabeformat
Fehlers oder eines Konvertierungslogik Fehlers wird diese Funktion eine Ausnahme werfen. Die Konvertierungslogik
verwendet rekursive Techniken um den *XML* Baum zu durchlaufen. Sie unterstützt Rekursionen die bis zu 25 Levels
tief sind. Über diese Tiefe hinweg wird Sie eine ``Zend\Json\Exception`` werfen. Es gibt verschiedenste *XML*
Dateien mit unterschiedlichem Grad an Komplexität die im tests Verzeichnis des Zend Frameworks vorhanden sind. Sie
können verwendet werden um die Funktionalität des xml2json Features zu testen.

Das folgende ist ein einfaches Beispiel das beides zeigt, den *XML* Eingabe String und den *JSON* Ausgabe String
der als Ergebnis von der ``Zend\Json\Json::fromXml()`` Funktion zurückgegeben wird. Dieses Beispiel verwendet den
optionalen Funktionsparameter um die *XML* Attribute nicht wärend der Konvertierung zu ignorieren. Demzufolge kann
man sehen das der resultierende *JSON* String eine Repräsentation der *XML* Attribute enthält die im *XML*
Eingabestring vorhanden sind.

*XML* Eingabe String der an die ``Zend\Json\Json::fromXml()`` Funktion übergeben wird:

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
   </books>

*JSON* Ausgabe String der von der ``Zend\Json\Json::fromXml()`` Funktion zurückgegeben wird:

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
   }

Weitere Details über das xml2json Feature können im originalen Proposal selbst gefunden werden. Siehe
`Zend_xml2json proposal`_.



.. _`IBM developerWorks Artikel`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`Zend_xml2json proposal`: http://tinyurl.com/2tfa8z
