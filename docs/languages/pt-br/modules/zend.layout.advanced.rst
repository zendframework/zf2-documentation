.. _zend.layout.advanced:

Uso Avançado de Zend_Layout
===========================

``Zend_Layout`` tem um número de casos de uso para o desenvolvedor que deseja adaptá-lo para diferentes
implementações de view, layouts de sistema de arquivos, e mais.

Os principais pontos de extensão são:

- **Custom view objects**. ``Zend_Layout`` permite a você utilizar qualquer classe que implemente
  ``Zend_View_Interface``.

- **Custom front controller plugins**. ``Zend_Layout`` vem embarcado com um front controller plugin padrão que
  automatiza a renderização de layouts antes de retornar a resposta. Você pode substituir por seu próprio
  plugin.

- **Custom action helpers**. ``Zend_Layout`` vem embarcado com um action helper padrão que deve servir para a
  maioria das necessidades já que é um proxy mudo para o próprio objeto de layout.

- **Custom layout script path resolution**. ``Zend_Layout`` permite a você usar seu próprio :ref:`inflector
  <zend.filter.inflector>` para resolução do caminho do script de layout, ou simplesmente modificar o inflector
  anexado para especificar suas próprias regras de inflexão.

.. _zend.layout.advanced.view:

Objetos View Customizados
-------------------------

``Zend_Layout`` permite a você usar qualquer classe que implemente ``Zend_View_Interface`` ou estenda
``Zend_View_Abstract`` para renderizar seu script de layout. Simplesmente passe seu objeto view customizado como um
parâmetro para o construtor/``startMvc()``, ou configure o usando o acessor ``setView()``:

.. code-block:: php
   :linenos:

   $view = new My_Custom_View();
   $layout->setView($view);

.. note::

   **Nem todas as implementações de Zend_View são iguais**

   Enquanto ``Zend_Layout`` permite que você use qualquer classe que implemente ``Zend_View_Interface``, você
   pode entrar bem se elas não puderem utilizar os vários helpers ``Zend_View``, particularmente os helpers
   layout e :ref:`placeholder <zend.view.helpers.initial.placeholder>`. Isso ocorre porque ``Zend_Layout`` torna o
   conjunto de variáveis no objeto disponível via ele mesmo e :ref:`placeholders
   <zend.view.helpers.initial.placeholder>`.

   Se você precisa usar uma implementação customizada de ``Zend_View`` que não suporta esses helpers, você
   precisará descobrir um modo de obter as variáveis de layout para o view. Isso pode ser feito ou pela extensão
   do objeto ``Zend_Layout`` com alteração do método ``render()`` para passar variáveis para o view, ou criando
   sua própria classe plugin que as passa antes de renderizar o layout.

   Alternativamente, se sua implementação de view suporta qualquer espécie de capacidade do plugin, você pode
   acessar as variáveis por meio do placeholder 'Zend_Layout' usando o :ref:`helper placeholder
   <zend.view.helpers.initial.placeholder>`:

   .. code-block:: php
      :linenos:

      $placeholders = new Zend_View_Helper_Placeholder();
      $layoutVars   = $placeholders->placeholder('Zend_Layout')->getArrayCopy();

.. _zend.layout.advanced.plugin:

Plugins Front Controller Customizados
-------------------------------------

Quando o usamos com os componentes *MVC*, ``Zend_Layout`` registra um plugin front controller que renderiza o
layout como a última ação antes de abandonar o laço de despacho. Na maioria dos casos, o plugin padrão
servirá, mas você se você desejar escrever o seu próprio, você pode especificar o nome da classe plugin a ser
carregada carregar pela passagem da opção *pluginClass* ao método ``startMvc()``.

Qualquer classe plugin que você escrever para esse propósito precisará estender
``Zend_Controller_Plugin_Abstract``, e deverá aceitar uma instância de objeto layout como um argumento para o
construtor. Caso contrário, os detalhes de sua implementação ficarão acima de você.

A classe plugin padrão usada é ``Zend_Layout_Controller_Plugin_Layout``.

