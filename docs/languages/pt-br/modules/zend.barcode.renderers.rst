.. _zend.barcode.renderers:

Renderizadores do Zend_Barcode
==============================

Os renderizadores tem algumas opções em comum. Essas opções podem ser definidas em quatro formas:

- Como uma matriz ou um objeto ``Zend_Config`` passado ao construtor.

- Como uma matriz passada ao método ``setOptions()``.

- Como um objeto ``Zend_Config`` passado ao método ``setConfig()``.

- Como valores distintos passados à setters individuais.

.. _zend.barcode.renderers.configuration:

.. rubric:: Diferentes maneiras de parametrizar um objeto renderizador

.. code-block:: php
   :linenos:

   $options = array('topOffset' => 10);

   // Caso 1
   $renderer = new Zend_Barcode_Renderer_Pdf($options);

   // Caso 2
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setOptions($options);

   // Caso 3
   $config   = new Zend_Config($options);
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setConfig($config);

   // Caso 4
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setTopOffset(10);

.. _zend.barcode.renderers.common.options:

Opções Comuns
-------------

Na lista seguinte, os valores não têm unidades; usaremos o termo "unidade". Por exemplo, o valor padrão da
"barra fina" é "1 unidade". As unidades reais dependem do suporte de renderização. Os setters individuais são
obtidos mudando a letra inicial da opção para maiúscula e colocando o prefixo "set" (por exemplo "barHeight" =>
"setBarHeight"). Todas as opções têm um getter correspondente com prefixo "get" (por exemplo "getBarHeight"). As
opções disponíveis são:

.. _zend.barcode.renderers.common.options.table:

.. table:: Opções Comuns

   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opção               |Tipo de Dado       |Valor Padrão         |Descrição                                                                                                                                                                                                                |
   +====================+===================+=====================+=========================================================================================================================================================================================================================+
   |rendererNamespace   |String             |Zend_Barcode_Renderer|Namespace do renderizador; por exemplo, caso precise estender os renderizadores.                                                                                                                                         |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |horizontalPosition  |String             |"left"               |Pode ser "left", "center" ou "right". Pode ser útil com o formato PDF ou se o método setWidth() for usado com um renderizador de imagem.                                                                                 |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |verticalPosition    |String             |"top"                |Pode ser "top", "middle" ou "bottom". Pode ser útil com o formato PDF ou se o método setHeight() for usado com um renderizador de imagem.                                                                                |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |leftOffset          |Integer            |0                    |Posição superior do código de barras no interior do renderizador. Se usado, este valor substituirá a opção "horizontalPosition".                                                                                         |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |topOffset           |Integer            |0                    |Posição superior do código de barras no interior do renderizador. Se usado, este valor substituirá a opção "verticalPosition".                                                                                           |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automaticRenderError|Boolean            |TRUE                 |Ativa a renderização automática dos erros. Se ocorrer uma exceção, o objeto código de barras fornecido será substituído por uma representação de erro. Observe que alguns erros (ou exceções) não podem ser renderizados.|
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |moduleSize          |Float              |1                    |Tamanho de um módulo de renderização no suporte.                                                                                                                                                                         |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |barcode             |Zend_Barcode_Object|NULL                 |O objeto código de barras a ser renderizado.                                                                                                                                                                             |
   +--------------------+-------------------+---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Existe um getter adicional: ``getType()``. Ele retorna o nome da classe de renderização sem o namespace (por
exemplo, ``Zend_Barcode_Renderer_Image`` retorna "image").

.. _zend.barcode.renderers.image:

Zend_Barcode_Renderer_Image
---------------------------

O renderizador Image irá desenhar a lista de instruções do objeto código de barras em um recurso de imagem. O
componente requer a extensão GD. A largura padrão de um módulo é de 1 pixel.

As opções disponíveis são:

.. _zend.barcode.renderers.image.table:

.. table:: Opções do Zend_Barcode_Renderer_Image

   +---------+------------+------------+--------------------------------------------------------------------------------------------------------------------------+
   |Opção    |Tipo de Dado|Valor Padrão|Descrição                                                                                                                 |
   +=========+============+============+==========================================================================================================================+
   |height   |Integer     |0           |Permite=lhe especificar a altura da imagem resultante. Se for "0", a altura será calculada pelo objeto código de barras.  |
   +---------+------------+------------+--------------------------------------------------------------------------------------------------------------------------+
   |width    |Integer     |0           |Permite-lhe especificar a largura da imagem resultante. Se for "0", a largura será calculada pelo objeto código de barras.|
   +---------+------------+------------+--------------------------------------------------------------------------------------------------------------------------+
   |imageType|String      |"png"       |Especifica o formato da imagem. Pode ser "png", "jpeg", "jpg" ou "gif".                                                   |
   +---------+------------+------------+--------------------------------------------------------------------------------------------------------------------------+

.. _zend.barcode.renderers.pdf:

Zend_Barcode_Renderer_Pdf
-------------------------

O renderizador de *PDF* irá desenhar a lista de instruções do objeto código de barras em um documento *PDF*. A
largura padrão de um módulo é de 0,5 point.

Não existem opções específicas para este renderizador.


