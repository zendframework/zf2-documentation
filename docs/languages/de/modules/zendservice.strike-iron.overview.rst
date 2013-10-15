.. EN-Revision: none
.. _zendservice.strikeiron:

ZendService\StrikeIron\StrikeIron
=======================

``ZendService\StrikeIron\StrikeIron`` bietet einen *PHP* 5 Clienten zu den Web Services von StrikeIron. Siehe die folgenden
Sektionen:



   - :ref:`ZendService\StrikeIron\StrikeIron <zendservice.strikeiron>`



   - :ref:`Gebündelte Services <zendservice.strikeiron.bundled-services>`



   - :ref:`Fortgeschrittene Benutzung <zendservice.strikeiron.advanced-uses>`



.. _zendservice.strikeiron.overview:

Übersicht
---------

`StrikeIron`_ bietet hunderte von kommerziellen Daten Services ("Daten als Service") wie z.B. Online Steuer,
Wärungsraten, Aktienwerte, Geocodes, Globale Adresen Prüfung, Yallow/White Pages, MapQuest Fahranleitungen, Dun &
Bradstreet Business Credit Prüfungen, und viele, viele mehr.

Jedes StrikeIron Web Service bietet eine standard *SOAP* (und REST) *API*, welche die Integration und Handhabung
mehrerer Services sehr einfach macht. StrikeIron managt auch die Kundenverrechnung für alle Services in einem
einzelnen Account, was es für Lösungsanbieter perfekt macht. Man kann mit freien WebServices unter
http://www.strikeiron.com/sdp starten.

Die Services von StrikeIron können schon alleine durch die `PHP 5 SOAP Erweiterung`_ verwendet werden. Trotzdem
bietet die Verwendung von StrikeIron auf diesem Weg kein ideales *PHP*-artiges Interface. Die
``ZendService\StrikeIron\StrikeIron`` Componente bietet einen leichtgewichtigen Layer aufbauend auf der *SOAP* Erweiterung
für die Arbeit mit den Services von StrikeIron auf einem bequemeren und *PHP*-artigeren Weg.

.. note::

   Die *PHP* 5 *SOAP* Erweiterung muß installiert und aktiviert sein um ``ZendService\StrikeIron\StrikeIron`` zu verwenden.

Die ``ZendService\StrikeIron\StrikeIron`` Komponente bietet:



   - Einen einzigen Punkt für die Konfiguration der eigenen Authentifizierungsdaten für StrikeIron die durch alle
     StrikeIron Services hinweg verwendet werden können.

   - Einen standardtisierten Weg um die eigenen StrikeIron Einwahl Informationen wie den Lizenz Status und die
     Anzahl von verbleibenden Hits zu einem Service zu erhalten.

   - Die Möglichkeit jedes StrikeIron Service von deren WSDL aus zu verwenden ohne eine *PHP* Wrapper Klasse zu
     erstellen, und die Option einen Wrapper für ein bequemeres Interface zu erstellen.

   - Wrapper für drei populäre StrikeIron Services.



.. _zendservice.strikeiron.registering:

Registrieren mit StrikeIron
---------------------------

Bevor man mit ``ZendService\StrikeIron\StrikeIron`` beginnen kann, muß man sich zuerst für einen StrikeIron Entwickler
Zugang `registrieren`_.

Nach der Registrierung erhält man einen StrikeIron Benutzernamen und ein Passwort. Diese werden Verwendet wenn man
sich auf StrikeIron verbindet indem man ``ZendService\StrikeIron\StrikeIron`` verwendet.

Man muß sich auch für StrikeIron's Super Data Pack Web Service `anmelden`_.

Beide Schritte der Registrierung sind frei und können relativ schnell mit der WebSeite von StrikeIron
durchgeführt werden.

.. _zendservice.strikeiron.getting-started:

Beginnen
--------

Sobald man sich für einen StrikeIron Account `registriert`_ und für das `Super Data Pack`_ angemeldet hat, ist
man für die Benutzung von ``ZendService\StrikeIron\StrikeIron`` bereit.

StrikeIron besteht aus hunderten von verschiedenen WebServices. ``ZendService\StrikeIron\StrikeIron`` kann mit vielen dieser
Services verwendet werden bietet aber nur für drei von Ihnen unterstützte Wrapper:

- :ref:`ZIP Code Informationen <zendservice.strikeiron.bundled-services.zip-code-information>`

- :ref:`US Addressen Prüfung <zendservice.strikeiron.bundled-services.us-address-verification>`

- :ref:`Verkaufs- & Steuergrundlagen <zendservice.strikeiron.bundled-services.sales-use-tax-basic>`

