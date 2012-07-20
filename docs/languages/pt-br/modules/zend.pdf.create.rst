.. _zend.pdf.create:

Criando e Carregando Documentos PDF
===================================

A classe ``Zend_Pdf`` representa os documentos *PDF* e provê funcionalidades para manipulação do documento.

Para criar um novo documento, um novo objeto ``Zend_Pdf`` deve ser instanciado primeiro.

A classe ``Zend_Pdf`` também provê dois métodos estáticos para carregar um documento *PDF* existente. Os
métodos são ``Zend_Pdf::load()`` e ``Zend_Pdf::parse()``. Ambos retornam objetos ``Zend_Pdf`` como resultado, ou
uma exceção se algum erro ocorrer.

.. _zend.pdf.create.example-1:

.. rubric:: Criar um novo documento PDF ou carregar um já existente

.. code-block:: php
   :linenos:

   ...
   // Cria um novo documento PDF
   $pdf1 = new Zend_Pdf();

   // Carrega um documento PDF a partir de um arquivo
   $pdf2 = Zend_Pdf::load($fileName);

   // Carrega um documento PDF a partir de uma string
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...

O formato de arquivo *PDF* suporta a atualização incremental do documento. Dessa forma, toda vez que um documento
é atualizado, uma nova revisão do documento é criada. O componente ``Zend_Pdf`` suporta a recuperação de uma
revisão especificada.

Uma revisão pode ser especificada como o segundo parâmetro para os métodos ``Zend_Pdf::load()`` e
``Zend_Pdf::parse()`` ou solicitada chamando o método ``Zend_Pdf::rollback()``. [#]_

.. _zend.pdf.create.example-2:

.. rubric:: Solicitando Revisões Específicas de um Documento PDF

.. code-block:: php
   :linenos:

   ...
   // Carrega a revisão anterior do documento PDF
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Carrega a revisão anterior do documento PDF
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Carrega a primeira revisão do documento PDF
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] O método ``Zend_Pdf::rollback()`` deve ser chamado antes que qualquer mudança seja aplicada ao documento,
       caso contrário o comportamento do método não é definido.