.. EN-Revision: none
.. _zend.http.client:

Zend\Http\Client
================

.. _zend.http.client.introduction:

Inleiding
---------

*Zend\Http\Client* verstrekt een eenvoudige interface om HTTP verzoeken te maken. *Zend\Http\Client* kan GET, POST,
PUT en DELETE verzoeken maken.

.. note::

   *Zend_HttpClient* volgt standaard tot 5 HTTP verwijzingen. Om dit gedrag te veranderen geef je het maximum
   toegestane verwijzingen aan de *get()* methode op.



   .. rubric:: Een basis GET verzoek maken

   .. code-block:: php
      :linenos:

      <?php
          require_once 'Zend/Http/Client.php';
          try {
              $http = new Zend\Http\Client('http://example.org');
              $response = $http->get();
              if ($response->isSuccessful()) {
                  echo $response->getBody();
              } else {
                  echo '<p>Er trad een fout op</p>';
              }
          } catch (Zend\Http_Client\Exception $e) {
              echo '<p>Er trad een fout op (' .$e->getMessage(). ')</p>';
          }
          ?>


.. _zend.http.client.basic-get-requests:

Basis GET verzoeken met gespecificeerde HTTP Headers
----------------------------------------------------

De *Zend\Http\Client* constructor maakt een *Zend\Http\Client* instantie om HTTP verzoeken te zenden.

Als je *Zend\Http\Client* gebruikt op één enkele URL kan je in de meeste gevallen de URL en relevante headers aan
de **constructor** geven, zoals in de volgende voorbeelden:

.. rubric:: Een Basis Zend\Http\Client maken

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Http/Client.php';

       // Specificeer de URL en een enkele header
       $http = new Zend\Http\Client('http://example.org', 'Accept: text/html');
       ?>


.. rubric:: Meerdere Headers sturen

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Http/Client.php';

       // Specificeer de URL en meerdere headers
       $http = new Zend\Http\Client('http://example.org',
                               array('Accept: text/html', 'Accept-Language: en-us,en;q=0.5'));
       ?>
Als je *Zend\Http\Client* wenst te gebruiken om verzoeken aan **meerdere** URLs te sturen, zie dan :ref:`
<zend.http.client.requesting-multiple-domains>`

.. _zend.http.client.requesting-multiple-domains:

Multidomein verzoeken
---------------------

*Zend\Http\Client* ondersteunt het sturen van verzoeken aan meerdere domeinen door het zetten van de URL via de
methode *Zend\Http\Client::setUri()*.

.. note::

   Een geweldig gebruik hiervoor is als je meerdere RSS feeds uitleest.

.. rubric:: Multidomein verzoek

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Http/Client.php';

       // Het client object instantiëren
       $http = new Zend\Http\Client();

       // De URI naar Slashdot's hoofd feed zetten
       $http->setUri('http://rss.slashdot.org/Slashdot/slashdot');

       // De feed opvragen
       $slashdot = $http->get();

       // Nu de BBC news feed instellen
       $http->setUri('http://newsrss.bbc.co.uk/rss/newsonline_world_edition/technology/rss.xml');

       // de feed opvragen
       $bbc = $http->get();
       ?>
.. _zend.http.client.settimeout:

De HTTP Timeout wijzigen
------------------------

*Zend\Http\Client::setTimeout()* laat je toe de timeout voor de HTTP verbinding te zetten, in seconden.

.. note::

   De standaard timeout is 10 seconden.

.. _zend.http.client.setheaders:

Dynamisch HTTP Headers zetten
-----------------------------

Je kan een **array** headers zetten met *Zend\Http\Client::setHeaders()*.

.. important::

   Headers moeten het formaat volgen: *Header: waarde*

.. _zend.http.client.making-other-requests:

POST, PUT en DELETE HTTP verzoeken maken
----------------------------------------

Het maken van POST, PUT en DELETE HTTP verzoeken wordt vereenvoudigd in *Zend\Http\Client* door middel van drie
methodes: *post()*, *put()*, en *delete()*, respectievelijk. De *post()* en *put()* methodes aanvaarden elk één
string parameter, *$data*, waarin een string met de data correct ge-encodeerd zoals volgt: **name=value&foo=bar**.
De *delete()* methode heeft geen parameters.

.. rubric:: POST data verzenden met Zend\Http\Client

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Http/Client.php';

       // Het client object instantiëren
       $http = new Zend\Http\Client();

       // De URI naar een POST dataverwerker zetten
       $http->setUri('http://example.org/post/processor');

       // De specifieke GET variabelen als HTTP POST data opslaan
       $postData = 'foo=' . urlencode($_GET['foo']) . '&bar=' . urlencode($_GET['bar']);

       // Het HTTP POST verzoek maken en het HTTP antwoord opslaan
       $httpResponse = $http->post($postData);
       ?>
Een PUT verzoek maken is hetzelfde als in het voorgaande voorbeeld om een POST verzoek te maken; je hoeft slechts
de *put()* methode gebruiken in plaats van de *post()* methode.


