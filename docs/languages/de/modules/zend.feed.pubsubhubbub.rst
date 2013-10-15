.. EN-Revision: none
.. _zend.feed.pubsubhubbub.introduction:

Zend\Feed\Pubsubhubbub
======================

``Zend\Feed\Pubsubhubbub`` ist eine Implementation der PubSubHubbub Core 0.2 Spezifikation (Working Draft). Sie
bietet eine Implementation eines Pubsubhubbub Publizisten und Abonnenten geeignet für den Zend Framework und
andere *PHP* Anwendungen.

.. _zend.feed.pubsubhubbub.what.is.pubsubhubbub:

Was ist Pubsubhubbub?
---------------------

Pubsubhubbub ist ein offenes, einfaches Web-skalierbares Pubsub Protokoll. Der normale Anwendungsfall ist es Blogs
(Publizist) zu erlauben Aktualisierungen von deren *RSS* oder Atom Feeds (Themen) an Abonnenten zu "senden". Diese
Abonenten müssen dem *RSS* oder Atom Feed des Blogs über einen Hub abonniert haben. Das ist ein zentraler Server
der benachrichtigt wird wenn es Aktualisierungen des Publizisten gibt und diese anschließend an alle Abonnenten
verteilt. Jeder Feed kann bekanntgeben das er ein oder mehrere Hubs unterstützen indem ein Atom Namespaced
Linkelement mit dem Rel Attribut "hub" verwendet wird.

Pubsubhubbub hat Aufmerksamkeit erlangt weil es ein Pubsub Protokoll ist das einfach zu implementieren ist und
über *HTTP* arbeitet. Seine Philosophie ist es das traditionelle Modell zu ersetzen indem Blog Feeds mit einem
regulären Interfall abgefragt werden um Aktualisierungen zu erkennen und zu empfangen. Abhängig von der Frequenz
der Abfrage kann es viel Zeit in Anspruch nehmen Aktualisierungen an interessierte Menschen bei Sammelstellen bis
zu Desktop Lesern, bekannt zu machen. Mit der Verwendung eines Pubsub Systems werden Aktualisierungen nicht einfach
von Abonnenten abgefragt sondern an die Abonnenten geschickt, was jegliche Verzögerung ausschaltet. Aus diesem
Grund fungiert Pubsubhubbub als Teil von dem was als Echt-Zeit Web bekannt ist.

Das Protokoll existiert nicht isoliert. PubSub Systems gibt es schon seit einiger Zeit, wie auch das übliche
Jabber Publish-Subscribe Protokoll, *XEP-0060*, oder das nicht so bekannte rssCloud (beschrieben 2001). Trotzdem
haben diese keine keine breite Anwendung gefunden weil Sie entweder komplex sind, ein schlechtes Timing haben, oder
nicht für Web Anwendungen verwendbar sind. Bei rssCloud, welches zuletzt als Antwort auf das Erscheinen von
Pubsubhubbub revidiert wurde, wurde auch eine signifikante Steigerung gesehen obwohl es an einer formalen
Spezifikation fehlt und es aktuell keine Atom 1.0 Feeds unterstützt.

Warscheinlich überraschend weil es noch relativ Jung ist, ist Pubsubhubbub trotzdem bereits in Verwendung unter
anderem bei Google Reader, Feedburner und es sind Plugins für Wordpress Blogs vorhanden.

.. _zend.feed.pubsubhubbub.architecture:

Architektur
-----------

``Zend\Feed\Pubsubhubbub`` implementiert zwei Seiten der Pubsubhubbub 0.2 Spezifikation: einen Publizisten und
einen Abonnenten. Es implementiert aktuell keinen Hub Server. Dieser ist aber in Arbeit für ein zukünftiges Zend
Framework Release.

Ein Publizist ist verantwortlich für die Mitteilung aller Aktualisierungen seines Feeds an alle unterstützten
Hubs (es können viele unterstützt werden um Redundanz zu einem System hinzuzufügen), egal ob es sich um Atom
oder *RSS* basierte handelt. Das wird getan indem die unterstützten Hub Server mit der *URL* des aktualisierten
Feeds gepingt werden. In der Pubsubhubbub Terminologie wird jede aktualisierbare Ressource welche in der Lage ist
abonniert zu werden als Thema bezeichnet. Sobald ein Ping empfangen wird, frägt der Hub den aktualisierten Feed
ab, bearbeitet die aktualisierten Elemente, und leitet alle Aktualisierungen an alle Abonnenten weiter die diesen
Feed abonniert haben.

