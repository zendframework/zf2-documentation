.. EN-Revision: none
.. _introduction.installation:

************
Installation
************

Siehe den :ref:`Anhang Voraussetzungen <requirements>` für eine detailierte Liste von Voraussetzungen für Zend
Framework.

Die Installation des Zend Frameworks ist extrem einfach. Sobald der Framework heruntergeladen und extrahiert wurde
wurde, sollte das ``/library`` Verzeichnis der Distribution dem Anfang des Includepfades angefügt werden. Es kann
auch gewünscht sein das library Verzeichnis in eine andere - möglicherweise geteilte - Lokation auf dem
Dateisystem zu verschieben.

- `Herunterladen des letzten stabilen Releases.`_ Diese Version, erhältlich in den beiden Formaten ``.zip`` und
  ``.tar.gz`` ist eine gute Wahl für jene für die Zend Framework neu ist.

- `Herunterladen des letzten nächtlichen Schnappschußes.`_ Für die tapferen unter euch, repräsentiert der
  nächtliche Schnappschuß den letzten Fortschritt in der Entwicklung des Zend Frameworks. Schnappschüße sind
  gebündelt mit Dokumentation, entweder in Englisch oder in allen vorhandenen Sprachen. Wenn davon abgesehen wird
  mit den letzten Zend Framework Entwicklungen zu arbeiten, sollte die Verwendung eine Subversion (*SVN*) Clients
  erwogen werden.

- Verwenden eines `Subversion`_ (*SVN*) Clients. Zend Framework ist eine Open Source Software, und das für dessen
  Entwicklung verwendete Subversion Repository ist öffentlich erreichbar. Es sollte überlegt werden *SVN* zu
  verwenden um den Zend Framework zu erhalten, wenn bereits *SVN* für die eigene Anwendungsentwicklung verwendet
  wird, oder wenn es notwendig ist die Framework Version öfter zu aktualisieren als Releases erscheinen.

  `Exportieren`_ ist nützlich wenn man eine spezielle Framework Revision ohne die ``.svn`` Verzeichnisse erhalten
  will, wie bei der Erstellung einer Arbeitskopie.

  `Checke eine Arbeitskopie aus`_ wenn Du am Zend Frameowork mitarbeiten willst. Eine Arbeitskopie kann jederzeit
  mit `svn update`_ upgedated werden und Änderungen können mit dem `svn commit`_ Kommando in unser *SVN*
  Repository übertragen werden.

  Eine `externe Definition`_ ist recht bequem für Entwickler die bereits *SVN* benutzen um Ihre eigenen
  Arbeitskopien ihrer Anwendungen zu Verwalten.

  Die *URL* für den Stamm des Zend Framework *SVN* Repositories ist:
  `http://framework.zend.com/svn/framework/standard/trunk`_

Sobald eine Kopie des Zend Framework vorhanden ist, muß die eigene Anwendung fähig sein die Zend Framework
Klassen aufzurufen. Obwohl es `verschiedene Wege gibt das zu erreichen`_, muß *PHP*'s `include_path`_ den Pfad zur
Zend Framework Bibliothek enthalten.

Zend bietet einen `QuickStart`_ um so schnell wie möglich in Funktion zu treten. Das ist ein exzellenter Weg um zu
lernen mit dem Framework umzugehen mit einem Beispiel aus der wirklichen Welt auf dem aufgebaut werden kann.

Da die Komponenten vom Zend Framework lose verbunden sind, können beliebige Kombinationen von Ihnen in eigenen
Anwendungen verwendet werden. Die folgenden Kapietl bieten eine komprimierten Referenz zum Zend Framework auf Basis
der Komponenten.



.. _`Herunterladen des letzten stabilen Releases.`: http://framework.zend.com/download/latest
.. _`Herunterladen des letzten nächtlichen Schnappschußes.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Exportieren`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Checke eine Arbeitskopie aus`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`externe Definition`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`verschiedene Wege gibt das zu erreichen`: http://www.php.net/manual/de/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/de/ini.core.php#ini.include-path
.. _`QuickStart`: http://framework.zend.com/docs/quickstart
