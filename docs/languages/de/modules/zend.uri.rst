.. EN-Revision: none
.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Überblick
---------

``Zend_Uri`` ist eine Komponente, die das Verändern und Validieren von `Uniform Resource Identifiers`_ (URIs)
unterstützt. ``Zend_Uri`` existiert hauptsächlich, um andere Komponenten wie z.B. ``Zend\Http\Client`` zu
unterstützen, aber ist auch als eigenständiges Hilfsmittel nützlich.

*URI*\ s beginnen immer mit einem Schema, gefolgt von einem Doppelpunkt. Der Aufbau der vielen unterschiedlichen
Schemata unterscheidet sich erheblich. Die ``Zend_Uri`` stellt eine Fabrik (Factory) bereit, die eine Unterklasse
von sich selber zurück gibt, die auf das entsprechende Schema spezialisiert ist. Diese Unterklasse heißt
``Zend\Uri\<scheme>``, wobei **<scheme>** das Schema in Kleinbuchstaben mit einem Großbuchstaben am Anfang
darstellt. Eine Ausnahme dieser Regel ist *HTTPS*, das auch von ``Zend\Uri\Http`` verarbeitet wird.

.. _zend.uri.creation:

Eine neue URI erstellen
-----------------------

``Zend_Uri`` erstellt eine neue *URI* von Grund auf, wenn nur das Schema an ``Zend\Uri\Uri::factory()`` übergeben
wurde.

.. _zend.uri.creation.example-1:

.. rubric:: Erstellen einer neuen URI mit Zend\Uri\Uri::factory()

.. code-block:: php
   :linenos:

   // Um eine neue URI von Grund auf zu erstellen, übergebe nur das Schema
   $uri = Zend\Uri\Uri::factory('http');

   // $uri instanceof Zend\Uri\Http

