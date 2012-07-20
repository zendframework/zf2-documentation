.. _zend.acl.advanced:

Gevorderd gebruik
=================

.. _zend.acl.advanced.storing:

Het opslaan van ACL data voor langere duur
------------------------------------------

Zend_Acl is zo ontworpen dat het geen aparte achterliggende technologie zoals een database of een cache server voor
het opslaan van ACL data nodig heeft. De complete PHP implementatie maakt het mogelijk om aangepaste administratie
programma's te maken, gebouwd op Zend_Acl met relatief gemak en flexibiliteit. Veel situaties vereisen een vorm van
interactief onderhoud van de ACL en Zend_Acl levert methodes om dit op te zetten en het raadplegen van, de
toegangscontrole van een applicatie.

Het opslaan van de ACL Data is daarom overgelaten als een taak voor de ontwikkelaar, want de verwachting is dat de
gebruikersprocessen veel variëren voor de verschillende situaties. Omdat Zend_Acl te ordenen is, kan een ACL
object geordend worden met de PHP functie `serialize()`_ en het resultaat kan worden opgeslagen waar de
ontwikkelaar dat wenst, zoals een bestand, database of een caching mechanisme.

.. _zend.acl.advanced.assertions:

Schrijven van conditionele ACL regels met een vereising
-------------------------------------------------------

Soms is een regel voor het toestaan of weigeren van een Rol om een Bron te gebruiken niet absoluut, maar hangt dit
af van een aantal criteria. Als voorbeeld, stel dat iets moet worden toegestaan, maar alleen tussen 8:00 en 17:00.
Een ander voorbeeld is het weigeren van toegang omdat het verzoek komt van een IP adres die gemarkeerd is als een
bron van misbruik. Zend_Acl heeft een ingebouwde ondersteuning om regels, gebaseerd op wat voor condities de
ontwikkelaar nodig heeft, te implementeren.

Zend_Acl levert ondersteuning voor conditionele regels met *Zend_Acl_Assert_Interface*. Om de regel vereising
interface te gebruiken, schrijft de ontwikkelaar een class die de *assert()* methode van de interface
implementeerd.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl/Assert/Interface.php';

   class schoonIPvereising implements Zend_Acl_Assert_Interface
   {
       public function assert(Zend_Acl $acl, Zend_Acl_Role_Interface $role = null,
                              Zend_Acl_Resource_Interface $resource = null, $privilege = null)
       {
           return $this->_isEenSchoonIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isEenSchoonIP($ip)
       {
           // ...
       }
   }

Als een vereising klasse beschikbaar is, moet de ontwikkelaar een instantie hiervan aanleveren wanneer die een
conditionele regel toekent. Een regel die is gemaakt met een vereising wordt alleen toepast als de vereising waar
heeft terug gestuurd.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend_Acl();
   $acl->allow(null, null, null, new schoonIPvereising());

De bovenstaande code maakt een conditionele toestaan regel die gebruik toestaat van alle privileges op alles door
iedereen, behalve als het verzoekende IP op de "zwarte lijst" staat. Als een verzoek binnenkomt van een IP dat niet
beschouwd wordt als "schoon", dan wordt de toestaan regel niet toegepast. Omdat de regel geldt voor alle Rollen,
alle bronnen en alle privileges, zal een "niet schoon" IP resulteren in een weigering van toegang. Dit is een
speciaal geval, echter, en dit moet worden begrepen dat in alle andere gevallen ( i.e., als een specifieke Rol,
Bron of privilege is gespecificeerd voor de rol ), een onwaar vereisingresultaat in de regel niet wordt toegepast
en er dus andere regels gebruikt worden om te bepalen of er toegestaan of geweigerd moet worden.

Aan de *assert()* methode van een vereisingobject wordt de ACL, Rol, Bron en privilege doorgegeven, waarop de
raadpleging (i.e., *isAllowed()*) plaatsvind, dit maakt het mogelijk voor de vereisingklasse om te bepalen of zijn
condities nodig zijn.



.. _`serialize()`: http://php.net/serialize
