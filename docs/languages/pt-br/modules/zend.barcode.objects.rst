.. _zend.barcode.objects:

Objetos Zend_Barcode
====================

Os objetos código de barras te permitem gerar códigos de barras independentemente do suporte de renderização.
Após a geração, você pode recuperar o código de barras como uma matriz de instruções de desenho que você
pode fornecer a um renderizador.

Os objetos têm um grande número de opções. A maioria deles são comuns a todos os objetos. Essas opções podem
ser definidas em quatro formas:

- Como uma matriz ou um objeto ``Zend_Config`` passado ao construtor.

- Como uma matriz passada ao método ``setOptions()``.

- Como um objeto ``Zend_Config`` passado ao método ``setConfig()``.

- Através de métodos de acesso individuais para cada tipo de configuração.

.. _zend.barcode.objects.configuration:

.. rubric:: Diferentes maneiras de parametrizar um objeto código de barras

.. code-block:: php
   :linenos:

   $options = array('text' => 'ZEND-FRAMEWORK', 'barHeight' => 40);

   // Caso 1: construtor
   $barcode = new Zend_Barcode_Object_Code39($options);

   // Caso 2: setOptions()
   $barcode = new Zend_Barcode_Object_Code39();
   $barcode->setOptions($options);

   // Caso 3: setConfig()
   $config  = new Zend_Config($options);
   $barcode = new Zend_Barcode_Object_Code39();
   $barcode->setConfig($config);

   // Caso 4: métodos de acesso individuais
   $barcode = new Zend_Barcode_Object_Code39();
   $barcode->setText('ZEND-FRAMEWORK')
           ->setBarHeight(40);

.. _zend.barcode.objects.common.options:

Opções Comuns
-------------

Na lista seguinte, os valores não têm unidades; usaremos o termo "unidade". Por exemplo, o valor padrão da
"barra fina" é "1 unidade". As unidades reais dependem do suporte de renderização (veja :ref:`a documentação
dos renderizadores <zend.barcode.renderers>` para mais informações). Os métodos de acesso são nomeados mudando
a letra inicial da opção para maiúscula e colocando o prefixo "set" (por exemplo "barHeight" se torna
"setBarHeight"). Todas as opções têm um método de leitura correspondente com prefixo "get" (por exemplo
"getBarHeight"). As opções disponíveis são:

.. _zend.barcode.objects.common.options.table:

.. table:: Opções Comuns

   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |Opção             |Tipo de Dado     |Valor Padrão       |Descrição                                                                                                                 |
   +==================+=================+===================+==========================================================================================================================+
   |barcodeNamespace  |String           |Zend_Barcode_Object|Namespace do código de barras; por exemplo, se você precisar estender os objetos incorporados                             |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |barHeight         |Integer          |50                 |Altura das barras                                                                                                         |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |barThickWidth     |Integer          |3                  |Largura da barra grossa                                                                                                   |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |barThinWidth      |Integer          |1                  |Largura da barra fina                                                                                                     |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |factor            |Integer          |1                  |Fator com o qual a largura das barras e o tamanho das fontes são multiplicados                                            |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |foreColor         |Integer          |0 (preto)          |Cor da barra e do texto. Poderia ser fornecido como um inteiro ou como um valor em HTML (por exemplo "#333333")           |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |backgroundColor   |Integer ou String|16777125 (branco)  |Cor do fundo. Poderia ser fornecido como um inteiro ou como um valor em HTML (por exemplo "#333333")                      |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |reverseColor      |Boolean          |FALSE              |Permite-lhe trocar a cor da barra e do fundo                                                                              |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |orientation       |Integer          |0                  |Orientação do código de barras                                                                                            |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |font              |String ou Integer|NULL               |Caminho para uma fonte TTF ou um número entre 1 e 5, caso esteja utilizando a geração de imagem com o GD (fontes internas)|
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |fontSize          |Integer          |10                 |Tamanho da fonte (não aplicável à fontes numéricas)                                                                       |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |withBorder        |Boolean          |FALSE              |Desenhar uma borda em torno do código de barras e dos espaços vazios                                                      |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |withQuietZones    |Boolean          |TRUE               |Deixar um espaço vazio antes e depois do código de barras                                                                 |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |drawText          |Boolean          |TRUE               |Define se o texto será mostrado abaixo do código de barras                                                                |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |stretchText       |Boolean          |FALSE              |Especifica se o texto será esticado ao longo do código de barras                                                          |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |withChecksum      |Boolean          |FALSE              |Indica se o checksum será adicionado automaticamente ao código de barras                                                  |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |withChecksumInText|Boolean          |FALSE              |Indica se o checksum será exibido na representação textual                                                                |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+
   |text              |String           |NULL               |O texto que será reproduzido como um código de barras                                                                     |
   +------------------+-----------------+-------------------+--------------------------------------------------------------------------------------------------------------------------+

.. _zend.barcode.objects.common.options.barcodefont:

O caso particular do setBarcodeFont() estático
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Você pode definir uma fonte comum para todos os seus objetos usando o método estático
``Zend_Barcode_Object::setBarcodeFont()``. Este valor pode ser substituído por objetos individuais usando o
método ``setFont()``.

.. code-block:: php
   :linenos:

   // Em seu arquivo bootstrap:
   Zend_Barcode_Object::setBarcodeFont('my_font.ttf');

   // Depois em seu código:
   Zend_Barcode::render(
       'code39',
       'pdf',
       array('text' => 'ZEND-FRAMEWORK')
   ); // utilizará 'my_font.ttf'

   // or:
   Zend_Barcode::render(
       'code39',
       'image',
       array(
           'text' => 'ZEND-FRAMEWORK',
           'font' => 3
       )
   ); // utilizará a terceira fonte interna do GD

.. _zend.barcode.objects.common.getters:

Métodos de Leitura Comuns Adicionais
------------------------------------



.. _zend.barcode.objects.common.getters.table:

.. table:: Métodos de Leitura Comuns

   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |Método de Leitura                  |Tipo de Dado|Descrição                                                                                                                           |
   +===================================+============+====================================================================================================================================+
   |getType()                          |String      |Retorna o nome da classe de código de barras sem o namespace (por exemplo, Zend_Barcode_Object_Code39 retorna simplesmente "code39")|
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getRawText()                       |String      |Retorna o texto original fornecido pelo objeto                                                                                      |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getTextToDisplay()                 |String      |Retorna o texto a ser exibido, incluindo, se ativado, o valor do checksum                                                           |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getQuietZone()                     |Integer     |Retornar a quantidade de espaço necessário antes e depois do código de barras sem nenhum desenho                                    |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getInstructions()                  |Array       |Retorna as instruções de desenho como uma matriz                                                                                    |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getHeight($recalculate = false)    |Integer     |Retorna a altura do código de barras calculado após uma possível rotação                                                            |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getWidth($recalculate = false)     |Integer     |Retorna a largura do código de barras calculado após uma possível rotação                                                           |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getOffsetTop($recalculate = false) |Integer     |Retorna a posição do topo do código de barras calculado após uma possível rotação                                                   |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+
   |getOffsetLeft($recalculate = false)|Integer     |Retorna a posição da esquerda do código de barras calculado após uma possível rotação                                               |
   +-----------------------------------+------------+------------------------------------------------------------------------------------------------------------------------------------+

.. include:: zend.barcode.objects.details.rst

