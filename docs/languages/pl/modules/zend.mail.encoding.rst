.. _zend.mail.encoding:

Kodowanie
=========

Treści wiadomości w formacie Text oraz HTML są domyślnie kodowane przy użyciu mechanizmu quotedprintable.
Wszystkie inne załączniki są kodowane za pomocą base64 jeśli inne kodowanie nie zostało wybrane podczas
wywołania metody *addAttachment()* lub nie zostało później dodane do obiektu MIME. Kodowania 7Bit oraz 8Bit
obecnie działają jedynie z danymi binarnymi.

*Zend_Mail_Transport_Smtp* koduje linie zaczynając je jedną lub dwoma kropkami, więc wiadomość nie łamie
zasad protokołu SMTP.


