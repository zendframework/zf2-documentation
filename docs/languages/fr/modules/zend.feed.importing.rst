.. EN-Revision: none
.. _zend.feed.importing:

Importer des flux
=================

``Zend_Feed`` permet aux développeurs d'obtenir très facilement des flux. Si vous connaissez l'URI d'un flux,
utilisez simplement la méthode ``Zend\Feed\Feed::import()``\  :

.. code-block:: php
   :linenos:

   $flux = Zend\Feed\Feed::import('http://flux.example.com/nomDuFlux');

Vous pouvez aussi utiliser ``Zend_Feed`` pour aller chercher le contenu d'un flux à partir d'un fichier ou d'une
chaîne *PHP*\  :

.. code-block:: php
   :linenos:

   // on importe un flux à partir d'un fichier texte
   $fluxAPartirDeFichierTexte = Zend\Feed\Feed::importFile('flux.xml');

   // on importe un flux à partir d'une variable PHP de type chaîne
   $fluxAPartirDePHP = Zend\Feed\Feed::importString($chaineFlux);

Dans chacun des exemples ci-dessus, une instance d'une classe étendant ``Zend\Feed\Abstract`` est renvoyée en cas
de succès, selon le type du flux. Si un flux *RSS* a été obtenu au moyen de l'une des méthodes d'importation
décrites ci-dessus, alors un objet ``Zend\Feed\Rss`` sera renvoyé. Par contre, si un flux Atom a été importé,
alors un objet ``Zend\Feed\Atom`` est renvoyé. Les méthodes d'importation déclencheront aussi une exception
``Zend\Feed\Exception`` en cas d'échec, par exemple si le flux est illisible ou malformé.

.. _zend.feed.importing.custom:

Flux personnalisés
------------------

``Zend_Feed`` permet aux développeurs de créer du flux personnalisé très facilement. Vous devez juste créer un
tableau et l'importer avec Zend_Feed. Ce tableau peut être importé avec ``Zend\Feed\Feed::importArray()`` ou avec
``Zend\Feed\Feed::importBuilder()``. Dans ce dernier cas, le tableau sera calculé instantanément par une source de
données personnalisée implémentant ``Zend\Feed_Builder\Interface``.

.. _zend.feed.importing.custom.importarray:

Importer un tableau personnalisé
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // on importe un flux atom à partir d'un tableau
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array);

   // la ligne suivante est équivalente à celle ci-dessus ;
   // par défaut l'instance Zend\Feed\Atom est retournée
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array, 'atom');

   // on importe un flux rss à partir d'un tableau
   $rssFeedFromArray = Zend\Feed\Feed::importArray($array, 'rss');

Le format du tableau doit être conforme à cette structure :

