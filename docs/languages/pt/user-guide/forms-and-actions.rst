.. _user-guide-forms-and-actions:

Fomularios e Ações
==================

Adicionando novos Albuns
------------------------

Nos agora podemos programar as funcionlidades de adição de novos albuns.
Existem dois itens nessa parte:

* Mostrar um formulário para que o usuário possa fornecer as informações
* Processar os dados do formulário e salva-los no banco de dados

Nos iremos usar ``Zend\Form`` para isso. O Componente ``Zend\Form`` gerencia os
formulario e a validação dos dados do formulário Atraves da adição de um 
``Zend\InputFilter`` a nossa entidade ``Album``. Mas iremos começar criando
uma nova classe ``Album\Form\AlbumForm`` que extenda ``Zend\Form\Form``
para definir nosso formulário. Crie um arquivo chamado ``AlbumForm.php`` em
``module/Album/src/Album/Form``:

.. code-block:: php

    <?php
    namespace Album\Form;

    use Zend\Form\Form;

    class AlbumForm extends Form
    {
        public function __construct($name = null)
        {
            // Nos iremos ignorar o nome passado
            parent::__construct('album');
            $this->setAttribute('method', 'post');
            $this->add(array(
                'name' => 'id',
                'type' => 'Hidden',
            ));
            $this->add(array(
                'name' => 'title',
                'type' => 'Text',
                'options' => array(
                    'label' => 'Title',
                ),
            ));
            $this->add(array(
                'name' => 'artist',
                'type' => 'Text',
                'options' => array(
                    'label' => 'Artist',
                ),
            ));
            $this->add(array(
                'name' => 'submit',
                'type' => 'Submit',
                'attributes' => array(
                    'value' => 'Go',
                    'id' => 'submitbutton',
                ),
            ));
        }
    }

Dentro do construtor de ``AlbumForm`` nos fazemos varias coisas. Primeiro nos configuramos o nome do 
formulário atraves de uma chamada ao contrutor da classe pai. Nos então configuramos o método do formulário,
nesse caso ``post``. Finalmente nos criamos quatro elemntos: id, title, artist, e o botão submit. Para cada
um deles nos configuramos vários atributose opções incluindo o label que será exibido.

Nos também precisamos configurar as validações desse formulário. No Zend Framework 2 isso é feito usando
filtros de entrada que podem tanto funcionar de forma independente quanto ser definidos em qualquer classe
que implemente a interface ``InputFilterAwareInterface``, como uma entidade. No nosso caso nos iremos adicionar
os filtros de entrada na classe Album, que está armazenada no arquivo ``Album.php`` em ``module/Album/src/Album/Model``:

.. code-block:: php
    :emphasize-lines: 5-8,15,23-86

    <?php
    namespace Album\Model;

    // Adicione essas clausulas de importação
    use Zend\InputFilter\Factory as InputFactory;
    use Zend\InputFilter\InputFilter;
    use Zend\InputFilter\InputFilterAwareInterface;
    use Zend\InputFilter\InputFilterInterface;

    class Album implements InputFilterAwareInterface
    {
        public $id;
        public $artist;
        public $title;
        protected $inputFilter;                       // <-- Adicione essa variável

        public function exchangeArray($data)
        {
            $this->id     = (isset($data['id']))     ? $data['id']     : null;
            $this->artist = (isset($data['artist'])) ? $data['artist'] : null;
            $this->title  = (isset($data['title']))  ? $data['title']  : null;
        }

        // Adicione o conteúdo desses métodos
        public function setInputFilter(InputFilterInterface $inputFilter)
        {
            throw new \Exception("Not used");
        }

        public function getInputFilter()
        {
            if (!$this->inputFilter) {
                $inputFilter = new InputFilter();
                $factory     = new InputFactory();

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'id',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'Int'),
                    ),
                )));

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'artist',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'StripTags'),
                        array('name' => 'StringTrim'),
                    ),
                    'validators' => array(
                        array(
                            'name'    => 'StringLength',
                            'options' => array(
                                'encoding' => 'UTF-8',
                                'min'      => 1,
                                'max'      => 100,
                            ),
                        ),
                    ),
                )));

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'title',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'StripTags'),
                        array('name' => 'StringTrim'),
                    ),
                    'validators' => array(
                        array(
                            'name'    => 'StringLength',
                            'options' => array(
                                'encoding' => 'UTF-8',
                                'min'      => 1,
                                'max'      => 100,
                            ),
                        ),
                    ),
                )));

                $this->inputFilter = $inputFilter;
            }

            return $this->inputFilter;
        }
    }

