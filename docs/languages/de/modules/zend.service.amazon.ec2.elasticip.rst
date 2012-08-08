.. EN-Revision: none
.. _zend.service.amazon.ec2.elasticip:

Zend_Service_Amazon_Ec2: Elastische IP Adressen
===============================================

Standardmäßig werden allen Amazon EC2 Instanzen beim Starten zwei IP Adressen zugeordnet: eine private (RFC 1918)
Adresse und eine öffentliche Adresse die über Network Address Translation (NAT) auf die private Adresse gemappt
wird.

Wenn man dynamische DNS verwendet um einen bestehenden DNS Namen zu einer öffentlichen IP Adresse einer neuen
Instanz zu verknüpfen, kann es für die IP Adresse bis zu 24 Stunden dauern bis Sie über das Internet
bekanntgegeben wurde. Als Ergebnis, können neue Instanzen keinen Verkehr empfangen weil beendete Instanzen
weiterhin Anfragen bekommen.

Um dieses Problem zu lösen, bietet Amazon EC2 elastische IP Adressen. Elastische IP Adressen sind statische IP
Adressen die für Dynamisches Cloud Computing entwickelt wurden. elastische IP Adressen werden mit dem eigenen
Account verknüpft, und nicht spezifischen Instanzen. Jede elastische IP Adresse die man mit dem eigenen Account
assoziiert bleibt mit dem eigenen Account verknüpft bis man diese explizit freigibt. Anders als traditionelle IP
Adressen erlauben es elastische IP Adressen Instanzen zu maskieren oder Zonen Fehler sichtbar zu machen indem die
eigene öffentliche IP Adresse schnell auf jede Instanz im eigenen Account verknüpft werden kann.

.. _zend.service.amazon.ec2.elasticip.allocate:

.. rubric:: Eine neue Elastische IP allokieren

*allocate* fügt dem eigenen Account eine neue Elastische IP Adresse hinzu.

*allocate* gibt die neu verknüpfte IP zurück.

.. code-block:: php
   :linenos:

   $ec2_eip = new Zend_Service_Amazon_Ec2_Elasticip('aws_key','aws_secret_key');
   $ip = $ec2_eip->allocate();

   // Gibt die neu verknüpfte elastische IP Adresse aus;
   print $ip;

.. _zend.service.amazon.ec2.elasticip.describe:

.. rubric:: Beschreiben von Verknüpften elastischen IP Adressen

*describe* hat einen optionalen Parameter um alle eigenen verknüpften elastischen IP Adressen zu beschreiben oder
auch nur einige der eigenen verknüpften Adressen.

*describe* gibt ein Array zurück das Informationen über jede elastische IP Adresse enthält welche wiederum
publicIp und instanceId enthalten wenn diese assoziiert sind.

.. code-block:: php
   :linenos:

   $ec2_eip = new Zend_Service_Amazon_Ec2_Elasticip('aws_key','aws_secret_key');
   // Beschreibe alle
   $ips = $ec2_eip->describe();

   // Beschreibe ein Subset
   $ips = $ec2_eip->describe(array('ip1', 'ip2', 'ip3'));

   // Beschreibe eine einzelne IP Adresse
   $ip = $ec2_eip->describe('ip1');

.. _zend.service.amazon.ec2.elasticip.release:

.. rubric:: Freigeben einer elastischen IP

*release* gibt eine elastische IP wieder für Amazon frei.

Gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_eip = new Zend_Service_Amazon_Ec2_Elasticip('aws_key','aws_secret_key');
   $ec2_eip->release('ipaddress');

.. _zend.service.amazon.ec2.elasticip.associate:

.. rubric:: Verknüpft eine elastische IP zu einer Instanz

*associate* verknüpft eine elastische IP mit einer bereits laufenden Instanz.

Gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_eip = new Zend_Service_Amazon_Ec2_Elasticip('aws_key','aws_secret_key');
   $ec2_eip->associate('instance_id', 'ipaddress');

.. _zend.service.amazon.ec2.elasticip.disassociate:

.. rubric:: Entfernt die Verknüpfung einer elastischen IP von einer Instanz

*disassocate* entfernt die Verknüpfung einer elastischen IP von einer Instanz. Wenn man eine Instanz beendet wird
diese automatisch die elastischen IP Adressen wieder freigeben.

Gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_eip = new Zend_Service_Amazon_Ec2_Elasticip('aws_key','aws_secret_key');
   $ec2_eip->disassociate('ipaddress');


