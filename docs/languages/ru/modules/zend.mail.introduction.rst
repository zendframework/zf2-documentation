.. EN-Revision: none
.. _zend.mail.introduction:

Введение
========

.. _zend.mail.introduction.getting-started:

Начало работы
-------------

``Zend_Mail`` предоставляет обобщенный функционал для формирования
и отправки как текстовых, так и *MIME*-сообщений электронной
почты. Сообщения могут отправляться через ``Zend\Mail\Transport\Sendmail``
(используется по умолчанию) или через ``Zend\Mail\Transport\Smtp``.

.. _zend.mail.introduction.example-1:

.. rubric:: Простое сообщение электронной почты

Простое сообщение электронной почты состоит из нескольких
получателей, заголовка сообщения, тела сообщения и
отправителя. Чтобы отправить такое сообщение, используя
``Zend\Mail\Transport\Sendmail``, сделайте следующее:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **Минимально необходимые определения**

   Для того, чтобы отправить сообщение через ``Zend_Mail``, вы должны
   указать как минимум одного получателя, отправителя
   (например, с помощью ``setFrom()``) и тело сообщения (текстовое и/или
   в формате HTML).

Для большинства атрибутов сообщений электронной почты есть
методы "get" для чтения информации, сохраненной в объекте
сообщения. За более подробной информацией обратитесь к
*API*-документации. К примеру, метод ``getRecipients()`` возвращает массив
с адресами электронной почты получателей, в порядке их
добавления.

В целях безопасности ``Zend_Mail`` фильтрует все содержимое
заголовков для предотвращения инъекций в заголовки с
использованием символов новой строки (*\n*). В имени отправителя
и именах получателей двойные кавычки заменяются на одинарные,
а угловые скобки на квадратные. Если эти символы находятся в
адресах электронной почты, то они удаляются.

.. _zend.mail.introduction.sendmail:

Конфигурирование транспорта, используемого по умолчанию
-------------------------------------------------------

Для экземпляра ``Zend_Mail`` по умолчанию используется
``Zend\Mail\Transport\Sendmail``. По существу он является оберткой к
*PHP*-функции `mail()`_. Если вы хотите передавать функции `mail()`_
дополнительные параметры, то просто создайте новый экземпляр
транспорта и передайте свои параметры его конструктору. После
этого новый экземпляр транспорта может выступать как
используемый по умолчанию транспорт для ``Zend_Mail``, либо он может
быть передан методу ``send()`` класса ``Zend_Mail``.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Передача дополнительных параметров транспорту Zend\Mail\Transport\Sendmail

Этот пример демонстрирует, как изменить заголовок Return-Path для
функции `mail()`_.

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail\Transport\Sendmail('-freturn_to_me@example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **Ограничения безопасного режима**

   Применение дополнительных параметров приведет к отказу в
   выполнении функции `mail()`_, если *PHP* работает в безопасном
   режиме (safe mode).



.. _`mail()`: http://php.net/mail
