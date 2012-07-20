.. _zend.layout.advanced:

Zend_Layout, utilisation avancée
================================

``Zend_Layout`` permet d'être utilisé de manière plus pointu.

Vous pouvez agir sur ces éléments :

- **Objet de vue personnalisé.** ``Zend_Layout`` accepte tout objet de vue implémentant l'interface
  ``Zend_View_Interface``.

- **Plugin contrôleur frontal personnalisé.** ``Zend_Layout`` est livré avec un plugin qui rend le layout
  automatiquement avant de renvoyer la réponse (utilisation *MVC*). Vous pouvez injecter votre propre plugin.

- **Aide d'action personnalisée.** ``Zend_Layout`` est livrée avec une aide d'action qui devrait en théorie
  suffire dans la majorité des cas. C'est un proxy vers l'objet ``Zend_Layout``. Vous pouvez cependant utiliser
  votre propre classe d'aide.

- **Résolveur de chemin de script personnalisé**. ``Zend_Layout`` vous permet d'utiliser votre :ref:`inflecteur
  <zend.filter.inflector>` pour la résolution des scripts de layout ou de modifier l'inflecteur par défaut.

.. _zend.layout.advanced.view:

Objets de vue personnalisés
---------------------------

``Zend_Layout`` accepte des objets de vue implémentant ``Zend_View_Interface`` ou étendant ``Zend_View_Abstract``
pour le rendu du script de layout. Passez le en paramètre au constructeur ou à ``startMvc()``, ou utilisez
l'accesseur ``setView()``:

.. code-block:: php
   :linenos:

   $view = new My_Custom_View();
   $layout->setView($view);

.. note::

   **Attention à vos implémentations de Zend_View**

   Même si ``Zend_Layout`` vous permet d'utiliser votre propre objet de vue (implémentant
   ``Zend_View_Interface``), vous pouvez rencontrer des problèmes si votre vue n'a pas accès à certaines aides
   de vue, en particulier les aides "layout" et :ref:`"placeholder" <zend.view.helpers.initial.placeholder>`.
   ``Zend_Layout`` effectue des affectations de variables sur la vue via ces aides.

   Si vous avez besoin d'un objet ``Zend_View`` personnalisé qui ne supporte pas ces aides de vue, vous devrez
   alors trouver un moyen de passer les variables du layout à la vue. Par exemple, en étendant l'objet
   ``Zend_Layout`` et en rédéfinissant la méthode ``render()`` en passant des variables à la vue. Aussi, vous
   pouvez créer votre propre plugin qui s'occupe de passer ces variables avant le rendu du layout.

   De même, si votre implémentation de la vue permet l'extension via des plugins, vous pouvez à tout moment
   accéder aux variables du layout grâce à l'aide :ref:`placeholder <zend.view.helpers.initial.placeholder>` en
   utilisant la clé "Zend_Layout" :

   .. code-block:: php
      :linenos:

      $placeholders = new Zend_View_Helper_Placeholder();
      $layoutVars   = $placeholders->placeholder('Zend_Layout')
                                   ->getArrayCopy();

.. _zend.layout.advanced.plugin:

Plugin de contrôleur frontal personnalisé
-----------------------------------------

Lorsqu'utilisé avec les composants *MVC*, ``Zend_Layout`` enregistre un plugin de contrôleur frontal qui se
charge du rendu du layout juste avant la fin de la boucle de distribution. Ceci convient à la majorité des cas,
si cependant vous avez besoin de construire votre propre plugin, passez son nom dans l'option *pluginClass* de la
méthode ``startMvc()``.

Votre plugin doit alors étendre ``Zend_Controller_Plugin_Abstract``, et devrait accepter un objet ``Zend_Layout``
lors de sa construction.

La classe par défaut du plugin est ``Zend_Layout_Controller_Plugin_Layout``.

.. _zend.layout.advanced.helper:

Aide d'action personnalisée
---------------------------

Si les composants *MVC* sont utilisés, alors ``Zend_Layout`` enregistre une classe d'aide d'action dans le
gestionnaire d'aides (helper broker). Par défaut, il s'agit de ``Zend_Layout_Controller_Action_Helper_Layout``.
Cette aide agit comme un proxy vers l'instance de ``Zend_Layout`` et permet d'y accéder dans vos actions.

Si vous voulez utiliser votre propre classe, celle-ci devra alors étendre
``Zend_Controller_Action_Helper_Abstract``. Passez le nom de la classe dans l'option *helperClass* de la méthode
``startMvc()``.

.. _zend.layout.advanced.inflector:

Résolution de chemin de script personnalisé (inflecteur)
--------------------------------------------------------

``Zend_Layout`` utilise ``Zend_Filter_Inflector`` pour établir une chaine de filtre permettant la résolution du
nom du layout, vers le fichier y correspondant. Par défaut, les règles "Word_CamelCaseToDash" suivie de
"StringToLower" sont utilisées. Le suffixe "phtml" est ensuite ajouté :

- "foo" sera transformé en "foo.phtml".

- "FooBarBaz" sera transformé vers "foo-bar-baz.phtml".

Vous pouvez personnaliser l'inflecteur de 3 manières différentes : Modifier la cible et/ou le suffixe grâce à
des accesseurs dans ``Zend_Layout``; Modifier les règles de l'inflecteur associé à ``Zend_Layout``; Ou encore
créer votre propre inflecteur et le passer à ``Zend_Layout::setInflector()``.

.. _zend.layout.advanced.inflector.accessors:

.. rubric:: Utilisation des accesseurs pour modifier l'inflecteur

L'inflecteur par défaut de ``Zend_Layout`` utilise des marqueurs statiques pour la cible et le suffixe. 2
accesseurs vous sont donc proposés :

.. code-block:: php
   :linenos:

   // Affecte une cible à l'inflecteur:
   $layout->setInflectorTarget('layouts/:script.:suffix');

   // Affecte le suffixe:
   $layout->setViewSuffix('php');

.. _zend.layout.advanced.inflector.directmodification:

.. rubric:: Modification directe de l'inflecteur de Zend_Layout

Les inflecteurs fonctionnent avec un cible et plusieurs règles. La cible par défaut utilisée pour
``Zend_Layout`` est ":script.:suffix" ; ":script" représente le nom du script de layout, et ":suffix" est une
règle statique.

Imaginons que vous vouliez que le suffixe du script de layout soit "html", et que vous vouliez séparer les mots en
CasseMélangée ou en notationCamel avec des tirets-bats au lieu des tirets. De plus, vous voulez chercher vos
scripts dans un sous-dossier "layouts" :

.. code-block:: php
   :linenos:

   $layout->getInflector()->setTarget('layouts/:script.:suffix')
                          ->setStaticRule('suffix', 'html')
                          ->setFilterRule(array('Word_CamelCaseToUnderscore'));

.. _zend.layout.advanced.inflector.custom:

.. rubric:: Inflecteur personnalisé

Dans la plupart des cas, modifier l'inflecteur sera suffisant. Vous pouvez cependant créer votre propre
inflecteur, pour l'utiliser à différents endroits par exemple, et le passer à ``Zend_Layout``:

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('layouts/:script.:suffix');
   $inflector->addRules(array(
       ':script' => array('Word_CamelCaseToUnderscore'),
       'suffix'  => 'html'
   ));
   $layout->setInflector($inflector);

.. note::

   **L'inflecteur peut être désactivé**

   L'inflecteur peut être désactivé si vous spécifiez, par exemple, un chemin absolu pour un script utilisé
   par ``Zend_Layout``. Les méthodes ``enableInflection()`` et ``disableInflection()`` vous y aideront.