Die Klasse ``ZendService\StrikeIron\StrikeIron`` bietet einen einfachen Web um die eigenen Account Informationen von
StrikeIron und andere Option im Konstruktor zu spezifizieren. Sie bietet auch eine Factory Methode die Clients für
StrikeIron Services zurück gibt:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

Die ``getService()`` Methode gibt einen Client für irgendein StrikeIron Service zurück das durch den Namen seiner
*PHP* Wrapper Klasse definiert wurde. In diesem Fall, referiert der Name 'SalesUseTaxBasic' zu der Wrapper Klasse
``ZendService\StrikeIron\SalesUseTaxBasic``. Wrapper sind für drei Services inkludiert und in :ref:`Bundled
Services <zendservice.strikeiron.bundled-services>` beschrieben.

Die ``getService()`` Methode kann auch einen Client für ein StrikeIron Service zurückgeben das bisher keinen
*PHP* Wrapper hat. Das wird in :ref:`Services durch WSDL verwenden
<zendservice.strikeiron.advanced-uses.services-by-wsdl>` erklärt.

.. _zendservice.strikeiron.making-first-query:

Die erste Abfrage durchführen
-----------------------------

Sobald die ``getService()`` Methode verwendet wurde um einen Clienten für ein gewünschtes StrikeIron Service zu
erhalten, kann dieser Client verwendet werden durch Aufruf seiner Methoden ganz wie jedes andere *PHP* Objekt.

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Einen Client für das Verkaufs / Steuerbasis Service erhalten
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Steuerrate für Ontario, Canada abfragen
   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
   echo $rateInfo->province;
   echo $rateInfo->abbreviation;
   echo $rateInfo->GST;

Im obigen Beispiel wird die ``getService()`` Methode verwendet um einen Client zum :ref:`Verkaufs- &
Steuergrundlagen <zendservice.strikeiron.bundled-services.sales-use-tax-basic>` Service zu erhalten. Das Client
Objekt wird in ``$taxBasic`` gespeichert.

Die ``getTaxRateCanada()`` Methode wird dann vom Service aus aufgerufen. Ein assoziatives Array wird verwendet um
der Methode Schlüssel Parameter anzugeben. Das ist der Weg auf dem alle StrikeIron Methoden aufgerufen werden.

Das Ergebnis von ``getTaxRateCanada()`` wird in ``$rateInfo`` gespeichert und hat Eigenschaften wie ``province``
und ``GST``.

Viele der Services von StrikeIron sind so einfach wie das obige Beispiel. Siehe :ref:`mitgelieferte Services
<zendservice.strikeiron.bundled-services>` für detailierte Informationen zu drei der Services von StrikeIron.

.. _zendservice.strikeiron.examining-results:

Ergebnisse betrachten
---------------------

Wenn man Services von StrikeIron lernt oder versucht fehler zu beheben, ist es oft nützlich das Ergebnis das von
einem Methodenaufruf zurückgegeben wird auszugeben. Das Ergebnis wird immer ien Objekt sein das eine Instanz von
``ZendService\StrikeIron\Decorator`` ist. Das ist ein kleines `Dekorator`_ Objekt das die Ergebnisse des Methoden
Aufrufs ummantelt.

Der einfachste Weg ein Ergebnis vom Service zu betrachten ist die Verwendung der eingebauten *PHP* Methode
`print_r()`_:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
   print_r($rateInfo);
   ?>

   ZendService\StrikeIron\Decorator Object
   (
       [_name:protected] => GetTaxRateCanadaResult
       [_object:protected] => stdClass Object
           (
               [abbreviation] => ON
               [province] => ONTARIO
               [GST] => 0.06
               [PST] => 0.08
               [total] => 0.14
               [HST] => Y
           )
   )

In der obigen Ausgabe sehen wir das der Dekorator (``$rateInfo``) ein Objekt ummantelt das
``GetTaxRateCanadaResult`` heißt, und das Ergebnis des Aufrufes von ``getTaxRateCanada()`` ist.

Das bedeutet das ``$rateInfo`` öffentliche Eigenschaften wie ``abbreviation``, ``province``, und ``GST`` hat.
Dieser werden z.B. mit ``$rateInfo->province`` aufgerufen.

.. tip::

   Die Eigenschaften von StrikeIron Ergebnissen beginnen oft mit einem Großbuchstaben wie ``Foo`` oder ``Bar``
   wobei die meisten *PHP* Objekt Eigenschaften normalerweise mit einem Kleinbuchstaben wie ``foo`` oder ``bar``
   beginnen. Der Dekorator wird diesen Eingriff automatisch durchführen sodas eine Eigenschaft von ``Foo`` als
   ``foo`` gelesen werden kann.

