.. EN-Revision: none
.. _zend.service.amazon.ec2.cloudwatch:

Zend\Service\Amazon\Ec2: CloudWatch Monitoring
==============================================

Amazon CloudWatch ist ein einfach zu verwendender Web Service der vollständiges Monitoring für Amazon Elastic
Compute Cloud (Amazon *EC2*) und Elastic Load Balancing bietet. Für detailiertere Informationen sehen Sie in den
`Amazon CloudWatch Developers Guide`_.

.. _zend.service.amazon.ec2.cloudwatch.usage:

Verwendung von CloudWatch
-------------------------

.. _zend.service.amazon.ec2.cloudwatch.usage.list:

.. rubric:: Liste der vorhandenen Metrik

``listMetrics()`` gibt eine Liste von bis zu 500 gültigen Metriken an für welche aufgezeichnete Daten vorhanden
sind und einen NextToken String der verwendet werden kann um eine Abfrage für das nächste Set von Ergebnissen zu
erhalten.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\CloudWatch('aws_key','aws_secret_key');
   $return = $ec2_ebs->listMetrics();

.. _zend.service.amazon.ec2.cloudwatch.usage.getmetricstatistics:

.. rubric:: Gibt Statistiken für eine gegebene Metrik zurück

``getMetricStatistics()`` gibt Daten für ein oder mehrere Statistiken einer gegebenen Metrik zurück.

.. note::

   Die maximale Anzahl an Datenpunkten die das Amazon CloudWatch Service in einer einzelnen GetMetricStatistics
   Anfrage zurückgibt ist 1.440. Wenn eine Anfrage durchgeführt wird, die mehr Datenpunkt als diese Anzahl
   erstellen würde, gibt Amazon CloudWatch einen Fehler zurück. Man kann die Anfrage anpassen indem der
   Zeitbereich (StartTime, EndTime) angenähert wird, oder indem die Dauer in der einzelnen Anfrage erhöht wird.
   Man kann also alle Daten mit der gleichen Granularität erhalten in der man diese ursprünglich angefragt hat,
   indem mehrere Anfragen mit angepassten Zeitbereichen durchgeführt werden.

``getMetricStatistics()`` benötigt nur zwei Parameter, besitzt aber vier zusätzliche Parameter die optional sind.

- **Benötigt:**

- **MeasureName** Der Name der Maßeinheit die mit der Maßeinheit der geholten Metrik korrespondiert. Gültige
  *EC2* Werte sind *CPU*\ Utilization, NetworkIn, NetworkOut, DiskWriteOps, DiskReadBytes, DiskReadOps,
  DiskWriteBytes. Gültige Elastic Load Balancing Metriken sind Latency, RequestCount, HealthyHostCount,
  UnHealthyHostCount. `Für weitere Informationen hier klicken`_.

- **Statistics** Die Statistik die für die angegebene Metrik zurückgegeben werden soll. Gültige Werte sind
  Average, Maximum, Minimum, Samples, Sum. Man kann diese als String oder Array von Strings definieren. Wenn man
  keine spezifiziert dann wird als Standard Average genommen statt nichts zu tun. Wenn man eine ungültige Option
  spezifiziert wird diese einfach ignoriert. `Für weitere Informationen hier klicken`_.

- **Optional:**

- **Dimensions** Amazon CloudWatch erlaubt es eine Dimension zu spezifizieren um Metrikdaten weiter zu filtern.
  Wenn man keine Dimension spezifiziert, gibt der Service die Zusammenfassung alle Maße mit dem angegebenen Namen
  der Maßeinheit und dem Zeitbereich zurück.

- **Unit** Die Standardeinheit der Maßeinheit für ein angegebenes Maß. Gültige Werte sind: Seconds, Percent,
  Bytes, Bits, Count, Bytes/Second, Bits/Second, Count/Second, und None. Verknüpfungen: Wenn Count/Second als
  Einheit verwendet wurd, sollte man Sum als Statistik verwenden und nicht Average. Andernfalls gibt das Beispiel
  die Anzahl der Anfragen zurück und nicht die Anzahl der 60-Sekunden Intervalle. Das würde dazu führen das
  Average immer 1 ist wenn die Einheit Count/Second ist.

- **StartTime** Der Zeitpunkt des ersten Datenpunkts der zurückgegeben werden soll, inklusive diesem. Zum
  Beispiel, 2008-02-26T19:00:00+00:00. Wir runden den Wert zur naheliegendsten Minute. Man kann die Startzeit bis
  zu mehr als zwei Wochen in die Vergangenheit setzen. Trotzdem wird man nur Werte für die letzten zwei Wochen
  erhalten. (Im *ISO* 8601 Format). Abhängigkeiten: Muß vor EndTime liegen.

- **EndTime** Der Zeitpunkt der für die Ermittlung des letzten Datenpunkts verwendet werden soll der
  zurückzugeben ist. Das ist der letzte Datenpunkt der zu holen ist, exklusive. Zum Beispiel,
  2008-02-26T20:00:00+00:00 (Im *ISO* 8601 Format).

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\CloudWatch('aws_key','aws_secret_key');
   $return = $ec2_ebs->getMetricStatistics(
                                        array('MeasureName' => 'NetworkIn',
                                              'Statistics' => array('Average')));



.. _`Amazon CloudWatch Developers Guide`: http://docs.amazonwebservices.com/AmazonCloudWatch/latest/DeveloperGuide/Welcome.html
.. _`Für weitere Informationen hier klicken`: http://docs.amazonwebservices.com/AmazonCloudWatch/latest/DeveloperGuide/US_GetStatistics.html
