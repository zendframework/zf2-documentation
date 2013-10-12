.. EN-Revision: none
.. _learning.paginator.together:

Assembler le tout
=================

Nous avons vu comment créer un objet Paginator, comment le rendre sur la page et aussi comment rendre les
éléments de navigation au travers des pages. Dans cette section nous allons voir comment intégrer Paginator dans
MVC.

Dans les exemples qui suivent, nous allons ignorer une bonne pratique qu'est d'utiliser une couche de services
(Service Layer) ceci dans le but de garder nos exemples concis et simples à comprendre. Lorsque vous manipulerez
bien les couches de services, vous devriez pouvoir intégrer Paginator simplement et efficacement.

Partons du contrôleur. L'application d'exemple est simple, et nous allons tout loger dans IndexController et
IndexAction. Encore une fois ce choix est fait pour l'exemple, vous ne devriez pas utiliser les contrôleurs de
cette façon.

.. code-block:: php
   :linenos:

   class IndexController extends Zend\Controller\Action
   {
       public function indexAction()
       {
           // Configuration du script de navigation. Voyez le tutoriel sur le script
           // des éléments de contrôle de la pagination pour plus d'informations
           Zend\View\Helper\PaginationControl::setDefaultViewPartial('controls.phtml');

           // Cherchons une connection à une base depuis le registre
           $db = Zend\Registry\Registry::get('db');

           // Créons un objet select qui récupère des billets et les range par date de création descendante
           $select = $db->select()->from('posts')->order('date_created DESC');

           // Créons un paginateur pour cette requête
           $paginator = Zend\Paginator\Paginator::factory($select);

           // Nous lisons le numéro de page depuis la requête. Si le paramètre n'est pas précisé
           // la valeur 1 sera utilisée par défaut
           $paginator->setCurrentPageNumber($this->_getParam('page', 1));

           // Assignons enfin l'objet Paginator à notre vue
           $this->view->paginator = $paginator;
       }
   }

Le script qui suit est index.phtml, le script de vue pour IndexController/indexAction par défaut. Gardons celui-ci
simple : il utilisera le type de défilement par défaut.

.. code-block:: php
   :linenos:

   <ul>
   <?php
   // Affiche le titre de chaque billet pour la page en cours
   foreach ($this->paginator as $item) {
       echo '<li>' . $item["title"] . '</li>';
   }
   ?>
   </ul>
   <?php echo $this->paginator; ?>

Naviguez maintenant dans votre projet pour voir Paginator en action. Nous n''avons vu ici qu'une partie de
l'utilisation et le manuel de référence vous en apprendra plus sur les possibilités de Zend_Paginator.


