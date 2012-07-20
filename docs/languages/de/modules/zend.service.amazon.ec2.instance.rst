.. _zend.service.amazon.ec2.instance:

Zend_Service_Amazon_Ec2: Instanzen
==================================

.. _zend.service.amazon.ec2.instance.types:

Instanz Typen
-------------

Amazon EC2 Instanzen werden in zwei Familien gruppiert: Standard und High-CPU. Standard Instanzen haben Speicher
und *CPU* Ratio die für die meisten generell gedachten Anwendungen passen; High-CPU Instanzen haben proportional
mehr *CPU* Ressourcen als Speicher (RAM) und sind gedacht für rechen-intensive Anwendungen. Wenn Instanz-Typen
ausgewählt werden, kann es gewünscht sein wenig intensive Instanztypen für Web-Server Instanzen zu verwenden und
intensivere Instanz-Typen für eigene Datenbank-Instanzen. Zusätzlich kann es gewünscht sein *CPU* Instanztypen
für *CPU*-intensive Datenverarbeitungs Tasks zu verwenden.

Eine der Vorteile von EC2 ist das man pro Stunde der Instanz zahlt, was es bequem und kostengünstig macht die
Performance der eigenen Anwendung auf verschiedenen Instanzfamilien und Typen zu testen. Ein guter Weg um zu
erkennen welches die passenste Instanzfamilie und der passenste Instanztyp ist, besteht darin Testinstanzen zu
starten und die Anweundung zu benchmarken.

.. note::

   **Instanz Typen**

   Der Instanztyp ist als Konstante im Code definiert. Spalte acht in der Tabelle ist der definierte Name der
   Konstante

.. _zend.service.amazon.ec2.instance.types-table:

.. table:: Vorhandene Instanztypen

   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+
   |Typ                |CPU                                                                           |Hauptspeicher|Plattenspeicher                                                     |Plattform|I/O             |Name     |Name der Konstante                           |
   +===================+==============================================================================+=============+====================================================================+=========+================+=========+=============================================+
   |Klein              |1 EC2 Recheneinheit (1 virtueller Kern mit 1 EC2 Recheneinheit)               |1.7 GB       |160 GB Speicher der Instanz (150 GB plus 10 GB Root Partition)      |32=bit   |Moderat         |m1.small |Zend_Service_Amazon_Ec2_Instance::SMALL      |
   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+
   |Groß               |4 EC2 Recheneinheiten (2 virtuelle Kerne mit jeweils 2 EC2 Recheneinheiten)   |7.5 GB       |850 GB Speicher der Instanz (2 x 420 GB plus 10 GB Root Partition)  |64-bit   |Hoch            |m1.large |Zend_Service_Amazon_Ec2_Instance::LARGE      |
   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+
   |Extra Groß         |8 EC2 Recheneinheiten (4 virtuelle Kerne mit jeweils 2 EC2 Recheneinheiten)   |15 GB        |1,690 GB Speicher der Instanz (4 x 420 GB plus 10 GB Root Partition)|64-bit   |Hoch            |m1.xlarge|Zend_Service_Amazon_Ec2_Instance::XLARGE     |
   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+
   |High-CPU Medium    |5 EC2 Recheneinheiten (2 virtuelle Kerne mit jeweils 2.5 EC2 Recheneinheiten) |1.7 GB       |350 GB Speicher der Instanz (340 GB plus 10 GB Root Partition)      |32-bit   |Durchschnittlich|c1.medium|Zend_Service_Amazon_Ec2_Instance::HCPU_MEDIUM|
   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+
   |High-CPU Extra Groß|20 EC2 Recheneinheiten (8 virtuelle Kerne mit jeweils 2.5 EC2 Recheneinheiten)|7 GB         |1,690 GB Speicher der Instanz (4 x 420 GB plus 10 GB Root Partition)|64-bit   |Hoch            |c1.xlarge|Zend_Service_Amazon_Ec2_Instance::HCPU_XLARGE|
   +-------------------+------------------------------------------------------------------------------+-------------+--------------------------------------------------------------------+---------+----------------+---------+---------------------------------------------+

.. _zend.service.amazon.ec2.instance.operations:

Ausführen von Amazon EC2 Instanzen
----------------------------------

