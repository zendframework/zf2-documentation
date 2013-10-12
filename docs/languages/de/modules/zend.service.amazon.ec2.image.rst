.. EN-Revision: none
.. _zend.service.amazon.ec2.images:

Zend\Service\Amazon\Ec2: Amazon Maschinen Images (AMI)
======================================================

Amazon Maschinen Images (AMIs) sind mit einer bereits wachsenden Listen von Betriebssystemen vorkonfiguriert.

.. _zend.service.amazon.ec2.images.info:

AMI Informations Tools
----------------------

.. _zend.service.amazon.ec2.images.register:

.. rubric:: Ein AMI mit EC2 registrieren

*register* Jedes *AMI* ist mit einer eideutigen ID assoziiert welche vom Amazon EC2 Service über die RegisterImage
Operation zur Verfügung gestellt wird. Wärend der Registrierung empfängt Amazon EC2 das spezifizierte Manifest
des Images von Amazon S3 und überprüft ob das Image dem Benutzer gehört der das Image registriert.

*register* gibt die imageId für das registrierte Image zurück.

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->register('imageLocation');

.. _zend.service.amazon.ec2.images.deregister:

.. rubric:: De-Registrieren einer AMI von EC2

*deregister*, de-registriert ein *AMI*. Einmal de-registriert können Instanzen dieses *AMI* nicht mehr gestartet
werden.

*deregister* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->deregister('imageId');

.. _zend.service.amazon.ec2.images.describe:

.. rubric:: Beschreiben einer AMI

*describe* gibt Informationen über *AMI*\ s, AKIs und ARIs zurück die für den Benutzer verfügbar sind. Die
zurückgegebenen Informationen enthalten den Imagetyp, Produktcodes, Architektur, Kernel und *RAM* Disk IDs. Images
die für den Benutzer verfügbar sind, enthalten öffentliche Images die zum Starten für jeden Benutzer vorhanden
sind, private Images die dem Benutzer gehören der die Anfrage stellt, und private Images die anderen Benutzern
gehören welche dem Benutzer explizit die Rechte zum Starten gegeben haben.





      .. _zend.service.amazon.ec2.images.describe-table:

      .. table:: Die Rechte für das Starten fallen in drei Kategorien

         +--------+-----------------------------------------------------------------------------------------------------------------------------+
         |Name    |Beschreibung                                                                                                                 |
         +========+=============================================================================================================================+
         |public  |Der Eigentümer des AMI gibt allen Gruppen das Recht das AMI zu starten. Alle Benutzer haben Startberechtigung für diese AMIs.|
         +--------+-----------------------------------------------------------------------------------------------------------------------------+
         |explicit|Der Eigentümer des AMI gibt einem spezifischen Benutzer die Startberechtigung.                                               |
         +--------+-----------------------------------------------------------------------------------------------------------------------------+
         |implicit|Ein Benutzer hat implizit die Startberechtigung für alle AMIs die Ihm gehören.                                               |
         +--------+-----------------------------------------------------------------------------------------------------------------------------+



Die Liste der zurückgegebenen *AMI*\ s kann durch die Spezifikation von *AMI* IDs, *AMI* Eigentümer oder
Benutzern mit Starterechtigung, geändert werden. Wenn keine Option spezifiziert wird, gibt Amazon EC2 alle *AMI*\
s zurück für die der Benutzer eine Startberechtigung hat.

Wenn eine oder mehrere *AMI* IDs spezifiziert werden, werden nur die *AMI*\ s zurückgegeben welche die
spezifizierten IDs besitzen. Wenn man eine ungültige *AMI* ID spezifiziert, wird ein Fehler zurückgegeben. Wenn
man eine *AMI* ID spezifiziert für die man keinen Zugriff hat, wird diese nicht in den zurückgegebenen
Ergebnissen enthalten sein.

Wenn ein oder mehrere *AMI* Eigentümer spezifiziert werden, werden nur die *AMI*\ s der spezifizierten
Eigentümer, für die man auch Zugriffsrechte hat, zurückgegeben. Die Ergebnisse können account für die Account
IDs des spezifizierten Eigentümers enthalten, amazon für *AMI*\ s die Amazon selbst gehören oder self für
*AMI*\ s die man selbst besitzt.

Wenn man eine Liste von ausführbaren Benutzern spezifiziert, werden nur die Benutzer zurückgegeben die eine
Startberechtigung für die *AMI*\ s haben. Man kann mit account, Account IDs spezifizieren (wenn man die *AMI*\ s
besitzt), self für *AMI*\ s die man selbst besitzt oder explizite Zugriffsrechte hat, oder all für öffentliche
*AMI*\ s.

*describe* gibt ein Array für alle Images zurück die den übergebenen Kriterien entsprechen. Das Array enthält
imageId, imageLocation, imageState, imageOwnerId, isPublic, architecture, imageType, kernedId, ramdiskId und
platform.

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->describe();

.. _zend.service.amazon.ec2.images.attribute:

Utilities für AMI Attribute
---------------------------

.. _zend.service.amazon.ec2.images.attribute.modify:

.. rubric:: Image Attribute verändern

Ein Attribut eines *AMI* verändern





      .. _zend.service.amazon.ec2.images.attribute.modify-table:

      .. table:: Gültige Attribute

         +----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
         |Name            |Beschreibung                                                                                                                                                                                                                                                                                                   |
         +================+===============================================================================================================================================================================================================================================================================================================+
         |launchPermission|Kontrolliert wer die Berechtigung hat das AMI zu starten. Startberechtigung kann spezifischen Benutzern durch das hinzufügen von userIds gegeben werden. Um das AMI öffentlich zu machen, sollte man die add Gruppe hinzufügen.                                                                                |
         +----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
         |productCodes    |Assoziiert einen Produktcode mit AMIs. Das erlaubt es Entwicklern Benutzer für die Verwendung von AMIs zu benennen. Der Benutzer muß für das Produkt angemeldet sein bevor er das AMI starten kann. Das ist ein Write-Once Attribut; nachdem es gesetzt wurde kann es nicht mehr geändert oder gelöscht werden.|
         +----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



*modifyAttribute* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   // Ändert die Startberechtigung (launchPermission) eines AMI
   $return = $ec2_img->modifyAttribute('imageId',
                                       'launchPermission',
                                       'add',
                                       'userId',
                                       'userGroup');

   // Setzt den Produktcode des AMI.
   $return = $ec2_img->modifyAttribute('imageId',
                                       'productCodes',
                                       'add',
                                       null,
                                       null,
                                       'productCode');

.. _zend.service.amazon.ec2.images.attribute.reset:

.. rubric:: Zurücksetzen eines AMI Attributes

*resetAttribute* setzt die Attribute eines *AMI* auf dessen Standardwerte zurück. **Das productCodes Attribut kann
nicht zurückgesetzt werden.**

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $return = $ec2_img->resetAttribute('imageId', 'launchPermission');

.. _zend.service.amazon.ec2.images.attribute.describe:

.. rubric:: AMI Attribute beschreiben

*describeAttribute* gibt Informationen über ein Attribut eines *AMI* zurück. Pro Aufruf kann nur ein Attribut
spezifiziert werden. Aktuell werden nur launchPermission und productCodes unterstützt.

*describeAttribute* gibt ein Array mit dem Wert des Attributes zurück das angefragt wurde.

.. code-block:: php
   :linenos:

   $ec2_img = new Zend\Service\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $return = $ec2_img->describeAttribute('imageId', 'launchPermission');


