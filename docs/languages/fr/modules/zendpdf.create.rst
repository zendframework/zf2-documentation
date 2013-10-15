.. EN-Revision: none
.. _zendpdf.create:

Créer et charger des documents PDF
==================================

La classe ``ZendPdf`` représente le document *PDF* en lui-même et fournis des méthodes pour manipuler
l'ensemble du document.

Pour créer un nouveau document, un nouvel objet ``ZendPdf`` doit être créé.

La classe ``ZendPdf`` fournis deux méthodes statiques pour charger un *PDF* existant. Ce sont les méthodes
``ZendPdf\Pdf::load()`` et ``ZendPdf\Pdf::parse()``. Les deux retournent un objet ``ZendPdf`` ou lève une exception en
cas d'erreur.

.. _zendpdf.create.example-1:

.. rubric:: Créer un nouveau document PDF ou en charger un existant

.. code-block:: php
   :linenos:

   ...
   /// Crée un nouveau document PDF.
   $pdf1 = new ZendPdf\Pdf();

   // Charge un document PDF depuis un fichier.
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // Charge un document PDF depuis une string
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...

Le format de fichier *PDF* supporte la mise à jour incrémentale d'un document. Ainsi chaque fois que le document
est mis à jour, une nouvelle version du document est créée. Le module ``ZendPdf`` supporte la récupération
d'une version spécifique.

La version peut-être donnée en second paramètre des méthodes ``ZendPdf\Pdf::load()`` et ``ZendPdf\Pdf::parse()`` ou
obligatoire dans le cas d'un appel à ``ZendPdf\Pdf::rollback()`` [#]_

.. _zendpdf.create.example-2:

.. rubric:: Demander une version particulière d'un document PDF

.. code-block:: php
   :linenos:

   ...
   // Charge la version précédente d'un document PDF.
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // Charge la version précédente d'un document PDF.
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // Charge la première version d'un document
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] La méthode ``ZendPdf\Pdf::rollback()`` doit être appelée avant tout changement. Sinon le comportement est
       indéfini.