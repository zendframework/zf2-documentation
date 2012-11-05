.. EN-Revision: none
.. _zend.feed.modifying-feed:

Изменение структуры лент и их сообщений
=======================================

Естетственный синтаксис *Zend_Feed* используется для создания и
изменения лент и записей так же, как и для их чтения. Вы можете
легко преобразовывать свои новые или измененные объекты
обратно в синтаксически корректный XML для сохранения в файл
или отправки серверу.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Изменение существующего сообщения в ленте

.. code-block:: php
   :linenos:

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'This is a new title';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();


Это выведет полное (включая вступление *<?xml ... >*)
XML-представление новой публикации, включающее в себя
необходимые пространства имен XML.

Обратите внимание на то, что вышеприведенный код будет
работать даже если существующая запись не имеет тег *<author>*. Для
присвоения вы можете использовать столько уровней доступа
через *->*, сколько для получения; все промежуточные уровни
будут созданы автоматически, если необходимо.

Если вы хотите использовать в своих сообщениях пространство
имен, отличное от *atom:*, *rss:* или *osrss:*, то вам нужно
зарегистрировать его через *Zend_Feed*, используя метод
*Zend\Feed\Feed::registerNamespace()*. Когда вы изменяете существующий элемент, он
всегда будет сохранять свое исходное пространство имен. Когда
вы добавляете новый элемент, то он будет включен в
пространство имен по умолчанию, если не было указано явно
другое пространство имен.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Создание сообщения Atom с элементами в специальном пространстве имен

.. code-block:: php
   :linenos:

   $entry = new Zend\Feed_Entry\Atom();
   // id уже присвоен сервером
   $entry->title = 'my custom entry';
   $entry->author->name = 'Example Author';
   $entry->author->email = 'me@example.com';

   // теперь выполнение специальной части
   Zend\Feed\Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'my first custom value';
   $entry->{'myns:container_elt'}->part1 = 'first nested custom part';
   $entry->{'myns:container_elt'}->part2 = 'second nested custom part';

   echo $entry->saveXML();



