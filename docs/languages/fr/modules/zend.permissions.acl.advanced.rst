.. _zend.permissions.acl.advanced:

Utilisation avancée
===================

.. _zend.permissions.acl.advanced.storing:

Rendre les données ACL persistantes
-----------------------------------

``Zend\Permissions\Acl`` a été conçu pour ne pas nécessiter de technologie spécifique comme une base de données ou un
serveur de cache pour conserver les données *ACL*. Son implémentation *PHP* permet de créer des outils
d'administration basés sur ``Zend\Permissions\Acl`` assez facilement. De nombreuses situations nécessitent une certaine forme
de maintenance ou de gestion des *ACL*, et ``Zend\Permissions\Acl`` fournit les méthodes pour définir et interroger les
règles d'accès d'une application.

Le stockage des données *ACL* est dès lors laissé aux bons soins du développeur, dans la mesure où les cas
d'utilisation peuvent grandement varier d'un cas à l'autre. Puisque ``Zend\Permissions\Acl`` est sérialisable, les objets
*ACL* peuvent être sérialisés avec la fonction `serialize()`_ de *PHP*, et le résultat peut être stocké
n'importe où le développeur le désire : fichier, base de donnée, cache.

.. _zend.permissions.acl.advanced.assertions:

Écrire des règles ACL conditionnelles avec des assertions
---------------------------------------------------------

Parfois, une règle pour autoriser ou interdire l'accès d'un rôle à une ressource n'est pas absolu, mais dépend
de plusieurs critères. Par exemple, supposons qu'un certain accès peut être autorisé, mais uniquement entre 8h
du matin et 5h du soir. Un autre exemple consisterait à interdire l'accès parce que la requête provient d'une
adresse IP qui est notée comme source d'abus. ``Zend\Permissions\Acl`` dispose d'un support intégré pour implémenter des
règles sur quoique ce soit dont le développeur ait besoin.

``Zend\Permissions\Acl`` fourni le support pour les règles conditionnelles via ``Zend\Permissions\Acl\Assert\AssertInterface``. Pour mettre en
oeuvre cette interface, il suffit d'implémenter la méthode ``assert()``\  :

.. code-block:: php
   :linenos:

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null,
                              $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isCleanIP($ip)
       {
           //...
       }
   }

Lorsqu'une classe d'assertion est disponible, le développeur doit fournir une instance de cette classe lorsqu'il
assigne une règle conditionnelle. Une règle qui est créée avec une assertion s'applique uniquement dans les cas
où l'assertion retourne une valeur ``TRUE``.

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());

Le code ci-dessus crée une règle conditionnelle qui autorise l'accès à tous les privilèges, sur tout et pour
tout le monde, sauf lorsque l'adresse IP de la requête fait partie de la liste noire. Si une requête provient
d'une adresse IP qui n'est pas considérée comme "propre", alors la règle d'autorisation ne s'applique pas.
Puisque la règle s'applique à tous les rôles, toutes les Ressources, et tous les privilèges, une IP "sale"
aboutira à un refus d'accès. Ceci constitue un cas spécial, et il faut bien noter que tous les autres cas (donc,
si un rôle, une ressource ou un privilège est défini pour la règle), une assertion qui échoue aboutit à une
règle qui ne s'applique pas et ce sont alors les autres règles qui servent à déterminer si l'accès est
autorisé ou non.

La méthode ``assert()`` d'un objet d'assertion reçoit l'*ACL*, le rôle, la ressource et le privilège auquel une
requête d'autorisation (c.-à-d., ``isAllowed()``) s'applique, afin de fournir un contexte à la classe
d'assertion pour déterminer ses conditions lorsque cela est nécessaire.



.. _`serialize()`: http://fr.php.net/serialize
