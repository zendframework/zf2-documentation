.. EN-Revision: none
.. _zend.mail.sending:

Отправка через SMTP
===================

Если требуется отправить сообщение электронной почты через
SMTP, то прежде чем будет вызван метод ``send()``, нужно создать и
зарегистрировать в ``Zend_Mail`` объект ``Zend\Mail\Transport\Smtp``. Для всех
последующих вызовов ``Zend\Mail\Mail::send()`` в текущем скрипте будет
использоваться SMTP:

.. _zend.mail.sending.example-1:

.. rubric:: Отправка сообщений через SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail\Transport\Smtp('mail.example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

Метод ``setDefaultTransport()`` и конструктор ``Zend\Mail\Transport\Smtp`` не требуют
большого количества ресурсов при выполнении. Эти две строки
кода могут быть выполнены во время подготовки с тем, чтобы
сконфигурировать поведение класса ``Zend_Mail`` для остальной части
скрипта. Это позволяет хранить конфигурационные данные
отдельно от логики приложения — отправляется ли почта через
SMTP или `mail()`_, какой почтовый сервер используется и т.д.



.. _`mail()`: http://php.net/mail
