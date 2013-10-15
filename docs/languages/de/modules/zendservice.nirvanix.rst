.. EN-Revision: none
.. _zendservice.nirvanix:

ZendService\Nirvanix\Nirvanix
=====================

.. _zendservice.nirvanix.introduction:

Einführung
----------

Nirvanix bietet ein Internet Media File System (IMFS), einen Internet Speicher Service der es Anwendungen erlaubt
Dateien hochzuladen, zu speichern, zu organisieren und nachhaltig auf Sie zuzugreifen durch Verwendung eines
Standard Web Service Interfaces. Ein IMFS ist ein verteiltes geclustertes Dateisystem, auf das über das Internet
zugegriffen wird, und das für die Handhabung mit Mediendateien (Audio, Video, usw.) optimiert ist. Das Ziel eines
IMFA ist es massive Skalarität zu bieten um den Problemen des Wachstums der Medienspeicher Herr zu werden, mit
garantiertem Zugriff und Erreichbarkeit unabhängig von Zeit und Ort. Letztendlich, gibt eine IMFS Anwendung die
Möglichkeit auf Daten sicher zuzugreifen, ohne die großen Fixkosten die mit der Beschaffung und Einrichtung von
physikalischen Speicherbänken verbunden sind.

.. _zendservice.nirvanix.registering:

Registrierung bei Nirvanix
--------------------------

Bevor man mit ``ZendService\Nirvanix\Nirvanix`` beginnt, muß man sich zuerst für einen Account anmelden. Bitte sehen Sie
auf die `Wie man anfängt`_ Seite auf der Nirvanix Webseite für weitere Informationen.

Nach der Registrierung erhält man einen Benutzernamen, ein Passwort und einen Anwendungsschlüssel. Alle drei
werden benötigt um ``ZendService\Nirvanix\Nirvanix`` zu verwenden.

.. _zendservice.nirvanix.apiDocumentation:

API Dokumentation
-----------------

Der Zugriff auf Nirvanix IMFS ist durch beide, sowohl ein *SOAP* als auch ein schnelleres REST Service möglich.
``ZendService\Nirvanix\Nirvanix`` bietet einen relativ dünnen *PHP* 5 Wrapper um das REST Service.

``ZendService\Nirvanix\Nirvanix`` zielt darauf ab das Nirvanix REST Service einfacher zu verwenden aber zu verstehen dass
das Service selbst trotzdem noch essentiell ist um mit Nirvanix erfolgreich zu sein.

Die `Nirvanix API Dokumentation`_ bietet eine Übersicht sowie detailierte Informationen über die Verwendung des
Services. Bitte machen Sie sich mit diesem Dokument vertraut und referieren Sie darauf wenn Sie
``ZendService\Nirvanix\Nirvanix`` verwenden.

.. _zendservice.nirvanix.features:

Features
--------

Nirvanix's REST Service kann mit *PHP* effektiv verwendet werden alleine mit Hilfe der `SimpleXML`_ Erweiterung und
``Zend\Http\Client``. Trotzdem ist deren Verwendung auf diesem Weg irgendwie unbequem wegen der wiederholenden
Operationen, wie die Übergabe des Session Tokens bei jeder Anfrage und der wiederholten Prüfung des Antwort Bodys
nach Fehlercodes.

``ZendService\Nirvanix\Nirvanix`` bietet die folgenden Funktionalitäten:



   - Einen einzelnen Punkt für die Konfiguration der Nirvanix Authentifizierungs Daten die mit den Nirvanix
     Namespaces verwendet werden können.

   - Ein Proxy Objekt das viel bequemer ist als ein *HTTP* Client alleine, hauptsächlich wird die Notwendigkeit
     entfernt die *HTTP* POST Anfrage manuell zu erstellen um auf das REST Service zugreifen zu können.

   - Ein verantwortlicher Wrapper der jeden Antwortbody parst und eine Ausnahme wirft wenn ein Fehler aufgetreten
     ist, was die Notwendigkeit mildert widerholt den Erfolg der vielen Kommandos zu prüfen.

   - Zusätzliche bequeme Methoden für einige oder die meisten üblichen Operationen.



.. _zendservice.nirvanix.storing-your-first:

Der Anfang
----------

Sobald man in Nirvanix registriert ist, ist man bereit die ersten Datein am IMFS zu speichern. Die üblichste
Operation die man am IMFS benötigt ist der Erstellung einer neuen Datei, das Herunterladen bestehender Dateien,
und das Löschen einer Datei. ``ZendService\Nirvanix\Nirvanix`` bietet bequeme Methoden für diese drei Operationen.

