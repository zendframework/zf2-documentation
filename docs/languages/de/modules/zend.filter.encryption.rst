.. _zend.filter.set.encrypt:

Encrypt
=======

Dieser Filter verschlüsselt beliebige Strings mit den angegebenen Einstellungen. Hierfür verwendet er Adapter.
Aktuell gibt es Adapter für die ``Mcrypt`` und ``OpenSSL`` Erweiterungen von *PHP*.

Da diese zwei Verschlüsselungs-Methodologien komplett unterschiedlich arbeiten, ist auch die Verwendung der
Adapters unterschiedlich. Man muß die Adapter den man verwenden will, bei der Initialisierung des Filters
auswählen.

.. code-block:: php
   :linenos:

   // Verwenden des Mcrypt Adapters
   $filter1 = new Zend_Filter_Encrypt(array('adapter' => 'mcrypt'));

   // Verwendung des OpenSSL Adapters
   $filter2 = new Zend_Filter_Encrypt(array('adapter' => 'openssl'));

Um einen anderen Adapter zu setzen kann man auch ``setAdapter()`` verwenden, und die ``getAdapter()`` Methode um
den aktuell gesetzten Adapter zu erhalten.

.. code-block:: php
   :linenos:

   // Verwenden des Mcrypt Adapters
   $filter = new Zend_Filter_Encrypt();
   $filter->setAdapter('openssl');

.. note::

   Wenn man die ``adapter`` Option nicht angibt oder setAdapter nicht verwendet, dann wird standardmäßig der
   ``Mcrypt`` Adapter verwendet.

.. _zend.filter.set.encrypt.mcrypt:

Verschlüsselung mit Mcrypt
--------------------------

Wenn man die ``Mcrypt`` Erweiterung installiert hat, kann man den ``Mcrypt`` Adapter verwenden. Dieser Adapter
unterstützt bei der Initialisierung die folgenden Optionen:

- **key**: Der Verschlüsselungs-Schlüssel mit dem die Eingabe verschlüsselt wird. Man benötigt den gleichen
  Schlüssel für die Entschlüsselung.

- **algorithm**: Der Algorithmus der verwendet werden soll. Das sollte einer der Algorithmus Cipher sein die man
  unter `PHP's Mcrypt Cipers`_ finden kann. Wenn er nicht gesetzt wird, ist er standardmäßig 'blowfish'.

- **algorithm_directory**: Das Verzeichnis in dem der Algorithmus gefunden werden kann. Wenn es nicht gesetzt wird,
  ist es standardmäßig der Pfad der in der Mcrypt Erweiterung gesetzt wurde.

- **mode**: Der Verschlüsselungs Modus der verwendet werden soll. Es sollte einer der Modi sein der unter `PHP's
  Mcrypt Modi`_ gefunden werden kann. Wenn er nicht gesetzt wird, ist er standardmäßig 'cbc'.

- **mode_directory**: Der Verzeichnis in dem der Modus gefunden werden kann. Wenn es nicht gesetzt wird, ist es
  standardmäßig der Pfad der in der ``Mcrypt`` Erweiterung gesetzt wurde.

- **vector**: Der Initialisierungs Vektor der verwendet werden soll. Wenn er nicht gesetzt wird, wird ein
  zufälliger Vektor verwende.

- **salt**: Ob der Schlüssel als Salt Wert verwendet wird. Der Schlüssel der für die Verschlüsselung verwendet
  wird, wird selbst auch verschlüsselt. Der Standardwert ist ``FALSE``.

- **compression**: Ob der verschlüsselte Wert komprimiert werden soll. Der Standard ist nicht komprimiert. Für
  Details sehen Sie unter :ref:`Komprimierung für Openssl <zend.filter.set.encrypt.openssl.compressed>` nach.

Wenn man einen String statt einem Array übergibt, wird dieser String als key Option verwendet.

