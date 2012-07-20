.. _zend.tool.framework.writing-providers:

Zend_Tool_Frameworkを利用してプロバイダを作成する
==================================

一般的に、プロバイダそれ自体は、
コマンドラインでクライアント（またはそれ以外）をディスパッチすることを求めるいくらかの能力をバンドルするための、
開発者のためのシェル以外の何物でもありません。 *MVC*\
アプリケーションの中での「コントローラ」と似ています。

.. _zend.tool.framework.writing-providers.loading:

Zend_Tool はどのようにプロバイダを見つけるか
---------------------------

By default ``Zend_Tool`` uses the IncludePathLoader to find all the providers that you can run. It recursivly
iterates all include path directories and opens all files that end with "Manifest.php" or "Provider.php". All
classes in these files are inspected if they implement either ``Zend_Tool_Framework_Provider_Interface`` or
``Zend_Tool_Framework_Manifest_ProviderManifestable``. Instances of the provider interface make up for the real
functionality and all their public methods are accessible as provider actions. The ProviderManifestable interface
however requires the implementation of a method ``getProviders()`` which returns an array of instantiated provider
interface instances.

The following naming rules apply on how you can access the providers that were found by the IncludePathLoader:

- The last part of your classname split by underscore is used for the provider name, e.g. "My_Provider_Hello" leads
  to your provider being accessible by the name "hello".

- If your provider has a method ``getName()`` it will be used instead of the previous method to determine the name.

- If your provider has "Provider" as prefix, e.g. it is called ``My_HelloProvider`` it will be stripped from the
  name so that the provider will be called "hello".

.. note::

   The IncludePathLoader does not follow symlinks, that means you cannot link provider functionality into your
   include paths, they have to be physically present in the include paths.

.. _zend.tool.framework.writing-providers.loading.example:

.. rubric:: Exposing Your Providers with a Manifest

You can expose your providers to ``Zend_Tool`` by offering a manifest with a special filename ending with
"Manifest.php". A Provider Manifest is an implementation of the
``Zend_Tool_Framework_Manifest_ProviderManifestable`` and requires the ``getProviders()`` method to return an array
of instantiated providers. In anticipation of our first own provider ``My_Component_HelloProvider`` we will create
the following manifest:

.. code-block:: php
   :linenos:

   class My_Component_Manifest
       implements Zend_Tool_Framework_Manifest_ProviderManifestable
   {
       public function getProviders()
       {
           return array(
               new My_Component_HelloProvider()
           );
       }
   }

.. _zend.tool.framework.writing-providers.basic:

プロバイダを作成するための基本命令
-----------------

例えば、サード・パーティのコンポーネントが働かせる
データファイルのバージョンを示す能力を開発者が加えたければ、
開発者が実装する必要があるクラスが１つだけあります。 もしコンポーネントが
``My_Component``\ と呼ばれるなら、 ``include_path``\ 上のどこかに ``HelloProvider.php``\
という名前のファイルで ``My_Component_HelloProvider``\
という名のクラスを作成するでしょう。 このクラスは
``Zend_Tool_Framework_Provider_Interface``\ を実装します、
そして、このファイルの本体は以下のように見えなければならないだけです:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say()
       {
           echo 'Hello from my provider!';
       }
   }

上記のコードが与えられて、
コンソール・クライアントを通じて開発者がこの機能にアクセスしたけれ、
呼び出しはこのように見えるでしょう:

.. code-block:: sh
   :linenos:

   % zf say hello
   Hello from my provider!

.. _zend.tool.framework.writing-providers.response:

レスポンスオブジェクト
-----------

As discussed in the architecture section ``Zend_Tool`` allows to hook different clients for using your
``Zend_Tool`` providers. To keep compliant with different clients you should use the response object to return
messages from your providers instead of using ``echo()`` or a similiar output mechanism. Rewritting our hello
provider with this knowledge it looks like:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $this->_registry->getResponse
                           ->appendContent("Hello from my provider!");
       }
   }

As you can see one has to extend the ``Zend_Tool_Framework_Provider_Abstract`` to gain access to the Registry which
holds the ``Zend_Tool_Framework_Client_Response`` instance.

.. _zend.tool.framework.writing-providers.advanced:

先進の開発情報
-------

.. _zend.tool.framework.writing-providers.advanced.variables:

プロバイダに変数を渡す
^^^^^^^^^^^

上記の例の "Hello World" は、単純なコマンドとして有名です、
しかし、より進んだ何かについてはどうでしょうか？
スクリプトを書くこととツーリングの必要性が高まるにつれ、
変数を扱う能力を必要とすると気付くかもしれません。
だいたいのファンクション・シグニチャにはパラメータがあるように、
ツーリング・リクエストはパラメータを受け入れることもできます。