Ein Abonnent ist jedes Mitglied oder jede Anwendung welche einen oder mehrere Hubs abonniert um Aktuslisierungen
von einem Thema zu empfangen welches von einem Publizisten gehostet wird. Der Abonnent kommuniziert niemals direkt
mit dem Publizisten da der Hub als Zwischenglied fungiert welches Abos akzeptiert und Aktualisierungen an
Abonnenten sendet. Der Abonnent kommuniziert seinerseits nur mit dem Hub um Themen entweder zu abonnieren und Abos
zu entfernen, oder wenn er Aktualisierungen vom Hub empfängt. Dieses Design der Kommunikation ("Fat Pings")
entfernt effektiverweise die Möglichkeit eines "Thundering Herd" Problems. Dieses findet in einem Pubsub System
statt in dem der Hub Abonnenten über eine vorhandene Aktualisierung informiert, und alle Abonnenten dazu
auffordert den Feed sofort vom Publizisten zu empfangen, was zu einer Verkehrsspitze führt. In Pubsubhubbub
verteilt der Hub das aktuelle Update in einem "Fat Ping" so dass der Publizist keine Verkehrsspitze aushalten muss.

``Zend\Feed\Pubsubhubbub`` implementiert Pubsubhubbub Publizisten und Abonnenten mit den Klassen
``Zend\Feed\Pubsubhubbub\Publisher`` und ``Zend\Feed\Pubsubhubbub\Subscriber``. Zusätzlich kann die Implementation
des Abonnenten alle Feed Aktualisierungen behandeln die von einem Hub weitergeleitet werden indem
``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` verwendet wird. Diese Klassen, deren Verwendungszweck, und die
*API*\ s werden in den weiterführenden Abschnitten behandelt.

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.publisher:

Zend\Feed\Pubsubhubbub\Publisher
--------------------------------

In Pubsubhubbub ist der Publizist der Teilnehmer welcher einen lebenden Feed veröffentlicht und Ihn regelmäßig
mit neuem Inhalt aktualisiert. Das kann ein Blog, eine Sammlung, oder sogar ein Webservice mit einer öffentlichen
Feed basierenden *API* sein. Damit diese Aktualisierungen zu den Abonnenten geschickt werden können, muss der
Publizist alle seine unterstützten Hubs darüber informieren das eine Aktualisierung stattgefunden hat, indem eine
einfache *HTTP* *POST* Anfrage verwendet wird, welche die *URI* oder das aktualisierte Thema enthält (z.B. den
aktualisierten *RSS* oder Atom Feed). Der Hub bestätigt den Empfang der Benachrichtigung, holt den aktualisierten
Feed, und leitet alle Aktualisierungen an alle Abonnenten weiter welche sich bei diesem Hub für Aktualisierungen
für den relevanten Feed angemeldet haben.

Vom Design her bedeutet dies dass der Publizist sehr wenig zu tun hat ausser diese Hub Pings jedesmal zu senden
wenn sich seine Feeds ändern. Als Ergebnis hiervon ist die Implementation des Publizisten extrem einfach zu
verwenden und benötigt sehr wenig Arbeit für die Einrichtung und Verwendung wenn Feeds aktualisiert werden.

``Zend\Feed\Pubsubhubbub\Publisher`` implementiert einen kompletten Pubsubhubbub Publizisten. Sein Setup ist sehr
einfach und hauptsächlich müssen bei Ihm nur die *URI* Endpunkte für alle Hubs konfiguriert werden welche bei
Aktualisierungen benachrichtigt werden müssen, und die *URI*\ s aller Themen die in Benachrichtigungen einzubinden
sind.

Das folgende Beispiel zeigt einen Publizisten der eine Sammlung von Hubs über Aktualisierungen zu einem Paar von
lokalen *RSS* und Atom Feeds benachrichtigt. Die Klasse enthält eine Anzahl von Fehlern welche die *URL*\ s des
Hubs enthalten, damit Benachrichtigungen stäter wieder ausgeführt oder protokolliert werden können wenn
irgendeine Benachrichtigung fehlschlägt. Jedes resultierende Fehlerarray enthält auch einen "response" Schlüssel
welche das betreffende *HTTP* Antwortobjekt enthält. In Falle irgendeines Fehlers wird empfohlen die Operation
für den fehlgeschlagenen Hub Endpunkt in Zukunft zumindest noch einmal zu versuchen. Das kann die Verwendung einer
geplanten Aufgabe für diesen Zweck oder einer Job Queue wenn solche extra Schritte optional sind.

.. code-block:: php
   :linenos:

   $publisher = new Zend\Feed\Pubsubhubbub\Publisher;
   $publisher->addHubUrls(array(
       'http://pubsubhubbub.appspot.com/',
       'http://hubbub.example.com',
   ));
   $publisher->addUpdatedTopicUrls(array(
       'http://www.example.net/rss',
       'http://www.example.net/atom',
   ));
   $publisher->notifyAll();

   if (!$publisher->isSuccess()) {
       // Auf Fehler prüfen
       $errors     = $publisher->getErrors();
       $failedHubs = array()
       foreach ($errors as $error) {
           $failedHubs[] = $error['hubUrl'];
       }
   }

   // Benachrichtigung für fehlgeschlagene Hubs in $failedHubs nochmals planen

Wenn man eine konkretere Kontrolle über den Publizisten bevorzugt, gibt es die Methoden ``addHubUrls()`` und
``addUpdatedTopicUrls()`` welche jeden Arraywert an die einzelnen öffentlichen Methoden ``addHubUrl()`` und
``addUpdatedTopicUrl()`` übergeben. Es gibt auch passende ``removeUpdatedTopicUrl()`` und ``removeHubUrl()``
Methoden.

Man kann das Setzen der Hub *URI*\ s auch überspringen und jeden in Folge benachrichtigen indem die Methode
``notifyHub()`` verwendet wird welche die *URI* eines Hub Endpunkts als sein einziges Argument akzeptiert.

Es gibt keine anderen Aufgaben die abzudecken sind. Die Implementation des Publizisten ist sehr einfach da das
meiste der Feedbearbeitung und Verteilung von den ausgewählten Hubs durchgeführt wird. Es ist trotzdem wichtig
Fehler zu erkennen und Benachrichtigungen wieder so früh wie möglich zu planen (mit einer vernünftigen maximalen
Anzahl an Versuchen) um sicherzustellen das Benachrichtigungen alle Abonnenten erreichen. In vielen Fällen können
Hubs, als endgültige Alternative, den eigenen Feed regelmäßig abfragen um zusätzliche Toleranzen bei Fehlern
anzubieten sowohl wegen deren eigenen temporären Downtime als auch den Fehlern und der Downtime des Publizisten.

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.subscriber:

Zend\Feed\Pubsubhubbub\Subscriber
---------------------------------

In Pubsubhubbub ist der Abonnent ein Teilnehmer welcher Aktualisierungen zu irgendeinem Thema (einem *RSS* oder
Atom Feed) empfangen will. Er kann dass bewerkstelligen indem er einen oder mehrere Hubs abonniert welche von
diesem Thema beworben werden, normalerweise als ein Set von ein oder mehreren Atom 1.0 Links mit dem Rel Attribut
"hub". Ab diesem Punkt sendet der Hub, wenn er eine Benachrichtigung über eine Aktualisierung des Publizisten
empfängt, einen Atom oder *RSS* Feed, welcher alle Aktualisierungen enthält, zur Callback *URL* des Abonnenten.
Über diesen Weg muss der Abonnent niemals den originalen Feed besuchen (obwohl es trotzdem empfohlen wird um
sicherzustellen das Aktualisierungen empfangen werden wenn ein Hub jemals offline geht). Alle Anfragen für Abos
müssen die *URI* des Themas enthalten welches abonniert werden soll, und eine Callback *URL* welche der Hub
verwendet um das Abo zu bestätigen und um Aktualisierungen weiterzuleiten.

Der Abonnent hat deswegen zwei Rollen. Abos zu erstellen und zu managen, inklusive der Abonnierung von neuen Themen
mit einem Hub, dem kündigen von Abos (wenn notwendig), und periodisch Abos zu erneuern da diese eine begrenzte
Gültigkeit haben können was durch den Hub gesetzt wird. Dies wird von

Die zweite Rolle ist es Aktualisierungen zu akzeptieren welche vom Hub zur Callback *URL* des Abonnenten gesendet
werden, wenn z.B. die *URI* des Abonnenten zugeordnet wurde um Aktualisierungen zu behandeln. Die Callback *URL*
behandelt auch Events wenn der Hub den Abonnenten kontaktiert um alle Abos zu das Löschen von Abos zu bestätigen.
Dies wird behandelt indem eine Instanz von ``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` verwendet wird wenn auf
die Callback *URL* zugegriffen wird.

