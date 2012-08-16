.. EN-Revision: none
.. _zend.session.global_session_management:

Globales Session Management
===========================

Das Standardverhalten von Sessions kann mit Hilfe der statischen Methoden von ``Zend_Session`` geändert werden.
Das komplette Management und die Manipulation des globalen Session Managements findet durch Verwendung von
``Zend_Session`` statt, was auch die Konfiguration der `üblichen Optionen, welche von ext/session unterstützt
werden`_, durch ``Zend_Session::setOptions()`` enthält. Zum Beispiel kann, das fehlerhafte Versichern das ein
sicherer *save_path* oder ein eindeutiger Cookiename von ext/session durch ``Zend_Session::setOptions()`` verwendet
wird, zu einem Sicherheitsproblem werden.

.. _zend.session.global_session_management.configuration_options:

Konfigurations Optionen
-----------------------

Wenn der erste Session Namensraum angefragt wird, startet ``Zend_Session`` automatisch die *PHP* Session, ausser er
wurde bereits mit :ref:`Zend_Session::start() <zend.session.advanced_usage.starting_a_session>` gestartet. Die
darunterliegende *PHP* Session verwendet die Standards von ``Zend_Session``, ausser wenn Sie schon durch
``Zend_Session::setOptions()`` modifiziert wurde.

Um eine Konfigurations Option einer Session zu setzen, muß der Basisname (der Teil des Namens nach "*session.*")
als Schlüssel eines Array inkludiert und an ``Zend_Session::setOptions()`` übergeben werden. Der
korrespondierende Wert im Array wird verwendet um den Wert der Option dieser Session zu setzen. Wenn keine Option
durch den Entwickler gesetzt wird, wird ``Zend_Session`` zuerst die benötigten Optionen anwenden und anschließend
die standard php.ini Einstellungen. Feedback der Community über die beste Handhabung für diese Optionen sollte
gesendet werden an `fw-auth@lists.zend.com`_.

.. _zend.session.global_session_management.setoptions.example:

.. rubric:: Verwenden von Zend_Config um Zend_Session zu konfigurieren

Um diese Komponente mit Hilfe von :ref:`Zend_Config_Ini <zend.config.adapters.ini>` zu konfigurieren, muß zuerst
die Konfigurations-Option dem *INI* File hinzugefügt werden:

.. code-block:: ini
   :linenos:

   ; Accept defaults for production
   [production]
   ; bug_compat_42
   ; bug_compat_warn
   ; cache_expire
   ; cache_limiter
   ; cookie_domain
   ; cookie_lifetime
   ; cookie_path
   ; cookie_secure
   ; entropy_file
   ; entropy_length
   ; gc_divisor
   ; gc_maxlifetime
   ; gc_probability
   ; hash_bits_per_character
   ; hash_function
   ; name sollte für jede PHP Anwendung eindeutig sein und den
   ; selben Domain Namen verwenden
   name = UNIQUE_NAME
   ; referer_check
   ; save_handler
   ; save_path
   ; serialize_handler
   ; use_cookies
   ; use_only_cookies
   ; use_trans_sid

   ; remember_me_seconds = <integer seconds>
   ; strict = on|off

   ; Entwicklung beinhaltet Konfiguration der Produktion,
   ; überschreibt aber diverse Werte
   [development : production]
   ; Nicht vergessen, dieses Verzeichnis zu erstellen und es
   ; rwx machen (lesbar und änderbar) durch PHP.
   save_path = /home/myaccount/zend_sessions/myapp
   use_only_cookies = on
   ; Beim Analysieren von Session ID Cookies, frage nach einer TTL von 10 Tagen
   remember_me_seconds = 864000

Als nächstes die Konfigurationsdatei laden und dessen Array Representation ``Zend_Session::setOptions()``
übergeben:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('myapp.ini', 'development');

   require_once 'Zend/Session.php';
   Zend_Session::setOptions($config->toArray());

