.. EN-Revision: none
.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

Введение
--------

``Zend_Mime`` является вспомогательным классом для работы с
сообщениями *MIME* multipart. Он используется :ref:`Zend_Mail <zend.mail>` и
:ref:`Zend_Mime_Message <zend.mime.message>`, может использоваться в приложениях,
требующих поддержки *MIME*.

.. _zend.mime.mime.static:

Статические методы и константы
------------------------------

``Zend_Mime`` предоставляет простой набор статических методов для
работы с *MIME*:

   - ``Zend_Mime::isPrintable()``: Возвращает TRUE, если переданная строка не
     содержит непечатаемых символов, иначе FALSE.

   - ``Zend_Mime::encodeBase64()``: Кодирует строку по алгоритму base64.

   - ``Zend_Mime::encodeQuotedPrintable()``: Кодирует строку по алгоритму
     quoted-printable.



``Zend_Mime`` определяет набор констант, обычно используемых с
*MIME*-сообщениями:

   - ``Zend_Mime::TYPE_OCTETSTREAM``: 'application/octet-stream'

   - ``Zend_Mime::TYPE_TEXT``: 'text/plain'

   - ``Zend_Mime::TYPE_HTML``: 'text/html'

   - ``Zend_Mime::ENCODING_7BIT``: '7bit'

   - ``Zend_Mime::ENCODING_8BIT``: '8bit'

   - ``Zend_Mime::ENCODING_QUOTEDPRINTABLE``: 'quoted-printable'

   - ``Zend_Mime::ENCODING_BASE64``: 'base64'

   - ``Zend_Mime::DISPOSITION_ATTACHMENT``: 'attachment'

   - ``Zend_Mime::DISPOSITION_INLINE``: 'inline'



.. _zend.mime.mime.instantiation:

Инстанциирование Zend_Mime
--------------------------

При создании объекта ``Zend_Mime`` сохраняется разделитель *MIME*, он
будет использоваться при вызовах нестатических методов
объекта. Если конструктор вызывается со строковым параметром,
то это значение будет использоваться в качестве разделителя
*MIME*, иначе разделитель будет сгенерирован случайным образом
во время выполнения конструктора.

Объект ``Zend_Mime`` имеет следующие методы:

   - ``boundary()``: Возвращает разделитель *MIME*.

   - ``boundaryLine()``: Возвращает полную строку с разделителем *MIME*.

   - ``mimeEnd()``: Возвращает полную завершающую строку с
     разделителем *MIME*.




