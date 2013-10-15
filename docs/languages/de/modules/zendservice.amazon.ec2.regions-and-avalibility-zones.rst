.. EN-Revision: none
.. _zendservice.amazon.ec2.zones:

ZendService\Amazon\Ec2: Regionen und Availability Zones
========================================================

Amazon EC2 bietet die Möglichkeit Instanzen in verschiedene Regionen und Avaiability Zonen zu patzieren. Regionen
werden in getrennte geographische Areale oder Länder geteilt. Avaiability Zonen sind in Regionen platziert und so
erstellt das Sie von Fehlern in anderen Availability Zonen isoliert sind und bieten eine billige Netzwerk
Verbindung mit geringer Latency zu anderen Availablilty Zonen in der gleichen Region. Durch Starten von Instanzen
in getrennten Availability Zonen kann man seine Anwendung vor einem Fehler in einer einzelnen Availability Zone
schützen.

.. _zendservice.amazon.ec2.zones.regions:

Amazon EC2 Regionen
-------------------

Amazon EC2 bietet viele Regionen so das man Amazon EC2 Instanzen in verschiedenen Lokationen, die den eigenen
Notwendigkeiten entsprechen, starten kann. Zum Beispiel kann es gewünscht sein Instanzen in Europa zu starten um
den eigenen europäischen Kunden näher zu sein oder um legalen Notwendigkeiten zu entsprechen.

Jede Amazon EC2 Region wurde gestaltet um von anderen Amazon EC2 Instanzen komplett isoliert zu sein. Das bietet
die grösst mögliche Fehlerunabhängigkeit und Stabilität, und es macht die Lokalität jeder EC2 Ressource
eindeutig.

.. _zendservice.amazon.ec2.zones.regions.example:

.. rubric:: Ansehen der vorhendenen Regionen

*describe* wird verwendet um herauszufinden zu welcher Region der eigene Account Zugriff hat.

*describe* gibt ein Array zurück das Informationen darüber enthält welche Regionen verfügbar sind. Jedes Array
enthält regionName und regionUrl.

.. code-block:: php
   :linenos:

   $ec2_region = new ZendService\Amazon\Ec2\Region('aws_key','aws_secret_key');
   $regions = $ec2_region->describe();

   foreach ($regions as $region) {
       print $region['regionName'] . ' -- ' . $region['regionUrl'] . '<br />';
   }

.. _zendservice.amazon.ec2.zones.availability:

Amazon EC2 Availability Zonen
-----------------------------

Wenn man eine Instanz startet, kann man optional eine Availability Zone spezifizieren. Wenn man keine Availability
Zone spezifiziert, wählt Amazon EC2 eine in der Region aus die man gerade verwendet. Wenn die initialen Instanzen
gestartet werden, empfehlen wir die standardmäßigen Availability Zone zu akzeptieren, welche es Amazon EC2
erlaubt die beste Availability Zone, basierend auf der Gesundheit des Systems und den vorhendenen Kapazitäten,
für einen auszuwählen. Selbst wenn man bereits andere Instanzen läuft, kann es gewünscht sein keine
Availability Zone auszuwählen wenn die neuen Instanze nicht notwendigerweise in der Nähe, oder seperiert, von
bestehenden Instanzen sein müssen.

.. _zendservice.amazon.ec2.zones.availability.example:

.. rubric:: Vorhendene Zonen sehen

*describe* wird verwendet um herauszufinden wie der Status jeder Availability Zone ist.

*describe* gibt ein Array zurück das Informationen darüber enthält, welche Zonen verfügbar sind. Jedes Array
enthält zoneName und zoneState.

.. code-block:: php
   :linenos:

   $ec2_zones = new ZendService\Amazon\Ec2\Availabilityzones('aws_key',
                                                              'aws_secret_key');
   $zones = $ec2_zones->describe();

   foreach ($zones as $zone) {
       print $zone['zoneName'] . ' -- ' . $zone['zoneState'] . '<br />';
   }