.. code-block:: php
   :linenos:

   $auth = array('username' => 'Dein-Benutzername',
                 'password' => 'Dein-Passwort',
                 'appKey'   => 'Dein-App-Schlüssel');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $imfs->putContents('/foo.txt', 'zu speichernder Inhalt');

   echo $imfs->getContents('/foo.txt');

   $imfs->unlink('/foo.txt');

Der erste Schritt um ``ZendService\Nirvanix\Nirvanix`` zu verwenden ist immer sich gegenüber dem Service zu
authentifizieren. Das wird durch die Übergabe der Anmeldedaten an den Kontruktor von ``ZendService\Nirvanix\Nirvanix``,
wie oben, gemacht. Das assoziative Array wurd direkt an Nirvanix als POST Parameter übergeben.

Nirvanix teilt seine WebService in `Namespaces`_ auf. Jeder Namespace kapselt eine Gruppe von zusammengehörenden
Operationen. Nachdem man eine Instanz von ``ZendService\Nirvanix\Nirvanix`` erhalten hat, muß die ``getService()`` Methode
aufgerufen werden um einen Proxy für den Namespace zu erhalten den man verwenden will. Oben wird ein Proxy für
den ``IMFS`` Namespace erstellt.

Nachdem man den Proxy für den Namespace hat den man verwenden will, muß die Methode auf Ihm aufgerufen werden.
Der Proxy erlaubt es jedes Kommando zu verwenden das in der REST *API* vorhanden ist. Der Proxy kann auch bequeme
Methoden verfügbar machen, welche Kommandos des Web Services wrappen. Das obige Beispiel zeigt die Verwendung der
bequemen IMFS Methoden um eine neue Datei zu erstellen, sie zu empfangen, diese Datei anzuzeigen und letztendlich
die Datei zu löschen.

.. _zendservice.nirvanix.understanding-proxy:

Den Proxy verstehen
-------------------

Im vorherigen Beispiel wurde die ``getService()`` Methode verwendet um ein Proxy Objekt zum ``IMFS`` Namespace
zurückzugeben. Das Proxy Objekt erlaubt es das Nirvanix REST Service in einer Art zu verwenden die näher daran
ist wie normalerweise ein *PHP* Methodenaufruf durchgeführt wird, gegenüber der Erstellung von eigenen *HTTP*
Anfrage Objekten.

Ein Proxy Objekt kann bequeme Methoden enthalten. Das sind Methoden die ``ZendService\Nirvanix\Nirvanix`` bietet um die
Verwendung der Nirvanix Web Services zu vereinfachen. Im vorigen Beispiel haben die Methoden ``putContents()``,
``getContents()``, und ``unlink()`` keine direkte Entsprechungen in der REST *API*. Das sind bequeme Methoden die
von ``ZendService\Nirvanix\Nirvanix`` angeboten werden um viel komplexere Operationen der REST *API* zu abstrahieren.

Für alle anderen Methodenaufrufe zum Proxy Objekt konvertiert der Proxy dynamisch den Methodenaufruf in die
entsprechende *HTTP* POST Anfrage zur REST *API*. Hierbei wird der Name der Methode als *API* Kommando verwendet,
und ein assoziatives Array im ersten Argument als POST Parameter.

Nehmen wir an das wir die REST *API* Methode `RenameFile`_ aufrufen wollen welche keine bequeme Methode in
``ZendService\Nirvanix\Nirvanix`` besitzen:

.. code-block:: php
   :linenos:

   $auth = array('username' => 'Dein-Benutzername',
                 'password' => 'Dein-Passwort',
                 'appKey'   => 'Dein-App-Schlüssel');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->renameFile(array('filePath' => '/path/to/foo.txt',
                                     'newFileName' => 'bar.txt'));

Oben wird ein Proxy für den ``IMFS`` erstellt. Eine Methode, ``renameFile()``, wird dann vom Proxy aufgerufen.
Diese Methode existiert nicht als bequeme Methode im *PHP* Code, deswegen wird Sie durch ``__call()`` gefangen und
in eine POST Anfrage für die REST *API* umgewandelt wo das assoziative Array als POST Parameter verwendet wird.

Es ist in der Nirvanix *API* Dokumentation zu beachten das *sessionToken* für diese Methode benötigt wird, wir
dieses aber nicht an das Proxy Objekt übbergeben haben. Es wird, der Bequemlichkeit halber, automatisch
hinzugefügt.

Das Ergebnis dieser Operation ist entweder ein ``ZendService\Nirvanix\Response`` Objekt welches das von Nirvanix
zurückgegebene *XML* wrappt, oder ``ZendService\Nirvanix\Exception`` wenn ein Fehler aufgetreten ist.

