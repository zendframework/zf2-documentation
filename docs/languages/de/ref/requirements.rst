.. _requirements:

******************************
Zend Framework Voraussetzungen
******************************

.. _requirements.introduction:

Einführung
----------

Zend Framework benötigt einen *PHP* 5 Interpreter mit einem Web Server der konfiguriert ist *PHP* Skripte korrekt
handzuhaben. Einige Features benötigen zusätzliche Erweiterungen oder Features des Web Servers; in den meisten
Fällen kann der Framewrok ohne diese verwendet werden, was aber zu geringerer Performance führen kann, oder dazu
das bestimmte Features nicht vollständig funktionieren. Ein Beispiel solch einer Abhängigkeit ist mod_rewrite in
einer Apache Umgebung, welches verwendet werden kann um "hübsche *URL*'s" wie
"``http://www.example.com/user/edit``" zu implementieren. Wenn mod_rewrite nicht aktiviert ist, kann Zend Framework
konfiguriert werden um *URL*'s wie "``http://www.example.com?controller=user&action=edit``" zu unterstützen.
Hübsche *URL*'s können verwendet werden um *URL*'s zu verkleinern, für textuelle Darstellung oder die
Optimierung von Suchmaschinen (*SEO*), aber sie beeinflussen die Funktionalität der Anwendung nicht direkt.

.. _requirements.version:

PHP Version
^^^^^^^^^^^

Zend empfiehlt das aktuellste Release von *PHP* wegen kritischer Sicherheits und Performance Verbesserungen, und
unterstützt aktuell *PHP* 5.2.4 oder höher.

Zend Framework hat eine sehr umfangreiche Sammlung von automatisierten Tests, welche mit PHPUnit 3.3.0 oder einer
späteren Version, ausgeführt werden können.

.. _requirements.extensions:

PHP Erweiterungen
^^^^^^^^^^^^^^^^^

Anbei finden Sie eine Tabelle die alle Erweiterungen auflistet die typischerweise in *PHP* gefunden werden können
und wie Sie im Zend Framework verwendet werden. Sie sollten prüfen die Erweiterungen welche die Zend Framework
Komponenten die Sie in Ihrer Anwendung verwenden werden in Ihrer *PHP* Umgebung vorhanden sind. Viele Anwendungen
benötigen nicht jede der Erweiterungen die anbei gelistet sind.

Eine Abhängigkeit des Typs "hard" zeigt das die Komponente oder Klasse nicht richtig funktioniert wenn die
entsprechende Erweiterung nicht vorhanden ist, wärend eine Abhängigkeit des Typs "soft" anzeigt das die
Komponente die Erweiterung verwenden kann wenn Sie vorhanden ist, aber auch ohne Sie korrekt funktionieren wird.
Viele Komponenten verwenden bestimmte Erweiterungen wenn Sie vorhanden sind um die Performance zu optimieren werden
aber Code mit ähnlicher Funktionalität in der Komponente selbst ausführen wenn die Erweiterung nicht vorhanden
ist.

.. include:: requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Zend Framework Komponenten
^^^^^^^^^^^^^^^^^^^^^^^^^^

Anbei ist eine Tabelle die alle vorhandenen Zend Framework Komponenten auflistet und welche *PHP* Erweiterungen
diese benötigen. Das kann helfen um herauszufinden welche Erweiterung in der eigenen Anwendung benötigt wird.
Nicht alle Erweiterungen welche vom Zend Framework verwendet werden sind für jede Anwendung notwendig.

Eine Abhängigkeit des Typs "hard" zeigt das die Komponente oder Klasse nicht richtig funktioniert wenn die
entsprechende Erweiterung nicht vorhanden ist, wärend eine Abhängigkeit des Typs "soft" anzeigt das die
Komponente die Erweiterung verwenden kann wenn Sie vorhanden ist, aber auch ohne Sie korrekt funktionieren wird.
Viele Komponenten verwenden bestimmte Erweiterungen wenn Sie vorhanden sind um die Performance zu optimieren werden
aber Code mit ähnlicher Funktionalität in der Komponente selbst ausführen wenn die Erweiterung nicht vorhanden
ist.

.. include:: requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Zend Framework Abhängigkeiten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Anbei kann eine Tabelle gefunden werden in der die Zend Framework Komponenten aufgelistet sind und deren
Abhängigkeit zu anderen Zend Framework Komponenten. Das kann helfen wenn man nur einzelne Komponenten verwenden
will statt den kompletten Zend Framework.

Eine Abhängigkeit vom Typ "hard" zeigt das die Komponente oder Klasse nicht richtig funktionieren kann wenn die
entsprechende Komponente nicht vorhanden ist, wärend eine Abhängigkeit vom Typ "soft" anzeigt das die Komponente
in speziellen Fällen oder in speziellen Adaptern die anhängige Komponente verwenden kann. Andererseits zeigt eine
Abhängigkeit von Typ "fix" an das diese Komponente oder Klasse in jedem Fall von einer Unterkomponente verwendet
wird, und eine Abhängigkeit von Typ "sub" zeigt an das diese Komponente von einer Unterkomponente in speziellen
Situationen oder mit speziellen Adaptern verwendet werden könnte.

.. note::

   Selbst wenn es möglich ist einzelne Komponenten für die Verwendung vom kompletten Zend Framework zu seperieren
   sollte man trotzdem wissen dass dies zu Problemen führen kann wenn Dateien fehlen oder Komponenten dynamisch
   verwendet werden.

.. include:: requirements.dependencies.table.rst

