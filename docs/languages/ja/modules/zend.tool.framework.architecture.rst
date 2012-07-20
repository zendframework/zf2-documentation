.. _zend.tool.framework.architecture:

アーキテクチャ
=======

.. _zend.tool.framework.architecture.registry:

レジストリ
-----

``include_path``\
のどこからでもプロバイダとマニフェストが由来するかもしれないので、
ツール・チェーンのいろいろな部分へのアクセスを単純化するためにレジストリが提供されます。
このレジストリはレジストリを認識するコンポーネントに注入されます。
そして、それから必要に応じてそれは彼らから依存性を引き出すかもしれません。
レジストリで登録される依存性の多くは、下位-構成要素に特有のリポジトリです。

レジストリのためのインターフェースは、以下の定義から成ります。:

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Registry_Interface
   {
       public function setClient(Zend_Tool_Framework_Client_Abstract $client);
       public function getClient();
       public function setLoader(Zend_Tool_Framework_Loader_Abstract $loader);
       public function getLoader();
       public function setActionRepository(
           Zend_Tool_Framework_Action_Repository $actionRepository
       );
       public function getActionRepository();
       public function setProviderRepository(
           Zend_Tool_Framework_Provider_Repository $providerRepository
       );
       public function getProviderRepository();
       public function setManifestRepository(
           Zend_Tool_Framework_Manifest_Repository $manifestRepository
       );
       public function getManifestRepository();
       public function setRequest(Zend_Tool_Framework_Client_Request $request);
       public function getRequest();
       public function setResponse(Zend_Tool_Framework_Client_Response $response);
       public function getResponse();
   }

レジストリが管理するいろいろなオブジェクトは、それらに該当する部分で論じられます。

レジストリを認識しなければならないクラスは、
``Zend_Tool_Framework_Registry_EnabledInterface``\ を実行しなければなりません。
このインターフェースは、単に対象クラスだけでレジストリの初期化を可能にします。

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Registry_EnabledInterface
   {
       public function setRegistry(
           Zend_Tool_Framework_Registry_Interface $registry
       );
   }

.. _zend.tool.framework.architecture.providers:

プロバイダ
-----

``Zend_Tool_Framework_Provider``\ は、
フレームワークの機能または「能力」面を表現します。 基本的に、
``Zend_Tool_Framework_Provider``\ は
「プロバイダ」をもたらすために必要なインターフェース、 または
``Zend_Tool_Framework``\ ツール・チェーン内で呼ぶことができて、
使うことができる若干のツーリング機能を提供します。
このプロバイダ・インターフェースを実装することの割り切った性質によって、
開発者は機能/能力を「ワンストップサービス」で ``Zend_Tool_Framework``\
に加えることができます。

プロバイダ・インターフェースは空のインターフェースで、メソッドを強制しません。
（これは、マーカ・インターフェース・パターンです）:

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Provider_Interface
   {}

あるいは、もし望めば、 ``Zend_Tool_Framework_Registry``\ に
アクセスできるようにする基底（または抽象）プロバイダを実装できます。:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Interface,
                  Zend_Tool_Registry_EnabledInterface
   {
       protected $_registry;
       public function setRegistry(
           Zend_Tool_Framework_Registry_Interface $registry
       );
   }

.. _zend.tool.framework.architecture.loaders:

ローダ
---

ローダの目的は、 ``Zend_Tool_Framework_Provider_Interface``\ か
``Zend_Tool_Framework_Manifest_Interface``\ を実装するクラスを含む
プロバイダとマニフェスト・ファイルを見つけることです。
一旦これらのファイルがローダによって見つかると、
プロバイダはプロバイダ・リポジトリにロードされ、
マニフェスト・メタデータはマニフェスト・リポジトリにロードされます。

ローダを実装するために、以下の抽象クラスを拡張しなければなりません:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Loader_Abstract
   {

       abstract protected function _getFiles();

       public function load()
       {
           /** ... */
       }
   }

