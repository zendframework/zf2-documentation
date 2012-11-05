.. EN-Revision: none
.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

Wprowadzenie
------------

*Zend_Mime* jest klasą wspierającą obsługę wielczęściowych wiadomości MIME. Jest ona używana przez klasy
:ref:`Zend_Mail <zend.mail>` oraz :ref:`Zend\Mime\Message <zend.mime.message>` i może być używana przez
aplikacje wymagające wsparcia MIME.

.. _zend.mime.mime.static:

Metody statyczne i stałe
------------------------

*Zend_Mime* zapewnia zbiór prostych statycznych metod do pracy z MIME:

   - *Zend\Mime\Mime::isPrintable()*: Zwraca TRUE jeśli podany łańcuch znaków nie zawiera niedrukowalnych znaków. W
     przeciwnym razie zwraca FALSE.

   - *Zend\Mime\Mime::encodeBase64()*: Koduje łańcuch znaków używając kodowania base64.

   - *Zend\Mime\Mime::encodeQuotedPrintable()*: Koduje łańcuch znaków używając mechanizmu quoted-printable.



*Zend_Mime* definiuje zbiór stałych używanych z wiadomościami MIME:

   - *Zend\Mime\Mime::TYPE_OCTETSTREAM*: 'application/octet-stream'

   - *Zend\Mime\Mime::TYPE_TEXT*: 'text/plain'

   - *Zend\Mime\Mime::TYPE_HTML*: 'text/html'

   - *Zend\Mime\Mime::ENCODING_7BIT*: '7bit'

   - *Zend\Mime\Mime::ENCODING_8BIT*: '8bit';

   - *Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE*: 'quoted-printable'

   - *Zend\Mime\Mime::ENCODING_BASE64*: 'base64'

   - *Zend\Mime\Mime::DISPOSITION_ATTACHMENT*: 'attachment'

   - *Zend\Mime\Mime::DISPOSITION_INLINE*: 'inline'



.. _zend.mime.mime.instantiation:

Tworzenie instancji Zend_Mime
-----------------------------

Kiedy tworzony jest obiekt *Zend_Mime*, zapisywane jest pole rozgraniczające MIME (MIME boundary) i jest ono
używane we wszystkich następnych wywołaniach metod tego obiektu. Jeśli konstruktor jest wywołany z łańcuchem
znaków w parametrze, to ta wartość jest używana jako pole rozgraniczające MIME. W przeciwnym razie generowane
jest losowe pole rozgraniczające.

Obiekt *Zend_Mime* ma takie metody:

   - *boundary()*: Zwraca wartość pola rozgraniczającego MIME.

   - *boundaryLine()*: Zwraca kompletną linię z polem rozgraniczającym MIME.

   - *mimeEnd()*: Zwraca końcową linię z polem rozgraniczającym MIME.




