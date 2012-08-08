.. EN-Revision: none
.. _zend.rest.client:

Zend_Rest_Client
================

.. _zend.rest.client.introduction:

Einführung
----------

Die Verwendung von ``Zend_Rest_Client`` ist sehr ähnlich der Verwendung von *SoapClient* Objekten (`SOAP Web
Service Erweiterung`_). Man kann einfach die REST Service Prozeduren als ``Zend_Rest_Client`` Methoden aufrufen.
Spezifiziere die komplette Adresse des Services im Constructor von ``Zend_Rest_Client``.

.. _zend.rest.client.introduction.example-1:

.. rubric:: Eine Basis REST Anfrage

.. code-block:: php
   :linenos:

   /**
    * Verbinden zum framework.zend.com Server und eine Begrüßung empfangen
    */
   $client = new Zend_Rest_Client('http://framework.zend.com/rest');

   echo $client->sayHello('Davey', 'Day')->get(); // "Servus Davey, guten Tag"

.. note::

   **Unterschiede im Aufruf**

   ``Zend_Rest_Client`` versucht, dass die entfernten Methoden, so weit wie möglich, wie die nativen Methoden
   aussehen, wobei der einzige Unterschied darin besteht, dass der Methodenaufruf mit ``get()``, ``post()``,
   ``put()`` oder ``delete()`` erfolgen muß. Dieser Aufruf kann entweder über Methoden Verkettung oder in eigenen
   Methodenaufrufen erfolgen:

   .. code-block:: php
      :linenos:

      $client->sayHello('Davey', 'Tag');
      echo $client->get();

.. _zend.rest.client.return:

Antworten
---------

Alle Anfragen die über ``Zend_Rest_Client`` gemacht wurden, liefern ein ``Zend_Rest_Client_Response`` Objekt
zurück. Dieses Objekt hat viele Eigenschaften, was es einfacher macht, auf die Ergebnisse zuzugreifen.

Wenn ein Service auf ``Zend_Rest_Server`` basiert, kann ``Zend_Rest_Client`` einige Annahmen über die Antwort
treffen, inklusive dem Antwort Status (erfolgreich oder fehlerhaft) und den Rückgabetyp.

.. _zend.rest.client.return.example-1:

.. rubric:: Antwort Status

.. code-block:: php
   :linenos:

   $result = $client->sayHello('Davey', 'Tag')->get();

   if ($result->isSuccess()) {
       echo $result; // "Hallo Davey, guten Tag"
   }

Im obigen Beispiel kann man sehen, dass das Ergebnis der Anfrage als Objekt verwendet wird, um ``isSuccess()``
aufzurufen. Mithilfe der magischen ``__toString()``-Methode kann man das Objekt bzw. das Ergebnis ausgeben
(*echo*). ``Zend_Rest_Client_Response`` erlaubt die Ausgabe jedes skalaren Wertes. Für komplexe Typen, kann
entweder die Array- oder die Objektschreibweise verwendet werden.

Wenn trotzdem ein Service abgefragt wird, der nicht ``Zend_Rest_Server`` verwendet, wird sich das
``Zend_Rest_Client_Response`` Objekt mehr wie ein *SimpleXMLElement* verhalten. Um die Dinge trotzdem einfacher zu
gestalten, wird das *XML* automatisch abgefragt, indem XPath verwendet wird, wenn die Eigenschaft nicht von
direkter Abstammung des Dokument Root-Elements ist. Zusätzlich, wenn auf eine Eigenschaft als Methode zugegriffen
wird, empfängt man den *PHP* Wert für das Objekt, oder ein Array mit den *PHP* Wert Ergebnissen.

.. _zend.rest.client.return.example-2:

.. rubric:: Technorati's REST Service verwenden

.. code-block:: php
   :linenos:

   $technorati = new Zend_Rest_Client('http://api.technorati.com/bloginfo');
   $technorati->key($key);
   $technorati->url('http://pixelated-dreams.com');
   $result = $technorati->get();
   echo $result->firstname() .' '. $result->lastname();

