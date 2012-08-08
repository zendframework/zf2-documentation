.. EN-Revision: none
.. _zend.feed.modifying-feed:

Modifier la structure du flux ou des entrées
============================================

La syntaxe intuitive de ``Zend_Feed`` peut aussi bien servir à lire des flux ou des entrées qu'à les construire
et les modifier. Vous pouvez facilement transformer vos nouveaux objets (ou objets modifiés) en code *XML* bien
formé et enregistrer ensuite ce code dans un fichier ou le renvoyer au serveur.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Modifier l'entrée existante d'un flux

.. code-block:: php
   :linenos:

   $flux = new Zend_Feed_Atom('http://atom.exemple.com/flux/1');
   $entree = $flux->current();

   $entree->title = 'Ceci est un nouveau titre';
   $entree->author->email = 'mon_email@exemple.com';

   echo $entree->saveXML();

Ce code affichera une représentation *XML* complète (y compris le prologue *<?xml ...>*) de la nouvelle entrée,
avec les espaces de noms *XML* nécessaires.

Notez que le code ci-dessus fonctionnera même si l'entrée existante ne possédait pas de balise *author*. Vous
pouvez utiliser autant de fois que vous le souhaitez l'opérateur d'accès *->* dans une instruction
d'affectation ; si nécessaire, les niveaux intermédiaires seront créés pour vous automatiquement.

Si vous souhaitez utiliser dans votre entrée un espace de noms autre que *atom:*, *rss:* ou *osrss:*, vous devez
enregistrer cet espace de noms auprès de ``Zend_Feed`` à l'aide de la méthode
``Zend_Feed::registerNamespace()``. Lorsque vous modifiez un élément existant, il gardera toujours son espace de
noms d'origine. Lorsque vous ajoutez un élément, il utilisera l'espace de noms par défaut si vous ne spécifiez
pas explicitement un autre espace de noms.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Créer une entrée Atom dont les éléments appartiennent à un espace de noms personnalisé

.. code-block:: php
   :linenos:

   $entree = new Zend_Feed_Entry_Atom();
   // en Atom, id est toujours affecté par le serveur
   $entree->title = 'mon entrée perso';
   $entree->author->name = 'Auteur';
   $entree->author->email = 'moi@exemple.com';

   // maintenant on s'occupe de la partie personnalisée
   Zend_Feed::registerNamespace('monen',
                                'http://www.exemple.com/monen/1.0');

   $entree->{'monen:monelement_un'} = 'ma première valeur personnalisée';
   $entree->{'monen:conteneur_elt'}
          ->partie1 = 'première partie imbriquée personnalisée';
   $entree->{'monen:conteneur_elt'}
          ->partie2 = 'deuxième partie imbriquée personnalisée';

   echo $entree->saveXML();


