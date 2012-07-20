.. _zend.currency.options:

Optionen für Währungen
======================

Abhängig von der Notwendigkeit können verschiedene Optionen bei der Instanzierung spezifiziert werden. Jede
dieser Optionen hat Standardwerte. Aber manchmal ist es notwendig zu definieren wie die eigenen Währungen
dargestellt werden sollen. Das enthält zum Beispiel:

- **Währungssymbol, Kurzname oder Name**:

  ``Zend_Currency`` kennt alle Währungsnamen, Abkürzungen und Symbole. Aber manchmal besteht die Notwendigkeit
  den String, der als Ersatz für eine Währung angezeigt werden soll, selbst zu definieren.

- **Position der Währung**:

  Die Position des Währungssymbols ist automatisch definiert. Aber manchmal besteht die Notwendigkeit sie manuell
  zu definieren.

- **Schreibweise**:

  Man könnte die Schreibweise definieren die verwendet wird wenn Ziffern dargestellt werden. Detailierte
  Informationen über Schreibweisen und deren Verwendung können in ``Zend_Locale``'s Kapitel über
  :ref:`Konvertierung des Zahlensystems <zend.locale.numbersystems>` gefunden werden.

- **Formatieren von Nummern**:

  Der Wert der Währung (generell als Geldwert bekannt) wird durch die Verwendung der Formatierungsregeln
  definiert, welche durch das Gebietsschema selbst definiert wird. Zum Beispiel wird das ',' Zeichen im englischen
  als Separator für Tausender verwendet, aber im deutschen als Kommazeichen.

Die folgende Liste erwähnt alle Optionen die gesetzt werden können. Sie können entweder bei der Instanzierung
oder durch Verwendung der Methode ``setFormat()`` gesetzt werden. In jedem Fall müssen diese Optionen als Array
angegeben werden.

- **currency**: Definiert die Abkürzung welche angezeigt werden kann.

- **display**: Definiert welcher Teil der Währung für die Darstellung der Währungsrepräsenation verwendet
  werden soll. Es gibt 4 Repräsentationen welche verwendet werden können und alle sind in :ref:`dieser Tabelle
  <zend.currency.description>` beschrieben.

- **format**: Definiert das Format welches für die Anzeige von Nummern verwendet werden soll. Dieses Nummernformat
  enthält zum Beispiel den Tausender-Separator. Man kann entweder ein Standardformat verwenden in dem ein
  Identifikator für ein Gebietsschema angegeben wird, oder durch manuelles definieren des Nummernformats. Wenn
  kein Format gesetzt wird, dann wird das Gebietsschema vom ``Zend_Currency`` Objekt verwendet. Siehe :ref:`das
  Kapitel über Zahlenformatierung <zend.locale.number.localize.table-1>` für Details.

- **locale**: Definiert ein Gebietsschema für diese Währung. Es wird für die Erkennung der Standardwerte
  verwendet wenn andere Einstellungen unterdrückt werden. Es ist zu beachten dass das Gebietsschema automatisch
  erkannt wird, wenn man selbst kein Gebietsschema angibt. Das könnte zu Problemen führen.

- **name**: Definiert den kompletten Namen der Währung welcher angezeigt werden kann.

- **position**: Definiert die Position an welcher die Beschreibung der Währung angezeigt werden soll. Die
  unterstützten Positionen sind :ref:`in diesem Abschnitt <zend.currency.position>` beschrieben.

- **precision**: Definiert die Genauigkeit welche für die Darstellung der Währung verwendet werden soll. Der
  Standardwert hängt vom Gebietsschema ab und ist für die meisten Gebietsschemata **2**.

- **script**: Definiert welche Schreibweise für die Anzeige von Ziffern verwendet wird. Die Standardschreibweise
  der meisten Gebietsschemata ist **'Latn'**, welches die Ziffern 0 bis 9 enthält. Andere Schreibweisen wie 'Arab'
  (arabisch) verwenden andere Ziffern. Siehe auch :ref:`das Kapitel über Zahlensysteme
  <zend.locale.numbersystems>` für Details und vorhandene Optionen.

- **service**: Definiert das Umrechnungsservice welches verwendet wird wenn mit unterschiedlichen Währungen
  gerechnet wird.

- **symbol**: Definiert das Währungssymbol welches angezeigt werden kann.

- **value**: Definiert den Wert der Währung (Geldwert). Bei Verwendung dieser Option sollte man auch die Option
  ``service`` setzen.

Wie man sehen kann gibt es vieles das verändert werden kann. Trotzdem entsprechen, wie bereits erwähnt, die
Standardwerte dieser Einstellungen den offiziellen Standards der Währungsdarstellung für jedes Land.


