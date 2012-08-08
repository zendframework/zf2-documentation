.. EN-Revision: none
.. _zend.service.amazon.ec2.securitygroups:

Zend_Service_Amazon_Ec2: Sicherheitsgruppen
===========================================

Eine Sicherheitsgruppe ist eine benante Sammlung von Zugriffsregeln. Diese Zugriffsregeln spezifizieren welcher
zufließende (z.B. hereinkommende) Netzwerkverkehr an die Instanz zugestellt werden soll. Jeder andere zufließende
Verkehr wird weggeworfen.

Man kann die Regeln für Gruppen jederzeit verändern. Die neuen Regeln werden automatisch für alle laufenden
Instanzen, und Instanzen die in Zukunft gestartet werden, erzwungen.

.. note::

   **Maximale Sicherheitsgruppen**

   Man kann bis zu 100 Sicherheitsgruppen erstellen.

.. _zend.service.amazon.ec2.securitygroups.maintenance:

Wartung von Sicherheitsgruppen
------------------------------

.. _zend.service.amazon.ec2.securitygroups.maintenance.create:

.. rubric:: Eine neue Sicherheitsgruppe erstellen

*create* erstellt eine neue Sicherheitsgruppe. Jede Instanz wird in einer Sicherheitsgruppe gestartet. Wenn wärend
dem Start keine Sicherheitsgruppe spezifiziert wurde, werden die Instanzen in der standardmäßigen
sicherheitsgruppe gestartet. Instanzen mit der gleichen Sicherheitsgruppe haben untereinander unbegrenzten
Netzwerkzugriff. Instanzen verhindern jeden Versuch eines Netzwerkzugriffs von anderen Instanzen aus
unterschiedlichen Sicherheitsgruppen.

*create* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->create('mygroup', 'my group description');

.. _zend.service.amazon.ec2.securitygroups.maintenance.describe:

.. rubric:: Eine Sicherheitsgruppe beschreiben

*describe* gibt Informationen über die Sicherheitsgruppen zurück welche einem selbst gehören.

Wenn Namen von Sicherheitsgruppen spezifiziert werden, werden Informationen über diese Sicherheitsgruppen
zurückgegeben. Andernfalls, werden Informationen über alle Sicherheitsgruppen zurückgegeben. Wenn eine Gruppe
spezifiziert wird, die nicht existiert wird ein Fehler zurückgegeben.

*describe* gibt ein Array zurück das Informationen über Sicherheitsgruppen enthält welches ownerId, groupName,
groupDescription und ein Array enthält das alle Regeln dieser Sicherheitsgruppe enthält.

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->describe('mygroup');

.. _zend.service.amazon.ec2.securitygroups.maintenance.delete:

.. rubric:: Eine Sicherheitsgruppe löschen

*delete* entfernt die Sicherheitsgruppe. Wenn man versucht eine Sicherheitsgruppe zu löschen die Instanzen
enthält, wird ein Fehler zurückgegeben. Wenn man versucht eine Sicherheitsgruppe zu löschen die von einer
anderen Sicherheitsgruppe referenziert ist, wird ein Fehler zurückgegeben. Wenn, zum Beispiel, Sicherheitsgruppe B
eine Regel hat die den Zugriff von Sicherheitsgruppe A erlaubt, kann Sicherheitsgruppe A nicht gelöscht werden,
bis die betreffende Regel entfernt wurde.

*delete* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->delete('mygroup');

.. _zend.service.amazon.ec2.securitygroups.authorize:

Zugriff authorisieren
---------------------

.. _zend.service.amazon.ec2.securitygroups.authorize.ip:

.. rubric:: Authorisierung durch die IP

*authorizeIp* fügt einer Sicherheitsgruppe eine Erlaubnis hinzu basierend auf einer IP Adresse, dem Protokoll Typ
und einem Port Bereich.

Erlaubnisse werden spezifiziert durch das IP Protokoll (TCP, UDP oder ICMP), der Quelle der Anfrage (durch IP
Bereich oder einem Amazon EC2 Benutzer-Gruppe Paar), den Quell- und Ziel-Port Bereichen (für *TCP* und UDP), und
den ICMP Codes und Typen (für ICMP). Wenn ICMP authorisiert wird kann -1 als Wildcard in den Typ- und Codefeldern
verwendet werden.

Änderungen einer Erlaubnis werden Instanzen über die Sicherheitsgruppe so schnell wie möglich mitgeteilt.
Abhängig von der Anzahl der Instanzen, kann es trotzdem zu einer kleinen Verzögerung kommen.

*authorizeIp* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->authorizeIp('mygroup',
                                  'protocol',
                                  'fromPort',
                                  'toPort',
                                  'ipRange');

.. _zend.service.amazon.ec2.securitygroups.authorize.group:

.. rubric:: Authorisierung durch die Gruppe

*authorizeGroup* fügt die Erlaubnis für eine Sicherheitsgruppe hinzu.

Änderungen einer Erlaubnis werden Instanzen über die Sicherheitsgruppe so schnell wie möglich mitgeteilt.
Abhängig von der Anzahl der Instanzen, kann es trotzdem zu einer kleinen Verzögerung kommen.

*authorizeGroup* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->authorizeGroup('mygroup', 'securityGroupName', 'ownerId');

.. _zend.service.amazon.ec2.securitygroups.revoke:

Zugriff entziehen
-----------------

.. _zend.service.amazon.ec2.securitygroups.revoke.ip:

.. rubric:: Entziehen durch die IP

*revokeIp* entzieht den Zugriff zu einer Sicherheitsgruppe basieren auf einer IP Adresse, einem Protokoll Typ und
einem Port Bereich. Der Zugriff der entzogen werden soll muß mit den gleichen Werte spezifiziert werden mit denen
der Zugriff erlaubt wurde.

Erlaubnisse werden spezifiziert durch das IP Protokoll (TCP, UDP oder ICMP), der Quelle der Anfrage (durch IP
Bereich oder einem Amazon EC2 Benutzer-Gruppe Paar), den Quell- und Ziel-Port Bereichen (für *TCP* und UDP), und
den ICMP Codes und Typen (für ICMP). Wenn ICMP authorisiert wird kann -1 als Wildcard in den Typ- und Codefeldern
verwendet werden.

Änderungen einer Erlaubnis werden Instanzen über die Sicherheitsgruppe so schnell wie möglich mitgeteilt.
Abhängig von der Anzahl der Instanzen, kann es trotzdem zu einer kleinen Verzögerung kommen.

*revokeIp* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->revokeIp('mygroup',
                               'protocol',
                               'fromPort',
                               'toPort',
                               'ipRange');

.. _zend.service.amazon.ec2.securitygroups.revoke.group:

.. rubric:: Entziehen durch die Gruppe

*revokeGroup* fübt eine Erlaubnis zu einer Sicherheitsgruppe hinzu. Die Erlaubnis die entzogen werden soll muß
mit den gleichen Werten spezifiziert werden mit denen die Erlaubnis erteilt wurde.

Änderungen einer Erlaubnis werden Instanzen über die Sicherheitsgruppe so schnell wie möglich mitgeteilt.
Abhängig von der Anzahl der Instanzen, kann es trotzdem zu einer kleinen Verzögerung kommen.

*revokeGroup* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_sg = new Zend_Service_Amazon_Ec2_Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->revokeGroup('mygroup', 'securityGroupName', 'ownerId');


