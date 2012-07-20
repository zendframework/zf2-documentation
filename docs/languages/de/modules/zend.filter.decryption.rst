.. _zend.filter.set.decrypt:

Decrypt
=======

Dieser Filter verschlüsselt beliebige Strings mit den angegebenen Einstellungen. Hierfür verwendet er Adapter.
Aktuell gibt es Adapter für die ``Mcrypt`` und ``OpenSSL`` Erweiterungen von *PHP*.

Für Details darüber wie man Inhalte verschlüsselt siehe den ``Encrypt`` Filter. Da die Grundlegenden Dinge beim
``Encrypt`` Filter behandelt werden, beschreiben wir hier nur mehr die zusätzlichen Methoden und Änderungen für
die Entschlüsselung.

.. _zend.filter.set.decrypt.mcrypt:

Entschlüsselung mit Mcrypt
--------------------------

Für die Entschlüsselung von Inhalten die vorher mit ``Mcrypt`` verschlüsselt wurden muß man die Optionen wissen
mit denen die Verschlüsselung aufgerufen wurde.

Es gibt einen wichtigen Unterschied. Wenn man bei der Verschlüsselung keinen Vektor angegeben hat, muß man Ihn
nach der Verschlüsselung des Inhalts holen indem die ``getVector()`` Methode am Verschlüsselungs-Filter
aufgerufen wird. Ohne den richtigen Vektor ist man nicht in der Lage den Inhalt zu entschlüsseln.

Sobald man alle Optionen angegeben hat ist die Entschlüsselung so einfach wie die Verschlüsselung.

.. code-block:: php
   :linenos:

   // Verwende die Standardmäßigen Blowfish Einstellungen
   $filter = new Zend_Filter_Decrypt('myencryptionkey');

   // Setze den Vektor mit dem der Inhalt verschlüsselt wurde
   $filter->setVector('myvector');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;

.. note::

   Man sollte beachten das man eine Ausnahme erhält wenn die Mcrypt Erweiterung in der eigenen Umgebung nicht
   vorhanden ist.

.. note::

   Man sollte ausserdem beachten das alle Einstellungen geprüft werden wenn man die Instanz erstellt oder wenn man
   ``setEncryption()`` aufruft. Wenn Mcrypt ein Problem mit den Einstellungen erkennt wird eine Ausnahme geworfen.

.. _zend.filter.set.decrypt.openssl:

Entschlüsselung mit OpenSSL
---------------------------

Entschlüsselung mit ``OpenSSL`` ist so einfach die Verschlüsseln. Aber man benötigt alle Daten von der Person
die den Inhalt verschlüsselt hat.

Für die Entschlüsselung mit ``OpenSSL`` benötigt man:

- **private**: Den eigenen privaten Schlüssel der für die Entschlüsselung des Inhalts verwendet wird. Der
  private Schlüssel kann ein Dateiname mit einem Pfad zur Schlüsseldatei sein, oder einfach der Inhalt der
  Schlüsseldatei selbst.

- **envelope**: Der verschlüsselte Umschlagschlüssel vom Benutzer der den Inhalt verschlüsselt hat. Man kann
  entweder den Pfad mit dem Dateinamen zur Schlüsseldatei angeben, oder den Inhalt der Schlüsseldatei selbst.
  Wenn die ``package`` Option gesetzt wurde, kann man diesen Parameter unterdrücken.

- **package**: Ob der Umschlagschlüssel mit dem verschlüsselten Wert gepackt werden soll. Der Standardwert ist
  ``FALSE``.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // natürlich kann man den Umschlagschlüssel auch bei der Instanziierung angeben
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));

.. note::

   Beachte das der ``OpenSSL`` Adapter nicht funktionieren wird wenn man keine gültigen Schlüssel angibt.

Optional könnte es notwendig sein die Passphrase für die Entschlüsselung der Schlüssel selbst anzugeben indem
die ``setPassphrase()`` Methode verwendet wird.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // natürlich kann man den Umschlagschlüssel auch bei der Instanziierung angeben
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

Zum Schluß kann der Inhalt entschlüsselt werden. Unser komplettes Beispiel für den vorher verschlüsselten Inhat
sieht nun wie folgt aus.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // natürlich kann man den Umschlagschlüssel auch bei der Instanziierung angeben
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;


