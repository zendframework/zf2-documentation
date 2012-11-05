.. EN-Revision: none
.. _learning.quickstart.create-layout:

Utworzenie layoutu
==================

Jak nie trudno zauważyć, skrypty widoków z poprzedniej części zawierały jedynie fragmenty kodu *HTML*, a nie
całe strony. Jest to zamierzone i ma na celu przygotowanie akcji tak, aby zwracały jedynie zawartość związaną
z samą akcją, a nie aplikacją jako taką.

Teraz należy umieścić generowaną treść w pełnoprawnej stronie *HTML*. Przydatne jest również nadanie
całej aplikacji jednolitego, zwięzłego wyglądu. Aby to osiągnąć zostanie użyty globalny layout (wzór)
strony.

Zend Framework używa dwóch wzorów projektowych przy implementacji layoutów: `Widok dwustopniowy (Two Step
View)`_ oraz `Widok złożony (Composite View)`_. **Widok dwustopniowy** jest najczęściej powiązany z `Widokiem
przekształconym (Transform View)`_- podstawową cechą jest założenie, że aplikacja tworzy widok podrzędny,
który zostaje umieszczony w widoku głównym (layout) i dopiero taki - złożony widok jest przetwarzany do
pokazania użytkownikowi. **Widok złożony** natomiast, zakłada tworzenie jednego bądź wielu autonomicznych
widoków bez relacji rodzic-potomek.

:ref:`Zend_Layout <zend.layout>` jest komponentem, który łączy te wzorce w aplikacji Zend Framework. Każdy
skrypt widoku (view script) posiada własne elementy i nie musi zajmować się wyświetlaniem elementów wspólnych
dla całej strony.

Mogą powstać sytuacje, w których niezbędne okaże się umieszczenie globalnych elementów w pojedynczym widoku.
W tym celu Zend Framework udostępnia szereg **pojemników (placeholders)**, które umożliwiają dostęp do takich
elementów z poziomu lokalnego skryptu widoku.

Aby rozpocząć korzystanie z ``Zend_Layout`` należy najpierw poinstruować bootstrap aby włączył zasób
``Layout``. Można to osiągnąć za pomocą komendy ``zf enable layout`` (w katalogu tworzonego projektu):

.. code-block:: console
   :linenos:

   % zf enable layout
   Layouts have been enabled, and a default layout created at
   application/layouts/scripts/layout.phtml
   A layout entry has been added to the application config file.

Tak jak jest to napisane w potwierdzeniu komendy, plik ``application/configs/application.ini`` został
zaktualizowany i zawiera następujący wpis w sekcji ``production``:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Dodane do sekcji [production]:
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

W rezultacie plik *INI* powinien wyglądać następująco:

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
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Dodany zapis powoduje, że aplikacja szuka skryptów widoku w katalogu ``application/layouts/scripts``. Należy
zauważyć, iż taki katalog wraz z plikiem ``layout.phtml`` zostały utworzone w strukturze projektu przez
narzędzie wiersza poleceń zf.

Następną przydatną rzeczą będzie upewnienie się, że deklaracja *XHTML* DocType jest umieszczona i poprawnie
sformułowana. Aby to osiągnąć należy dodać zasób do bootstrapa.

Najprostszym sposobem na dodanie zasobu bootstrap jest utworzenie chronionej metody o nazwie zaczynającej się na
``_init``. Celem jest zainicjalizowanie deklaracji DocType więc nowa metoda w klasie bootstrap może się nazywać
``_initDoctype()``:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend\Application_Bootstrap\Bootstrap
   {
       protected function _initDoctype()
       {
       }
   }

W ciele metody należy powiadomić zasób widoku aby użył odpowiedniego DocType. Tylko skąd wziąć obiekt
widoku? Najłatwiejszym rozwiązaniem jest zainicjalizowanie zasobu ``View``. Potem można pobrać obiekt i go
użyć.

Aby zainicjalizować zasób widoku należy dodać następującą linijkę do pliku
``application/configs/application.ini`` w sekcji ``production``:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Dodanie do sekcji [production]:
   resources.view[] =

Ten zapis inicjalizuje widok bez żadnych opcji (pisownia '[]' oznacza, że "view" jest tablicą bez żadnych
kluczy ani wartości).

Teraz, skoro widok jest skonfigurowany, można wrócić do metody ``_initDoctype()``. W niej należy upewnić się,
że zasób ``View`` został zainicjowany (na podstawie zapisów w pliku konfiguracyjnym), pobrać obiekt widoku i
go skonfigurować:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend\Application_Bootstrap\Bootstrap
   {
       protected function _initDoctype()
       {
           $this->bootstrap('view');
           $view = $this->getResource('view');
           $view->doctype('XHTML1_STRICT');
       }
   }

Po zainicjalizowaniu ``Zend_Layout`` i ustawieniu deklaracji Doctype, należy utworzyć główny layout strony:

.. code-block:: php
   :linenos:

   <!-- application/layouts/scripts/layout.phtml -->
   <?php echo $this->doctype() ?>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Quickstart Application</title>
     <?php echo $this->headLink()->appendStylesheet('/css/global.css') ?>
   </head>
   <body>
   <div id="header" style="background-color: #EEEEEE; height: 30px;">
       <div id="header-logo" style="float: left">
           <b>ZF Quickstart Application</b>
       </div>
       <div id="header-navigation" style="float: right">
           <a href="<?php echo $this->url(
               array('controller'=>'guestbook'),
               'default',
               true) ?>">Guestbook</a>
       </div>
   </div>

   <?php echo $this->layout()->content ?>

   </body>
   </html>

Za pomocą view helpera ``layout()`` pobierana jest zawartość przeznaczona do wyświetlenia (znajduje się w
zmiennej "content"). Można ją umieszczać w innych częściach layoutu ale w większości przypadków takie
podejście wystarczy.

Należy zwrócić uwagę na użycie view helpera ``headLink()``. Jest to prosty sposób na zachowanie kontroli nad
elementami <link> dodawanymi w różnych miejscach aplikacji oraz na wygenerowanie kodu *HTML* dla tych elementów
w pliku layoutu bądź innego skryptu widoku. Jeśli zajdzie potrzeba dodania dodatkowego arkusza CSS w pojedynczej
akcji to można to zrobić używając ``headLink()``\ (na generowanej stronie pojawi się automatycznie).

.. note::

   **Punkt kontrolny**

   Teraz należy udać się pod adres "http://localhost" i sprawdzić efekty oraz wygenerowany kod. Powinien
   pojawić się nagłówek *XHTML*, elementy head, title oraz body.



.. _`Widok dwustopniowy (Two Step View)`: http://martinfowler.com/eaaCatalog/twoStepView.html
.. _`Widok złożony (Composite View)`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
.. _`Widokiem przekształconym (Transform View)`: http://www.martinfowler.com/eaaCatalog/transformView.html