A ``InputFilterAwareInterface`` define dois métodos: ``setInputFilter()`` e
``getInputFilter()``. Nos só precisamos implementar ``getInputFilter()`` então
nos simplesmente disparamos uma execção em ``setInputFilter()``.

No método ``getInputFilter()``, nos instanciamos um ``InputFilter`` e depois
adicionamos os campos que no precisamos. Nos adicionamos um campo para cada
propriedade que quisermos filtrar e/ou validade. Para op campo ``id`` nos
adicionamos um filtro ``Int`` já queos só queremos inteiros. Para os elementos
textuais nos iremos adicionar dois filtros, ``StripTags`` e ``StringTrim``,
para remover código HTML não desejado e caracteres de espaço desnecessários.
Nos também os configuramos para sere obrigatórios e adicionamos um validador
``StringLength`` para garantir que o usuário não tenha mais caracteres do que
podemos armazenar no nosso banco de dados.

Nos precisamos acessar o formulário para exibi-lo e então processar a submissão.
Isso é feito na ``addAction()`` do ``AlbumController``:

.. code-block:: php
    :emphasize-lines: 6-7,10-31

    // module/Album/src/Album/Controller/AlbumController.php:

    //...
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    use Album\Model\Album;          // <-- Add this import
    use Album\Form\AlbumForm;       // <-- Add this import
    //...

        // Adicione o conteúdo no seguinte método
        public function addAction()
        {
            $form = new AlbumForm();
            $form->get('submit')->setValue('Add');

            $request = $this->getRequest();
            if ($request->isPost()) {
                $album = new Album();
                $form->setInputFilter($album->getInputFilter());
                $form->setData($request->getPost());

                if ($form->isValid()) {
                    $album->exchangeArray($form->getData());
                    $this->getAlbumTable()->saveAlbum($album);

                    // Redirect to list of albums
                    return $this->redirect()->toRoute('album');
                }
            }
            return array('form' => $form);
        }
    //...

Depois de adicionar ``AlbumForm`` na lista de objetos a serem usados, nos implementamos
``addAction()``. Vamos agora dar uma olhada no código de ``addAction()`` em mais detalhes:

.. code-block:: php

    $form = new AlbumForm();
    $form->get('submit')->setValue('Add');

Nós instanciamos ``AlbumForm`` e então configuramos o lavel do botão de envio como “Add”
(N.T. "Adicionar" do inglês "Add"). Nos fazemos isso aqui já que queremos reutilizar
o mesmo formulário para a edição do album onde iremos utilizar um label diferente
a different label.

