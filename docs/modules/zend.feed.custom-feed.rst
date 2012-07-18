.. _zend.feed.custom-feed:

Custom Feed and Entry Classes
=============================

Finally, you can extend the ``Zend_Feed`` classes if you'd like to provide your own format or niceties like automatic handling of elements that should go into a custom namespace.

Here is an example of a custom Atom entry class that handles its own **myns:** namespace entries. Note that it also makes the ``registerNamespace()`` call for you, so the end user doesn't need to worry about namespaces at all.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Extending the Atom Entry Class with Custom Namespaces

.. code-block:: php
   :linenos:

   /**
    * The custom entry class automatically knows the feed URI (optional) and
    * can automatically add extra namespaces.
    */
   class MyEntry extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend_Feed::registerNamespace('myns',
                                        'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   parent::__set('myns:updated', $value);
                   break;

               default:
                   parent::__set($var, $value);
           }
       }

       public function __call($var, $unused)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

Then to use this class, you'd just instantiate it directly and set the ``myUpdated`` property:

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // method-style call is handled by __call function
   $entry->myUpdated();
   // property-style call is handled by __get function
   $entry->myUpdated;


