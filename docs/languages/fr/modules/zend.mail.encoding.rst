.. EN-Revision: none
.. _zend.mail.encoding:

Encodage
========

Par défaut, le corps des messages textes et HTML est encodé via le mécanisme "quoted-printable". Les en-têtes
du message sont aussi encodés avec le mécanisme "quoted-printable" si vous ne spécifiez pas base64 avec
``setHeaderEncoding()``. Si vous utilisez une langue qui n'est pas sur des lettres de type romaines, la base64 sera
plus convenable. Tous les fichiers joints sont encodés via base64 si aucun autre encodage n'est spécifié lors de
l'appel à ``addAttachment()`` ou assigné plus tard à la partie *MIME* de l'objet. Les encodages 7Bit et 8Bit ne
se font pour l'instant que sur les données binaires.

L'encodage des en-têtes, spécialement l'encodage du sujet, est toujours délicat. ``Zend_Mime`` implémente
actuellement son propre algorithme pour encoder les en-têtes "quoted-printable" suivant la RFC-2045. Ceci est du
à un problème des fonctions *iconv_mime_encode* et *mb_encode_mimeheader* avec certaines tables de caractères.
Cet algorithme ne coupe les en-têtes qu'au niveau des espaces, ce qui peut entraîner des problèmes quand la
longueur excède la longueur de 76 caractères. Dans ce cas, il est suggéré de basculer en encodage BASE64 pour
les en-têtes comme décrit dans les exemples suivants :

.. code-block:: php
   :linenos:

   // Par défaut Zend_Mime::ENCODING_QUOTEDPRINTABLE
   $mail = new Zend_Mail('KOI8-R');

   // Bascule en encodage Base64 parce que le Russe exprimé en KOI8-R est
   // considérablement différent des langues basées sur des lettres romaines
   $mail->setHeaderEncoding(Zend_Mime::ENCODING_BASE64);

``Zend_Mail_Transport_Smtp`` encode les lignes commençant par un ou deux points, ainsi l'émail ne viole pas le
protocole SMTP.


