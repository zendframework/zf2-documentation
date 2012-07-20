.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` permite a los desarrolladores almacenar datos de configuración en un formato sencillo *XML* y
leerlos a través de una sintáxis de propiedades de objetos anidados. El elemento raíz del archivo *XML* es
irrelevante y puede ser nombrado arbitrariamente. El primer nivel de elementos *XML* corresponde con las secciones
de datos de configuración. El formato *XML* admite organización jerárquica a través del anidamiento de
elementos *XML* bajo los elementos a nivel de sección. El contenido de un elemento *XML* a nivel de hoja
corresponde al valor de un dato de configuración. La herencia de sección está permitida por un atributo *XML*
especial llamado **extends**, y el valor de este atributo se corresponde con la sección de la cual los datos son
heredados por la sección extendida..

.. note::

   **Tipo devuelto**

   Los datos de configuración que se leen en ``Zend_Config_Xml`` son siempre devueltos como strings. La
   conversión de datos de string a otros tipos se deja en manos de los desarrolladores para que se ajuste a sus
   necesidades particulares.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Usando Zend_Config_Xml

Este ejemplo ilustra un uso básico de ``Zend_Config_Xml`` para cargar datos de configuración de un archivo *XML*.
En este ejemplo hay datos de configuración tanto para un sistema de producción como para un sistema de pruebas.
Debido a que los datos de configuración del sistema de pruebas son muy similares a los de producción, la sección
de pruebas hereda de la sección de producción. En este caso, la decisión es arbitraria y podría haberse escrito
a la inversa, con la sección de producción heredando de la sección de pruebas, a pesar de que éste no sería el
caso para situaciones más complejas. Suponga, pues, que los datos de configuración siguientes están contenidos
en ``/path/to/config.xml``::

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter>pdo_mysql</adapter>
               <params>
                   <host>db.example.com</host>
                   <username>dbuser</username>
                   <password>secret</password>
                   <dbname>dbname</dbname>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host>dev.example.com</host>
                   <username>devuser</username>
                   <password>devsecret</password>
               </params>
           </database>
       </staging>
   </configdata>

Ahora, asuma que el desarrollador de aplicaciones necesita los datos de configuración de la fase de pruebas del
archivo *XML*. Es una tarea sencilla cargar estos datos, especificando el archivo *XML* y la sección de pruebas:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/ruta/de/config.xml', 'pruebas');

   echo $config->database->params->host;   // muestra "dev.example.com"
   echo $config->database->params->dbname; // muestra "dbname"

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Usando atributos de etiqueta en Zend_Config_Xml

Zend_Config_Xml también soporta dos formas adicionales de definir nodos en la configuración. Ambas hacen uso de
atributos. Dado que los atributos **extends** y **value** son palabras reservadas (la última por la segunda manera
de usar atributos), pueden no ser utilizadas. La primera manera de utilizar atributos es añadir atributos en un
nodo padre, el cual será interpretado como hijo de ese nodo:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret" dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser" password="devsecret"/>
           </database>
       </staging>
   </configdata>

La otra forma no reduce la configuración, sino que permite mantenerla de forma más fácil dado que no es
necesario escribir el nombre de la etiqueta dos veces. Simplemente, cree una etiqueta vacía con el valor en el
atributo **value**:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter value="pdo_mysql"/>
               <params>
                   <host value="db.example.com"/>
                   <username value="dbuser"/>
                   <password value="secret"/>
                   <dbname value="dbname"/>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host value="dev.example.com"/>
                   <username value="devuser"/>
                   <password value="devsecret"/>
               </params>
           </database>
       </staging>
   </configdata>

.. note::

   **XML strings**

   ``Zend_Config_Xml`` is able to load an *XML* string directly, such as that retrieved from a database. The string
   is passed as the first parameter to the constructor and must start with the characters **'<?xml'**:

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config>
          <production>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      $config = new Zend_Config_Xml($string, 'staging');

.. note::

   **Zend_Config XML namespace**

   ``Zend_Config`` comes with it's own *XML* namespace, which adds additional functionality to the parsing process.
   To take advantage of it, you have to define a namespace with the namespace *URI*
   ``http://framework.zend.com/xml/zend-config-xml/1.0/`` in your config root node.

   With the namespace enabled, you can now use *PHP* constants within your configuration files. Additionally, the
   **extends** attribute was moved to the new namespace and is deprecated in the ``NULL`` namespace. It will be
   completly removed there in Zend Framework 2.0.

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config xmlns:zf="http://framework.zend.com/xml/zend-config-xml/1.0/">
          <production>
              <includePath>
                  <zf:const zf:name="APPLICATION_PATH"/>/library</includePath>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging zf:extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      define('APPLICATION_PATH', dirname(__FILE__));
      $config = new Zend_Config_Xml($string, 'staging');

      echo $config->includePath; // Prints "/var/www/something/library"


