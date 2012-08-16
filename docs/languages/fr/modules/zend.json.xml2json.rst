.. EN-Revision: none
.. _zend.json.xml2json:

XML to JSON conversion
======================

``Zend_Json`` fournit une méthode de convenance pour transformer des données au format *XML* en un format *JSON*.
Ce dispositif est inspiré `d'un article de developerWorks d'IBM`_.

``Zend_Json`` inclut une fonction statique appelée ``Zend_Json::fromXml()``. Cette fonction produira du *JSON* à
partir d'une entrée au format *XML*. Cette fonction prend n'importe quelle chaîne arbitraire *XML* comme
paramètre d'entrée. Elle prend également un paramètre booléen facultatif d'entrée pour informer la logique de
conversion d'ignorer ou non les attributs *XML* pendant le processus de conversion. Si ce paramètre facultatif
d'entrée n'est pas donné, alors le comportement par défaut est d'ignorer les attributs *XML*. Cet appel de
fonction est réalisé comme ceci :

.. code-block:: php
   :linenos:

   // la fonction fromXml prend simplement une chaîne
   // contenant le XML comme entrée
   $jsonContents = Zend_Json::fromXml($xmlStringContents, true);

La fonction ``Zend_Json::fromXml()`` fait la conversion du paramètre d'entrée (chaîne au format *XML*) et
renvoie le rendu équivalent sous forme de chaîne au format *JSON*. En cas d'erreur, de format *XML* ou de logique
de conversion, cette fonction lèvera une exception. La logique de conversion emploie également des techniques
récursives à travers l'arbre *XML*. Il supporte la récursivité jusqu'à 25 niveaux de profondeur. Au delà de
cette profondeur, elle lèvera une ``Zend_Json_Exception``. Il y a plusieurs fichiers *XML*, avec différents
niveaux de complexité, fournis dans le répertoire tests de Zend Framework. Ils peuvent être utilisés pour
tester la fonctionnalité du dispositif xml2json.

Ce qui suit est un exemple simple qui montre à la fois la chaîne *XML* fournie et la chaîne *JSON* retournée en
résultat de la fonction ``Zend_Json::fromXml()``. Cet exemple utilise le paramètre facultatif pour ne pas ignorer
les attributs *XML* pendant la conversion. Par conséquent, vous pouvez noter que la chaîne résultante *JSON*
inclut une représentation des attributs *XML* actuels de la chaîne *XML* fournie.

Chaîne *XML* fournie à la fonction ``Zend_Json::fromXml()``:

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

Chaîne *JSON* retournée par la fonction ``Zend_Json::fromXml()``:

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

Plus de détails au sujet de ce dispositif xml2json peuvent être trouvés dans la proposition originale
elle-même. Jetez un oeil à la `proposition Zend_xml2json`_.



.. _`d'un article de developerWorks d'IBM`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`proposition Zend_xml2json`: http://framework.zend.com/wiki/display/ZFPROP/Zend_xml2json+-+Senthil+Nathan
