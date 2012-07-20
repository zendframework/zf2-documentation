.. _zend.view.helpers.initial.action:

L'aide de vue Action
====================

L'aide de vue *Action* permet à des scripts de vue de distribuer une action donnée d'un contrôleur ; le
résultat de l'objet de réponse suivant la distribution est alors retourné. Ceux-ci peuvent être employés quand
une action particulière peut produire du contenu réutilisable ou du contenu de type "gadget".

Les actions qui ont comme conséquence un ``_forward()`` ou une redirection sont considérées invalide, et
retourneront une chaîne vide.

L'API pour l'aide de vue *Action* respecte le même schéma que la plupart les composants *MVC* qui appellent des
actions de contrôleur : *action($action, $controller, $module = null, array $params = array())*. ``$action`` et
``$controller`` sont exigés ; si aucun module n'est spécifié, le module par défaut est implicite.

.. _zend.view.helpers.initial.action.usage:

.. rubric:: Utilisation de base de l'aide de vue Action

Par exemple, vous pouvez avoir un *CommentController* avec une méthode ``listAction()`` que vous souhaitez appeler
afin de récupérer une liste de commentaires pour la requête courante :

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?php echo $this->action('list', 'comment', null, array('count' => 10)); ?>
       </div>
   </div>


