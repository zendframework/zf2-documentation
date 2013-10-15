.. EN-Revision: none
.. _zendservice.amazon.ec2.keypairs:

ZendService\Amazon\Ec2: Schlüsselpaare
=======================================

Schlüsselpaare werden verwendet um auf Instanzen zuzugreifen.

.. _zendservice.amazon.ec2.keypairs.create:

.. rubric:: Erstellen eines neuen Amazon Schlüsselpaars

*create*, erstellt ein neues 2048 RSA Schlüsselpaar und gibt eine eindeutige ID zurück die verwendet werden kann
um auf diese Schlüsselpaare zu referenzieren wenn eine neue Instanz gestartet wird.

*create* gibt ein Array zurück das keyName, keyFingerprint und keyMaterial enthält.

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->create('my-new-key');

.. _zendservice.amazon.ec2.keypairs.delete:

.. rubric:: Löschen eines Amazon Schlüsselpaares

*delete*, löscht das Schlüsselpaar. Das verhindert nur das er von neuen Instanzen verwendet wird. Aktuell, mit
diesem Schlüsselpaar laufende Instanzen, erlauben es trotzdem das man auf Sie zugreigen kann.

*delete* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->delete('my-new-key');

.. _zendservice.amazon.ec2.describe:

.. rubric:: Ein Amazon Schlüsselpaar beschreiben

*describe* gibt Informationen über das vorliegende Schlüsselpaar zurück. Wenn man ein Schlüsselpaar
spezifiziert, werden Informationen über diese Schlüsselpaare zurückgegeben. Andernfalls werden Informationen
über alle registrierten Schlüsselpaare zurückgegeben.

*describe* gibt ein Array zurück das keyName und keyFingerprint enthält.

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->describe('my-new-key');