Die meisten der oben gezeigten Optionen benötigen keine Erklärung die nicht in der Standard *PHP* Dokumentation
gefunden werden kann, aber jene von speziellem Interesse sind anbei beschrieben.



   - boolean *strict*- verhindert das automatische Starten von ``Zend_Session`` wenn *new Zend_Session_Namespace()*
     verwendet wird.

   - integer *remember_me_seconds*- Wie lange soll das Session Id Cookie bestehen, nachdem der Benutzer Agent
     beendet wurde (z.B. Browser Anwendung geschlossen)

   - string *save_path*- Der richtige Wert ist abhängig vom System, und sollte vom Entwickler auf einen
     **absoluten Pfad** zu einem Verzeichnis bereitgestellt werden, welches durch den *PHP* Prozess lesbar und
     beschreibbar ist. Wenn kein schreibbarer Pfad gegeben ist, wird ``Zend_Session`` eine Ausnahme werden sobald
     Sie gestartet wird (z.B. wenn ``start()`` aufgerufen wird).

     .. note::

        **Sicherheits Risiko**

        Wenn der Pfad von einer anderen Anwendung aus lesbar ist, kann die Entführung der Session möglich sein.
        Wenn der Pfad von einer anderen Anwendung aus beschreibbar ist, kann die `Session vergiftet`_ werden. Wenn
        der Pfad mit anderen Benutzern oder anderen *PHP* Anwendungen geteilt wird, können verschiedenste
        Sicherheitsprobleme auftreten. Das inkludiert Diebstahl von Inhalten der Session, Entführung von Sessions
        und Kollisionen der Müllsammlung (z.B., eine andere Anwendung eines Benutzers können *PHP* veranlassen
        die eigenen Session Dateien zu löschen).

        Zum Beispiel kann ein Angreifer die Webseite des Opfers besuchen um ein Session Cookie zu erhalten. Dann,
        den Cookie Pfad auf die eigene Domain auf dem gleichen Server ändern, bevor er die eigene Webseite besucht
        um ``var_dump($_SESSION)`` auszuführen. Bewaffnet mit detailiertem Wissen über die Verwendung von Daten
        in den Sessions des Opfers, kann der Angreifer den Sessionstatus verändern (Vergiften der Session), den
        Cookie Pfad auf die Webseite des Opfers zurück ändern, und anschließend eine Anfrage von der Webseite
        des Opfers, mithilfe der vergifteten Session, durchführen. Selbst wenn zwei Anwendungen auf dem gleichen
        Server keinen Lese-/Schreibzugriff auf den jeweils anderen *save_path* der Anwendung haben, wenn der
        *save_path* erahnbar ist und der Angreifer die Kontrolle über eine der zwei Webseiten hat, kann der
        Angreifer den *save_path* seiner Webseiten ändern um dem anderen save_path zu verwenden und somit die
        Vergiftung der Session durchführen, in den meisten üblichen *PHP* Konfigurationen. Deshalb sollte der
        Wert für *save_path* nicht öffentlich bekanntgegeben werden, und er sollte geändert werden um dem Pfad
        eindeutig für jede Anwendung zu sichern.

   - string *name*- Der richtige Wert ist abhängig vom System and sollte vom Entwickler, durch Verwenden eines
     bestimmten Wertes, bereitgestellt werden, welcher für jede Zend Framework Anwendung **eindeutig** ist.

     .. note::

        **Sicherheits Risiko**

        Wenn die *php.ini* Einstellung für *session.name* die selbe ist (z.B., die standardmäßige "PHPSESSID"),
        und es zwei oder mehr *PHP* Anwendungen gibt die über den selben Domain Namen erreichbar sind, dann werden
        Sie miteinander für alle Besucher die beide Webseiten besuchen, die selben Session Daten teilen.
        Zusätzlich, könnte das auch zu einer Verfälschung von Session Daten führen.

   - boolean *use_only_cookies*- Um zusätzliche Sicherheitsrisiken zu vermeiden, sollte der Standardwert dieser
     Option nicht verändert werden.

        .. note::

           **Sicherheits Risiko**

           Wenn diese Einstellung nicht aktiviert wird, kann ein Angreifer einfach die Session Id des Opfers
           ändern indem ein Link auf der Webseite des Angreifers verwendet wird, wie z.B.
           *http://www.example.com/index.php?PHPSESSID=fixed_session_id*. Die Änderung funtioniert, wenn das Opfer
           nicht schon ein Session Id Cookie für example.com besitzt. Sobald ein Opfer eine bekannte Session Id
           benutzt, kann der Angreifer versuchen die Session zu übernehmen indem er sich verstellt und vorgibt das
           Opfer zu sein, und den UserAgent des Opfers emuliert.