Dieses Kapitel beschreibt die Methoden für die Behandlung von Amazon EC2 Instanzen.

.. _zend.service.amazon.ec2.instance.operations.run:

.. rubric:: Starten neuer EC2 Instanzen

*run* startetn eine spezifische Anzahl von EC2 Instanzen. *run* nimmt für den Start ein Array von Parametern.
Anbei ist eine Tabelle welche die gültigen Werte enthält.





      .. _zend.service.amazon.ec2.instance.operations.run-table:

      .. table:: Gültige Optionen für das Starten

         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |Name                  |Beschreibung                                                                                                                      |Benötigt|
         +======================+==================================================================================================================================+========+
         |imageId               |ID der AMI mit der Instanzen gestartet werden.                                                                                    |Ja      |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |minCount              |Minimale Anzahl der zu startenden Instanzen. Standardwert: 1                                                                      |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |maxCount              |Maximale Anzahl der zu startenden Instanzen. Standardwert: 1                                                                      |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |keyName               |Name des Schlüsselpaares mit dem Instanzen gestartet werden. Wenn man keinen Schlüssel angibt, werden alle Instanzen unangreifbar.|Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |securityGroup         |Name der Sicherheitsgruppe mit der Instanzen zu assoziieren sind.                                                                 |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |userData              |Die Benutzerdaten welche bei den zu startenden Instanzen vorhanden sind. Diese sollten nicht Base64 verschlüsselt sein.           |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |instanceType          |Spezifiziert den Instanztyp. Standardwert: m1.small                                                                               |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |placement             |Spezifiziert die Availability Zone in der Instanz(en) zu starten sind. Standardmäßig wählt Amazon EC2 eine Availability Zone aus. |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |kernelId              |Die ID des Kernels mit dem die Instanz gestartet werden soll.                                                                     |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |ramdiskId             |Die ID der RAM Disk mit der die Instanz gestartet werden soll.                                                                    |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |blockDeviceVirtualName|Spezifiziert den virtuellen Name der zu dem korrespondierenden Devicenamen gemappt werden soll. Zum Beispiel: instancestore0      |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |blockDeviceName       |Spezifiziert das Device zu dem der virtuelle Name gemappt werden soll. Zum Beispiel: sdb                                          |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+
         |monitor               |Schaltet das Monitoring für die AWS CloudWatch Instanz ein                                                                        |Nein    |
         +----------------------+----------------------------------------------------------------------------------------------------------------------------------+--------+



*run* gibt Informationen über jede Instanz zurück die gestartet wird.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->run(array('imageId' => 'ami-509320',
                                      'keyName' => 'myKey',
                                      'securityGroup' => array('web',
                                                               'default')));

.. _zend.service.amazon.ec2.instance.operations.reboot:

.. rubric:: Neu booten von EC2 Instanzen

*reboot* bootet eine oder mehrere Instanzen.

Diese Operation ist asynchron; die queuet nur die Anfrage eine spezifizierte Instanz(en) zu rebooten. Die Operation
wird erfolgreich sein wenn die Instanzen gültig sind und dem Benutzer gehören. Anfragen um beendete Instanzen zu
rebooten werden ignoriert.

*reboot* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->reboot('instanceId');

.. _zend.service.amazon.ec2.instance.operations.terminate:

.. rubric:: Beenden von EC2 Instanzen

*terminate* führt eine oder mehrere Instanzen herunter. Diese Operation ist idempotent; wenn eine Instanz mehr als
einmal terminiert wird, wird jeder Aufruf erfolgreich sein.

*terminate* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->terminate('instanceId');

.. note::

   **Terminierte Instanzen**

   Terminierte Instanzen bleiben nach der Terminierung sichtbar (voraussichtlich eine Stunde).

.. _zend.service.amazon.ec2.instance.utility:

Utilities für Amazon Instanzen
------------------------------

In diesem Kapitel erfährt man wie man Informationen über die Ausgabe der Console erhält und sieht ob eine
Instanz einen Produktcode enthält.

.. _zend.service.amazon.ec2.instance.utility.describe:

.. rubric:: Instanzen beschreiben

*describe* gibt Information über die Instanzen zurück die einem gehören.

