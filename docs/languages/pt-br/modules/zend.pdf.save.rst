.. EN-Revision: none
.. _zend.pdf.save:

Salvar Mudanças em Documentos PDF
=================================

Existem dois métodos que salvam as mudanças feitas em documentos *PDF*: os métodos ``Zend_Pdf::save()`` e
``Zend_Pdf::render()``.

``Zend_Pdf::save($filename, $updateOnly = false)`` salva o documento *PDF* em um arquivo. Se $updateOnly for
``TRUE``, então apenas o novo segmento do arquivo *PDF* será acrescentado ao arquivo. De outra forma, o arquivo
é sobrescrito.

``Zend_Pdf::render($newSegmentOnly = false)`` retorna o documento *PDF* como uma string. Se $newSegmentOnly for
``TRUE``, então apenas o novo segmento do arquivo *PDF* será retornado.

.. _zend.pdf.save.example-1:

.. rubric:: Salvando Documentos PDF

.. code-block:: php
   :linenos:

   ...
   // Carrega o documento PDF
   $pdf = Zend_Pdf::load($fileName);
   ...
   // Atualiza o documento PDF
   $pdf->save($fileName, true);
   // Salva o documento como um novo arquivo
   $pdf->save($newFileName);

   // Retorna o documento PDF como uma string
   $pdfString = $pdf->render();

   ...


