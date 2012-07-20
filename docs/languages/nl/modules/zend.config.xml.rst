.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

*Zend_Config_Xml* staat programmeurs toe om configuratiedate in een eenvoudig XML bestand op te slaan en deze via
geneste objecteigenschap syntax te lezen. Het root element van het XML bestand is irrelevant en kan een
willekeurige naam hebben. Het eerste niveau van de XML elementen komt overeen met configuratiedata secties. Het XML
formaat ondersteunt hiërarchische organisatie via geneste XML elementen onder de sectieniveau elementen. De inhoud
van het laagste XML element komt overeen met de waarde van een configuratiedata element. Sectie overerving wordt
ondersteund via een speciaal XML attribuut genaamd *extends*, en de waarde van dit attribuut komt overeen met de
naam van de sectie waarvan de data moet worden overgeërfd door de uitbreidende sectie.

.. note::

   **Teruggeef type**

   Configuratiedata die door *Zend_Config_Xml* word ingelezen wordt altijd als string terug gegeven. Omzetting van
   data van strings naar andere types wordt aan de programmeur overgelaten om aan hun specifieke behoeften te
   voldoen.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Zend_Config_Xml gebruiken

Dit voorbeeld illustreert een basisgebruik van *Zend_Config_Xml* voor het inladen van configuratiedata vanuit een
XML bestand. In dit voorbeeld vind je configuratiedata voor zowel een productiesysteem als een preproductiesysteem.
Omdat de preproductiesysteem configuratiedata sterk overeenkomt met de productieserver configuratiedata, erft de
preproductieserver sectie van de productie sectie. In dit geval is de beslissing willekeurig en zou dit andersom
kunnen worden geschreven, de productieserver sectie zou erven van de preproductieserver sectie, alhoewel het niet
het geval zou kunnen zijn in meer complexe situaties. Veronderstel dan dat de volgende configuratiedata in
*/path/to/config.xml* staat:

.. code-block::
   :linenos:
   <?xml version="1.0"?>
   <configdata>
       <productie>
           <webhost>www.example.com</webhost>
           <database>
               <type>pdo_mysql</type>
               <host>db.example.com</host>
               <username>dbuser</username>
               <password>secret</password>
               <name>dbname</name>
           </database>
       </productie>
       <preproductie extends="productie">
           <database>
               <host>dev.example.com</host>
               <username>devuser</username>
               <password>devsecret</password>
           </database>
       </preproductie>
   </configdata>
Veronderstel vervolgens dat de programmeur de preproductie configuratiedata van het XML bestand nodig heeft. Het is
eenvoudig om die data in te laden door het XML bestand en de preproductie sectie te specifiëren:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Config/Xml.php';

   $config = new Zend_Config_Xml('/path/to/config.xml', 'preproductie');

   echo $config->database->host; // geeft "dev.example.com"
   echo $config->database->name; // geeft "dbname"

