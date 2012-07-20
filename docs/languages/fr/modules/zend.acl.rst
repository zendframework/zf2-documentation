.. _zend.acl.introduction:

Introduction
============

``Zend_Acl`` fournit une implémentation légère et flexible de listes de contrôle d'accès (*ACL*) pour la
gestion de privilèges. En général, une application peut utiliser ces *ACL* pour contrôler l'accès à certains
objets par d'autres objets demandeurs.

Dans le cadre de cette documentation :

- une **ressource** est un objet dont l'accès est contrôlé,

- un **rôle** est un objet qui peut demander l'accès à une ressource.

Dit simplement, **les rôles demandent l'accès à des ressources**. Par exemple, si une personne demande l'accès
à une voiture, alors la personne est le rôle demandeur et la voiture est la ressource, puisque l'accès à la
voiture est soumis à un contrôle.

Grâce à la définition et à la mise en oeuvre d'une *ACL*, une application peut contrôler comment les objets
demandeurs (rôles) reçoivent l'accès (ou non) à des objets protégés (ressources).

.. _zend.acl.introduction.resources:

A propos des ressources
-----------------------

Avec ``Zend_Acl``, créer une ressource est très simple. ``Zend_Acl`` fournit ``Zend_Acl_Resource_Interface`` pour
faciliter la tâche aux développeurs. Une classe a simplement besoin d'implémenter cette interface, qui consiste
en une seule méthode, ``getResourceId()``, pour que ``Zend_Acl`` reconnaît l'objet comme étant une ressource.
Par ailleurs, ``Zend_Acl_Resource`` est fourni par ``Zend_Acl`` comme une implémentation basique de ressource que
les développeurs peuvent étendre si besoin.

