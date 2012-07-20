.. _zend.pdf.save:

Sauvegarder les changement dans un document PDF
===============================================

Il y a deux méthodes qui permettent la sauvegarde dans un document *PDF*. Ce sont ``Zend_Pdf::save()`` et
``Zend_Pdf::render()``.

La méthode ``Zend_Pdf::save($filename, $updateOnly = false)`` sauvegarde un document dans un fichier. Si
``$updateOnly`` est à ``TRUE``, alors seulement les nouvelles sections *PDF* sont ajoutées au fichier. Sinon le
fichier est écrasé.

La méthode ``Zend_Pdf::render($filename, $newSegmentOnly = false)`` retourne le document *PDF* dans une chaîne.
Si ``$newSegmentOnly`` est à ``TRUE``, alors seulement les nouvelles sections du *PDF* sont retournées.

.. _zend.pdf.save.example-1:

.. rubric:: Sauvegarder un document PDF

.. code-block:: php
   :linenos:

   ...
   // Charge un document PDF.
   $pdf = Zend_Pdf::load($fileName);
   ...
   // Met à jour le document
   $pdf->save($fileName, true);
   // Sauvegarde le document dans un nouveau fichier.
   $pdf->save($newFileName);

   // Retourne le document PDF dans une string
   $pdfString = $pdf->render();
   ...


