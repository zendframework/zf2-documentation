.. _zend.loader.autoloader-resource:

Ressource Autoloader
====================

Ressource Autoloader sind dazu gedacht Namespaced Bibliothekscode zu Managen der den Coding Standard Richtlinien
vom Zend Framework folgt, welche aber kein 1:1 Mapping zwischen dem Klassennamen und der Verzeichnis Struktur
haben. Ihr primärer Zweck ist es als Autoloader Anwendungs-Ressource Code zu arbeiten, wie z.B. für
Anwendungs-spezifische Modelle, Formen, und *ACL*\ s.

Ressource Autoloader werden mit dem :ref:`autoloader <zend.loader.autoloader>` bei der Instanziierung registriert,
und zwar mit dem Namespace mit dem Sie assoziiert sind. Das erlaubt es Code in speziellen Verzeichnissen zu
namespacen, und trotzdem die Vorteile des Autoloadings zu nutzen.

.. _zend.loader.autoloader-resource.usage:

Verwendung von Ressource Autoloadern
------------------------------------

Nehmen wir die folgende Verzeichnis Struktur an:

.. code-block:: text
   :linenos:

   path/to/some/directory/
       acls/
           Site.php
       forms/
           Login.php
       models/
           User.php

In diesem Verzeichnis hat jeder Code ein Präfix mit dem Namespace "My\_". Im Unterverzeichnis "acls" ist der
Komponentenpräfix "Acl\_" hinzugefügt, was letztendlich zu einem Klassennamen von "My_Acl_Site" führt. So
ähnlich mappt das Unterverzeichnis "forms" auf "Form\_", was zu "My_Form_Login" führt. Das Unterverzeichnis
"models" hat keinen Komponenten Namespace, was zu "My_User" führt.

Man kann einen Ressource Autoloader verwenden um diese Klassen automatisch zu laden. um den Ressource Autoloader zu
instanziieren ist es mindestens notwendig den Basispfad und den Namespace für die Ressourcen zu übergeben für
die er verantwortlich ist:

.. code-block:: php
   :linenos:

   $resourceLoader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'  => 'path/to/some/directory',
       'namespace' => 'My',
   ));

.. note::

   **Basis Namespace**

   In ``Zend_Loader_Autoloader`` wird erwartet das man den endenden Unterstrich ("\_") im Namespace angibt wenn der
   eigene Autoloader verwendet wird um den Namespace zu suchen. ``Zend_Loader_Autoloader_Resource`` nimmt an das
   alle Codes die man automatisch laden will ein Unterstrich Trennzeichen zwischen Namespace, Komponente und Klasse
   verwenden. Als Ergebnis, muß man den endenen Unterstrich nicht verwenden wenn ein Ressource Autoloader
   registriert wird.

Jetzt da wir den Basis Ressource Autoloader eingerichtet haben, können wir einige Komponenten zu Ihm hinzufügen
um die automatisch zu Laden. Das wird mit der ``addResourceType()`` Methode getan, welche drei Argumente
akzeptiert: einen Ressource "type", der intern als Referenzname verwendet wird; den Pfad des Unterverzeichnisses
unter dem Basispfad in dem diese Ressource existiert; und den Namespace der Komponente die dem Basis Namespace
hinzugefügt wird. Als Beispiel fügen wir jeden unserer Ressource Typen hinzu.

.. code-block:: php
   :linenos:

   $resourceLoader->addResourceType('acl', 'acls/', 'Acl')
                  ->addResourceType('form', 'forms/', 'Form')
                  ->addResourceType('model', 'models/');

Alternativ können diese als Array an ``addResourceTypes()`` übergeben werden; das folgende ist äquivalent zu dem
obigen:

.. code-block:: php
   :linenos:

   $resourceLoader->addResourceTypes(array(
       'acl' => array(
           'path'      => 'acls/',
           'namespace' => 'Acl',
       ),
       'form' => array(
           'path'      => 'forms/',
           'namespace' => 'Form',
       ),
       'model' => array(
           'path'      => 'models/',
       ),
   ));

Letztendlich kann alles davon spezifiziert werden wenn das Objekt instanziiert wird indem einfach ein
"resourceTypes" Schlüssel in den Optionen spezifiziert und übergeben wird, sowie eine Struktur wie anbei:

.. code-block:: php
   :linenos:

   $resourceLoader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'      => 'path/to/some/directory',
       'namespace'     => 'My',
       'resourceTypes' => array(
           'acl' => array(
               'path'      => 'acls/',
               'namespace' => 'Acl',
           ),
           'form' => array(
               'path'      => 'forms/',
               'namespace' => 'Form',
           ),
           'model' => array(
               'path'      => 'models/',
           ),
       ),
   ));

.. _zend.loader.autoloader-resource.module:

Der Modul Ressource Autoloader
------------------------------

Zend Framework wird mit einer konkreten Implementation von ``Zend_Loader_Autoloader_Resource`` ausgeliefert die
Ressourcen Typen enthält welche den notwendigen Standard Verzeichnisstrukturen für Zend Framework *MVC*
Anwendungen entsprechen. Diese Lader, ``Zend_Application_Module_Autoloader``, kommt mit den folgenden Mappings:

.. code-block:: text
   :linenos:

   forms/       => Form
   models/      => Model
       DbTable/ => Model_DbTable
       mappers/ => Model_Mapper
   plugins/     => Plugin
   services/    => Service
   views/
       helpers  => View_Helper
       filters  => View_Filter

Wenn man, als Beispiel, ein Modul mit dem Präfix "Blog\_" hat, und die Klasse "Blog_Form_Entry" instanziieren
will, würde diese in den Ressourcen Verzeichnis "forms/" im Unterverzeichnis nach einer Datei die "Entry.php"
heißt suchen.

Wenn Modul Bootstraps mit ``Zend_Application`` verwendet werden, wird standardmäßig eine Instanz von
``Zend_Application_Module_Autoloader`` für jede eigene Modul erstellt, was es erlaubt Modul Ressource automatisch
zu laden.

.. _zend.loader.autoloader-resource.factory:

Verwendung von Ressource Autoloadern als Objekt Factories
---------------------------------------------------------



.. _zend.loader.autoloader-resource.reference:

Referenz zu den Ressource Autoloadern
-------------------------------------




