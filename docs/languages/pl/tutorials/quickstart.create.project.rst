.. EN-Revision: none
.. _learning.quickstart.create-project:

Utworzenie projektu
===================

Aby utworzyć nowy projekt należy wcześniej pobrać i rozpakować Zend Framework.

.. _learning.quickstart.create-project.install-zf:

Instalacja Zend Framework
-------------------------

Najprostszym sposobem pobrania Zend Framework razem z całym środowiskiem *PHP* jest zainstalowanie `Zend
Server`_. Zend Server zawiera instalatory dla Mac OS X, Windows, Fedora Core oraz Ubuntu. Oprócz tego dostępna
jest uniwersalna paczka instalacyjna kompatybilna z większością dystrybucji Linux.

Po zainstalowaniu Zend Server, pliki frameworka są dostępne w katalogu ``/usr/local/zend/share/ZendFramework``
dla Mac OS X oraz Linux, lub ``C:\Program Files\Zend\ZendServer\share\ZendFramework`` dla Windows. Zmienna
``include_path`` będzie automatycznie ustawiona tak aby obejmowała Zend Framework.

Alternatywnie można `pobrać najnowszą wersję Zend Framework`_ i rozpakować zawartość do dowolnego katalogu;
należy zapamiętać wybraną lokalizację instalacji.

Opcjonalnie w pliku ``php.ini`` można umieścić w zmiennej ``include_path`` ścieżkę do podkatalogu
``library/`` znajdującego się w pobranym archiwum.

Instalacja zakończona! Zend Framework jest zainstalowany i gotowy do użycia.

.. _learning.quickstart.create-project.create-project:

Tworzenie projektu
------------------

.. note::

   **Narzędzie wiersza poleceń zf**

   W katalogu instalacji Zend Framework znajduje się podkatalog ``bin/``. Zawiera on skrypty ``zf.sh`` oraz
   ``zf.bat`` odpowiednio dla użytkowników Unix oraz Windows. Należy zapamiętać ścieżkę dostępu do tych
   skryptów.

   Jeśli w dokumentacji pojawią się odniesienia do komendy ``zf``, proszę pamiętać o zastąpieniu ich pełną
   ścieżką dostępu do odpowiedniego skryptu. Dla systemów Unix można skorzystać z polecenia alias: ``alias
   zf.sh=path/to/ZendFramework/bin/zf.sh``.

   W przypadku problemów z konfiguracją narzędzia wiersza poleceń proszę zapoznać się z :ref:`jego
   instrukcją <zend.tool.framework.clitool.setup-general>`.

Aby utworzyć nowy projekt należy otworzyć terminal (dla Windows - wiersz polecenia ``Start -> Run`` i polecenie
``cmd``). Należy przejść do katalogu nowego projektu. Następnie, używając ścieżki do odpowiedniego skryptu,
należy wywołać następujące polecenie:

.. code-block:: console
   :linenos:

   % zf create project quickstart

Wywołanie tego polecenia spowoduje utworzenie podstawowej struktury katalogów, razem z początkowymi kontrolerami
i widokami. Drzewo katalogów powinno wyglądać podobnie do poniższego:

.. code-block:: text
   :linenos:

   quickstart
   |-- application
   |   |-- Bootstrap.php
   |   |-- configs
   |   |   `-- application.ini
   |   |-- controllers
   |   |   |-- ErrorController.php
   |   |   `-- IndexController.php
   |   |-- models
   |   `-- views
   |       |-- helpers
   |       `-- scripts
   |           |-- error
   |           |   `-- error.phtml
   |           `-- index
   |               `-- index.phtml
   |-- library
   |-- public
   |   |-- .htaccess
   |   `-- index.php
   `-- tests
       |-- application
       |   `-- bootstrap.php
       |-- library
       |   `-- bootstrap.php
       `-- phpunit.xml

