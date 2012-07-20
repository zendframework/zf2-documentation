.. _learning.autoloading.resources:

Automatisches Laden von Ressourcen
==================================

Oft ist es kompliziert, wenn eine Anwendung entwickelt wird, Klassen in den 1:1 Klassenname:Dateiname Standard zu
packen welchen der Zend Framework empfiehlt, oder es hat Vorteile für Zwecke des Packens das nicht zu tun. Das
bedeutet aber das die eigenen Klassendateien nicht vom Autoloader gefunden werden.

Wenn man :ref:`die Design Ziele <learning.autoloading.design>` für den Autoloader durchliest, zeigt der letzte
Punkt in diesem Kapitel das die Lösung diese Situation abdecken könnte. Zend Framework macht das mit der
``Zend_Loader_Autoloader_Resource``.

Eine Ressource ist nur ein Name der mit dem Namespace einer Komponente korrespondiert (welche dem Namespace des
Autoloaders angehängt wird) und einem Pfad (der relativ zum Basispfad des Autoloaders ist). In Aktion könnte man
etwas wie folgt machen:

.. code-block:: php
   :linenos:

   $loader = new Zend_Application_Module_Autoloader(array(
       'namespace' => 'Blog',
       'basePath'  => APPLICATION_PATH . '/modules/blog',
   ));

Sobald der Loader platziert ist, muss man Ihn über die verschiedenen Ressource Typen informieren die er beachten
soll. Dieser Ressource Typen sind einfach Paare von Unterverzeichnis und Präfix.

Nehmen wir als Beispiel den folgenden Baum:

.. code-block:: text
   :linenos:

   path/to/some/resources/
   |-- forms/
   |   `-- Guestbook.php        // Foo_Form_Guestbook
   |-- models/
   |   |-- DbTable/
   |   |   `-- Guestbook.php    // Foo_Model_DbTable_Guestbook
   |   |-- Guestbook.php        // Foo_Model_Guestbook
   |   `-- GuestbookMapper.php  // Foo_Model_GuestbookMapper

Unser erster Schritt ist die Erstellung des Ressource Loaders:

.. code-block:: php
   :linenos:

   $loader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'  => 'path/to/some/resources/',
       'namespace' => 'Foo',
   ));

Als nächstes müssen wir einige Ressource Typen definieren. ``Zend_Loader_Autoloader_Resourse::addResourceType()``
hat drei Argumente: den Typ ("type") der Ressource (ein eigener String), den Pfad unter dem Basispfad in dem der
Ressource Typ gefunden werden kann, und der Präfix der Komponente welcher für den Ressource Typ zu verwenden ist.
Im obigen Baum haben wir drei Ressource Typen: form (im Unterverzeichnis "forms", mit dem Komponenten Präfix
"Form"), model (im Unterverzeichnis "models", mit dem Komponenten Präfix "Model"), und dbtable (im
Unterverzeichnis "``models/DbTable``", mit dem Komponenten Präfix "``Model_DbTable``"). Wir definieren Sie wie
folgt:

.. code-block:: php
   :linenos:

   $loader->addResourceType('form', 'forms', 'Form')
          ->addResourceType('model', 'models', 'Model')
          ->addResourceType('dbtable', 'models/DbTable', 'Model_DbTable');

Sobald Sie definiert sind, können diese Klassen einfach verwendet werden:

.. code-block:: php
   :linenos:

   $form      = new Foo_Form_Guestbook();
   $guestbook = new Foo_Model_Guestbook();

.. note::

   **Modul Ressource Autoloading**

   Zend Framework's *MVC* Layer empfiehlt die Verwendung von "Modulen", welche eigenständigt Anwendungen in der
   eigenen Site sind. Typischerweise haben Module standardmäßig eine Anzahl von Ressource Typen, und Zend
   Framework :ref:`empfiehlt sogar ein Standard Verzeichnis Layout für Module <project-structure.filesystem>`.
   Ressource Autoloader sind deshalb recht nützlich in diesem Paradigma -- so nützlich das Sie standardmäßig
   aktiviert sind wenn man eine Bootstrap Klasse für eigene Module erstellt welche
   ``Zend_Application_Module_Bootstrap`` erweitert. Für weitere Informationen kann in der
   :ref:`Zend_Loader_Autoloader_Module Dokumentation <zend.loader.autoloader-resource.module>` nachgelesen werden.