.. code-block:: php
   :linenos:

   array(
       // obligatoire
       'title'       => 'titre du flux',
       'link'        => 'url canonique du flux',

       // optionel
       'lastUpdate'  => 'date de la mise à jour au format timestamp',
       'published'   => 'date de la publication au format timestamp',

       // obligatoire
       'charset'     => 'charset des données textuelles',

       // optionnel
       'description' => 'description courte du flux',
       'author'      => 'auteur du flux',
       'email'       => 'email de l'auteur du flux',

        // optionnel, ignoré si le flux est de type atom
       'webmaster'   => 'email de la personne responsable'
                      . 'en cas de problème technique'

       // optionnel
       'copyright'   => 'informations de copyright',
       'image'       => 'url de l'image',
       'generator'   => 'générateur du flux',
       'language'    => 'langue dans la quelle le flux est écrit',

       // optionnel, ignoré si le flux est de type atom
       'ttl'         => 'combien de temps en minutes un flux peut être'
                      . 'mis en cache avant rafraîchissement',
       'rating'      => 'l'évaluation PICS du canal',

       // optionnel, ignoré si le flux est de type atom
       // un nuage pour être averti des mises à jour
       'cloud'       => array(
           // obligatoire
           'domain'            => 'domaine du nuage, ex. rpc.sys.com',

           // optionnel, par défaut port 80
           'port'              => 'port de connexion',

           // obligatoire
           'path'              => 'chemin du nuage, ex. /RPC2',
           'registerProcedure' => 'procédure à appeler, '
                                . 'ex. myCloud.rssPleaseNotify',
           'protocol'          => 'protocole à utiliser , ex. soap ou xml-rpc',
       ),

       // optionnel, ignoré si le flux est de type atom
       // une boîte de saisie qui peut être montrée avec le flux
       'textInput'   => array(
           // obligatoire
           'title'       => 'l'intitulé du bouton de validation '
                          . 'de la boîte de saisie',
           'description' => 'explication de la boîte de saisie',
           'name'        => 'le nom de l'objet texte',
           'link'        => 'l'URL du CGI qui va analyser la requête',
       )

       // optionnel, ignoré si le flux est de type atom
       // Information disant aux agrégateurs quelles heures ils peuvent ignorer
       'skipHours'   => array(
           // jusqu'à 24 lignes dont les valeurs
           // sont des nombres compris entre 0 et 23
           // ex. 13 (1pm)
           'heures dans le format 24H',
       )

       // optionnel, ignoré si le flux est de type atom
       // Information disant aux agrégateurs quels jours ils peuvent ignorer
       'skipDays '   => array(
           // jusqu'à 7 lignes dont les valeurs peuvent être
           // Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday
           // ex. Monday
           'jour'
       )

       // optionnel, ignoré si le flux est de type atom
       // Données d'extension iTunes
       'itunes'      => array(
           // optionel, par défaut l'auteur principal
           'author'       => 'nom de l'artiste',

           // optionel, default l'auteur principal
           'owner'        => array(
               'name'  => 'nom du propriétaire' ,
               'email' => 'email du propriétaire',
           )

           // optionnel, default to the main image value
           'image'        => 'image de l'album/podcast',

           // optionnel, default to the main description value
           'subtitle'     => 'description courte',

           // optionnel, default to the main description value
           'summary'      => 'description longue',

           // optionnel
           'block'        => 'empêcher l'apparition d'un épisode (yes|no)',

           // obligatoire, catégorie et information de recherche
           // dans iTunes Music Store
           'category'     => array(
               // jusqu'à 3 lignes
               array(
                   // obligatoire
                   'main' => 'catégorie principale',
                   // optionnel
                   'sub'  => 'sous-catégorie'
               ),
           )

           // optionnel
           'explicit'     => 'graphique d'avertissement parental (yes|no|clean)',
           'keywords'     => 'une liste d'au maximum 12 mot clés'
                           . 'séparés par des virgules',
           'new-feed-url' => 'utiliser pour informer iTunes'
                           . 'd'un nouvel URL de flux',
       )

       'entries'     => array(
           array(
               // obligatoire
               'title'        => 'titre de l'item',
               'link'         => 'url de cet item',

               // obligatoire, seulement du text, pas d'html
               'description'  => 'version raccourci du texte',

               // optionnel
               'guid'         => 'id de l'article, si aucun alors'
                               . 'la valeur link est utilisée',

                // optionnel, peut contenir html
               'content'      => 'version complète de l'information',

               // optionnel
               'lastUpdate'   => 'date de publication au format timestamp',
               'comments'     => 'page de commentaires de l'item',
               'commentRss'   => 'l'url du flux des commentaires associés',

               // optionnel, source originale de l'item
               'source'       => array(
                   // obligatoire
                   'title' => 'titre de la source originale',
                   'url' => 'url de la source originale'
               )

               // optionnel, liste des catégories attachées
               'category'     => array(
                   array(
                       // obligatoire
                       'term' => 'intitulé de la première catégorie',

                       // optionnel
                       'scheme' => 'url qui décrit l'organisation de la catégorie'
                   ),
                   array(
                       //données de la seconde catégorie et ainsi de suite
                   )
               ),

               // optionnel, liste des pièces jointes à l'item
               'enclosure'    => array(
                   array(
                       // obligatoire
                       'url' => 'url de la pièce jointe',

                       // optionnel
                       'type' => 'type mime de la pièce jointe',
                       'length' => 'length de la pièce jointe en octets'
                   ),
                   array(
                       //données de la seconde pièce jointe et ainsi de suite
                   )
               )
           ),

           array(
               //données du second item et ainsi de suite
           )
       )
   );

Références :

   - Spécification *RSS* 2.0 : `RSS 2.0`_

   - Spécification Atom : `RFC 4287`_

   - Spécification WFW : `Well Formed Web`_

   - Spécification iTunes : `iTunes Technical Specifications`_



.. _zend.feed.importing.custom.importbuilder:

Importer une source de données personnalisée
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez créer une instance Zeed_Feed à partir de n'importe quelle source de données implémentant
``Zend\Feed_Builder\Interface``. Vous devez juste implémenter les méthodes ``getHeader()`` et ``getEntries()``
pour pouvoir utiliser votre objet avec ``Zend\Feed\Feed::importBuilder()``. Par une simple référence d'implémentation
vous pouvez utiliser ``Zend\Feed\Builder``, qui prend un tableau dans son constructeur, réalise quelques
validations mineures, et peut être utilisé dans la méthode ``importBuilder()``. La méthode ``getHeader()`` doit
retourner une instance de ``Zend\Feed_Builder\Header``, et ``getEntries()`` doit retourner un tableau d'instances
``Zend\Feed_Builder\Entry``

.. note::

   ``Zend\Feed\Builder`` fournit une mise en oeuvre concrète afin de montrer l'utilisation. Les utilisateurs sont
   encouragés à faire leurs classes propres mettre en oeuvre ``Zend\Feed_Builder\Interface``.

Voici un exemple d'utilisation de ``Zend\Feed\Feed::importBuilder()``\  :

.. code-block:: php
   :linenos:

   // importe un flux atom à partir d'un constructeur personnalisé
   $atomFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array));

   // la ligne suivante est équivalente à celle ci-dessus ;
   // par défaut l'instance Zend\Feed\Atom est retournée
   $atomFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array), 'atom');

   // importe un flux rss à partir d'un constructeur personnalisé
   $rssFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

Décharger le contenu d'un flux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour décharger le contenu d'une instance ``Zend\Feed\Abstract``, vous pouvez utiliser les méthodes ``send()`` ou
*saveXml().*

.. code-block:: php
   :linenos:

   assert($feed instanceof Zend\Feed\Abstract);

   // décharge le flux dans l'affichage standard
   print $feed->saveXML();

   // envoie les en-têtes et décharge le flux
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technical Specifications`: http://www.apple.com/itunes/store/podcaststechspecs.html
