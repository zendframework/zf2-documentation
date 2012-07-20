.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

*Zend_Config_Ini* staat programmeurs toe configuratiedata op te slaan in een vertrouwd INI formaat en deze terug in
te lezen in de applicatie door gebruik te maken van een syntax met geneste objecteigenschappen. Het INI formaat is
gespecializeerd om een hiërarchie van configuratiedata keys te verstrekken, evenals de erfelijkheid tussen
verschillende configuratiedata secties. Hiërachies van configuratiedata worden ondersteund door de keys te
scheiden met een punt (*.*). Een sectie kan een andere sectie uitbreiden of overerven door een dubbelpunt te
schrijven achter de sectienaam (*:*) en de naam van de sectie waarvan de data wordt geërfd.

.. note::

   **parse_ini_file**

   *Zend_Config_Ini* gebruikt de `parse_ini_file()`_ PHP functie. Ga deze documentatie na om op de hoogte te zijn
   van specifiek gedrag van de functie, die wordt overgedragen naar *Zend_Config_Ini*, zoals hoe speciale waarden
   als *true*, *false*, *yes*, *no*, en *null* worden behandeld.

.. note::

   **Key scheider**

   Standaard, is de punt (*.*) het teken om keys te scheiden. Dit kan worden gewijzigd, door de *$config* key
   *'nestSeparator'* te wijzigen als je een nieuwe *Zend_Config_Ini* object aanmaakt. Als voorbeeld:

      .. code-block::
         :linenos:
         <?php
         require_once 'Zend/Config/Ini.php';
         $config['nestSeparator'] = ':';
         $config = new Zend_Config_Ini('/path/to/config.ini', 'staging', $config);



.. _zend.config.adapters.ini.example.using:

.. rubric:: Zend_Config_Ini gebruiken

Dit voorbeeld illustreert een basisgebruik van *Zend_Config_Ini* voor het inladen van configuratiedata vanuit een
INI bestand. In dit voorbeeld vind je configuratiedata voor zowel een productiesysteem als een preproductiesysteem.
Omdat de preproductiesysteem configuratiedata sterk overeenkomt met de productieserver configuratiedata, erft de
preproductieserver sectie van de productie sectie. In dit geval is de beslissing willekeurig en zou dit andersom
kunnen worden geschreven, de productieserver sectie zou erven van de preproductieserver sectie, alhoewel het niet
het geval zou kunnen zijn in meer complexe situaties. Veronderstel dan dat de volgende configuratiedata in
*/path/to/config.ini* staat:

.. code-block::
   :linenos:
   ; Configuratiedata voor productieserver
   [productie]
   webhost           = www.example.com
   database.type     = pdo_mysql
   database.host     = db.example.com
   database.username = dbuser
   database.password = secret
   database.name     = dbname

   ; Preproductieserver configuratiedata erft van productieserver en
   ; overschrijft waarden waar nodig
   [preproductie : productie]
   database.host     = dev.example.com
   database.username = devuser
   database.password = devsecret
Veronderstel vervolgens dat de programmeur de preproductie configuratiedata van het INI bestand nodig heeft. Het is
eenvoudig om die data in te laden door het INI bestand en de preproductie sectie te specifiëren:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Config/Ini.php';

   $config = new Zend_Config_Ini('/path/to/config.ini', 'preproductie');

   echo $config->database->host; // geeft "dev.example.com"
   echo $config->database->name; // geeft "dbname"
.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Zend_Config_Ini Constructor parameters

      +---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Parameter      |Opmerking                                                                                                                                                                                                                                                                             |
      +===============+======================================================================================================================================================================================================================================================================================+
      |$filename      |Het ini bestand wat geladen moet worden                                                                                                                                                                                                                                               |
      +---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section       |De sectie binnen het ini bestand dat geladen moet worden. Door deze parameter de waarde null te geven, worden alle secties geladen. Verder kan een array van sectie namen worden meegegeven om meerdere secties te laden.                                                             |
      +---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$config = false|Configuratie array. De volgende keys worden ondersteund: allowModifications: Zet deze op true om wijzigingen toe te staan in het geladen bestand. Standaard is dit false.nestSeparator: Hiermee kan je aangeven welk teken gebruikt moet worden als key scheider. Standaard is dit "."|
      +---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
