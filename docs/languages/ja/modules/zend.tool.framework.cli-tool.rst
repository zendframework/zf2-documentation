.. _zend.tool.framework.clitool:

CLIツールの使用
=========

（内部的にコンソール・ツールとして知られる） *CLI*\
またはコマンドライン・ツールは、 現在、 ``Zend_Tool``\
リクエストをディスパッチするための主要なインターフェースです。 *CLI*\
ツールで、開発者は「コマンド・ライン・ウインドウ」内でツーリング・リクエストを出すことができます。
それは、「ターミナルの」ウインドウとしても一般に知られています。
この環境は、*nix環境で優れていますが、 Windowsでの ``cmd.exe``\
やconsole2、更にはCygwinプロジェクトとも共通の実装を持ちます。

.. _zend.tool.framework.clitool.setup-general:

CLIツールの設定
---------

コマンド・ライン・クライアントを通じてツーリング・リクエストを出すために、
システムで「zf」命令を取り扱えるように、
最初にクライアントを設定する必要があります。
コマンド・ライン・クライアントは、どう見ても、
ゼンド・フレームワーク・ディストリビューションを提供される ``.sh``\ または
``.bat``\ ファイルです。 トランクでは、それはここで見つかります:
`http://framework.zend.com/svn/framework/standard/trunk/bin/`_

ご覧の通り、3つのファイルが、 ``bin/``\ ディレクトリにあります: ``zf.php``\ 、 ``zf.sh``\
及び ``zf.bat``\ 。 ``zf.sh``\ および ``zf.bat``\
は、オペレーティングシステム固有クライアント・ラッパです: \*nix環境のための
``zf.sh``\ とWin32環境のための ``zf.bat``\ 。 これらのクライアント・ラッパは、適切な
``php.exe``\ を捜し出して、 ``zf.php``\ を捜し出して、
クライアント・リクエストに渡す役割を果たします。 ``zf.php``\
は、環境を理解し、適切なinclude_pathを構築して、
ディスパッチするための適切なライブラリ・コンポーネントにコマンド・ラインで提供されるものを渡す
取扱いに対して責任あるものです。

最後に、あなたのオペレーティングシステムに関係なく、
あなたはすべてを働かせる2つのものを確実にすることを望みます。

. ``zf.sh/zf.bat``\ は、システム・パスから到達できます。
  カレント作業ディレクトリが何かに関係なく、
  これはあなたのコマンド・ラインでどこからでも ``zf``\ を呼ぶ能力です。

. ``ZendFramework/library``\ は ``include_path``\ にあります。

.. note::

   上記が最も理想的な必要条件であるとはいえ、 単にZend
   Frameworkをダウンロードして、 ``./path/to/zf.php``\
   としていくらかのコマンドが動作することを期待できます。

.. _zend.tool.framework.clitool.setup-starnix:

Unixのようなシステム上でCLIツールを設定
-----------------------

\*nix環境で最も一般的な準備は、 *PHP*\ バイナリと同じディレクトリに ``zf.sh``\ と
``zf.php``\ をコピーすることです。
これは、通常、以下の場所のうちの1つで見つけられます:

.. code-block:: text
   :linenos:

   /usr/bin
   /usr/local/bin
   /usr/local/ZendServer/bin/
   /Applications/ZendServer/bin/

*PHP*\ バイナリの場所を見つけるために、 コマンドラインで 'which php'
を実行できます。 これは、この環境で *PHP*\ スクリプトを実行するために存在する
*PHP*\ バイナリの場所を返します。

次の課題は、Zend Frameworkライブラリがシステム *PHP* ``include_path``\ の中で
正しく設定されることを確実にすることです。 *include_path*\
が位置するところを見つけ出すために、 ``php -i`` を実行したり、 ``include_path``\
変数を探したり、 より簡潔に、 ``php -i | grep include_path`` を実行したりします。 一旦
``include_path``\ が位置するところ （これは通常、 ``/usr/lib/php`` や ``/usr/share/php``\ 、
``/usr/local/lib/php`` または同様の何かです） を見つけたら、 ``/library/``
ディレクトリの内容が ``include_path``\
に指定されたディレクトリに置かれることを確実にしてください。

一旦それらの2つのことをしたなら、
コマンドを発行して、このような固有のレスポンスを戻すことができるはずです:

.. image:: ../images/zend.tool.framework.cliversionunix.png
   :align: center

あなたがこの種の出力に遭遇しないならば、
戻って、必要な部分の全てを固有の場所に持つことを確実にするために
構成をチェックしてください。

サーバー構成やアクセスレベル、
またはその他の理由によって使いたいかもしれない二、三の他の設定があります。

