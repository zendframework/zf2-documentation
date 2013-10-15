.. EN-Revision: none
.. _zendservice.flickr:

ZendService\Flickr\Flickr
===================

.. _zendservice.flickr.introduction:

Introduction
------------

``ZendService\Flickr\Flickr`` est une *API* simple pour utiliser le service Web REST de Flick. Pour pouvoir utiliser les
services Web Flickr, vous devez avoir une clé d'utilisation de l'API. Pour obtenir une telle clé, et pour plus
d'information sur le service Web REST de Flickr, veuillez vous référez à la `documentation de l'API Flickr`_.

Dans l'exemple suivant, nous allons utiliser la méthode ``tagSearch()`` pour rechercher des photos ayant "php"
dans les tags.

.. _zendservice.flickr.introduction.example-1:

.. rubric:: Simple recherche de photos sur Flickr

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MA_CLE_API');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Paramètres optionnels**

   ``tagSearch()`` accepte un tableau d'options comme second paramètre optionnel.

.. _zendservice.flickr.finding-users:

Trouver les photos et les informations des utilisateurs Flickr
--------------------------------------------------------------

``ZendService\Flickr\Flickr``\ fournit plusieurs façons différentes de récupérer des informations sur les
utilisateurs.

- ``userSearch()``: Accepte une chaîne de caractère de balise délimitée par des espaces, et un tableau
  d'options en second paramètre optionnel. Elle retourne un jeu de photos sous la forme d'un objet
  ``ZendService\Flickr\ResultSet``.

- ``getIdByUsername()``: Retourne l'identifiant utilisateur, correspondant à son nom d'utilisateur.

- ``getIdByEmail()``: Retourne l'identifiant utilisateur correspondant à l'adresse émail donnée.

.. _zendservice.flickr.finding-users.example-1:

.. rubric:: Trouver les photos publiques d'un utilisateur Flickr par son adresse émail

Dans cet exemple, nous havons une adresse émail d'un utilisateur Flickr, et nous recherchons les photos publiques
des utilisateurs en utilisant la méthode ``userSearch()``:

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MA_CLE_API');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zendservice.flickr.grouppoolgetphotos:

Trouver des photos dans le pool d'un groupe
-------------------------------------------

``ZendService\Flickr\Flickr`` vous permet de récupérer les photos issues du pool d'un groupe à partir de son ID.
Utilisez pour cela la méthode ``groupPoolGetPhotos()``:

.. _zendservice.flickr.grouppoolgetphotos.example-1:

.. rubric:: Récupération les photos du pool d'un groupe grâce à son ID

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MA_CLE_API');

   $results = $flickr->groupPoolGetPhotos($groupId);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Paramètre optionnel**

   ``groupPoolGetPhotos()`` accepte un second paramètre optionnel sous la forme d'un tableau d'options.

.. _zendservice.flickr.getimagedetails:

Récupérer les détails d'une image
---------------------------------

``ZendService\Flickr\Flickr`` permet de récupérer facilement et rapidement, les détails d'une image grâce à son ID.
Utilisez simplement la méthode ``getImageDetails()``, comme dans l'exemple suivant :

.. _zendservice.flickr.getimagedetails.example-1:

.. rubric:: Récupérer les détails d'une image

Une fois que vous avez l'identifiant de l'image Flickr, il est simple de retrouver les informations qui lui sont
associées :

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MA_CLE_API');

   $image = $flickr->getImageDetails($imageId);

   echo "ID de l'image : $imageId, taille : "
      . "$image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Clicker pour l'image</a>\n";

.. _zendservice.flickr.classes:

Classes de résultats ZendService\Flickr\Flickr
----------------------------------------

Les classes suivantes sont toutes retournées par ``tagSearch()`` et ``userSearch()``:

   - :ref:`ZendService\Flickr\ResultSet <zendservice.flickr.classes.resultset>`

   - :ref:`ZendService\Flickr\Result <zendservice.flickr.classes.result>`

   - :ref:`ZendService\Flickr\Image <zendservice.flickr.classes.image>`



.. _zendservice.flickr.classes.resultset:

ZendService\Flickr\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Représente le jeu de résultats d'une recherche sur Flickr.

.. note::

   Implémente l'itérateur *SeekableIterator* (ie en utilisant *foreach*), ainsi qu'un accès direct à un
   résultat particulier en utilisant ``seek()``.

.. _zendservice.flickr.classes.resultset.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.flickr.classes.resultset.properties.table-1:

.. table:: Propriétés ZendService\Flickr\ResultSet

   +---------------------+----+-------------------------------------------------------------+
   |Nom                  |Type|Description                                                  |
   +=====================+====+=============================================================+
   |totalResultsAvailable|int |Nombre total de résultats disponibles                        |
   +---------------------+----+-------------------------------------------------------------+
   |totalResultsReturned |int |Nombre total de résultats retournés                          |
   +---------------------+----+-------------------------------------------------------------+
   |firstResultPosition  |int |??? The offset in the total result set of this result set ???|
   +---------------------+----+-------------------------------------------------------------+

.. _zendservice.flickr.classes.resultset.totalResults:

ZendService\Flickr\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Retourne le nombre de totale de résultats dans ce jeu de résultats.

:ref:`Retour à la liste des classes <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.result:

