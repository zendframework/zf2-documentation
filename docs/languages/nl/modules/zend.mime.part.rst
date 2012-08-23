.. EN-Revision: none
.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

Inleiding
---------

Deze klasse stelt een enkel deel van een MIME bericht voor. Het bevat de inhoud van het berichtdeel, plus
informatie over de encodering, inhoudstype en oorspronkelijke bestandsnaam ervan. Het biedt een methode om een
string te genereren vanaf opgeslagen data. *Zend_Mime_Part* objecten kunnen aan :ref:`Zend_Mime_Message
<zend.mime.message>` worden toegevoegd om een compleet mulitpart bericht te assembleren.

.. _zend.mime.part.instantiation:

Instantiëring
-------------

*Zend_Mime_Part* word geïnstantieert met een string die de inhoud van het nieuwe deel bevat. Het wordt aangenomen
dat het type van de inhoud OCTET-STREAM is, geëncodeerd op 8bits. Na het instantiëren van een *Zend_Mime_Part*
kan je meta informatie zetten door onmiddellijk de attributen aan te spreken:

.. code-block:: php
   :linenos:

   <?php
   public $type = ZMime::TYPE_OCTETSTREAM;
   public $encoding = ZMime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   ?>
.. _zend.mime.part.methods:

Methodes om een berichtdeel naar een string te schrijven
--------------------------------------------------------

*->getContent()* geeft de geëncodeerde inhoud van de Mime_Part als een string weer, geëncodeert volgens de in het
attribuut $encoding gespecificeerde encodage. Toegestane waarden zijn Zend_Mime::ENCODING_* karakterset. Er worden
geen conversies uitgevoerd.

*->getHeaders()* geeft de Mime-Headers terug voor een Mime_Part zoals die werden gegenereerd vanaf de informatie in
de publiekelijk toegankelijke attributen. De attributen van het object dienen op gepaste wijze te zijn gezet voor
deze methode voor aangeroepen.

   - *$charset* moet naar dezelfde charset worden gezet als de inhoud indien dat een text type is (Text of HTML).

   - *$id* mag worden gezet om inline beelden in een HTML mail met een ID te identifiëren.

   - *$filename* bevat de bestandsnaam dat het bestand zal krijgen indien het gedownload wordt.

   - *$disposition* definieert indien het bestand moet worden beschouwd als een bijvoegsel of indien het wordt
     gebruikt binnenin een (HTML-) mail (inline).

   - *$description* word alleen voor informatiueve doeleinden gebruikt.




