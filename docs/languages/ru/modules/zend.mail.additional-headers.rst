.. EN-Revision: none
.. _zend.mail.additional-headers:

Дополнительные заголовки
========================

Любые заголовки сообщений электронной почты могут быть
установлены с помощью метода ``addHeader()``. Он требует передачи
двух параметров, содержащих имя и значение поля заголовка.
Третий необязательный параметр определяет, должен ли
заголовок иметь одно или несколько значений:

.. _zend.mail.additional-headers.example-1:

.. rubric:: Добавление заголовков сообщений

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // Несколько
   $mail->addHeader('X-greetingsTo', 'Dad', true);

Для установки заголовка Reply-To существует отдельный метод
``setReplyTo($email, $name=null)``, поскольку требуется дополнительное
экранирование различных частей (e-mail и имя).


