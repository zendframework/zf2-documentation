.. _zend.feed.custom-feed:

Aangepaste Feed en Entry klassen
================================

Naast dit alles is het ook mogelijk om de *Zend_Feed* klassen uit te breiden wanneer je een eigen formaat of
extra's wil aanbieden, zoals automatisch afhandelen van elementen in een aangepaste namespace.

Hier is een voorbeeld van een aangepaste Atom entry klasse die zijn eigen *myns:* namespace behandeld. Merk op dat
het ook de oproep *registerNamespace()* voor je afhandelt, zodanig dat de eindgebruiker zich helemaal niet met
namespaces hoeft bezig te houden.

.. rubric:: De Atom Entry Class uitbreiden met aangepaste Namespaces

.. code-block:: php
   :linenos:

   <?php

   /**
    * De aangepaste entry klasse kent automatisch de feed URI (optioneel) en
    * kan automatisch extra namespaces toevoegen.
    */
   class MyEntry extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Vertaal myUpdated naar myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Vertaal myUpdated naar myns:updated.
                   parent::__set('myns:updated', $value);
                   break;

               default:
                   parent::__set($var, $value);
           }
       }

   }

   ?>
Om deze klasse nu te gebruiken moet je ze gewoon direct instantiëren en de *myUpdated* eigenschap zetten:

.. code-block:: php
   :linenos:

   <?php

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   ?>

