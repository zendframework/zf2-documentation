.. EN-Revision: none
.. _zend.pdf.pages:

Les pages d'un document
=======================

.. _zend.pdf.pages.creation:

Création de page
----------------

Les pages d'un document *PDF* sont représentés par la classe ``ZendPdf\Page``

Les pages d'un *PDF* proviennent d'un *PDF* existant, ou sont créées à partir de rien.

Une nouvelle page peut-être obtenu en créant un nouvel objet ``ZendPdf\Page`` ou en appelant la méthode
``ZendPdf\Pdf::newPage()``\ qui retourne un objet ``ZendPdf\Page``. La différence est que la méthode
``ZendPdf\Pdf::newPage()`` crée une page directement attachée au document. A la différence des pages non attachées
à un document, elle ne peut-être utilisée dans plusieurs documents *PDF*, mais est un peu plus performante.
[#]_. C'est à vous de choisir quel approche doit-être utilisée.

Les méthodes ``ZendPdf\Pdf::newPage()`` et ``ZendPdf\Page`` prennent le même paramètre. C'est la taille de la page
($x, $y) en point (1/72 inch soit 0,352778 mm), ou une constante prédéfinie, qui correspond au format du papier :


   - ZendPdf\Page::SIZE_A4

   - ZendPdf\Page::SIZE_A4_LANDSCAPE

   - ZendPdf\Page::SIZE_LETTER

   - ZendPdf\Page::SIZE_LETTER_LANDSCAPE



Les pages du document sont stockées dans l'attribut public ``$pages`` de la classe ``ZendPdf``. C'est un tableau
d'objet ``ZendPdf\Page``. Il définit l'ensemble des pages, ainsi que l'ordre de celle-ci et peut-être manipulé
comme un tableau classique :

.. _zend.pdf.pages.example-1:

.. rubric:: Gestion des pages d'un document PDF

.. code-block:: php
   :linenos:

   ...
   // Inverse l'ordre des pages
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Ajoute une nouvelle page
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Page::SIZE_A4);
   // Ajoute une nouvelle page
   $pdf->pages[] = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   // Retire la page spécifiée
   unset($pdf->pages[$id]);
   ...

.. _zend.pdf.pages.cloning:

Clonage de page
---------------

Les pages existantes d'un *PDF* peuvent être clonées en créant un nouvel objet ``ZendPdf\Page`` avec la page
existante comme paramètre :

.. _zend.pdf.pages.example-2:

.. rubric:: Cloner une page existante

.. code-block:: php
   :linenos:

   ...
   // Stocke le modèle dans une variable séparée
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Ajoute une nouvelle page
   $page1 = new ZendPdf\Page($template);
   $pdf->pages[] = $page1;
   ...

   // Ajoute une autre page
   $page2 = new ZendPdf\Page($template);
   $pdf->pages[] = $page2;
   ...

   // Enlève la page modèle du document
   unset($pdf->pages[$templatePageIndex]);
   ...

C'est pratique si plusieurs pages doivent être créées sur le même modèle.

.. caution::

   Important ! La page clonée partage quelques ressources *PDF* avec la page modèle, donc ceci doit être
   utilisé seulement dans le même document qu'une page modèle. Le document modifié peut être sauvegardé comme
   nouveau document.



.. [#] C'est une limitation de la version courante du module ``ZendPdf``. Ce sera corrigé dans une future
       version. Mais les pages non attachées à un document donneront toujours de meilleurs résultats pour
       partager une page entre plusieurs documents.