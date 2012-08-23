.. EN-Revision: none
.. _zend.paginator.usage:

Utilisation
===========

.. _zend.paginator.usage.paginating:

Paginer des collections de données
----------------------------------

Afin de pouvoir paginer des éléments, ``Zend_Paginator`` doit posséder une manière générique d'accéder aux
sources de données. De ce fait, tous les accès aux données se font via des adaptateurs de sources. Plusieurs
adaptateurs existent par défaut :

.. _zend.paginator.usage.paginating.adapters:

.. table:: Adaptateurs pour Zend_Paginator

   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Adaptateur   |Description                                                                                                                                                                                                       |
   +=============+==================================================================================================================================================================================================================+
   |Array        |Utilise un tableau PHP                                                                                                                                                                                            |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbSelect     |Utilise une instance de Zend_Db_Select qui retourne un tableau                                                                                                                                                    |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbTableSelect|Utilise une instance Zend_Db_Table_Select, qui retournera une instance de Zend_Db_Table_Rowset_Abstract. Ceci fournit aussi des informations supplémentaires sur le jeu de résultats, tel que les noms de colonne.|
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Iterator     |Utilise une instance implémentant Iterator                                                                                                                                                                        |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |NULL         |N'utilise pas Zend_Paginator pour la pagination. En revanche, les options et capacités de contrôle de la pagination restent disponibles.                                                                          |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Plutôt que de sélectionner chaque ligne correspondant à une requête fournie, les adaptateurs *DbSelect* et
   *DbTableSelect* récupèrent seulement la quantité de données nécessaire pour l'affichage de la page
   courante.

   A cause de ceci, une seconde requête est générée dynamiquement pour déterminer le nombre total de lignes
   correspondantes. Cependant, il est possible de directement fournir un nombre ou un requête de dénombrement
   vous-même. Regardez la méthode ``setRowCount()`` de l'adaptateur *DbSelect* pour de plus amples informations.

Pour créer une instance de ``Zend_Paginator``, vous devez spécifier un adaptateur à son constructeur:



   .. code-block:: php
      :linenos:

      $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_Array($array));



Pour une meilleure intégration, vous pouvez utiliser la fabrique ``factory()``:



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($array);



.. note::

   Pour l'adaptateur ``NULL``, il faut spécifier un chiffre à son constructeur en lieu et place de la collection
   de données.

Bien que l'instance soit techniquement utilisable dans l'état, dans votre contrôleur d'action vous devrez
informer le paginateur du numéro de page demandé par l'utilisateur. Ceci lui permet d'avancer à travers les
données paginées.



   .. code-block:: php
      :linenos:

      $paginator->setCurrentPageNumber($page);



La manière la plus simple de suivre et scruter cette valeur est via l'URL. Nous recommandons l'utilisation d'un
routeur compatible avec ``Zend_Controller_Router_Interface``, mais ceci n'est pas nécessaire.

Voici une route que vous pourriez définir dans un fichier de configuration *INI*:



   .. code-block:: php
      :linenos:

      routes.example.route = articles/:articleName/:page
      routes.example.defaults.controller = articles
      routes.example.defaults.action = view
      routes.example.defaults.page = 1
      routes.example.reqs.articleName = \w+
      routes.example.reqs.page = \d+



Avec une telle route (et en utilisant les composants *MVC* de Zend Framework), vous pourriez spécifier le numéro
de la page de cette manière :



   .. code-block:: php
      :linenos:

      $paginator->setCurrentPageNumber($this->_getParam('page'));



Il y a d'autres options disponibles, voyez :ref:`la configuration <zend.paginator.configuration>` pour plus de
détails.

Enfin, il faut passer l'instance du paginateur à votre vue. Si vous utilisez ``Zend_View`` avec l'aide d'action
*ViewRenderer*, ceci fonctionnera :



   .. code-block:: php
      :linenos:

      $this->view->paginator = $paginator;



.. _zend.paginator.usage.dbselect:

The DbSelect and DbTableSelect adapter
--------------------------------------

The usage of most adapters is pretty straight-forward. However, the database adapters require a more detailed
explanation regarding the retrieval and count of the data from the database.

To use the DbSelect and DbTableSelect adapters you don't have to retrieve the data upfront from the database. Both
adapters do the retrieval for you, aswell as the counting of the total pages. If additional work has to be done on
the database results the adapter ``getItems()`` method has to be extended in your application.

Additionally these adapters do **not** fetch all records from the database Instead, the adapters manipulates the
original query to produce the corresponding COUNT query. Paginator then executes that COUNT query to get the number
of rows. This does require an extra round-trip to the database, but this is many times faster than fetching an
entire result set and using count(). Especially with large collections of data.

The database adapters will try and build the most efficient query that will execute on pretty much all modern
databases. However, depending on your database or even your own schema setup, there might be more efficient ways to
get a rowcount. For this scenario the database adapters allow you to set a custom COUNT query. For example, if you
keep track of the count of blog posts in a separate table, you could achieve a faster count query with the
following setup:

.. code-block:: php
   :linenos:

   $adapter = new Zend_Paginator_Adapter_DbSelect($db->select()->from('posts'));
   $adapter->setRowCount(
       $db->select()->from('item_counts', array(Zend_Paginator_Adapter_DbSelect::ROW_COUNT_COLUMN => 'post_count'))
   )

   $paginator = new Zend_Paginator($adapter);

This approach will probably not give you a huge performance gain on small collections and/or simple select queries.
However, with complex queries and large collections, a similar approach could give you a significant performance
boost.

.. _zend.paginator.rendering:

Rendre des pages avec les scripts de vue
----------------------------------------

Le script de vue va être utilisé pour rendre les éléments de la page (bien sûr si ``Zend_Paginator`` est
utilisé à cet effet), et pour afficher les éléments relatifs au contrôle de la pagination.

Comme ``Zend_Paginator`` implémente l'interface SPL `IteratorAggregate`_, boucler sur les éléments et les
afficher est très simple.



   .. code-block:: php
      :linenos:

      <html>
      <body>
      <h1>Example</h1>
      <?php if (count($this->paginator)): ?>
      <ul>
      <?php foreach ($this->paginator as $item): ?>
        <li><?php echo $item; ?></li>
      <?php endforeach; ?>
      </ul>
      <?php endif; ?>

      <?php echo $this->paginationControl($this->paginator,
                                          'Sliding',
                                          'my_pagination_control.phtml'); ?>
      </body>
      </html>



Notez l'appel à l'aide de vue en fin de script. *PaginationControl* accepte jusqu'à quatre paramètres :
l'instance du paginateur, un type de défilement (optionnel), un partial de vue (optionnel) et un tableau de
paramètres additionnels.

Les second et troisième paramètres sont très importants. Alors que le partial est utiliser pour déterminer
comment **présenter** les données, le type de défilement définira la manière dont ils se **comportent**.
Disons que le partial ressemble à un contrôle de recherche, comme ce qui suit :

.. image:: ../images/zend.paginator.usage.rendering.control.png
   :align: center