Wenn man jemals das originale Objekt oder seinen Namen vom Dekorator heraus benötigt können die Methoden
``getDecoratedObject()`` und ``getDecoratedObjectName()`` verwendet werden.

.. _zendservice.strikeiron.handling-errors:

Fehler handhaben
----------------

Die vorigen Beispiel sind naiv, was bedeutet das keine Handhabung von Fehlern gezeigt wurde. Es ist möglich das
StrikeIron einen Fehler zurückgibt wärend des Aufrufs einer Methode. Selbst fehlerhafte Account Daten oder ein
abgelaufener Zugang kann StrikeIron dazu bringen einen Fehler zu werfen.

Eine Ausnahme wird geworfen wenn solch ein Fehler auftritt. Man sollte das berücksichtigen und solche Ausnahmen
fangen wenn man Methodenaufrufe zu einem Service durchführt:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   try {

     $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

   } catch (ZendService\StrikeIron\Exception $e) {

     // Fehler handhaben für Events wie Verbindungsprobleme oder Account Probleme

   }

Die geworfenen Ausnahmen werden immer ``ZendService\StrikeIron\Exception`` sein.

Es ist wichtig die Unterschiede zwischen Ausnahmen und normalen fehlgeschlagenen Methodenaufrufen zu verstehen.
Ausnahmen treten für **ausgenommene** Verhaltenweisen auf, wie z.B. ein Netzwerk das abstürzt oder ein
abgelaufener Account. Fehlgeschlagene Methodenaufrufe die häufig auftreten, wie z.B. wenn ``getTaxRateCanada()``
die angegebene ``province`` nicht findet, führen nicht dazu das Ausnahmen geworfen werden.

.. note::

   Jedesmal wenn ein Methodenaufruf zu einem Service von StrikeIron durchgeführt wird, sollte das Ergebnis Objekt
   auf Gültigkeit geprüft werden und man sollte genauso vorsehen eine Ausnahme zu fangen.



.. _zendservice.strikeiron.checking-subscription:

Den eigenen Account prüfen
--------------------------

StrikeIron bietet viele verschiedene Services. Einige von Ihnen sind kostenlos, eine sind auf einer Testbasis
vorhanden, und einige sind nur für zahlende Kunden. Wenn StrikeIron verwendet wird, ist es wichtig auf den Account
Status für die Services zu achten die man verwendet und diesen regelmäßig zu prüfen.

Jeder StrikeIron Client, der von der ``getService()`` Methode zurückgegeben wird, hat die Möglichkeit den Account
Status für diesen Service zu prüfen indem die ``getSubscriptionInfo()`` Methode dieses Clients verwendet wird:

.. code-block:: php
   :linenos:

   // Einen Client für das Verkaufs / Steuerbasis Service erhalten
   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   $taxBasic = $strikeIron->getService(array('class => 'SalesUseTaxBasic'));

   // Prüfe die noch möglichen Zugriffe für das Verkaufs- & Steuerbasis Service
   $subscription = $taxBasic->getSubscriptionInfo();
   echo $subscription->remainingHits;

Die ``getSubscriptionInfo()`` Methode gibt ein Objekt zurück, das typischerweise eine ``remainingHits``
Eigenschaft hat. Es ist wichtig den Status, für jeden Service der verwendet wird, zu prüfen. Wenn ein
Methodenaufruf zu StrikeIron gemacht wird, nachdem die möglichen Zugriffe aufgebraucht wurden, wird eine Ausnahme
auftreten.

Das Prüfen des Accounts zu einem Service benötigt keinen Zugriff (hit) auf diesen Server. Jedes Mal wenn
irgendein Methodenaufruf zu einem Service gemacht wurde, wird die Anzahl der möglichen Zugriffe gecached und
dieser gecachete Wert wird durch ``getSubscriptionInfo()`` zurückgegeben ohne das noch einmal mit dem Service eine
Verbindung aufgebaut werden muß. Um ``getSubscriptionInfo()`` dazu zu bringen seinen Cache auszuschalten und die
Account Informationen nochmals abzufragen, kann ``getSubscriptionInfo(true)`` verwendet werden.



.. _`StrikeIron`: http://www.strikeiron.com
.. _`PHP 5 SOAP Erweiterung`: http://us.php.net/soap
.. _`registrieren`: http://strikeiron.com/Register.aspx
.. _`anmelden`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`registriert`: http://strikeiron.com/Register.aspx
.. _`Super Data Pack`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`Dekorator`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`print_r()`: http://www.php.net/print_r
