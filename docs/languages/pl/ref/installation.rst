.. EN-Revision: none
.. _introduction.installation:

Instalacja
==========

Aby zapoznać się z pełną listą wymagań Zend Framework należy przejść do :ref:`dodatku dotyczącego
wymogów <requirements>`.

Instalacja Zend Framework jest ekstremalnie prosta. Po pobraniu i rozpakowaniu frameworka powinieneś dodać
katalog /library na początek dyrektywy include_path. Możesz także przenieść katalog /library w inne miejsce
np. współdzielone między aplikacjami.



   - `Ściągnij najnowszą stabilną wersję.`_ Ta wersja, dostępna w formatach *.zip* oraz *.tar.gz*, jest
     dobrym wyborem dla początkujących z Zend Framework.

   - `Ściągnij najnowszą wersję nocną`_. Dla tych odważnych, nocne wersje reprezentują ostatnie postępy w
     rozwoju Zend Framework. Wersje te można ściagnąć tylko z angielską dokumentacją lub wraz z dokumentacją
     we wszystkich dostępnych językach. Jeśli nie chcesz używać najnowszych wydanych wersji Zend Framework,
     rozważ użycie klienta Subversion (SVN).

   - Użycie klienta `Subversion`_ (SVN). Zend Framework jest oprogramowaniem o otwartym kodzie źródłówym i
     repozytorium Subversion używane to jego tworzenia jest publicznie dostępne. Rozważ użycie SVN do pobrania
     Zend Framework jeżeli obecnie używasz SVN do rozwijania swojej aplikacji, jeżeli chcesz brać udział w
     rozwoju frameworka lub gdy potrzebujesz aktualizować Zend Framework częściej niż wydawane są jego wersje.

     `Eksportowanie`_ jest przydatne gdy chcesz pobrać określoną wersję bez katalogów *.svn*, tworzonych w
     kopii roboczej.

     `Pobranie kopii roboczej`_ jest dobrym rozwiązaniem gdy chcesz brać udział w rozwijaniu Zend Framework i
     wtedy, gdy chcesz mieć możliwość aktualizowania swojej kopii roboczej za pomocą komendy `svn update`_.

     `Definicja zewnętrznych plików`_ jest bardzo wygodna dla programistów, którzy używają SVN do
     zarządzania kopiami roboczymi swojej aplikacji.

     Adres URL katalogu trunk repozytorium SVN dla Zend Framework to
     `http://framework.zend.com/svn/framework/standard/trunk`_



Kiedy już pobierzesz kopię Zend Framework, twoja aplikacja będzie musiała być w stanie uzyskać dostęp do
klas frameworka. Jest kilka sposobów `osiągnięcia tego`_ ale obojętnie od wybranego sposobu wartość dyrektywy
PHP `include_path`_ musi zawierać ścieżkę do biblioteki Zend Framework.

Zend zapewnia `poradnik Szybki Start`_ który pozwoli ci na możliwie szybkie zapoznanie się z frameworkiem. Jest
to znakomity sposób rozpoczęcia nauki frameworka, wraz z realnymi przykładami zastosowania, które możesz
wykorzystać.

Ze względu na to, że komponenty Zend Framework są ze sobą luźno związane, możesz ich użyć w swoich
aplikacjach w przeróżnych kombinacjach. Kolejne rozdziały w wyczerpujący sposób opiszą cały framework,
komponent po komponencie.



.. _`Ściągnij najnowszą stabilną wersję.`: http://framework.zend.com/download
.. _`Ściągnij najnowszą wersję nocną`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Eksportowanie`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Pobranie kopii roboczej`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`Definicja zewnętrznych plików`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`osiągnięcia tego`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`poradnik Szybki Start`: http://framework.zend.com/docs/quickstart