各々のツーリング・リクエストがクラス内でメソッドに分離されることができると、
ツーリング・リクエストのパラメータはきわめて周知の立場で分離されることもできます。
プロバイダのアクション・メソッドのパラメータは、
クライアントがそのプロバイダとアクションの組合せを呼ぶとき、
利用することを望む同じパラメータを含むことができます。
たとえば、あなたが上記の例で名前を扱いたいならば、
あなたは多分オブジェクト指向コードでこうするでしょう:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           echo 'Hello' . $name . ', from my provider!';
       }
   }

それから上記の例は、コマンドライン ``zf say hello Joe``\
によって呼ぶことができます。 "Joe"
は、メソッド呼び出しのパラメータとして、プロバイダに供給されます。
また注意すべきこととして、 パラメータが任意だとあなたがわかるように、 ``zf say
hello``\ がさらに機能して、名前 "Ralph" にデフォルト設定するように、
コマンドライン上で選択できることを意味します。

.. _zend.tool.framework.writing-providers.advanced.prompt:

Prompt the User for Input
^^^^^^^^^^^^^^^^^^^^^^^^^

There are cases when the workflow of your provider requires to prompt the user for input. This can be done by
requesting the client to ask for more the required input by calling:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say($name = 'Ralph')
       {
           $nameResponse = $this->_registry
                                ->getClient()
                                ->promptInteractiveInput("Whats your name?");
           $name = $nameResponse->getContent();

           echo 'Hello' . $name . ', from my provider!';
       }
   }

This command throws an exception if the current client is not able to handle interactive requests. In case of the
default Console Client however you will be asked to enter the name.

.. _zend.tool.framework.writing-providers.advanced.pretendable:

プロバイダ・アクションを実行するための擬態
^^^^^^^^^^^^^^^^^^^^^

あなたが実装したいかもしれないもう一つの面白い特徴は、 **擬態性**\ です。
擬態性は、
まるでそれがリクエストされたアクションとプロバイダの組み合わせを実行しているように擬態して、
実際にそれを実行せずに、それが実行するで **あろう**\
ことについて沢山の情報をユーザーに与えることを
プロバイダでできるようにします。
これ以外の場合にはユーザーが実行したくないかもしれない重いデータベースや、
ファイルシステム修正をするときに重要な小道具であるかもしれません。

擬態性は簡単に実装できます。 このフィーチャーには2つの要素があります: 1)
プロバイダが「擬態する」能力を持つことを示します。 2)
現在のリクエストが本当に、
「擬態する」よう要求されたことを確実にするために、リクエストをチェックします。
このフィーチャーは下記のコードサンプルで示されます。

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends    Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Pretendable
   {
       public function say($name = 'Ralph')
       {
           if ($this->_registry->getRequest()->isPretend()) {
               echo 'I would say hello to ' . $name . '.';
           } else {
               echo 'Hello' . $name . ', from my provider!';
           }
       }
   }

擬態モードでプロバイダを実行してちょっと呼び出し

.. code-block:: sh
   :linenos:

   % zf --pretend say hello Ralph
   I would say hello Ralph.

.. _zend.tool.framework.writing-providers.advanced.verbosedebug:

冗長及びデバッグモード
^^^^^^^^^^^

You can also run your provider actions in "verbose" or "debug" modes. The semantics in regard to this actions have
to be implemented by you in the context of your provider. You can access debug or verbose modes with:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           if($this->_registry->getRequest()->isVerbose()) {
               echo "Hello::say has been called\n";
           }
           if($this->_registry->getRequest()->isDebug()) {
               syslog(LOG_INFO, "Hello::say has been called\n");
           }
       }
   }

.. _zend.tool.framework.writing-providers.advanced.configstorage:

ユーザーの構成及びストレージにアクセス
^^^^^^^^^^^^^^^^^^^

Using the Enviroment variable ``ZF_CONFIG_FILE`` or the .zf.ini in your home directory you can inject configuration
parameters into any ``Zend_Tool`` provider. Access to this configuration is available via the registry that is
passed to your provider if you extend ``Zend_Tool_Framework_Provider_Abstract``.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $username = $this->_registry->getConfig()->username;
           if(!empty($username)) {
               echo "Hello $username!";
           } else {
               echo "Hello!";
           }
       }
   }

The returned configuration is of the type ``Zend_Tool_Framework_Client_Config`` but internally the ``__get`` and
``__set`` magic methods proxy to a ``Zend_Config`` of the given configuration type.

The storage allows to save arbitrary data for later reference. This can be useful for batch processing tasks or for
re-runs of your tasks. You can access the storage in a similar way like the configuration:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $aValue = $this->_registry->getStorage()->get("myUsername");
           echo "Hello $aValue!";
       }
   }

ストレージ *API* はとても簡単です。

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Client_Storage
   {
       public function setAdapter($adapter);
       public function isEnabled();
       public function put($name, $value);
       public function get($name, $defaultValue=null);
       public function has($name);
       public function remove($name);
       public function getStreamUri($name);
   }

.. important::

   When designing your providers that are config or storage aware remember to check if the required user-config or
   storage keys really exist for a user. You won't run into fatal errors when none of these are provided though,
   since empty ones are created upon request.


