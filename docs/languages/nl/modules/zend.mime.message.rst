.. EN-Revision: none
.. _zend.mime.message:

Zend\Mime\Message
=================

.. _zend.mime.message.introduction:

Inleiding
---------

*Zend\Mime\Message* stelt een MIME compatibel bericht voor dat één of meer gescheiden delen (voorgesteld als
:ref:`Zend\Mime\Part <zend.mime.part>` objecten) kan bevatten. Je kan MIME compatibele multipart berichten
genereren van MimeParts met *Zend\Mime\Message*. Encodering en boundary worden transparant door de klasse
afgehandeld. *Zend\Mime\Message* objecten kunnen ook van opgegeven strings worden opgebouwd (experimenteel).
Gebruikt door :ref:`Zend_Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instantiëring
-------------

Er is geen expliciete constructor voor *Zend\Mime\Message*.

.. _zend.mime.message.addparts:

MIME Delen Toevoegen
--------------------

:ref:`Zend\Mime\Part <zend.mime.part>` objecten kunnen aan een gegeven *Zend\Mime\Message* object worden toegevoegd
door *->addPart($part)* op te roepen

De methode *->getParts()* geeft een array met alle delen in *Zend\Mime\Message* terug. De :ref:`Zend\Mime\Part
<zend.mime.part>` objecten kunnen dan worden gewijzigd vermits ze als referenties in de array zijn opgeslaan.
Indien delen aan de array worden toegevoegd, of de volgorde ervan word gewijzigd, moet de array terug aan
:ref:`Zend\Mime\Part <zend.mime.part>` worden gegeven door *->setParts($partsArray)* op te roepen.

De functie *->isMultiPart()* zal true teruggeven als meer dan 1 deel in het Zend\Mime\Message object is
geregistreerd en dat object dus een Multipart-Mime-Message zou genereren bij weergave.

.. _zend.mime.message.bondary:

Boundary afhandeling
--------------------

*Zend\Mime\Message* maakt en gebruikt meestal zijn eigen *Zend_Mime* object om een boundary te genereren. Indien je
een boundary moet definiëren of je wil het standaard gedrag van het Zend_Mime object dat *Zend\Mime\Message*
gebruikt wil wijzigen, kan je het Zend_Mime object zelf instantiëren en het dan in *Zend\Mime\Message*
registreren. Normaal gesproken zal je dit niet hoeven te doen. *->setMime(Zend_Mime $mime)<-* zet een speciale
instantie van *Zend_Mime* dat door deze *Zend\Mime\Message* moet worden gebruikt.

*->getMime()* geeft de instantie van *Zend_Mime* terug die zal worden gebruikt om het bericht weer te geven wanneer
*generateMessage()* word opgeroepen.

*->generateMessage()* geeft de inhoud van *Zend\Mime\Message* als een string weer.

.. _zend.mime.message.parse:

Een string parsen om een Zend\Mime\Message object te maken (experimenteel)
--------------------------------------------------------------------------

Een gegeven MIME compatibel bericht in de vorm van een string kan worden gebruikt om er een *Zend\Mime\Message*
object van te (her)opbouwen. *Zend\Mime\Message* heeft een statische "factory" methode om deze string te parsen en
een *Zend\Mime\Message* object terug te geven.

*Zend\Mime\Message::createFromMessage($str, $boundary)* decodeert een gegeven string en geeft een
*Zend\Mime\Message* object terug dat dan kan worden onderzocht door *->getParts()* te gebruiken.


