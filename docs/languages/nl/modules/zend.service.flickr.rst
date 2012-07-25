.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

Inleiding voor het zoeken in Flickr
-----------------------------------

*Zend_Service_Flickr* is een eenvoudige API om de Flickr REST web service te gebruiken. Om de Flickr web services
te gebruiken moet je een API key hebben. Om deze te verkrijgen en voor meer informatie over de Flickr REST Web
Service, kan je terecht bij de `Flickr API documentatie`_.

In het volgende voorbeeld gebruiken we de *tagSearch()* methode om foto's te zoeken die "php" in de tags hebben.

.. rubric:: Eenvoudige Flickr Photo zoekopdracht

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

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

*Zend_Service_Flickr* biedt drie verschillende mogelijkheden om Flickr gebruikersinformatie te verkrijgen:

- *userSearch()*: Aanvaardt een string query van spatiegescheiden vermeldingen en een optionele tweede parameter
  als een array van zoekopties, en geeft een *Zend_Service_Flickr_ResultSet* object terug.

- *getIdByUsername()*: Geeft een string user ID terug, verbonden met de opgegeven gebruikersnaam string.

- *getIdByEmail()*: Geeft een string user ID terug, verbonden met de opgegeven gebruikerse-mail string.

.. rubric:: Een Flickr gebruiker vinden door middel van zijn e-mailadres

In dit voorbeeld hebben we het e-mailadres van de Flickr gebruiker, en we verkrijgen de gebruikersinformatie door
de *userSearch()* methode te gebruiken:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }
   ?>
.. _zend.service.flickr.getimagedetails:

Flickr beelddetails opvragen
----------------------------

*Zend_Service_Flickr* maakt het snel en eenvoudig om details van een beeld te verkrijgen via zijn ID. Gebruik
gewoon de *getImageDetails()* methode zoals in het volgende voorbeeld:

.. rubric:: Flickr beelddetails verkrijgen

Wanneer je een Flickr beeld ID hebt is het eenvoudig informatie over dat beeld te verkrijgen:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "Beeld ID $imageId is $image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Klik hier voor het beeld</a>\n";
   ?>
.. _zend.service.flickr.classes:

Zend_Service_Flickr Klassen
---------------------------

De volgende klassen worden alleen teruggegeven door *tagSearch()* en *userSearch()*:

   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vertegenwoordigt een set resultaten van een Flickr zoekopdracht.

.. note::

   Implementeert de *SeekableIterator* voor gemakkelijke iteratie (bv., door *foreach* te gebruiken), evenals
   onmiddellijke toegang tot een specifiek resultaat door *seek()* te gebruiken.

.. _zend.service.flickr.classes.resultset.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Flickr_ResultSet Eigenschappen

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

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Geeft het totaal aantal resultaten in deze set resultaten terug.

:ref:`Terug naar de klasselijst <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Een enkel beeldresultaat van een Flickr zoekopdracht

.. _zend.service.flickr.classes.result.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Flickr_Result Eigenschappen

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
   |Square     |Zend_Service_Flickr_Image|Een 75x75 thumbnailbeeld.                                    |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Thumbnail  |Zend_Service_Flickr_Image|Een 100 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Small      |Zend_Service_Flickr_Image|Een 240 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Medium     |Zend_Service_Flickr_Image|Een 500 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Large      |Zend_Service_Flickr_Image|Een 640 pixel thumbnailbeeld.                                |
   +-----------+-------------------------+-------------------------------------------------------------+
   |Original   |Zend_Service_Flickr_Image|Het oorspronkelijk beeld.                                    |
   +-----------+-------------------------+-------------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Representeert een beeld teruggegeven door een Flickr zoekopdracht.

.. _zend.service.flickr.classes.image.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Flickr_Image Eigenschappen

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
