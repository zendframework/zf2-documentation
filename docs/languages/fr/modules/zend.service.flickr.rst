.. EN-Revision: none
.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

Introduction
------------

``Zend_Service_Flickr`` est une *API* simple pour utiliser le service Web REST de Flick. Pour pouvoir utiliser les
services Web Flickr, vous devez avoir une clé d'utilisation de l'API. Pour obtenir une telle clé, et pour plus
d'information sur le service Web REST de Flickr, veuillez vous référez à la `documentation de l'API Flickr`_.

Dans l'exemple suivant, nous allons utiliser la méthode ``tagSearch()`` pour rechercher des photos ayant "php"
dans les tags.

.. _zend.service.flickr.introduction.example-1:

.. rubric:: Simple recherche de photos sur Flickr

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MA_CLE_API');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Paramètres optionnels**

   ``tagSearch()`` accepte un tableau d'options comme second paramètre optionnel.

.. _zend.service.flickr.finding-users:

Trouver les photos et les informations des utilisateurs Flickr
--------------------------------------------------------------

``Zend_Service_Flickr``\ fournit plusieurs façons différentes de récupérer des informations sur les
utilisateurs.

- ``userSearch()``: Accepte une chaîne de caractère de balise délimitée par des espaces, et un tableau
  d'options en second paramètre optionnel. Elle retourne un jeu de photos sous la forme d'un objet
  ``Zend_Service_Flickr_ResultSet``.

- ``getIdByUsername()``: Retourne l'identifiant utilisateur, correspondant à son nom d'utilisateur.

- ``getIdByEmail()``: Retourne l'identifiant utilisateur correspondant à l'adresse émail donnée.

.. _zend.service.flickr.finding-users.example-1:

.. rubric:: Trouver les photos publiques d'un utilisateur Flickr par son adresse émail

Dans cet exemple, nous havons une adresse émail d'un utilisateur Flickr, et nous recherchons les photos publiques
des utilisateurs en utilisant la méthode ``userSearch()``:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MA_CLE_API');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zend.service.flickr.grouppoolgetphotos:

Trouver des photos dans le pool d'un groupe
-------------------------------------------

``Zend_Service_Flickr`` vous permet de récupérer les photos issues du pool d'un groupe à partir de son ID.
Utilisez pour cela la méthode ``groupPoolGetPhotos()``:

.. _zend.service.flickr.grouppoolgetphotos.example-1:

.. rubric:: Récupération les photos du pool d'un groupe grâce à son ID

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MA_CLE_API');

   $results = $flickr->groupPoolGetPhotos($groupId);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Paramètre optionnel**

   ``groupPoolGetPhotos()`` accepte un second paramètre optionnel sous la forme d'un tableau d'options.

.. _zend.service.flickr.getimagedetails:

Récupérer les détails d'une image
---------------------------------

``Zend_Service_Flickr`` permet de récupérer facilement et rapidement, les détails d'une image grâce à son ID.
Utilisez simplement la méthode ``getImageDetails()``, comme dans l'exemple suivant :

.. _zend.service.flickr.getimagedetails.example-1:

.. rubric:: Récupérer les détails d'une image

Une fois que vous avez l'identifiant de l'image Flickr, il est simple de retrouver les informations qui lui sont
associées :

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MA_CLE_API');

   $image = $flickr->getImageDetails($imageId);

   echo "ID de l'image : $imageId, taille : "
      . "$image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Clicker pour l'image</a>\n";

.. _zend.service.flickr.classes:

Classes de résultats Zend_Service_Flickr
----------------------------------------

Les classes suivantes sont toutes retournées par ``tagSearch()`` et ``userSearch()``:

   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Représente le jeu de résultats d'une recherche sur Flickr.

.. note::

   Implémente l'itérateur *SeekableIterator* (ie en utilisant *foreach*), ainsi qu'un accès direct à un
   résultat particulier en utilisant ``seek()``.

.. _zend.service.flickr.classes.resultset.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.flickr.classes.resultset.properties.table-1:

.. table:: Propriétés Zend_Service_Flickr_ResultSet

   +---------------------+----+-------------------------------------------------------------+
   |Nom                  |Type|Description                                                  |
   +=====================+====+=============================================================+
   |totalResultsAvailable|int |Nombre total de résultats disponibles                        |
   +---------------------+----+-------------------------------------------------------------+
   |totalResultsReturned |int |Nombre total de résultats retournés                          |
   +---------------------+----+-------------------------------------------------------------+
   |firstResultPosition  |int |??? The offset in the total result set of this result set ???|
   +---------------------+----+-------------------------------------------------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Retourne le nombre de totale de résultats dans ce jeu de résultats.

:ref:`Retour à la liste des classes <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Un seule image résultant d'une requête sur Flickr.

.. _zend.service.flickr.classes.result.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.flickr.classes.result.properties.table-1:

.. table:: Propriétés Zend_Service_Flickr_Result

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
   |Square    |Zend_Service_Flickr_Image|Une miniature de l'image au format 75x75 pixels.                                           |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Thumbnail |Zend_Service_Flickr_Image|Une miniature de l'image de 100 pixels.                                                    |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Small     |Zend_Service_Flickr_Image|Une version en 240 pixels de l'image.                                                      |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Medium    |Zend_Service_Flickr_Image|Une version en 500 pixel version de l'image.                                               |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Large     |Zend_Service_Flickr_Image|Une version en 640 pixel version de l'image.                                               |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+
   |Original  |Zend_Service_Flickr_Image|L'image originale.                                                                         |
   +----------+-------------------------+-------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Représente une image retournée pour une recherche Flickr.

.. _zend.service.flickr.classes.image.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.flickr.classes.image.properties.table-1:

.. table:: Propriétés Zend_Service_Flickr_Image

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

:ref:`Retour à la liste des classes <zend.service.flickr.classes>`



.. _`documentation de l'API Flickr`: http://www.flickr.com/services/api/
