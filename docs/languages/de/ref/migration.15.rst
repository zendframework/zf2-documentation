.. EN-Revision: none
.. _migration.15:

Zend Framework 1.5
==================

Wenn man von einem älteren Release auf Zend Framework 1.5 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.15.zend.controller:

Zend_Controller
---------------

Obwohl die meisten grundsätzlichen Funktionalitäten die gleichen bleiben und alle dokumentierten
Funktionalitäten die gleichen bleiben gibt es doch ein spezielles **undokumentiertes**"Feature" das geändert
wurde.

Wenn *URL*\ s geschrieben werden besteht der dokumentierte Weg darin die Aktionsnamen camelCased mit einem
Trennzeichen zu schreiben; diese sind normalerweise '.' oder '-', können aber im Dispatcher konfiguriert werden.
Der Dispatcher ändert den Aktionsnamen intern auf Kleinschreibung und verwendet diese Trennzeichen um die
Aktionsmethode wieder zu bauen indem er sie camelCase schreibt. Trotzdem, weil *PHP* Funktionen nicht unabhängig
von der Schreibweise sind, **könnte** man *URL*\ s mit camelCase schreiben und der Dispatcher würde diese auf den
gleichen Platz auflösen. Zum Beispiel, 'camel-cased' würde durch den Dispatcher zu 'camelCasedAction' werden;
trotzdem, durch den Fall der unabhängigen Schreibweise in *PHP*, würden beide die selbe Methode ausführen.

Das führt zu Problemen mit dem ViewRenderer wenn View Skripte aufgelöst werden. Der kanonische, dokumentierte Weg
besteht darin das alle Trennzeichen zu Bindestrichen umgewandelt und die Wörter kleingeschrieben werden. Das
erzeugt eine semantische Bindung zwischen Aktionen und View Skripten, und die Normalisierung stellt sicher das die
Skripte gefunden werden. Trotzdem, wenn die Aktion 'camelCased' aufgerufen und aufgelöst wird, ist das
Trennzeichen nicht mehr vorhanden, und der ViewRenderer versucht einen anderen Ort aufzulösen
--``camelcased.phtml`` statt ``camel-cased.phtml``.

Einige Entwickler hängen an diesem "Feature", welches nie angedacht war. Verschiedene Änderungen im 1.5.0 Baum,
führen dazu das der ViewRenderer diese Pfade nicht länger auflöst; die semantische Bindung wird nun erzwungen.
Ale erstes, erzwingt der Dispatcher nun die Groß-/Kleinschreibung in Aktionsnamen. Das bedeutet dass das hinleiten
zu eigenen Aktionen über die URL durch Verwendung von camelCase nicht länger auf die gleiche Methode aufgelöst
wird wie mit Trennzeichen (z.B. 'camel-casing'). Das führt dazu das der ViewRenderer jetzt nur mehr
zeichen-getrennte Aktionen honoriert wenn er View Skripte auflöst.

Wenn man findet das man auf dieses "Feature" nicht verzichten kann gibt es mehrere Optionen:

- Beste Option: Die View Skripte umbenennen. Vorteile: zukünftige Kompatibilität. Nachteile: Wenn man viele View
  Skripte hat die auf dem vorigen aufbauen führt das, unerwarteter Weise, zu vielen Umbenennungen die
  durchgeführt werden müssen.

- Zweitbeste Option: Der ViewRenderer delegiert nun die Auflösung von View Skripten zu ``Zend_Filter_Inflector``;
  man kann die Regeln des Inflectors ändern damit er nicht länger die Wörter der Aktion mit einem Bindestrich
  trennt:

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
     $inflector = $viewRenderer->getInflector();
     $inflector->setFilterRule(':action', array(
         new Zend_Filter_PregReplace(
             '#[^a-z0-9' . preg_quote(DIRECTORY_SEPARATOR, '#') . ']+#i',
             ''
         ),
         'StringToLower'
     ));

  Der obige Code ändert den Inflector so, das er Wörter nicht länger mit einem Bindestrich trennt; Es kann auch
  gewünscht sein den 'StringToLower' Filter zu entfernen man die aktuellen View Skripte camelCased benannt haben
  **will**.

  Wenn die Umbenennung der View Skripte zu aufwendig oder Zeitintensiv ist, dann ist das die beste Option wenn man
  die Zeit hierfür findet.

- Die am wenigsten zu empfehlende Option: Man kann den Dispatcher dazu zwingen camelCase Aktionsnamen mit einem
  neuen Front Controller Flag ``useCaseSensitiveActions`` zu bearbeiten:

  .. code-block:: php
     :linenos:

     $front->setParam('useCaseSensitiveActions', true);

  Das erlaubt es camelCase in der URL zu verwenden uns es trotzdem auf die gleiche Aktion aufzulösen wie wenn
  Trennzeichen verwendet worden wären. Das bedeutet dass das Originale Problem trotzdem durchschlägt; es kann
  notwendig sein die zweite Option von oben zusätzlich zu verwenden um sicherzustellen das die Dinge in allen
  Variationen funktionieren.

  Man sollte auch beachten das die Verwendung dieses Flags eine Notiz auslöst, das dessen Verwendung nicht mehr
  durchgeführt werden sollte.


