.. EN-Revision: none
.. _zendservice.amazon.ec2.reserved.instance:

ZendService\Amazon\Ec2: Reservierte Instanzen
==============================================

Mit Amazon *EC2* Reservierte Instanzen, kann man eine geringe Einmalzahlung für jede zu reservierende Instanz
tätigen und einen signifikanten Rabatt auf einer Stundenbasierenden Verwendung für diese Instanz erhalten.

Amazon *EC2* Reservierte Instanzen basieren auf Instanz Typ und Ort (Region und Vorhandene Zone) für eine
spezifizierte Zeitperiode (z.B. 1 Jahr oder 3 Jahre) und sind nur für Linux oder UNIX Instanzen erhältlich.

.. _zendservice.amazon.ec2.reserved.instance.howitworks:

Wie werden Reservierte Instanzen angehängt
------------------------------------------

Reservierte Instanzen werden an Instanzen angehängt welche den Typen- und Ortskriterien wärend der spezifizierten
Periode entsprechen. In diesem Beispiel verwendet ein Benutzer die folgenden Instanzen:

- (4) m1.small Instanzen in der Vorhandenen Zone us-east-1a

- (4) c1.medium Instanzen in der Vorhandenen Zone us-east-1b

- (2) c1.xlarge Instanzen ind er Vorhandenen Zone us-east-1b

Der Benutzer erwirbt anschließend die folgenden Reservierten Instanzen.

- (2) m1.small Instanzen in der Vorhandenen Zone us-east-1a

- (2) c1.medium Instanzen in der Vorhandenen Zone us-east-1a

- (2) m1.xlarge Instanzen in der Vorhandenen Zone us-east-1a

Amazon *EC2* fügt die zwei m1.small Reservierten Instanzen den zwei Instanzen in der Vorhandenen Zone us-east-1a
hinzu. Amazon *EC2* fügt die zwei c1.medium Reservierten Instanzen nicht hinzu weil die c1.medium Instanzen in
einer anderen Vorhandenen Zone sind und es fügt auch nicht die m1.xlarge Reservierten Instanzen hinzu weil es
keine laufenden m1.xlarge Instanzen gibt.

.. _zendservice.amazon.ec2.reserved.instance.operations:

Verwendung Reservierter Instanzen
---------------------------------

.. _zendservice.amazon.ec2.reserved.instance.operations.describe:

.. rubric:: Beschreibt Reservierte Instanzen die man gekauft hat

``describeInstances()`` gibt Informationen über eine reservierte Instanz oder Instanzen zurück die man gekauft
hat.

``describeInstances()`` gibt ein mehrdimensionales Array zurück welches folgendes enthält: reservedInstancesId,
instanceType, availabilityZone, duration, fixedPrice, usagePrice, productDescription, instanceCount und state.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeInstances('instanceId');

.. _zendservice.amazon.ec2.reserved.instance.offerings.describe:

.. rubric:: Beschreiben der aktuell vorhandenen Reservierten Instanz Angebote

``describeOfferings()`` beschreibt Angebote für Reservierte Instanzen die für einen Kauf vorhanden sind. Mit
Amazon *EC2* Reservierten Instanzen kauft man das Recht amazon *EC2* Instanzen für eine bestimmte Zeitdauer zu
starten (ohne Fehler wegen unzureichender Kapazität zu erhalten) und einen geringeren Preis für die Verwendung
der wirklich verwendeten Zeit zu erhalten.

``describeOfferings()`` gibt ein mehrdimensionales Array zurück das die folgenden Daten enthält:
reservedInstancesId, instanceType, availabilityZone, duration, fixedPrice, usagePrice und productDescription.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeOfferings();

.. _zendservice.amazon.ec2.reserved.instance.offerings.purchase:

.. rubric:: Das CloudWatch Monitoring bei Instanzen ausschalten

``purchaseOffering()`` erwirbt eine Reservierte Instanz für die Verwendung mit dem eigenen Account. Mit Amazon
*EC2* Reservierten Instanzen kauft man das Recht amazon *EC2* Instanzen für eine bestimmte Zeitdauer zu starten
(ohne Fehler wegen unzureichender Kapazität zu erhalten) und einen geringeren Preis für die Verwendung der
wirklich verwendeten Zeit zu erhalten.

``purchaseOffering()`` gibt die reservedInstanceId zurück.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->purchaseOffering('offeringId', 'instanceCount');


