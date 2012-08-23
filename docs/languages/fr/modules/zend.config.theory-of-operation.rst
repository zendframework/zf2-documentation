.. EN-Revision: none
.. _zend.config.theory_of_operation:

Aspect théorique
================

Les données de configuration sont transmis au constructeur de ``Zend_Config`` sous la forme d'un tableau
associatif, qui peut être multidimensionnel, afin de supporter une organisation des données du général vers le
spécifique. Les classes d'adaptateur concrètes permettent de construire le tableau associatif pour le
constructeur de ``Zend_Config`` à partir du système de stockage des données de configuration. Dans certaines
utilisations spécifiques, les scripts de l'utilisateur peuvent fournir de tels tableaux directement au
constructeur de ``Zend_Config``, sans employer une classe d'adaptateur.

Chaque valeur du tableau de données de configuration devient une propriété de l'objet ``Zend_Config``. La clé
est utilisée comme nom de propriété. Si une valeur est un tableau, alors la propriété d'objet résultante est
créée comme un nouveau objet ``Zend_Config``, chargé avec les données du tableau. Cela se déroule
récursivement, tel qu'une hiérarchie de données de configuration peut être créée avec n'importe quel nombre
de niveaux.

``Zend_Config`` implémente les interfaces **Countable** et **Iterator** afin de faciliter l'accès simple aux
données de configuration. Ainsi, on peut employer la fonction `count()`_ et des constructions de *PHP* telles que
`foreach`_ sur des objets ``Zend_Config``.

Par défaut, les données de configuration fournies par ``Zend_Config`` ne sont pas modifiables (lecture seule), et
une affectation (par exemple, ``$config->database->host = 'example.com';``) lèvera une exception. Ce comportement
par défaut peut cependant être surchargé par le constructeur pour permettre la modification des valeurs de
données. De plus, quand les modifications sont autorisées, ``Zend_Config`` supporte l'effacement de valeurs
(c'est-à-dire ``unset($config->database->host)``). La méthode ``readOnly()`` peut être utilisée pour
déterminer si les modifications sont autorisés pour un objet ``Zend_Config`` donné et la méthode
``setReadOnly()`` peut être utilisée pour empêcher toute nouvelle modification d'un objet ``Zend_Config`` qui
aurait été créé en autorisant le modifications.

.. note::

   Il est important de ne pas confondre des modifications en cours de script avec l'enregistrement des données de
   configuration dans le support de stockage spécifique. Les outils pour créer et modifier des données de
   configuration pour différents supports de stockage ne concernent pas ``Zend_Config``. Des solutions tiers
   open-source sont facilement disponibles afin de créer et / ou de modifier les données de configuration pour
   différents supports de stockage.

Les classes d'adaptateur héritent de la classe de ``Zend_Config`` ce qui permet d'utiliser ses fonctionnalités.

La famille des classes ``Zend_Config`` permet d'organiser les données de configuration en sections. Les classes
d'adaptateur ``Zend_Config`` peuvent être chargées en spécifiant une section unique, des sections multiples, ou
toutes les sections (si aucune n'est indiquée).

Les classes d'adaptateurs ``Zend_Config`` supporte un modèle d'héritage simple qui permet à des données de
configuration d'être héritées d'une section de données de configuration dans d'autres. Ceci afin de réduire ou
d'éliminer le besoin de reproduire des données de configuration pour différents cas. Une section héritante peut
également surchargée les valeurs dont elle hérite de sa section parente. Comme l'héritage des classes *PHP*,
une section peut hériter d'une section parent, qui peut hériter d'une section grand-parent, et ainsi de suite,
mais l'héritage multiple (c.-à-d., la section C héritant directement des sections parents A et B) n'est pas
supporté.

Si vous avez deux objets ``Zend_Config``, vous pouvez les fusionner en un objet unique en utilisant la fonction
``merge()``. Par exemple, prenons ``$config`` et ``$localConfig``, vous pouvez fusionner ``$localConfig`` dans
``$config`` en utilisant ``$config->merge($localConfig);``. Les éléments de ``$localConfig`` surchargeront les
éléments nommés de la même manière dans ``$config``.

.. note::

   L'objet ``Zend_Config`` qui réalise la fusion doit avoir été construit en autorisant les modifications, en
   fournissant ``TRUE`` en tant que second paramètre du constructeur. La méthode ``setReadOnly()`` peut être
   utilisée pour empêcher toute nouvelle modification après la fin de la fusion.



.. _`count()`: http://fr.php.net/count
.. _`foreach`: http://fr.php.net/foreach
