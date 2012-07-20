.. _zend.auth.adapter.digest:

Digest Authentication
=====================

.. _zend.auth.adapter.digest.introduction:

Einführung
----------

`Digest Authentifizierung`_ ist eine Methode der *HTTP* Authentifizierung welche die `Basis Authentifizierung`_
verbessert indem ein Weg angeboten wird um Authentifizierungen, ohne die Übermittlung des Passwortes als Klartext
über das Netzwerk, durchzuführen.

Dieser Adapter erlaubt Authentifizierungen gegen Textdateien die Zeilen enthalten die folgende Basiselemente der
Digest Authentifizierung enthalten:

- Benutzername, wie z.B. "**joe.user**"

- Bereich, wie z.B. "**Administrativer Bereich**"

- *MD5* Hash von Benutzername, Bereich und Passwort, getrennt durch Doppelpunkte

Die obigen Elemente werden durch Doppelpunkte getrennt, wie im folgenden Beispiel (in dem das Passwort
"**irgendeinPasswort**" ist):

.. code-block:: text
   :linenos:

   irgendeinBenutzer:Irgendein Bereich:fde17b91c3a510ecbaf7dbd37f59d4f8

.. _zend.auth.adapter.digest.specifics:

Spezifisches
------------

Der Digest Authentifizierungs Adapter, ``Zend_Auth_Adapter_Digest``, benötigt verschiedene Eingabeparameter:

- filename - Der Dateiename gegen den Authentifizierungs-Anfragen durchgeführt werden

- realm - Digest Authentifizierungs Bereich

- username - Digest Authentifizierungs Benutzer

- password - Passwort für den Benutzer des Bereichs

Diese Parameter müssen vor dem Aufruf von ``authenticate()`` gesetzt werden.

.. _zend.auth.adapter.digest.identity:

Identität
---------

Der Digest Authentifizierungs Adapter gibt ein ``Zend_Auth_Result`` Objekt zurück, welches mit der Identität wird
wobei dieses als Arry mit Schlüssel von **realm** und **username** veröffentlicht wird. Die entsprechenden Array
Werte welche diesen Schlüsseln zugeordnet sind korrespondieren mit den Werte die vorher durch den Aufruf von
``authenticate()`` gesetzt wurden.

.. code-block:: php
   :linenos:

   $adapter = new Zend_Auth_Adapter_Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Irgendein Bereich
       [username] => irgendeinBenutzer
   )
   */



.. _`Digest Authentifizierung`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`Basis Authentifizierung`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
