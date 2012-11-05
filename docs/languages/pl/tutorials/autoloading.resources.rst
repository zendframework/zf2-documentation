.. EN-Revision: none
.. _learning.autoloading.resources:

Automatyczne ładowanie zasobów
==============================

Często, podczas tworzenia aplikacji, zachowanie zalecanego przez Zend Framework standardu dotyczącego utrzymania
stosunku 1:1 pomiędzy klasami a plikami jest trudne bądź niekorzystne z punktu widzenia wydajności. To oznacza,
że pliki z klasami nie zostaną odnalezione przez autoloader.

Zgodnie z :ref:`celami autoloadera <learning.autoloading.design>` a zwłaszcza z ostatnim punktem, powyższa
sytuacja jest obsługiwana przez autoloader Zend Framework poprzez ``Zend\Loader_Autoloader\Resource``.

Zasób to jedynie nazwa odpowiadająca przestrzeni nazw komponentu (dołączona do przestrzeni nazw autoloadera)
wraz ze ścieżką (relatywnie do ścieżki bazowej autoloadera). W praktyce można użyć następującego kodu:

.. code-block:: php
   :linenos:

   $loader = new Zend\Application_Module\Autoloader(array(
       'namespace' => 'Blog',
       'basePath'  => APPLICATION_PATH . '/modules/blog',
   ));

Po włączeniu autoloadera należy "poinformować" go o typach zasobów, które powinien dołączać. Są to, po
prostu, pary względnych ścieżek oraz prefiksów.

Jako przykład może posłużyć następujące drzewo katalogów:

.. code-block:: text
   :linenos:

   sciezka/do/zasobow/
   |-- forms/
   |   `-- Guestbook.php        // Foo_Form_Guestbook
   |-- models/
   |   |-- DbTable/
   |   |   `-- Guestbook.php    // Foo_Model_DbTable_Guestbook
   |   |-- Guestbook.php        // Foo_Model_Guestbook
   |   `-- GuestbookMapper.php  // Foo_Model_GuestbookMapper

Pierwszym krokiem jest utworzenie autoloadera zasobów:

.. code-block:: php
   :linenos:

   $loader = new Zend\Loader_Autoloader\Resource(array(
       'basePath'  => 'sciezka/do/zasobow/',
       'namespace' => 'Foo',
   ));

Następnie należy zdefiniować typy zasobów. ``Zend\Loader_Autoloader\Resourse::addResourceType()`` przyjmuje
trzy argumenty: typ zasobu (dowolny łańcuch znaków), ścieżka relatywna do ścieżki bazowej autoloadera, w
której zasób się znajduje oraz prefiks używany przez dany typ zasobu. W powyższym przykładzie istnieją trzy
rodzaje zasobów: formularze (w katalogu "forms" z prefiksem "Form"), modele (w katalogu "models" z prefiksem
"Model") oraz modele tabeli bazy danych (w katalogu "``models/DbTable``" z prefiksem "``Model_DbTable``").
Następujący przykład pokazuje sposób ich definiowania:

.. code-block:: php
   :linenos:

   $loader->addResourceType('form', 'forms', 'Form')
          ->addResourceType('model', 'models', 'Model')
          ->addResourceType('dbtable', 'models/DbTable', 'Model_DbTable');

Po zdefiniowaniu, można używać tych klas bez ręcznego dołączania:

.. code-block:: php
   :linenos:

   $form      = new Foo_Form_Guestbook();
   $guestbook = new Foo_Model_Guestbook();

.. note::

   **automatyczne ładowanie zasobu modułu**

   Implementacja wzorca projektowego *MVC* w Zend Framework zachęca do używania modułów, które są
   mini-aplikacjami w ramach tworzonego programu. Moduły przeważnie posiadają wiele typów zasobów a Zend
   Framework nawet :ref:`zaleca standardową strukturę katalogów dla modułu <project-structure.filesystem>`.
   Autoloader zasobów staje się bardzo przydatny w tym kontekście. Przez to, jeśli umieści się plik z klasą
   bootstrap pochodną do ``Zend\Application_Module\Bootstrap`` to autoloader zostanie domyślnie włączony. Aby
   uzyskać więcej informacji należy zapoznać się z :ref:`dokumentacją Zend\Loader_Autoloader\Module
   <zend.loader.autoloader-resource.module>`.


