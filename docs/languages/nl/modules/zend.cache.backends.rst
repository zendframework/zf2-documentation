.. EN-Revision: none
.. _zend.cache.backends:

Zend_Cache backends
===================

.. _zend.cache.backends.file:

Zend_Cache_Backend_File
-----------------------

Deze backends slaat cache records op in bestanden (in een gekozen map).

Beschikbare opties zijn :

.. table:: Beschikbare opties

   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Optie               |Data Type|Standaardwaarde|Omschrijving                                                                                                                                                                                                                                                                                                                                 |
   +====================+=========+===============+=============================================================================================================================================================================================================================================================================================================================================+
   |cacheDir            |string   |'/tmp/'        |Map waar de cache bestanden worden opgeslaan                                                                                                                                                                                                                                                                                                 |
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fileLocking         |boolean  |true           |Zet fileLocking af of aan : kan cache corruptie onder slechte omstandigheden vermijden maar helpt niet op multithread webservers of op NFS bestandssystemen...                                                                                                                                                                               |
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |readControl         |boolean  |true           |Zet schrijfcontrole af of aan : indien aangezet wordt er een een controlesleutel in het cachebestand geschreven en deze sleutel word dan vergelijkt met de berekende sleutel na het inlezen.                                                                                                                                                 |
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |readControlType     |string   |'crc32'        |Leescontrole type (alleen indien schrijfcontrole is aangezet). Beschikbare waarden zijn : 'md5' (beste maar traagste), 'crc32' (een beetje minder secuur maar sneller, betere keuze), 'strlen' voor een lengtetest alleen (snelst).                                                                                                          |
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashedDirectoryLevel|int      |0              |Maat van gehashte map structuur : 0 betekent "geen gehashte mapstructuur", 1 betekent "1 map level", 2 betekent "2 map levels"... Deze optie kan de cache versnellen indien je meerdere duizende cache bestanden hebt. Alleen specifieke benchen kunnen je helpen om de juiste waarde voor je te vinden. Misschien is 1 of 2 een goede start.|
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashedDirectoryUmask|int      |0700           |Umask voor de gehashte mapstructuur                                                                                                                                                                                                                                                                                                          |
   +--------------------+---------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.sqlite:

Zend_Cache_Backend_Sqlite
-------------------------

Deze backend slaat cache records op in een SQLite database.

Beschikbare opties zijn :

.. table:: Beschikbare opties

   +-------------------------------+---------+---------------+-----------------------------------------------------------+
   |Optie                          |Data Type|Standaardwaarde|Omschrijving                                               |
   +===============================+=========+===============+===========================================================+
   |cacheDBCompletePath (mandatory)|string   |null           |Het complete pad (met bestandsnaam) naar de SQLite database|
   +-------------------------------+---------+---------------+-----------------------------------------------------------+

.. _zend.cache.backends.memcached:

Zend_Cache_Backend_Memcached
----------------------------

Deze backend slaat cache records op in een memcache server. `memcached`_ is een high-performance, gedistribueerd
systeem van object caching. Om deze backend te gebruiken heb je een memcached daemon en de `memcache PECL
extension`_ nodig.

Opgelet : met deze backend zijn "tags" niet ondersteund als het "doNotTestCacheValidity=true" argument.

Beschikbare opties zijn :

.. table:: Beschikbare opties

   +-----------+---------+-------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Optie      |Data Type|Standaardwaarde                                                          |Omschrijving                                                                                                                                                                                                                                                                                                   |
   +===========+=========+=========================================================================+===============================================================================================================================================================================================================================================================================================================+
   |servers    |array    |array(array('host' => 'localhost','port' => 11211, 'persistent' => true))|Een array van memcached servers ; elke memcached server is beschreven door een associatieve array : 'host' => (string) : de naam van een memcached server, 'port' => (int) : de poort van een memcached server, 'persistent' => (bool) : gebruik of niet van persistante verbindingen met deze memcached server|
   +-----------+---------+-------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compression|boolean  |false                                                                    |true indien je on-the-fly compressie wil gebruiken                                                                                                                                                                                                                                                             |
   +-----------+---------+-------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.apc:

Zend_Cache_Backend_APC
----------------------

Deze backend slaat cache records op in shared memory via de `APC`_ (Alternative PHP Cache) extensie (welke
uiteraard nodig is voor het gebruik van deze backend).

Opgelet : met deze backend zijn "tags" niet ondersteund als het "doNotTestCacheValidity=true" argument.

Er zijn geen opties voor deze backend.



.. _`memcached`: http://www.danga.com/memcached/
.. _`memcache PECL extension`: http://pecl.php.net/package/memcache
.. _`APC`: http://pecl.php.net/package/APC
