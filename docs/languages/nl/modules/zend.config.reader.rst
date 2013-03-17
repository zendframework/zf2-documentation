.. EN-Revision: 18ad64234b220b9ac10f7ed3729b5f938964a528
.. _zend.config.reader.introduction:

Zend\\Config\\Reader
====================

``Zend\Config\Reader`` biedt de mogelijkheid om configuratiegegevens in te lezen. Er zijn concrete
implementaties voor het openen van verschillende bestandsformaten. ``Zend\Config\Reader`` zelf is een interface
die twee methoden bevat: ``fromFile()`` en ``fromString()``.

De concrete implementaties zijn:

- ``Zend\Config\Reader\Ini``

- ``Zend\Config\Reader\Xml``

- ``Zend\Config\Reader\Json``

- ``Zend\Config\Reader\Yaml``

Zowel ``fromFile()`` als ``fromString()`` geven een PHP array terug met de configuratiegegevens.

.. note::

   **Verschil met ZF1**

   De ``Zend\Config\Reader`` component ondersteunt niet langer:

   - Overerving van secties.

   - Inlezen van specifieke secties.

.. _zend.config.reader.ini:

Zend\\Config\\Reader\\Ini
-------------------------

``Zend\Config\Reader\Ini`` biedt de mogelijkheid om configuratiegegevens in *INI* formaat in te laden en ze
beschikbaar te stellen door middel van de array syntax.

``Zend\Config\Reader\Ini`` maakt gebruik van de *PHP* functie `parse_ini_file()`_. Raadpleeg de documentatie
om meer te weten te komen over de specifieke handelingen die naar ``Zend\Config\Reader\Ini`` gepropageerd worden,
zoals de manier waarop speciale waarden als "``TRUE``", "``FALSE``", "yes", "no", en "``NULL``" behandeld worden.

.. note::

   **Key Separator**

   De key separator is standaard een punt ("**.**"). Je kan dit wijzigen met behulp van de ``setNestSeparator()``
   methode. Bijvoorbeeld:

   .. code-block:: php
      :linenos:

      $reader = new Zend\Config\Reader\Ini();
      $reader->setNestSeparator('-');
      
Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Reader\Ini`` om configuratiegegevens in te lezen
uit een *INI* bestand:

.. code-block:: ini
   :linenos:

   webhost                  = 'www.example.com'
   database.adapter         = 'pdo_mysql'
   database.params.host     = 'db.example.com'
   database.params.username = 'dbuser'
   database.params.password = 'secret'
   database.params.dbname   = 'dbproduction'

Het INI bestand kan vervolgens ingelezen worden met behulp van ``Zend\Config\Reader\Ini``:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Ini();
   $data   = $reader->fromFile('/path/to/config.ini');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

``Zend\Config\Reader\Ini`` biedt tevens de mogelijkheid om de inhoud van een INI bestand
in te sluiten in een ander INI bestand. Stel dat je een INI bestand hebt dat database.ini heet:

.. code-block:: ini
   :linenos:

   database.adapter         = 'pdo_mysql'
   database.params.host     = 'db.example.com'
   database.params.username = 'dbuser'
   database.params.password = 'secret'
   database.params.dbname   = 'dbproduction'

Dan kan je de gegevens insluiten in een ander INI bestand: 

.. code-block:: ini
   :linenos:

   webhost  = 'www.example.com'
   @include = 'database.ini'

Als we dit bestand inlezen met ``Zend\Config\Reader\Ini``, dan zal de volledige structuur van het eerste voorbeeld
mee overgenomen worden.

De ``@include = 'file-to-include.ini'`` opdracht kan ook gebruikt worden in een subelement. Bijvoorbeeld:

.. code-block:: ini
   :linenos:

   adapter         = 'pdo_mysql'
   params.host     = 'db.example.com'
   params.username = 'dbuser'
   params.password = 'secret'
   params.dbname   = 'dbproduction'

Het gebruik van ``@include`` in een subelement:

.. code-block:: ini
   :linenos:

   webhost           = 'www.example.com'
   database.@include = 'database.ini'

.. _zend.config.reader.xml:

Zend\\Config\\Reader\\Xml
-------------------------

``Zend\Config\Reader\Xml`` biedt de mogelijkheid om configuratiegegevens in *XML* formaat in te laden en ze
beschikbaar te stellen door middel van de array syntax. De naam van het root element van de *XML* data is irrelevant.

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Reader\Xml`` om configuratiegegevens in te lezen
uit een *XML* bestand:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>?>
   <config>
       <webhost>www.example.com</webhost>
       <database>
           <adapter value="pdo_mysql"/>
           <params>
               <host value="db.example.com"/>
               <username value="dbuser"/>
               <password value="secret"/>
               <dbname value="dbproduction"/>
           </params>
       </database>
   </config>

