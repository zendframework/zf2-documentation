.. _learning.autoloading.intro:

Einführung
==========

Autoloading ist ein Mechanismus welcher die Notwendigkeit den Aufrufs von "require" im eigenen *PHP* Code
eliminiert. Laut `dem PHP Manual für Autoload`_ wird ein Autoloader, sobald er definiert wurde, "automatisch
aufgerufen im Fall das versucht wird auf eine Klasse oder ein Interface zuzugreifen welche bis zu diesem Zeitpunkt
noch nicht definiert wurde.

Bei Verwendung eines Autoloaders muss man sich keine Gedanken darüber machen **wo** eine Klasse im eigenen Projekt
existiert. Mit gut-definierten Autoloadern muss man sich keine Gedanken darüber machen wo eine Klassendatei
relativ zu einer aktuellen Klassendatei ist; man verwendet einfach die Klasse, und der Autoloader führt eine
Dateisuche durch.

Zusätzlich, weil Autoloading dazu führt das man im letzten möglichen Moment lädt und sicherstellt das ein Match
nur einmal stattfindet, kann eine große Steigerung der Geschwindigkeit stattfinden -- speziell wenn man sich die
Zeit nimmt die Aufrufe zu ``require_once()`` zu entfernen bevor man den Livebetrieb aufnimmt.

Zend Framework empfiehlt die Verwendung von Autoloaden, und bietet verschiedene Tools um das Autoloading für beide
zu unterstützen, sowohl Bibliothekscode als auch Anwendungscode. Das Tutorial zeigt diese Tools und auch wie man
Sie effektiv verwendet.



.. _`dem PHP Manual für Autoload`: http://php.net/autoload