W tym momencie, jeśli Zend Framework nie jest umieszczony w zmiennej ``include_path``, zaleca się skopiowanie lub
umieszczenie linku symbolicznego do podkatalogu ``library/`` projektu. Najistotniejsze jest aby zawartość
katalogu ``library/Zend/`` instalacji Zend Framework była dostępna w katalogu ``library/`` projektu. Na systemach
Unix można tego dokonać za pomocą następujących poleceń:

.. code-block:: console
   :linenos:

   # Symlink:
   % cd library; ln -s path/to/ZendFramework/library/Zend .

   # Kopia:
   % cd library; cp -r path/to/ZendFramework/library/Zend .

W systemach Windows najprostszym rozwiązaniem będzie wykonanie tego z poziomu Explorera.

Teraz, kiedy nowy projekt jest utworzony należy zapoznać się z podstawowymi założeniami: bootstrapem,
konfiguracją, kontrolerami oraz widokami.

.. _learning.quickstart.create-project.bootstrap:

Bootstrap
---------

Klasa ``Bootstrap`` definiuje zasoby i komponenty do inicjalizacji. Domyślnie uruchamiany jest :ref:`kontroler
frontowy <zend.controller.front>` ze standardowym katalogiem w którym szukane są kontrolery akcji (o których
mowa później) ustawionym na ``application/controllers/``. Klasa przedstawia się następująco:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
   }

Jak widać, na początek wymagane jest niewiele.

.. _learning.quickstart.create-project.configuration:

Konfiguracja
------------

Sam Zend Framework nie wymaga konfiguracji ale tworzona aplikacja - najczęściej tak. Standardowo plik
konfiguracyjny umieszczony jest w ``application/configs/application.ini``. Zawiera on podstawowe instrukcje
ustawienia środowiska *PHP* (np. włączanie/wyłączanie raportowania błędów), wskazanie ścieżki i klasy
``Bootstrap`` oraz ścieżkę do katalogu kontrolerów akcji. Domyślny plik wygląda następująco:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Należy zwrócić uwagę na kilka cech tego pliku. Po pierwsze, używając konfiguracji w pliku *INI*, można
bezpośrednio używać stałych; ``APPLICATION_PATH`` to stała PHP (opisana później). Dodatkowo, zdefiniowane
zostały oddzielne sekcje: production, staging, testing oraz development. Ostatnie trzy dziedziczą ustawienia ze
środowiska produkcyjnego (production). Podany sposób stanowi użyteczny przykład organizacji konfiguracji,
dzięki której odpowiednie ustawienia są dostępne w odpowiednim momencie cyklu rozwoju oprogramowania.

.. _learning.quickstart.create-project.action-controllers:

Kontrolery akcji (action controllers)
-------------------------------------

Zawarte w aplikacji **kontrolery akcji** przechowują ścieżki działania programu i odwzorowują żądania na
odpowiednie modele i widoki.

Kontroler akcji powinien posiadać co najmniej jedną metodę o nazwie zakończonej na "Action". Te metody stają
się dostępne dla użytkowników. Domyślnie URLe w Zend Framework stosują schemat ``/kontroler/akcja``, gdzie
"kontroler" jest odwzorowany na nazwę kontrolera akcji (z pominięciem sufiksu "Controller") a "akcja" jest
odwzorowana na metodę w tym kontrolerze (z pominięciem sufiksu "Action").

W typowym projekcie niezbędny jest kontroler ``IndexController``, który jest początkowym punktem odniesienia i
stanowi stronę początkową aplikacji, oraz ``ErrorController`` czyli kontroler obsługujący błędy *HTTP* 404
(brak kontrolera i/lub akcji) lub *HTTP* 500 (błąd aplikacji).

Domyślnie ``IndexController`` wygląda następująco:

.. code-block:: php
   :linenos:

   // application/controllers/IndexController.php

   class IndexController extends Zend_Controller_Action
   {

       public function init()
       {
           /* Inicjalizacja kontrolera akcji */
       }

       public function indexAction()
       {
           // ciało akcji
       }
   }

