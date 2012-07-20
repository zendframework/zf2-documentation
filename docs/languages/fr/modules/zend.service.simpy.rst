.. _zend.service.simpy:

Zend_Service_Simpy
==================

.. _zend.service.simpy.introduction:

Introduction
------------

``Zend_Service_Simpy`` permet l'interaction avec les services Web du réseau social de partage de 'marque-pages'
(de 'favoris', de 'liens') Simpy.

Pour utiliser ``Zend_Service_Simpy``, vous devez posséder un compte. Pour ceci, voyez `le site Web de Simpy`_.
Pour plus d'informations sur l'API REST de Simpy, voyez `sa documentation`_.

Les sections qui suivent vont vous indiquer les éléments sur lesquels vous pouvez agir en utilisant l'API de
Simpy, via ``Zend_Service_Simpy``.

   - Liens: Créer, requêter, mettre à jour, supprimer

   - Mots-clés: requêter, supprimer, renommer, fusionner, éclater

   - Notes: Créer, requêter, mettre à jour, supprimer

   - Listes: récupérer, récupérer tout



.. _zend.service.simpy.links:

Liens
-----

Lors d'interactions avec les liens, ceux-ci sont retournées dans l'ordre descendant par date d'ajout. Vous pouvez
les chercher par titre, auteur, mots-clés, notes ou même via le contenu de leur page. Vous pouvez chercher selon
tous ces critères avec des phrases, des booléens ou des jokers. Voyez la `syntaxe de recherche`_ et `les champs
de recherche`_ depuis la FAQ de Simpy, pour plus d'informations.

.. _zend.service.simpy.links.querying:

.. rubric:: Requêter des liens

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Recherche les 10 liens les plus récents */
   $linkQuery = new Zend_Service_Simpy_LinkQuery();
   $linkQuery->setLimit(10);

   /* Récupère et affiche les liens */
   $linkSet = $simpy->getLinks($linkQuery);
   foreach ($linkSet as $link) {
       echo '<a href="';
       echo $link->getUrl();
       echo '">';
       echo $link->getTitle();
       echo '</a><br />';
   }

   /* Recherche les 5 derniers liens ajoutés,
   contenant 'PHP' dans leur titre */
   $linkQuery->setQueryString('title:PHP');
   $linkQuery->setLimit(5);

   /* Cherche tous les liens avec le mot 'French' dans le titre
   et le mot-clé 'language' */
   $linkQuery->setQueryString('+title:French +tags:language');

   /* Cherche tous les liens avec le mot 'French' dans le titre
   et pas le mot-clé 'travel' */
   $linkQuery->setQueryString('+title:French -tags:travel');

   /* Cherche tous les liens ajoutés le 9/12/06 */
   $linkQuery->setDate('2006-12-09');

   /* Cherche tous les liens ajoutés après le 9/12/06 (exclu)*/
   $linkQuery->setAfterDate('2006-12-09');

   /* Cherche tous les liens ajoutés avant le 9/12/06 (exclu)*/
   $linkQuery->setBeforeDate('2006-12-09');

   /* Cherche tous les liens ajoutés entre le 1/12/06 et le 9/12/06 (exclues) */
   $linkQuery->setBeforeDate('2006-12-01');
   $linkQuery->setAfterDate('2006-12-09');

Les liens sont représentés de manière unique par leur *URL*. Ainsi tenter de sauvegarder un lien ayant le même
*URL* qu'un lien existant va l'écraser.

.. _zend.service.simpy.links.modifying:

.. rubric:: Modifier des liens

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Sauvegarde un lien */
   $simpy->saveLink(
       'Zend Framework' // Title
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // Access Type
       'zend, framework, php' // Tags
       'Zend Framework home page' // Alternative title
       'This site rocks!' // Note
   );

   /* Ecrase le lien avec les nouvelles données */
   $simpy->saveLink(
       'Zend Framework'
       'http://framework.zend.com',
       Zend_Service_Simpy_Link::ACCESSTYPE_PRIVATE, // Access Type has changed
       'php, zend, framework' // Tags have changed order
       'Zend Framework' // Alternative title has changed
       'This site REALLY rocks!' // Note has changed
   );

   /* Effacement du lien */
   $simpy->deleteLink('http://framework.zend.com');

   /* Effacement de plusieurs liens */
   $linkSet = $this->_simpy->getLinks();
   foreach ($linkSet as $link) {
       $this->_simpy->deleteLink($link->getUrl());
   }

.. _zend.service.simpy.tags:

Mots-clés
---------