Wenn man eine oder mehrere Instanz IDs spezifiziert, gibt Amazon EC2 Informationen über diese Instanzen zurück.
Wenn man keine Instanz IDs spezifiziert, gibt Amazon EC2 Informationen über alle relevanten Instanzen zurück.
Wenn eine ungültige Instanz ID spezifiziert wird, wird ein Fehler zurückgegeben. Wenn eine Instanz spezifiziert
wird die man nicht besitzt, wird diese in den zurückgegebenen Ergebnissen nicht enthalten sein.

*describe* gibt ein Array zurück das Informationen über die Instanz enthält.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describe('instanceId');

.. note::

   **Beendete Instanzen**

   Kürzlich beendete Instanzen können in den zurückgegebenen Ergebnissen vorkommen. Das Interval ist
   normalerweise weniger als eine Stunde. Wenn man nicht will das beendete Instanzen zurückgegeben werden, muß
   eine zweite Variable, ein boolsches ``TRUE``, an *describe* übergeben werden, und die beendete Instanz wird
   ignoriert.

.. _zend.service.amazon.ec2.instance.utility.describebyimageid:

.. rubric:: Instanzen anhand der Image Id beschreiben

*describeByImageId* ist funktional identisch mit *describe* gibt aber nur die Instanz zurück, welche die
angegebene imageId verwendet.

*describeByImageId* gibt ein Array zurück das Informationen über die Instanzen enthält, die von der übergebenen
imageId gestartet wurden.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeByImageId('imageId');

.. note::

   **Beendete Instanzen**

   Kürzlich beendete Instanzen können in den zurückgegebenen Ergebnissen vorkommen. Das Interval ist
   normalerweise weniger als eine Stunde. Wenn man nicht will das beendete Instanzen zurückgegeben werden, muß
   eine zweite Variable, ein boolsches ``TRUE``, an *describe* übergeben werden, und die beendete Instanz wird
   ignoriert.

.. _zend.service.amazon.ec2.instance.utility.consoleOutput:

.. rubric:: Empfangen von Konsolen-Ausgaben

*consoleOutput* empfänge die Ausgabe der Konsole für eine spezifizierte Instanz.

Die Ausgabe der Konsole einer Instanz wird gepuffert und kurz nach dem Booten, neu Booten, und Beenden der Instanz
gesendet. Amazon EC2 sichert die letzten 64 KB Ausgabe, welche zumindest eine Stunde nach dem letzten Senden
verfügbar sein ist.

*consoleOutput* gibt ein Array zurück das *instanceId*, *timestamp* von der letzten Ausgabe enthält und *output*
von der Konsole.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->consoleOutput('instanceId');

.. _zend.service.amazon.ec2.instance.utility.confirmproduct:

.. rubric:: Produktcode an einer Instanz bestätigen

*confirmProduct* gibt ``TRUE`` zurück wenn der spezifizierte Produktcode der spezifizierten Instanz angehängt
ist. Die Operation gibt ``FALSE`` zurück wenn der Produktcode der Instanz nicht angehängt ist.

Die *confirmProduct* Operation kann nur von dem Eigentümer der *AMI* ausgeführt werden. Dieses Feature ist
nützlich wenn ein *AMI* Eigentümer Support anbietet und sicherstellen will ob die Instanz eines Benutzer korrekt
ist.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->confirmProduct('productCode', 'instanceId');

.. _zend.service.amazon.ec2.instance.utility.monitor:

.. rubric:: Einschalten des CloudWatch Monitorings für Instanzen

*monitor* gibt die Liste von Instanzn und deren aktuellen Status vom CloudWatch Monitorings zurück. Wenn die
Instant das Monitoring aktuell nicht aktiviert hat, dann wird es eingeschaltet.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->monitor('instanceId');

.. _zend.service.amazon.ec2.instance.utility.unmonitor:

.. rubric:: Ausschalten des CloudWatch Monitorings für Instanzen

*monitor* gibt die Liste von Instanzn und deren aktuellen Status vom CloudWatch Monitorings zurück. Wenn die
Instant das Monitoring aktuell aktiviert hat, dann wird es ausgeschaltet.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend_Service_Amazon_Ec2_Instance('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->unmonitor('instanceId');