.. _zend.layout.advanced.helper:

Action Helpers Customizados
---------------------------

Quando o usamos com componentes *MVC*, ``Zend_Layout`` registra um helper action controller com o helper broker. O
helper padrão, ``Zend_Layout_Controller_Action_Helper_Layout``, age como um proxy mudo para a própria instância
do objeto de layout, e deve servir para a maioria dos casos de uso.

Se você sentir necessidade de escrever funcionalidades customizadas, simplesmente escreva uma classe action helper
estendendo ``Zend_Controller_Action_Helper_Abstract`` e passe o nome da classe como uma opção *helperClass* para
o método ``startMvc()``. Detalhes da implementação ficarão acima de você.

.. _zend.layout.advanced.inflector:

Resolução de Caminho de Script de Layout Customizada: Usando o Inflector
------------------------------------------------------------------------

``Zend_Layout`` usa ``Zend_Filter_Inflector`` para estabelecer uma cadeia de filtro para traduzir um nome de layout
para caminho de script de layout. Por padrão, ela usa as regras 'Word_CamelCaseToDash' seguida por
'StringToLower', e o sufixo 'phtml' para transformar o nome em um caminho. Alguns exemplos:

- 'foo' será transformado em 'foo.phtml'.

- 'FooBarBaz' será transformado em 'foo-bar-baz.phtml'.

Você tem três opções para modificar inflexão: modificar o alvo de inflexão e/ou sufixo da view via acessores
de ``Zend_Layout``, modificar as regras do inflector e alvo do inflector associado com a instância
``Zend_Layout``, ou criar sua própria instância de inflector e passá-la para ``Zend_Layout::setInflector()``.

.. _zend.layout.advanced.inflector.accessors:

.. rubric:: Usando acessores Zend_Layout para modificar o inflector

O inflector ``Zend_Layout`` padrão usa referências estáticas para o alvo e sufixo de view script, e tem
acessores para configurar esses valores.

.. code-block:: php
   :linenos:

   // Configure o alvo do inflector:
   $layout->setInflectorTarget('layouts/:script.:suffix');

   // Configura o sufixo do view script de layout:
   $layout->setViewSuffix('php');

.. _zend.layout.advanced.inflector.directmodification:

.. rubric:: Modificação direta do inflector Zend_Layout

Inflectores tem um alvo e uma ou mais regras. O alvo padrão usado com ``Zend_Layout`` é ':script.:suffix';
':script' passa o nome do layout registrado, enquanto ':suffix' é uma regra estática do inflector.

Digamos que você queira que o script de layout termine no sufixo 'html', e que você queira separar palavras
MixedCase e camelCased com underscores ao invés de hífens, e não deixe o nome em caixa baixa. Adicionalmente,
você quer procurar em um subdiretório 'layouts' pelo script.

.. code-block:: php
   :linenos:

   $layout->getInflector()->setTarget('layouts/:script.:suffix')
                          ->setStaticRule('suffix', 'html')
                          ->setFilterRule(array('Word_CamelCaseToUnderscore'));

.. _zend.layout.advanced.inflector.custom:

.. rubric:: Inflectores Customizados

Na maioria dos casos, modificar o inflector existente será suficiente. Entretanto, você pode ter um inflector que
você deseja usar em diversos lugares, com diferentes objetos de diferentes tipos. ``Zend_Layout`` suporta isso.

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('layouts/:script.:suffix');
   $inflector->addRules(array(
       ':script' => array('Word_CamelCaseToUnderscore'),
       'suffix'  => 'html'
   ));
   $layout->setInflector($inflector);

.. note::

   **Inflexão pode ser desabilitada**

   Inflexão pode ser desabilitada e habilitada usando acessores no objeto ``Zend_Layout``. Isso pode ser útil se
   você quiser especificar um caminho absoluto para um view script de layout, ou saber que o mecanismo que você
   usará para especificar o script de layout não precisa de inflexão. Simplesmente use os métodos
   ``enableInflection()`` e ``disableInflection()``.


