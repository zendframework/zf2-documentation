.. _zend.navigation.containers:

Container
=========

Container haben Methoden für das Hinzufügen, Empfangen, Löschen und Durchlaufen von Seiten. Container
implementieren die `SPL`_ Interfaces ``RecursiveIterator`` und ``Countable``, was bedeutet das ein Container
durchlaufen werden kann indem die SPL Klasse ``RecursiveIteratorIterator`` verwendet wird.

.. _zend.navigation.containers.creating:

Erstellen von Containern
------------------------

``Zend_Navigation_Container`` ist abstrakt, und kann nicht direkt instanziiert werden. Verwende ``Zend_Navigation``
wenn ein Container instanziiert werden soll.

``Zend_Navigation`` kann komplett leer erstellt werden, oder indem ein Array genommen wird, oder ein
``Zend_Config`` Objekt mit Seiten in den Container gegeben wird. Jede seite in dem gegebenen Array/Config wird
eventuell an die ``addPage()`` Methode der Container Klasse übergeben, was bedeutet das jedes Element im
Array/Config ein Array oder Config Objekt sein kann, oder eine Instanz von ``Zend_Navigation_Page``.

.. _zend.navigation.containers.creating.example.array:

.. rubric:: Erstellt einen Container indem ein Array verwendet wird

.. code-block:: php
   :linenos:

   /*
    * Erstellt einen Container von einem Array
    *
    * Jedes Element im Array wird an Zend_Navigation_Page::factory() übergeben
    * wenn es erstellt wird.
    */
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Seite 1',
           'id' => 'home-link',
           'uri' => '/'
       ),
       array(
           'label' => 'Zend',
           'uri' => 'http://www.zend-project.com/',
           'order' => 100
       ),
       array(
           'label' => 'Seite 2',
           'controller' => 'page2',
           'pages' => array(
               array(
                   'label' => 'Seite 2.1',
                   'action' => 'page2_1',
                   'controller' => 'page2',
                   'class' => 'special-one',
                   'title' => 'Dieses Element hat eine spezielle Klasse',
                   'active' => true
               ),
               array(
                   'label' => 'Seite 2.2',
                   'action' => 'page2_2',
                   'controller' => 'page2',
                   'class' => 'special-two',
                   'title' => 'Dieses Element hat auch eine spezielle Klasse'
               )
           )
       ),
       array(
           'label' => 'Seite 2 mit Parametern',
           'action' => 'index',
           'controller' => 'page2',
           // Spezifiziert einen Parameter oder zwei
           'params' => array(
               'format' => 'json',
               'foo' => 'bar'
           )
       ),
       array(
           'label' => 'Seite 2 mit Parametern und einer Route',
           'action' => 'index',
           'controller' => 'page2',
           // Spezifiziert einen Routen Namen und einen Parameter für die Route
           'route' => 'nav-route-example',
           'params' => array(
               'format' => 'json'
           )
       ),
       array(
           'label' => 'Seite 3',
           'action' => 'index',
           'controller' => 'index',
           'module' => 'mymodule',
           'reset_params' => false
       ),
       array(
           'label' => 'Seite 4',
           'uri' => '#',
           'pages' => array(
               array(
                   'label' => 'Seite 4.1',
                   'uri' => '/page4',
                   'title' => 'Seite 4 mit Verwendung von URI',
                   'pages' => array(
                       array(
                           'label' => 'Seite 4.1.1',
                           'title' => 'Seite 4 mit Verwendung von MVC Parametern',
                           'action' => 'index',
                           'controller' => 'page4',
                           // Sagen wir das diese Seite aktiv ist
                           'active' => '1'
                       )
                   )
               )
           )
       ),
       array(
           'label' => 'Seite 0?',
           'uri' => '/setting/the/order/option',
           // Setzt die Reihenfolge auf -1, damit Sie als erstes erscheint
           'order' => -1
       ),
       array(
           'label' => 'Seite 5',
           'uri' => '/',
           // Diese Seite sollte nicht sichtbar sein
           'visible' => false,
           'pages' => array(
               array(
                   'label' => 'Seite 5.1',
                   'uri' => '#',
                   'pages' => array(
                       array(
                           'label' => 'Seite 5.1.1',
                           'uri' => '#',
                           'pages' => array(
                               array(
                                   'label' => 'Seite 5.1.2',
                                   'uri' => '#',
                                   // Sagen wir das die Seite aktiv ist
                                   'active' => true
                               )
                           )
                       )
                   )
               )
           )
       ),
       array(
           'label' => 'ACL Seite 1 (guest)',
           'uri' => '#acl-guest',
           'resource' => 'nav-guest',
           'pages' => array(
               array(
                   'label' => 'ACL Seite 1.1 (foo)',
                   'uri' => '#acl-foo',
                   'resource' => 'nav-foo'
               ),
               array(
                   'label' => 'ACL Seite 1.2 (bar)',
                   'uri' => '#acl-bar',
                   'resource' => 'nav-bar'
               ),
               array(
                   'label' => 'ACL Seite 1.3 (baz)',
                   'uri' => '#acl-baz',
                   'resource' => 'nav-baz'
               ),
               array(
                   'label' => 'ACL Seite 1.4 (bat)',
                   'uri' => '#acl-bat',
                   'resource' => 'nav-bat'
               )
           )
       ),
       array(
           'label' => 'ACL Seite 2 (member)',
           'uri' => '#acl-member',
           'resource' => 'nav-member'
       ),
       array(
           'label' => 'ACL Seite 3 (admin)',
           'uri' => '#acl-admin',
           'resource' => 'nav-admin',
           'pages' => array(
               array(
                   'label' => 'ACL Seite 3.1 (nothing)',
                   'uri' => '#acl-nada'
               )
           )
       ),
       array(
           'label' => 'Zend Framework',
           'route' => 'zf-route'
       )
   ));

