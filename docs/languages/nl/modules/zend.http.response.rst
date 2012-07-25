.. _zend.http.response:

Zend_Http_Response
==================

.. _zend.http.response.introduction:

Inleiding
---------

*Zend_Http_Response* verstrekt eenvoudige toegang tot de antwoorden die door :ref:` <zend.http.client>` worden
teruggestuurd. Het verstrekt een intuïtieve set van methodes om met de HTTP antwoorddata die van een verzoek wordt
ontvangen te werken:

   - *isError()*: TRUE indien een HTTP foutcode werd ontvangen; anders FALSE.

   - *isSuccessful()*: TRUE indien een HTTP succescode werd ontvangen; anders FALSE.

   - *isRedirect()*: TRUE indien een HTTP verwijzingscode werd ontvangen; anders FALSE.

   - *getStatus()*: Geeft de HTTP statuscode terug.

   - *getHeaders()*: Geeft een array van strings van HTTP antwoordheaders terug.

   - *getBody()*: Geeft de HTTP antwoordinhoud als een string terug.



.. rubric:: Met HTTP antwoorddata werken

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Http/Client.php';
   try {
       $http = new Zend_Http_Client('http://example.org');
       $response = $http->get();
       if ($response->isSuccessful()) {
           echo $response->getBody();
       } else {
           echo "<p>Er trad een fout op</p>\n";
           echo "HTTP Status: " . $response->getStatus() . "\n";
           echo "HTTP Headers:\n";
           $responseHeaders = $response->getHeaders();
           foreach ($responseHeaders as $responseHeaderName => $responseHeaderValue) {
               echo "$responseHeaderName: $responseHeaderValue\n";
           }
       }
   } catch (Zend_Http_Exception $e) {
       echo '<p>Er trad een fout op (' .$e->getMessage(). ')</p>';
   }
   ?>