.. _zendservice.nirvanix.examining-results:

Ergebnisse erkunden
-------------------

Die Nirvanix REST *API* gibt Ihre Ergebnisse immer in einem *XML* zurück. ``ZendService\Nirvanix\Nirvanix`` parst dieses
*XML* mit der *SimpleXML* Erweiterung und dekoriert dann das sich ergebende *SimpleXMLElement* mit einem
``ZendService\Nirvanix\Response`` Objekt.

Der einfachste Weg ein Ergebnis vom service zu betrachten ist die Verwendung der in *PHP* eingebauten Funktionen
wie ``print_r()``:

.. code-block:: php
   :linenos:

   <?php
   $auth = array('username' => 'Dein-Benutzername',
                 'password' => 'Dein-Passwort',
                 'appKey'   => 'Dein-App-Schlüssel');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->putContents('/foo.txt', 'Vierzehn Bytes');
   print_r($result);
   ?>

   ZendService\Nirvanix\Response Object
   (
       [_sxml:protected] => SimpleXMLElement Object
           (
               [ResponseCode] => 0
               [FilesUploaded] => 1
               [BytesUploaded] => 14
           ))

Auf jede Eigenschaft oder Methode des dekorierten *SimpleXMLElement*\ s kann zugegriffen werden. Im obigen
Beispiel, könnte *$result->BytesUploaded* verwendet werden um die anzahl von empfangenen Bytes zu sehen. Sollte
man auf das *SimpleXMLElement* direkt zugreifen wollen, kann einfach *$result->getSxml()* verwendet werden.

Die üblichste Antwort von Nirvanix ist Erfolg (*ResponseCode* von Null). Es ist normalerweise nicht notwendig
*ResponseCode* zu prüfen weil jedes nicht-null Ergebnis eine ``ZendService\Nirvanix\Exception`` wirft. Siehe das
nächste Kapitel über die Behandlung von Fehlern.

.. _zendservice.nirvanix.handling-errors:

Fehler behandeln
----------------

Wenn Nirvanix verwendet wird, ist es wichtig Fehler zu vermeiden die vom Service zurückgegeben werden können und
diese entsprechend zu behandeln.

Alle Operationen gegenüber dem REST Service ergeben einen *XML* RückgabePayload der ein *ResponseCode* Element,
wie im folgenden Beispiel, enthält:

.. code-block:: xml
   :linenos:

   <Response>
       <ResponseCode>0</ResponseCode>
   </Response>

Wenn *ResponseCode* Null ist, wie im obigen Beispiel, war die Operation erfolgreich. Wenn die Operation nicht
erfolgreich war, ist *ResponseCode* nicht-Null und ein *ErrorMessage* Element sollte vorhanden sein.

Um die Notwendigkeit zu verringern immer zu Prüfen ob *ResponseCode* Null ist, prüft ``ZendService\Nirvanix\Nirvanix``
automatisch jede von Nirvanix zurückgegebene Antwort. Wenn *ResponseCode* einen Fehler zeigt, wird eine
``ZendService\Nirvanix\Exception`` geworfen.

.. code-block:: xml
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');
   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);

   try {

     $imfs = $nirvanix->getService('IMFS');
     $imfs->unlink('/a-nonexistant-path');

   } catch (ZendService\Nirvanix\Exception $e) {
     echo $e->getMessage() . "\n";
     echo $e->getCode();
   }

im obigen Beispiel ist ``unlink()`` eine bequeme Methode die das *DeleteFiles* der REST *API* wrappt. Der
*filePath* Parameter wird vom `DeleteFiles`_ Kommando benötigt und enthält einen Pfad der nicht existiert. Das
wird in einer ``ZendService\Nirvanix\Nirvanix`` Ausnahme resultieren die, mit der Nachricht "Invalid Path" und Code 70005,
geworfen wird.

Die `Nirvanix API Dokumentation`_ beschreibt die mit jedem Kommando assoziierten Fehler. Abhängig von den eigenen
Bedürfnissen kann jedes Kommando in einen *try* Block eingebettet werden oder aus Bequemlichkeit, viele Kommandos
im selben *try* Block.



.. _`Wie man anfängt`: http://www.nirvanix.com/gettingStarted.aspx
.. _`Nirvanix API Dokumentation`: http://developer.nirvanix.com/sitefiles/1000/API.html
.. _`SimpleXML`: http://www.php.net/simplexml
.. _`Namespaces`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999879
.. _`RenameFile`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999923
.. _`DeleteFiles`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999918
