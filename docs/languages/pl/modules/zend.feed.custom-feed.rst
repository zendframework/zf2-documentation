.. EN-Revision: none
.. _zend.feed.custom-feed:

Własne klasy kanału i wpisu
===========================

Ostatecznie możesz rozszerzyć klasę *Zend_Feed* jeśli chcesz stworzyć swój własny format lub zapewnić
automatyczną obsługę elementów, które działają w innej przestrzeni nazw.

Oto przykład własnej klasy wpisu Atom która obsługuje własną przestrzeń nazw *myns:* wpisów. Zauważ, że
ona także wywołuje za Ciebie metodę *registerNamespace()*, dzięki czemu użytkownik końcowy nie musi w ogóle
martwić się o przestrzenie nazw.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Rozszerzanie klasy wpisu Atom z własnymi przestrzeniami nazw

.. code-block:: php
   :linenos:

   /**
    * Własna klasa wpisu może automatycznie nadawać adres URI (opcjonalnie)
    * oraz automatycznie dodawać dodatkowe przestrzenie nazw.
    */
   class MyEntry extends Zend\Feed_Entry\Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend\Feed\Feed::registerNamespace('myns',
                                        'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Tłumaczy myUpdated na myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Tłumaczy myUpdated na myns:updated.
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
                   // Tłumaczy myUpdated na myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }

   }


Teraz aby użyć tej klasy, musisz po prostu bezpośrednio utworzyć jej instancję i przypisać wartość
właściwości *myUpdated*:

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // wywołanie w stylu metody jest obsługiwane przez funkcję __call
   $entry->myUpdated();
   // wywołanie w stylu właściwości jest obsługiwane przez funkcję __get
   $entry->myUpdated;



