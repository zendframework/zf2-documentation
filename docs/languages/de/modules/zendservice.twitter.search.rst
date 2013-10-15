.. EN-Revision: none
.. _zendservice.twitter.search:

ZendService\Twitter\Search
===========================

.. _zendservice.twitter.search.introduction:

Einführung
----------

``ZendService\Twitter\Search`` bietet einen Client für die `Such API von Twitter`_. Das Twitter Suchservice wird
verwendet um in Twitter zu suchen. Aktuell gibt es Daten nur im Atom oder *JSON* Format zurück, aber ein
komplettes *REST* Service kommt in Zukunft welche auch *XML* Antworten unterstützen wird.

.. _zendservice.twitter.search.trends:

Twitter Trends
--------------

Gibt die Top Zehn Abfragen zurück die aktuell bei Twitter Trend sind. Die Antwort enthält die Zeit der Abfragen,
den Namen jedes einzelnen Trendtopics, und auch die Url zur Twitter Suchseite für dieses Topic. Aktuell
unterstützt die Such *API* für Trends nur eine Rückgabe von *JSON* weswegen die Funktion ein Array zurückgibt.

.. code-block:: php
   :linenos:

   $twitterSearch = new ZendService\Twitter\Search();
   $twitterTrends = $twitterSearch->trends();

   foreach ($twitterTrends as $trend) {
       print $trend['name'] . ' - ' . $trend['url'] . PHP_EOL
   }

Das zurückgegebene Array enthält zwei Werte:

- *name* ist der Name des Trends.

- *url* ist die *URL* um die Tweets für diesen Trend zu sehen.

.. _zendservice.twitter.search.search:

Suchen in Twitter
-----------------

Die Verwendung der Suchmethode gibt Tweets zurück die einer speziellen Abfrage entsprechen. Es gibt eine Anzahl
von `Suchoperatoren`_ die für die Abfrage verwendet werden können.

Die Suchmethode akzeptiert sechs verschiedene optionale *URL* Parameter die als Array übergeben werden:

- *lang* begrenzt die Tweets auf eine angegebene Sprache. *lang* muß durch einen `ISO 639-1 Code`_ angegeben
  werden.

- *rpp* die Anzahl der Tweets die pro Seite zurückzugeben sind, bis zu einem Maximum von 100.

- *page* spezifiziert die Seitennummer die zurückzugeben ist, bis zu einem Maximum von etwa 1500 Ergebnissen
  (basierend auf RPP * Seite).

- *since_id* gibt Tweets mit den Status IDs zurück die größer als die angegebene ID sind.

- *show_user* spezifiziert ob ">user<:" am Anfang des Tweets hinzugefügt wird. Das ist nützlich für Leser die
  das Authorfeld in Atom nicht anzeigen. Der Standardwert ist "``FALSE``".

- *geocode*, gibt Tweets zurück bei denen Benutzer in einerm angegebenen Radius zum angegebenen Längen- und
  Breitengrad sind, wobei der Ort des Benutzers von seinem Twitter Profil genommen wird. Der Wert des Parameters
  wird durch "latitude,longitude,radius" spezifiziert, wobei die Einheiten des Radius entweder in "mi" (Meilen)
  oder "km" (Kilometer) spezifiziert werden müssen.

.. _zendservice.twitter.search.search.json:

.. rubric:: Suchbeispiel für JSON

Das folgende Codebeispiel gibt ein Array mit den Suchergebnissen zurück.

.. code-block:: php
   :linenos:

   $twitterSearch = new ZendService\Twitter\Search('json');
   $searchResults = $twitterSearch->search('zend', array('lang' => 'en'));

.. _zendservice.twitter.search.search.atom:

.. rubric:: Suchbeispiel für ATOM

Das folgende Codebeispiel gibt ein ``Zend\Feed\Atom`` Objekt zurück.

.. code-block:: php
   :linenos:

   $twitterSearch = new ZendService\Twitter\Search('atom');
   $searchResults = $twitterSearch->search('zend', array('lang' => 'en'));

.. _zendservice.twitter.search.accessors:

Zend-Spezifische Zugriffsmethoden
---------------------------------

Wärend die Such *API* von Twitter nur zwei Methoden spezifiziert, hat ``ZendService\Twitter\Search`` zusätzliche
Methoden die für das Empfangen und die Modifizierung von internen Eigenschaften verwendet werden können.

- ``getResponseType()`` und ``setResponseType()`` erlauben es den Antworttype der Suche zu empfangen und, zwischen
  *JSON* und Atom, zu verändern.



.. _`Such API von Twitter`: http://apiwiki.twitter.com/Search+API+Documentation
.. _`Suchoperatoren`: http://search.twitter.com/operators
.. _`ISO 639-1 Code`: http://en.wikipedia.org/wiki/ISO_639-1