.. _zend.navigation.containers.creating.example.config:

.. rubric:: Erstellung eines Containers indem ein Config Objekt erstellt wird

.. code-block:: php
   :linenos:

   /* INHALT VON /path/to/navigation.xml:
   <?xml version="1.0" encoding="UTF-8"?>
   <config>
       <nav>

           <zend>
               <label>Zend</label>
               <uri>http://www.zend-project.com/</uri>
               <order>100</order>
           </zend>

           <page1>
               <label>Seite 1</label>
               <uri>page1</uri>
               <pages>

                   <page1_1>
                       <label>Seite 1.1</label>
                       <uri>page1/page1_1</uri>
                   </page1_1>

               </pages>
           </page1>

           <page2>
               <label>Seite 2</label>
               <uri>page2</uri>
               <pages>

                   <page2_1>
                       <label>Seite 2.1</label>
                       <uri>page2/page2_1</uri>
                   </page2_1>

                   <page2_2>
                       <label>Seite 2.2</label>
                       <uri>page2/page2_2</uri>
                       <pages>

                           <page2_2_1>
                               <label>Seite 2.2.1</label>
                               <uri>page2/page2_2/page2_2_1</uri>
                           </page2_2_1>

                           <page2_2_2>
                               <label>Seite 2.2.2</label>
                               <uri>page2/page2_2/page2_2_2</uri>
                               <active>1</active>
                           </page2_2_2>

                       </pages>
                   </page2_2>

                   <page2_3>
                       <label>Seite 2.3</label>
                       <uri>page2/page2_3</uri>
                       <pages>

                           <page2_3_1>
                               <label>Seite 2.3.1</label>
                               <uri>page2/page2_3/page2_3_1</uri>
                           </page2_3_1>

                           <page2_3_2>
                               <label>Seite 2.3.2</label>
                               <uri>page2/page2_3/page2_3_2</uri>
                               <visible>0</visible>
                               <pages>

                                       <page2_3_2_1>
                                           <label>Seite 2.3.2.1</label>
                                           <uri>page2/page2_3/page2_3_2/1</uri>
                                           <active>1</active>
                                       </page2_3_2_1>

                                       <page2_3_2_2>
                                           <label>Seite 2.3.2.2</label>
                                           <uri>page2/page2_3/page2_3_2/2</uri>
                                           <active>1</active>

                                           <pages>
                                               <page_2_3_2_2_1>
                                                   <label>Ignoriert</label>
                                                   <uri>#</uri>
                                                   <active>1</active>
                                               </page_2_3_2_2_1>
                                           </pages>
                                       </page2_3_2_2>

                               </pages>
                           </page2_3_2>

                           <page2_3_3>
                               <label>Seite 2.3.3</label>
                               <uri>page2/page2_3/page2_3_3</uri>
                               <resource>admin</resource>
                               <pages>

                                       <page2_3_3_1>
                                           <label>Seite 2.3.3.1</label>
                                           <uri>page2/page2_3/page2_3_3/1</uri>
                                           <active>1</active>
                                       </page2_3_3_1>

                                       <page2_3_3_2>
                                           <label>Seite 2.3.3.2</label>
                                           <uri>page2/page2_3/page2_3_3/2</uri>
                                           <resource>guest</resource>
                                           <active>1</active>
                                       </page2_3_3_2>

                               </pages>
                           </page2_3_3>

                       </pages>
                   </page2_3>

               </pages>
           </page2>

           <page3>
               <label>Seite 3</label>
               <uri>page3</uri>
               <pages>

                   <page3_1>
                       <label>Seite 3.1</label>
                       <uri>page3/page3_1</uri>
                       <resource>guest</resource>
                   </page3_1>

                   <page3_2>
                       <label>Seite 3.2</label>
                       <uri>page3/page3_2</uri>
                       <resource>member</resource>
                       <pages>

                           <page3_2_1>
                               <label>Seite 3.2.1</label>
                               <uri>page3/page3_2/page3_2_1</uri>
                           </page3_2_1>

                           <page3_2_2>
                               <label>Seite 3.2.2</label>
                               <uri>page3/page3_2/page3_2_2</uri>
                               <resource>admin</resource>
                           </page3_2_2>

                       </pages>
                   </page3_2>

                   <page3_3>
                       <label>Seite 3.3</label>
                       <uri>page3/page3_3</uri>
                       <resource>special</resource>
                       <pages>

                           <page3_3_1>
                               <label>Seite 3.3.1</label>
                               <uri>page3/page3_3/page3_3_1</uri>
                               <visible>0</visible>
                           </page3_3_1>

                           <page3_3_2>
                               <label>Seite 3.3.2</label>
                               <uri>page3/page3_3/page3_3_2</uri>
                               <resource>admin</resource>
                           </page3_3_2>

                       </pages>
                   </page3_3>

               </pages>
           </page3>

           <home>
               <label>Home</label>
               <order>-100</order>
               <module>default</module>
               <controller>index</controller>
               <action>index</action>
           </home>

       </nav>
   </config>
    */

   $config = new Zend_Config_Xml('/path/to/navigation.xml', 'nav');
   $container = new Zend_Navigation($config);

