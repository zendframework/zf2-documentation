.. EN-Revision: none
.. _zend.mail.different-transports:

Использование различных транспортов
===================================

В том случае, если вы хотите отправлять различные сообщения
через различные соединения, вы можете напрямую передавать
объект транспорта методу ``send()`` без предшествующего вызова
``setDefaultTransport()``. Для текущего запроса ``send()`` переданный объект
заменит собой транспорт, используемый по умолчанию:

.. _zend.mail.different-transports.example-1:

.. rubric:: Использование различных транспортов

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // построение сообщения...
   $tr1 = new Zend_Mail_Transport_Smtp('server@example.com');
   $tr2 = new Zend_Mail_Transport_Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // опять используется транспорт по умолчанию

.. note::

   **Дополнительные транспорты**

   Дополнительные транспорты могут быть написаны посредством
   реализации интерфейса *Zend_Mail_Transport_Interface*.


