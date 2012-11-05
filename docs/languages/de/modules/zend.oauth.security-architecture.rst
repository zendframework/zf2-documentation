.. EN-Revision: none
.. _zend.oauth.introduction.security-architecture:

Architektur der Sicherheit
==========================

OAuth wurde speziell designt um über eine unsichere *HTTP* Verbindung zu arbeiten und deshalb ist die Verwendung
von *HTTPS* nicht notwendig obwohl es natürlich wünschenswert wäre wenn es vorhanden ist. Sollte eine *HTTPS*
Verbindung möglich sein bietet OAuth die Implementation einer Signaturmethode an welche PLAINTEXT heißt und
verwendet werden kann. Über eine typische unsichere *HTTP* Verbindung muss die Verwendung von PLAINTEXT verhindert
werden und ein alternatives Schema wird verwendet. Die OAuth Spezifikation definiert zwei solcher Signaturmethoden:
HMAC-SHA1 und RSA-SHA1. Beide werden von ``ZendOauth`` vollständig unterstützt.

Diese Signaturmethoden sind recht einfach zu verstehen. Wie man sich vorstellen kann macht die PLAINTEXT
Signaturmethode nichts das erwähnenswert wäre da Sie auf *HTTPS* aufsetzt. Wenn man aber PLAINTEXT über *HTTP*
verwenden würde, dann würde ein signifikantes Problem bestehen: Es gibt keinen Weg um sicherzustellen das der
Inhalt einer OAuth-aktivierten Anfrage (welche einen OAuth Zugriffstoken enthalten würde) beim Routen verändert
wurde. Das ist der Fall weil unsichere *HTTP* Anfragen immer das Risiko des Lauschens, von Man In The Middle (MITM)
Attacken, oder andere Risiken haben können in denen eine Anfrage weiterbearbeitet werden könnten und damit
Arbeiten im Sinne des Angreifers ausgeführt werden indem sich dieser als Originalanwendung maskiert ohne das dies
vom Serviceprovider bemerkt wird.

HMAC-SHA1 und RSA-SHA1 vermindern dieses Risiko indem alle OAuth Anfragen mit dem originalen von der Anwendung
registrierten Konsumentengeheimnis digital signiert werden. Angenommen nur der Konsument und der Provider wissen
was das Geheimnis ist, dann kann ein Mann in der Mitte soviele Anfragen verändern wie er will - aber er wird nicht
in der Lage sein sie gültig zu signieren und unsignierte oder ungültig signierte Anfragen würden von beiden
Parteien ausgeschieden werden. Digitale Signaturen bieten deshalb eine Garantie das gültig signierte Anfragen von
der erwarteten Partei kommen und beim Routen nicht verändert wurden. Das ist der Kern warum OAuth über eine
unsichere Verbindung arbeiten kann.

Wie diese digitalen Signaturen arbeiten hängt von der verwendeten Methode ab, z.B. HMAC-SHA1, RSA-SHA1 oder
möglicherweise eine andere Methode welche vom Serviceprovider definiert wird. HMAC-SHA1 ist ein einfacher
Mechanismus welcher einen Nachrichten Authentifizierungscode (MAC) erzeugt indem eine kryptographische Hash
Funktion (z.B. SHA1) in Verbindung mit einem geheimen Schlüssel verwendet wird der nur dem Sender und dem
Empfänger der Nachricht bekannt sind (z.b. das Konsumentengeheimnis von OAuth kombiniert mit dem authorisierten
Zugriffsschlüssel). Dieser Hashing Mechanismus wird den Parametern und dem Inhalt aller OAuth Anfragen angehängt
und zu einem "Basissignatur String" zusammengefügt wie es von der OAuth Spezifikation definiert ist.

RSA-SHA1 operiert auf ähnlichen Prinzipien ausser dass das Geheimnis welches geteilt wird, wie man es erwarten
würde, der private RSA Schlüssel jeder Partei ist. Beide Seiten haben den öffentlichen Schlüssel des anderen
mit dem die digitalen Signaturen geprüft werden. Das führt verglichen mit HMAC-SHA1 zu einem Riskolevel da die
RSA Methode keinen Zugriffsschlüssel als teil des geteilten Geheimnisses verwendet. Dies bedeutet dass wenn der
private RSA Schlüssel eines Konsumenten kompromitiert ist, sind es alle zugeordneten Zugriffstoken dieses
Konsumenten auch. RSA führt zu einem alles oder gar nichts Schema. Generell tendiert die Mehrheit der
Serviceprovider welche OAuth Authorisierung anbieten dazu HMAC-SHA1 standardmäßig zu verwenden, und jene welche
RSA-SHA1 anbieten können eine Fallback Unterstützung für HMAC-SHA1 anbieten.

Wärend digitale Signaturen zur Sicherheit von OAuth beitragen sind Sie trotzdem für andere Formen von Attacken
angreifbar, wie Replay Attacken welche vorhergehende Anfragen aufgezeichnet und zu einer Zeit geprüft und signiert
wurden. Ein Angreifen können jetzt exakt die gleiche Anfrage zum Provider wie er will und zu jeder Zeit senden und
seine Ergebnisse auffangen. Das führt zu einem signifikanten Risiko aber es ist recht einfach sich davor zu
schützen - einen eindeutigen String (z.b. eine Nonce) bei allen Anfragen hinzufügen welcher sich bei jeder
Anfrage ändert (dies verändert laufend den Signaturstring) kann aber niemals wiederverwendet werden weil Provider
verwendete Nonces zusammen mit einem bestimmten Fenster aktiv verfolgen welches vom Timestamp definiert wird der
einer Anfrage auch angehängt wird. Man würde erwarten das wenn die Verfolgung einer bestimmten Nonce gestoppt
wird, das wiederabspielen funktionieren würde, aber das ignoriert den Timestamp der verwendet werden kann um das
Alter einer Anfrage zu ermitteln zu welcher Sie digital signiert wurde. Man kann also annehmen dass die eine Woche
alte Anfrage in einem Wiederholungsversuch abgespielt wird, auf ähnliche Weise verworfen wird.

Als letzter Punkt erwähnt, ist dies keine exzessive Ansicht der Sicherheitsarchitektur in OAuth. Was passiert zum
Beispiel wenn *HTTP* Anfragen welche sowohl den Zugriffstoken als auch das Geheimnis des Konsumenten enthalten
abgehört werden? Das System ist auf der einen Seite von einer klaren Übermittlung von allem abhängig solange
*HTTPS* nicht aktiv ist. Deshalb ist die naheliegende Feststellung das *HTTPS*, dort wo es möglich ist zu
bevorzugen ist und *HTTP* nur an solchen Orten eingesetzt wird so es nicht anders möglich oder nicht erschwinglich
ist.


