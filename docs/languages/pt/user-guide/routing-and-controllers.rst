.. EN-Revision: 96c6ad3
.. _user-guide.routing-and-controllers:

Roteamento e Controladores
==========================

Nos vamos construir um inventário bastante simples para exibir nossa coleção de
álbuns. A página inicial irá listar a coleção e permitir a inclusão, edição e
exclusão de álbuns. Para isso as seguintes páginas serão necessárias:

+---------------+-------------------------------------------------------------+
| Página        | Descrição                                                   |
+===============+=============================================================+
| Inicial       | Essa página irá exibir a lista de álbuns e disponibilizar   |
|               | os links para editá-los e deletá-los. Também irá            |
|               | disponibilizar um link para a criação de novos álbuns.      |
+---------------+-------------------------------------------------------------+
| Incluir álbum | Essa página irá conter um formulário para inclusão de álbum.|
+---------------+-------------------------------------------------------------+
| Editar álbum  | Essa página irá conter um formulário para edição de álbum.  |
+---------------+-------------------------------------------------------------+
| Excluir álbum | Essa página irá confirmar que nós queremos excluir um álbum |
|               | e então realizar a exclusão.                                |
+---------------+-------------------------------------------------------------+

Antes de configurar nossos arquivos, é importante entender como o framework
espera que as páginas sejam organizadas. Cada página da aplicação é conhecida
como uma *action* e ações são agrupadas em *controllers* dentro de *modules*.
Dessa forma você irá geralmente agrupar ações em um controller, por exemplo, um
controller de notícias deve ter as ações ``atual``, ``arquivada`` e ``visualizar``.

Como nos temos quatro páginas e todas elas são relativas aos álbuns, nos iremos
agrupá-las em um mesmo controller ``AlbumController`` dentro do nosso módulo
``Album`` como quatro ações. As quatro ações serão:

+---------------+---------------------+------------+
| Página        | Controller          | Action     |
+===============+=====================+============+
| Inicial       | ``AlbumController`` | ``index``  |
+---------------+---------------------+------------+
| Incluir álbum | ``AlbumController`` | ``add``    |
+---------------+---------------------+------------+
| Editar álbum  | ``AlbumController`` | ``edit``   |
+---------------+---------------------+------------+
| Excluir álbum | ``AlbumController`` | ``delete`` |
+---------------+---------------------+------------+

O mapeamento da URL para uma ação em particular é feito usando rotas que são
definidas no arquivo ``module.config.php`` do módulo. Nos iremos adicionar uma
rota para as ações dos álbuns. Esse é o arquivo de configuração do módulo
atualizado com o novo código em destaque.

.. code-block:: php
    :emphasize-lines: 9-27

    <?php
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),

        // A seção a seguir é nova e deve ser adicionada ao arquivo
        'router' => array(
            'routes' => array(
                'album' => array(
                    'type'    => 'segment',
                    'options' => array(
                        'route'    => '/album[/][:action][/:id]',
                        'constraints' => array(
                            'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                            'id'     => '[0-9]+',
                        ),
                        'defaults' => array(
                            'controller' => 'Album\Controller\Album',
                            'action'     => 'index',
                        ),
                    ),
                ),
            ),
        ),

        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

O nome da rota é ‘album’ e seu tipo é ‘segment’. Uma rota de seguimento nos permite
especificar variáveis na rota que serão mapeadas para parâmetros na rota correspondente.
Nesse caso, a rota é **``/album[/:action][/:id]``** que irá corresponder a qualquer URL
que comece com ``/album``. O resto do seguimento será uma ação opcional e finalmente
o último seguimento será mapeado para um id opcional. Os colchetes indicam que um
seguimento é opcional. A seção ``constraints`` permite que nós certifiquemos que um
seguimento é como esperado, por isso limitamos as ações a começar com uma letra e ter
caracteres alfanuméricos, underscores ou hifens em seguida. Nos também limitamos o id
à números.

Essa rota nos permite mapear as seguintes URLs:

+---------------------+------------------------------+------------+
| URL                 | Página                       | Ação       |
+=====================+==============================+============+
| ``/album``          | Inicial (lista de álbuns)    | ``index``  |
+---------------------+------------------------------+------------+
| ``/album/add``      | Incluir novo álbum           | ``add``    |
+---------------------+------------------------------+------------+
| ``/album/edit/2``   | Editar álbum com id 2        | ``edit``   |
+---------------------+------------------------------+------------+
| ``/album/delete/4`` | Excluir álbum com id 4       | ``delete`` |
+---------------------+------------------------------+------------+

Criando o Controlador
=====================

Nos agora estamos prontos para configurar nosso controller. No Zend Framework 2, o
controller é uma classe que geralmente é chamada de ``{Controller name}Controller``.
Note que ``{Controller name}`` deve começar com uma letra maiúscula.  Essa classe deve
estar dentro de um arquivo chamado ``{Controller name}Controller.php`` no diretório
``Controller`` do seu módulo. No nosso caso isso é ``module/Album/src/Album/Controller``.
Cada ação é um método público dentro da classe controller nomeado como
``{action name}Action``. Nesse caso ``{action name}`` deve começar com letra minúscula.

.. note::

    Isso acontece por convenção. O Zend Framework 2 não possui muitas restrições
    para os controller além do fato de eles terem que implementar a interface
    ``Zend\Stdlib\Dispatchable``. O framework disponibiliza duas classes abstratas
    que fazem isso para nos: ``Zend\Mvc\Controller\AbstractActionController``
    e ``Zend\Mvc\Controller\AbstractRestfulController``. Nos iremos usar o padrão
    ``AbstractActionController``, mas se você pretende escrever uma aplicação
    RESTful, ``AbstractRestfulController`` pode ser útil.

Vamos seguir em frente e criar nossa classe controller ``AlbumController.php`` em
``zf2-tutorials/module/Album/src/Album/Controller``:

.. code-block:: php

    <?php
    namespace Album\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class AlbumController extends AbstractActionController
    {
        public function indexAction()
        {
        }

        public function addAction()
        {
        }

        public function editAction()
        {
        }

        public function deleteAction()
        {
        }
    }

.. note::

    Nos já informamos o modulo sobre nosso controller na seção 
    ‘controller’ do arquivo ``module/Album/config/module.config.php``.

Nós acabamos de configurar as quatro ações que nós queremos usar. Elas não funcionam
até que nos configuremos as views. As URLs para cada ação são:

+--------------------------------------------+----------------------------------------------------+
| URL                                        | Método chamado                                     |
+============================================+====================================================+
| http://zf2-tutorial.localhost/album        | ``Album\Controller\AlbumController::indexAction``  |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/add    | ``Album\Controller\AlbumController::addAction``    |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/edit   | ``Album\Controller\AlbumController::editAction``   |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/delete | ``Album\Controller\AlbumController::deleteAction`` |
+--------------------------------------------+----------------------------------------------------+

Nós agora temos um roteamento funcionando e as ações configuradas para cada página da
nossa aplicação.

É hora de construirmos as camadas de View e Model.

Inicializando os arquivos de view
---------------------------------

Para integrar as views na nossa aplicação tudo que precisamos fazer é criar alguns
arquivos de views. Esses arquivos serão executados pelo ``DefaultViewStrategy`` que
irá passar qualquer variável ou ``view models`` que forem retornados pelos métodos
de ação do controller. Esses arquivos de views serão armazenados no diretório ``views``
do nosso módulo, dentro de um subdiretório com o nome do controller. Crie agora esses
quatro arquivos vazios:

* ``module/Album/view/album/album/index.phtml``
* ``module/Album/view/album/album/add.phtml``
* ``module/Album/view/album/album/edit.phtml``
* ``module/Album/view/album/album/delete.phtml``

Nos agora poderemos começar a preenchê-los, começando com o banco de dados e os models.
