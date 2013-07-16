.. EN-Revision: 1a4ca34
.. _user-guide.modules:

Modulos
=======

O Zend Framework 2 usa um sistema modular atraves do qual você pode organizaro código 
principal específico da sua aplicação em cada módulo. O Módulo ``Application`` distribuido
com o ``Sekeleton`` é usado para a inicialização, gerenciamento de erros e configurações de
roteamento para toda a aplicação. Tmabém é geralmente usado pata prover Controllers no nível
da aplicação, como por exemplo a página incial dessa aplicação, mas nos não iremos usar esse
padrão no tutorial já que queremos que nossa lista de albuns seja nossa página incial, e ela
estará contida no nosso módulo. 

Nos iremos colocar todo o nosso código dentro do módulo ``Album`` que conterá nossos controllers,
modelos, formulários e views, juntamento com sua configuração Mas também iremos alterar o módulo
``Application`` quando necessário.

Vamos começar com a estrutura de diretórios necessária.

Configurando o Módulo de Album
------------------------------

Comece criando um diretório chamado ``Album`` dentro do diretório ``module`` com os seguintes
subdiretórios que irão conter os arquivos do módulo:

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /config
                /src
                    /Album
                        /Controller
                        /Form
                        /Model
                /view
                    /album
                        /album

Como você pode ver o módulo ``Album`` tem diretórios independentes para os direferentes
tipos de arquivos que teremos. Os arquivos PHP que contém as classes do Namespace ``Album``
ficam no diretório ``src/Album``, dessa forma podemos utilizar tantos Namespaces no nosso
módulo quanto precisarmos. O diretório de views também tem uma sub-pasta chamada ``album``
para os arquivos de view desse módulo.

Para carregar e configurar um módulo o Zend Framework 2 possui um
``ModuleManager``. Ele irá procurar pelo arquivo ``Module.php`` na raiz do diretório do seu
módulo (``module/Album``) e espera encontrar um calsse chamada ``Album\Module`` dentro dele.
Ou seja, as classes de cada módulo irão conter um namespace com o mesmo nome do módulo,
que também será o nome do diretório do módulo.

Portanto crie o arquivo ``Module.php`` no Módulo ``Album``:
Creie um arquivo chamado ``Module.php`` no diretório ``zf2-tutorial/module/Album`` com o
seguinte código:

.. code-block:: php

    <?php
    namespace Album;

    class Module
    {
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\ClassMapAutoloader' => array(
                    __DIR__ . '/autoload_classmap.php',
                ),
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    ),
                ),
            );
        }

        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

O ``ModuleManager`` irá chamar os métodos ``getAutoloaderConfig()`` e ``getConfig()``
automaticamente para nós.

Carregamento Automático de Arquivos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nosso método ``getAutoloaderConfig()`` retorna um array que é compatível com a 
``AutoloaderFactory`` do ZF2. Nós configuramos isso de forma que possamos adicionar um
arquivo com o mapa das classes para o ``ClassMapAutoloader`` (mapa de carregamento
automático de classes)e além disso adicionamos o namespace do módulo ao ``StandardAutoloader``
(Carregador automático padrão). O carregador automático padrão solicita um namespace e o 
caminho onde estão localizados os arquivos desse namespace. Ele é compatível com o PSR-0 
e por isso as classes são direcionadas automaticamente para os arquivos de acordo com as
regras do padrãp PSR-0 <https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.

Como estamos em ambiente de desenvolvimento nos não precisamos incluir as classes pelo mapa de
classes por isso nos iremos retornar apenas um array vazio paa o mapa de carregamento automático.
Crie um arquivo chamado ``autoload_classmap.php`` no diretório ``zf2-tutorial/module/Album``com o 
código:

.. code-block:: php

    <?php
    return array();

Como o array está vazio sempre que o ``autoloader`` procrar por um classe no namespace ``Album``
ele irá retornar pata o ``StandardAutoloader`` para nós.

.. note::

    Se você estiver usando Composer, você pode simplesmente criar um método
    ``getAutoloaderConfig() { }`` vazio e adcionar o seguinte código ao composer.json:

    .. code-block:: javascript

        "autoload": {
            "psr-0": { "Album": "module/Album/src/" }
        },

    Se você fizer dessa forma então terá que rodar ``php composer.phar update`` para atualizar os arquivos 
    de carregamento automático do composer.

Configuração
------------

Após ter registrado o carregamento automático vamos dar uma olhada rápida no método ``getConfig()`` 
do ``Album\Module`` . Esse método simplesmente carrega o arquivo ``config/module.config.php``.

Crie um arquivo chamado ``module.config.php`` no diretório ``zf2-tutorial/module/Album/config``:

.. code-block:: php

    <?php
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

A informação de configuração é passada para os componentes relevantes pelo
``ServiceManager``.  Nos iremos precisar de duas seções iniciais: ``controllers`` and
``view_manager``. A seção ``controllers`` prove uma lista de todos os controllers
disponíveis no módulo. Nos iremos precisar apenas de um controller, ``AlbumController``,
que iremos referenciar como ``Album\Controller\Album``. A chave do controller deve ser única
por todos os módulos, por isso nos a prefixamos com o nome do módulo.

Na seção ``view_manager``, nos inlcuimos nosso diretório de views na configuração
``TemplatePathStack``. Isso permitirá que os arquivos de view para o modulo ``Album`` sejam
econtrados dentro do nosso diretório ``view/``.

Informando a Aplicação sobre o Novo Módulo
------------------------------------------

Nós agora precisamos infromar ao ``ModuleManager`` (Gerenciador de Módulos) que nosso novo módulo
existe. Isso é feito no arquivo ``config/application.config.php`` da aplicação que está presente
na ``Aplicação Sekeleton``. Altere esse arquivo para incluir na seção ``modules`` o módulo 
``Album`` assim como os demais, dessa forma o arquivo ficará parecido com o seguinte:

(Alterações estão destacadas e com comentários.)

.. code-block:: php
    :emphasize-lines: 5

    <?php
    return array(
        'modules' => array(
            'Application',
            'Album',                  // <-- Adicione essa linha
        ),
        'module_listener_options' => array(
            'config_glob_paths'    => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                './module',
                './vendor',
            ),
        ),
    );

Como você pode ver nosa dicionamos o módulo ``Album`` na lista de módulos
depois do módulo ``Application``.

Nos acabamos de deixar nosso módulo pronto para receber nosso código específico.