``_getFiles()``\ メソッドは、ファイル（絶対パス）の配列を返さなければなりません。
Zend
Frameworkで供給されるビルトイン・ローダは、インクルードパス・ローダと呼ばれます。
デフォルトで、ツーリング・フレームワークは、
プロバイダまたはマニフェスト・メタデータ・オブジェクトを含むかもしれないファイルを見つけるために、
include_pathベースのローダを使います。 他のオプションが全く無くても、
``Zend_Tool_Framework_Loader_IncludePathLoader``\ はインクルードパスの中で ``Mainfest.php``\ 、
``Tool.php``\ または ``Provider.php``\ で 終わるファイルを探します
``Zend_Tool_Framework_Loader_Abstract``\ の ``load()``\ メソッドによって一旦見つかると、
それらがサポートされたインターフェースのいずれかを実装するかどうか判定するためにそれらはテストされます。
もし実装していれば、見つかったクラスのインスタンスがインスタンス化されます、
そして、それは固有のリポジトリを付加されています。

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Loader_IncludePathLoader
       extends Zend_Tool_Framework_Loader_Abstract
   {

       protected $_filterDenyDirectoryPattern = '.*(/|\\\\).svn';
       protected $_filterAcceptFilePattern = '.*(?:Manifest|Provider)\.php$';

       protected function _getFiles()
       {
           /** ... */
       }
   }

ご覧の通り、インクルードパス・ローダは、 ``$_filterAcceptFilePattern``\ にマッチし、
``$_filterDenyDirectoryPattern``\ にマッチしないファイルを求めて、
すべてのinclude_pathsを検索します。

.. _zend.tool.framework.architecture.manifests:

マニフェスト
------

要するに、マニフェストはプロバイダ・リポジトリにどんなさらなるプロバイダでもロードする役割を果たしうるばかりではなく、
どんなプロバイダまたはクライアントにとってでも有用である、指定された、または任意のメタデータを含みます。

空の ``Zend_Tool_Framework_Manifest_Interface``\ を実装して、 ``Zend_Tool_Framework_Manifest_Metadata``\
を実装する オブジェクトの配列を返す ``getMetadata()``\ メソッドを提供しさえすれば、
メタデータをマニフェスト・リポジトリにもたらすことができます。

.. code-block:: php
   :linenos:

   interface Zend_Tool_Framework_Manifest_Interface
   {
       public function getMetadata();
   }

下記で定義されたローダによって、
メタデータ・オブジェクトはマニフェスト・リポジトリ(``Zend_Tool_Framework_Manifest_Repository``)にロードされます。
すべてのプロバイダがプロバイダ・リポジトリにロードされるとわかったあと、マニフェストは処理されます。
これによって、何が現在プロバイダ・リポジトリ内部にあるかに基づくメタデータ・オブジェクトをマニフェストは作成できます。

メタデータを記述するために用いることができる
多少の異なるメタデータ・クラスがあります。 ``Zend_Tool_Framework_Manifest_Metadata``\ は、
基底メタデータ・オブジェクトです。
以下のコード・スニペットによってわかるように、
基底メタデータ・クラスは事実上かなり軽量で抽象的です:

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Metadata_Basic
   {

       protected $_type        = 'Global';
       protected $_name        = null;
       protected $_value       = null;
       protected $_reference   = null;

       public function getType();
       public function getName();
       public function getValue();
       public function getReference();
       /** ... */
   }

より分化したメタデータを記述するために同様に他のビルトイン・メタデータ・クラスがあります:
``ActionMetadata``\ 及び ``ProviderMetadata``\ 。
これらのクラスは、アクションまたはプロバイダのいずれかに特有なメタデータをより詳細に記述する助けになります。
そして、参照はそれぞれアクションまたはプロバイダへの参照であることが期待されます。
これらのクラスは、以下のコード・スニペットで記述されます。

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Manifest_ActionMetadata
       extends Zend_Tool_Framework_Manifest_Metadata
   {

       protected $_type = 'Action';
       protected $_actionName = null;

       public function getActionName();
       /** ... */
   }

   class Zend_Tool_Framework_Manifest_ProviderMetadata
       extends Zend_Tool_Framework_Manifest_Metadata
   {

       protected $_type = 'Provider';
       protected $_providerName  = null;
       protected $_actionName    = null;
       protected $_specialtyName = null;

       public function getProviderName();
       public function getActionName();
       public function getSpecialtyName();
       /** ... */
   }

これらのクラスでの'Type'は、
オブジェクトが責を負うべきメタデータのタイプを記述するのに用いられます。
``ActionMetadata``\ のケースでは、タイプは'Action'です。 そして逆に、 ``ProviderMetadata``\
の場合は、タイプは'Provider'です。 これらのメタデータ・タイプは、
それらがこの新しいメタデータで参照しているオブジェクト(``getReference()``)だけでなく、
それらが記述している「もの」についても、さらなる構造化情報を含みます。

