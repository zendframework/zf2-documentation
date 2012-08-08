.. EN-Revision: none
.. _zend.captcha.adapters:

CAPTCHA Adapter
===============

Die folgenden Adapter werden mit dem Zend Framework standardmäßig ausgeliefert.

.. _zend.captcha.adapters.word:

Zend_Captcha_Word
-----------------

``Zend_Captcha_Word`` ist ein abstrakter Adapter der als Basisklasse für die meisten anderen *CAPTCHA* Adapter
fungiert. Er bietet Mutatoren für die Spezifizierung der Wortlänge, Session *TTL*, das Session Namespaceobjekt
das verwendet werden soll, und die Session Namespaceklasse die für die Persistenz zu verwenden ist wenn man
``Zend_Session_Namespace`` nicht verwenden will. ``Zend_Captcha_Word`` kapselt die Prüflogik.

Standardmäßig ist die Wortlänge 8 Zeichen, das Sessiontimeout 5 Minuten und für die Persistenz wird
``Zend_Session_Namespace`` verwendet (wobei der Namespace "``Zend_Form_Captcha_<captcha ID>``" verwendet wird).

Zusätzlich zu den Methoden wie vom ``Zend_Captcha_Adapter`` Interface benötigt werden bietet
``Zend_Captcha_Word`` die folgenden Methoden an:

- ``setWordLen($length)`` und ``getWordLen()`` erlauben es die Länge des erzeugten "Wortes" in Zeichen zu
  spezifizieren, und den aktuellen Wert zu erhalten.

- ``setTimeout($ttl)`` und ``getTimeout()`` erlauben es die Lebenszeit des Sessiontokens zu spezifizieren, und den
  aktuellen Wert er erhalten. ``$ttl`` sollte in Sekunden spezifiziert sein.

- ``setUseNumbers($numbers)`` und ``getUseNumbers()`` erlauben es zu spezifizieren ob Nummern als mögliche Zeichen
  für den Zufall funktionieren oder ob nur Zeichen verwendet werden.

- ``setSessionClass($class)`` und ``getSessionClass()`` erlauben es eine alternative ``Zend_Session_Namespace``
  Implementation zu spezifizieren die verwendet werden soll um das *CAPTCHA* Token persistent zu machen und den
  aktuellen Wert zu bekommen.

- ``getId()`` erlaubt es den aktuellen Tokenidentifikator zu erhalten.

- ``getWord()`` erlaubt es das erzeugte Wort das mit dem *CAPTCHA* verwendet wird zu erhalten. Es wird das Wort
  erzeugen wenn es bis dahin noch nicht erstellt wurde.

- ``setSession(Zend_Session_Namespace $session)`` erlaubt es ein Sessionobjekt zu spezifizieren das für die
  Persistenz des *CAPTCHA* Tokens verwendet wird. ``getSession()`` erlaubt es das aktuelle Sessionobjekt zu
  erhalten.

Alle Wort *CAPTCHA*\ s erlauben es ein Array von Optionen an den Konstruktor zu übergeben, oder alternativ dieses
an ``setOptions()`` zu übergeben. Man kann auch ein ``Zend_Config`` Objekt an ``setConfig()`` zu übergeben.
Standardmäßig können die **wordLen**, **timeout**, und **sessionClass** Schlüssel alle verwendet werden. Jede
konkrete Implementation kann zusätzliche Schlüssel definieren oder die Optionen auf einem anderen Weg verwenden.

.. note::

   ``Zend_Captcha_Word`` ist eine abstrakte Klasse und kann nicht direkt instanziiert werden.

.. _zend.captcha.adapters.dumb:

Zend_Captcha_Dumb
-----------------

Der ``Zend_Captcha_Dumb`` Adapter ist fast selbsterklärend. Er bietet einen zufälligen String der in umgekehrter
Reihenfolge eingegeben werden muß um validiert zu werden. Als solches ist es keine gute *CAPTCHA* Lösung, und
sollte nur für Testzwecke verwendet werden. Er erweitert ``Zend_Captcha_Word``.

.. _zend.captcha.adapters.figlet:

Zend_Captcha_Figlet
-------------------

Der ``Zend_Captcha_Figlet`` Adapter verwendet :ref:`Zend_Text_Figlet <zend.text.figlet>` um dem Benutzer ein Figlet
zu präsentieren.

Optionen die an den Konstruktor übergeben werden, werden auch an das :ref:`Zend_Text_Figlet <zend.text.figlet>`
Objekt übergeben. Schaue in die :ref:`Zend_Text_Figlet <zend.text.figlet>` Dokumentation für Details darüber
welche Konfigurationsoptionen vorhanden sind.

.. _zend.captcha.adapters.image:

Zend_Captcha_Image
------------------

Der ``Zend_Captcha_Image`` Adapter nimmt das erzeugte Wort und stellt es als Bild dar, führt diverse
Verzerrungs-Permutationen durch und mach es so schwierig es automatisch zu entschlüsseln. Er benötigt die `GD
Erweiterung`_ kompiliert mit TrueType oder Freetype Unterstützung. Aktuell kann der ``Zend_Captcha_Image`` Adapter
nur *PNG* Bilder erzeugen.