.. important::

   ``Zend\Feed\Pubsubhubbub\Subscriber`` implementiert die Pubsubhubbub Spezifikation 0.2. Da dies eine Version der
   Spezifikation ist implementieren Sie aktuell nicht alle Hubs. Die neue Spezifikation erlaubt der Callback *URL*
   einen Abfragestring einzubinden welcher von dieser Klasse verwendet, aber nicht von allen Hubs unterstützt
   wird. Im Interesse einer maximalen Kompatibilität wird deshalb empfohlen die Komponente des Abfragestrings der
   Callback *URI* des Abonnenten als Pfadelement darzustellen, z.B. als Parameter in der Route erkannt und mit der
   Callback *URI* assoziiert und vom Router der Anwendung verwendet.

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.subscriber.subscribing.and.unsubscribing:

Abonnieren und Abos löschen
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Pubsubhubbub\Subscriber`` implementiert einen kompletten Pubsubhubbub Abonnenten der in der Lage ist
jedes Thema über jeden Hub der von diesem Thema vermittelt wird zu abonnieren und Abos zu löschen. Er arbeitet in
Verbindung mit ``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` welcher Anfragen von einem Hub akzeptiert um alle
Aboanfragen und das Löschen von Abos zu bestätigen (um Missbrauch durch andere zu verhindern).

Jedes Abo (oder Löschen eines Abos) benötigt die betreffende Information bevor es bearbeitet werden kann, z.B.
die *URI* des Themas (Atom oder *RSS* Feed) das für Aktualisierungen abonniert werden soll, und die *URI* des
Endpunkts für den Hub welcher die Anmeldung auf das Abo bearbeitet und die Aktualisierungen weiterleitet. Die
Lebenszeit eines Abos kann durch den Hub ermittelt werden, aber die meisten Hubs sollten die automatische
Auffrischung des Abos unterstützen indem der Abonnenten geprüft wird. Das wird von
``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` unterstützt und benötigt keine weitere Arbeit. Es wird trotzdem
empfohlen dass man die vom Hub kommende Lebenszeit des Abos (time to live, ttl) verwendet um die Erstellung neuer
Abos zu planen (der Prozess ist identisch mit dem eines neuen Abos) um es beim Hub zu aktualisieren. Wärend das
per se nicht notwendig ist, deckt es Fälle ab in denen ein Hub die automatische Aktualisierung des Abos nicht
unterstützt und deckt damit Fehler des Hubs mit zusätzlicher Redundanz ab.