基底 ``Zend_Tool_Framework_Manifest_Metadata``\ クラスを拡張して、
クラス/オブジェクト・ローカル・マニフェストを通してこれらの新しいメタデータ・オブジェクトを返しさえすれば、
あなた自身のメタデータ・タイプを構築できます。
これらのユーザー・ベースのクラスは、マニフェスト・リポジトリの中に残ります

もし、これらのメタデータ・オブジェクトがリポジトリならば、
リポジトリでそれらを探すために利用できる２つの異なるメソッドがあります。

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Manifest_Repository
   {
       /**
        * 検索するメソッドを使うために、
        * $searchPropertiesはマニフェストの範囲内でマッチさせたい
        * キーと値のペアの名前と値を含まなければなりません。
        *
        * 例:
        *     $manifestRepository->findMetadatas(array(
        *         'action' => 'Foo',
        *         'name'   => 'cliActionName'
        *         ));
        *
        * 値'Foo'と名前'action'でキーを持つどんなメタデータ・オブジェクトも見つけます。
        * そして、キーは'cliActionName'の'name'値と名づけられました。
        *
        * 注意:
        * 検索基準の中に存在するが、オブジェクトに現れない名前と値のペアを除外するか、
        * または含むために、$includeNonExistentPropertiesにブール値を渡してください
        */
       public function findMetadatas(Array $searchProperties = array(),
                                     $includeNonExistentProperties = true);

       /**
        * どれくらいが返されたかに関係なく、
        * マッチしている検索基準のうちのちょうど1つを以下は返します。
        * マニフェストの最初の1つは、何が返されるかということです。
        */
       public function findMetadata(Array $searchProperties = array(),
                                    $includeNonExistentProperties = true)
       {
           $metadatas = $this->getMetadatas($searchProperties,
                                            $includeNonExistentProperties);
           return array_shift($metadatas);
       }
   }

上記のサーチ方式を見ると、シグニチャはとても柔軟に検索することを許します。
メタデータ・オブジェクトを見つけるために、
制約にマッチする配列を単に配列によって渡してください。
データがプロパティ・アクセッサ （オブジェクト・メタデータの上で実装される
``getSomething()``\ メソッド） によってアクセスできるならば、
それは「見つかった」オブジェクト・メタデータとしてユーザーへ渡されます。

.. _zend.tool.framework.architecture.clients:

クライアント
------

クライアントは、 ``Zend_Tool_Framework``\ システムと
ユーザーまたは外部ツールとの橋渡しをするインターフェースです。
クライアントは、すべての形とサイズに伝わることができます: *RPC*\
エンドポイント、コマンド・ライン・インタフェースまたはウェブ・インターフェースさえ。
Zend_Toolは、 ``Zend_Tool_Framework``\ システムと相互に作用するための
デフォルト・インターフェースとして、コマンド・ライン・インタフェースを実装しました。

クライアントを実装するためには、以下の抽象クラスを拡張する必要があります。:

.. code-block:: php
   :linenos:

   abstract class Zend_Tool_Framework_Client_Abstract
   {
       /**
        * このメソッドは、カスタム・ローダ、リクエストとレスポンス・オブジェクトを構成して、
        * セットするために、クライアント実装によって実装されなければなりません。
        *
        * (必須ではありませんが、提案されます)
        */
       protected function _preInit();

       /**
        * このメソッドは解析するクライアント実装によって実装されなければなりません。
        * リクエスト・オブジェクト・アクション、
        * プロバイダ及びパラメータ情報を準備しなければなりません。
        */
       abstract protected function _preDispatch();

       /**
        * このメソッドは、レスポンス・オブジェクトを出力して、
        * それをツーリング・クライアントに（クライアントに特有の手段で）返すために、
        * クライアント実装によって実装されなければなりません。
        *
        * (必須ではありませんが、提案されます)
        */
       abstract protected function _postDispatch();
   }

ご覧の通り、そこで、1つのメソッドはクライアントの必要を満たすことを要求されます。
（他の２つは提案されます） 初期化、前処理と後処理
コマンド・ライン・クライアントが動く方法についてより深く研究するには、
`ソースコード`_ を見てください。



.. _`ソースコード`: http://framework.zend.com/svn/framework/standard/branches/release-1.8/library/Zend/Tool/Framework/Client/Console.php
