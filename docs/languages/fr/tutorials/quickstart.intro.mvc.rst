.. _learning.quickstart.intro:

Zend Framework & Introduction MVC
=================================

.. _learning.quickstart.intro.zf:

Zend Framework
--------------

Zend Framework est un cadre de travail open source orienté objets pour des applications web basées sur *PHP* 5.
Zend Framework est souvent appelé une "bibliothèque de composants" car ses composants sont faiblement couplés et
vous pouvez les utiliser de manière plus ou moins indépendante. Mais Zend Framework propose aussi une solution
avancée Model-View-Controller (*MVC*) qui peut être utilisée pour monter des structures de base pour vos
applications. Une liste complète des composants de Zend Framework avec une brève description peut être trouvée
dans `l'aperçu des composants`_. Ce guide de démarrage montre les composants les plus utilisés dans Zend
Framework, comme ``Zend_Controller``, ``Zend_Layout``, ``Zend_Config``, ``Zend_Db``, ``Zend_Db_Table``,
``Zend_Registry``, ainsi que quelques aides de vue.

En utilisant ces composants nous allons construire un livre d'or reposant sur une base de données, simple, en
quelques minutes. Le code source complet pour cette application est disponible dans les formats :

- `zip`_

- `tar.gz`_

.. _learning.quickstart.intro.mvc:

Model-View-Controller
---------------------

Qu'est ce que *MVC* dont tout le monde parle et pourquoi se pencher dessus ? *MVC* est bien plus qu'un acronyme de
trois lettres (*TLA*) que vous pouvez sortir pour faire "élégant" ; c'est devenu un standard de conception des
applications Web modernes, ceci pour de bonnes raisons. La plupart du code des application se retrouvent dans une
de ces catégories : présentation, logique métier, accès aux données. Le pattern *MVC* modélise cette
séparation à merveille. Le résultat final est qu'un code de présentation peut être travaillé à un endroit de
l'application alors que la logique métier et l'accès aux données le sont à d'autres endroits. La plupart des
développeurs ont trouvé cette séparation indispensable pour maintenir le code global organisé,
particulièrement lorsque plusieurs développeurs travaillent ensemble sur la même application.

.. note::

   **Plus d'informations**

   Cassons le pattern pour voir les pièces individuellement :

   .. image:: ../images/learning.quickstart.intro.mvc.png
      :width: 321
      :align: center

   - **Model**- C'est la partie qui définit la fonctionnalité de base de l'application derrière des
     abstractions. L'accès aux données et la logique métier sont définis dans cette couche.

   - **View**- La vue définit exactement ce qui sera présenté à l'utilisateur. Normalement les contrôleurs
     passent des données à chaque vue à rendre dans un format précis. Les vues collectent les données de
     l'utilisateur aussi. Ici vous trouverez principalement du *HTML*.

   - **Controller**- Les contrôleurs sont la colle qui lie tout. Ils manipulent les modèles, décident de la vue
     à rendre en fonction de la requête utilisateur et d'autres facteurs, passent les données dont chaque vue a
     besoin et passent éventuellement la main à un autre contrôleur. La plupart des experts *MVC* experts
     recommandent `de garder les contrôleurs les plus simples et petits possibles`_.

   Bien sûr `on pourrait en dire plus`_ sur ce pattern critique, mais nous avons là suffisament d'informations
   pour comprendre l'application de livre d'or que nous allons construire.



.. _`l'aperçu des composants`: http://framework.zend.com/about/components
.. _`zip`: http://framework.zend.com/demos/ZendFrameworkQuickstart.zip
.. _`tar.gz`: http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz
.. _`de garder les contrôleurs les plus simples et petits possibles`: http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model
.. _`on pourrait en dire plus`: http://ootips.org/mvc-pattern.html
