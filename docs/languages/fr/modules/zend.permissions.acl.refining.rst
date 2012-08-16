.. EN-Revision: none
.. _zend.permissions.acl.refining:

Affiner les Contrôles d'Accès
=============================

.. _zend.permissions.acl.refining.precise:

Mieux définir les Contrôles d'Accès
-----------------------------------

L'*ACL* basique définie dans le :ref:`chapitre précédent <zend.permissions.acl.introduction>`\ montre comment plusieurs
privilèges peuvent être alloués pour l'ensemble de l'*ACL* (toutes les ressources). En pratique, toutefois, les
contrôles d'accès ont souvent des exceptions et des degrés de complexité variables. ``Zend\Permissions\Acl`` permet
d'atteindre ce degré de finesse d'une manière directe et flexible.

Pour l'exemple du *CMS*, nous avons déterminé que bien que le groupe "Staff" couvre les besoins de la plupart des
utilisateurs, un groupe "Marketing" est nécessaire. Ce groupe doit avoir accès à la newsletter et aux dernières
news dans le *CMS*. Le groupe va recevoir la possibilité de publier et d'archiver à la fois des newsletters et
des news.

De plus, il a été demandé que le groupe "Staff" puisse voir les nouveaux textes, mais pas les nouvelles news.
Enfin, il devrait être impossible pour tout le monde (y compris les administrateurs) d'archiver un contenu qui
n'aurait une durée de vie que de 1 ou 2 jours.

En premier lieu, nous modifions le registre des rôles pour refléter ces changements. Nous avons dit que le groupe
"Marketing" a les même permissions de base que "Staff". Donc nous créons "marketing" pour qu'il hérite des
permissions de "staff".

.. code-block:: php
   :linenos:

   // Le nouveau groupe Marketing hérite des permissions de Staff
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');

Ensuite, notez que les contrôles d'accès plus haut font référence à des ressources (ex. "newsletters",
"dernières news", "annonces"). Maintenant, nous ajoutons ces Ressources :

.. code-block:: php
   :linenos:

   // Créer les Ressources pour les règles

   // newsletter
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // news
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // dernières news
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // annonces
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');

Ensuite c'est simplement une manière de définir ces règles spécifiques sur les parties cibles de l'*ACL*\  :

.. code-block:: php
   :linenos:

   // Le Marketing doit être capable de publier
   // et d'archiver les newsletters et les dernières news
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Staff (et marketing, par héritage),
   // n'ont pas la permission de relire les dernières news
   $acl->deny('staff', 'latest', 'relire');

   // Personne (y compris les administrateurs)
   // n'a la permission d'archiver des annonces
   $acl->deny(null, 'annonce', 'archive');

On peut maintenant interroger les *ACL* sur base des dernières modifications :

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "autorisé" : "refusé"; // refusé

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "autorisé" : "refusé"; // autorisé

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "autorisé" : "refusé"; // refusé

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "autorisé" : "refusé"; // autorisé

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "autorisé" : "refusé"; // autorisé

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "autorisé" : "refusé"; // refusé

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "autorisé" : "refusé"; // refusé

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "autorisé" : "refusé"; // refusé

.. _zend.permissions.acl.refining.removing:

Retirer les Contrôles d'Accès
-----------------------------

Pour retirer une ou plusieurs règles des *ACL*, utilisez simplement la méthode ``removeAllow()`` ou
``removeDeny()``. Comme pour ``allow()`` et ``deny()``, vous pouvez utiliser une valeur ``NULL`` pour indiquer que
la méthode s'applique à tous les rôles, ressources et / ou privilèges.

.. code-block:: php
   :linenos:

   // Retire l'interdiction de relire les dernières news au Staff
   // (et au marketing, par héritage)
   $acl->removeDeny('staff', 'latest', 'relire');

   echo $acl->isAllowed('marketing', 'latest', 'relire') ?
        "autorisé" : "refusé"; // autorisé

   // Retire l'autorisation de publier
   // et archiver les newsletters au Marketing
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "autorisé" : "refusé"; // refusé

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "autorisé" : "refusé"; // refusé

Les privilèges peuvent être modifiés de manière incrémentielle comme indiqué au dessus, mais une valeur
``NULL`` pour les privilèges écrase ces modifications incrémentielles.

.. code-block:: php
   :linenos:

   // donne au groupe Marketing toutes les permissions
   // sur les dernières nouvelles
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "autorisé" : "refusé"; // autorisé

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "autorisé" : "refusé"; // autorisé

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "autorisé" : "refusé"; // autorisé


