.. EN-Revision: none
.. _zend.service.amazon.ec2.windows.instance:

Zend\Service_Amazon\Ec2: Windows Instanzen
==========================================

Die Verwendung von Amazon EC2 Instanzen auf denen Windows läuft ist ähnlich wie die Verwendung von Instanzen die
Linux oder UNIX und Windows verwenden:

- Remote Desktop—Um auf Windows Instanzen zuzugreifen muß Remote Desktop statt SSH verwendet werden.

- Administratives Passwort—Um auf Windows Instanzen das erste Mal zugreifen zu können muß man das
  administrative Passwort holen indem der ec2-get-password Befehl verwendet wird.

- Vereinfachtes Bündeln- Um eine Windows Instanz zu bündeln muß ein einzelnes Kommando verwendet werden, der die
  Instanz beendet, diese als *AMI* speichert, und Sie wieder startet.

Als Teil dieses Services können Amazon EC2 Instanzen jetzt Microsoft Windows Server 2003 ausführen. Die Basis
Windows Images bieten die meisten mit Windows verbundenen Funktionalitäten. Wenn man trotzdem mehr als zwei
gleichzeitige Windows Benutzer benötigt, oder Anwendungen hat die *LDAP*, Kerberos, RADIUS oder andere
Benutzerservices verwenden muß man Windows mit Authentifizierungs Services verwenden. Zum Beispiel benötigen
Microsoft Exchange Server und Microsoft Sharepoint Server Windows mit Authentifizierungs Services.

.. note::

   Um damit zu beginnen Windows Instanzen zu verwenden ist es empfohlen die *AWS* Management Konsole zu verwenden.
   Es gibt Unterschiede in den Preisen zwischen Windows und Windows mit Authenzifizierungs Services Instanzen. Für
   Informationen über Preise sehen Sie bitte auf die Amazon EC2 Produkt Seite.

Amazon EC2 bietet aktuell die folgenden Windows *AMI*\ s:

- Windows Authentifiziert (32-bit)

- Windows Authentifiziert (64-bit)

- Windows Anonym (32-bit)

- Windows Anonym (64-bit)

Die öffentlichen Windows *AMI*\ s die Amazon anbietet sind unmodifizierte Versionen von Windows mit den folgenden
zwei Ausnahmen: Es sind Treiber hinzugefügt welche die Geschwindigkeit von Netzwerk und Disk I/O verbessern und es
wurde ein Amazon EC2 Konfigurations Service erstellt. Der Amazon EC2 Konfigurations Service bietet die folgenden
Funktionen:

- Setzt das Administrator Passwort zufällig bei ersten Starten, verschlüsselt das Passwort mit dem SSH Schlüssel
  des Benutzers, und gibt Ihn an die Konsole zurück. Diese Operation passiert wärend dem ersten Start von *AMI*.
  Wenn das Passwort geändert wird, dann werden *AMI*\ s die von dieser Instanz erstellt wurden das neue Passwort
  verwenden.

- Konfiguriert den Computernamen auf den internen DNS Namen. Um den internen DNS Namen zu ermitteln, siehe
  Verwendung von Instanz Adressierung.

- Sendet die letzten drei System- und Anwendungsfehler vom Eventlog an die Konsole. Das hilft entwickler Probleme
  zu identifizieren welche den Crash einer Instanz verursacht oder die Netzwerkverbindung unterbrochen haben.

.. _zend.service.amazon.ec2.windows.instance.operations:

Verwendung von Windows Instanzen
--------------------------------

.. _zend.service.amazon.ec2.windows.instance.operations.bundle:

.. rubric:: Bündelt eine Amazon EC2 Instanz auf der Windows läuft

``bundle()`` hat drei benötigte Parameter und einen optionalen

- **instanceId** Die Instanz die man bündeln will

- **s3Bucket** Wo man will das die *AMI* auf S3 lebt

- **s3Prefix** Der Präfix den man dem AMI auf S3 zuordnen will

- **uploadExpiration** Der Ablauf der Upload Policy. Amazon empfiehlt 12 Stunden oder länger. Das basiert auf der
  Anzahl an Minuten. Der Standardwert ist 1440 Minuten (24 Stunden)

``bundle()`` gibt ein multidimensionales Array zurück welches die folgenden Werte enthält: instanceId, bundleId,
state, startTime, updateTime, progress, s3Bucket und s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend\Service\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->bundle('instanceId', 's3Bucket', 's3Prefix');

.. _zend.service.amazon.ec2.windows.instance.operations.describe:

.. rubric:: Beschreibt die aktuellen Bündelungstasks

``describeBundle()`` Beschreibt die aktuellen Bündelungstasks

``describeBundle()`` gibt ein multidimensionales Array zurück welches die folgenden Werte enthält: instanceId,
bundleId, state, startTime, updateTime, progress, s3Bucket und s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend\Service\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeBundle('bundleId');

.. _zend.service.amazon.ec2.windows.instance.operations.cancel:

.. rubric:: Beendet eine Amazon EC2 Bündel-Operation

``cancelBundle()`` Beendet eine Amazon EC2 Bündel-Operation

``cancelBundle()`` gibt ein multidimensionales Array zurück welches die folgenden Werte enthält: instanceId,
bundleId, state, startTime, updateTime, progress, s3Bucket und s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new Zend\Service\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->cancelBundle('bundleId');


