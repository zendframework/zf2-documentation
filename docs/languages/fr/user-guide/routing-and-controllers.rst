.. EN-Revision: none
.. _user-guide.routing-and-controllers:

#######################
Routing et contrôleurs
#######################

Nous allons mettre en place un système d'inventaire très simple pour afficher
notre collection d'albums. La page d'accueil listera notre collection et nous
permettra d'ajouter, modifier et effacer des albums. Pour cela, il nous faut 
les pages suivantes :

+---------------+------------------------------------------------------------+
| Page          | Description                                                |
+===============+============================================================+
| Accueil       | Cette page affichera la liste d'albums et contiendra des   |
|               | liens pour les modifier et les effacer. Elle contiendra    |
|               | aussi un bouton qui nous permettra d'ajouter de nouveaux   |
|               | albums.                                                    |
|               |                                                            |
+---------------+------------------------------------------------------------+
| Ajouter album | Cette page contiendra un formulaire pour ajouter un album. |
+---------------+------------------------------------------------------------+
| Modifier album| Cette page contiendra un formulaire pour modifier un album.|
+---------------+------------------------------------------------------------+
| Effacer album | Cette page nous permettra d'effacer un album avec demande  |
|               | de confirmation.                                           |
+---------------+------------------------------------------------------------+

Avant tout chose, il est important de comprendre comment les pages doivent être
organisées pour le framework. Chaque page de l'application est une *action* et
les actions sont regroupées au sein de *contrôleurs* dans les *modules*. Ainsi,
vous regrouperez généralement les actions au sein d'un contrôleur; par exemple,
un contrôleur qui gèrerait des actualités auraient des actions  comme ``nouvelles``,
``archivées`` etc.

Comme nous avons quatre pages pour nos albums, nous les regrouperons dans un seul 
contrôleur ``AlbumController`` dans notre module ``Album`` sous forme de 4 actions.
Ces 4 actions seront :

+---------------+---------------------+------------+
| Page          | Contrôleur          | Action     |
+===============+=====================+============+
| Accueil       | ``AlbumController`` | ``index``  |
+---------------+---------------------+------------+
| Ajouter album | ``AlbumController`` | ``add``    |
+---------------+---------------------+------------+
| Modifier album| ``AlbumController`` | ``edit``   |
+---------------+---------------------+------------+
| Effacer album | ``AlbumController`` | ``delete`` |
+---------------+---------------------+------------+

La correspondance entre une URL et une action particulière se fait à l'aide des
routes qui sont décrites dans le fichier ``module.config.php`` du module. Nous 
ajouterons une route pour nos 4 actions. Voici le fichier de configuration 
mis à jour avec le code qui est commenté.

.. code-block:: php

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),

        // Code à ajouter à votre fichier.
        'router' => array(
            'routes' => array(
                'album' => array(
                    'type'    => 'segment',
                    'options' => array(
                        'route'    => '/album[/:action][/:id]',
                        'constraints' => array(
                            'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                            'id'     => '[0-9]+',
                        ),
                        'defaults' => array(
                            'controller' => 'Album\Controller\Album',
                            'action'     => 'index',
                        ),
                    ),
                ),
            ),
        ),

        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

Le nom de la route est ‘album’ et possède un type de ‘segment’. Les segments
nous permettent de spécifier des espaces réservés dans l'URL qui seront mappés
aux paramètres nommés dans la route correspondante. Dans notre cas, la route est
**``/album[/:action][/:id]``**, qui vérifiera chaque url qui commence par ``/album``. 
Le segment suivant correspond au nom d'une action optionnelle, et le dernier segment
correspond à un id, optionnel lui aussi. Les crochets indiquent qu'un segment est 
optionnel. La section constraints permet de nous assurer que les caractères relevés 
dans un segment correspondent bien à ceux attendus, nous avons donc restreint les actions
pour qu'elles commencent par une lettre, les caractères suivants étant alphanumériques, 
le signe souligné '_', et le tiret. Les id sont ainsi limités aux seuls chiffres.