**ALTERNATIVE SETUP**\ では 一緒にダウンロードするZend Frameworkを現状のまま保って、
``PATH``\ の場所から ``zf.sh``\ へのリンクを作成する必要があります。
ZendFrameworkダウンロードの内容を ``/usr/local/share/ZendFramework``\ や またはよりローカルに
``/home/username/lib/ZendFramework``\ 、 そして ``zf.sh``\ へのシンボリックリンクを作成した
場所に入れることができることを意味します。

リンクを ``/usr/local/bin`` （これは、例えばリンクを ``/home/username/bin/``\
に入れても動作するでしょう）
に置きたいならば、あなたはこれに類似したコマンドを発行するでしょう:

.. code-block:: sh
   :linenos:

   ln -s /usr/local/share/ZendFramework/bin/zf.sh /usr/local/bin/zf

   # または (例えば)
   ln -s /home/username/lib/ZendFramework/bin/zf.sh /home/username/bin/zf

コマンドラインでグローバルにアクセスすることができるはずのリンクをこれは確立します。

.. _zend.tool.framework.clitool.setup-windows:

WindowsでCLIツールを設定
-----------------

Windows Win32環境で最も一般的な準備は、 *PHP*\ バイナリと同じディレクトリに ``zf.bat``\
と ``zf.php``\ をコピーすることです。
これは、通常、以下の場所のうちの1つで見つけられます:

.. code-block:: text
   :linenos:

   C:\PHP
   C:\Program Files\ZendServer\bin\
   C:\WAMP\PHP\bin

あなたは、コマンドラインで ``php.exe``\ を実行できるはずです。 できなければ、
最初に、 *PHP*\
ディストリビューションに付属していたドキュメンテーションをチェックしてください、
さもなければ、 ``php.exe``\ へのパスがあなたのWindows ``PATH``\
環境変数であることを確認してください。

次の課題は、Zend Frameworkライブラリがシステム *PHP* ``include_path``\ の中で
正しく設定されることを確実にすることです。 ``include_path``\
が位置するところを見つけ出すために、 ``php -i`` を入力したり、 ``include_path``\
変数を探したりできます。 grepが使えるCygwin構成があるなら、より簡潔に、 ``php -i |
grep include_path`` を実行します。 一旦 ``include_path``\ が位置するところ （これは通常、
``C:\PHP\pear`` や ``C:\PHP\share``\ 、 ``C:\Program Files\ZendServer\share`` または同様の何かです）
を見つけたら、library/ ディレクトリの内容が ``include_path``\
に指定されたディレクトリに置かれることを確実にしてください。

一旦それらの2つのことをしたなら、
コマンドを発行して、このような固有のレスポンスを戻すことができるはずです:

.. image:: ../images/zend.tool.framework.cliversionwin32.png
   :align: center

あなたがこの種の出力に遭遇しないならば、
戻って、必要な部分の全てを固有の場所に持つことを確実にするために
構成をチェックしてください。

サーバー構成やアクセスレベル、
またはその他の理由によって使いたいかもしれない二、三の他の設定があります。

**ALTERNATIVE SETUP**\ では 一緒にダウンロードするZend Frameworkを現状のまま保って、
システム ``PATH``\ と ``php.ini``\ ファイルの両方を変更する必要があります。
ユーザー環境で、 ``zf.bat``\ ファイルが実行可能であるように、 必ず
``C:\Path\To\ZendFramework\bin``\ を加えるようにしてください。 また、
``C:\Path\To\ZendFramework\library``\ が ``include_path``\ にあることを確実にするために、
``php.ini``\ ファイルを変えてください。

.. _zend.tool.framework.clitool.setup-othernotes:

設定での他の考慮事項
----------

もし何らかの理由で ``include_path``\ の中にZend
Frameworkライブラリを必要としないならば、 もう一つの選択肢があります。 ``zf.php``\
がZend
Frameworkインストールの位置を決定するために利用する2つの特別な環境変数があります。

1つ目は ``ZEND_TOOL_INCLUDE_PATH_PREPEND``\ です。 クライアントをロードする前にシステム（
``php.ini``\ ）の ``include_path``\ に この環境変数の値を前に付加します。

あるいは、 ``zf``\ コマンドライン・ツールのために特に辻褄が合うもののために
完全にシステム ``include_path``\ を **取り替える** ``ZEND_TOOL_INCLUDE_PATH``\
を使いたいかもしれません。

.. _zend.tool.framework.clitool.continuing:

次に進むべきところは？
-----------

この時点では、よりちょっと「面白い」コマンドの奥義を伝え始めるために準備されなければなりません。
動き出すためには、何が利用できるか見るために、 ``zf --help``\
コマンドを発行できます。

.. image:: ../images/zend.tool.framework.clihelp.png
   :align: center

プロジェクト作成のために ``zf``\ スクリプトを使用する方法を理解するために、
``Zend_Tool_Project``\ の「プロジェクトの作成」CreateProject節に進んでください。



.. _`http://framework.zend.com/svn/framework/standard/trunk/bin/`: http://framework.zend.com/svn/framework/standard/trunk/bin/
