.. EN-Revision: none
.. _zend.mime.message:

Zend_Mime_Message
=================

.. _zend.mime.message.introduction:

Introduction
------------

``Zend_Mime_Message`` représente un message compatible *MIME* qui peut contenir une ou plusieurs parties
séparées (représentées par des objets :ref:`Zend_Mime_Part <zend.mime.part>`) Avec ``Zend_Mime_Message``, les
messages multiparts compatibles *MIME* peuvent être générés à partir de ``Zend_Mime_Part``. L'encodage et la
gestion des frontières sont gérées de manière transparente par la classe. Les objets ``Zend_Mime_Message``
peuvent aussi être reconstruits à partir de chaînes de caractères données (expérimental). Utilisés par
:ref:`Zend_Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instancier Zend_Mime_Message
----------------------------

Il n'y a pas de constructeur explicite pour ``Zend_Mime_Message``.

.. _zend.mime.message.addparts:

Ajouter des parties MIME
------------------------

Les objets :ref:`Zend_Mime_Part <zend.mime.part>` peuvent êtres ajoutés à un objet ``Zend_Mime_Message`` donné
en appelant *->addPart($part)*.

Un tableau avec toutes les objets :ref:`Zend_Mime_Part <zend.mime.part>` du ``Zend_Mime_Message`` est retourné
dans un tableau grâce à *->getParts()*. Les objets Zend_Mime_Part peuvent ainsi être changés car ils sont
stockés dans le tableau comme références. Si des parties sont ajoutées au tableau, ou que la séquence est
changée, le tableau à besoin d'être retourné à l'objet :ref:`Zend_Mime_Part <zend.mime.part>` en appelant
*->setParts($partsArray)*.

La fonction *->isMultiPart()* retournera ``TRUE`` si plus d'une partie est enregistrée avec l'objet
Zend_Mime_Message, l'objet pourra ainsi régénérer un objet Multipart-Mime-Message lors de la génération de la
sortie.

.. _zend.mime.message.bondary:

Gérer les frontières
--------------------

``Zend_Mime_Message`` crée et utilise généralement son propre objet ``Zend_Mime`` pour générer une frontière.
Si vous avez besoin de définir une frontière ou si vous voulez changer le comportement de l'objet ``Zend_Mime``
utilisé par ``Zend_Mime_Message``, vous pouvez instancier l'objet ``Zend_Mime`` vous-même et l'enregistrer
ensuite dans ``Zend_Mime_Message``. Généralement, vous n'aurez pas besoin de faire cela. *->setMime(Zend_Mime
$mime)* définit une instance spéciale de ``Zend_Mime`` pour qu'elle soit utilisée par ce Message.

*->getMime()* retourne l'instance de ``Zend_Mime`` qui sera utilisée pour générer le message lorsque
``generateMessage()`` est appelée.

*->generateMessage()* génère le contenu Z ``Zend_Mime_Message`` en une chaîne de caractères.

.. _zend.mime.message.parse:

Parser une chaîne de caractère pour créer un objet Zend_Mime_Message (expérimental)
-----------------------------------------------------------------------------------

Un message compatible *MIME* donné sous forme de chaîne de caractère peut être utilisé pour reconstruire un
objet ``Zend_Mime_Message``. ``Zend_Mime_Message`` a une méthode de fabrique statique pour parser cette chaîne et
retourner un objet ``Zend_Mime_Message``.

``Zend_Mime_Message::createFromMessage($str, $boundary)`` décode la chaîne de caractères donnée et retourne un
objet ``Zend_Mime_Message`` qui peut ensuite être examiné en utilisant *->getParts()*.