.. _zend.session.global_session_management.headers_sent:

Fehler: Header schon gesendet
-----------------------------

Wenn die Fehler Nachricht, "Cannot modify header information - headers already sent", oder "You must call .. before
any output has been sent to the browser; output started in ..." erscheint, sollte der direkte Grund (Funktion oder
Methode) der mit dieser Nachricht gekoppelt ist sorgfältig begutachtet werden. Jede Aktion die das senden von
*HTTP* Headern benötigt, wie z.B. das modifizieren von Browser Cookies, muß vor dem Senden von normaler Ausgabe
(ungepufferter Ausgabe) durchgeführt werden, ausser wenn *PHP*'s Ausgabebuffer verwendet wird.

- `Puffern der Ausgabe`_ ist oft notwendig um dieses Problem zu verhindern, und hilft bei der Steigerung der
  Geschwindigkeit. Zum Beispiel aktiviert "*output_buffering = 65535*" in der *php.ini* das Puffern der Ausgabe mit
  einem 64k Puffer. Selbst wenn das Puffern der Ausgabe eine gute Taktik ist um auf Produktionsservern die
  Geschwindigkeit zu Erhöhen, ist das Vertrauen auf das Puffern, um das Problem "headers already sent" zu beheben,
  nicht ausreichend. Die Anwendung darf die Buffergröße nicht überschreiten, andernfalls wird das Problem von
  Zeit zu Zeit wieder auftreten, wann auch immer eine Ausgabe gesendet wird (vor den *HTTP* Headern) welche die
  Puffergröße überschreitet.

- Wenn eine Methode von ``Zend_Session`` als Verursacher der Fehlermeldung ist, sollte die Methode sorgfältig
  begutachtet werden und es ist sicher zu stellen das Sie auch wirklich in der Anwendung benötigt wird. Zum
  Beispiel sendet auch die standardmäßige Verwendung von ``destroy()`` einen *HTTP* Header um das Session Cookie
  auf der Seite des Clients ablaufen zu lassen. Wenn das nicht benötigt wird sollte ``destroy(false)`` verwendet
  werden, da die Anweisungen für das Ändern von Cookies im *HTTP* Header gesendet.

- Anternativ kann versucht werden die Logik der Anwendung anders anzuordnen, so das Aktionen welche Header
  manipulieren vor dem Senden von jeglicher Ausgabe ausgeführt werden.

- Jedes schließende "*?>*" Tag sollte entfernt werden, wenn es am Ende einer *PHP* Source Datei steht. Sie werden
  nicht benötigt und neue Zeilen und andere beinahe unsichtbare Leerzeichen welche dem schließenden Tag folgen
  können eine Ausgabe an den Client verursachen.

.. _zend.session.global_session_management.session_identifiers:

Session Identifizierer
----------------------

Einführung: Die beste Praxis in Relation für die Benutzung von Session innerhlab des ZF fordert die Verwendung
eines Browser Cookies (z.B. ein normales Cookie welchem im Web Browser gespeichert wird), statt der integration von
eindeutigen Session Identifizierern in *URL*\ s als Mittel für das verfolgen von individuellen Benutzern.
Normalerweise verwendet diese Komponente nur Cookie für die Handhabung von Session Identifizierern. Der Wert des
Cookies ist der eindeutige Identifizierer in der Session des Browsers. *PHP*'s ext/session verwendet diesen
Identifizierer um eine eindeutige eins-zu-eins Verbindung zwischen dem Besucher der Webseite und dem dauerhaften
Session Daten Speicher herzustellen. ``Zend_Session``\ * umhüllt diesen Speichermechanismus (``$_SESSION``) mit
einem objektorientierten Interface. Leider, wenn ein Angreifer Zugriff auf der Wert des Cookies (die Session Id)
erhält, kann er die Session des Besuchers übernehmen. Dieses Problem gilt nicht nur für *PHP* oder den Zend
Framework. Die ``regenerateId()`` Methode erlaubt einer Anwendung die Session Id (die im Cookie des Besuchers
gespeichert ist) in einen neuen, zufälligen, unvorhersagbaren Wert zu ändern. Achtung: Auch wenn nicht das
gleiche gemeint ist, um diese Sektion einfacher lesbar zu machen, verwenden wir die Ausdrücke "User Agent" und
"Webbrowser" synonym füreinander.

