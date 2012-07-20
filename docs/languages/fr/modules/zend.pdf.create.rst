.. _zend.pdf.create:

Créer et charger des documents PDF
==================================

La classe ``Zend_Pdf`` représente le document *PDF* en lui-même et fournis des méthodes pour manipuler
l'ensemble du document.

Pour créer un nouveau document, un nouvel objet ``Zend_Pdf`` doit être créé.

La classe ``Zend_Pdf`` fournis deux méthodes statiques pour charger un *PDF* existant. Ce sont les méthodes
``Zend_Pdf::load()`` et ``Zend_Pdf::parse()``. Les deux retournent un objet ``Zend_Pdf`` ou lève une exception en
cas d'erreur.

.. _zend.pdf.create.example-1:

.. rubric:: Créer un nouveau document PDF ou en charger un existant

.. code-block:: php
   :linenos:

   ...
   /// Crée un nouveau document PDF.
   $pdf1 = new Zend_Pdf();

   // Charge un document PDF depuis un fichier.
   $pdf2 = Zend_Pdf::load($fileName);

   // Charge un document PDF depuis une string
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...

Le format de fichier *PDF* supporte la mise à jour incrémentale d'un document. Ainsi chaque fois que le document
est mis à jour, une nouvelle version du document est créée. Le module ``Zend_Pdf`` supporte la récupération
d'une version spécifique.

La version peut-être donnée en second paramètre des méthodes ``Zend_Pdf::load()`` et ``Zend_Pdf::parse()`` ou
obligatoire dans le cas d'un appel à ``Zend_Pdf::rollback()`` [#]_

.. _zend.pdf.create.example-2:

.. rubric:: Demander une version particulière d'un document PDF

.. code-block:: php
   :linenos:

   ...
   // Charge la version précédente d'un document PDF.
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Charge la version précédente d'un document PDF.
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Charge la première version d'un document
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] La méthode ``Zend_Pdf::rollback()`` doit être appelée avant tout changement. Sinon le comportement est
       indéfini.