.. _zend.navigation.containers.adding:

Hinzufügen von Seiten
---------------------

Das Hinzufügen von Seiten in einen Container kann mit den Methoden ``addPage()``, ``addPages()`` oder
``setPages()`` durchgeführt werden. Das folgende Beispiel zeigt eine Erklärung des ganzen.

.. _zend.navigation.containers.adding.example:

.. rubric:: Hinzufügen von Seiten zu einem Container

.. code-block:: php
   :linenos:

   // Container erstellen
   $container = new Zend_Navigation();

   // Seite durch die Angabe eine Instanz einer Page hinzufügen
   $container->addPage(Zend_Navigation_Page::factory(array(
       'uri' => 'http://www.example.com/'
   )))

   // Seite durch die Angabe eines Arrays hinzufügen
   $container->addPage(array(
       'uri' => 'http://www.example.com/'
   )))

   // Seite durch die Angabe eines Config Objekts hinzufügen
   $container->addPage(new Zend_Config(array(
       'uri' => 'http://www.example.com/'
   )))

   $pages = array(
       array(
           'label'  => 'Speichern'
           'action' => 'save',
       ),
       array(
           'label' =>  'Löschen',
           'action' => 'delete'
       )
   );

   // Zwei Seiten hinzufügen
   $container->addPages($pages);

   // Bestehende Seite entfernen und die gegebenen Seiten hinzufügen
   $container->setPages($pages);

