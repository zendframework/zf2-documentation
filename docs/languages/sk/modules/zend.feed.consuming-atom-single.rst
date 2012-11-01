.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

Získanie jednej položky z Atom
==============================

Jednotlivé položky Atom (*<entry>*) sú validné aj samé o sebe. Zvyčajne je URL týchto položiek nasledované
*/<entryId>*, ako napríklad URL *http://atom.example.com/feed/1*, ktoré sa bude ďalej používať v príkladoch.

Ak získate jednu položku, stále budete mať *Zend\Feed\Atom* objekt, ale automaticky bude vytvorený "anonymný"
zdroj, ktorý bude obsahovať túto položku.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Získanie jednej položky z Atom

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   echo 'The feed has: ' . $feed->count() . ' entry.';

   $entry = $feed->current();

   ?>
Eventuálne je možné vytvoriť inštanciu objektu položky priamo ak je známe, že sa pristupuje k
jednopoložkovému dokumentu:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Použitie objektu položky pre získanie položky z Atom zdroja

.. code-block:: php
   :linenos:

   <?phpi
   $entry = new Zend\Feed_Entry\Atom('http://atom.example.com/feed/1');
   echo $entry->title();

   ?>

