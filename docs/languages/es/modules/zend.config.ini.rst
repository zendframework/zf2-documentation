.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

``Zend_Config_Ini`` permite a los desarrolladores almacenar datos de configuración en un formato de datos *INI*
familiar, y leer de ellos en la aplicación usando una sintáxis de propiedades de objetos anidados. El formato
*INI* se especializa en proveer tanto la habilidad de mantener una jerarquía de claves de datos (data keys) de
configuración como la de mantener una jerarquía entre secciones de datos de configuración. Las jerarquías de
datos de configuración son provistas separando las claves mediante el carácter punto ( "**.**" ). Una sección
puede extender o heredar de otra sección indicando el nombre de la sección seguido de dos puntos ( "**:**" ) y el
nombre de la sección desde la cual se quieren heredar los datos.

.. note::

   **parse_ini_file**

   ``Zend_Config_Ini`` utiliza la función `parse_ini_file()`_ de *PHP*. Por favor, revise esta documentación para
   observar sus comportamientos específicos, que se propagan a ``Zend_Config_Ini``, tales como la forma en que los
   valores especiales: "``TRUE``" , "``FALSE``" , "yes" , "no" , y ``NULL`` son manejados.

.. note::

   **Separador de clave**

   Por defecto, el carácter separador de clave es el punto ( "**.**" ). Puede ser reemplazado, no
   obstante,cambiando la clave de ``$options`` llamada ``nestSeparator`` al construir el objeto
   ``Zend_Config_Ini``. Por ejemplo:

   .. code-block:: php
      :linenos:

      $options['nestSeparator'] = ':';
      $config = new Zend_Config_Ini('/path/to/config.ini',
                                    'pruebas',
                                    $options);

.. _zend.config.adapters.ini.example.using:

.. rubric:: Utilizando Zend_Config_Ini

Este ejemplo muestra una forma de uso básica de ``Zend_Config_Ini`` para cargar datos de configuración de un
archivo *INI*. En este ejemplo hay datos de configuración tanto para un sistema de producción como para un
sistema en fase de pruebas. Debido a que los datos de la fase de pruebas son muy parecidos a los de producción, la
sección de pruebas hereda de la sección de producción. En este caso, la decisión es arbitraria y podría
haberse escrito a la inversa, con la sección de producción heredando de la sección de pruebas, a pesar de que
éste no sería el caso para situaciones más complejas. Supongamos, entonces, que los siguientes datos de
configuración están contenidos en ``/path/to/config.ini``: :

.. code-block:: ini
   :linenos:

   ; Datos de configuración de la web de producción
   [produccion]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; Los datos de configuración de la fase de pruebas heredan de la producción
   ; y sobreescribren valores si es necesario
   [pruebas : produccion]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret

Ahora, asuma que el desarrollador de aplicaciones necesita los datos de configuración de la etapa de pruebas del
archivo *INI*. Resulta fácil cargar estos datos especificando el archivo *INI* en la sección de la etapa de
pruebas:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/config.ini', 'pruebas');

   echo $config->database->params->host;   // muestra "dev.example.com"
   echo $config->database->params->dbname; // muestra "dbname"

.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Parámetros del constructor Zend_Config_Ini

      +-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Parámetros               |Notas                                                                                                                                                                                                                                                                   |
      +=========================+========================================================================================================================================================================================================================================================================+
      |$filename                |El archivo INI que se va a cargar.                                                                                                                                                                                                                                      |
      +-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section                 |La [sección] contenida en el archivo INI que se va a cargar. Fijar este parámetro a NULL cargará todas las secciones. Alternativamente, se puede introducir un array de nombres de sección para cargar multiples secciones.                                             |
      +-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$options (default FALSE )|Array de opciones. Las siguientes claves están aceptadas: allowModifications : : Fijar a TRUE para permitir modificaciones subsiguientes del archivo cargado. Por defecto es NULLnestSeparator : Carácter que utilizar como separador de anidamiento. Por defecto es "."|
      +-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
