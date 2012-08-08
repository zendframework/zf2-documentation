.. EN-Revision: none
.. _learning.view.placeholders.standard:

Placeholders standards
======================

Dans la :ref:`section précédente <learning.view.placeholders.basics>`, nous avons vu l'aide de vue
``placeholder()`` et comment l'utiliser pour aggréger du contenu personnalisable. Dans ce chapitre, nous allons
passer en revue quelques placeholders concrets fournis avec Zend Framework, ainsi que la manière de les utiliser
à votre avantage pour créer des layouts complexes.

La plupart des placeholders fournis permettent de gérer le contenur de la section **<head>** de la layout -- une
zone qui ne peut typiquement pas être manipulée directement par vos scripts de vue, mais que vous voulez tout de
même traiter. Par exemples: vous voudriez que votre titre se compose d'un certain contenu sur toutes les pages
mais aussi d'une partie dynamique relative au contrôleur/action en cours; aussi vous voudriez préciser des
fichiers *CSS* à charger basés sur la section de l'application en cours; enfin vous pourriez avoir recours à des
scripts JavaScript spécifiques parfois, ou encore changer la déclaration de *DocType*.

Zend Framework est livré avec des implémentations de placeholder pour chacune de ces situations et encore
d'autres.

.. _learning.view.placeholders.standard.doctype:

Changer le DocType
------------------

Les déclarations de *DocType* sont difficiles à mémoriser et souvent essentielles pour s'assurer que le
navigateur rende correctement le contenu. L'aide de vue ``doctype()`` permet d'utiliser des mnemonics pour
spécifier un *DocType*; aussi, d'autres aides de vues interrogeront l'aide ``doctype()`` pour s'assurer que le
contenu qu'elles génèrent est conforme au *DocType* utilisé.

Par exemple si vous souhaitez utiliser la *DTD* *XHTML1* Strict, vous pouvez simplement la préciser comme ceci:

.. code-block:: php
   :linenos:

   $this->doctype('XHTML1_STRICT');

Voici les autres mnemonics utilisables:

**XHTML1_STRICT**
   *XHTML* 1.0 Strict

**XHTML1_TRANSITIONAL**
   *XHTML* 1.0 Transitional

**HTML4_STRICT**
   *HTML* 4.01 Strict

**HTML4_Loose**
   *HTML* 4.01 Loose

**HTML5**
   *HTML* 5

Vous pouvez changer le type et rendre la déclaration en un seul appel:

.. code-block:: php
   :linenos:

   echo $this->doctype('XHTML1_STRICT');

Cependant l'approche conseillée est de préciser le type dans le bootstrap et rendre l'aide de vue dans la layout.
Essayez d'ajouter ceci à votre classe de bootstrap:

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDocType()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');
       }
   }

Puis, dans le script de layout, affichez simplement avec ``echo`` l'aide en haut du fichier:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <!-- ... -->

Ceci permet d'être sûr que les aides de vue diverses utiliseront cette déclaration, que le docType est précisé
avant le rendu du layout et qu'il n'existe qu'un seul endroit logique pour le changer.

.. _learning.view.placeholders.standard.head-title:

Spécifier le titre de la page
-----------------------------

Souvent, le site incluera le nom de la société dans le titre de la page et ajoutera ensuite des informations
basées sur la page en cours de lecture. Par exemple, le site zend.com inclut la chaine "Zend.com" sur toutes les
pages et y fait précèder des informations relatives à la page en cours: "Zend Server - Zend.com". Dans Zend
Framework, l'aide de vue ``headTitle()`` peut vous simplifier cette tâche.

Au plus simple, l'aide ``headTitle()`` permet d'aggréger du contenu pour la balise **<title>**; lorsque vous
l'affichez, il assemble son contenu dans l'ordre des ajouts. Pour contrôler l'ordre, les méthodes ``prepend()``
et ``append()`` sont là, pour changer le séparateur à utiliser entre les segments, utilisez la méthode
``setSeparator()``.

Typiquement vous devriez renseigner tous les segments communs à toutes les pages en bootstrap, de la même
manière que nous avions agit avec le doctype. Dans ce cas, nous allons écrire une méthode
``_initPlaceholders()`` pour gérer tous les placeholders et préciser un titre initial ainsi qu'un séparateur.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Précise le titre initial et le séparateur:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');
       }

       // ...
   }

Dans un script de vue, nous voulons ajouter un nouveau segment:

.. code-block:: php
   :linenos:

   <?php $this->headTitle()->append('Some Page'); // placé après les autres segments ?>
   <?php $this->headTitle()->prepend('Some Page'); // placé avant ?>

Dans notre layout, nous affichons simplement l'aide ``headTitle()``:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <!-- ... -->

Le contenu suivant aura été généré:

.. code-block:: html
   :linenos:

   <!-- Si append() a été utilisé: -->
   <title>My Site :: Some Page</title>

   <!-- Si prepend() a été utilisé: -->
   <title>Some Page :: My Site</title>

.. _learning.view.placeholders.standard.head-link:

Spécifier des feuilles de style avec HeadLink
---------------------------------------------

Les bons développeurs *CSS* créront souvent une feuille de style globale et des feuilles individuelles pour les
sections spécifiques ou certaines pages du site puis chargeront celles-ci plus tard conditionnellement afin de
réduire le nombre de données à transférer entre chaque requête. Le placeholder ``headLink()`` permet de
réaliser de telles aggrégations conditionnelles de feuilles de style.

