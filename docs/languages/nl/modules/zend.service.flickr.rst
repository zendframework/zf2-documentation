.. EN-Revision: none
.. _zend.service.flickr:

Zend\Service\Flickr
===================

.. _zend.service.flickr.introduction:

Inleiding voor het zoeken in Flickr
-----------------------------------

*Zend\Service\Flickr* is een eenvoudige API om de Flickr REST web service te gebruiken. Om de Flickr web services
te gebruiken moet je een API key hebben. Om deze te verkrijgen en voor meer informatie over de Flickr REST Web
Service, kan je terecht bij de `Flickr API documentatie`_.

In het volgende voorbeeld gebruiken we de *tagSearch()* methode om foto's te zoeken die "php" in de tags hebben.

.. rubric:: Eenvoudige Flickr Photo zoekopdracht

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend\Service\Flickr('MY_API_KEY');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }
   ?>
.. note::

   *tagSearch()* aanvaardt een optionele tweede parameter met een array van opties.

.. _zend.service.flickr.finding-users:

Flickr gebruikers vinden
------------------------

*Zend\Service\Flickr* biedt drie verschillende mogelijkheden om Flickr gebruikersinformatie te verkrijgen:

- *userSearch()*: Aanvaardt een string query van spatiegescheiden vermeldingen en een optionele tweede parameter
  als een array van zoekopties, en geeft een *Zend\Service_Flickr\ResultSet* object terug.

- *getIdByUsername()*: Geeft een string user ID terug, verbonden met de opgegeven gebruikersnaam string.

- *getIdByEmail()*: Geeft een string user ID terug, verbonden met de opgegeven gebruikerse-mail string.

.. rubric:: Een Flickr gebruiker vinden door middel van zijn e-mailadres

In dit voorbeeld hebben we het e-mailadres van de Flickr gebruiker, en we verkrijgen de gebruikersinformatie door
de *userSearch()* methode te gebruiken:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend\Service\Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }
   ?>
.. _zend.service.flickr.getimagedetails:

Flickr beelddetails opvragen
----------------------------

*Zend\Service\Flickr* maakt het snel en eenvoudig om details van een beeld te verkrijgen via zijn ID. Gebruik
gewoon de *getImageDetails()* methode zoals in het volgende voorbeeld:

.. rubric:: Flickr beelddetails verkrijgen

Wanneer je een Flickr beeld ID hebt is het eenvoudig informatie over dat beeld te verkrijgen:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend\Service\Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "Beeld ID $imageId is $image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Klik hier voor het beeld</a>\n";
   ?>
.. _zend.service.flickr.classes:

Zend\Service\Flickr Klassen
---------------------------

De volgende klassen worden alleen teruggegeven door *tagSearch()* en *userSearch()*:

   - :ref:`Zend\Service_Flickr\ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend\Service_Flickr\Result <zend.service.flickr.classes.result>`

   - :ref:`Zend\Service_Flickr\Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend\Service_Flickr\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vertegenwoordigt een set resultaten van een Flickr zoekopdracht.

.. note::

   Implementeert de *SeekableIterator* voor gemakkelijke iteratie (bv., door *foreach* te gebruiken), evenals
   onmiddellijke toegang tot een specifiek resultaat door *seek()* te gebruiken.

.. _zend.service.flickr.classes.resultset.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend\Service_Flickr\ResultSet Eigenschappen

   +---------------------+----+-------------------------------------------------------------+
   |Naam                 |Type|Beschrijving                                                 |
   +=====================+====+=============================================================+
   |totalResultsAvailable|int |Totaal aantal beschikbare resultaten                         |
   +---------------------+----+-------------------------------------------------------------+
   |totalResultsReturned |int |Totaal aantal teruggestuurde resultaten                      |
   +---------------------+----+-------------------------------------------------------------+
   |firstResultPosition  |int |De offset in de totale set resultaten van deze set resultaten|
   +---------------------+----+-------------------------------------------------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend\Service_Flickr\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Geeft het totaal aantal resultaten in deze set resultaten terug.

:ref:`Terug naar de klasselijst <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend\Service_Flickr\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Een enkel beeldresultaat van een Flickr zoekopdracht

.. _zend.service.flickr.classes.result.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend\Service_Flickr\Result Eigenschappen

   +-----------+-------------------------+-------------------------------------------------------------+
   |Naam       |Type                     |Beschrijving                                                 |
   +===========+=========================+=============================================================+
   |id         |int                      |Beeld ID                                                     |
   +-----------+-------------------------+-------------------------------------------------------------+
   |owner      |int                      |Het NSID van de eigenaar van de foto.                        |
   +-----------+-------------------------+-------------------------------------------------------------+
   |secret     |string                   |Een key gebruikt in het bouwen van een URL.                  |
   +-----------+-------------------------+-------------------------------------------------------------+
   |server     |string                   |De servernaam om in het bouwen van een URL te gebruiken.     |
   +-----------+-------------------------+-------------------------------------------------------------+
   |title      |string                   |De titel van de foto.                                        |
   +-----------+-------------------------+-------------------------------------------------------------+
   |ispublic   |boolean                  |de foto is publiek.                                          |
   +-----------+-------------------------+-------------------------------------------------------------+
   |isfriend   |boolean                  |Je kan de foto zien omdat je een vriend bent van de eigenaar.|
   +-----------+-------------------------+-------------------------------------------------------------+
   |isfamily   |boolean                  |Je kan de foto zien omdat je familie bent van de eigenaar.   |
   +-----------+-------------------------+-------------------------------------------------------------+
   |license    |string                   |De licentie waaronder de foto beschikbaar is.                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |date_upload|string                   |De datum waarop de foto werd geupload.                       |
   +-----------+-------------------------+-------------------------------------------------------------+
   |date_taken |string                   |De datum waarop de foto werd genomen.                        |
   +-----------+-------------------------+-------------------------------------------------------------+
   |owner_name |string                   |De schermnaam van de eigenaar.                               |
   +-----------+-------------------------+-------------------------------------------------------------+
   |icon_server|string                   |De server die gebruikt werd om icon URLs te assembleren.     |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Square     |Zend\Service_Flickr\Image|Een 75x75 thumbnailbeeld.                                    |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Thumbnail  |Zend\Service_Flickr\Image|Een 100 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Small      |Zend\Service_Flickr\Image|Een 240 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Medium     |Zend\Service_Flickr\Image|Een 500 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Large      |Zend\Service_Flickr\Image|Een 640 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Original   |Zend\Service_Flickr\Image|Het oorspronkelijk beeld.                                    |
   +-----------+-------------------------+-------------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend\Service_Flickr\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Representeert een beeld teruggegeven door een Flickr zoekopdracht.

.. _zend.service.flickr.classes.image.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend\Service_Flickr\Image Eigenschappen

   +--------+------+------------------------------------------------------+
   |Naam    |Type  |Beschrijving                                          |
   +========+======+======================================================+
   |uri     |string|URI voor het oorspronkelijk beeld                     |
   +--------+------+------------------------------------------------------+
   |clickUri|string|Een klikbaar URI (bv. de Flickr pagina) voor het beeld|
   +--------+------+------------------------------------------------------+
   |width   |int   |Breedte van het beeld                                 |
   +--------+------+------------------------------------------------------+
   |height  |int   |Hoogte van het beeld                                  |
   +--------+------+------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.flickr.classes>`



.. _`Flickr API documentatie`: http://www.flickr.com/services/api/
