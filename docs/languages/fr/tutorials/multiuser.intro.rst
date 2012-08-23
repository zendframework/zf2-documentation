.. EN-Revision: none
.. _learning.multiuser.intro:

Fabrique une application Multi-Utilisateurs avec Zend Framework
===============================================================

.. _learning.multiuser.intro.zf:

Zend Framework
--------------

Lorsque le web a été crée, il s'agissait d'un média permettant de consulter des documents statiques. La demande
de contenu a cru, le nombre d'internautes aussi et les sites webs sont devenus des applications tournant sur de
grosses plateformes.

*HTTP* est le protocole du web: sans état, des requêtes/réponses à courte durée de vie. Ce protocole a été
crée comme cela pour assurer le web tel qu'on l'entendait avant : servir du contenu statique et c'est ce design
qui a fait du web un immense succès. C'est aussi ce design qui mène à des notions que les développeurs veulent
utiliser dans leurs applications.

Ces informations nous mènent à trois questions:

- Comment distinguer les clients d'une application?

- Comment identifier ces clients?

- Comment contrôler les droits d'un client identifié?

.. note::

   **Client contre Utilisateur**

   Nous utilisons le terme "client" et pas utilisateur. Les applications web deviennent des fournisseurs de
   services. Ceci signifie que les "gens", les utilisateurs humains avec des navigateurs web ne sont pas les seuls
   à consommer l'application et ses services. Beaucoup d'autres applications web consomment elles-mêmes des
   ressources sur une application via des technologies comme *REST*, *SOAP*, ou *XML-RPC*. On voit bien qu'on ne
   peut parler d'utilisateur, nous traitons donc les utilisateurs humains des utilisateurs machines sous le même
   nom : des "clients" web.

Dans les chapitres qui suivent, nous nous attaquerons à ces problèmes que sont l'authentification,
l'identification et les détails. Nous allons découvrir trois composants: ``Zend_Session``, ``Zend_Auth``, et
``Zend\Permissions\Acl``; nous montrerons des exemples concrets et des possibilités d'extension.


