.. _learning.layout.usage:

Utiliser Zend_Layout
====================

L'utilisation classique de ``Zend_Layout`` est simple. En supposant que vous utilisez ``Zend_Application``, il
suffit simplement de passer des options de configuration et créer un script de layout.

.. _learning.layout.usage.configuration:

Layout Configuration
--------------------

L'endroit recommandé pour stocker les layouts est "``layouts/scripts/``" dans l'application:

.. code-block:: text
   :linenos:

   application
   |-- Bootstrap.php
   |-- configs
   |   `-- application.ini
   |-- controllers
   |-- layouts
   |   `-- scripts
   |       |-- layout.phtml

Pour initialiser ``Zend_Layout``, ajouter ceci à votre fichier de configuration
("``application/configs/application.ini``"):

.. code-block:: dosini
   :linenos:

   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"
   resources.layout.layout = "layout"

La première ligne indique où chercher les scripts de layout; la seconde donne le nom du script à utiliser
(l'extension est supposée "``.phtml``" par défaut).

.. _learning.layout.usage.layout-script:

Créer un script de layout
-------------------------

Il convient maintenant de créer un script de layout. D'abord, vérifiez l'existance du dossier
"``application/layouts/scripts``"; puis ouvrez un éditeur et créez une mise en page balisée. Les scripts de
layout sont des scripts de vue, avec quelques différences tout de même.

.. code-block:: php
   :linenos:

   <html>
   <head>
       <title>My Site</title>
   </head>
   <body>
       <?php echo $this->layout()->content ?>
   </body>
   </html>

Dans l'exemple ci-dessus, un appel à l'aide de vue ``layout()`` y est effectué. Lorsque vous activez l'instance
de ``Zend_Layout``, vous avez aussi accès à une aide d'acion et de vue qui permettent d'accéder à l'instance de
``Zend_Layout``; et vous pouvez ainsi appeler des méthodes sur l'objet layout. Dans notre cas, nous récupérons
une variable appelée ``$content``, et nous l'affichons. Par défaut, ``$content`` est peuplée du contenu de la
vue rendue pour l'action en cours. Sinon, tout ce que vous feriez dans un script de vue est valide dans un script
de layout: appel d'aides ou de méthodes sur la vue.

Maintenant, nous avons un script de layout fonctionnel et notre application sait où le trouver.

.. _learning.layout.usage.access:

Accéder à l'objet Layout
------------------------

Il est probable que vous ayez besoin d'accéder à l'objet instance layout. Cela est possible de trois manières:

- **Dans des scripts de vue:** utilisez l'aide de vue ``layout()``, qui retourne l'instance de ``Zend_Layout``
  enregistrée au moyen du plugin MVC.

  .. code-block:: php
     :linenos:

     <?php $layout = $this->layout(); ?>

  Comme cela retourne l'objet de layout, vous pouvez appeler dessus toute méthode ou assigner des variables.

- **Dans vos contrôleurs:** utilisez ici l'aide d'action ``layout()``, qui agit comme l'aide de vue.

  .. code-block:: php
     :linenos:

     // Appel de l'aide comme méthode sur le gestionnaire d'aides:
     $layout = $this->_helper->layout();

     // Ou, de manière plus détaillée:
     $helper = $this->_helper->getHelper('Layout');
     $layout = $helper->getLayoutInstance();

  Comme avec l'aide de vue, vous pouvez appeler dès lors n'importe quelle méthode de layout ou lui assigner des
  variables.

- **Ailleurs:** utilisez la méthode statique ``getMvcInstance()``. Cette méthode retourne l'instance de layout
  comme déja vu plus haut maintenant.

  .. code-block:: php
     :linenos:

     $layout = Zend_Layout::getMvcInstance();

- **Via le bootstrap:** utilisez la ressource layout qui crée, configure et retourne l'objet ``Zend_Layout``.

  .. code-block:: php
     :linenos:

     $layout = $bootstrap->getResource('Layout');

  Partout où vous avez accès à l'objet bootstrap, il s'agit de la méthode recommandée par rapport à
  ``getMvcInstance()``.

.. _learning.layout.usage.other-operations:

Autres opérations
-----------------

Dans la plupart des cas, le script de configuration de layout ci-dessus (avec quelques modifications) répondra à
vos besoins. Cependant, dans certains cas il peut être intéressant d'utiliser d'autres fonctionnalités. Dans les
exemples qui suivent, vous allez utiliser une des :ref:`méthodes listées ci-dessus
<learning.layout.usage.access>` pour récupérer l'objet layout.

- **Affecter les variables de layout**. ``Zend_Layout`` garde en mémoire les variables de vue spécifiques à la
  layout, la clé ``$content`` en est un exemple. Vous pouvez assigner et récupérer ces variables grâce à la
  méthode ``assign()`` ou en y accédant comme des attributs classiques.

  .. code-block:: php
     :linenos:

     // Affecter du contenu:
     $layout->somekey = "foo"

     // Afficher ce même contenu:
     echo $layout->somekey; // 'foo'

     // Utiliser la méthode assign() :
     $layout->assign('someotherkey', 'bar');

     // Accéder à la variable reste identique:
     echo $layout->someotherkey; // 'bar'

- ``disableLayout()``. Occasionellement, vous pouriez vouloir d"sactiver totalement les layouts, par exemple, pour
  répondre à une requête AJAX ou autravers d'une API RESTful. Dans ces cas, appelez la méthode
  ``disableLayout()`` de l'objet layout.

  .. code-block:: php
     :linenos:

     $layout->disableLayout();

  Le contraire de cette méthode, ``enableLayout()``, permet de ré-activer le rendu des layouts pour l'action en
  cours.

- **Utiliser un autre script de layout**: Si vous avez plusieurs scripts de layout pour votre application, vous
  pouvez selectionner lequel rendre grâce à la méthode ``setLayout()``. Précisez alors le nom du script de
  layout, sans l'extension.

  .. code-block:: php
     :linenos:

     // Utiliser le script de layout "alternate.phtml":
     $layout->setLayout('alternate');

  Le script de layout doit se trouver dans le ``$layoutPath`` précisé via la configuration (en bootstrap
  générallement). ``Zend_Layout`` utilisera le nouveau script à rendre.


