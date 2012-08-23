.. EN-Revision: none
.. _introduction.installation:

******
インストール
******

Zend Framework の要件についての詳細な情報は :ref:`システム要件 <requirements>`
を参照ください。

Zend Framework のインストールは非常に簡単です。
フレームワークをダウンロードして展開したら、その中の ``/library``
フォルダをインクルードパスの先頭に追加するだけです。 library フォルダを別の場所
(おそらく共有ライブラリの場所) に移動してもよいでしょう。

- `最新の安定版をダウンロードする`_\ 。 このバージョンは ``.zip`` と ``.tar.gz``
  の二種類の形式で公開されており、Zend Framework をはじめて使う人におすすめです。

- `最新のスナップショットをダウンロードする`_\ 。
  最先端の機能を試してみたいという勇気ある人たちのために、 Zend Framework
  の最新の開発版のスナップショットを毎日更新しています。
  スナップショットには、英語ドキュメントのみが含まれているものと
  全言語のドキュメントが含まれているものの二種類があります。 最新の Zend Framework
  の開発版を試してみたい方は、Subversion (*SVN*)
  クライアントの使用をご検討ください。

- `Subversion`_ (*SVN*) クライアントを使用する。 Zend Framework
  はオープンソースソフトウェアであり、開発に使用している Subversion
  リポジトリは一般に公開されています。既にアプリケーションの開発で *SVN*
  を使用している、 Zend Framework に対して何らかのフィードバックを行いたい、
  あるいはフレームワークのバージョンを常に最新に保っておきたい
  などといった場合は、 *SVN* で最新の Zend Framework を取得してください。

  `エクスポート`_ 機能を使用すると、フレームワークの特定のリビジョンを ``.svn``
  ディレクトリなしで取得できるので便利です。

  `チェックアウト`_ は、Zend Framework
  に対して何らかの貢献をしたい方にとって便利な方法です。
  この方法で取得したファイルは、 `svn update`_
  コマンドで常に最新版に更新できます。 また、変更内容を *SVN*
  リポジトリにコミットするには `svn commit`_ コマンドを使用します。

  すでに *SVN* を使用して自身のアプリケーションを管理している開発者にとっては、
  `外部定義`_ が非常に便利です。

  Zend Framework の *SVN* リポジトリの最先端の *URL* は
  `http://framework.zend.com/svn/framework/standard/trunk`_ です。

Zend Framework を取得したら、
あなたのアプリケーションからフレームワークのクラス群にアクセスできるようにしましょう。これには
`いくつかの方法があります`_ が、 *PHP* の `include_path`_ に Zend Framework
ライブラリへのパスを含める必要があります。

Zend が提供する `クイックスタート`_
を見れば、手っ取り早く実行してみることができます。
これは、実際に動作するサンプルを用いてフレームワークについて学ぶためのドキュメントです。

Zend Framework の各コンポーネントは疎結合なので、
必要に応じて特定のコンポーネントのみを自作のアプリケーションで使用することもできます。
これ以降の章では、Zend Framework
の包括的な使用法をコンポーネント単位で説明します。



.. _`最新の安定版をダウンロードする`: http://framework.zend.com/download/latest
.. _`最新のスナップショットをダウンロードする`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`エクスポート`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`チェックアウト`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`外部定義`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`いくつかの方法があります`: http://www.php.net/manual/ja/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/ja/ini.core.php#ini.include-path
.. _`クイックスタート`: http://framework.zend.com/docs/quickstart
