.. _zend.permissions.acl.refining:

Verfeinern der Zugriffskontrolle
================================

.. _zend.permissions.acl.refining.precise:

Präzise Zugangsbeschränkung
---------------------------

Die grundlegende *ACL*, wie sie im :ref:`vorherigen Kapitel <zend.permissions.acl.introduction>` definiert ist, zeigt wie
verschiedene Rechte für die gesamte *ACL* (alle Ressourcen) vergeben werden können. In der Praxis tendieren
Zugangsbeschränkungen jedoch eher dahin, Ausnahmen und verschiedene Stufen von Komplexität zu haben. ``Zend\Permissions\Acl``
erlaubt einem, diese Verfeinerungen auf einfache und flexible Weise zu bewerkstelligen.

Für das Beispiel *CMS* wurde ermittelt, dass während die Gruppe 'staff' die Bedürfnisse der überwiegenden
Mehrheit der Benutzer abdeckt, es den Bedarf für eine neue Gruppe 'marketing' gibt, die Zugriff auf den Newsletter
und die neuesten Nachrichten im *CMS* benötigen. Die Gruppe ist ziemlich unabhängig und wird die Möglichkeit
haben, sowohl Newsletter als auch die neuesten Nachrichten zu veröffentlichen und zu archivieren.

Zusätzlich wurde angefordert, dass es der Gruppe 'staff' erlaubt sein soll, die Nachrichten ansehen, aber nicht
die neuesten Nachrichten überarbeiten zu können. Letztendlich soll es für jeden (Administratoren eingeschlossen)
unmöglich sein, irgend eine Bekanntmachung zu archivieren, da diese sowieso nur eine Lebensdauer von 1 bis 2 Tagen
haben.

Zuerst überarbeiten wir die Rollenregistrierung, um die Änderungen wider zu spiegeln. Wir haben ermittelt, dass
die Gruppe 'marketing' dieselben grundlegenden Rechte wie 'staff' hat, also definieren wir 'marketing' so, dass die
Genehmigungen von 'staff' geerbt werden:

.. code-block:: php
   :linenos:

   // Die neue Gruppe Marketing erbt Genehmigungen der Mitarbeiter
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');

Als nächstes ist zu beachten, dass sich die obige Zugangsbeschränkung auf bestimmte Ressourcen bezieht (z.B.
"newsletter", "lastest news", "announcement news"). Nun fügen wir die Ressourcen hinzu:

.. code-block:: php
   :linenos:

   // Ressourcen für die Regeln erstellen

   // Newsletter
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // Nachrichten
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // Neueste Nachrichten
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // Bekanntmachungen
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');

Nun ist es nur eine Frage der Definition für diese spezifischeren Regeln auf die Zielbereiche der *ACL*:

.. code-block:: php
   :linenos:

   // Marketing muss Newsletter und die neuesten Nachrichten veröffentlichen
   // und archivieren können
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Staff (und Marketing durch die Vererbung), wird die Erlaubnis verweigert,
   // die neuesten Nachrichten überarbeiten zu können
   $acl->deny('staff', 'latest', 'revise');

   // Jedem (inklusive der Administratoren) wird die Erlaubnis verweigert,
   // Bekanntmachungsnachricht zu archivieren
   $acl->deny(null, 'announcement', 'archive');

Wir können nun die *ACL* hinsichtlich der letzten Änderungen abfragen:

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied";
   // verweigert

.. _zend.permissions.acl.refining.removing:

Zugangsbeschränkungen entfernen
-------------------------------

Um eine oder mehrere Zugangsregel von der *ACL* zu entfernen, verwendet man einfach die vorhandenen Methoden
``removeAllow()`` oder ``removeDeny()``. Wie bei ``allow()`` und ``deny()`` kann man den ``NULL`` Wert übergeben,
um die Anwendung auf alle Rollen, Ressourcen und / oder Rechte anzuzeigen:

.. code-block:: php
   :linenos:

   // Entferne die Verweigerung, die letzten Nachrichten zu überarbeiten für
   // die Mitarbeiter (und Marketing durch die Vererbung)
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // erlaubt

   // Entferne die Erlaubnis für das Marketing, Newsletter veröffentlichen und
   // archivieren zu können
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // verweigert

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied";
   // verweigert

Rechte können schrittweise wie oben angezeigt verändert werden, aber ein ``NULL``-Wert für die Rechte
überschreibt solche schrittweisen Änderungen:

.. code-block:: php
   :linenos:

   // Erlaube dem Marketing alle Rechte für die neuesten Nachrichten
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // erlaubt

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied";
   // erlaubt


