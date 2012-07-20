.. _zend.feed.consuming-atom-single-entry:

Pobieranie pojedynczego wpisu kanału Atom
=========================================

Pojedyncze elementy *<entry>* kanału Atom są same w sobie poprawne. Zazwyczaj URL do pojedynczego wpisu jest
adresem URL kanału z dodanym identyfikatorem */<entryId>* wpisu, na przykład *http://atom.example.com/feed/1*,
dla przykładowego URL, który był użyty wcześniej.

Gdy odczytujesz pojedynczy wpis, wciąż masz obiekt *Zend_Feed_Atom*, ale automatycznie tworzy on "anonimowy"
kanał zawierający ten wpis.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Odczytywanie pojedynczego wpisu kanału Atom

.. code-block::
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'Kanał zawiera: ' . $feed->count() . ' wspisów.';

   $entry = $feed->current();


Mógłbyś też bezpośrednio utworzyć instancję obiektu wpisu jeśli wiesz, że odczytujesz dokument
pojedynczego wpisu *<entry>*:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Bezpośrednie użycie obiektu wpisu dla pojedynczego wpisu kanału Atom

.. code-block::
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();



