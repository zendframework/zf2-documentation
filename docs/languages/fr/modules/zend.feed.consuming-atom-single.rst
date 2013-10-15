.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

Consommer une entrée Atom particulière
======================================

Les éléments Atom *<entry>* sont aussi valides tout seuls. Généralement l'URL d'une entrée constitue l'URL du
flux suivie de */<idEntree>*, par exemple *http://atom.exemple.com/flux/1* si on reprend l'URL que nous avons
utilisée ci-dessus.

Si vous lisez une entrée seule, vous obtiendrez toujours un objet ``Zend\Feed\Atom`` mais cette classe créera
automatiquement un flux "anonyme" pour contenir l'entrée.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Lire un flux Atom constitué d'une seule entrée

.. code-block:: php
   :linenos:

   $flux = new Zend\Feed\Atom('http://atom.exemple.com/flux/1');
   echo 'Le flux possède : ' . $flux->count() . ' entrée(s).';

   $entree = $flux->current();

Vous pouvez aussi instancier directement la classe représentant les entrées si vous êtes sûr que vous accédez
à un document contenant une seule balise *<entry>*\  :

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Utiliser directement l'objet Zend\Feed\Entry\Atom

.. code-block:: php
   :linenos:

   $entree = new Zend\Feed\Entry\Atom('http://atom.exemple.com/flux/1');
   echo $entree->title();