Les mots-clés sont récupérés dans l'ordre descendant, par le nombre de liens utilisant le mot-clé.

.. _zend.service.simpy.tags.working:

.. rubric:: Travailler avec les mots-clés

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Sauvegarde d'un lien avec des mots-clés */
   $simpy->saveLink(
       'Zend Framework' // Title
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // Access Type
       'zend, framework, php' // Tags
   );

   /* Récupère la liste de tous les mots-clés utilisés par les liens
   et les notes */
   $tagSet = $simpy->getTags();

   /* Affiche chaque mot-clé avec le nombre de liens les utilisant */
   foreach ($tagSet as $tag) {
       echo $tag->getTag();
       echo ' - ';
       echo $tag->getCount();
       echo '<br />';
   }

   /* Efface le mot-clé 'zend' de tous les liens l'utilisant */
   $simpy->removeTag('zend');

   /* Renome le mot-clé 'framework' vers 'frameworks' */
   $simpy->renameTag('framework', 'frameworks');

   /* Eclate le mot-clé 'frameworks' en 'framework' et 'development',
   ce qui va effacer le mot-clé 'frameworks' et ajouter les mots-clés
   'framework' et 'development' pour tous les liens l'utilisant
   anciennement */
   $simpy->splitTag('frameworks', 'framework', 'development');

   /* Cette opération de fusion est l'opposé de l'opération ci-dessus */
   $simpy->mergeTags('framework', 'development', 'frameworks');

.. _zend.service.simpy.notes:

Notes
-----

Les notes peuvent être sauvées, récupérées, effacées. Elles possèdent un identifiant numérique unique.

.. _zend.service.simpy.notes.working:

.. rubric:: Travailler avec les notes

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Sauvegarde une note */
   $simpy->saveNote(
       'Test Note', // Title
       'test,note', // Tags
       'This is a test note.' // Description
   );

   /* Ecrase une note existante */
   $simpy->saveNote(
       'Updated Test Note', // Title
       'test,note,updated', // Tags
       'This is an updated test note.', // Description
       $note->getId() // Unique identifier
   );

   /* Recherche les 10 notes les plus récentes */
   $noteSet = $simpy->getNotes(null, 10);

   /* Affiche ces notes */
   foreach ($noteSet as $note) {
       echo '<p>';
       echo $note->getTitle();
       echo '<br />';
       echo $note->getDescription();
       echo '<br >';
       echo $note->getTags();
       echo '</p>';
   }

   /* Cherche les notes avec le mot 'PHP' dans leur titre */
   $noteSet = $simpy->getNotes('title:PHP');

   /* Cherche les notes avec le mot 'PHP' dans leur titre et pas le mot
   'framework' dans leur description */
   $noteSet = $simpy->getNotes('+title:PHP -description:framework');

   /* Efface une note */
   $simpy->deleteNote($note->getId());

.. _zend.service.simpy.watchlists:

Listes de surveillance
----------------------

Les listes de surveillance ne peuvent qu'être requêtées via l'API Simpy. Vous devez donc vous assurer qu'elles
sont correctement créées, depuis le site Web de Simpy, il n'est pas possible de les créer ou les supprimer
depuis l'API.

.. _zend.service.simpy.watchlists.retrieving:

.. rubric:: Récupérer des listes de surveillance

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Récupérer une liste de listes de surveillance */
   $watchlistSet = $simpy->getWatchlists();

   /* Affiche les données de chaque liste */
   foreach ($watchlistSet as $watchlist) {
       echo $watchlist->getId();
       echo '<br />';
       echo $watchlist->getName();
       echo '<br />';
       echo $watchlist->getDescription();
       echo '<br />';
       echo $watchlist->getAddDate();
       echo '<br />';
       echo $watchlist->getNewLinks();
       echo '<br />';

       foreach ($watchlist->getUsers() as $user) {
           echo $user;
           echo '<br />';
       }

       foreach ($watchlist->getFilters() as $filter) {
           echo $filter->getName();
           echo '<br />';
           echo $filter->getQuery();
           echo '<br />';
       }
   }

   /* Récupère une liste de surveillance par son identifiant */
   $watchlist = $simpy->getWatchlist($watchlist->getId());
   $watchlist = $simpy->getWatchlist(1);



.. _`le site Web de Simpy`: http://simpy.com
.. _`sa documentation`: http://www.simpy.com/doc/api/rest
.. _`syntaxe de recherche`: http://www.simpy.com/faq#searchSyntax
.. _`les champs de recherche`: http://www.simpy.com/faq#searchFieldsLinks
