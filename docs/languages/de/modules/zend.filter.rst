.. EN-Revision: none
.. _zend.filter.introduction:

Einführung
==========

Die ``Zend_Filter`` Komponente bietet ein Set von normalerweise benötigen Datenfiltern. Sie bietet auch einen
einfachen Filterketten Mechanismus mit dem mehrere Filter bei einem einfachen Wert in einer benutzerdefinierten
Reihenfolge ausgeführt werden können.

.. _zend.filter.introduction.definition:

Was ist ein Filter?
-------------------

In der physikalischen Welt wird ein Filter typischerweise für das entfernen von unerwünschten Teilen einer
Eingabe verwendet, und der gewünschte Teil der Eingabe wird zur Ausgabe des Filters weitergeleitet (z.B. Kaffee).
In solchen Szenarien ist ein Filter ein Operator der ein Subset von der Eingabe produziert. Diese Art des Filterns
ist für Web Anwendungen nützlich - entfernen illegaler Eingaben, trimmen von unnötigen Leerzeichen, usw.

Diese Basisdefinition eines Filter kann erweitert werden um generelle Umwandlungen über eine Eingabe zu
beinhalten. Eine übliche Umwandlung die in Web Anwendungen durchgeführt wird, ist das auskommentieren von *HTML*
Entititäten. Zum Beispiel, wenn ein Formular Feld automatisch mit einer unsicheren Eingabe übergeben wird (z.B.
von einem Web Browser), sollte dieser Wert entweder frei von *HTML* Entititäten sein oder nur auskommentierte
*HTML* Entititäten enthalten, um unerwünschtes Verhalten und Sicherheitslöcher zu vermeiden. Um diesen
Anforderungen gerecht zu werden müssen *HTML* Entititäten die in der Eingabe vorkommen entweder entfernt oder
auskommentiert werden. Natürlich hängt es von der Situation ab welcher Weg mehr zutrifft. Ein Filter der *HTML*
Entititäten entfernt operiert innerhalb der Beschreibung der ersten Definition von Filter - ein Operator der ein
Subset von einer Eingabe produziert. Ein Filter der *HTML* Entititäten auskommentiert, wandelt die Eingabe um
(z.B. "&" wird umgewandelt in "&amp;"). Solche Fälle zu unterstützen ist für Web Entwickler sehr wichtig und "zu
filtern", im Kontext der Verwendung von ``Zend_Filter``, bedeutet einige Umwandlungen über Eingabedaten
durchzuführen.

.. _zend.filter.introduction.using:

Normale Verwendung von Filtern
------------------------------

Diese Filterdefinition bekanntgegeben zu haben bietet die Grundlage für ``Zend\Filter\Interface``, welches eine
einzelne Methode benötigt die ``filter()`` genannt wird, und von der Filterklasse implementiert werden muß.