.. _zend.navigation.containers.removing:

Seiten löschen
--------------

Das Löschen von Seiten kann mit ``removePage()`` oder ``removePages()`` durchgeführt werden. Die ersten Methode
akzeptiert eine Instanz einer Seite, oder ein Integer. Der Integer korrespondiert mit der ``order`` welche die
Seite hat. Die letztere Methode entfernt alle Seiten vom Container.

.. _zend.navigation.containers.removing.example:

.. rubric:: Seiten von einem Container entfernen

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label'  => 'Seite 1',
           'action' => 'page1'
       ),
       array(
           'label'  => 'Seite 2',
           'action' => 'page2',
           'order'  => 200
       ),
       array(
           'label'  => 'Seite 3',
           'action' => 'page3'
       )
   ));

   // Entfernt eine Seite implizit durch die Reihenfolge der Seite
   $container->removePage(0);      // Entfernt Seite 1

   // Entfernt eine Seite durch die Instanz
   $page3 = $container->findOneByAction('page3');
   $container->removePage($page3); // Entfernt Seite 3

   // Entfernt eine Seite durch explizite angabe der Reihenfolge der Seite
   $container->removePage(200);    // Entfernt Seite 2

   // Entfernt alle Seiten
   $container->removePages();      // Entfernt alle Seiten

.. _zend.navigation.containers.finding:

Seiten finden
-------------

Container haben Finder Methoden für das Empfangen von Seiten. Es gibt ``findOneBy($property, $value)``,
``findAllBy($property, $value)`` und ``findBy($property, $value, $all = false)``. Diese Methoden durchsuchen
rekursiv den Container nach Seiten die dem angegebenen ``$page->$property == $value`` entsprechen. Die erste
Methode, ``findOneBy()``, gibt eine einzelne Seite zurück die der angegebenen Eigenschaft mit dem angegebenen Wert
entspricht, oder ``NULL`` wenn Sie nicht gefunden werden kann. Die zweite Methode wird alle Seiten mit einer
Eigenschaft zurückgeben die dem angegebenen Wert entspricht. Die dritte Methode wird eine eine der zwei anderen
Methoden aufrufen, abhängig vom ``$all`` Flag.

Die Finder Methoden können auch magisch verwendet werden indem der Name der Eigenschaft an ``findBy``,
``findOneBy`` oder ``findAllBy`` angehängt wird, z.B. ``findOneByLabel('Home')`` um die erste passende Seite mit
dem Label 'Home' zu finden. Andere Kombinationen sind ``findByLabel(...)``, ``findOnyByTitle(...)``,
``findAllByController(...)``, usw. Finder Methoden funktionieren auch mit eigenen Eigenschaften, so wie z.B.
``findByFoo('bar')``.

.. _zend.navigation.containers.finding.example:

.. rubric:: Seiten in einem Container finden

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label' => 'Seite 1',
           'uri'   => 'page-1',
           'foo'   => 'bar',
           'pages' => array(
               array(
                   'label' => 'Seite 1.1',
                   'uri'   => 'page-1.1',
                   'foo'   => 'bar',
               ),
               array(
                   'label' => 'Seite 1.2',
                   'uri'   => 'page-1.2',
                   'class' => 'my-class',
               ),
               array(
                   'type'   => 'uri',
                   'label'  => 'Seite 1.3',
                   'uri'    => 'page-1.3',
                   'action' => 'about'
               )
           )
       ),
       array(
           'label'      => 'Seite 2',
           'id'         => 'page_2_and_3',
           'class'      => 'my-class',
           'module'     => 'page2',
           'controller' => 'index',
           'action'     => 'page1'
       ),
       array(
           'label'      => 'Seite 3',
           'id'         => 'page_2_and_3',
           'module'     => 'page3',
           'controller' => 'index'
       )
   ));

   // Die 'id' muß nicht eindeutig sein, aber man sollte darauf achten das wenn
   // man zwei Seiten mit der gleichen Id hat, diese die gleichen Id Attribute in
   // Menüs und Breadcrumbs darstellen werden
   $found = $container->findBy('id',
                               'page_2_and_3');      // Gibt Seite 2 zurück
   $found = $container->findOneBy('id',
                                  'page_2_and_3');   // Gibt Seite 2 zurück
   $found = $container->findBy('id',
                               'page_2_and_3',
                               true);                // Gibt Seite 2 und 3 zurück
   $found = $container->findById('page_2_and_3');    // Gibt Seite 2 zurück
   $found = $container->findOneById('page_2_and_3'); // Gibt Seite 2 zurück
   $found = $container->findAllById('page_2_and_3'); // Gibt Seite 2 und 3 zurück

   // Finde alle zu my-class passenden CSS Klassen
   $found = $container->findAllBy('class',
                                  'my-class');      // Gibt Seite 1.2 und 2 zurück
   $found = $container->findAllByClass('my-class'); // Gibt Seite 1.2 und 2 zurück

   // Finde die erste zu my-class passende CSS Klasse
   $found = $container->findOneByClass('my-class'); // Gibt Seite 1.2 zurück

   // Findet alle zu non-existant passenden CSS Klassen
   $found = $container->findAllByClass('non-existant'); // Gibt array() zurück

   // Findet die erste zu non-existant passende CSS Klasse
   $found = $container->findOneByClass('non-existant'); // Gibt null zurück

   // Findet alle Seiten mit den eigenen Eigenschaften 'foo' = 'bar'
   $found = $container->findAllBy('foo', 'bar'); // Gibt Seite 1 und 1.1 zurück

   // Um das gleiche auf Magische Weise zu ermöglichen, muß 'foo' kleingeschrieben
   // sein weil 'foo' eine eigene Eigenschaft ist und deshalb der Name der
   // Eigenschaft nicht zu 'Foo' normalisiert wird
   $found = $container->findAllByfoo('bar');

   // Findet alle mit controller = 'index'
   $found = $container->findAllByController('index'); // Gibt Seite 2 und 3 zurück

.. _zend.navigation.containers.iterating:

Container durchsuchen
---------------------

``Zend_Navigation_Container`` implementiert ``RecursiveIteratorIterator``, und kann mit jeder ``Iterator`` Klasse
durchsucht werden. Um einen Container rekursiv zu durchsuchen, kann die ``RecursiveIteratorIterator`` Klasse
verwendet werden.

.. _zend.navigation.containers.iterating.example:

.. rubric:: Einen Container durchsuchen

.. code-block:: php
   :linenos:

   /*
    * Erstellt einen Container von einem Array
    */
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Seite 1',
           'uri'   => '#'
       ),
       array(
           'label' => 'Seite 2',
           'uri'   => '#',
           'pages' => array(
               array(
                   'label' => 'Seite 2.1',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Seite 2.2',
                   'uri'   => '#'
               )
           )
       )
       array(
           'label' => 'Seite 3',
           'uri'   => '#'
       )
   ));

   // Durchsucht flach indem ein normales foreach verwendet wird:
   // Ausgabe: Seite 1, Seite 2, Seite 3
   foreach ($container as $page) {
       echo $page->label;
   }

   // Durchsucht rekursiv indem RecursiveIteratorIterator verwendet wird
   $it = new RecursiveIteratorIterator(
           $container, RecursiveIteratorIterator::SELF_FIRST);

   // Ausgabe: Seite 1, Seite 2, Seite 2.1, Seite 2.2, Seite 3
   foreach ($it as $page) {
       echo $page->label;
   }