Het XML bestand kan vervolgens ingelezen worden met behulp van ``Zend\Config\Reader\Xml``:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Xml();
   $data   = $reader->fromFile('/path/to/config.xml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"
   
``Zend\Config\Reader\Xml`` maakt gebruik van de *PHP* class `XMLReader`_. Raadpleeg de documentatie
om meer te weten te komen over de specifieke handelingen die naar ``Zend\Config\Reader\Xml`` gepropageerd worden.

Met ``Zend\Config\Reader\Xml`` kan je tevens de inhoud van XML bestanden insluiten in een specifiek XML element.
Dit gebeurt met de standaard XML functie `XInclude`_. Om deze functie te gebruiken moet je de namespace
``xmlns:xi="http://www.w3.org/2001/XInclude"`` toevoegen aan het HTML bestand. Stel dat je een XML bestand hebt 
met configuratiegegevens voor een database:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <config>
       <database>
           <adapter>pdo_mysql</adapter>
           <params>
               <host>db.example.com</host>
               <username>dbuser</username>
               <password>secret</password>
               <dbname>dbproduction</dbname>
           </params>
       </database>
   </config>

Dan kan je de gegevens insluiten in een ander XML bestand: 

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <config xmlns:xi="http://www.w3.org/2001/XInclude">
       <webhost>www.example.com</webhost>
       <xi:include href="database.xml"/>
   </config>

De syntax om een XML bestand in een specifiek element in te sluiten is ``<xi:include href="file-to-include.xml"/>``

.. _zend.config.reader.json:

Zend\\Config\\Reader\\Json
--------------------------

``Zend\Config\Reader\Json`` biedt de mogelijkheid om configuratiegegevens in *JSON* formaat in te laden en ze
beschikbaar te stellen door middel van de array syntax.

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Reader\Json`` om configuratiegegevens in te lezen
uit een *JSON* bestand:

.. code-block:: json
   :linenos:

   {
     "webhost"  : "www.example.com",
     "database" : {
       "adapter" : "pdo_mysql",
       "params"  : {
         "host"     : "db.example.com",
         "username" : "dbuser",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }

Het JSON bestand kan vervolgens ingelezen worden met behulp van ``Zend\Config\Reader\Json``:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Json();
   $data   = $reader->fromFile('/path/to/config.json');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

``Zend\Config\Reader\Json`` gebruikt de :ref:`Zend\\Json\\Json <zend.json.introduction>` class.

Met ``Zend\Config\Reader\Json`` kan je ook de inhoud van een JSON bestand inladen in een specifieke JSON sectie
of element met behulp van ``@include``. Stel dat je een JSON bestand hebt met configuratiegegevens voor een database:

.. code-block:: json
   :linenos:

   {
     "database" : {
       "adapter" : "pdo_mysql",
       "params"  : {
         "host"     : "db.example.com",
         "username" : "dbuser",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }

Dan kan je de gegevens insluiten in een ander JSON bestand: 

.. code-block:: json
   :linenos:

   {
       "webhost"  : "www.example.com",
       "@include" : "database.json"
   }

.. _zend.config.reader.yaml:

Zend\\Config\\Reader\\Yaml
--------------------------

``Zend\Config\Reader\Yaml`` biedt de mogelijkheid om configuratiegegevens in *YAML* formaat in te laden en ze
beschikbaar te stellen door middel van de array syntax. Om de YAML reader te kunnen gebruiken, moet je een 
callback specifiëren uit een externe library of de `Yaml PECL extension`_ gebruiken.

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Reader\Yaml`` en de Yaml PECL extensie om
configuratiegegevens in te lezen uit een *YAML* bestand:

.. code-block:: yaml
   :linenos:

   webhost: www.example.com
   database:
       adapter: pdo_mysql
       params:
         host:     db.example.com
         username: dbuser
         password: secret
         dbname:   dbproduction

Het YAML bestand kan vervolgens ingelezen worden met behulp van ``Zend\Config\Reader\Yaml``:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Yaml();
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

Als je een externe YAML reader wenst te gebruiken, dan moet je een callback functie specifiëren in de 
constructor. Stel dat je de `Spyc`_ wenst te gebruiken:

.. code-block:: php
   :linenos:

   // include the Spyc library
   require_once ('path/to/spyc.php');

   $reader = new Zend\Config\Reader\Yaml(array('Spyc','YAMLLoadString'));
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

Je kan ook de ``Zend\Config\Reader\Yaml`` instantiëren zonder parameters en de YAML reader nadien toewijzen
via de ``setYamlDecoder()`` methode.

Met ``Zend\Config\Reader\Yaml`` kan je ook de inhoud van een YAML bestand inladen in een specifieke YAML sectie
of element met behulp van ``@include``. Stel dat je een YAML bestand hebt met configuratiegegevens voor een database:

.. code-block:: yaml
   :linenos:

   database:
       adapter: pdo_mysql
       params:
         host:     db.example.com
         username: dbuser
         password: secret
         dbname:   dbproduction

Dan kan je de gegevens insluiten in een ander YAML bestand: 

.. code-block:: yaml
   :linenos:

   webhost:  www.example.com
   @include: database.yaml



.. _`parse_ini_file()`: http://php.net/parse_ini_file
.. _`XMLReader`: http://php.net/xmlreader
.. _`XInclude`: http://www.w3.org/TR/xinclude/
.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