ZendService\Flickr\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Un seule image résultant d'une requête sur Flickr.

.. _zendservice.flickr.classes.result.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.flickr.classes.result.properties.table-1:

.. table:: Propriétés ZendService\Flickr\Result

   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Nom       |Type                     |Description                                                                                |
   +==========+=========================+===========================================================================================+
   |id        |string                   |Identifiant de l'image                                                                     |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |owner     |string                   |Le NSID du propriétaire de la photo.                                                       |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |secret    |string                   |La clé utilisée dans la construction de l'URL.                                             |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |server    |string                   |Le nom du serveur à utiliser pour construire l'URL.                                        |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |title     |string                   |Le titre de la photo.                                                                      |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |ispublic  |string                   |La photo est publique.                                                                     |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |isfriend  |string                   |Vous pouvez voir la photo parce que vous êtes un ami du propriétaire de cette photo.       |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |isfamily  |string                   |Vous pouvez voir la photo parce que vous êtes de la famille du propriétaire de cette photo.|
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |license   |string                   |La licence sous laquelle cette photo est disponible.                                       |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |dateupload|string                   |La date à laquelle la photo a été uploadée.                                                |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |datetaken |string                   |La date à laquelle la photo a été prise.                                                   |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |ownername |string                   |Le screenname du propriétaire de la photo.                                                 |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |iconserver|string                   |Le serveur utilisé pour l'assemblage des ??? icon URLs ???.                                |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Square    |ZendService\Flickr\Image|Une miniature de l'image au format 75x75 pixels.                                           |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Thumbnail |ZendService\Flickr\Image|Une miniature de l'image de 100 pixels.                                                    |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Small     |ZendService\Flickr\Image|Une version en 240 pixels de l'image.                                                      |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Medium    |ZendService\Flickr\Image|Une version en 500 pixel version de l'image.                                               |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Large     |ZendService\Flickr\Image|Une version en 640 pixel version de l'image.                                               |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Original  |ZendService\Flickr\Image|L'image originale.                                                                         |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.image:

ZendService\Flickr\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Représente une image retournée pour une recherche Flickr.

.. _zendservice.flickr.classes.image.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.flickr.classes.image.properties.table-1:

.. table:: Propriétés ZendService\Flickr\Image

   +--------+------+---------------------------------------------+
   |Nom     |Type  |Description                                  |
   +========+======+=============================================+
   |uri     |string|URI de l'image originale.                    |
   +--------+------+---------------------------------------------+
   |clickUri|string|URI cliquable (ie la page Flickr) de l'image.|
   +--------+------+---------------------------------------------+
   |width   |int   |Largeur de l'image.                          |
   +--------+------+---------------------------------------------+
   |height  |int   |Hauteur de l'image.                          |
   +--------+------+---------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.flickr.classes>`



.. _`documentation de l'API Flickr`: http://www.flickr.com/services/api/
