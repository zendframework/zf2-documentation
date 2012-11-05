.. EN-Revision: none
.. _zend.config.writer.introduction:

Zend\Config\Writer
==================

``Zend\Config\Writer`` gibt einem die Möglichkeit Configdateien aus ``Zend_Config`` Objekten heraus zu schreiben.
Es arbeitet mit einem Adapter-artigen System und ist deswegen sehr einfach zu verwenden. Standardmäßig wird
``Zend\Config\Writer`` mit drei Adaptern ausgeliefert, die alle Datei basierend sind. Der Writer wird mit
speziellen Optionen instanziert, welche **filename** und **config** sein können. Dann wird die ``write()`` Methode
des Writers aufgerufen und die Configdatei wird erstellt. Man kann ``$filename`` und ``$config`` auch direkt an die
``write()`` Methode übergeben. Aktuell werden die folgenden Writer mit ``Zend\Config\Writer`` ausgeliefert:

- ``Zend\Config_Writer\Array``

- ``Zend\Config_Writer\Ini``

- ``Zend\Config_Writer\Xml``

Der *INI* Writer hat zwei Modi für die Darstellung bezüglich Sektionen. Standardmäßig wird die Top-Level
Konfiguration immer in Sektionsnamen geschrieben. Durch den Aufruf von ``$writer->setRenderWithoutSections();``
werden alle Optionen in den globalen Namespace der *INI* Datei geschrieben und es werden keine Sektionen
angehängt.

Zusätzlich hat ``Zend\Config_Writer\Ini`` einen zusätzlichen optionalen Parameter **nestSeparator**, welche
definiert mit welchem Zeichen die einzelnen Nodes getrennt werden. Der Standard ist ein einzelner Punkt, wie er
standardmäßig von ``Zend\Config\Ini`` akzeptiert wird.

Wenn ein ``Zend_Config`` Objekt geändert oder erstellt wird, muß man einige Dinge wissen. Um einen Wert zu
erstellen oder zu ändern muß einfach der Parameter des ``Zend_Config`` Objektes über den Zugriffsaccessor
(**->**) gesetzt werden. Um eine Sektion im Root oder im Branch zu erstellen muß einfach ein neues Aray erstellt
werden ("``$config->branch = array();``"). Um zu definieren welche Sektion eine andere erweitert, muß die
``setExtend()`` Methode am Root ``Zend_Config`` Objekt aufgerufen werden.

.. _zend.config.writer.example.using:

.. rubric:: Verwenden von Zend\Config\Writer

Dieses Beispiel zeigt die grundsätzliche Verwendung von ``Zend\Config_Writer\Xml`` um eine neue
Konfigurationsdatei zu erstellen:

.. code-block:: php
   :linenos:

   // Ein neues Config Objekt erstellen
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();
   $config->staging    = array();

   $config->setExtend('staging', 'production');

   $config->production->db = array();
   $config->production->db->hostname = 'localhost';
   $config->production->db->username = 'production';

   $config->staging->db = array();
   $config->staging->db->username = 'staging';

   // Die Config Datei auf einem der folgenden Wege schreiben:
   // a)
   $writer = new Zend\Config_Writer\Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // b)
   $writer = new Zend\Config_Writer\Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // c)
   $writer = new Zend\Config_Writer\Xml();
   $writer->write('config.xml', $config);

Das erstellt eine *XML* Config Datei mit den Sektionen production und staging, wobei staging production erweitert.

.. _zend.config.writer.modifying:

.. rubric:: Eine bestehende Config ändern

Dieses Beispiel zeigt wie eine bestehende Config Datei bearbeitet werden kann.

.. code-block:: php
   :linenos:

   // Lädt alle Sektionen einer bestehenden Config Datei, und überspringt
   // alle Erweiterungen
   $config = new Zend\Config\Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // Ändere einen Wert
   $config->production->hostname = 'foobar';

   // Schreibe die Config Datei
   $writer = new Zend\Config_Writer\Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **Laden einer Config Datei**

   Beim Laden einer bestehenden Config Datei für eine Änderung ist es sehr wichtig das alle Sektionen geladen
   werden und die Erweiterungen übersprungen werden, sodas keine Werte zusammengefügt werden. Das wird durch die
   Übergabe von **skipExtends** als Option an den Constructor durchgeführt.

Für alle Datei-basierenden Writer (*INI*, *XML* und *PHP* Array) wird intern ``render()`` verwendet um den
Konfigurationsstring zu erstellen. Diese Methode kann auch von ausserhalb aus verwendet werden wenn man Zugriff auf
eine String-Repräsentation der Konfigurationsdaten benötigt.