Man kan die Verschlüsselungswerte auch im Nachhinein mit den Methoden ``getEncryption()`` und ``setEncryption()``
erhalten und setzen.

.. note::

   Es ist zu beachten das man eine Ausnahme erhält wenn die mcrypt Erweiterung in der eigenen Umgebung nicht
   vorhanden ist.

.. note::

   Man sollte auch beachten das alle Einstellungen geprüft werden wenn man eine Instanz erstellt oder
   ``setEncryption()`` aufruft. Wenn mcrypt ein Problem mit diesen Einstellungen erkennt wird eine Ausnahme
   geworfen.

Man kann den Verschlüsselungs Vektor durch den Aufruf von ``getVector()`` und ``setVector()`` erhalten und setzen.
Ein engegebener String wird, je nach benötigter Vektorgröße des verwendeten Algorithmus, abgeschnitten oder
aufgefüllt.

.. note::

   Es ist zu beachten das, wenn man keinen eigenen Vektor setzt, man den Vektor holen und speichern muß.
   Andernfalls ist man nicht in der Lage den verschlüsselten String wieder zu dekodieren.

.. code-block:: php
   :linenos:

   // Verwendet die standardmäßigen Blowfish Einstellungen
   $filter = new Zend_Filter_Encrypt('myencryptionkey');

   // Setzt einen eigenen Vektor, andernfalls muß man getVector()
   // ausrufen und diesen Vektor für spätere Entschlüsselung speichern
   $filter->setVector('myvector');
   // $filter->getVector();

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // Für Entschlüsselung siehe den Decrypt Filter

.. _zend.filter.set.encrypt.openssl:

Verschlüsselung mit OpenSSL
---------------------------

Wenn man die ``OpenSSL`` Erweiterung installiert hat, kann man den ``OpenSSL`` Adapter verwenden. Dieser Adapter
unterstützt bei der Instanziierung die folgenden Optionen:

- **public**: Der öffentliche Schlüssel des Benutzer dem man verschlüsselte Inhalte zur Verfügung stellen will.
  Man kann mehrere öffentliche Schlüssel angeben indem man ein Array verwendet. Man kann entweder den Pfad und
  den Dateinamen der Schlüsseldatei angeben, oder nur den Inhalt der Schlüseldatei selbst.

- **private**: Der eigene private Schlüssel der für die Verschlüsselung des Inhalts verwendet wird. Auch der
  private Schlüssel kann entweder ein Dateiname mit Pfad zur Schlüsseldatei sein, oder nur der Inhalt der
  Schlüsseldatei selbst.

- **compression**: Ob der verschlüsselte Wert komprimiert werden soll. Standardmäßig wird nicht komprimiert.

- **package**: Ob der Umschlagschlüssel mit dem verschlüsselten Wert gepackt werden soll. Der Standardwert ist
  ``FALSE``.

Man kann öffentliche Schlüssel auch im Nachhinein mit den Methoden ``getPublicKey()`` und ``setPublicKey()``
erhalten und setzen. Auch der private Schlüssel kann mit den entsprechenden Methoden ``getPrivateKey()`` und
``setPrivateKey()`` geholt und gesetzt werden.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // natürlich kann man die öffentlichen Schlüssel auch
   // bei der Instanziierung angeben
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));

.. note::

   Es ist zu beachten das der ``OpenSSL`` Adapter nicht funktionieren wird wenn keine gültigen Schlüsseln
   angegeben werden.

Wenn man auch die Schlüssel selbst verschlüsseln will, muß man eine Passphrase mit der ``setPassphrase()``
Methode angeben. Wenn man Inhalte entschlüsseln will, die mit einer Passphrase verschlüsselt wurden, muß man
nicht nur den öffentlichen Schlüssel, sondern auch die Passphrase um den verschlüsselten Schlüssel zu
entschlüsseln.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // Natürlich kann man die öffentlichen Schlüssel
   // auch bei der Instanziierung angeben
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