Cette route nous permet d'avoir les URL suivantes :

+---------------------+------------------------------+------------+
| URL                 | Page                         | Action     |
+=====================+==============================+============+
| ``/album``          | Accueil (listes des albums)  | ``index``  |
+---------------------+------------------------------+------------+
| ``/album/add``      | Ajouter un album             | ``add``    |
+---------------------+------------------------------+------------+
| ``/album/edit/2``   | Modifier l'album avec l'id 2 | ``edit``   |
+---------------------+------------------------------+------------+
| ``/album/delete/4`` | Effacer l'album avec l'id 4  | ``delete`` |
+---------------------+------------------------------+------------+

Créer le contrôleur
===================

Nous sommes maintenant prêts à mettre en place notre contrôleur. Dans zend framework 2,
le contrôleur est une classe que l'on nomme généralement ``{Nom du contrôleur}Controller``.
Notez que ``{Nom du contrôleur}`` doit commencer par une majuscule. Cette classe réside dans
un fichier nommé ``{Nom du contrôleur}Controller.php``, sous le dossier ``Controller`` du 
module. Dans notre cas, ce sera ``module/Album/src/Album/Controller``. Chaque action est une méthode
publique de la classe contrôleur nommée ``{nom de l'action}Action``. Dans notre cas, ``{nom de l'action}``
devrait commencer par une lettre minuscule.

Ceci n'est qu'une convention. Zend Framework 2 n'impose pas beaucoup de 
restrictions sur les contrôleurs, outre le fait qu'ils doivent implémenter
l'interface ``Zend\Stdlib\Dispatchable``. Le framework propose deux classes 
abstraites qui font le travail pour nous : ``Zend\Mvc\Controller\AbstractActionController``
et ``Zend\Mvc\Controller\AbstractRestfulController``. Nous utiliserons  
``AbstractActionController``, mais si vous avez l'intention d'écrire un service RESTful,
``AbstractRestfulController`` vous sera plus utile.

Allons-y et créons notre classe contrôleur :

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    namespace Album\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    
    class AlbumController extends AbstractActionController
    {
        public function indexAction()
        {
        }
    
        public function addAction()
        {
        }
    
        public function editAction()
        {
        }
    
        public function deleteAction()
        {
        }
    }

Notez que nous avons déjà informé le module de l'existence de notre contrôleur
dans la section ‘controllers’ de ``config/module.config.php``.

Nous avons désormais nos 4 actions que nous souhaitons utiliser. Elles ne 
fonctionneront que lorsque nous aurons mis en place les vues. Les URL de chaque
action sont :

+--------------------------------------------+----------------------------------------------------+
| URL                                        | Methode appelée                                    |
+============================================+====================================================+
| http://zf2-tutorial.localhost/album        | ``Album\Controller\AlbumController::indexAction``  |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/add    | ``Album\Controller\AlbumController::addAction``    |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/edit   | ``Album\Controller\AlbumController::editAction``   |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/delete | ``Album\Controller\AlbumController::deleteAction`` |
+--------------------------------------------+----------------------------------------------------+

Nous avons désormais un routeur fonctionnel et les actions sont renseignées 
pour chaque page de notre application.

Il est temps de construire la vue et la couche modèle.

Initialiser les scripts de vue
------------------------------

Pour intégrer la vue dans notre application, tout ce que nous avons à faire est de 
créer les fichiers de la vue. Ces fichiers seront exécutés par le ``DefaultViewStrategy``
et recevront n'importe quelle variable ou modèles de vue retournées par les méthodes d'action 
du contrôleur. Créez maintenant ces 4 fichiers vides :

* ``module/Album/view/album/album/index.phtml``
* ``module/Album/view/album/album/add.phtml``
* ``module/Album/view/album/album/edit.phtml``
* ``module/Album/view/album/album/delete.phtml``

Nous pouvons désormais commencer à tout renseigner, à commencer par notre base de données 
et les modèles.