``Zend_Captcha_Image`` erweitert ``Zend_Captcha_Word``, und bietet zusätzlich die folgenden Methoden:

- ``setExpiration($expiration)`` und ``getExpiration()`` erlauben es eine maximale Lebenszeit zu definieren die das
  *CAPTCHA* Bild auf dem Dateisystem bleibt. Das ist typischerweise längerer als die Session Lifetime. Die Garbage
  Collection läuft periodisch jedes Mal wenn das *CAPTCHA* Objekt enthalten ist, und löscht die Bilder die
  abgelaufen sind. Der Wert der Löschung sollte in Sekunden angegeben werden.

- ``setGcFreq($gcFreq)`` und ``getGcFreg()`` erlauben es zu Spezifizieren wie oft die Garbage Collection laufen
  soll. Die Garbage Collection wird alle ``1/$gcFreq`` Aufrufe ausgeführt. Standard ist 100.

- ``setFont($font)`` und ``getFont()`` erlauben es die Schrift zu Spezifizieren die man verwenden will. ``$font``
  sollte ein voll qualifizierter Pfad zu der Schriftart-Datei sein. Dieser Wert wird benötigt; das *CAPTCHA* wird
  wärend der Erzeugung eine Ausnahme werfen wenn die Schriftdatei nicht spezifiziert wurde.

- ``setFontSize($fsize)`` und ``getFontSize()`` erlauben es die Schriftgröße in Pixel zu Spezifizieren die
  verwendet wird wenn das *CAPTCHA* erzeugt wird. Der Standardwert ist 24px.

- ``setHeight($height)`` und ``getHeight()`` erlauben es die Höhe in Pixel zu Spezifizieren die das erzeugte
  *CAPTCHA* Bild haben soll. Der Standardwert ist 50px.

- ``setWidth($width)`` und ``getWidth()`` erlauben es die Breite in Pixel zu Spezifizieren die das erzeugte
  *CAPTCHA* Bild haben soll. Der Standardwert ist 200px.

- ``setImgDir($imgDir)`` und ``getImgDir()`` erlauben es das Verzeichnis für das Speicher der *CAPTCHA* Bilder zu
  spezifizieren. Der Standardwert ist "``./images/captcha/``", was relativ zum Bootstrapskript zu sehen ist.

- ``setImgUrl($imgUrl)`` und ``getImgUrl()`` erlauben es den Relativen Pfad zum *CAPTCHA* Bild für die Verwendung
  im *HTML* Markup zu spezifizieren. Der Standardwert ist "``/images/captcha/``".

- ``setSuffix($suffix)`` und ``getSuffix()`` erlauben es die Endung des Dateinamens für das *CAPTCHA* Bild zu
  spezifizieren. Der Standardwert ist "``.png``". Beachte: Das Ändern dieses Wertes wird den Typ des erzeugten
  Bildes nicht ändern.

- ``setDotNoiseLevel($level)`` und ``getDotNoiseLevel()`` erlauben es zusammen mit ``setLineNoiseLevel($level)``
  und ``getLineNoiseLevel()`` zu kontrollieren wieviel "Rauschen" in der Form von zufälligen Punkten und Linien im
  Bild enthalten sein sollen. Jede Einheit von ``$level`` erzeugt einen zufälligen Punkt oder eine Linie. Der
  Standard ist 100 Punkte und 5 Linien. Das Rauschen wird zweimal hinzugefügt - vor und nach der Umwandlung der
  Verzerrung des Bildes.

Alle der obigen Optionen können an den Konstruktor übergeben werden indem einfach der Präfix der 'set' Methode
entfernt wird und der Anfangsbuchstabe kleingeschrieben wird: "suffix", "height", "imgUrl", usw.

.. _zend.captcha.adapters.recaptcha:

Zend_Captcha_ReCaptcha
----------------------

Der ``Zend_Captcha_ReCaptcha`` Adapter verwendet :ref:`Zend_Service_ReCaptcha <zend.service.recaptcha>` um
*CAPTCHA*\ s zu erzeugen und zu prüfen. Es bietet die folgenden Methoden an:

- ``setPrivKey($key)`` und ``getPrivKey()`` erlauben es den privaten Schlüssel zu spezifizieren der für den
  ReCaptcha Service verwendet werden soll. Er muß wärend der Erstellung spezifiziert werden, auch wenn er
  jederzeit überschrieben werden kann.

- ``setPubKey($key)`` und ``getPubKey()`` erlauben es den öffentlichen Schlüssel zu spezifizieren der mit dem
  ReCaptcha Service verwendet werden soll. Er muß wärend der Erstellung spezifiziert werden, auch wenn er
  jederzeit überschrieben werden kann.

- ``setService(Zend_Service_ReCaptcha $service)`` und ``getService()`` erlauben es das ReCaptcha Serviceobjekt zu
  setzen und erhalten.



.. _`GD Erweiterung`: http://php.net/gd
