.. EN-Revision: none
.. _performance.localization:

Internationalisierung (I18n) und Lokalisierung (L10n)
=====================================================

Internationalisierte und Lokalisierte Sites sind ein fantastischer Weg um seine Zuschaueranzahl zu expandieren und
sicherzustellen das alle Besucher die Information bekommen die Sie benötigen. Trotzdem kommt es oft zu einem
Geschwindigkeitsverlust. Anbei sind einige Strategien die man verwenden kann um den Overhead von I18n und L10n zu
verkleinern.

.. _performance.localization.translationadapter:

Welchen Übersetzungsadapter sollte ich verwenden?
-------------------------------------------------

Nicht alle Übersetzungadapter sind gleich gemacht. Einige haben mehr Feature als andere, und einige sind
performanter als andere. Zusätzlich kann es sein das man geschäftliche Notwendigkeiten hat die einen zwingen
einen bestimmten Adapter zu verwenden. Trotzdem, welcher Adapter ist der schnellste, wenn man die Wahl hat?

.. _performance.localization.translationadapter.fastest:

Verwende nicht-XML Übersetzungsadapter für die größte Geschwindigkeit
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework wird mit einer Vielzahl von Übersetzungsadaptern ausgeliefert. Die Hälfte von Ihnen verwenden ein
*XML* Format, welches viel Speicher benötigt und eine Geschwindkeitseinbuße bedeutet. Glücklicherweise gibt es
verschiedene Adapter die andere Formate verwenden, die viel schneller geparst werden können. In der Reihenfolge
Ihrer Geschwindigkeit, vom Schnellsten zum Langsamsten, sind das:

- **Array**: Das ist der Schnellste, weil er, von seiner Definition her, sofort in ein natives *PHP* Format geparst
  und sofort eingefügt wird.

- **CSV**: Verwendet ``fgetcsv()`` um eine *CSV* Datei zu parsen und transformiert es in ein natives *PHP* Format.

- **INI**: Verwendet ``parse_ini_file()`` um eine *INI* Datei zu lesen und Sie in ein natives *PHP* Format zu
  transformieren. Dieser und der *CSV* Adapter sind in Ihrer Geschwindigkeit ziemlich identisch.

- **Gettext**: Der Gettext Adapter von Zend Framework verwendet **nicht** die Gettext Erweiterung da diese nicht
  Threadsicher ist und es nicht erlaubt mehr als ein Gebietsschema pro Server zu definieren. Als Ergebnis, ist ist
  er langsamer als die Gettext Erweiterung direkt, aber, weil das Gettext Format binär ist, ist es schneller
  geparst als *XML*.

Wenn hohe Geschwindigkeit eine der eigenen Bedenken sind, empfehlen wir die Verwendung einer der obigen Adapter.

.. _performance.localization.cache:

Wie kann ich Übersetzungen und Lokalisierungen sogar noch schneller machen?
---------------------------------------------------------------------------

Aus Geschäftsgründen kann es möglich sein, das man auf einen *XML*-basierenden Übersetzungsadapter limitiert
ist. Oder vielleicht will man die Dinge sogar noch schneller machen. Oder vielleicht will man L10n Operationen
schneller machen. Wie kann man das tun?

.. _performance.localization.cache.usage:

Verwenden von Übersetzungs und Lokalisierungs Caches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beide, ``Zend_Translator`` und ``Zend_Locale`` implementieren eine Caching Funktionalität welche die
Geschwindigkeit großartig verbessern kann. In jedem der Fälle ist dass das Nadelöhr typischerweise das Lesen der
Dateien, nicht das effektive Nachschauen; die Verwendung eines Caches eliminiert die Notwendigkeit die
Übersetzungsdateien und/oder Lokalisierungsdateien zu lesen.

Man kann an den folgenden Orten mehr über das Cachen von Übersetzungs und Lokalisierungsstrings nachlesen:

- :ref:`Zend_Translator Adapter Caching <zend.translator.adapter.caching>`

- :ref:`Zend_Locale Caching <zend.locale.cache>`