Warum?: Wenn ein Angreifer einen gültigen Session Identifizierer erhält, kann ein Angreifer einen gültigen
Benutzer (das Opfer) verkörpern, und anschließend Zugriff auf vertrauliche Intormationen oder andererseits die
Daten des Opfers verändern welche von der Anwendung verwaltet werden. Das Ändern des Session Id's hilft sich
gegen die Übernahme der Session zu Schützen. Wenn die Session Id geändert wird, und ein Angreifer den neuen Wert
nicht weiß, kann der Angreifer die neue Session Id nicht für Ihren Zweck, dem Versuch der Übernahme der Session
des Opfers, verwenden. Selbst wenn der Angreifer zugriff auf die alte Session Id erhält, verschiebt
``regenerateId()`` die Daten der Session vom alten Session Id "Handle" zum neuen, weswegen keine Daten über die
alte Session Id abrufbar sind.

Wann sollte regenerateId() verwendet werden: Das Hinzufügen von ``Zend_Session::regenerateId()`` in die Bootstrap
Datei des Zend Frameworks bietet einen der sichersten und am besten geschützten Wege um die Session Id's in den
Cookies der User Agenten zu erneuern. Wenn es keine bedingte Logik gibt, um herauszufinden wann die Session Id
erneuert werden soll, dann gibt es keinen Mangel in dieser Logik. Auch wenn der Erneuern bei jeder Anfrage einen
möglichen Weg der Attacke verhindert, will nicht jedermann die damit hervorgerufenen kleinen Einbußen in der
Geschwindigkeit und der Bandbreite hinnhmen. Deswegen versuchen Anwendungen normalerweise Situationen von
größerem Risiko zu erahnen, und nur in diesen Situationen die Session Id's zu erneuern. Immer wenn die Rechte
einer Session vom Besucher der Webseite "ausgeweitet" werden (z.B. ein Besucher muß noch einmal seine Identität
authentifizieren bevor sein "Profil" bearbeitet werden darf), oder wann auch immer ein sicherheits-"sensitiver"
Session Parameter geändert wird, sollte daran gedacht werden ``regenerateId()`` zu verwenden um eine neue Session
Id zu erstellen. Wenn die ``rememberMe()`` Funktion aufgerufen wird, sollte ``regenerateId()`` nicht verwendet
werden, ausser der erstere ruft den letzteren auf. Wenn sich ein Benutzer erfolgreich auf die Webseite eingeloggt
hat, sollte ``rememberMe()`` statt ``regenerateId()`` verwendet werden.

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation:

Session-Entführung und Fixierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Vermeiden von `Seiten übergreifenden Script (XSS) Gefährdungen`_ hilft bei der Vorbeugung von Session
Entführungen. Laut `Secunia's`_ Statistik kommen XSS Probleme häufig vor, unabhängig von der Sprache dir für
die Erstellung der Web Anwendung benutzt wurde. Vor der Annahme nie XSS Probleme mit einer Anwendung zu haben,
sollten diese mit der folgenden besten Praxis berücksichtigt werden um, wenn sie auftreten, den geringsten Schaden
zu haben. Mit XSS benötigt ein Angreifer keinen direkten Zugriff auf den Netzwerk Verkehr des Opfers. Wenn das
Opfer bereits ein Session Cookie hat, kann Javascript XSS einem Angreifer erlauben das Cookie zu lesen und die
Session zu stehlen. Für Opfer ohne Session Cookies, kann ein Angreifer, wenn er XSS verwendet um Javascript
einzuschleusen, ein Session Id Cookie mit einem bekannten Wert, auf dem Browser des Opfers erstellen, und dann ein
identisches Cookie auf dem System des Angreifers setzen, um die Session des Opfers zu entführen. Wenn das Opfer
die Webseite des Angreifers besucht, kann der Angreifer auch die meisten anderen infizierbaren Characteristiken vom
User Agent des Opfers emulieren. Wenn eine Webseite eine XSS Gefährdung aufweist, könnte der Angreifer ein *AJAX*
Javascript einfügen das versteckt die Webseite des Angreifers "besucht", damit der Angreifer die Characteristika
vom Browser des Opfers weiß und auf die beeinträchtigte Session auf der Webseite des Opfers aufmerksam gemacht
wird. Trotzdem kann ein Angreifer nicht willkürlich die serverseitigen Status der *PHP* Session ändern, wenn der
Entwickler den Wert für die *save_path* Option richtig eingestellt hat.

