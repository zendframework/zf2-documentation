.. EN-Revision: none
.. _zend.json.xml2json:

Převod XML do JSON
==================

*Zend_Json* poskytuje metodu pro převod dat formátovaných pomocí XML do JSON formátu. Tato vlastnost je
inspirována `článkem na IBM developerWorks`_.

*Zend_Json* zahrnuje statickou metodu *Zend_Json::fromXml()*. Tato funkce generuje JSON ze vstupu ve formátu XML.
Tato funkce přijímá jako vstupní parametr jakýkoliv XML řetězec. Také přijímá druhý, volitelný
parametr zda ignorovat XML atributy během převodu. Pokud není tento volitelný parametr zadán, defaultní
chování je ignorování XML atributů. Volání této funkce je naznačeno níže:

.. code-block:: php
   :linenos:

           // Funkce fromXml jednoduše přijme String obsahující XML data jak vstup.
           $jsonContents = Zend_Json::fromXml($xmlStringContents, true);?>

Funkce *Zend_Json::fromXml()* provádí konverzi vstupního XML řetězce a vrací odpovídající zápis ve
formátu JSON. V případě chyby v XML nebo chyby při převodu, tato funkce vyhazuje výjimku. Tato konverze
také využívá rekurzivitu při procházení XML stromu. Podporuje zanoření do 25 úrovní. Za touto hloubkou
vyhodí *Zend_Json_Exception*. V adresáři tests Zend Frameworku je několik XML souborů s různým stupněm
komplexity pro otestování funkčnosti funkce xml2json.

Následující jednoduchý příklad ukazuje jak předaný XML vstup tak JSON výstup z funkce
*Zend_Json::fromXml()*. Tento příklad využívá volitelného parametru pro neignorování XML atributů během
převodu. Proto vrácený JSON řetězec obsahuje reprezentaci XML atributů přítomných ve vstupním XML
řetězci.

XML řetězec předaný funkci *Zend_Json::fromXml()*:

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

JSON výstup vrácený z funkce *Zend_Json::fromXml()*:

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

Více podrobností o funkci xml2json můžete najít v původním návrhu. Podívejte se na `návrh
Zend_xml2json`_.



.. _`článkem na IBM developerWorks`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`návrh Zend_xml2json`: http://tinyurl.com/2tfa8z
