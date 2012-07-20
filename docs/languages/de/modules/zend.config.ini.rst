.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

``Zend_Config_Ini`` ermöglicht es Entwicklern, Konfigurations-Daten in einem vertrauten *INI* Format zu speichern
und sie mit einer Syntax auszulesen, die dem Zugriff auf die Eigenschaften verschachtelter Objekte entspricht. Das
verwendete *INI* Format bietet einerseits die Möglichkeit, Konfigurations Daten hierarchisch abzulegen und
andererseits Vererbung zwischen Sektionen zu spezifizieren. Konfigurations-Daten-Hierarchien werden durch das
Trennen der Schlüsselwörter durch einen Punkt (**.**). Eine Sektion kann eine andere Sektion erweitern oder
beerben indem man nach dem Sektionsname einen Doppelpunkt (**:**) notiert, gefolgt vom Namen der zu beerbenden
Sektion.

.. note::

   **Die Ini Datei parsen**

   ``Zend_Config_Ini`` verwendet die *PHP* Funktion `parse_ini_file()`_. Deren Dokumentation klärt über spezielle
   Verhaltensweisen auf, die sich auch auf ``Zend_Config_Ini`` auswirken, z. B. wie die besonderen Werte
   "``TRUE``", "``FALSE``", "yes", "no" und "``NULL``" gehandhabt werden.

.. note::

   **Schlüssel Trenner**

   Standardmäßig ist das Schlüssel Trennzeichen der Punkt (**.**). Dies kann geändert werden, indem der
   ``$options`` Schlüssel ``nestSeparator`` geändert wird, wenn das ``Zend_Config_Ini`` Objekt instanziert wird.
   Zum Beispiel:

   .. code-block:: php
      :linenos:

      $options['nestSeparator'] = ':';
      $config = new Zend_Config_Ini('/path/to/config.ini',
                                    'staging',
                                    $options);

.. _zend.config.adapters.ini.example.using:

.. rubric:: Zend_Config_Ini benutzen

Dieses Beispiel zeigt die grundlegende Nutzung von ``Zend_Config_Ini`` um Konfigurations-Daten aus einer *INI*
Datei zu laden. In diesem Beispiel gibt es Konfigurations-Daten für ein Produktiv- und ein Staging-System. Da sich
die Daten für das Staging-System nur unwesentlich von denen für das Produktiv-System unterscheiden, erbt das
Staging-System vom Produktiv-System. In diesem Fall ist die Entscheidung darüber, welche Sektion von welcher erben
soll, willkürlich und es könnte auch anders herum gemacht werden. In komplexeren Fällen ist das möglicherweise
nicht der Fall. Nehmen wir also an, dass sich die folgenden Konfigurations-Daten in der Datei
``/path/to/config.ini`` befinden:

.. code-block:: ini
   :linenos:

   ; Konfigurations-Daten für die Produktiv-Site
   [production]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; Konfigurations-Daten für die Staging-Site, erbt von der Produktion
   ; und überschreibt Werte, wo nötig
   [staging : production]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret

Nehmen wir weiterhin an, dass der Anwendungs-Entwickler die Staging-Konfiguration aus dieser *INI* Datei benötigt.
Es ist ein Leichtes, diese Daten zu laden, es muss nur die *INI* Datei und die Staging-Sektion spezifiziert werden:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/config.ini', 'staging');

   echo $config->database->params->host;   // Ausgabe "dev.example.com"
   echo $config->database->params->dbname; // Ausgabe "dbname"

.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Zend_Config_Ini Kontruktor Parameter

      +------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Parameter               |Notizen                                                                                                                                                                                                                                                                                                                                     |
      +========================+============================================================================================================================================================================================================================================================================================================================================+
      |$filename               |Die INI Datei die geladen wird.                                                                                                                                                                                                                                                                                                             |
      +------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section                |Die [section] innerhalb der INI Datei die geladen wird. Das Setzen dieses Parameters auf NULL lädt alle Sektionen. Alternativ, kann ein Array von Sektionsnamen übergeben werden um mehrere Sektionen zu laden.                                                                                                                             |
      +------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$options (Default FALSE)|Options Array. Die folgenden Schlüssel werden unterstützt: allowModifications: Auf TRUE gesetzt erlaubt es weiterführende Modifikationen der geladenen Konfigurationsdaten im Speicher. Standardmäßig auf NULL gestellt nestSeparator: Auf das Zeichen zu setzen das als Abschnitts Separator verwendet wird. Standardmäßig auf "." gestellt|
      +------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
