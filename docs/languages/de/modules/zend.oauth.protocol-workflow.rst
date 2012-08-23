.. EN-Revision: none
.. _zend.oauth.introduction.protocol-workflow:

Workflow des Protokolls
=======================

Bevor OAuth implementiert wird macht es Sinn zu verstehen wie das Protokoll arbeitet. Hierfür nehmen wir ein
Beispiel von Twitter welches aktuell bereits OAuth basierend auf der OAuth Core 1.0 Revision A Spezifikation
imeplementiert. Dieses Beispiel sieht das Protokoll aus der Perspektive des Benutzers (der den Zugriff gestattet),
dem Konsumenten (der den Zugriff anfragt) und dem Provider (der die privaten Daten des Benutzers hat). Ein Zugriff
kann nur-lesend, oder lesend und schreibend sein.

Durch Zufall hat unser Benutzer entschieden das er einen neuen Service verwenden will der TweetExpress genannt wird
und behauptet in der Lage zu sein Blog Posts bei Twitter in wenigen Sekunden nochmals zu posten. TweetExpress ist
bei Twitter eine registrierte Anwendung was bedeutet das es Zugriff auf einen Konsumentenschlüssel und ein
Geheimnis des Konsumenten hat (alle OAuth Anwendungen müssen diese vom Provider haben auf welchen Sie zugreifen
wollen) welche seine Anfragen bei Twitter identifizieren und sicherstellen das alle Anfragen signiert werden
können indem das Geheimnis des Konsumenten verwendet wird um deren Herkunft zu prüfen.

Um TweetExpress zu verwenden wird man danach gefragt sich für einen neuen Account zu registrieren, und das der
Registrierung wird sichergestellt das man dafüber informiert ist das TweetExpress den eigenen Twitter Account mit
dem Service assoziiert.

In der Zwischenzeit was TweenExpress beschäftigt. Bevor das Einverständnis von Twitter gegeben wird, hat es eine
*HTTP* Anfrage an den Service von Twitter geschickt und nach einem neuen unauthorisierten Anfrage Token gefragt.
Dieser Token ist aus der Perspektive von Twitter nicht Benutzerspezifisch, aber TweetExpress man Ihn spezifisch
für den aktuellen Benutzer verwenden und sollte Ihn mit seinem Account verknüpfen und Ihn für eine künftige
Verwendung speichern. TweetExpress leitet den Benutzer nun zu Twitter um damit er den Zugriff von TweetExpress
erlauben kann. Die URL für diese Umleitung wird signiert indem das Konsumentengeheimnis von TweetExpress verwendet
wird und Sie enthält den unauthorisierten Anfrage Token als Parameter.

An diesem Punkt kann der Benutzer gefragt werden sich in Twitter anzumelden und wird jetzt mit einem Twitter
Bildschirm konfrontiert welcher Ihn fragt ob er diese Anfrage von TweetExpress für den Zugriff auf die *API* von
Twitter im Auftrag des Benutzers gestattet. Twitter speichert die Antwort von der wir annehmen das Sie positiv war.
Basierend auf dem Einverständnis des Benutzers speichert Twitter den aktuell unauthorisierten Anfrage Token als
vom Benutzer akzeptiert (was Ihn Benutzerspezifisch macht) und erzeugt einen neuen Wert in der Form eines
Überprüfungscodes. Der Benutzer wird jetzt auf eine spezifische Callback URL zurückgeleitet welche von
TweetExpress verwendet wird (diese Callback URL kann bei Twitter registriert sein, oder dynamisch gesetzt werden
indem bei den Anfragen ein oauth_callback Parameter verwendet wird). Die Umleitungs-URL wird den neu erzeugten
Überprüfungscode enthalten.

Die Callback URL von TweetExpress löst eine Überprüfung der Anfrage aus um zu erkennen ob der Benutzer seine
Zustimmung an Twitter gegeben hat. Wir nehmen an das dies der Fall war, dann kann jetzt sein nicht authorisierter
Anfrage Token gegen einen voll authorisierten Anfrage Token getauscht werden indem eine Anfrage an Twitter
zurückgesendet wird inklusive dem Anfrage Token und dem empfangenen Überprüfungscode. Twitter sollte jetzt eine
Antwort zurücksenden welche diesen Zugriffstoken enthält welcher in allen Anfragen verwendet werden muss um
Zugriff auf die *API* von Twitter im Auftrag des Benutzers zu erhalten. Twitter macht das nur einmal sobald
bestätigt wurde das der angehängte Anfrage Token noch nicht verwendet wurde um einen anderen Anfrage Token zu
erhalten. Ab diesem Punkt kann TweetExpress dem Benutzer die Anfrage der Akzeptanz bestätigen und den originalen
Anfrage Token löschen da er nicht länger benötigt wird.

Ab diesem Punkt kann TweetExpress die *API* von Twitter verwenden um neue Tweets im Sinne des Benutzers zu schicken
indem einfach auf die Endpunkte der *API* mit einer Anfrage zugegriffen wird welche digital signiert wurde (über
HMAC-SHA1) mit einer Kombination von dem Konsumenten Geheimnis von TweetExpress und dem Zugriffsschlüssel der
verwendet wird.

Auch wenn Twitter den Zugriffstoken nicht ablaufen lässt, steht es dem Benutzer frei TweetExpress zu
de-authorisieren damit es nicht mehr auf seine Einstellungen des Twitter Accounts zugreifen kann. Sobald er
de-authorisiert wurde, wird der Zugriff von TweetExpress abgeschnitten und sein eigener Zugriffstoken wird als
ungültig dargestellt.


