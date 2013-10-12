.. EN-Revision: none
.. _zend.feed.consuming-rss:

Consommer un flux RSS
=====================

Lire un flux *RSS* se résume à instancier un objet ``Zend\Feed\Rss`` en passant l'URL du flux :

.. code-block:: php
   :linenos:

   $canal = new Zend\Feed\Rss('http://rss.exemple.com/nomDuCanal');

Si une erreur a lieu lors de l'obtention du flux, une ``Zend\Feed\Exception`` sera déclenchée.

Une fois que vous disposez d'un objet "flux *RSS*", vous pouvez accéder aux propriétés *RSS* standard du canal,
et ce directement à partir de l'objet :

.. code-block:: php
   :linenos:

   echo $canal->title();

Notez la syntaxe utilisée : un appel de fonction. ``Zend_Feed`` utilise une convention selon laquelle les
propriétés sont traitées comme des objets *XML* si elles sont demandées au moyen de la syntaxe
*$obj->propriété* et comme des chaînes si elles sont demandées au moyen de la syntaxe *$obj->propriété()*.
Ceci permet d'accéder à la totalité du contenu textuel d'un nœud particulier tout comme à l'ensemble des
enfants de ce nœud.

Si les propriétés du canal possèdent des attributs, ils sont accessibles à l'aide de l'indexage *PHP*\  :

.. code-block:: php
   :linenos:

   echo $canal->category['domain'];

Comme les attributs *XML* ne peuvent avoir des enfants, la syntaxe *$obj->propriété['attribut']()* n'est pas
nécessaire pour accéder aux valeurs des attributs.

La plupart du temps vous voudrez itérer sur le flux et réaliser quelque chose avec ses entrées.
``Zend\Feed\Abstract`` implémente l'interface *iterator* de *PHP*, ce qui résume au code suivant l'affichage des
titres de tous les articles du canal :

.. code-block:: php
   :linenos:

   foreach ($canal as $element) {
       echo $element->title() . "\n";
   }

Si vous n'êtes pas un familier de *RSS*, voici les éléments standard associés au canal *RSS* et à ses
éléments pris séparément (les entrées).

Les éléments requis pour les canaux sont :



   - *title* (titre) : le nom du canal

   - *link* (lien) : l'URL du site Web correspondant au canal

   - *description*\  : une ou plusieurs phrases décrivant le canal



Les éléments optionnels pour les canaux sont :



   - *pubDate* (date de publication) : la date de publication de l'ensemble, au format *RFC* 822

   - *language* (langue) : la langue dans laquelle est écrit le canal

   - *category* (catégorie) : un ou plusieurs noms de catégorie (spécifiés au moyen de plusieurs balises)
     auquel appartient le canal



Les éléments *RSS* *<item>* n'ont pas d'éléments requis particulier. Cependant soit *title* soit *description*
doivent être présents.

Les éléments communs sont :



   - *title* (titre) : le titre de l'élément

   - *link* (lien) : l'URL de l'élément

   - *description*\  : un résumé de l'élément

   - *author* (auteur) : l'adresse e-mail de l'auteur

   - *category* (catégorie) : une ou plusieurs catégories auquel appartient l'élément

   - *comments* (commentaires) : l'URL des commentaires relatifs à cet élément

   - *pubDate* (date de publication) : la date à laquelle l'élément a été publié, au format *RFC* 822



Dans votre code vous pouvez toujours tester si un élément est non-vide au moyen du test suivant :

.. code-block:: php
   :linenos:

   if ($element->nomPropriete()) {
       // ... traitement
   }

Si vous utilisez à la place de la condition *$element->nomPropriete*, vous obtiendrez toujours un objet qui, même
vide, sera évalué comme ``TRUE``, donc le test échouera.

Pour plus d'informations, la spécification *RSS* 2.0 officielle est disponible à l'adresse :
http://blogs.law.harvard.edu/tech/rss