Nur durch das Aufrufen von ``Zend_Session::regenerateId()``, wenn die Session des Benutzers das erste Mal verwendet
wird, verhindert keine Session Fixierungs Attacken, ausser es kann die Session, die von einem Angreifer erstellt
wurde um ein Opfer zu Emulieren, unterschieden werden. Das könnte zuerst wiedersprüchlich klingen zu dem
vorherigen Statement, solange angenommen wird das ein Angreifer zuerst eine reale Session auf der Webseite
initiiert. Die Session wird "zuerst vom Angreifer benutzt", welche dann das Ergebnis der Initialisierung weiß
(``regenerateId()``). Der Angreifer verwendet dann diese neue Session Id in Kombination mit der XSS Gefährdung,
oder injiziert die Session Id über einen Link auf der Webseite des Angreifers (funktioniert wenn *use_only_cookies
= off*).

Wenn zwischen einem Angreifer und einem Opfer welche die selbe Session Id verwenden, unterschieden werden kann,
kann mit der Session Enführung direkt gehandelt werden. Trotzdem beinhalten solche Formen von Unterscheidungen
normalerweise eine Verringerung der Handhabung weil diese Methoden der Unterscheidung oft ungenau sind. Wenn, zum
Beispiel, eine Anfrage von einer IP in einem anderen Land empfangen wird als von der IP in welchem die Session
erstellt wurde, gehört die neue Anfrage möglicherweise zu einem Angreifer. Unter der folgenden Annahme, gibt es
möglicherweise keinen Weg, für eine Webseiten Anwendung, zwischen einem Opfer und einem Angreifer zu
unterscheiden:



   - Der Angreifer initiiert eine Session auf der Webseite um eine gültige Session Id zu erhalten

   - Der Angreifer benutzt XSS Gefährdungen auf der Webseite um ein Cookie auf dem Browser des Opfers mit der
     geichen, gültigen Session Id (z.b. Session Fixierung), zu erstellen

   - Beide, das Opfer und der Angreifer kommen von der selben Proxy Farm (z.B. wenn beide hinter der selben
     Firewall einer großen Firma, wie AOL, sind)

Der Beispiel-Code anbei, macht es für Angreifer viel schwerer die aktuelle Session Id des Opfers zu wissen solange
der Angreifer nicht bereits die ersten Zwei Schritte von oben ausgeführt hat.

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation.example:

.. rubric:: Session Fixierung

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend_Session_Namespace();

   if (!isset($defaultNamespace->initialized)) {
       Zend_Session::regenerateId();
       $defaultNamespace->initialized = true;
   }

.. _zend.session.global_session_management.rememberme:

>rememberMe(integer $seconds)
-----------------------------

Normalerweise enden Sessions wenn der User Agent terminiert, wie wenn der End-Benutzer seinen WebBrowser schließt.
Trotzdem kann die Anwendung die Möglichkeit bieten, eine Benutzer Session über die Lebensdauer des Client
Programms hinweg zu verlängern durch die Verwendung von persistenten Cookies. ``Zend_Session::rememberMe()`` kann
vor dem Start der Session verwendet werden um die Zeitdauer zu kontrollieren bevor ein persistentes Session Cookie
abläuft. Wenn keine Anzahl an Sekunden definiert wird, verwendet das Session Cookie standardmäßig eine
Lebenszeit von *remember_me_seconds*, welche durch Verwendung von ``Zend_Session::setOptions()`` gesetzt werden
kann. Um zu helfen eine Session Fixierung/Entführung zu vereiteln, sollte diese Funktion verwendet werden wenn
sich ein Benutzer erfolgreich an der Anwendung authentifiziert hat (z.B., durch ein "login" Formular).

