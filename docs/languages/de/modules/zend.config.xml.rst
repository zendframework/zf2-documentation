.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` ermöglicht es Entwicklern, Konfigurations-Daten in einfachen *XML* Dateien zu speichern und
sie mit einer Syntax auszulesen, die dem Zugriff auf die Eigenschaften verschachtelter Objekte entspricht. Der Name
des Root-Elementes der *XML* Datei oder des Strings ist unwichtig und kann beliebig gewählt werden. Die erste
Ebene der *XML* Struktur stellt die Konfigurationsdaten-Sektionen dar. Hirarchische Strukturen können im *XML*
Format durch Verschachteln von *XML* Elementen unterhalb der Sektions-Ebene umgesetzt werden. Der Inhalt eines
*XML* Blatt-Elementes (Leaf) ist der Wert eines Konfigurations-Eintrages. Die Sektions-Vererbung wird durch ein
spezielles *XML* Attribut namens **extends** unterstützt, der Wert des Attributs entspricht dabei dem Namen der
Sektion, von der Daten geerbt werden sollen.

.. note::

   **Rückgabe Typen**

   Konfigurations-Daten, die in ``Zend_Config_Xml`` eingelesen wurden, werden immer als Strings zurück gegeben.
   Die Konvertierung der Daten von Strings in andere Datentypen ist Aufgabe der Entwickler und von deren
   Bedürfnissen abhängig.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Zend_Config_Xml benutzen

Dieses Beispiel zeigt die grundlegende Nutzung von ``Zend_Config_Xml`` um Konfigurations-Daten aus einer *XML*
Datei zu laden. In diesem Beispiel gibt es Konfigurations-Daten für ein Produktiv- und ein Staging-System. Da sich
die Daten für das Staging-System nur unwesentlich von denen für das Produktiv-System unterscheiden, erbt das
Staging-System vom Produktiv-System. In diesem Fall ist die Entscheidung darüber, welche Sektion von welcher erben
soll, willkürlich und es könnte auch anders herum gemacht werden. In komplexeren Fällen ist das möglicherweise
nicht der Fall. Nehmen wir also an, dass sich die folgenden Konfigurations-Daten in der Datei
``/path/to/config.xml`` befinden:

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

Nehmen wir weiterhin an, dass der Anwendungs-Entwickler die Staging-Konfiguration aus dieser *XML* Datei benötigt.
Es ist ein Leichtes, diese Daten zu laden, es muss nur die *XML* Datei und die Staging-Sektion spezifiziert werden:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host;   // ausgabe "dev.example.com"
   echo $config->database->params->dbname; // ausgabe "dbname"

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Tag Attribute in Zend_Config_Xml verwenden

``Zend_Config_Xml`` unterstützt auch zwei zusätzliche Wege der Definition von Knoten in der Konfiguration. Beide
verwenden Attribute. Da die **extends** und **value** Attribute reservierte Schlüsselwörter sind (das letztere
durch den zweiten Weg der Verwendung von Attributen), können sie nicht verwendet werden. Der erste Weg Attribute
zu verwenden ist das hinzufügen von Attributen zum Elternknoten, welcher dann in einen Kindknoten dieses Knotens
übersetzt wird:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret"
                       dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser"
                       password="devsecret"/>
           </database>
       </staging>
   </configdata>

Der andere Weg verkürzt die Konfiguration nicht wirklich, macht es aber einfacher in der Handhabung das der
Tag-Name nicht zweimal geschrieben werden muß. Man erstellt einfach einen leeren Tag, welcher seinen Wert im
**value** Attribut enthält:

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

   **XML Strings**

   ``Zend_Config_Xml`` ist dazu in der Lage *XML* Strings direkt zu laden, wie z.B. deren Empfang von einer
   Datenbank. Der String wird als erster Parameter an den Konstruktor übergeben und muß mit den Zeichen
   **'<?xml'** beginnen:

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

   **Zend_Config XML Namespace**

   ``Zend_Config`` kommt mit seinem eigenen *XML* Namespace, welcher zusätzliche Funktionalität beim Parsing
   Prozess hinzufügt. Um diese Vorteile zu verwenden, muß ein Namespace mit der Namespace *URI*
   ``http://framework.zend.com/xml/zend-config-xml/1.0/`` im Root Node der Konfiguration definiert werden.

   Wenn der Namespace aktiviert ist, können *PHP* Konstanten in den Konfigurationsdateien verwendet werden.
   Zusätzlich ist das **extends** Attribut in den neuen Namespace gewandert und in im ``NULL`` Namespace nicht
   mehr erlaubt. Es wird mit Zend Framework 2.0 komplett entfernt.

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

      echo $config->includePath; // Ausgabe "/var/www/something/library"


