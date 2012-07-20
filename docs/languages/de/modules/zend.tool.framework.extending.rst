.. _zend.tool.framework.extending:

Extending and Configuring Zend_Tool_Framework
=============================================

.. _zend.tool.framework.console-client:

Anpassen des Zend_Tool Konsolen Clients
---------------------------------------

Mit Zend Framework 1.9 erlaubt es ``Zend_Tool_Framework`` Entwicklern Informationen zu Speichern, Provider
spezifische Konfigurationswerte, und eigene Dateien an einem speziellen Ort auf der Entwicklermaschine. Diese
Konfigurationswerte und Dateien können von Providern verwendet werden um Funktionalität zu erweitern, sie
anzupassen, oder aus einem anderen Grund welcher dem Provider passt.

Der primäre Zwecke, und der warscheinlich wichtigste der von existierenden Providern verwendet wird, besteht darin
es Entwicklern zu erlauben den Weg wie die "out of the box" Provider funktionieren zu verändern.

Eines der üblichsten angefragten Features ist es, in der Lage zu sein ``Zend_Tool_Project``'s Projekt Provider
eigene Projekt Profile anzubieten. Das würde es Entwicklern erlauben ein eigenes Profil an einem speziellen Platz
zu speichern, der wiederholt vom ``Zend_Tool`` System verwendet werden kann um eigene Profile zu erstellen. Ein
anderes üblicherweise angefragtes Feature ist es in der Lage zu sein das Verhalten von Providern mit
Konfigurationseinstellungen zu verändern. Um das zu tun benötigen wir nicht nur eine ``Zend_Tool``
Konfigurationsdatei, sondern auch einen Ort an dem wir diese Konfigurationsdatei finden können.

.. _zend.tool.framework.console-client.home-directory:

Das Home Verzeichnis
^^^^^^^^^^^^^^^^^^^^

Bevor der Konsolen Client beginnen kann nach einer ``Zend_Tool`` Konfigurationsdatei zu suchen, oder einem lokalen
Speicherverzeichnis, muß er zuerst in der Lage sein zu erkennen wo das "Home Verzeichnis" liegt.

Auf \*nix basierten Maschinen, wird *PHP* mit einer Umgebungsvariable die ``HOME`` heißt, und dem Pfad zum Home
Verzeichnis des aktuellen Benutzers, bekannt gegeben. Typischerweise ist dieser Pfad ähnlich wie
``/home/myusername``.

Auf Windows basierten Maschinen, wird *PHP* typischerweise mit einer Umgebungsvariable die ``HOMEPATH`` heißt, und
dem Pfad zum Home Verzeichnis des aktuellen Benutzers, bekannt gegeben. Das Verzeichnis kann normalerweise,
entweder unter ``C:\Documents and Settings\Username\``, oder bei Vista unter ``C:\Users\Username`` gefunden werden.

Wenn entweder das Home Verzeichnis nicht gefunden werden kann, oder man den Ort an dem der ``Zend_Tool_Framework``
Konsolen Client das Home Verzeichnis findet, ändern will kann man eine Umgebungsvariable die ``ZF_HOME`` heißt
angeben um zu spezifizieren wo das Home Verzeichnis gefunden werden kann.

.. _zend.tool.framework.console-client.local-storage:

Lokaler Speicher
^^^^^^^^^^^^^^^^

Sobald das Home Verzeichnis gefunden werden kann, kann ``Zend_Tool_Framework``'s Konsolen Client entweder das
lokale Speicher Verzeichnis automatisch erkennen, oder es kann Ihm mitgeteilt werden wo das lokale
Speicherverzeichnis erwartet wird.

Angenommen das Home Verzeichnis wurde gefunden (hier als ``$HOME`` bezeichnet), dann wird der Konsolen client nach
dem lokalen Speicherverzeichnis unter ``$HOME/.zf/`` nachsehen. Wenn es gefunden wird, dann wird das lokale
Speicherverzeichnis auf diesen Ort gesetzt.

Wenn das Verzeichnis nicht gefunden werden kann, oder der Entwickler den Ort überschreiben will, kann man das
durch Setzen einer Umgebungsvariable durchführen. Unabhängig davon ob ``$HOME`` vorher gesetzt wurde, kann der
Entwickler die Umgebungsvariable ``ZF_STORAGE_DIR`` anbieten.