Domyślny ``ErrorController`` przedstawia się jak poniżej:

.. code-block:: php
   :linenos:

   // application/controllers/ErrorController.php

   class ErrorController extends Zend_Controller_Action
   {

       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:

                   // błąd 404 -- brak kontrolera i/lub akcji
                   $this->getResponse()->setHttpResponseCode(404);
                   $this->view->message = 'Page not found';
                   break;
               default:
                   // błąd aplikacji
                   $this->getResponse()->setHttpResponseCode(500);
                   $this->view->message = 'Application error';
                   break;
           }

           $this->view->exception = $errors->exception;
           $this->view->request   = $errors->request;
       }
   }

Należy zwrócić uwagę, iż ``IndexController`` nie zawiera żadnego kodu oraz ``ErrorController`` odnosi się do
właściwości "view". To prowadzi do następnego tematu.

.. _learning.quickstart.create-project.views:

Widoki (views)
--------------

Widoki (view scripts) w Zend Framework są napisane w starym dobrym *PHP*. Domyślnie znajdują się w
``application/views/scripts/``, gdzie są w dalszym stopniu dzielone wg kontrolerów do których należą. W
obecnym przypadku istnieją dwa kontrolery: ``IndexController`` oraz ``ErrorController``. Oznacza to, że w
katalogu widoków powinny się znaleźć dwa podkatalogi: ``index/`` oraz ``error/``. W nich należy umieścić
skrypty widoków odpowiednie dla każdej z akcji danego kontrolera. Domyślnie tworzone są skrypty
``index/index.phtml`` oraz ``error/error.phtml``.

Skrypty widoków mogą zawierać dowolny kod *HTML* i używać *<?php* jako tagów otwarcia i *?>* jako tagów
zamknięcia dla poleceń *PHP*.

