.. EN-Revision: none
.. _zend.mime.message:

Zend\Mime\Message
=================

.. _zend.mime.message.introduction:

Introduction
------------

``Zend\Mime\Message`` représente un message compatible *MIME* qui peut contenir une ou plusieurs parties
séparées (représentées par des objets :ref:`Zend\Mime\Part <zend.mime.part>`) Avec ``Zend\Mime\Message``, les
messages multiparts compatibles *MIME* peuvent être générés à partir de ``Zend\Mime\Part``. L'encodage et la
gestion des frontières sont gérées de manière transparente par la classe. Les objets ``Zend\Mime\Message``
peuvent aussi être reconstruits à partir de chaînes de caractères données (expérimental). Utilisés par
:ref:`Zend_Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instancier Zend\Mime\Message
----------------------------

Il n'y a pas de constructeur explicite pour ``Zend\Mime\Message``.

.. _zend.mime.message.addparts:

Ajouter des parties MIME
------------------------

Les objets :ref:`Zend\Mime\Part <zend.mime.part>` peuvent êtres ajoutés à un objet ``Zend\Mime\Message`` donné
en appelant *->addPart($part)*.

Un tableau avec toutes les objets :ref:`Zend\Mime\Part <zend.mime.part>` du ``Zend\Mime\Message`` est retourné
dans un tableau grâce à *->getParts()*. Les objets Zend\Mime\Part peuvent ainsi être changés car ils sont
stockés dans le tableau comme références. Si des parties sont ajoutées au tableau, ou que la séquence est
changée, le tableau à besoin d'être retourné à l'objet :ref:`Zend\Mime\Part <zend.mime.part>` en appelant
*->setParts($partsArray)*.

La fonction *->isMultiPart()* retournera ``TRUE`` si plus d'une partie est enregistrée avec l'objet
Zend\Mime\Message, l'objet pourra ainsi régénérer un objet Multipart-Mime-Message lors de la génération de la
sortie.

.. _zend.mime.message.bondary:

Gérer les frontières
--------------------

``Zend\Mime\Message`` crée et utilise généralement son propre objet ``Zend_Mime`` pour générer une frontière.
Si vous avez besoin de définir une frontière ou si vous voulez changer le comportement de l'objet ``Zend_Mime``
utilisé par ``Zend\Mime\Message``, vous pouvez instancier l'objet ``Zend_Mime`` vous-même et l'enregistrer
ensuite dans ``Zend\Mime\Message``. Généralement, vous n'aurez pas besoin de faire cela. *->setMime(Zend_Mime
$mime)* définit une instance spéciale de ``Zend_Mime`` pour qu'elle soit utilisée par ce Message.

*->getMime()* retourne l'instance de ``Zend_Mime`` qui sera utilisée pour générer le message lorsque
``generateMessage()`` est appelée.

*->generateMessage()* génère le contenu Z ``Zend\Mime\Message`` en une chaîne de caractères.

.. _zend.mime.message.parse:

Parser une chaîne de caractère pour créer un objet Zend\Mime\Message (expérimental)
-----------------------------------------------------------------------------------

Un message compatible *MIME* donné sous forme de chaîne de caractère peut être utilisé pour reconstruire un
objet ``Zend\Mime\Message``. ``Zend\Mime\Message`` a une méthode de fabrique statique pour parser cette chaîne et
retourner un objet ``Zend\Mime\Message``.

``Zend\Mime\Message::createFromMessage($str, $boundary)`` décode la chaîne de caractères donnée et retourne un
objet ``Zend\Mime\Message`` qui peut ensuite être examiné en utilisant *->getParts()*.