Sobald der Pfad zu einem lokalen Speicherverzeichnis gefunden wurde, **muss** das Verzeichnis existieren damit es
an die ``Zend_Tool_Framework`` Runtime übergeben werden kann, da dieses für Sie nicht erstellt wird.

.. _zend.tool.framework.console-client.configuration-file:

Benutzer Konfiguration
^^^^^^^^^^^^^^^^^^^^^^

Wie beim lokalen Speicher kann ``Zend_Tool_Framework``'s Konsolen Client, sobald ein Home Verzeichnis gefunden
wurde, entweder versuchen den Pfad zu einer Konfigurationsdatei autoamtisch zu erkennen, oder es kann Ihm ganz
spezifisch gesagt werden wo die Konfigurationsdatei gefunden werden kann.

Angenommen das Home Verzeichnis wurde gefunden (hier als ``$HOME`` bezeichnet), dann wird der Konsolen Client
versuchen nach der Existenz einer Konfigurationsdatei zu sehen die in ``$HOME/.zf.ini`` liegt. Diese Datei wird,
wenn Sie gefunden wurde, als Konfigurationsdatei für ``Zend_Tool_Framework`` verwendet.

Wenn der Ort nicht existiert, aber das lokale Speicherverzeichnis, dann wird der Konsolen Client versuchen die
Konfigurationsdatei im lokalen Speicherverzeichnis zu finden. Angenommen das lokale Speicherverzeichnis existiert
in ``$LOCAL_STORAGE``, und eine Datei existiert als ``$LOCAL_STORAGE/zf.ini``, dann wird diese vom Konsolen Client
gefunden und als ``Zend_Tool_Framework`` Konfigurationsdatei verwendet.

Wenn die Datei nicht automatisch erkannt werden kann, oder der Entwickler den Ort der Konfigurationsdatei
spezifizieren will, kann er das durch Setzen einer Umgebungsvariable tun. Wenn die Umgebungsvariable
``ZF_CONFIG_FILE`` gesetzt ist, dann wird dieser Wert als Ort der Konfigurationsdatei verwendet die mit dem
Konsolen Client zu verwenden ist. ``ZF_CONFIG_FILE`` kann auf irgendeine *INI*, *XML* oder *PHP* Datei zeigen die
``Zend_Config`` lesen kann.

Wenn die Datei weder an der automatisch erkannten, noch an der angegebenen Position existiert, dann wird Sie nicht
verwendet da ``Zend_Tool_Framework`` nicht versucht diese Datei automatisch zu erstellen.

.. _zend.tool.framework.console-client.configuration-content:

Inhalt der Benutzer Konfigurationsdatei
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Konfigurationdatei sollte als ``Zend_Config`` Konfigurationdatei, im *INI* format, strukturiert sein und ohne
zusätzliche definierte Sektionen. Schlüssel des ersten Levels sollten vom Provider verwendet werden um nach einem
speziellen Wert zu suchen. Wenn der "Project" Provider zum Beispiel ein "profiles" Verzeichnis erwartet, dann
sollte typischerweise darunter verstanden werden das er im folgenden Schlüssel Wertpaar gesucht wird:

.. code-block:: php
   :linenos:

   project.profile = irgendein/pfad/zu/irgendeinem-verzeichnis

Der einzige reservierte *INI* Präfix ist der Wert "php". Der "php" Präfix für Werte ist reserviert um Namen und
Werte, von wärend der Laufzeit setzbaren *PHP* Werte, zu setzen, wie ``include_path`` oder ``error_reporting``. Um
``include_path`` oder ``error_reporting`` mit einem *INI* Wert zu überschreiben, würde ein Entwickler folgendes
setzen:

.. code-block:: php
   :linenos:

   php.include_path = "/path/to/includes1:/path/to/includes2"
   php.error_reporting = 1

.. important::

   Der reservierte Prefix "php" funktioniert nur mit *INI* Dateien. Man kann *PHP* *INI* Werte nicht in *PHP* oder
   *XML* Konfigurationen setzen.