Mit der relevanten Information an der Hand kann eine Abonnierung wie anbei gezeigt versucht werden:

.. code-block:: php
   :linenos:

   $storage = new Zend\Feed\Pubsubhubbub\Model\Subscription;

   $subscriber = new Zend\Feed\Pubsubhubbub\Subscriber;
   $subscriber->setStorage($storage);
   $subscriber->addHubUrl('http://hubbub.example.com');
   $subscriber->setTopicUrl('http://www.example.net/rss.xml');
   $subscriber->setCallbackUrl('http://www.mydomain.com/hubbub/callback');
   $subscriber->subscribeAll();

Um Abos zu speichern und Zugriff auf dessen Daten für eine generelle Verwendung zu Speichern benötigt die
Komponente eine Datenbank (ein Schema wird später in diesem Abschnitt angeboten). Standardmäßig wird angenommen
das der Name der Tabelle "subscription" ist und im Hintergrund ``Zend\Db\Table\Abstract`` anwendet, was bedeutet
das der Standardadapter verwendet wird welcher in der Anwendung gesetzt ist. Man kann auch eine eigene spezielle
Instanz von ``Zend\Db\Table\Abstract`` in das assoziierte Modell von ``Zend\Feed\Pubsubhubbub\Model\Subscription``
übergeben. Dieser eigene Adapter kann so einfach wie gewünscht sein indem der Name der Tabelle welche zu
verwenden ist geändert wird, oder so komplex wie es notwendig ist.

