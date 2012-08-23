.. EN-Revision: none
.. _learning.multiuser.intro:

Erstellung von Multi-User Anwendungen mit Zend Framework
========================================================

.. _learning.multiuser.intro.zf:

Zend Framework
--------------

Als das Originale "Web" erstellt wurde, wurde es dazu designt eine Veröffentlichungs-Platform für hauptsächlich
statiche Inhalte zu sein. Als der Wunsch nach Inhalt im Web wuchs, tat es auch die Anzahl der Benutzer des
Internets für Web Inhalte, und auch der Wunsch für die Verwendung des Webs als Anwendungsplattform wuchs. Seit
das Web von Natur aus gut darin ist simultane Erfahrungen an viele Konsumenten von einem einzelnen Ort aus zu
liefern, ist es auch die ideale Umgebung für die Erstellung von dynamisch erzeugten, Multi-User und heutzutage
üblicheren Sozialen Systeme.

*HTTP* ist das Protokoll des Webs: es ist statuslos und ein Antwort Protokoll. Dieses Protokoll wurde so erstellt
weil der originale Zweck des Webs das anbieten und veröffentlichen von statischem Inhalt war. Es ist auch dieses
Design welches das Web so immens erfolgreich gemacht hat wie es ist. Es ist auch exakt dieses Design welches
Entwicklern neue Bedenken bereitet wenn Sie das Web als Anwendungsplattform verwenden wollen.

Diese Bedenken und Verantwortlichkeiten können effektiv in drei Fragen zusammengefasst werden:

- Wie trennt den Benutzer einer Anwendung von einem anderen?

- Wie identifiziert man einen Benutzer als authentisch?

- Wie kontrolliert man wozu ein Benutzer Zugriff hat?

.. note::

   **Konsument vs. Benutzer**

   Es ist zu beachten das wir den Ausdruck "Benutzer" statt Person verwenden. Web Anwendungen werden immer mehr von
   Services betrieben. Das bedeuetet das es nicht nur Personen ("Benutzer") mit echten Web Browsern gibt welche die
   Anwendung konsumieren und verwenden, sondern auch andere Web Anwendungen die durch eine Maschinen Service
   Technologie wie *REST*, *SOAP*, und *XML-RPC* darauf zugreifen. Deshalb sollten Personen, wie auch andere
   benutzende Anwendungen, alle auf dem selben Weg behandelt werden und den selben Bedenken die oben beschrieben
   wurden.

In den folgenden Kapiteln, sehen wir uns diese gemeinsamen Probleme an welche im Detail auf Authentifizierung und
Autorisierung Bezug nehmen. Wir werden die 3 Hauptkomponenten kennenlernen: ``Zend_Session``, ``Zend_Auth``, und
``Zend\Permissions\Acl``; eine sofort verwendbare Lösung anbieten sowie Erweiterungspunkte welche auf eine bessere anpassbare
Lösung abzielen.


