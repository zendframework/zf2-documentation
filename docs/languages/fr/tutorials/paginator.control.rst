.. EN-Revision: none
.. _learning.paginator.control:

Contrôles de la pagination et styles de défilement
==================================================

Rendre visuellement les éléments d'une page est un bon départ. Dans les sections précédentes, nous avons
aperçu la méthode ``setCurrentPageNumber()`` pour déterminer la page active. Le point suivant est la navigation
au travers de ces pages. Le paginateur vous fournit des outils pour ça comme la possibilité de rendre un script
de vue partiel et le support des styles de défilement (ScrollingStyles).

La vue partiel est un bout de vue qui rend juste les contrôles de la pagination comme les boutons suivant et
précédent. Le design de la vue partielle est libre, il vous faudra simplement un objet Zend_View. Commencez donc
par créer un nouveau script de vue dans le dossier des scripts de vue. Vous pouvez l'appeler comme vous voulez,
nous l'appellerons "controls.phtml" de notre coté. Le manuel comporte des exemples de tels scripts, en voici un.

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
   <!-- First page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->first)); ?>">
       First
     </a> |
   <?php else: ?>
     <span class="disabled">First</span> |
   <?php endif; ?>

   <!-- Previous page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Previous
     </a> |
   <?php else: ?>
     <span class="disabled">< Previous</span> |
   <?php endif; ?>

   <!-- Next page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Next >
     </a> |
   <?php else: ?>
     <span class="disabled">Next ></span> |
   <?php endif; ?>

   <!-- Last page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->last)); ?>">
       Last
     </a>
   <?php else: ?>
     <span class="disabled">Last</span>
   <?php endif; ?>

   </div>
   <?php endif; ?>

Il faut maintenant indiquer à Zend_Paginator la vue partielle à utiliser. Ajoutez ceci à votre bootstrap:

.. code-block:: php
   :linenos:

   Zend_View_Helper_PaginationControl::setDefaultViewPartial('controls.phtml');

La dernière étape est la plus simple. Passez un objet Paginator à un script de vue (PAS 'controls.phtml'!).
Ensuite, demandez simplement l'affichage de l'objet Paginator lui-même. Ceci va faire intervenir l'aide de vue
PaginationControl. Dans l'exemple qui suit, l'objet Paginator a été affecté comme variable de vue 'paginator'.
Ne vous inquiétez pas si vous ne comprenez pas totalement le fonctionnement, les sections suivantes le
détaillent.

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

Pour décider quels numéros de page afficher, le paginateur utilise des styles de défilement. Le style par
défaut est "Sliding", qui ressemble à la présentation des résultats de Yahoo! Un style ressemblant à Google
est "Elastic". Le style par défaut se règle au moyen de la méthode statique ``setDefaultScrollingStyle()``, ou
lors du rendu du paginateur dans le script de vue mais ceci nécessite un appel manuel à l'aide de vue.

.. code-block:: php
   :linenos:

   // $this->paginator est un objet Paginator
   <?php echo $this->paginationControl($this->paginator, 'Elastic', 'controls.phtml'); ?>

Pour une liste de tous les styles de défilement, consultez le manuel.