.. _zend.rest.client.return.example-3:

.. rubric:: Beispiel Technorati Antwort

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <!-- generator="Technorati API version 1.0 /bloginfo" -->
   <!DOCTYPE tapi PUBLIC "-//Technorati, Inc.//DTD TAPI 0.02//EN"
                         "http://api.technorati.com/dtd/tapi-002.xml">
   <tapi version="1.0">
       <document>
           <result>
               <url>http://pixelated-dreams.com</url>
               <weblog>
                   <name>Pixelated Dreams</name>
                   <url>http://pixelated-dreams.com</url>
                   <author>
                       <username>DShafik</username>
                       <firstname>Davey</firstname>
                       <lastname>Shafik</lastname>
                   </author>
                   <rssurl>
                       http://pixelated-dreams.com/feeds/index.rss2
                   </rssurl>
                   <atomurl>
                       http://pixelated-dreams.com/feeds/atom.xml
                   </atomurl>
                   <inboundblogs>44</inboundblogs>
                   <inboundlinks>218</inboundlinks>
                   <lastupdate>2006-04-26 04:36:36 GMT</lastupdate>
                   <rank>60635</rank>
               </weblog>
               <inboundblogs>44</inboundblogs>
               <inboundlinks>218</inboundlinks>
           </result>
       </document>
   </tapi>

Hier greifen wir auf die *firstname* und *lastname* Eigenschaften zu. Selbst wenn diese keine Top-Level Elemente
sind, werden Sie automatisch zurückgegeben, wenn auf sie durch ihren Namen zugegriffen wird.

.. note::

   **Mehrere Elemente**

   Wenn beim Zugriff, über einen Namen, mehrere Elemente mit demselben Namen gefunden werden, wird ein Array von
   SimpleXML-Elementen zurückgegeben. Beim Zugriff über die Methodenschreibweise wird ein Array von *PHP* Werten
   zurückgegeben.

.. _zend.rest.client.args:

Anfrage Argumente
-----------------

Wenn man eine Anfrage an einen Server sendet, welcher nicht auf ``Zend_Rest_Server`` basiert, sind die Chancen
groß, dass man mehrere Argumente mit der Anfrage senden muß. Das wird durchgeführt, indem man eine Methode mit
dem Namen des Arguments aufruft und den Wert, als das erste (und einzige) Argument übergibt. Jeder dieser
Methodenaufrufe, gibt das Objekt selbst zurück, was Verkettung oder "flüssige" Verwendung erlaubt. Der erste
Aufruf, oder das erste Argument, das übergeben wird, wenn man mehr als ein Argument übergeben will, wird immer
als die Methode angenommen wenn ein ``Zend_Rest_Server`` Service aufgerufen wird.

.. _zend.rest.client.args.example-1:

.. rubric:: Anfrage Argumente setzen

.. code-block:: php
   :linenos:

   $client = new Zend_Rest_Client('http://example.org/rest');

   $client->arg('value1');
   $client->arg2('value2');
   $client->get();

   // oder

   $client->arg('value1')->arg2('value2')->get();

Beide Varianten im obigen Beispiel, ergeben die folgenden get-Argumente:
*?method=arg&arg1=value1&arg=value1&arg2=value2*

Es gilt zu bemerken, dass der erste Aufruf von *$client->arg('value1');* in beidem resultiert:
*method=arg&arg1=value1* und *arg=value1*. Es ist so, dass ``Zend_Rest_Server`` die Anfrage korrekt versteht, ohne
dass vordefiniertes Wissen über das Service benötigt wird.

.. warning::

   **Striktheit von Zend_Rest_Client**

   Jeder REST Service der strikt in seinen Argumenten ist, die er empfängt, wird wegen dem oben beschriebenen
   Verhalten bei der Verwendung von ``Zend_Rest_Client`` fehlschlagen. Das ist keine gewöhnliche Praxis und sollte
   keine Probleme verursachen.



.. _`SOAP Web Service Erweiterung`: http://www.php.net/soap