``Zend_Acl`` fournit une structure en arbre à laquelle plusieurs ressources (ou "zone sous contrôle d'accès")
peuvent être ajoutées. Puisque les ressources sont sauvées dans cet arbre, elles peuvent être organisées du
général (via la racine de l'arbre) jusqu'au particulier (via les feuilles de l'arbre). Les requêtes envers une
ressource spécifique vont automatiquement entraîner la recherche de règles sur ses parents au sein de la
structure hiérarchique des ressources, ce qui permet un héritage simple des règles. Par exemple, si une règle
par défaut doit être appliquée à tous les bâtiments d'une ville, on pourra simplement assigner la règle à la
ville elle-même, au lieu de la répéter à tous les bâtiments. Mais certains bâtiments peuvent nécessiter des
règles spécifiques, et ceci peut se faire aisément avec ``Zend_Acl`` en assignant les règles nécessaires à
chaque bâtiment de la ville qui nécessite une exception. Une ressource peut hériter d'un seul parent ressource,
qui hérite lui même de son propre parent, et ainsi de suite.

``Zend_Acl`` supporte aussi des privilèges pour chaque ressource (par exemple : "créer", "lire", "modifier",
"supprimer"), et le développeur peut assigner des règles qui affectent tous les privilèges ou seuls certains
privilèges d'une ressource.

.. _zend.acl.introduction.roles:

A propos des rôles
------------------

Comme pour les ressources, créer un rôle est très simple. Tout rôle doit implémenter
``Zend_Acl_Role_Interface`` qui consiste en une seule méthode ``getRoleId()``. De plus, ``Zend_Acl_Role`` est
inclus dans ``Zend_Acl`` comme une implémentation basique de rôle que les développeurs peuvent étendre si
besoin.

Dans ``Zend_Acl``, un rôle peut hériter de un ou plusieurs rôles. Ceci permet de supporter l'héritage de
règles à travers plusieurs rôles. Par exemple, un rôle utilisateur, comme "Éric", peut appartenir à un ou
plusieurs rôles d'action, tels que "éditeur" ou "administrateur". Le développeur peut créer des règles pour
"éditeur" et "administrateur" séparément, et "Éric" va hériter des règles des deux sans avoir à définir des
règles directement pour "Éric".

Bien que la possibilité d'hériter de plusieurs rôles soit très utile, l'héritage multiple introduit aussi un
certain degré de complexité. L'exemple ci-dessous illustre l'ambiguïté et la manière dont ``Zend_Acl`` la
résout.

.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Héritages multiples entre rôles

Le code ci-dessous définit trois rôles de base - "guest", "member", et "admin" - desquels d'autres rôles peuvent
hériter. Ensuite, un rôle identifié par "someUser" est créé et hérite des trois autres rôles. L'ordre selon
lequel ces rôles apparaissent dans le tableau ``$parents`` est important. Lorsque cela est nécessaire
``Zend_Acl`` recherche les règles d'accès définies non seulement pour le rôle demandé (ici "someUser"), mais
aussi pour les autres rôles desquels le rôle recherché hérite (ici "guest", "member", et "admin") :

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $acl->addRole(new Zend_Acl_Role('guest'))
       ->addRole(new Zend_Acl_Role('member'))
       ->addRole(new Zend_Acl_Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend_Acl_Role('someUser'), $parents);

   $acl->add(new Zend_Acl_Resource('someResource'));

   $acl->deny('invite', 'someResource');
   $acl->allow('membre', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'autorisé' : 'refusé';

Puisqu'il n'y a pas de règle spécifiquement définie pour le rôle "someUser" et "someResource", ``Zend_Acl``
doit rechercher des règles qui pourraient être définies pour des rôles dont "someUser" hérite. Premièrement,
le rôle "admin" est contrôlé, et il n'y a pas de règle d'accès définie pour lui. Ensuite, le rôle "member"
est visité, et ``Zend_Acl`` trouve qu'il y a une règle qui spécifie que "member" a un accès autorisé à
"someResource".

Si ``Zend_Acl`` continuait à examiner toutes les règles de tous les rôles parents, il trouverait que
"someResource" est interdit d'accès à "someResource". Ceci introduit une ambiguïté puisque maintenant
"someUser" est à la fois autorisé et interdit d'accès à "someResource", puisqu'il hérite de règles opposées
de ses différents parents.

``Zend_Acl`` résout cette ambiguïté en arrêtant la recherche de règles d'accès dès qu'une première règle
est découverte. Dans notre exemple, puisque le rôle "member" est examiné avant le rôle "guest", le résultat
devrait afficher "autorisé".

.. note::

   Lorsque vous spécifiez plusieurs parents pour un rôle, conservez à l'esprit que le dernier parent listé est
   le premier dans lequel une règle utilisable sera recherchée.

.. _zend.acl.introduction.creating:

Créer la Liste de Contrôle d'Accès
----------------------------------

Une *ACL* peut représenter n'importe quel ensemble d'objets physiques ou virtuels que vous souhaitez. Pour les
besoins de la démonstration, nous allons créer un système basique d'*ACL* pour une Gestion de Contenus (*CMS*)
qui comporte plusieurs niveaux de groupes au sein d'une grande variété de zones. Pour créer un nouvel objet
*ACL*, nous créons une nouvelle instance d'*ACL* sans paramètres :

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

.. note::

   Jusqu'à ce que le développeur spécifie une règle "allow", ``Zend_Acl`` refuse l'accès pour tous les
   privilèges sur chaque ressource pour chaque rôle.

.. _zend.acl.introduction.role_registry:

Registre des rôles
------------------

Les systèmes de gestion de contenu (ou *CMS*) vont pratiquement toujours nécessiter une hiérarchie de
permissions afin de déterminer les droits de rédaction de ses utilisateurs. Il pourrait y avoir un groupe
"Invités" qui donne accès aux démonstrations, un groupe "Staff" pour la majorité des utilisateurs du *CMS* qui
réalisent la plupart du travail quotidien, un groupe "Éditeur" pour ceux qui sont responsables de la publication,
l'archivage, la relecture et la suppression, et enfin un groupe "Administrateur" dont les tâches incluent toutes
les tâches des autres groupes plus des tâches de maintenance, de gestion des utilisateurs, configuration et
backup ou export. Cet ensemble de permissions peut être représenté dans un registre de rôles, permettant à
chaque groupe d'hériter des privilèges des groupes "parents". Les permissions peuvent être rendues de la
manière suivante :

.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Contrôles d'Accès pour un exemple de CMS

   +--------------+----------------------------+-----------------------+
   |Nom           |Permissions                 |Permissions héritées de|
   +==============+============================+=======================+
   |Invité        |Voir                        |N/A                    |
   +--------------+----------------------------+-----------------------+
   |Staff         |Modifier, Soumettre, Relire |Invité                 |
   +--------------+----------------------------+-----------------------+
   |Éditeur       |Publier, Archiver, Supprimer|Staff                  |
   +--------------+----------------------------+-----------------------+
   |Administrateur|(Reçoit tous les accès)     |N/A                    |
   +--------------+----------------------------+-----------------------+

Pour cet exemple, ``Zend_Acl_Role`` est utilisé, mais n'importe quel objet qui implémente
``Zend_Acl_Role_Interface`` est acceptable. Ces groupes peuvent être ajoutés au registre des rôles comme suit :

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   // Ajoute des groupes au registre des rôles en utilisant Zend_Acl_Role

   // Invité n'hérite d'aucun accès
   $roleinvite = new Zend_Acl_Role('invite');
   $acl->addRole($roleinvite);

   // Staff hérite de Invité
   $acl->addRole(new Zend_Acl_Role('staff'), $roleinvite);

   // Ce que précède pourrait aussi être écrit:
   // $acl->addRole(new Zend_Acl_Role('staff'), 'invite');

   // Editeur hérite de staff
   $acl->addRole(new Zend_Acl_Role('editeur'), 'staff');

   // Administrateur n'hérite pas d'accès
   $acl->addRole(new Zend_Acl_Role('administrateur'));

.. _zend.acl.introduction.defining:

Définir les Contrôles d'Accès
-----------------------------

Maintenant que l'*ACL* contient les rôles nécessaires, on peut établir des règles qui définissent comment les
ressources accèdent aux rôles. Vous avez sans doute noté que nous n'avons défini aucune ressource particulière
pour cet exemple, ce qui est plus simple pour illustrer comment les règles s'appliquent à toutes les ressources.
``Zend_Acl`` fournit une implémentation dans laquelle les règles doivent simplement être assignées du général
au particulier, ce qui réduit le nombre de règles spécifiques à ajouter. Ceci grâce à l'héritage.

.. note::

   Généralement ``Zend_Acl`` se conforme à une règle donnée si et seulement si une règle plus spécifique ne
   s'applique pas.

En conséquence, on peut définir un nombre assez complexe de règles avec un nombre minimal de code. Pour définir
les permissions comme définies ci-dessus :

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $roleinvite = new Zend_Acl_Role('invité');
   $acl->addRole($roleinvite);
   $acl->addRole(new Zend_Acl_Role('staff'), $roleinvite);
   $acl->addRole(new Zend_Acl_Role('editeur'), 'staff');
   $acl->addRole(new Zend_Acl_Role('administrateur'));

   // Invité peut uniquement voir le contenu
   $acl->allow($roleinvite, null, 'voir');

   /*
   ce qui précède peut aussi être écrit :
   $acl->allow('invité', null, 'voir');
   */

   // Staff hérite des privilèges de Invité, mais a aussi ses propres
   // privilèges
   $acl->allow('staff', null, array('edit', 'submit', 'relire'));

   // Editeur hérite les privilèges voir, modifier, soumettre,
   // et relire de Staff, mais a aussi besoin de certains privilèges
   $acl->allow('editeur', null, array('publier', 'archiver', 'supprimer'));

   // Administrateur hérite de rien, mais reçoit tous les privilèges
   $acl->allow('administrateur');

Les valeurs ``NULL`` dans les appels ``allow()`` ci-dessus sont utilisées pour indiquer que les règles
s'appliquent à toutes les ressources.

.. _zend.acl.introduction.querying:

Interroger les ACL
------------------

Nous avons maintenant une *ACL* flexible, qui peut être utilisée pour déterminer si l'objet appelant a les
permissions pour réaliser les fonctions au sein de l'application web. Interroger cette liste est assez simple en
utilisant la méthode ``isAllowed()``\  :

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('invité', null, 'voir') ?
        "autorisé" : "refusé";
   // autorisé

   echo $acl->isAllowed('staff', null, 'publier') ?
        "autorisé" : "refusé";
   // refusé

   echo $acl->isAllowed('staff', null, 'relire') ?
        "autorisé" : "refusé";
   // autorisé

   echo $acl->isAllowed('editeur', null, 'voir') ?
        "autorisé" : "refusé";
   // autorisé parce que hérité de Invité

   echo $acl->isAllowed('editeur', null, 'modifier') ?
        "autorisé" : "refusé";
   // refusé parce qu'il n'y a pas de règle pour 'modifier'

   echo $acl->isAllowed('administrateur', null, 'voir') ?
        "autorisé" : "refusé";
   // autorisé car administrateur est autorisé pour tout

   echo $acl->isAllowed('administrateur') ?
        "autorisé" : "refusé";
   // autorisé car administrateur est autorisé pour tout

   echo $acl->isAllowed('administrateur', null, 'modifier') ?
        "autorisé" : "refusé";
   // autorisé car administrateur est autorisé pour tout


