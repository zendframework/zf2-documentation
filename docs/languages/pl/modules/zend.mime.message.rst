.. EN-Revision: none
.. _zend.mime.message:

Zend_Mime_Message
=================

.. _zend.mime.message.introduction:

Wprowadzenie
------------

*Zend_Mime_Message* reprezetuje wiadomość zgodną z MIME, która zawiera jedną lub więcej odrębnych części
(Reprezentowanych przez obiekty :ref:`Zend_Mime_Part <zend.mime.part>`). Klasa *Zend_Mime_Message*, może
wygenerować wieloczęściowe wiadomości zgodne z MIME z obiektów *Zend_Mime_Part*. Kodowanie i obsługa pól
rozgraniczających są obsługiwane przez samą klasę. Obiekty *Zend_Mime_Message* mogą być także
zrekonstruowane z podanych łańcuchów znaków (eksperymentalne). Klasa używana jest przez :ref:`Zend_Mail
<zend.mail>`.

.. _zend.mime.message.instantiation:

Tworzenie instancji
-------------------

*Zend_Mime_Message* nie posiada konstruktora.

.. _zend.mime.message.addparts:

Dodawanie części MIME
---------------------

Obiekty :ref:`Zend_Mime_Part <zend.mime.part>` mogą być dodane poprzez ich przekazanie do obiektu
*Zend_Mime_Message* za pomocą metody *->addPart($part)*

Tablica z wszystkimi obiektami :ref:`Zend_Mime_Part <zend.mime.part>` z wiadomości *Zend_Mime_Message* jest zwraca
za pomocą metody *->getParts()*. Obiekty Zend_Mime_Part mogą być wtedy zmienione ponieważ są one przechowywane
w tablicy jako referencje. Jeśli jakieś części są dodane do tablicy lub zmieniona jest ich kolejność,
konieczne jest przekazanie tablicy spowrotem do :ref:`Zend_Mime_Part <zend.mime.part>` poprzez wywolanie
*->setParts($partsArray)*.

Funkcja *->isMultiPart()* zwróci wartość true jeśli w obiekcie *Zend_Mime_Message* zarejestrowanych jest
więcej części niż jedna. Wtedy gdy obiekt będzie generował wyjściową wiadomość, wygeneruje ją jako
wieloczęściową wiadomość MIME.

.. _zend.mime.message.bondary:

Obsługa pola rozgraniczającego (boundary)
-----------------------------------------

*Zend_Mime_Message* zazwyczaj tworzy obiekt *Zend_Mime* i używa go do tworzenia pola rozgraniczającego. Jeśli
chcesz zdefiniować pole samodzielnie lub chcesz zmienić zachowanie obiektu *Zend_Mime* używanego przez
*Zend_Mime_Message*, możesz utworzyć instancję obiektu *Zend_Mime* samodzielnie i potem zarejestrować ją do
obiekcie *Zend_Mime_Message*. Zazwyczaj jednak nie jest to potrzebne. *->setMime(Zend_Mime $mime)* ustawia
specjalną instancję *Zend_Mime* która ma być używana przez obiekt *Zend_Mime_Message*

*->getMime()* zwraca instancję *Zend_Mime* która będzie użyta do renderowania wiadomości przez wywołanie
metody *generateMessage()*.

*->generateMessage()* renderuje wiadomość *Zend_Mime_Message* do postaci łańcuchu znaków.

.. _zend.mime.message.parse:

Tworzenie obiektu Zend_Mime_Message z łańcucha znaków. (eksperymentalne)
------------------------------------------------------------------------

Wiadomość zgodna z MIME zapisana w postaci łańcucha znaków może być użyta do zrekonstruowania obiektu
*Zend_Mime_Message*. *Zend_Mime_Message* ma statyczną fabrykę przetwarzającą podany łańcuch znaków i
następnie zwracającą obiekt *Zend_Mime_Message*.

*Zend_Mime_Message::createFromMessage($str, $boundary)* dekoduje podany łańcuch znaków i zwraca obiekt
*Zend_Mime_Message*. Jego poprawność może być następnie sprawdzona przez użycie metody *->getParts()*