Pour cela, ``headLink()`` definit une certain nombre de méthodes "virtuelles" (via surcharge) pour simplifier le
tout. Celles qui vont nous concernet sont ``appendStylesheet()`` et ``prependStylesheet()``. Chacune peut accepter
jusqu'à quatre arguments, ``$href`` (chemin relatif vers la feuille de style), ``$media`` (le type *MIME*, par
défaut "text/css"), ``$conditionalStylesheet`` (à utiliser pour préciser une "condition" à évaluer pour la
feuille de style), et ``$extras`` (un tableau associatif utiliser générallement pour renseigner une clé pour
"media"). Dans la plupart des cas, seul le premier argument suffira, le chemin relatif vers la feuille de style.

Dans notre exemple, nous supposerons que toutes les pages ont besoin de charger une feuille de style stockée dans
"``/styles/site.css``" (relativement au document root); nous allons préciser cela dans notre méthode de bootstrap
``_initPlaceholders()``.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Affecte le titre original et le séparateur:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');

           // Affecte la feuille de style originale:
           $view->headLink()->prependStylesheet('/styles/site.css');
       }

       // ...
   }

Plus tard, dans un contrôleur par exemple, nous pouvons rajouter des feuilles de style:

.. code-block:: php
   :linenos:

   <?php $this->headLink()->appendStylesheet('/styles/user-list.css') ?>

Dans notre layout, là encore, un simple echo sur le placeholer:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <!-- ... -->

Ceci génèrera quelque chose comme:

.. code-block:: html
   :linenos:

   <link rel="stylesheet" type="text/css" href="/styles/site.css" />
   <link rel="stylesheet" type="text/css" href="/styles/user-list.css" />

.. _learning.view.placeholders.standard.head-script:

Aggréger des scripts avec HeadScript
------------------------------------

Un autre moyen de ne pas surcharger la page est de ne charger le JavaScript que lorsque c'est nécessaire. Vous
aurez donc besoin de scripts découpés: peut-être un pour afficher le menu du site progressivement, un autre pour
traiter le contenu d'une page spécifique. Dans ces cas, l'aide ``headScript()`` propose une solution.

Comme l'aide ``headLink()``, ``headScript()`` permet d'empiler en début ou fin des scripts entiers et de les
afficher d'un coup. Cela est très flexible pour spécifier des fichiers de scripts entiers à charger, ou encore
du code JavaScript explicite. Vous pouvez aussi capturer le JavaScript via ``captureStart()``/``captureEnd()``, qui
permettent d'utiliser du code JavaScript inline plutot que de demander un appel serveur pour charger un fichier.

Tout comme ``headLink()``, ``headScript()`` propose des mééthodes "virtuelles" via surcharge pour spécifier
rapidement des contenus à aggréger; les méthodes sont ``prependFile()``, ``appendFile()``, ``prependScript()``,
et ``appendScript()``. Les deux premières vous permettent de préciser des fichiers référéncés dans l'attribut
``$src`` d'une balise **<script>**; les deux dernières vont prendre le contenu qu'on leur passe et le rendre comme
du JavaScript dans les balises **<script>**.

Dans cet exemple, nous allons spécifier qu'un script, "``/js/site.js``" a besoin d'être chargé sur chaque page;
nous allons donc mettre à jour notre méthode de bootstap ``_initPlaceholders()`` pour effectuer cela.

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initPlaceholders()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');
           $view->doctype('XHTML1_STRICT');

           // Titre et séparateur d'origine:
           $view->headTitle('My Site')
                ->setSeparator(' :: ');

           // Feuille de style originale:
           $view->headLink()->prependStylesheet('/styles/site.css');

           // Affecte le JS initial à charger:
           $view->headScript()->prependFile('/js/site.js');
       }

       // ...
   }

Dans un script de vue, nous voulons ajouter un script ou capturer du contenu JavaScript à inclure dans le
document.

.. code-block:: php
   :linenos:

   <?php $this->headScript()->appendFile('/js/user-list.js') ?>
   <?php $this->headScript()->captureStart() ?>
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   <?php $this->headScript()->captureEnd() ?>

Dans notre script de layout, nous affichons simplement le placeholder, tout comme nous avions fait pour les autres
précédemment:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>
   <html>
       <?php echo $this->headTitle() ?>
       <?php echo $this->headLink() ?>
       <?php echo $this->headScript() ?>
       <!-- ... -->

Le contenu suivant sera généré:

.. code-block:: html
   :linenos:

   <script type="text/javascript" src="/js/site.js"></script>
   <script type="text/javascript" src="/js/user-list.js"></script>
   <script type="text/javascript">
   site = {
       baseUrl: "<?php echo $this->baseUrl() ?>"
   };
   </script>

.. note::

   **Variante InlineScript**

   La plupart des navigateur bloquent l'affichage tant que tous les scritps et les feuilles de style référencés
   dans la section **<head>** ne sont pas chargés. Ces règles permettent un meilleur feeling au niveau du rendu
   de la page et permettent à l'utilisateur de voir le contenu de la page plus tôt.

   Pour cela, vous pouvez par exemple écrire vos tags **<script>** après avoir fermé **<body>**. (C'est une
   pratique recommandée par `Y! Slow project`_.)

   Zend Framework supporte cela de deux manières différentes:

   - Vous pouvez rendre ``headScript()`` où vous voulez dans votre layout; ce n'est pas parce que la méthode
     commence par "head" que vous devez l'appeler pour cette section du HTML.

   - Aussi, vous pourriez utiliser l'aide de vue ``inlineScript()``, qui est simplement une variante de
     ``headScript()`` avec le même comportement mais un registre séparé.



.. _`Y! Slow project`: http://developer.yahoo.com/yslow/
