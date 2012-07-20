.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

Einführung
----------

Diese Klasse repräsentiert einen einzelnen Abschnitte einer *MIME* Nachricht. Sie enthält den aktuellen Inhalt
des Abschnitts der Nachricht und zusätzlich Informationen über Ihre Verschlüsselung, den Typ und den originalen
Dateinamen. Sie stellt ausserdem eine Methode, für die Erzeugung eines Strings aus den in Ihr gespeicherten Daten,
zur Verfügung. ``Zend_Mime_Part`` Objekte können zu :ref:`Zend_Mime_Message <zend.mime.message>` hinzugefügt
werden, um zu einer kompletten mehrteiligen Nachricht verknüpft zu werden.

.. _zend.mime.part.instantiation:

Instanziierung
--------------

``Zend_Mime_Part`` wird instanziiert mit einem String welcher den Inhalt des neuen Abschnitts repräsentiert. Der
Typ wird angenommen mit OCTET-STREAM, die Verschlüsselung mit 8Bit. Nach der Instanziierung einer
``Zend_Mime_Part`` kann die Meta Informationen gesetzt werden durch direkten Zugriff auf die Attribute:

.. code-block:: php
   :linenos:

   public $type = Zend_Mime::TYPE_OCTETSTREAM;
   public $encoding = Zend_Mime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   public $boundary;
   public $location;
   public $language;

.. _zend.mime.part.methods:

Methoden für das übertragen der des Teils der Nachricht zu einem String
-----------------------------------------------------------------------

``getContent()`` gibt den verschlüsselten Inhalt des MimeParts als String zurück, wobei die Verschlüsselung
verwendet wird welche im Attribut $encoding definiert wurde. Gültige Werte sind Zend_Mime::ENCODING_* Zeichensatz
Konvertierungen werden nicht durchgeführt.

``getHeaders()`` gibt den Mime-Headers für den MimePart zurück, erzeugt anhand der Informationen der öffentlich
zugänglichen Attribute. Die Attribute des Objektes müssen korrekt gesetzt sein, bevor diese Methode aufgerufen
wird.



   - ``$charset`` muß auf den aktuellen Charset des Inhaltes gesetzt werden, wenn dieser ein Texttyp ist (Text
     oder *HTML*).

   - ``$id`` kann gesetzt werden für die Erkennung einer Content-ID für Inline Grafiken in einer *HTML*
     Nachricht.

   - ``$filename`` enthält den Namen welche die Datei bekommt wenn sie heruntergeladen wird.

   - ``$disposition`` definiert ob die Datei als Anhang behandelt werden soll, oder ob sie in einer (HTML-)
     Nachricht verwendet wird (Inline).

   - ``$description`` wird nur zur Zweck der Information verwendet.

   - ``$boundary`` definiert den String als umgebend.

   - ``$location`` kann als Ressource *URI* verwendet werden, der eine Relation zum Inhalt hat.

   - ``$language`` definiert die Sprache des Inhalts.




