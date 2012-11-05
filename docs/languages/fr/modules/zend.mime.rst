.. EN-Revision: none
.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

Introduction
------------

``Zend_Mime`` est une classe de support pour gérer les messages *MIME* en plusieurs parties. Elle est utilisé par
:ref:`Zend_Mail <zend.mail>` et :ref:`Zend\Mime\Message <zend.mime.message>`, est peut-être utilisée dans
l'application qui nécessite un support *MIME*.

.. _zend.mime.mime.static:

Méthodes statiques et constantes
--------------------------------

``Zend_Mime`` fournit un jeu simple de méthodes statiques pour fonctionner avec *MIME*:

   - ``Zend\Mime\Mime::isPrintable()``: retourne ``TRUE`` si la chaine données contient des caractères non
     imprimables. ``FALSE`` dans les autres cas.

   - ``Zend\Mime\Mime::encode()``: encode une chaîne en utilisant l'encodage spécifié.

   - ``Zend\Mime\Mime::encodeBase64()encodeBase64()``: encode une chaîne en utilisant base64.

   - ``Zend\Mime\Mime::encodeQuotedPrintable()``: encode une chaîne avec le mécanisme quoted-printable.

   - ``Zend\Mime\Mime::encodeBase64Header()``: encode une chaîne en utilisant base64 pour les entêtes émail.

   - ``Zend\Mime\Mime::encodeQuotedPrintableHeader()``: ncode une chaîne avec le mécanisme quoted-printable pour les
     entêtes émail.



``Zend_Mime`` définit un jeu de constantes communément utilisé avec des messages *MIME*:

   - ``Zend\Mime\Mime::TYPE_OCTETSTREAM``: "application/octet-stream"

   - ``Zend\Mime\Mime::TYPE_TEXT``: "text/plain"

   - ``Zend\Mime\Mime::TYPE_HTML``: "text/html"

   - ``Zend\Mime\Mime::ENCODING_7BIT``: "7bit"

   - ``Zend\Mime\Mime::ENCODING_8BIT``: "8bit"

   - ``Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE``: "quoted-printable"

   - ``Zend\Mime\Mime::ENCODING_BASE64``: "base64"

   - ``Zend\Mime\Mime::DISPOSITION_ATTACHMENT``: "attachment"

   - ``Zend\Mime\Mime::DISPOSITION_INLINE``: "inline"

   - ``Zend\Mime\Mime::MULTIPART_ALTERNATIVE``: 'multipart/alternative'

   - ``Zend\Mime\Mime::MULTIPART_MIXED``: 'multipart/mixed'

   - ``Zend\Mime\Mime::MULTIPART_RELATED``: 'multipart/related'



.. _zend.mime.mime.instatiation:

Instancier Zend_Mime
--------------------

Lors de l'instanciation d'un objet ``Zend_Mime``, une frontière *MIME* est stockée pour qu'elle soit utilisée
pour tous les appels aux méthodes statiques suivant, sur cet objet. Si le constructeur est appelé avec une
chaîne en paramètre, cette valeur sera utilisée comme frontière *MIME*. Sinon, une frontière *MIME* aléatoire
sera générée lors de la construction.

Un objet ``Zend_Mime`` contient les méthodes suivantes :

   - ``boundary()``: retourne la frontière *MIME*.

   - ``boundaryLine()``: retourne la ligne complète de la frontière *MIME*.

   - ``mimeEnd()``: retourne la fin de la frontière *MIME* complète.




