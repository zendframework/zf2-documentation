.. EN-Revision: none
.. _zend.json.xml2json:

Conversión de XML a JSON
========================

``Zend_Json`` roporciona una método conveniente para transformar datos en formato *XML* a formato *JSON*. Esta
característica fue inspirado en un `artículo de IBM developerWorks`_.

``Zend_Json`` incluye una función estática llamada ``Zend\Json\Json::fromXml()``. Esta función generará *JSON* desde
una determinada entrada *XML*. Esta función toma cualquier string *XML* arbitrario como un parámetro de entrada.
También puede tomar opcionalmente parámetros booleanos de entrada que instruyan a la lógica de conversión de
ignorar o no los atributos *XML* durante el proceso de conversión. Si este parámetro opcional de entrada no está
dado, entonces el comportamiento por defecto es ignorar los atributos *XML*. La llamada a esta función se hace
como se muestra a continuación:

.. code-block:: php
   :linenos:

   // la función fromXml simplemente toma un string conteniendo XML
   // como entrada.
   $jsonContents = Zend\Json\Json::fromXml($xmlStringContents, true);

``Zend\Json\Json::fromXml()`` función que hace la conversión del parámetro de entrada formateado como un string *XML*
y devuelve el string de salida equivalente formateado a *JSON*. En caso de cualquier entrada con formato *XML*
erróneo o un error en la lógica de conversión, esta función arrojará una excepción. La conversión lógica
también usa técnicas recursivas para recorrer el árbol *XML*. Soporta una recursión de hasta 25 niveles de
profundidad. Más allá de esa profundidad, arrojará una ``Zend\Json\Exception``. Hay varios archivos *XML* con
diversos grados de complejidad provistas en el directorio de tests de Zend Framework. Se pueden utilizar para
probar la funcionalidad de la característica xml2json.

El siguiente es un ejemplo simple que muestra tanto el string de entrada *XML* pasado a y al string *JSON* de
salida devuelto como resultado de la función ``Zend\Json\Json::fromXml()``. Este ejemplo utilizó el parámetro de la
función opcional como para no ignorar los atributos *XML* durante la conversión. Por lo tanto, puede notar que el
string resultante *JSON* incluye una representación de los atributos *XML* presentes en el string de entrada
*XML*.

String de entrada XML pasada a la función ``Zend\Json\Json::fromXml()``:

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

String de salida *JSON* devuelto por la función ``Zend\Json\Json::fromXml()``:

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

Más detalles sobre esta característica xml2json pueden encontrarse en la propuesta original. Eche un vistazo a la
`Zend_xml2json proposal`_.



.. _`artículo de IBM developerWorks`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`Zend_xml2json proposal`: http://tinyurl.com/2tfa8z
