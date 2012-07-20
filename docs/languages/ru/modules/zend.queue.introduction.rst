.. _zend.queue.introduction:

Введение
========

``Zend_Queue`` представляет собой фабрику для создания подключений к
очередям сообщений.

Очередь сообщений – это средство для распределенной
обработки данных. Например, приложение для поиска работы может
принимать резюме из множества различных источников.

Вы можете создать очередь "``/queue/applications``", у которой будут
отправитель и получатель. Отправителем может быть любой
источник информации, который может подключаться к службе
сообщений либо напрямую, либо через приложение, имеющее доступ
к ней.

Отправитель отсылает сообщение в очередь:

.. code-block:: xml
   :linenos:

   <resume>
       <name>Вася Пупкин</name>
       <location>
           <city>Москва</city>
           <state>Московская область</state>
       </location>
       <skills>
           <programming>PHP</programming>
           <programming>Perl</programming>
       </skills>
   </resume>

Получатель или обработчик очереди получает сообщение и
обработает данные из резюме.

Существует много паттернов, которые могут быть применены к
очередям сообщений для того, чтобы абстрагировать поток
сообщений от кода и предоставить метрики, трансформации и
мониторинг очередей сообщений. `Enterprise Integration Patterns: Designing, Building,
and Deploying Messaging Solutions (Addison-Wesley Signature Series)`_ (ISBN-10 0321127420; ISBN-13 978-0321127426)
- хорошая книга об использовании очередей сообщений.



.. _`Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions (Addison-Wesley Signature Series)`: http://www.amazon.com/Enterprise-Integration-Patterns-Designing-Addison-Wesley/dp/0321200683