.. _zend.session.global_session_management.forgetme:

forgetMe()
----------

Diese Funktion ist das Gegenteil von ``rememberMe()`` durch Schreiben eines Session Cookies das eine Lebenszeit hat
die endet wenn der Benutzer terminiert.

.. _zend.session.global_session_management.sessionexists:

sessionExists()
---------------

Diese Methode kann verwendet werden um Herauszufinden ob eine Session für den aktuellen User Agent/Anfrage bereits
existiert. Das kann vor dem Starten einer Session verwendet werden, und ist unabhängig von allen anderen
``Zend_Session`` und ``Zend_Session_Namespace`` Methoden.

.. _zend.session.global_session_management.destroy:

destroy(bool $remove_cookie = true, bool $readonly = true)
----------------------------------------------------------

``Zend_Session::destroy()`` entfernt alle deuerhaften Daten welche mit der aktuellen Session verbunden sind. Aber
es werden keine Variablen in *PHP* verändert, so das die benannte Session (Instanzen von
``Zend_Session_Namespace``) lesbar bleibt. Es ein "Logout" fertigzustellen, muß der optionale Parameter auf
``TRUE`` (standard) gesetzt werden um auch das Session Id Cookie des User Agents zu löschen. Der optionale
``$readonly`` Parameter entfernt die Möglichkeit neue ``Zend_Session_Namespace`` Instanzen zu erstellen und für
``Zend_Session`` in den Session Daten Speicher zu schreiben.

Wenn die Fehlermeldung "Cannot modify header information - headers already sent" erscheint, sollte entweder die
Verwendung von ``TRUE`` als Wert für das erste Argument (die Entfernung des Session Cookies anfragen) vermieden
werden, oder in :ref:`diesem Abschnitt <zend.session.global_session_management.headers_sent>` nachgesehen werden.
Deswegen muß entweder ``Zend_Session::destroy(true)`` aufgerufen werden bevor *PHP* *HTTP* Header gesendet hat,
oder die Pufferung der Ausgabe muß aktiviert sein. Auch die komplette Ausgabe die gesendet werden soll, darf die
gesetzte Puffergröße nicht überschreiten, um das Senden der Ausgabe vor dem Aufruf von ``destroy()`` zu
Verhindern.

.. note::

   **Wirft**

   Standardmäßig ist ``$readonly`` aktiviert, und weitere Aktionen welche das Schreiben in den Session Daten
   Speicher beinhalten, werfen eine Ausnahme.

.. _zend.session.global_session_management.stop:

stop()
------

Diese Methode macht nicht mehr als ein Flag in ``Zend_Session`` zu wechseln um weiteres Schreiben in den Session
Daten Speicher zu verhindern. Wir erwarten spezielles Feedback für dieses Feature. Potentielle Nicht-/Verwendung
könnte temporär bei Verwendung von ``Zend_Session_Namespace`` Instanzen oder ``Zend_Session`` Methoden verhindern
das auf den Session Daten Speicher geschrieben wird, wärend deren Ausführung zum Code der View transferiert wird.
Versuche Aktionen auszuführen welche das Schreiben über diese Instanzen oder Methoden inkludieren werden eine
Ausnahme werfen.

.. _zend.session.global_session_management.writeclose:

writeClose($readonly = true)
----------------------------

Beendet die Session, schließt das schreiben und entfernt ``$_SESSION`` vom Backend Speicher Mechanismus. Das
vervollständigt die interne Transformation der Daten auf diese Anfrage. Der optionale boolsche ``$readonly``
Parameter kann den Schreibzugriff entfernen durch das werfen einer Ausnahme bei jedem Versuch in eine Session durch
``Zend_Session`` oder ``Zend_Session_Namespace`` zu schreiben.

.. note::

   **Wirft**

   Standardmäßig ist ``$readonly`` aktiviert und weitere Aktionen welche in den Session Daten Speicher schreiben
   werfen eine Ausnahme. Trotzdem könnten einige besondere Anwendungen erwarten das ``$_SESSION`` beschreibbar
   bleibt nachdem die Session mittels ``session_write_close()`` beendet wurde. Obwohl das nicht die "beste Praxis"
   ist, ist die ``$readonly`` für jene vorhanden die Sie benötigen.

