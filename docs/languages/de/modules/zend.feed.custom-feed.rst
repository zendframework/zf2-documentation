.. _zend.feed.custom-feed:

Eigene Klassen für Feeds und Einträge
=====================================

Schließlich kannst du die ``Zend_Feed`` Klasse erweitern, wenn du dein eigenes Format oder Feinheiten wie die
automatische Verarbeitung von Elementen, die in deinen eigenen Namensraum enthalten sein sollen, bereit stellen
möchtest

Hier ist ein Beispiel einer eigenen Klasse für Atom Einträge, die ihre eigenen Elemente für den **myns:**
Namensraum verwendet. Beachte, dass sie auch den ``registerNamespace()`` Aufruf für dich durchführt, so dass sich
der Endbenutzer nicht um Namensräume kümmern muss.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Die Klasse für Atom Einträge mit einem eigenen Namensraum erweitern

.. code-block:: php
   :linenos:

   /**
    * Die eigene Klasse für Einträge kennt automatisch die Feed URI (optional)
    * und kann automatisch weitere Namensräume hinzufügen
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
                   // Übersetze myUpdated nach myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Übersetze myUpdated nach myns:updated.
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
                   // Übersetze myUpdated zu myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

Um diese Klasse zu verwenden, musst du sie nur direkt instanziieren und die ``myUpdated`` Eigenschaft setzen.

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // Methoden-Stil Aufruf wird von der _call Methode gehandhabt
   $entry->myUpdated();
   // Eigenschaften-Stil Aufruf wurd von der __get Methode gehandhabt
   $entry->myUpdated;