.. code-block:: php

    $request = $this->getRequest();
    if ($request->isPost()) {
        $album = new Album();
        $form->setInputFilter($album->getInputFilter());
        $form->setData($request->getPost());
        if ($form->isValid()) {

Se o método ``isPost()`` do objeto ``Request`` retornar true (N.T. "Verdadeiro"), isso
significa que o formulário foi submetido e por isso nos queremos que o configurar o filtro
de valores do  formulário partindo de uma instancia de album. Nos então passamos os valores
enviados para o formulário e verificamos se esses valores são validos ustilizando o método
``isValid()`` do objeto do formulario.

.. code-block:: php

    $album->exchangeArray($form->getData());
    $this->getAlbumTable()->saveAlbum($album);

Se os dados forem validos, nos pegamos os dados já filtrados do formulário e armazenamos no
model usando o método``saveAlbum()``.

.. code-block:: php

    // Redireciona para a lista de albuns
    return $this->redirect()->toRoute('album');

Depois de salvar a nova linha de album, nos redirecionamos de volta para a lista de albuns
usando o plugin ``Redirect`` do controller.

.. code-block:: php

    return array('form' => $form);

Finalmente nos retornamos a variável que desejamos para a view. Nesse caso somente o objeto
do formulário. Note que o Zend Framework 2 também permite que retornemos um array contendo
as variáveis que serão atribuidas a view e ele irá criar um ``ViewModel`` por tras dos panos
para você. isso reduz um pouco o código necessário.

Nos agora precisamos renderizar o formulario no nosso arquivo add.phtml:

.. code-block:: php

    <?php
    // module/Album/view/album/album/add.phtml:

    $title = 'Add new album';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>
    <?php
    $form = $this->form;
    $form->setAttribute('action', $this->url('album', array('action' => 'add')));
    $form->prepare();

    echo $this->form()->openTag($form);
    echo $this->formHidden($form->get('id'));
    echo $this->formRow($form->get('title'));
    echo $this->formRow($form->get('artist'));
    echo $this->formSubmit($form->get('submit'));
    echo $this->form()->closeTag();

Novamente nos exibimos um titulo como anteriormente e depois nos renderizamos o formulario.
O Zend Framework possui alguns métodos auxiliares ("helpers") para tornar isso um pouco mais
fácil. os objeto ``form()`` inclue métodos auxiliaresm como  ``openTag()`` e ``closeTag()``
que são usados para abrir e fechar o formulário. Depois para cada elemento nos podemos utilizar
o método auxiliar ``formRow()``, mas para dois elementos específicos iremos usar ``formHidden()``
e ``formSubmit()``.

.. image:: ../images/user-guide.forms-and-actions.add-album-form.png
    :width: 940 px

Alternativamente o processo de renderização do formulário pode ser simplificado usando o
método  auxiliar , the process of rendering the form can be simplified by using the empacotado
``formCollection``.  nesse caso o exemplo anterior poderia ser interiamente substituido pela
seguinte instrução de renderização do formulário completo:

.. code-block:: php

    echo $this->formCollection($form);

Nota: Você ainda precisa chamar os métodos ``openTag`` e ``closeTag`` do formulário.  VocÊ subsititui
as outras instruções pela chamada ao método ``formCollection`` acima.

Isso irá iteragir pela estrutura do formulário chamando os labels elementos e métodos auxiliares apropriados
para cada elemento. mas você ainda ira precisar envolver formCollection($form) com as tags de abertura e
fechamento do formulário. Isso ajuda a reduzir a complexidade do seu arquivo de view em situações onde o
código HTML padrão do formulário é aceitável.

Você agora deve poder usar o link “Add new album” (N.T. Adicionar novo album) na página incial da aplicação
para adicionar um novo album à coleção.

Editando um Album
-----------------

Editar um album é praticamente identico a adicionar um novo, portanto o código também é muito similar.
Dessa vez iremos implementar a ``editAction()`` do ``AlbumController``:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    //...

        // Adicione conteúdo a esse método:
        public function editAction()
        {
            $id = (int) $this->params()->fromRoute('id', 0);
            if (!$id) {
                return $this->redirect()->toRoute('album', array(
                    'action' => 'add'
                ));
            }

            // Requisita um ALbum com id específico. Uma exceção é disparada caso
            // ele não seja encontrado, nesse caso redirecione para a págin incial.
            try {
                $album = $this->getAlbumTable()->getAlbum($id);
            }
            catch (\Exception $ex) {
                return $this->redirect()->toRoute('album', array(
                    'action' => 'index'
                ));
            }

            $form  = new AlbumForm();
            $form->bind($album);
            $form->get('submit')->setAttribute('value', 'Edit');

            $request = $this->getRequest();
            if ($request->isPost()) {
                $form->setInputFilter($album->getInputFilter());
                $form->setData($request->getPost());

                if ($form->isValid()) {
                    $this->getAlbumTable()->saveAlbum($album);

                    // Redireciona para a lista de albuns
                    return $this->redirect()->toRoute('album');
                }
            }

            return array(
                'id' => $id,
                'form' => $form,
            );
        }
    //...

Esse código deve parecer confortavelmente familiar. Vamos paenas olar as diferenças em relação a
inclusão de um novo album. Primeiramente, nos procuramos pelo ``id`` contido na rota correspondente
e usamos isso para carregar o albu para ser editado:

.. code-block:: php

    $id = (int) $this->params()->fromRoute('id', 0);
    if (!$id) {
        return $this->redirect()->toRoute('album', array(
            'action' => 'add'
        ));
    }

    // Requisita um ALbum com id específico. Uma exceção é disparada caso
    // ele não seja encontrado, nesse caso redirecione para a págin incial.
    try {
        $album = $this->getAlbumTable()->getAlbum($id);
    }
    catch (\Exception $ex) {
        return $this->redirect()->toRoute('album', array(
            'action' => 'index'
        ));
    }

``params`` é um plugin do controlador que contem métodos convenientes para requisitar
parametros da rota correspondente. Nos usamos isso para requisitar o ``id`` a partir da
rota criada no arquivo ``module.config.php`` do módulo. Se o ``id`` for igual a zero,
nos redirecionamos para a ação de inclusão de albuns, caso contrario, nos continuamos a 
solicitar a entidade do album do nosso banco de dados.

Nos temos que verificar para ter certeza que um album com esse ``id`` específico pode ser encontrado.
Se não for possível encontra-lo, caso não seja possível o método de acesso de dados irá disparar uma
exceção. Nós pegamos essa exceção e redirecionamos o usuário para a página inicial.

.. code-block:: php

    $form = new AlbumForm();
    $form->bind($album);
    $form->get('submit')->setAttribute('value', 'Edit');

O método ``bind()`` do formulario vincula o model com o formulário. Isso é usado de duas
formas:

* Quando exibimos o formulário o valor inicial de cado elemento é extraído do model.
* Depois de uma validação com sucesso no método isValid(), os dados do formulário são inseridos
  novamente no model.

Essas operações são feitas usando um objeto hydrator. Existem vário hydrator, mas o padrão é o
 ``Zend\Stdlib\Hydrator\ArraySerializable`` que espera encontrar dois métodos no model:
 ``getArrayCopy()`` e ``exchangeArray()``. Nos já escrevemos o método ``exchangeArray()`` na nossa
 entidade ``Album``, então só precisamos implementar ``getArrayCopy()``:

.. code-block:: php
    :emphasize-lines: 10-14

    // module/Album/src/Album/Model/Album.php:
    // ...
        public function exchangeArray($data)
        {
            $this->id     = (isset($data['id']))     ? $data['id']     : null;
            $this->artist = (isset($data['artist'])) ? $data['artist'] : null;
            $this->title  = (isset($data['title']))  ? $data['title']  : null;
        }

        // Adicione o seguinte método:
        public function getArrayCopy()
        {
            return get_object_vars($this);
        }
    // ...

Como resultado do uso de ``bind()`` com seu hydrator, nos não precisamos popular os dados do formulário
de volta no ``$album`` já que isso já foi feito, então nos podemos somente chamar o método ``saveAlbum()``
para armazenar as alterações no banco de dados.

O arquivo de view, ``edit.phtml``, irá se parecer bastante com aquele usado para adicionar um novo album:

.. code-block:: php

    <?php
    // module/Album/view/album/album/edit.phtml:

    $title = 'Edit album';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>

    <?php
    $form = $this->form;
    $form->setAttribute('action', $this->url(
        'album',
        array(
            'action' => 'edit',
            'id'     => $this->id,
        )
    ));
    $form->prepare();

    echo $this->form()->openTag($form);
    echo $this->formHidden($form->get('id'));
    echo $this->formRow($form->get('title'));
    echo $this->formRow($form->get('artist'));
    echo $this->formSubmit($form->get('submit'));
    echo $this->form()->closeTag();

As únicas mudanças são o uso do titulo ‘Edit Album’ e a mudança da ação do album para a
``editAction`` do nosso controller.

Nos agora devemos poder editar nossos albuns.

Deletando um Album
------------------

Para completar nossa aplicação nós precisamos adicionar a exclusão. Nós temos um link
para deletar próximo a cada um dos albuns na lista e o procedimento mais comum seria
deletar o album quando esse link fosse clicado. Isso seria errado, lembre-se das
especificações do protocolo HTTP quando eles dizem que não se deve realizar ações
irreversivas usando p método GET e que devemos usar POST no lugar.

Nos devemos mostrar um formulário de confirmação quando o usuário clicar em delete,
se então ele clicar em “yes” (N.T. "Sim" em inglês), nos realizamos a exclusão.
Como o formulário é bastante simples nos iremos codifica-lo diretamente na nossa view
 (``Zend\Form`` é, adinal de contas, opcional!).

Mas vamos começão implementando nossa ação em ``AlbumController::deleteAction()``:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    //...
        // Adicione conteúdo ao seguinte método
        public function deleteAction()
        {
            $id = (int) $this->params()->fromRoute('id', 0);
            if (!$id) {
                return $this->redirect()->toRoute('album');
            }

            $request = $this->getRequest();
            if ($request->isPost()) {
                $del = $request->getPost('del', 'No');

                if ($del == 'Yes') {
                    $id = (int) $request->getPost('id');
                    $this->getAlbumTable()->deleteAlbum($id);
                }

                // Redireciona para a lista de albuns
                return $this->redirect()->toRoute('album');
            }

            return array(
                'id'    => $id,
                'album' => $this->getAlbumTable()->getAlbum($id)
            );
        }
    //...

Como anteriormente nos pegamos o ``id`` a partir da rota correspondente e verificamos
se a requisição partiu de um método POST com ``isPost()`` para determinar se devemos
mostrar uma página de confirmação ou se já devemos deletar o album. Nos usamos o objeto
da tabela para deletar uma linha usadno o método ``deleteAlbum()`` e então redirecionamos
o usuário de volta para a lista de albuns. Caso a requisição não seja do tipo POST, nos 
então buscamos a linha correspondente na tabela e enviamos para a view juntamente com
seu ``id``.

O arquivo de view é um formulário simples:

.. code-block:: php

    <?php
    // module/Album/view/album/album/delete.phtml:

    $title = 'Delete album';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>

    <p>Are you sure that you want to delete
        '<?php echo $this->escapeHtml($album->title); ?>' by
        '<?php echo $this->escapeHtml($album->artist); ?>'?
    </p>
    <?php
    $url = $this->url('album', array(
        'action' => 'delete',
        'id'     => $this->id,
    ));
    ?>
    <form action="<?php echo $url; ?>" method="post">
    <div>
        <input type="hidden" name="id" value="<?php echo (int) $album->id; ?>" />
        <input type="submit" name="del" value="Yes" />
        <input type="submit" name="del" value="No" />
    </div>
    </form>

Nesse arquivo nós exibimos uma mensagem de confirmaçãopara o usuário junamente com um formulário
com os botões "Yes" e "No" (N.T. "Sim" e "Não" em inglês). Na ação nós iremos checar especificamente
pela opção "Yes" quando realizarmos a exclusão.

Garantindo que a página inicial exiba a lista de albuns
-------------------------------------------------------

Um ultimo ponto. No momento a página incial, http://zf2-tutorial.localhost/
não exibe a lista de albuns.

Isso acontece por causa da rota configurada no arquivo ``module.config.php``
do módulo ``Application``. Para alterar isso abra
``module/Application/config/module.config.php`` e enconte a rota "home":

.. code-block:: php

    'home' => array(
        'type' => 'Zend\Mvc\Router\Http\Literal',
        'options' => array(
            'route'    => '/',
            'defaults' => array(
                'controller' => 'Application\Controller\Index',
                'action'     => 'index',
            ),
        ),
    ),

Altere o ``controller`` de ``Application\Controller\Index`` para
``Album\Controller\Album``:

.. code-block:: php
    :emphasize-lines: 6

    'home' => array(
        'type' => 'Zend\Mvc\Router\Http\Literal',
        'options' => array(
            'route'    => '/',
            'defaults' => array(
                'controller' => 'Album\Controller\Album', // <-- change here
                'action'     => 'index',
            ),
        ),
    ),

É isso, você agora possui uma aplicação totalmente funcional!