Nachfolgend ist ein grundsätzliches Beispiel der Verwendung eines Filters über zwei Eingabedaten, einem
Und-Zeichen (**&**) und einem Hochkommazeichen (**"**):

.. code-block:: php
   :linenos:

   $htmlEntities = new Zend\Filter\HtmlEntities();

   echo $htmlEntities->filter('&'); // &
   echo $htmlEntities->filter('"'); // "

.. _zend.filter.introduction.static:

Verwenden der statischen staticFilter() Methode
-----------------------------------------------

Wenn es unbequem ist einen gegebene Filterklasse zu Laden und eine Instanz des Filters zu erstellen, kann die
statische ``Zend\Filter\Filter::staticFilter()`` Methode als alternativer Aufrufstil verwendet werden. Das erste Argument
dieser Methode ist der Eingabewert, der die ``filter()`` Methode passieren soll. Das zweite Argument ist ein
String, der dem Basisnamen der Filterklasse, relativ zum ``Zend_Filter`` Namensraum, entspricht. Die
``filterStatic()`` Methode lädt die Klasse automatisch, erstellt eine Instanz, und führt die Eingabedaten der
``filter()`` Methode zu.

.. code-block:: php
   :linenos:

   echo Zend\Filter\Filter::filterStatic('&', 'HtmlEntities');

Es kann auch ein Array von Konstruktor Argumenten übergeben werden, wen diese für die Filterklasse benötigt
werden.

.. code-block:: php
   :linenos:

   echo Zend\Filter\Filter::filterStatic('"',
                                  'HtmlEntities',
                                  array('quotestyle' => ENT_QUOTES));

Die statische Verwendung kann für das Ad-Hoc aufrufen von Filtern bequem sein, aber wenn man einen Filter über
mehrere Eingaben anwenden will ist es effizienter den ersten Beispiel von oben zu folgen, eine Instanz des Filter
Objekts zu erstellen und dessen ``filter()`` Methode aufzurufen.

Die ``Zend\Filter\Input`` Klasse erlaubt es also, mehrere Filter zu instanzieren und auszurufen, und wenn
benötigt, den Prüfklassen diese Sets von Eingabedaten zu verarbeiten. Siehe :ref:`Zend\Filter\Input
<zend.filter.input>`.

.. _zend.filter.introduction.static.namespaces:

Namespaces
^^^^^^^^^^

Wenn man mit selbst definierten Filtern arbeitet, dann kann man an ``Zend\Filter\Filter::filterStatic()`` einen vierten
Parameter übergeben welcher der Namespace ist, an dem der eigene Filter gefunden werden kann.

.. code-block:: php
   :linenos:

   echo Zend\Filter\Filter::filterStatic(
       '"',
       'MyFilter',
       array($parameters),
       array('FirstNamespace', 'SecondNamespace')
   );

``Zend_Filter`` erlaubt es auch standardmäßige Namespaces zu setzen. Das bedeutet das man Sie einmal in der
Bootstrap setzt und sie nicht mehr bei jedem Aufruf von ``Zend\Filter\Filter::filterStatic()`` angeben muß. Der folgende
Codeschnipsel ist identisch mit dem vorherigen.

.. code-block:: php
   :linenos:

   Zend\Filter\Filter::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   echo Zend\Filter\Filter::filterStatic('"', 'MyFilter', array($parameters));
   echo Zend\Filter\Filter::filterStatic('"', 'OtherFilter', array($parameters));

Der Bequemlichkeit halber gibt es die folgenden Methoden welche die Behandlung von Namespaces erlauben:

- **Zend\Filter\Filter::getDefaultNamespaces()**: Gibt alle standardmäßigen Namespaces als Array zurück.

- **Zend\Filter\Filter::setDefaultNamespaces()**: Setzt neue standardmäßige Namespaces und überschreibt alle vorher
  gesetzten. Es wird entweder ein String für einen einzelnen Namespace akzeptiert, oder ein Array für mehrere
  Namespaces.

- **Zend\Filter\Filter::addDefaultNamespaces()**: Fügt zusätzliche Namespaces zu den bereits gesetzten hinzu. Es wird
  entweder ein String für einen einzelnen Namespace akzeptiert, oder ein Array für mehrere Namespaces.

- **Zend\Filter\Filter::hasDefaultNamespaces()**: Gibt ``TRUE`` zurück wenn ein oder mehrere standardmäßige Namespaces
  gesetzt sind, und ``FALSE`` wenn keine standardmäßigen Namespaces gesetzt sind.

.. _zend.filter.introduction.caveats:

Doppelt filtern
---------------

Wenn zwei Filter nacheinander verwendet werden muss man bedenken dass es oft nicht möglich ist die originale
Ausgabe zu erhalten indem der gegensätzliche Filter verwendet wird. Nehmen wir das folgende Beispiel:

.. code-block:: php
   :linenos:

   $original = "my_original_content";

   // Einen Filter anwenden
   $filter   = new Zend\Filter_Word\UnderscoreToCamelCase();
   $filtered = $filter->filter($original);

   // Sein gegenstück verwenden
   $filter2  = new Zend\Filter_Word\CamelCaseToUnderscore();
   $filtered = $filter2->filter($filtered)

Das oben stehende Code Beispiel könnte zur Vermutung führen dass man die originale Ausgabe erhält nachdem der
zweite Filter angewendet wurde. Aber bei logischer Betrachtung ist dies nicht der Fall. Nachdem der erste Filter
angewendet wurde, wird **my_original_content** zu **MyOriginalContent** geändert. Aber nachdem der zweite Filter
angewendet wurde ist das Ergebnis **My_Original_Content**.

Wie man sieht ist es nicht immer möglich die originale Ausgabe zu erhalten indem ein Filter angewendet wird der
das Gegenteil zu sein scheint. Das hängt vom Filter und auch von der angegebenen Inhalt ab.


