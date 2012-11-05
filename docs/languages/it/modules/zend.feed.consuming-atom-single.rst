.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

Lettura di un singolo elemento di un feed Atom
==============================================

I singoli elementi (*<entry>*) di un feed Atom sono validi anche da soli. Di norma l'URL per un elemento di un feed
è l'URL del feed stesso seguito da */<entryId>*, ad esempio *http://atom.example.com/feed/1*, per utilizzare l'URL
citato in precedenza.

Anche se si legge un singolo elemento, si dispone ancora di un valido oggetto *Zend\Feed\Atom*, ma verrà creato un
"anonimo" feed contenente un solo elemento.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Lettura di un feed Atom con un singolo elemento

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   echo 'Il feed contiene: ' . $feed->count() . ' elemento.';

   $entry = $feed->current();
In alternativa, è possibile creare direttamente un'istanza di un oggetto per l'elemento se si accede ad un singolo
nodo *<entry>*:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Utilizzo diretto dell'oggetto Entry per un singolo elemento del feed Atom

.. code-block:: php
   :linenos:

   <?php

   $entry = new Zend\Feed_Entry\Atom('http://atom.example.com/feed/1');
   echo $entry->title();

