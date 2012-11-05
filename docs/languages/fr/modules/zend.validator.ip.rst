.. EN-Revision: none
.. _zend.validate.set.ip:

Ip
==

``Zend\Validate\Ip`` permet de déterminer si une adresse IP donnée est valide. Le composant supporte IPv4 et
IPv6.

.. _zend.validate.set.ip.options:

Options supportées par Zend\Validate\Ip
---------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\Ip``\  :

- **allowipv4**\  : définit si la validation autorise les adresses IPv4. Cette option vaut ``TRUE`` par défaut.

- **allowipv6**\  : définit si la validation autorise les adresses IPv6. Cette option vaut ``TRUE`` par défaut.

.. _zend.validate.set.ip.basic:

Utilisation classique
---------------------

Voici un exemple banal:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Ip();
   if ($validator->isValid($ip)) {
       // ip semble valide
   } else {
       // ip n'est pas valide
   }

.. note::

   **adresses IP invalides**

   ``Zend\Validate\Ip`` ne valide que des adresses IP. '``mydomain.com``' ou '``192.168.50.1/index.html``' ne sont
   donc pas des adresses IP valides. Ce sont des noms de domaines ou des *URL*\ s mais pas des adresses IP.

.. note::

   **Validation IPv6**

   ``Zend\Validate\Ip`` valides les adresses IPv6 au moyen d'expressions régulières. La raison est que les
   fonctions fournies par PHP ne suivent pas la *RFC*. Beaucoup d'autres classes disponibles font de même.

.. _zend.validate.set.ip.singletype:

Valider IPv4 ou IPV6 seules
---------------------------

Il peut arriver de ne vouloir valider qu'un seul des deux formats. Par exemple si le réseau ne supporte pas IPv6,
il serait idiot de demander une telle validation.

Pour limiter ``Zend\Validate\Ip`` sur un seul des deux protocoles, utilisez les options ``allowipv4`` ou
``allowipv6`` et mettez les à ``FALSE``. Il est possible d'effectuer celà au moyen du constructeur ou avec la
méthode ``setOptions()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Ip(array('allowipv6' => false);
   if ($validator->isValid($ip)) {
       // ip semble être une IPv4 valide
   } else {
       // ip n'est pas une adresse IPv4
   }

.. note::

   **Comportement par défaut**

   Le comportement par défaut de ``Zend\Validate\Ip`` est de valider les deux standards.


