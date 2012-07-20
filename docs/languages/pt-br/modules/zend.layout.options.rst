.. _zend.layout.options:

Opções de Configuração Zend_Layout
==================================

``Zend_Layout`` tem uma variedade de opções de configuração. Essas podem ser configuradas chamando os acessores
apropriados, passando uma matriz ou objeto ``Zend_Config`` para o construtor ou ``startMvc()``, passando uma matriz
de opções para ``setOptions()``, ou passando um objeto ``Zend_Config`` para ``setConfig()``.

- **layout**: o layout a ser usado. Utiliza o inflector atual para resolver o nome fornecido para o view script de
  layout apropriado. Por padrão, esse valor é 'layout' e resolve para 'layout.phtml'. Os acessores são
  ``setLayout()`` e ``getLayout()``.

- **layoutPath**: o caminho base para os view scripts de layout. Os acessores são ``setLayoutPath()`` e
  ``getLayoutPath()``.

- **contentKey**: a variável de layout usada para o conteúdo padrão (quando usado com o *MVC*). O valor padrão
  é 'content'. Os acessores são ``setContentKey()`` e ``getContentKey()``.

- **mvcSuccessfulActionOnly**: quando usar o *MVC*, se uma ação lança uma exceção e esse marco é ``TRUE``, o
  layout não será renderizado (isso é para prevenir dupla renderização do layout quando o :ref:`ErrorHandler
  plugin <zend.controller.plugins.standard.errorhandler>` estiver em uso). Por padrão, o marco é ``TRUE``. Os
  acessores são ``setMvcSuccessfulActionOnly()`` e ``getMvcSuccessfulActionOnly()``.

- **view**: O objeto view para ser usado na renderização. Quando usado com o *MVC*, ``Zend_Layout`` tentará usar
  o objeto view registrado com o :ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>` se nenhum objeto
  view tiver sido passado explicitamente. Os acessores são ``setView()`` e ``getView()``.

- **helperClass**: a classe action helper para usar quando ``Zend_Layout`` estiver utilizando os componentes *MVC*.
  Por padrão, ela é ``Zend_Layout_Controller_Action_Helper_Layout``. Os acessores são ``setHelperClass()`` e
  ``getHelperClass()``.

- **pluginClass**: a classe front controller plugin para usar quando ``Zend_Layout`` estiver utilizando os
  componentes *MVC*. Por padrão, ela é ``Zend_Layout_Controller_Plugin_Layout``. Os acessores são
  ``setPluginClass()`` e ``getPluginClass()``.

- **inflector**: o inflector a ser usado quando resolver nomes para caminhos de view scripts de layout; veja
  :ref:`a documentação Zend_Layout inflector para mais detalhes <zend.layout.advanced.inflector>`. Os acessores
  são ``setInflector()`` e ``getInflector()``.

.. note::

   **helperClass e pluginClass devem ser passados para startMvc()**

   Para que as configurações *helperClass* e *pluginClass* tenham efeito, elas devem ser passadas como opções
   para ``startMvc()``; se forem configuradas mais tarde, elas não tem efeito.

.. _zend.layout.options.examples:

Exemplos
--------

Os seguintes exemplos assumem a seguinte matriz ``$options`` e objeto ``$config``:

.. code-block:: php
   :linenos:

   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/path/to/layouts',
       'contentKey' => 'CONTENT',           // ignorado quando o MVC não é usado
   );

.. code-block:: php
   :linenos:

   /**
   [layout]
   layout = "foo"
   layoutPath = "/path/to/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

.. _zend.layout.options.examples.constructor:

.. rubric:: Passando opções para o construtor ou startMvc()

Tanto o construtor quanto o método estático ``startMvc()`` podem aceitar tanto uma matriz de opções quanto um
objeto ``Zend_Config`` com opções de modo a configurar a instância de ``Zend_Layout``.

Primeiro, dê uma olhada na passagem de uma matriz:

.. code-block:: php
   :linenos:

   // Usando um construtor:
   $layout = new Zend_Layout($options);

   // Usando startMvc():
   $layout = Zend_Layout::startMvc($options);

E agora usando um objeto config:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

   // Usando construtor:
   $layout = new Zend_Layout($config);

   // Usando startMvc():
   $layout = Zend_Layout::startMvc($config);

Basicamente, esse é o modo mais fácil de customizar sua instância ``Zend_Layout``.

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: Usando setOption() e setConfig()

Algumas vezes você precisa configurar o objeto ``Zend_Layout`` depois que ele já foi instanciado;
``setOptions()`` e ``setConfig()`` dão a você um modo fácil e rápido de fazer isso:

.. code-block:: php
   :linenos:

   // Usando uma matriz de opções:
   $layout->setOptions($options);

   // Usando um objeto Zend_Config:
   $layout->setConfig($options);

Note, entretanto, que certas opções, tais como *pluginClass* e *helperClass*, não serão afetadas quando a
passagem for feita por esse método; elas precisam ser passadas ao construtor ou método ``startMvc()``.

.. _zend.layout.options.examples.accessors:

.. rubric:: Usando Acessores

Finalmente, você pode também configurar sua instância ``Zend_Layout`` via acessores. Todos os acessores
implementam uma interface fluente, significando que suas chamadas podem ser encadeadas:

.. code-block:: php
   :linenos:

   $layout->setLayout('foo')
          ->setLayoutPath('/path/to/layouts')
          ->setContentKey('CONTENT');


