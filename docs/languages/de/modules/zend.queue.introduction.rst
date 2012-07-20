.. _zend.queue.introduction:

Einführung
==========

``Zend_Queue`` bietet Factory Funktionen ob spezielle Queue Client Objekte zu erstellen.

Eine Message Queue ist eine Methode für entferntes Bearbeiten. Zum Beispiel könnte eine Job Broker Anwendung
mehrere Anwendungen für Jobs akzeptieren und das von einer Vielzahl von Quellen.

Man könnte eine Queue "``/queue/applications``" erstellen die einen Sender und einen Empfänger hat. Der Sender
würde jede vorhandene Quelle sein die sich zum Nachrichten Service verbinden kann oder indirekt zu einer Anwendung
(Web) die sich zum Nachrichten Service verbinden kann.

Der Sender sendet eine Nachricht an die Queue:

.. code-block:: xml
   :linenos:

   <resume>
       <name>John Smith</name>
       <location>
           <city>San Francisco</city>
           <state>California</state>
           <zip>00001</zip>
       </location>
       <skills>
           <programming>PHP</programming>
           <programming>Perl</programming>
       </skills>
   </resume>

Der Empfänger oder Konsument der Queue würde die Nachricht entgegennehmen und den Prozess weiterbearbeiten.

Es gibt viele Nachrichten-Pattern die Queues angehängt werden können um den kontrollierten Ablauf des Codes zu
abstrahieren um Metriken, Transformationen, und Monitoring für Nachrichten-Queues anzubieten. Ein gutes Buch für
Nachrichten-Pattern ist `Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions
(Addison-Wesley Signature Series)`_ (ISBN-10 0321127420; ISBN-13 978-0321127426).



.. _`Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions (Addison-Wesley Signature Series)`: http://www.amazon.com/Enterprise-Integration-Patterns-Designing-Addison-Wesley/dp/0321200683