Zum Schluß muß man, wenn OpenSSL verwendet wird, dem Empfänger den verschlüsselten Inhalt, die Passphrase, wenn
eine angegeben wurde, und den Umschlagschlüssel für die Entschlüsselung angeben.

Das bedeutet, das man die Umschlagschlüssel nach der Verschlüsselung mit der ``getEnvelopeKey()`` Methode holen
muß.

Unser komplettes Beispiel für die Verschlüsselung von Inhalten mit ``OpenSSL`` schaut wie folgt aus.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // natürlich kann man die öffentlichen Schlüssel
   // auch bei der Instaiziierung angeben
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $encrypted = $filter->filter('text_to_be_encoded');
   $envelope  = $filter->getEnvelopeKey();
   print $encrypted;

   // Für die Entschlüsselung siehe beim Decrypt Filter

.. _zend.filter.set.encrypt.openssl.simplified:

Vereinfachte Verwendung mit Openssl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wie vorher zu sehen war, muss man den Umschlagschlüssel holen um in der Lage zu sein den vorher verschlüsselten
Wert wieder zu entschlüsseln. Das kann sehr frustrierend sein wenn man mit mehreren Werten arbeitet.

Für eine vereinfachte Verwendung kann man die ``package`` Option auf ``TRUE`` setzen. Der Standardwert ist
``FALSE``.

.. code-block:: php
   :linenos:

   // Verwende openssl und gib einen privaten Schlüssel an
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem',
       'public'  => '/public/key/path/public.pem',
       'package' => true
   ));

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // Für die Entschlüsselung siehe beim Decrypt Filter

Jetzt enthält der zurückgegebene Wert sowohl den verschlüsselten Wert als auch den Umschlagschlüssel. Man muss
diesen also nicht mehr nach der Verschlüsselung holen. Aber, und das ist der negative Aspekt dieses Features, der
verschlüsselte Wert kann jetzt nur mehr entschlüsselt werden indem man ``Zend_Filter_Encrypt`` verwendet.

.. _zend.filter.set.encrypt.openssl.compressed:

Komprimieren des Inhalts
^^^^^^^^^^^^^^^^^^^^^^^^

Basierend auf dem originalen Wert, kann der verschlüsselte Wert ein sehr langer String sein. Um den Wert zu
reduzieren erlaubt ``Zend_Filter_Encrypt`` die Verwendung von Kompression.

Die ``compression`` Option kann entweder auf den Namen eines Komprimierungsadapters gesetzt werden, oder auf ein
Array welches alle gewünschten Optionen für den Komprimierungsadapter setzt.

.. code-block:: php
   :linenos:

   // Verwende nur den grundsätzlichen Komprimierungsadapter
   $filter1 = new Zend_Filter_Encrypt(array(
       'adapter'     => 'openssl',
       'private'     => '/path/to/mykey/private.pem',
       'public'      => '/public/key/path/public.pem',
       'package'     => true,
       'compression' => 'bz2'
   ));

   // Verwende den Basis Komprimierungsadapter
   $filter2 = new Zend_Filter_Encrypt(array(
       'adapter'     => 'openssl',
       'private'     => '/path/to/mykey/private.pem',
       'public'      => '/public/key/path/public.pem',
       'package'     => true,
       'compression' => array('adapter' => 'zip', 'target' => '\usr\tmp\tmp.zip')
   ));

.. note::

   **Entschlüsselung mit den selben Werten**

   Wenn man einen Wert entschlüsseln will welcher zusätzlich komprimiert wurde, dann muss man die selben
   Komprimierungseinstellungen für die Entschlüsselung verwenden wie bei der Verschlüsselung. Andernfalls wird
   die Entschlüsselung fehlschlagen.



.. _`PHP's Mcrypt Cipers`: http://php.net/mcrypt
.. _`PHP's Mcrypt Modi`: http://php.net/mcrypt
