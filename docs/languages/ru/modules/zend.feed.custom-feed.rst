.. EN-Revision: none
.. _zend.feed.custom-feed:

Создание собственных классов лент и записей
===========================================

Вы можете наследовать классы *Zend_Feed*, если хотите обеспечить
собственный формат или такие улучшения, как автоматическая
обработка элементов, которые должны находиться в специальном
пространстве имен.

Здесь приведен пример специального класса сообщения Atom,
который управляет сообщениями в собственным пространстве
имен *myns:*. Обратите внимание, что он автоматически производит
вызов *registerNamespace()*, так что конечным пользователям не нужно
будет беспокоиться о пространствах имен.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Расширение класса сообщения Atom с добавлением специальных пространств имен

.. code-block:: php
   :linenos:

   /**
    * Специальный класс сообщения знает URI ленты и может автоматически
    * добавлять дополнительные пространства имен
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
                   // преобразование myUpdated в myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // преобразование myUpdated в myns:updated.
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
                   // преобразование myUpdated в myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }


Далее для использования этого класса просто создаете его
экземпляр и устанавливаете свойство *myUpdated*:

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // вызов в виде метода обрабатывается функцией __call
   $entry->myUpdated();
   // вызов в виде свойства обрабатывается функцией __get
   $entry->myUpdated;



