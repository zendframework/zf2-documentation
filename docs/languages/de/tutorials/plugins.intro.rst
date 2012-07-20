.. _learning.plugins.intro:

Einführung
==========

Zend Framework verwendet sehr stark Plugin Architekturen. Plugins erlauben eine einfache Erweiterung und Anpassung
vom Framework wärend der eigene Code vom Zend Framework Code seperiert bleibt.

Typischerweise arbeiten Plugins im Zend Framework wie folgt:

- Plugins sind Klassen. Die aktuelle Klassendefinition ist unterschiedlich basierend auf der Komponente -- man muss
  eine abstrakte Klasse erweitern oder ein Interface implementieren, aber der Fakt bleibt bestehen dass das Plugin
  selbst eine Klasse ist.

- Zusammengehörende Plugins teilen sich einen gemeinsamen Klassenpräfix. Zum Beispiel wenn man eine Anzahl von
  View Helfern erstellt, könnten alle den Klassenpräfix "``Foo_View_Helper_``" teilen.

- Alles nach dem gemeinsamen Präfix wird als **Name des Plugins** oder **Kurzname** angenommen (gegenüber dem
  "langen Namen" welcher der komplette Klassenname ist). Wenn der Plugin Präfix zum Beispiel
  "``Foo_View_Helper_``" ist, und der Klassenname "``Foo_View_Helper_Bar``", dann wird der Name des Plugins einfach
  "``Bar``" sein.

- Namen von Plugins sind typischerweise abhängig von der Schreibweise. Ein Nachteil ist, das der initiale
  Buchstabe ost entweder klein- oder großgeschrieben ist; in unserem vorherigen Beispiel würden beide, sowohl
  "bat" als auch "Bar" auf das gleiche Plugin verweisen.

Jetzt sehen wir uns die Verwendung von Plugins an.


