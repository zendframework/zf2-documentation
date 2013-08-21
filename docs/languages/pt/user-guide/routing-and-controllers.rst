.. EN-Revision: 96c6ad3
.. _user-guide.routing-and-controllers:

Roteamento e Controladores
==========================

Nos vamos construir um inventário bastante simples para exibir nossa coleção de
albuns. A página incial irá listar a coleção e permitir a inclusão, edição e
exclusão de albuns. Para isso as seguintes páginas serão necessárias:

+---------------+-------------------------------------------------------------+
| Página        | Descrição                                                   |
+===============+=============================================================+
| Inicial       | Essa página irá exibir a lista de albuns e disponibilizar   |
|               | os links para edita-los e deleta-los. Também irá            |
|               | disponibilizar um link para a criação de novos albuns.      |
+---------------+-------------------------------------------------------------+
| Inlcuir album | Essa página ira conter um formulário para inclusão de album.|
+---------------+-------------------------------------------------------------+
| Editar album  | Essa página ira conter um formulário para edição de album.  |
+---------------+-------------------------------------------------------------+
| Excluir album | Essa página irá confirmar que nos queremos excluir um album |
|               | e então realizar a exclusão.                                |
+---------------+-------------------------------------------------------------+

Antes de configurar nossos arquivos, é importante entender como o framework
espera que as páginas sejam organizadas. Cada página da aplicação é conhecida
como uma *action* e ações são agrupadas em *controllers* dentro de *modules*.
Dessa forma você irá geralmente agrupar ações em um controller, por exemplo, um
controller de notícias deve ter as ações ``atual``, ``arquivada`` e ``visualizar``.

Como nos termos quatro páginas e todas elas são relativas aos albuns, nos iremos
agrupá-las em um mesmo controller ``AlbumController`` dentro do nosso módulo
``Album`` como quatro ações. As quatro ações serão:

+---------------+---------------------+------------+
| Página        | Controller          | Action     |
+===============+=====================+============+
| Inicial       | ``AlbumController`` | ``index``  |
+---------------+---------------------+------------+
| Incluir album | ``AlbumController`` | ``add``    |
+---------------+---------------------+------------+
| Editar album  | ``AlbumController`` | ``edit``   |
+---------------+---------------------+------------+
| Excluir album | ``AlbumController`` | ``delete`` |
+---------------+---------------------+------------+

O mapeamento da URL para uma acão em particular é feito usando rotas que são
definidas no arquivo ``module.config.php`` do módulo. Nos iremos adicionar uma
rota para as ações dos albuns. Esse é o arquivo de configuração do módulo
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

O nome da rota é ‘album’ e seu tipo é ‘segment’. Uma rota de Seguimento nos permite
especificar variáveis na rota que serão mapeadas para parametros na rota correspondente.
Nesse caso, a rota é **``/album[/:action][/:id]``** que irá corresponder a qualquer URL
que comece com ``/album``. O resto do seguimento será uma ação opcional e finalmente
o último seguimento será mapeado para um id opcional. Os colchetes indicam que um
seguimento é opcional. a seção ``constraints`` permite que nós certifiquemos que um
seguimento é como esperado, por isso limitamos as ações a começar com uma letra e ter
caracteres alfanuméricos, underscores ou hifens em seguida. Nos também limitamos o id
à números.

Essa rota nos permite mapear as seguintes URLs:

+---------------------+------------------------------+------------+
| URL                 | Página                       | Ação       |
+=====================+==============================+============+
| ``/album``          | Inicial (lista de albuns)    | ``index``  |
+---------------------+------------------------------+------------+
| ``/album/add``      | Incluir novo album           | ``add``    |
+---------------------+------------------------------+------------+
| ``/album/edit/2``   | Editar album com id 2        | ``edit``   |
+---------------------+------------------------------+------------+
| ``/album/delete/4`` | Excluir album com id 4       | ``delete`` |
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
    para os controller além do fato de eles terem que implementar a inteface
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

Nos acavamos de configurara as quatro ações que nos queremos usar. Elas não funionam
até que nos configuremos as views. As URLs para cada ação são:

+--------------------------------------------+----------------------------------------------------+
| URL                                        | Metodo chamado                                     |
+============================================+====================================================+
| http://zf2-tutorial.localhost/album        | ``Album\Controller\AlbumController::indexAction``  |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/add    | ``Album\Controller\AlbumController::addAction``    |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/edit   | ``Album\Controller\AlbumController::editAction``   |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/delete | ``Album\Controller\AlbumController::deleteAction`` |
+--------------------------------------------+----------------------------------------------------+

Nos agora temos um roteamoento funionando e as ações coniguradas para cada página da
nossa aplicação.

É hora de contruirmos as camadas de View e Model.

Inicializando os arquivos de view
---------------------------------

Para integrar as views na nossa aplicação tudo que precisamos fazer é criar alguns
arquivos de views. Esses arquivos serão executados pelo ``DefaultViewStrategy`` que
irá passar qualquer variável ou ``view models`` que forem retornados pelos métodos
de ação do controller. Esses arquivos de views serão armazenados no diretório ``views``
do nosso módulo dentro de um subsiretório com o nome do controller. Crie agora esses
quatro arquivos vazios:

* ``module/Album/view/album/album/index.phtml``
* ``module/Album/view/album/album/add.phtml``
* ``module/Album/view/album/album/edit.phtml``
* ``module/Album/view/album/album/delete.phtml``

Nos agora poderemos comerçar a preenche-los, começando com o banco de dados e os models.
