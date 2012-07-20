.. _zend.feed.importing:

Feeds importieren
=================

``Zend_Feed`` ermöglicht es Entwicklern, Feeds sehr einfach abzurufen. Wenn Du die *URI* eines Feeds kennst,
verwende einfach die ``Zend_Feed::import()`` Methode:

.. code-block:: php
   :linenos:

   $feed = Zend_Feed::import('http://feeds.example.com/feedName');

Du kannst ``Zend_Feed`` außerdem verwenden, um Inhalte eines Feeds aus einer Datei oder die Inhalte aus einem
*PHP* String Variable zu abzurufen.

.. code-block:: php
   :linenos:

   // Feeds von einer Textdatei importieren
   $feedFromFile = Zend_Feed::importFile('feed.xml');

   // Feeds von einer PHP String Variable importieren
   $feedFromPHP = Zend_Feed::importString($feedString);

In jedem der obigen Beispiele wird bei Erfolg abhängig vom Typ des Feeds ein Objekt einer Klasse zurück gegeben,
welche ``Zend_Feed_Abstract`` erweitert. Wird ein *RSS* Feed durch eine der obigen Importiermethoden abgerufen,
wird eine ``Zend_Feed_Rss`` Objekt zurückgegeben. Auf der anderen Seite wird beim Importieren eines Atom Feeds ein
``Zend_Feed_Atom`` Objekt zurückgegeben. Bei Fehlern, wie z.B. ein unlesbarer oder nicht wohlgeformter Feed,
werfen die Importiermethoden auch ein ``Zend_Feed_Exception`` Objekt.

.. _zend.feed.importing.custom:

Eigene Feeds
------------

``Zend_Feed`` ermöglicht es Entwicklern Ihre eigenen Feeds sehr einfach zu erstellen. Man muß nur ein Array
erstellen und es in ``Zend_Feed`` importieren, Dieses Array kann mit ``Zend_Feed::importArray()`` oder mit
``Zend_Feed::importBuilder()`` importiert werden. Im letzteren Fall wird das Array on the Fly durch eine eigene
Datenquelle berechnet die ``Zend_Feed_Builder_Interface`` implementiert.

.. _zend.feed.importing.custom.importarray:

Importieren eines eigenen Arrays
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Importieren eines Feeds von einem Array
   $atomFeedFromArray = Zend_Feed::importArray($array);

   // Die folgende Zeile ist identisch mit der obigen; standardmäßig
   // wird eine Zend_Feed_Atom Instanz zurückgegeben
   $atomFeedFromArray = Zend_Feed::importArray($array, 'atom');

   // Importieren eines RSS Feeds von einem Array
   $rssFeedFromArray = Zend_Feed::importArray($array, 'rss');

Das Format des Arrays muß dieser Struktur entsprechen:

.. code-block:: php
   :linenos:

   array(
       // benötigt
       'title' => 'Titel des Feeds',
       'link'  => 'Kanonische URL zu dem Feed',

       // optional
       'lastUpdate' => 'Zeitstempel des Update Datums',
       'published'  => 'Zeitstempel des Veröffentlichungs Datums',

       // benötigt
       'charset' => 'Zeichensatz der textuellen Daten',

       //optional
       'description' => 'Kurzbeschreibung des Feeds',
       'author'      => 'Author, Veröffentlicher des Feeds',
       'email'       => 'Email des Authors',

       // optional, ignoriert wenn Atom verwendet wird
       'webmaster' => 'Email Adresse der Person die für technische '
                   .  'Belange verantwortlich ist',

       //optional
       'copyright' => 'Copyright Notiz',
       'image'     => 'URL zu Bildern',
       'generator' => 'Ersteller',
       'language'  => 'Sprache in welcher der Feed geschrieben ist',

       // optional, ignoriert wenn Atom verwendet wird
       'ttl'    => 'Wie lange ein Feed gecached werden kann '
                .  'bevor er erneut werden muß',
       'rating' => 'Die PICS Rate dieses Kanals',

       // optional, ignoriert wenn Atom verwendet wird
       // eine Wolke die über Updates benachrichtigt wird
       'cloud' => array(
           // benötigt
           'domain' => 'Domain der Wolke, e.g. rpc.sys.com',

           // optional, Standard ist 80
           'port' => 'Port zu dem verbunden wird',

           // benötigt
           'path'              => 'Pfad der Wolke, e.g. /RPC2',
           'registerProcedure' => 'Prozedur die aufgerufen wird, '
                               .  'z.B. myCloud.rssPleaseNotify'
           'protocol'          => 'Protokoll das verwendet wird, z.B. '
                               .  'soap oder xml-rpc'
       ),

       // optional, ignoriert wenn Atom verwendet wird
       // Eine Texteingabebox die im Feed angezeigt werden kann
       'textInput' => array(
           // benötigt
           'title'       => 'Die Überschrift des Senden Buttons im '
                         .  'Texteingabefeld',
           'description' => 'Beschreibt das Texteingabefeld',
           'name'        => 'Der Name des Text Objekts im '
                         .  'Texteingabefeld',
           'link'        => 'Die URL des CGI Skripts das Texteingabe '
                         .  'Anfragen bearbeitet'
       ),

       // optional, ignoriert wenn Atom verwendet wird
       // Hinweise geben welche Stunden übersprungen werden können
       'skipHours'   => array(
           // bis zu 24 Zeilen dessen Werte eine Nummer zwischen 0 und 23 ist
           // z.B. 13 (1pm)
           'hour in 24 format'
       ),

       // optional, ignoriert wenn Atom verwendet wird
       // Hinweise geben welche Tage übersprungen werden können
       'skipDays '   => array(
           // bis zu 7 Zeilen dessen Werte Montag, Dienstag, Mittwoch,
           // Donnerstag, Freitag, Samstag oder Sonntag sind
           // z.B. Montag
           'a day to skip'
       ),

       // optional, ignoriert wenn Atom verwendet wird
       // Itunes Erweiterungsdaten
       'itunes' => array(
           // optional, Standard ist der Wert der author Spalte
           'author' => 'Musiker Spalte',

           // optional, Standard ist der Wert der author Spalte
           // Eigentümer des Podcasts
           'owner' => array(
               'name'  => 'Name des Eigentümers',
               'email' => 'Email des Eigentümers'
           ),

           // optional, Standard ist der image Wert
           'image' => 'Album/Podcast Bild',

           // optional, Standard ist der description Wert
           'subtitle' => 'Kurzbeschreibung',
           'summary'  => 'Langbeschreibung',

           // optional
           'block' => 'Verhindern das eine Episode erscheint (ja|nein)',

           // benötigt
           // 'Kategoriespalte und iTunes Music Store Browse'
           'category' => array(
               // bis zu 3 Zeilen
               array(
                   // benötigt
                   'main' => 'Hauptkategorie',

                   // optional
                   'sub'  => 'Unterkategorie'
               ),
           ),

           // optional
           'explicit'     => 'Elterliche Anweisungsspalte (ja|nein|löschen)',
           'keywords'     => 'Eine kommagetrennte Liste von maximal '
                          .  '12 Schlüsselwörtern',
           'new-feed-url' => 'Verwendet um iTunes über eine neue URL '
                          .  'Lokation zu informieren'
       ),

       'entries' => array(
           array(
               // benötigt
               'title' => 'Titel des Feedeintrags',
               'link'  => 'URL zum Feedeintrag',

               // benötigt, nur Text, kein HTML
               'description'  => 'Kurzversion des Feedeintrags',

               //optional
               'guid' => 'Id des Artikels, wenn nicht angegeben '
                      .  'wird der link Wert verwendet',

               // optional, kann HTML enthalten
               'content' => 'Langversion',

               // optional
               'lastUpdate' => 'Zeitstempel des Veröffnetlichungsdatums',
               'comments'   => 'Kommentarseite des Feedeintrags',
               'commentRss' => 'Die FeedURL der zugehörenden Kommentare',

               // optional, Originale Quelle des Feedeintrags
               'source' => array(
                   // benötigt
                   'title' => 'Titel der Originalen Quelle',
                   'url'   => 'URL der originalen Quelle'
               ),

               // optional, Liste der zugeordneten Kategorien
               'category' => array(
                   array(
                       // benötigt
                       'term' => 'Überschrift der ersten Kategorie',

                       // optional
                       'scheme' => 'URL die das Kategorisierungsschema '
                                .  'identifiziert'
                   ),

                   array(
                       //Daten der zweiten Kategorie und so weiter
                   )
               ),

               // optional, Liste der Anhänge des Feedeintrags
               'enclosure' => array(
                   array(
                       // benötigt
                       'url' => 'URL des verlinkten Anhangs',

                       // optional
                       'type'   => 'Mime Typ des Anhangs',
                       'length' => 'Länge des verlinkten Inhalts oktal'
                   ),

                   array(
                       // Daten für den zweiten Anhang und so weiter
                   )
               )
           ),

           array(
               // Daten für den zweiten Eintrag und so weiter
           )
       )
   );