.. _zend.session.global_session_management.expiresessioncookie:

expireSessionCookie()
---------------------

Diese Methode sendet ein abgelaufenes Session Id Cookie, was den Client dazu bringt den Session Cookie zu löschen.
Manchmal wird diese Technik dazu verwendet einen Logout auf der Seite des Client auszuführen.

.. _zend.session.global_session_management.savehandler:

setSaveHandler(Zend_Session_SaveHandler_Interface $interface)
-------------------------------------------------------------

Die meisten Entwickler werden den Standardmäßigen Speicher Handle ausreichend finden. Diese Methode bietet einen
objekt-orientierten Wrapper für `session_set_save_handler()`_.

.. _zend.session.global_session_management.namespaceisset:

namespaceIsset($namespace)
--------------------------

Diese Methode kann dazu verwendet werden um herauszufinden ob ein Session Namensraum existiert, oder ob ein
bestimmter Index in einem bestimmten Namensraum existiert.

.. note::

   **Wirft**

   Eine Ausnahme wird geworfen wenn ``Zend_Session`` nicht als lesbar markiert ist (z.B. bevor ``Zend_Session``
   gestartet wurde).

.. _zend.session.global_session_management.namespaceunset:

namespaceUnset($namespace)
--------------------------

``Zend_Session::namespaceUnset($namespace)`` kann verwendet werden um effektiv den kompletten Namensraum und dessen
Inhalt zu entfernen. Wie mit allen Arrays in *PHP*, wenn eine Variable die ein Array enthält entfernt wird, und
das Array andere Objekte enthält, werden diese verfügbar bleiben, wenn diese durch Referenz in anderen
Array/Objekten gespeichert sind, die durch anderen Variablen erreichbar bleiben. ``namespaceUnset()`` führt kein
"tiefes" entfernen/löschen von Inhalten eines Eintrages im Namensraum durch. Für eine detailiertere Erklärung
sollte im *PHP* Handbuch unter `Referenzen erklärt`_ nachgesehen werden.

.. note::

   **Wirft**

   Eine Ausnahme wird geworfen wenn der Namensraum nicht beschreibbar ist (z.B. nach ``destroy()``).

.. _zend.session.global_session_management.namespaceget:

namespaceGet($namespace)
------------------------

DEPRECATED: ``getIterator()`` in ``Zend_Session_Namespace`` sollte verwendet werden. Diese Methode gibt ein Array
mit dem Inhalt von ``$namespace`` zurück. Wenn es logische Gründe gibt diese Methode öffentlich aufrufbar zu
lassen bitte ein Feedback auf die `fw-auth@lists.zend.com`_ Mailingliste geben. Aktuell ist jede Anteilnahme an
irgendeinem relevanten Thema sehr willkommen :)

.. note::

   **Wirft**

   Eine Ausnahme wird geworfen wenn ``Zend_Session`` nicht als lesbar markiert ist (z.B bevor ``Zend_Session``
   gestartet wurde).

.. _zend.session.global_session_management.getiterator:

getIterator()
-------------

``getIterator()`` kann verwendet werden, um ein Array zu erhalten, das die Namen aller Namensräume enthält.

.. note::

   **Wirft**

   Eine Ausnahme wird geworfen wenn ``Zend_Session`` nicht als lesbar markiert ist (z.B. bevor ``Zend_Session``
   gestartet wurde).



.. _`üblichen Optionen, welche von ext/session unterstützt werden`: http://www.php.net/session#session.configuration
.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`Session vergiftet`: http://en.wikipedia.org/wiki/Session_poisoning
.. _`Puffern der Ausgabe`: http://php.net/outcontrol
.. _`Seiten übergreifenden Script (XSS) Gefährdungen`: http://en.wikipedia.org/wiki/Cross_site_scripting
.. _`Secunia's`: http://secunia.com/
.. _`session_set_save_handler()`: http://php.net/session_set_save_handler
.. _`Referenzen erklärt`: http://php.net/references
