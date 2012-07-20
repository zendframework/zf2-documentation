.. _zend.mime.message:

Zend_Mime_Message
=================

.. _zend.mime.message.introduction:

Inleiding
---------

*Zend_Mime_Message* stelt een MIME compatibel bericht voor dat één of meer gescheiden delen (voorgesteld als
:ref:`Zend_Mime_Part <zend.mime.part>` objecten) kan bevatten. Je kan MIME compatibele multipart berichten
genereren van MimeParts met *Zend_Mime_Message*. Encodering en boundary worden transparant door de klasse
afgehandeld. *Zend_Mime_Message* objecten kunnen ook van opgegeven strings worden opgebouwd (experimenteel).
Gebruikt door :ref:`Zend_Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instantiëring
-------------

Er is geen expliciete constructor voor *Zend_Mime_Message*.

.. _zend.mime.message.addparts:

MIME Delen Toevoegen
--------------------

:ref:`Zend_Mime_Part <zend.mime.part>` objecten kunnen aan een gegeven *Zend_Mime_Message* object worden toegevoegd
door *->addPart($part)* op te roepen

De methode *->getParts()* geeft een array met alle delen in *Zend_Mime_Message* terug. De :ref:`Zend_Mime_Part
<zend.mime.part>` objecten kunnen dan worden gewijzigd vermits ze als referenties in de array zijn opgeslaan.
Indien delen aan de array worden toegevoegd, of de volgorde ervan word gewijzigd, moet de array terug aan
:ref:`Zend_Mime_Part <zend.mime.part>` worden gegeven door *->setParts($partsArray)* op te roepen.

De functie *->isMultiPart()* zal true teruggeven als meer dan 1 deel in het Zend_Mime_Message object is
geregistreerd en dat object dus een Multipart-Mime-Message zou genereren bij weergave.

.. _zend.mime.message.bondary:

Boundary afhandeling
--------------------

*Zend_Mime_Message* maakt en gebruikt meestal zijn eigen *Zend_Mime* object om een boundary te genereren. Indien je
een boundary moet definiëren of je wil het standaard gedrag van het Zend_Mime object dat *Zend_Mime_Message*
gebruikt wil wijzigen, kan je het Zend_Mime object zelf instantiëren en het dan in *Zend_Mime_Message*
registreren. Normaal gesproken zal je dit niet hoeven te doen. *->setMime(Zend_Mime $mime)<-* zet een speciale
instantie van *Zend_Mime* dat door deze *Zend_Mime_Message* moet worden gebruikt.

*->getMime()* geeft de instantie van *Zend_Mime* terug die zal worden gebruikt om het bericht weer te geven wanneer
*generateMessage()* word opgeroepen.

*->generateMessage()* geeft de inhoud van *Zend_Mime_Message* als een string weer.

.. _zend.mime.message.parse:

Een string parsen om een Zend_Mime_Message object te maken (experimenteel)
--------------------------------------------------------------------------

Een gegeven MIME compatibel bericht in de vorm van een string kan worden gebruikt om er een *Zend_Mime_Message*
object van te (her)opbouwen. *Zend_Mime_Message* heeft een statische "factory" methode om deze string te parsen en
een *Zend_Mime_Message* object terug te geven.

*Zend_Mime_Message::createFromMessage($str, $boundary)* decodeert een gegeven string en geeft een
*Zend_Mime_Message* object terug dat dan kan worden onderzocht door *->getParts()* te gebruiken.


