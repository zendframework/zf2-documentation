.. _zend.layout.quickstart:

Guia Rápido Zend_Layout
=======================

Há dois casos de uso primários para ``Zend_Layout``: com o *MVC* do Zend Framework, e sem.

.. _zend.layout.quickstart.layouts:

Scripts de Layout
-----------------

Em ambos os casos, entretanto, você precisará criar um script de layout. Scripts de layout simplesmente utilizam
``Zend_View`` (ou qualquer outra implementação de view que você esteja usando). Variáveis de layout são
registradas com um :ref:`marcador <zend.view.helpers.initial.placeholder>` ``Zend_Layout``, e podem ser acessadas
via helper de marcador ou buscando-as como propriedades de objeto do objeto layout via helper de layout.

Como um exemplo:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>Meu Site</title>
   </head>
   <body>
   <?php
       // busca a chave 'content' usando um helper de layout:
       echo $this->layout()->content;

       // busca a chave 'foo' usando um helper marcador:
       echo $this->placeholder('Zend_Layout')->foo;

       // busca o objeto de layout e recupera várias chaves dele:
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

Como ``Zend_Layout`` utiliza ``Zend_View`` para renderização, Você pode também usar quaisquer helpers de view
registradas, e também ter acesso a quaisquer variáveis de view associadas. Particularmente útil são os vários
:ref:`helpers marcadores <zend.view.helpers.initial.placeholder>`, que permitem a você recuperar conteúdo para
áreas tais como a seção <head>, navegação, etc.:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <?php echo $this->headTitle() ?>
       <?php echo $this->headScript() ?>
       <?php echo $this->headStyle() ?>
   </head>
   <body>
       <?php echo $this->render('header.phtml') ?>

       <div id="nav"><?php echo $this->placeholder('nav') ?></div>

       <div id="content"><?php echo $this->layout()->content ?></div>

       <?php echo $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

Usando Zend_Layout com o MVC do Zend Framework
----------------------------------------------

``Zend_Controller`` oferece um rico conjunto de funcionalidades para extensão por meio de seus :ref:`front
controller plugins <zend.controller.plugins>` e :ref:`action controller helpers <zend.controller.actionhelpers>`.
``Zend_View`` também tem :ref:`helpers <zend.view.helpers>`. ``Zend_Layout`` toma vantagem desses diversos pontos
de extensão quando usado com os componentes *MVC*.

``Zend_Layout::startMvc()`` cria uma instância de ``Zend_Layout`` com qualquer configuração opcional que você
fornecer. Ele registra então um front controller plugin que renderiza o layout com qualquer conteúdo de
aplicação uma vez que o laço de despacho foi feito, e registra um action helper para permitir o acesso ao objeto
layout a partir de seus action controllers. Adicionalmente, você pode a qualquer tempo pegar a instância de
dentro de um view script usando o view helper *layout*.

Primeiro, dê uma olhada em como inicializar ``Zend_Layout`` para uso com o *MVC*:

.. code-block:: php
   :linenos:

   // Em seu bootstrap:
   Zend_Layout::startMvc();

``startMvc()`` pode tomar uma matriz opcional de opções ou um objeto ``Zend_Config`` para customizar a
instância; essas opções são detalhadas na :ref:` <zend.layout.options>`.

Em um action controller, você pode então acessar a instância de layout como um action helper:

.. code-block:: php
   :linenos:

   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // desabilita layouts para este action:
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // usa um script de layout diferente com este action:
           $this->_helper->layout->setLayout('foobaz');
       };
   }

Em seus view scripts, você pode então acessar o objeto de *layout* via view helper layout. Esse view helper é
levemente diferente dos outros no que toca a não tomar argumentos, e retornar um objeto ao invés de um valor
string. Isso permite que você imediatamente chame métodos no objeto de layout:

.. code-block:: php
   :linenos:

   <?php $this->layout()->setLayout('foo'); // configura layout alternativo ?>

A qualquer tempo, você pode buscar a instância de ``Zend_Layout`` registrada com *MVC* via método estático
``getMvcInstance()``:

.. code-block:: php
   :linenos:

   // Retorna null se startMvc() não foi o primeiro a ser chamado
   $layout = Zend_Layout::getMvcInstance();

Finalmente, o front controller plugin de ``Zend_Layout`` tem uma importante característica em adição a
renderização do layout: ele recupera todos os segmentos nomeados do objeto de resposta e associa variáveis,
associando o segmento 'default' a variável 'content'. Isso permite a você acessar o conteúdo de sua aplicação
e renderizá-lo em seus view scripts.

Como um exemplo, diremos que seu código primeiro ativa ``FooController::indexAction()``, que renderiza algum
conteúdo para o segmento de resposta padrão, e então prossegue para ``NavController::menuAction()``, que
renderiza conteúdo para o segmento de resposta 'nav'. Finalmente, você prossegue para
``CommentController::fetchAction()`` e busca alguns comentários, mas renderizar isso para o segmento de resposta
é bom (o que adiciona conteúdo aquele segmento). Seu view script poderia então renderizar cada um separadamente:

.. code-block:: php
   :linenos:

   <body>
       <!-- renders /nav/menu -->
       <div id="nav"><?php echo $this->layout()->nav ?></div>

       <!-- renders /foo/index + /comment/fetch -->
       <div id="content"><?php echo $this->layout()->content ?></div>
   </body>

Essa característica é particularmente útil quando usada em conjunção com o :ref:`action helper
<zend.controller.actionhelpers.actionstack>` e :ref:`plugin <zend.controller.plugins.standard.actionstack>`
ActionStack, o qual você pode usar para configurar uma pilha de ações através da qual itertamos, e então
criamos páginas widgetizadas.

.. _zend.layout.quickstart.standalone:

Usando Zend_Layout como um Componente
-------------------------------------

Como um componente autônomo, ``Zend_Layout`` não oferece tantas características ou tanta conveniência como
quanto é usado com o *MVC*. Entretanto, ele ainda tem dois benefícios a destacar:

- Escopo de variáveis de layout.

- Isolamento do view script de layout de outros scripts view.

Quando usado como um componente autônomo, simplesmente inicie o objeto layout, use os vários acessores para
configurar estado, configure variáveis como propriedades de objeto, e renderize o layout:

.. code-block:: php
   :linenos:

   $layout = new Zend_Layout();

   // Configura um caminho de script de layout:
   $layout->setLayoutPath('/path/to/layouts');

   // Configura algumas variáveis:
   $layout->content = $content;
   $layout->nav     = $nav;

   // Escolhe um script de layout diferente:
   $layout->setLayout('foo');

   // Renderiza o layout final
   echo $layout->render();

.. _zend.layout.quickstart.example:

Exemplo de Layout
-----------------

Algumas vezes uma imagem vale mais que mil palavras. A seguir temos um exemplo de um script de layout.

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

A ordem real dos elementos pode variar, dependendo do *CSS* que você tenha configurado; por exemplo, se você
está usando posicionamento absoluto, você pode ser capaz de ter a navegação exibida mais tarde no documento,
mas ainda mostrar-se no topo; o mesmo poderia ser dito para a barra lateral ou o cabeçalho. A mecânica real de
puxar o conteúdo permanece a mesma, entretanto.