Que se passe-t-il lorsque l'utilisateur clique sur le lien "next" quelques fois? Plusieurs choses peuvent arriver.
Le numéro de la page courante pourrait rester au milieu (comme c'est le cas sur Yahoo!), ou il pourrait aussi bien
avancer à la fin de la fourchette des pages et apparaître encore à gauche lorsque l'utilisateur clique alors sur
"next". Le nombre de pages pourrait alors s'étendre ou se comprimer alors que l'utilisateur avance ("scroll") à
travers (comme chez Google).

Il existe 4 types de défilement intégrés dans Zend Framework :

.. _zend.paginator.usage.rendering.scrolling-styles:

.. table:: Types de défilement pour Zend_Paginator

   +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Type de défilement|Description                                                                                                                                                                     |
   +==================+================================================================================================================================================================================+
   |All               |Retourne toutes les pages. Très pratique lorsqu'il y a peu de pages totales.                                                                                                    |
   +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Elastic           |Un défilement de type Google qui s'étend et se contracte au fur et à mesure que l'utilisateur avance dans les pages de résultats.                                               |
   +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Jumping           |Alors que l'utilisateur défile, le nombre de pages avance à la fin d'une échelle donnée, puis recommence au début de l'échelle suivante.                                        |
   +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Sliding           |Un défilement de type Yahoo! qui positionne la page en cours au centre d'une échelle de pages, le plus justement et près possible. Ce type de défilement est le type par défaut.|
   +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Le quatrième et dernier paramètre est réservé pour un tableau associatif optionnel de variables
supplémentaires que vous voulez rendre disponible dans vos partiels de vues (disponible via ``$this``). Par
exemple, ces valeurs permettent d'inclure des paramètres d'URL supplémentaires pour les liens de pagination.

En spécifiant le partial de vue par défaut, le défilement et l'instance de vue, vous pouvez alors vous
affranchir totalement des appels à *PaginationControl*:



   .. code-block:: php
      :linenos:

      Zend_Paginator::setDefaultScrollingStyle('Sliding');
      Zend_View_Helper_PaginationControl::setDefaultViewPartial(
          'my_pagination_control.phtml'
      );
      $paginator->setView($view);



Utilisez dès lors un simple *echo* dans le script de vue pour le rendu du paginateur complet:



   .. code-block:: php
      :linenos:

      <?php echo $this->paginator; ?>



.. note::

   Bien sûr, il est possible d'utiliser Zend_paginator avec d'autres moteurs de templates. Par exemple, avec
   Smarty vous pourriez faire ceci :



      .. code-block:: php
         :linenos:

         $smarty->assign('pages', $paginator->getPages());



   Vous pouvez ainsi accéder aux valeurs du paginateur grâce à un template comme ceci :



      .. code-block:: php
         :linenos:

         {$pages->pageCount}



.. _zend.paginator.usage.rendering.example-controls:

Exemples de contrôles de pagination
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Voici quelques exemples qui vous aideront à démarrer avec le paginateur:

Pagination de recherche :

   .. code-block:: php
      :linenos:

      <!--
      Voir http://developer.yahoo.com/ypatterns/pattern.php?pattern=searchpagination
      -->

      <?php if ($this->pageCount): ?>
      <div class="paginationControl">
      <!-- Previous page link -->
      <?php if (isset($this->previous)): ?>
        <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
          < Previous
        </a> |
      <?php else: ?>
        <span class="disabled">< Previous</span> |
      <?php endif; ?>

      <!-- Numbered page links -->
      <?php foreach ($this->pagesInRange as $page): ?>
        <?php if ($page != $this->current): ?>
          <a href="<?php echo $this->url(array('page' => $page)); ?>">
              <?php echo $page; ?>
          </a> |
        <?php else: ?>
          <?php echo $page; ?> |
        <?php endif; ?>
      <?php endforeach; ?>

      <!-- Next page link -->
      <?php if (isset($this->next)): ?>
        <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
          Next >
        </a>
      <?php else: ?>
        <span class="disabled">Next ></span>
      <?php endif; ?>
      </div>
      <?php endif; ?>



Pagination d'objets :

   .. code-block:: php
      :linenos:

      <!--
      Voir http://developer.yahoo.com/ypatterns/pattern.php?pattern=itempagination
      -->

      <?php if ($this->pageCount): ?>
      <div class="paginationControl">
      <?php echo $this->firstItemNumber; ?> - <?php echo $this->lastItemNumber; ?>
      of <?php echo $this->totalItemCount; ?>

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
        <a href="<?php echo $this->url(array('page' => $this->last)); ?>">Last</a>
      <?php else: ?>
        <span class="disabled">Last</span>
      <?php endif; ?>

      </div>
      <?php endif; ?>



Pagination Dropdown :

   .. code-block:: php
      :linenos:

      <?php if ($this->pageCount): ?>
      <select id="paginationControl" size="1">
      <?php foreach ($this->pagesInRange as $page): ?>
        <?php $selected = ($page == $this->current) ? ' selected="selected"' : ''; ?>
        <option value="<?php echo $this->url(array('page' => $page)); ?>"
                <?php echo $selected ?>>
          <?php echo $page; ?>
        </option>
      <?php endforeach; ?>
      </select>
      <?php endif; ?>

      <script type="text/javascript"
          src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js">
      </script>
      <script type="text/javascript">
      $('paginationControl').observe('change', function() {
          window.location = this.options[this.selectedIndex].value;
      })
      </script>



.. _zend.paginator.usage.rendering.properties:

Liste des propriétés
^^^^^^^^^^^^^^^^^^^^

Les options suivantes sont disponibles pour contrôler la pagination dans les partials de vue :

.. _zend.paginator.usage.rendering.properties.table:

.. table:: Propriétés disponibles aux partials de vue

   +----------------+---------------+----------------------------------------------------------------+
   |Propriété       |Type           |Description                                                     |
   +================+===============+================================================================+
   |first           |entier         |Numéro de la première page                                      |
   +----------------+---------------+----------------------------------------------------------------+
   |firstItemNumber |entier         |Numéro absolu du premier objet(item) dans cette page            |
   +----------------+---------------+----------------------------------------------------------------+
   |firstPageInRange|entier         |Première page dans l'échelle retournée par le type de défilement|
   +----------------+---------------+----------------------------------------------------------------+
   |current         |entier         |Numéro de la page en cours                                      |
   +----------------+---------------+----------------------------------------------------------------+
   |currentItemCount|entier         |Nombre d'objets sur cette page                                  |
   +----------------+---------------+----------------------------------------------------------------+
   |itemCountPerPage|integer        |Nombre d'objets maximum à afficher par page                     |
   +----------------+---------------+----------------------------------------------------------------+
   |last            |entier         |Numéro de la dernière page                                      |
   +----------------+---------------+----------------------------------------------------------------+
   |lastItemNumber  |entier         |Numéro absolu du dernier objet sur cette page                   |
   +----------------+---------------+----------------------------------------------------------------+
   |lastPageInRange |entier         |Dernière page dans l'échelle retournée par le type de défilement|
   +----------------+---------------+----------------------------------------------------------------+
   |next            |entier         |Numéro de la page suivante                                      |
   +----------------+---------------+----------------------------------------------------------------+
   |pageCount       |entier         |Nombre de pages                                                 |
   +----------------+---------------+----------------------------------------------------------------+
   |pagesInRange    |tableau (array)|Tableau des pages retournées par le type de défilement          |
   +----------------+---------------+----------------------------------------------------------------+
   |previous        |entier         |Numéro de la page précédente                                    |
   +----------------+---------------+----------------------------------------------------------------+
   |totalItemCount  |entier         |Nombre total d'objets                                           |
   +----------------+---------------+----------------------------------------------------------------+



.. _`IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
