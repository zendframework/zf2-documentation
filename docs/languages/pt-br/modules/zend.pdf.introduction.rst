.. _zend.pdf.introduction:

Introdução
==========

O componente ``Zend_Pdf`` é um motor para manipulação de *PDF* (Portable Document Format). Ele pode carregar,
criar, modificar e salvar documentos. Dessa forma, ele pode ajudar qualquer aplicação em *PHP* a criar documentos
*PDF* dinamicamente através da modificação de documentos existentes ou gerando novos documentos a partir do
zero. ``Zend_Pdf`` oferece as seguintes características:



   - Criar um novo documento ou carregar um já existente. [#]_

   - Recuperar uma revisão específica do documento.

   - Manipular páginas dentro de um documento. Alterar ordem, adicionar e remover páginas de um documento.

   - Diferentes formas primitivas de desenho (linhas, retângulos, polígonos, círculos, elipses e áreas).

   - Escrever texto usando qualquer uma das 14 fontes padrões (built-in) ou suas próprias fontes TrueType
     personalizadas.

   - Rotações.

   - Desenho de imagens. [#]_

   - Atualização incremental dos arquivos *PDF*.





.. [#] O carregamento de documentos *PDF* V1.4 (Acrobat 5) já é suportado.
.. [#] Imagens nos formatos JPG, PNG [até 8bit por canal+Alpha] e TIFF são suportadas.