.. EN-Revision: none
.. _zend.gdata.exception:

Gdata Ausnahmen auffangen
=========================

Die ``ZendGData\App\Exception`` Klasse ist eine Basis Klasse für Ausnahmen die durch ``ZendGData`` geworfen
werden. Man kann jede durch ``ZendGData`` geworfene Ausnahme auffangen indem ``ZendGData\App\Exception``
aufgefangen wird.

.. code-block:: php
   :linenos:

   try {
       $client =
           ZendGData\ClientLogin::getHttpClient($username, $password);
   } catch(ZendGData\App\Exception $ex) {
       // Die Ausnahme an den Benutzer bekanntgeben
       die($ex->getMessage());
   }

Die folgenden Ausnahme Subklassen werden von ``ZendGData`` verwendet:



   - ``ZendGData\App\AuthException`` indiziert das die Benutzer Account Daten nicht gültig sind.

   - ``ZendGData\App\BadMethodCallException`` indiziert das eine Methode für ein Service aufgerufen wurde der
     diese Methode nicht unterstützt. Zum Beispiel unterstützt der CodeSearch Service ``post()`` nicht.

   - ``ZendGData\App\HttpException`` indiziert das eine *HTTP* Anfrage nicht erfolgreich war. Bietet die
     Möglichkeit das komplette ``Zend\Http\Request`` Objekt zu erhalten um den exakten Grund des Fehlers
     festzustellen in den Fällen in denen ``$e->getMessage()`` nicht genug Details liefert.

   - ``ZendGData\App\InvalidArgumentException`` wird geworfen wenn eine Anwendung einen Wert bietet der in dem
     gegebenen Kontext nicht gültig ist. Zum Beispiel wenn ein Kalender Sichtbarkeits Wert von "banana"
     spezifiziert wird, oder ein Blogger Feed geholt werden soll ohne einen Blog Namen zu spezifizieren.

   - ``ZendGData\App\CaptchaRequiredException`` wird geworfen wenn ein ClientLogin Versuch stattfindet und eine
     CAPTCHA(tm) Challenge vom Authentifikations Service empfangen wird. Diese Ausnahme enthält eine Token ID und
     eine *URL* zu einem CAPTCHA(tm) Challenge Bild. Dieses Bild ist ein visuelles Puzzle das dem Benutzer
     angezeigt werden sollte. Nachdem die Antwort des Benutzers auf dieses Challenge Bild gesammelt wurde, kann die
     Antwort im nächsten ClientLogin Versuch inkludiert werden. Alternativ kann der Benutzer direkt zu dieser
     Webseite geleitet werden: https://www.google.com/accounts/DisplayUnlockCaptcha Weitere Informationen
     können in der :ref:`ClientLogin Dokumentation <zend.gdata.clientlogin>` gefunden werden.



Man kann diese Ausnahme Subklassen verwenden um spezielle Ausnahmen unterschiedlich zu handhaben. Siehe die *API*
Dokumentation für Informationen darüber welche Ausnahme Subklassen durch welche Methoden in ``ZendGData``
geworfen werden.

.. code-block:: php
   :linenos:

   try {
       $client = ZendGData\ClientLogin::getHttpClient($username,
                                                       $password,
                                                       $service);
   } catch(ZendGData\App\AuthException $authEx) {
       // Die Benutzer Account Daten sind nicht korrekt.
       // Es wäre nett dem Benutzer einen zweiten Versuch zu geben.
       ...
   } catch(ZendGData\App\HttpException $httpEx) {
       // Google Data Server konnten nicht erreicht werden.
       die($httpEx->getMessage);
   }



