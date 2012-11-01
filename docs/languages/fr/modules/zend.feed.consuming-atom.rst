.. EN-Revision: none
.. _zend.feed.consuming-atom:

Consommer un flux Atom
======================

La classe ``Zend\Feed\Atom`` est utilisée pratiquement de la même manière que ``Zend\Feed\Rss``. Tout comme
``Zend\Feed\Rss``, elle offre aussi un accès aux propriétés du flux et elle permet d'itérer sur les entrées du
flux. La différence principale réside dans la structure du protocole Atom lui-même. Atom est le successeur de
*RSS*\  ; c'est un protocole plus général et il est conçu pour prendre en charge plus facilement les flux qui
incluent directement leur contenu, et ce en divisant la balise *RSS* *description* en deux éléments : *summary*
(résumé) et *content* (contenu).

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Emploi basique de Zend\Feed\Atom

Pour lire un flux Atom et afficher le titre (propriété *title*) et le résumé (propriété *summary*) de chaque
entrée :

.. code-block:: php
   :linenos:

   $flux = new Zend\Feed\Atom('http://atom.exemple.com/flux/');
   echo 'Le flux contient ' . $flux->count() . ' entrée(s).' . "\n\n";
   foreach ($flux as $entree) {
       echo 'Titre : ' . $entree->title() . "\n";
       echo 'Résumé : ' . $entree->summary() . "\n\n";
   }

Voici les propriétés liées au flux que vous pourrez trouver dans un flux Atom :



   - *title* (titre) : le titre du flux, la même chose que le titre d'un canal *RSS*

   - *id* (identifiant) : avec Atom, chaque flux et entrée possède un identifiant unique

   - *link* (lien) : les flux peuvent posséder plusieurs liens, qui se distinguent les uns des autres par un
     attribut *type*

     Le lien équivalent au lien d'un canal *RSS* aurait pour type *"text/html"*. Si le lien désigne une version
     alternative du contenu présent dans le flux, il possédera un attribut *rel="alternate"*

   - *subtitle* (sous-titre) : la description du flux, qui équivaut à la description d'un canal *RSS*

     *author->name()*\  : le nom de l'auteur du flux

     *author->email()*\  : l'adresse e-mail de l'auteur du flux



Les entrées Atom possèdent généralement les propriétés suivantes :



   - *id* (identifiant) : l'identifiant unique de l'entrée

   - *title* (titre) : le titre de l'entrée, la même chose que le titre d'un élément *RSS*

   - *link* (lien) : un lien vers un autre format ou une vue alternative de l'entrée

   - *summary* (résumé) : un résumé du contenu de l'entrée

   - *content* (contenu) : le contenu de l'entrée dans son entier ; vous pouvez l'ignorer si le flux ne contient
     que des résumés

   - *author* (auteur) : avec les sous-balises *name* (nom) et *email*

   - *published* (publié) : la date à laquelle l'entrée a été publiée, au format *RFC* 3339

   - *updated* (publié) : la date à laquelle l'entrée a été mise à jour, au format *RFC* 3339



Pour plus d'informations sur Atom ainsi qu'un grand nombre de ressources, voyez le site
`http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
