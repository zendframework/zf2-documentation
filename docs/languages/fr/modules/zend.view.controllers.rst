.. _zend.view.controllers:

Scripts de contrôleur
=====================

Le contrôleur est l'endroit où vous instanciez et configurez ``Zend_View``. Vous assignez ensuite des variables
à la vue, et lui dites comment effectuer le rendu en utilisant un script particulier.

.. _zend.view.controllers.assign:

Assigner des variables
----------------------

Votre script de contrôleur devrait assigner les variables nécessaires à la vue avant de passer le contrôle au
script de vue. Normalement vous pouvez faire les assignations une par une en assignant les noms des propriétés de
l'instance de la vue :

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Ha";
   $view->b = "Bé";
   $view->c = "Cé";

Cependant, ceci peut être pénible quand vous avez déjà collecté (dans un tableau ou dans un objet) les valeurs
à assigner.

La méthode ``assign()`` vous laisse assigner "en vrac" depuis un tableau ou un objet. Les exemples suivants ont le
même effet que celui ci-dessus.

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // assigne un tableau de paires clés/valeurs, où la clé
   // est le nom de la variable, et la valeur, sa valeur assignée
   $array = array(
       'a' => "Ha",
       'b' => "Bé",
       'c' => "Cé",
   );
   $view->assign($array);

   // fait pareil avec les propriétés publiques d'un objet
   // notez le transtypage lors de l'assignation
   $obj = new StdClass;
   $obj->a = "Ha";
   $obj->b = "Bé";
   $obj->c = "Cé";
   $view->assign((array) $obj);

Alternativement, vous pouvez utiliser la méthode ``assign()`` pour assigner les variables une par une, en passant
le nom de la variable, et sa valeur.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->assign('a', "Ha");
   $view->assign('b', "Bé");
   $view->assign('c', "Cé");

.. _zend.view.controllers.render:

Effectuer le rendu d'un script de vue
-------------------------------------

Une fois que vous avez assigné toutes les variables dont vous avez besoin, le contrôleur devrait demander à
``Zend_View`` de rendre un script de vue particulier. Faites cela en appelant la méthode ``render()``. Notez que
la méthode va retourner la vue rendue, mais ne va pas l'afficher, vous devez donc l'afficher vous même avec
*print* ou *echo*, au moment voulu.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Ha";
   $view->b = "Bé";
   $view->c = "Cé";
   echo $view->render('uneVue.php');

.. _zend.view.controllers.script-paths:

Chemin des scripts de vue
-------------------------

Par défaut, ``Zend_View`` s'attend à ce que vos scripts de vues soient dans le même dossier que celui du
contrôleur. Par exemple, si le script du contrôleur est dans "/chemin/des/controleurs" et qu'il appelle
*$view->render('uneVue.php')*, ``Zend_View`` va rechercher "/chemin/des/controleurs/uneVue.php".

Évidemment, vos scripts sont peut-être localisés ailleurs. Pour dire à ``Zend_View`` ou il doit chercher,
utilisez la méthode ``setScriptPath()``.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->setScriptPath('/chemin/des/vues');

Maintenant, vous appelez *$view->render('uneVue.php')*, il va rechercher dans "``/chemin/des/vues/uneVue.php``".

En fait, vous pouvez "empiler" les chemins en utilisant la méthode ``setScriptPath()``. Comme vous ajoutez des
chemins dans la pile, ``Zend_View`` va rechercher le script de vue dans le chemin le plus récemment ajouté. Cela
vous permet de passer outre les vues par défaut, pour des vues personnalisées. Ainsi vous pouvez créer des
"thèmes" ou des "skins" pour certaines vues, pendant que vous laissez les autres intactes.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->addScriptPath('/chemin/des/vues');
   $view->addScriptPath('/chemin/des/vues-personnalisees');

   // maintenant, lorsque vous appelerez $view->render('listelivre.php'),
   // Zend_View va rechercher en premier dans
   // "/chemin/des/vues-personnalisees/listelivre.php", puis
   // dans "/chemin/des/vues/listelivre.php", et ensuite dans le répertoire
   // courant pour trouver le fichier "listelivre.php".

.. note::

   **Ne jamais utiliser une entrée utilisateur pour spécifier les chemins vers les scripts de vues**

   ``Zend_View`` utilise des chemins dans lesquels elle cherche et effectue le rendu des scripts de vues. En soi,
   ces dossiers devraient être connus à l'avance, et sous votre contrôle. **Ne jamais** spécifier des dossiers
   de scripts de vues sur la base d'une entrée utilisateur, car vous pourriez ainsi avoir une vulnérabilité
   d'inclusion de fichier non voulu si les chemins spécifiés par l'utilisateur sont traversant. Par exemple, le
   code suivant peut générer un problème :

   .. code-block:: php
      :linenos:

      // $_GET['foo'] == '../../../etc'
      $view->addScriptPath($_GET['foo']);
      $view->render('passwd');

   De la manière dont cet exemple est conçu, il montre clairement le problème potentiel. Si vous **devez**
   compter sur l'entrée d'utilisateur pour placer votre chemin de scripts, filtrez correctement l'entrée et
   contrôlez pour vous assurer que ces chemins sont contrôlés par votre application.