Referenzen:

- *RSS* 2.0 Spezifikation: `RSS 2.0`_

- Atom Spezifikation: `RFC 4287`_

- *WFW* Spezifikation: `Gut geformtes Web`_

- iTunes Spezifikation: `iTunes Technische Spezifikation`_

.. _zend.feed.importing.custom.importbuilder:

Importieren einer eigenen Daten Quelle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eine ``Zend_Feed`` Instanz kann von jeder Datenquelle erstellt werden die ``Zend_Feed_Builder_Interface``
implementiert. Die ``getHeader()`` und ``getEntries()`` Methoden müssen implementiert werden damit das Objekt mit
``Zend_Feed::importBuilder()`` verwendet werden kann. Als einfache Referenz Implementation kann
``Zend_Feed_Builder`` verwendet werden, welches ein Array im Contructor entgegen nimmt, einige einfache Prüfungen
durchführt, und anschließend in der ``importBuilder()`` Methode verwendet werden kann. Die ``getHeader()``
Methode muß eine Instanz von ``Zend_Feed_Builder_Header`` zurückgeben, und ``getEntries()`` muß ein Array von
``Zend_Feed_Builder_Entry`` Instanzen zurückgeben.

.. note::

   ``Zend_Feed_Builder`` arbeitet als konkrete Implementation um die Verwendung zu demonstrieren. Benutzer sind
   angehlaten Ihre eigenen Klassen zu Erstellen um ``Zend_Feed_Builder_Interface`` zu implementieren.

Hier ist ein Beispiel der Verwendung von ``Zend_Feed::importBuilder()``:

.. code-block:: php
   :linenos:

   // Einen Feed von einer eigenen Erstellungsquelle importieren
   $atomFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array));

   // Die folgende Zeile ist mit der obigen äquivalent; standardmäßig
   // wird eine Zend_Feed_Atom Instanz zurückgegeben
   $atomFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array), 'atom');

   // Einen RSS Feeed von einem Array von eigenen Erstellungsquellen importieren
   $rssFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

Ausgeben des Inhalts eines Feeds
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um den Inhalt einer ``Zend_Feed_Abstract`` Instanz auszugeben können die ``send()`` oder ``saveXml()`` Methoden
verwendet werden.

.. code-block:: php
   :linenos:

   assert($feed instanceof Zend_Feed_Abstract);

   // Den Feed an der Standardausgabe ausgeben
   print $feed->saveXML();

   // HTTP Header und den Feed ausgeben
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Gut geformtes Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technische Spezifikation`: http://www.apple.com/itunes/store/podcaststechspecs.html
