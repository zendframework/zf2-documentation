.. EN-Revision: none
.. _zend.pdf.pages:

Trabalhando com Páginas
=======================

.. _zend.pdf.pages.creation:

Criação de Página
-----------------

As páginas em um documento *PDF* são representadas como instâncias de ``ZendPdf\Page`` em ``ZendPdf``.

Páginas *PDF* podem ser carregadas de um *PDF* existente ou criadas usando a *API* de ``ZendPdf``.

Novas páginas podem ser criadas instanciando novos objetos ``ZendPdf\Page`` diretamente ou chamando o método
``ZendPdf\Pdf::newPage()``, que retorna um objeto ``ZendPdf\Page``. ``ZendPdf\Pdf::newPage()`` cria uma página já
anexada à um documento. Páginas desanexadas não podem ser usadas com múltiplos documentos *PDF*, mas elas
possuem uma performance relativamente maior. [#]_

O método ``ZendPdf\Pdf::newPage()`` e o construtor ``ZendPdf\Page`` recebem os mesmos parâmetros de definição do
tamanho da página. Eles podem receber tanto o tamanho da página ($x, $y) em pontos (1/72 polegadas) quanto uma
constante pré-definida representando um tipo de página:



   - ZendPdf\Page::SIZE_A4

   - ZendPdf\Page::SIZE_A4_LANDSCAPE

   - ZendPdf\Page::SIZE_LETTER

   - ZendPdf\Page::SIZE_LETTER_LANDSCAPE



As páginas de um documento são armazenadas no atributo público ``$pages`` da classe ``ZendPdf``. O atributo
contém uma matriz de objetos ``ZendPdf\Page`` e define completamente as instâncias e ordem das páginas. Esta
matriz pode ser manipulada como qualquer outra matriz do *PHP*:

.. _zend.pdf.pages.example-1:

.. rubric:: Gerenciamento de páginas de documentos PDF

.. code-block:: php
   :linenos:

   ...
   // Inverte a ordem das páginas
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Adiciona nova página
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Page::SIZE_A4);
   // Adiciona nova página
   $pdf->pages[] = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   // Remove uma página específica
   unset($pdf->pages[$id]);

   ...

.. _zend.pdf.pages.cloning:

Clonagem de Página
------------------

Páginas *PDF* podem ser clonadas através da criação de um novo objeto ``ZendPdf\Page`` com uma página já
existente como parâmetro:

.. _zend.pdf.pages.example-2:

.. rubric:: Clonando páginas existentes

.. code-block:: php
   :linenos:

   ...
   // Armazena a página template em uma variável separada
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Adiciona nova página
   $page1 = new ZendPdf\Page($template);
   $pdf->pages[] = $page1;
   ...

   // Adiciona outra página
   $page2 = new ZendPdf\Page($template);
   $pdf->pages[] = $page2;
   ...

   // Remove a fonte da página template dos documentos
   unset($pdf->pages[$templatePageIndex]);

   ...

É útil caso você precise criar diversas páginas usando um template.

.. caution::

   Importante! Uma página clonada compartilha alguns recursos do *PDF* com uma página template, então ela só
   pode ser usada no mesmo documento como uma página template. Um documento modificado pode ser salvo como um novo
   documento.



.. [#] Esta é uma limitação da versão atual do Zend Framework. Esta limitação será eliminada nas versões
       futuras. Mas páginas desanexadas sempre terão um desempenho melhor no compartilhamento de páginas entre
       diversos documentos.