Um eine neue *URI* von Grund auf zu erstellen, übergibt man nur das Schema an ``Zend\Uri\Uri::factory()`` [#]_. Wenn
ein nicht unterstütztes Schema übergeben, und keine Schema-spezifische Klasse angegeben wird, dann wird eine
``Zend\Uri\Exception`` ausgeworfen.

Wenn das Schema oder die übergebene *URI* unterstützt wird, gibt ``Zend\Uri\Uri::factory()`` eine Unterklasse von
sich selbst zurück, die auf das zu erstellende Schema spezialisiert ist.

Erstellen neuer eigener URI Klassen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beginnend mit Zend Framework 1.10.5 kann man eine eigene Klasse spezifizieren welche, wenn Sie als zweiter
Parameter der Methode ``Zend\Uri\Uri::factory()`` angegeben wird, verwendet wird wenn man eine Zend_Uri Instanz
erstellt. Das erlaubt es Zend_Uri zu erweitern und eigene URI Klassen zu erstellen, und neue URI Objekte zu
instanzieren basierend auf den eigenen Klassen.

Der zweite Parameter welcher an ``Zend\Uri\Uri::factory()`` übergeben wird muss ein String sein mit dem Namen der
Klasse welche ``Zend_Uri`` erweitert. Diese Klasse muss entweder bereits geladen sein, oder geladen werden können
indem ``Zend\Loader\Loader::loadClass()`` verwendet wird - deshalb muss es den Konventionen für Zend Framework Klassen
und Dateien folgen und muss im include_path sein.

.. _zend.uri.creation.custom.example-1:

.. rubric:: Erstellen eine URI durch Verwendung einer eigenen Klasse

.. code-block:: php
   :linenos:

   // Erstellt eine neue 'ftp' URI basierend auf einer eigenen Klasse
   $ftpUri = Zend\Uri\Uri::factory(
       'ftp://user@ftp.example.com/path/file',
       'MyLibrary_Uri_Ftp'
   );

   // $ftpUri ist eine Instanz von MyLibrary_Uri_Ftp, welche eine Unterklasse von Zend_Uri ist

.. _zend.uri.manipulation:

Verändern einer vorhandenen URI
-------------------------------

Um eine vorhandene *URI* zu verändern, übergibt man die komplette *URI* an ``Zend\Uri\Uri::factory()``.

.. _zend.uri.manipulation.example-1:

.. rubric:: Verändern einer vorhandenen URI mit Zend\Uri\Uri::factory()

.. code-block:: php
   :linenos:

   // Um eine vorhandene URI zu verändern, übergibt man diese
   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   // $uri instanceof Zend\Uri\Http

Die *URI* wird analysiert und validiert. Wenn sie als ungültig erkannt wird, wird sofort eine
``Zend\Uri\Exception`` geworfen. Andernfalls gibt ``Zend\Uri\Uri::factory()`` eine Unterklasse von sich selbst zurück,
die auf das zu verändernde Schema spezialisiert ist.

.. _zend.uri.validation:

URI Validierung
---------------

Die ``Zend\Uri\Uri::check()`` Methode kann verwendet werden, wenn nur das Validieren einer vorhandenen *URI* benötigt
wird.

.. _zend.uri.validation.example-1:

.. rubric:: URI Validierung mit Zend\Uri\Uri::check()

.. code-block:: php
   :linenos:

   // Überprüfe, ob eine übergebene URI wohlgeformt ist
   $valid = Zend\Uri\Uri::check('http://uri.in.question');

   // $valid ist TRUE für eine valide URI, andernfalls FALSE

``Zend\Uri\Uri::check()`` gibt einen Boolschen Wert zurück was bequemer ist als ``Zend\Uri\Uri::factory()`` zu verwenden
und die Exception zu fangen.

.. _zend.uri.validation.allowunwise:

"Unwise" Zeichen in URIs erlauben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig wird ``Zend_Uri`` die folgenden Zeichen nicht akzepzieren: **"{", "}", "|", "\", "^", "`"**. Diese
Zeichen sind durch die *RFC* als "unwise" definiert und deshalb ungültig; trotzdem, akzeptieren viele
Implementierungen diese Zeichen als gültig.

``Zend_Uri`` kann so eingestellt werden, dass es diese "unwise" Zeichen akzeptiert. Hierzu muss die Option
'allow_unwise' Option durch Verwendung von ``Zend\Uri\Uri::setConfig()`` auf ein boolsches ``TRUE`` gesetzt werden:

.. _zend.uri.validation.allowunwise.example-1:

.. rubric:: Spezielle Zeichen in URIs erlauben

.. code-block:: php
   :linenos:

   // Enthält das '|' Symbol
   // Normal würde das false zurückgeben:
   $valid = Zend\Uri\Uri::check('http://example.com/?q=this|that');

   // Trotzdem kann man diese "unwise" Zeichen erlauben
   Zend\Uri\Uri::setConfig(array('allow_unwise' => true));

   // Gibt 'true' zurück
   $valid = Zend\Uri\Uri::check('http://example.com/?q=this|that');

   // Setzt den Wert 'allow_unwise' auf das Standardmäßige FALSE zurück
   Zend\Uri\Uri::setConfig(array('allow_unwise' => false));

.. note::

   ``Zend\Uri\Uri::setConfig()`` setzt Konfigurationsoptionen global. Es wird, wie im obigen Beispiel, empfohlen die
   'allow_unwise' Option auf '``FALSE``' zurückzusetzen, solange man unwise Zeichen immer global erlauben will.

.. _zend.uri.instance-methods:

Allgemeine Instanzmethoden
--------------------------

Jede Instanz einer ``Zend_Uri`` Unterklasse (z.B. ``Zend\Uri\Http``) hat verschiedene Instanzmethoden, die für die
Verwendung mit jeglicher *URI* nützlich sind.

.. _zend.uri.instance-methods.getscheme:

Das Schema der URI erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Schema der *URI* ist der Teil der *URI* vor dem Doppelpunkt. Zum Beispiel ist 'http' das Schema von
``http://www.zend.com``.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Das Schema eines Zend\Uri\* Objektes erhalten

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

Die ``getScheme()`` Instanzmethode gibt nur das Schema des *URI* Objektes zurück.

.. _zend.uri.instance-methods.geturi:

Die komplette URI erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Die komplette URI eines Zend\Uri\* Objektes erhalten

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

Die ``getUri()`` Methode gibt den String zurück, der die komplette *URI* repräsentiert.

.. _zend.uri.instance-methods.valid:

Die URI validieren
^^^^^^^^^^^^^^^^^^

``Zend\Uri\Uri::factory()`` validiert immer jede übergebene *URI* und wird keine ``Zend_Uri`` Unterklasse
instanzieren, wenn die übergebene *URI* ungültig ist. Dennoch ist es nach der Instanzierung der ``Zend_Uri``
Unterklasse für eine neue oder eine bestehende *URI* möglich, dass die *URI* später ungültig wird, nachdem sie
verändert worden ist.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Ein Zend\Uri\* Object validieren

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

Die ``valid()`` Instanzmethode ermöglicht es, das *URI* Objekt auf Gültigkeit zu überprüfen.



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] Zum Zeitpunkt des Schreibens bietet ``Zend_Uri`` nur eingebaute Unterstützung für die Schemata *HTTP* und
       *HTTPS*