.. _zend.navigation.containers.other:

Andere Operationen
------------------

Die Methode ``hasPage(Zend_Navigation_Page $page)`` prüft ob der Container die angegebene Seite besitzt. Die
Methode ``hasPages()`` prüft ob irgendeine Seite im Container existiert, und ist gleich mit ``count($container) >
1``.

Die ``toArray()`` Methode konvertiert den Container und die Seiten in Ihm zu einem Array. Das kann für eine
Serialisierung und das Debugging nützlich sein.

.. _zend.navigation.containers.other.example.toarray:

.. rubric:: Einen Container in ein Array konvertieren

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label' => 'Seite 1',
           'uri'   => '#'
       ),
       array(
           'label' => 'Seite 2',
           'uri'   => '#',
           'pages' => array(
               array(
                   'label' => 'Seite 2.1',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Seite 2.2',
                  'uri'   => '#'
               )
           )
       )
   ));

   var_dump($container->toArray());

   /* Ausgabe:
   array(2) {
     [0]=> array(15) {
       ["label"]=> string(6) "Seite 1"
       ["id"]=> NULL
       ["class"]=> NULL
       ["title"]=> NULL
       ["target"]=> NULL
       ["rel"]=> array(0) {
       }
       ["rev"]=> array(0) {
       }
       ["order"]=> NULL
       ["resource"]=> NULL
       ["privilege"]=> NULL
       ["active"]=> bool(false)
       ["visible"]=> bool(true)
       ["type"]=> string(23) "Zend_Navigation_Page_Uri"
       ["pages"]=> array(0) {
       }
       ["uri"]=> string(1) "#"
     }
     [1]=> array(15) {
       ["label"]=> string(6) "Seite 2"
       ["id"]=> NULL
       ["class"]=> NULL
       ["title"]=> NULL
       ["target"]=> NULL
       ["rel"]=> array(0) {
       }
       ["rev"]=> array(0) {
       }
       ["order"]=> NULL
       ["resource"]=> NULL
       ["privilege"]=> NULL
       ["active"]=> bool(false)
       ["visible"]=> bool(true)
       ["type"]=> string(23) "Zend_Navigation_Page_Uri"
       ["pages"]=> array(2) {
         [0]=> array(15) {
           ["label"]=> string(8) "Seite 2.1"
           ["id"]=> NULL
           ["class"]=> NULL
           ["title"]=> NULL
           ["target"]=> NULL
           ["rel"]=> array(0) {
           }
           ["rev"]=> array(0) {
           }
           ["order"]=> NULL
           ["resource"]=> NULL
           ["privilege"]=> NULL
           ["active"]=> bool(false)
           ["visible"]=> bool(true)
           ["type"]=> string(23) "Zend_Navigation_Page_Uri"
           ["pages"]=> array(0) {
           }
           ["uri"]=> string(1) "#"
         }
         [1]=>
         array(15) {
           ["label"]=> string(8) "Seite 2.2"
           ["id"]=> NULL
           ["class"]=> NULL
           ["title"]=> NULL
           ["target"]=> NULL
           ["rel"]=> array(0) {
           }
           ["rev"]=> array(0) {
           }
           ["order"]=> NULL
           ["resource"]=> NULL
           ["privilege"]=> NULL
           ["active"]=> bool(false)
           ["visible"]=> bool(true)
           ["type"]=> string(23) "Zend_Navigation_Page_Uri"
           ["pages"]=> array(0) {
           }
           ["uri"]=> string(1) "#"
         }
       }
       ["uri"]=> string(1) "#"
     }
   }
   */



.. _`SPL`: http://php.net/spl
