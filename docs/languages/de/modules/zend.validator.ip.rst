.. EN-Revision: none
.. _zend.validator.set.ip:

Ip
==

``Zend_Validate_Ip`` erlaubt es zu Prüfen ob ein gegebener Wert eine IP Adresse ist. Er unterstützt den IPv4 und
auch den IPv6 Standard.

.. _zend.validator.set.ip.options:

Unterstützte Optionen für Zend_Validate_Ip
------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Ip`` unterstützt:

- **allowipv4**: Definiert ob die Prüfung IPv4 Adressen erlaubt. Diese Option ist standardmäßig ``TRUE``.

- **allowipv6**: Definiert ob die Prüfung IPv6 Adressen erlaubt. Diese Option ist standardmäßig ``TRUE``.

.. _zend.validator.set.ip.basic:

Grundsätzliche Verwendung
-------------------------

Ein einfaches Beispiel für die Verwendung ist anbei:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Ip();
   if ($validator->isValid($ip)) {
       // IP scheint gültig zu sein
   } else {
       // IP ist ungültig; Gründe ausgeben
   }

.. note::

   **Ungültige IP Adressen**

   Es ist zu beachten das ``Zend_Validate_Ip`` nur IP Adressen prüft. Adressen wie '``mydomain.com``' oder
   '``192.168.50.1/index.html``' sind keine gültigen IP Adressen. Sie sind entweder Hostnamen oder gültige *URL*\
   s, aber keine IP Adressen.

.. note::

   **IPv6 Prüfung**

   ``Zend_Validate_Ip`` prüft IPv6 Adressen mit einer Regex. Der Grund ist, dass die Filter und Methoden von *PHP*
   der *RFC* nicht folgen. Viele andere vorhandene Klassen folgen Ihr auch nicht.

.. _zend.validator.set.ip.singletype:

IPv4 oder IPv6 alleine prüfen
-----------------------------

Manchmal ist es nützlich nur eines der unterstützten Formate zu prüfen. Zum Beispiel wenn das eigene Netzwert
nur IPv4 unterstützt. In diesem Fall wäre es sinnlos IPv6 in der Prüfung zu erlauben.

Um ``Zend_Validate_Ip`` auf ein Protokoll zu begrenzen kann man die Optionen ``allowipv4`` oder ``allowipv6`` auf
``FALSE`` setzen. Man kann das durchführen indem die Option entweder im Constructor angegeben wird, oder indem
``setOptions()`` im Nachhinein verwendet wird.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Ip(array('allowipv6' => false);
   if ($validator->isValid($ip)) {
       // IP scheint eine gültige IPv4 Adresse zu sein
   } else {
       // IP ist keine IPv4 Adresse
   }

.. note::

   **Standard Verhalten**

   Das Standardverhalten dem ``Zend_Validate_Ip`` folgt, ist es beide Standards zu erlauben.