Domyślnie skrypt ``index/index.phtml`` zawiera następującą zawartość:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/index/index.phtml -->
   <style>

       a:link,
       a:visited
       {
           color: #0398CA;
       }

       span#zf-name
       {
           color: #91BE3F;
       }

       div#welcome
       {
           color: #FFFFFF;
           background-image: url(http://framework.zend.com/images/bkg_header.jpg);
           width:  600px;
           height: 400px;
           border: 2px solid #444444;
           overflow: hidden;
           text-align: center;
       }

       div#more-information
       {
           background-image: url(http://framework.zend.com/images/bkg_body-bottom.gif);
           height: 100%;
       }

   </style>
   <div id="welcome">
       <h1>Welcome to the <span id="zf-name">Zend Framework!</span><h1 />
       <h3>This is your project's main page<h3 />
       <div id="more-information">
           <p>
               <img src="http://framework.zend.com/images/PoweredBy_ZF_4LightBG.png" />
           </p>

           <p>
               Helpful Links: <br />
               <a href="http://framework.zend.com/">Zend Framework Website</a> |
               <a href="http://framework.zend.com/manual/en/">Zend Framework
                   Manual</a>
           </p>
       </div>
   </div>

Skrypt ``error/error.phtml`` jest nieco bardziej interesujący - używa instrukcji warunkowych *PHP*:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/error/error.phtml -->
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN";
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Default Application</title>
   </head>
   <body>
     <h1>An error occurred</h1>
     <h2><?php echo $this->message ?></h2>

     <?php if ('development' == $this->env): ?>

     <h3>Exception information:</h3>
     <p>
         <b>Message:</b> <?php echo $this->exception->getMessage() ?>
     </p>

     <h3>Stack trace:</h3>
     <pre><?php echo $this->exception->getTraceAsString() ?>
     </pre>

     <h3>Request Parameters:</h3>
     <pre><?php echo var_export($this->request->getParams(), 1) ?>
     </pre>
     <?php endif ?>

   </body>
   </html>

.. _learning.quickstart.create-project.vhost:

Utworzenie wirtualnego hosta
----------------------------

Na potrzeby tego wprowadzenia, założono użycie `web serwera Apache`_. Zend Framework działa równie dobrze z
innymi serwerami - włączając Microsoft Internet Information Services, lighttpd, nginx i wiele innych.
Większość programistów jednak jest najbardziej zaznajomiona z Apache, który ułatwia zrozumienie struktury
katalogów Zend Framework i posiada szerokie możliwości przepisywania linków (mod_rewrite).

Aby utworzyć wirtualnego hosta należy odnaleźć plik ``httpd.conf`` oraz ewentualne pozostałe pliki
konfiguracyjne serwera. Popularne katalogi:

- ``/etc/httpd/httpd.conf`` (Fedora, RHEL i inne)

- ``/etc/apache2/httpd.conf`` (Debian, Ubuntu i inne)

- ``/usr/local/zend/etc/httpd.conf`` (Zend Server na maszynach \*nix)

- ``C:\Program Files\Zend\Apache2\conf`` (Zend Server na maszynach Windows)

W pliku ``httpd.conf`` (lub ``httpd-vhosts.conf`` dla niektórych systemów) należy dokonać dwóch zmian. Po
pierwsze - upewnić się, że jest zainicjowana zmienna ``NameVirtualHost``; Typowe ustawienie to "\*:80". Po
drugie - zdefiniować wirtualnego hosta:

.. code-block:: apache
   :linenos:

   <VirtualHost *:80>
       ServerName quickstart.local
       DocumentRoot /sciezka/do/quickstart/public

       SetEnv APPLICATION_ENV "development"

       <Directory /sciezka/do/quickstart/public>
           DirectoryIndex index.php
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
   </VirtualHost>

Należy zwrócić uwagę na kilka szczegółów. Po pierwsze, ``DocumentRoot`` wskazuje na podkatalog projektu o
nazwie ``public``. To oznacza, że jedynie pliki znajdujące się w tym podkatalogu mogą być zwracane przez
serwer bezpośrednio. Po drugie, instrukcje ``AllowOverride``, ``Order`` oraz ``Allow`` umożliwiają stosowanie
plików ``htacess`` w projekcie. W środowisku programistycznym (development) jest to uznawane za dobrą praktykę
ponieważ eliminuje potrzebę resetowania serwera po każdej zmianie instrukcji konfiguracyjnych. Jednak w
środowisku produkcyjnym (production), zalecane jest przeniesienie zawartości pliku ``htaccess`` do głównego
pliku konfiguracyjnego serwera oraz wyłączenie obsługi ``htaccess``. Po trzecie, instrukcja ``SetEnv`` pozwala
zainicjować zmienną środowiskową oraz przekazać ją do PHP i ``index.php``. Dzięki temu stanie się ona
podstawą stałej ``APPLICATION_ENV`` aplikacji Zend Framework. W środowisku produkcyjnym można ją ustawić na
"production" lub zrezygnować z tej instrukcji ("production" jest domyślną wartością stałej
``APPLICATION_ENV``).

Na koniec należy dodać wpis w pliku ``hosts`` odnoszący się do wartości ``ServerName``. Na systemach \*nix
jest to zazwyczaj ``/etc/hosts``. Na maszynach Windows typową lokalizacją jest
``C:\WINDOWS\system32\drivers\etc``. Wpis powinien być podobny do:

.. code-block:: text
   :linenos:

   127.0.0.1 quickstart.local

Po uruchomieniu webserwera (lub restarcie) projekt powinien być gotowy do użytku.

.. _learning.quickstart.create-project.checkpoint:

Punkt kontrolny
---------------

W tym momencie aplikacja Zend Framework jest gotowa do uruchomienia. Po wpisaniu w przeglądarce nazwy serwera
(ustalonej w poprzednim punkcie) powinna się pojawić strona powitalna.



.. _`Zend Server`: http://www.zend.com/en/products/server-ce/downloads
.. _`pobrać najnowszą wersję Zend Framework`: http://framework.zend.com/download/latest
.. _`web serwera Apache`: http://httpd.apache.org/