Wärend das Modell als standardmäßige bereits verwendbare Lösung angeboten wird, kann man sein eigenes Modell
verwenden indem irgendein anderes Backend oder Datenbanklayer (z.B. Doctrine) verwendet wird, solange die
resultierende Klasse das Interface ``Zend\Feed\Pubsubhubbub\Model\SubscriptionInterface`` implementiert.

Ein Beispielschema (MySQL) für eine Abotabelle auf welche vom angebotenen Modell aus zugegriffen werden kann,
könnte wie folgt aussehen:

.. code-block:: sql
   :linenos:

   CREATE TABLE IF NOT EXISTS `subscription` (
     `id` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
     `topic_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
     `hub_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
     `created_time` datetime DEFAULT NULL,
     `lease_seconds` bigint(20) DEFAULT NULL,
     `verify_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
     `secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
     `expiration_time` datetime DEFAULT NULL,
     `subscription_state` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
     PRIMARY KEY (`id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Im Hintergrund sendet der Abonnent eine Anfrage an den Endpunkt des Hubs welche die folgenden Parameter enthält
(basierend auf dem vorhergehenden Beispiel):

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.subscriber.subscribing.and.unsubscribing.table:

.. table:: Anfrageparameter beim Abonnieren

   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Parameter        |Wert                                                                                             |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
   +=================+=================================================================================================+===============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |hub.callback     |http://www.mydomain.com/hubbub/callback?xhub.subscription=5536df06b5dcb966edab3a4c4d56213c16a8184|Die URI welche von einem Hub verwendet wird um den Abonnenten zu kontaktieren und entweder eine Bestätigung für eine Anfrage oder das Löschen eines Abos abzufragen oder Aktualisierungen für abonnierte Feeds zu senden. Der angehängte Abfragestring enthält einen eigenen Parameter (demzufolge der Zweck von xhub). Es ist ein Parameter für einen Abfragestring welcher vom Hub aufbewahrt um mit allen Anfragen des Abonnenten wieder versendet wird. Sein Zweck ist es dem Abonnenten zu erlauben sich zu identifizieren und die Abos zu betrachten welche mit einer beliebigen Hubanfrage in einem Backend=Speichermedium assoziiert sind. Das ist kein Standardparameter welcher von dieser Komponente verwendet wird statt einen Aboschlüssel im URI Pfad zu kodieren, was in einer Zend Framework Anwendung viel komplizierter zu implementieren wäre. Trotzdem, da nicht alle Hubs Parameter für den Abfragestring unterstützen wird empfohlen den Aboschlüssel als Pfadkomponente in der Form von http://www.mydomain.com/hubbub/callback/5536df06b5dcb966edab3a4c4d56213c16a8184 hinzuzufügen. Um das zu bewerkstelligen, wird die Definition einer Route benötigt welche in der Lage ist den endgültigen Wert des Schlüssels herauszuparsen den Wert zu erhalten und Ihn an das Callback Objekt des Abonnenten zu übergeben. Der Wert würde an die Methode Zend\Pubsubhubbub\Subscriber\Callback::setSubscriptionKey() übergeben. Ein detailiertes Beispiel wird später gezeigt.|
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.lease_seconds|2592000                                                                                          |Die Anzahl an Sekunden für welche der Abonnenten will dass ein neues Abo gültig bleibt (z.B. ein TTL). Hubs können Ihre eigene maximale Abodauer erzwingen. Alle Abos sollten erneuert werden indem einfach erneut abonniert wird bevor die Abodauer endet um die Kontinuierlichkeit der Aktualisierungen zu gewährleisten. Hubs sollten zusätzlich versuchen Abos automatisch zu aktualisieren bevor diese auslaufen indem die Abonnenten kontaktiert werden (dies wird automatisch von der Callback Klasse behandelt).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.mode         |subscribe                                                                                        |Ein einfacher Wert welche anzeigt das dies eine Aboanfrage ist. Anfragen für das Löschen von Abos würden den Wert "unsubscribe" verwenden.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.topic        |http://www.example.net/rss.xml                                                                   |Die URI des Themas (z.B. Atom oder RSS Feed) welche der Abonnent zu abonnieren wünscht damit er Aktualisierungen bekommt.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.verify       |sync                                                                                             |Zeigt dem Hub die bevorzugte Methode der Prüfung von Abos und dem Löschen von Abos. Sie wird im Normalfall zwei mal wiederholt. Technisch gesehen unterscheidet diese Komponente nicht zwischen den zwei Modi und behandelt beide gleich.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.verify       |async                                                                                            |Zeigt dem Hub die bevorzugte Methode der Prüfung von Abos und dem Löschen von Abos. Sie wird im Normalfall zwei mal wiederholt. Technisch gesehen unterscheidet diese Komponente nicht zwischen den zwei Modi und behandelt beide gleich.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hub.verify_token |3065919804abcaa7212ae89.879827871253878386                                                       |Ein Prüftoken welcher dem Abonnenten vom Hub zurückgegeben wird wenn er ein Abos oder das Löschen eines Abos bestätigt. Bietet ein Maß an Vertrauen dass die Bestätigung der Anfrage vom aktuellen Hub kommt um Missbrauch zu vermeiden.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +-----------------+-------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Man kann verschiedene dieser Parameter verändern um eine andere Vorliebe anzuzeigen. Zum Beispiel kann man eine
anderen Wert der Gültigkeit in Sekunden setzen indem man ``Zend\Pubsubhubbub\Subscriber::setLeaseSeconds()``
verwendet, oder eine Vorliebe für eine asynchrone Prüfung zeigen indem
``setPreferredVerificationMode(Zend\Feed\Pubsubhubbub::VERIFICATION_MODE_ASYNC)`` verwendet wird. Trotzdem bleiben
die Hubs in der Lage Ihre eigenen Vorlieben zu erzwingen, und aus diesem Grund wurde die Komponente so designt dass
Sie mit fast jedem Set an Optionen arbeitet und eine minimale Konfiguration des End-Benutzers erfordert.
Konventionen sind toll wenn Sie funktionieren!

.. note::

   Wärend Hubs die Verwendung eines spezifischen Prüfmodus benötigen können (beide werden von
   ``Zend_Pubsubhubbub`` unterstützt), kann eine spezifische die zu bevorzugen ist durch Verwendung der Method
   ``Zend_Pubsubhubbub`` angezeigt werden. Im Modus "sync" (synchron) versucht der Hub eine Aboanfrage sofort zu
   bestätigen sobald diese empfangen, und noch bevor auf die Aboanfrage geantwortet wird. Im Modus "async"
   (asynchron) gibt der Hub sofort eine Antwort auf die Aboanfrage zurück, und die Prüfanfrage kann später
   stattfinden. Da ``Zend_Pubsubhubbub`` die Rolle der Aboprüfung als eigene Callback Klasse implementiert, und
   die Verwendung eines Backend Speichermediums, unterstützt Sie beide transparent im Sinne der Geschwindigkeit
   des Endbenutzers. Die acynchrone Prüfung ist stark zu bevorzugen um die Nachteile eines schlecht performenden
   Hubs zu eliminieren, und die Server Ressourcen des End-Benutzers und die Verbindungen nicht zu lange zu binden.

Das Löschen eines Abos folgt exakt dem gleichen Pattern wie im vorherigen Beispiel, mit der Ausnahme das
stattdessen ``unsubscribeAll()`` aufgerufen wird. Die enthaltenen Parameter sind identisch mit einer Aboanfrage mit
der Ausnahme das "``hub.mode``" auf "unsubscribe" gesetzt wird.

Standardmäßig versucht eine neue Instanz von ``Zend\Pubsubhubbub\Subscriber`` ein Datenbank Backend
Speichermedium zu verwenden mit Standardwerten um den standardmäßigen ``Zend_Db`` Adapter mit dem Tabellennamen
"subscription" zu verwenden. Es wird empfohlen eine eigene Speicherlösung zu setzen welche diese Standardwerte
nicht verwendet, entweder duch übergabe eines neuen Modells welches das benötigte Interface unterstützt, oder
durch Übergabe einer neuen Instanz von ``Zend\Db\Table\Abstract`` an dem Constructor des standardmäßigen Modells
um den verwendeten Tabellennamen zu verändern.

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.subscriber.handling.hub.callbacks:

Callbacks von Abonnenten behandeln
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wann auch immer eine Aboanfrage oder eine Anfrage auf Löschen eines Abos gemacht wird muss der Hub die Anfrage
prüfen indem er eine neue Prüfanfrage an die Callback *URL* weiterleitet welche in den Abo or Abo löschen
Parametern gesetzt ist. Um diese Hub Anfragen zu behandeln, welche alle zukünftigen Kommunikationen enthalten
können wie z.B. Themenaktualisierungen (Feed), sollte die Callback *URL* die Ausführung einer Instanz von
``Zend\Pubsubhubbub\Subscriber\Callback`` auslösen um die Anfrage zu behandeln.

Die Callback Klasse sollte konfiguriert werden dass Sie das selbe Speichermedium wie die Subscriber Klasse
verwendet. Ihre Verwendung ist sehr einfach da die meiste Arbeit intern erledigt wird.

.. code-block:: php
   :linenos:

   $storage = new Zend\Feed\Pubsubhubbub\Model\Subscription;
   $callback = new Zend\Feed\Pubsubhubbub\Subscriber\Callback;
   $callback->setStorage($storage);
   $callback->handle();
   $callback->sendResponse();

   /**
    * Prüfe ob der resultierende Callback das Ergebnis eines Feed Updates ist.
    * Andernfalls war es entweder eine (De-)Abo-Prüfanfrage oder ungültig.
    * Typischerweise müssen wir nicht mehr tun als die Behandlung der
    * Aktualisierungen vom Feed hinzuzufügen - der Rest wird intern von der
    * Klasse behandelt.
    */
   if ($callback->hasFeedUpdate()) {
       $feedString = $callback->getFeedUpdate();
       /**
        * Die Aktualisierung des Feeds asynchron bearbeiten um ein Timeout
        * des Hubs zu vermeiden.
        */
   }

.. note::

   Es sollte beachtet werden dass ``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` jeden hereinkommenden
   Anfragestring und andere Parameter unabhängig parsen kann. Dies ist notwendig da *PHP* die Struktur und
   Schlüssel eines Abfragestrings ändert wenn diese in die Superglobals ``$_GET`` oder ``$_POST`` geparst wird.
   Zum Beispiel werden alle doppelten Schlüssel ignoriert und Punkte werden in Unterstriche konvertiert.
   Pubsubhubbub unterstützt beide in den Abfragestring die es erzeugt.

.. important::

   Es ist wichtig das Entwickler erkennen das Hubs nur mit dem Senden von Anfragen und dem Empfangen einer Antwort
   beschäftigt sind welche den Empfang prüft. Wenn eine Feedaktualisierung empfangen wird sollte Sie niemals
   nachfolgend bearbeitet werden da Sie den Hub auf eine Antwort warten lässt. Stattdessen sollte jede Bearbeitung
   auf einen anderen Prozess ausgelagert werden oder verzögert bis eine Antwort zum Hub zurückgesendet wird. Ein
   Symptom des Fehlers Hubanfragen sofort zu komplettieren besteht darin das ein Hub weitere Versuche durchführen
   kann die Aktualisierungs- oder Prüfanfrage zuzustellen was zu doppelten Aktualisierungsversuchen führen kann
   die vom Abonnenten bearbeitet werden. Das scheint problematisch zu sein -- aber in Wirklichkeit kann ein Hub ein
   Timeout von ein paar Sekunden anwenden, und wenn keine Antwort in dieser Zeit empfangen wird kann er trennen (in
   der annahme eines Zustellfehlers) und es später nochmal versuchen. Es ist zu beachten das von Hubs erwartet
   wird das Wie große Mengen an Aktualisierungen verteilen und Ihre Ressources deswegen gestreckt sind - bitte
   bearbeiten Sie Feeds asynchron (z.B. in einem separaten Prozess oder einer Job Queue oder sogar in einem
   geplanten Cron Task) soweit das möglich ist.

.. _zend.feed.pubsubhubbub.zend.feed.pubsubhubbub.subscriber.setting.up.and.using.a.callback.url.route:

Eine Callback URL Route einstellen und verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wie vorher erwähnt empfängt die Klasse ``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` den kombinierten Schlüssel
welche mit jedem Abo assoziiert ist vom Hub über eine oder zwei Methoden. Die technisch bevorzugte Methode ist das
Hinzufügen dieses Schlüssels zur Callback *URL* welcher für den Hub in allen zukünftigen Anfragen tätig ist
indem ein Stringparameter in der Abfrage mit dem Schlüssel "xhub.subscription" verwendet wird. Trotzdem, aus
historischen Gründen, weil es in Pubsubhubbub 0.1 nicht unterstützt wurde (es wurde kürzlich nur in 0.2
hinzugefügt) ist es stärkstens empfohlen das kompatibelste zu verwenden und den Schlüssel der Callback *URL*
hinzuzugefügen indem er den *URL* Pfaden angehängt wird.

Deshalb würde die *URL* http://www.example.com/callback?xhub.subscription=key zu
http://www.example.com/callback/key werden.

Da die Abfragestring Methode der Standard in der Vermeidung eines größeren Levels der zukünftigen Unterstützung
der kompletten 0.2 Spezifikation ist, benötigt es etwas zusätzliche Arbeit um Sie zu implementieren.

Der erste Schritt besteht darin der Klasse ``Zend\Feed\Pubsubhubbub\Subscriber\Callback`` dem Pfad bewusst zu
machen welcher den Aboschlüssel enthält. Er wird hierfür manuell injiziert, da man für diesen Zweck auch eine
Route manuell definieren muss. Das wird erzielt indem einfach die Methode
``Zend\Feed\Pubsubhubbub\Subscriber\Callback::setSubscriptionKey()`` mit dem Parameter aufgerufen wird welcher der
Schlüsselwert ist der vom Router kommt. Das folgende Beispiel zeigt dies durch Verwendung eines Zend Framework
Controllers.

.. code-block:: php
   :linenos:

   class CallbackController extends Zend\Controller\Action
   {

       public function indexAction()
       {
           $storage = new Zend\Feed\Pubsubhubbub\Model\Subscription;
           $callback = new Zend\Feed\Pubsubhubbub\Subscriber\Callback;
           $callback->setStorage($storage);
           /**
            * Injiziert den Aboschlüssel welcher er vom URL Pfad geparst wird
            * indem ein Parameter vom Router verwendet wird
            */
           $subscriptionKey = $this->_getParam('subkey');
           $callback->setSubscriptionKey($subscriptionKey);
           $callback->handle();
           $callback->sendResponse();

           /**
            * Prüfen ob der Callback als Ergebnis den Empfang eines Feed Updates
            * enthält. Anderfalls war es entweder eine De-Aboprüfungsanfrage oder
            * eine ungültige Anfrage. Typischerweise muss nichts anderes getan
            * werden als das Handling der Feedaktualisierungen hinzuzufügen - der
            * Rest wird intern von der Klasse behandelt.
            */
           if ($callback->hasFeedUpdate()) {
               $feedString = $callback->getFeedUpdate();
               /**
                * Die Aktualisierung des Feeds asynchron behandeln um Hub
                * Timeouts zu vermeiden.
                */
           }
       }

   }

Aktuell kann das Hinzufügen der Route zu einem Parameter welcher den Schlüssel der an den Pfad angehängt wird
mappen würde durchgeführt werden indem eine Routenkonfiguration wie im kommenden *INI* formatierten Beispiel für
die Verwendung mit dem Bootstrapping von ``Zend_Application`` verwendet wird.

.. code-block:: ini
   :linenos:

   ; Callback Route fürs Hinzufügen einer PuSH Aboschlüssel Abfrage zu aktivieren
   resources.router.routes.callback.route = "callback/:subkey"
   resources.router.routes.callback.defaults.module = "default"
   resources.router.routes.callback.defaults.controller = "callback"
   resources.router.routes.callback.defaults.action = "index"


