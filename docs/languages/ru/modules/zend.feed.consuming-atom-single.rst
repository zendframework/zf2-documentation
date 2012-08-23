.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

Работа с отдельным сообщением ленты Atom
========================================

Отдельные сообщения Atom'а *<entry>* сами по себе являются валидными.
Обычно URL сообщения состоит из URL ленты и следующим после него ID
сообщения - например, *http://atom.example.com/feed/1* (используется URL,
приведенный ранее в качестве примера).

При чтении отдельного сообщения также создается объект
*Zend_Feed_Atom*, но при этом автоматически создается "анонимная"
лента, содержащая данное сообщение.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Чтение отдельного сообщения ленты Atom

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'The feed has: ' . $feed->count() . ' entry.';

   $entry = $feed->current();


Альтернативно, вы можете непосредственно создавать объект
сообщения, если знаете, что документ, находящийся по данному
адресу, содержит только элемент *<entry>*:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Непосредственное использование объекта сообщения Atom

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();



