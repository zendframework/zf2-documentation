.. _zend.openid.introduction:

導入
==

``Zend_OpenId`` は、OpenID 対応のサイトや ID プロバイダを作成するためのシンプルな *API*
を提供する Zend Framework のコンポーネントです。

.. _zend.openid.introduction.what:

OpenID とは?
----------

OpenID は、ユーザ中心のデジタル識別子用のプロトコル群のことです。
これらのプロトコルによって、ID プロバイダを使用したオンライン ID
を作成します。この ID は、OpenID がサポートする場所ならどこでも使用可能です。
OpenID 対応のサイトでは、
ユーザ名やパスワードといった旧来の認証情報を覚えておく必要がなくなるわけです。
すべての OpenID 対応サイトで単一の OpenID による ID を使用できます。 この ID
は、通常は *URL* となります。 これはそのユーザの個人ページの *URL*
かもしれませんし、 blog などの他の情報を含むリソースの *URL* かもしれません。
ユーザ名やパスワードの組み合わせをたくさん覚える必要はもうありません。
ひとつの ID ですべてのインターネットサービスが使用できるのです。 OpenID
はオープンで、中央管理されておらずフリーなユーザ中心のソリューションです。
各自がどの OpenID プロバイダを使用するかを選択できますし、 独自の ID
サーバを作成することもできます。 OpenID 対応のサイトや ID
プロバイダを作成する際に、 どこかの許可を得る必要はありません。

OpenID についての詳細な情報は `OpenID の公式サイト`_ を参照ください。

.. _zend.openid.introduction.how:

動作原理は?
------

``Zend_OpenId`` コンポーネントの主要な目的は、 次の図のような OpenID
認証プロトコルを実装することです。

.. image:: ../images/zend.openid.protocol.jpg
   :width: 559
   :align: center

. 認証処理はエンドユーザ側から始まります。 まず OpenID
  識別子をユーザエージェント経由で OpenID コンシューマに渡します。

. OpenID コンシューマはユーザから受け取った識別子を正規化し、
  その内容を確認します。確認した結果として得られるのは、 識別子、OpenID
  プロバイダ *URL* そして OpenID プロトコルのバージョンです。

. OpenID コンシューマは、Diffie-Hellman
  キーを使用してプロバイダとのオプションの関連を確立します。
  その結果、両者が共通の "共用する秘密" を保持することになり、
  これを用いてその後のメッセージの署名や検証を行います。

. OpenID コンシューマは、ユーザエージェントを OpenID 認証リクエストとともに OpenID
  プロバイダの *URL* にリダイレクトします。

. OpenID プロバイダはユーザエージェントが認証済みかどうかを確認し、
  必要に応じて認証処理を行います。

. エンドユーザは所定のパスワードを入力します。

. OpenID プロバイダは、指定されたコンシューマでその ID
  が許可されているかどうかを調べ、必要に応じてユーザに問い合わせます。

. エンドユーザは、その ID を渡してもよいかどうかを指定します。

. OpenID プロバイダはユーザエージェントを OpenID
  コンシューマにリダイレクトします。その際のリクエストには "認証に通った"
  あるいは "失敗した" といった情報が含まれます。

. OpenID コンシューマはプロバイダから受け取った情報を検証します。
  この検証には、ステップ 3 で取得した "共用する秘密" を用いるか、あるいは OpenID
  プロバイダにさらに直接リクエストを行います。

.. _zend.openid.introduction.structure:

Zend_OpenId の構造
---------------

``Zend_OpenId`` は 2 つのサブパッケージで構成されています。 まず最初が
``Zend_OpenId_Consumer`` で、これは OpenID
対応のサイトを開発するためのものです。もうひとつは ``Zend_OpenId_Provider``
で、これは OpenID
サーバを開発するためのものです。これらはお互いに完全に独立しており、
それぞれ個別に使用できます。

これらのサブパッケージの唯一の共通部分は、 ``Zend_OpenId_Extension_Sreg``
が実装している OpenID Simple Registration Extension と ``Zend_OpenId``
クラスのユーティリティ関数群です。

.. note::

   ``Zend_OpenId`` は、 `GMP 拡張モジュール`_ が使用可能な場合はそれを使用します。
   ``Zend_OpenId`` を使う場合は、 GMP
   拡張モジュールを有効にしておくとよりよいパフォーマンスが得られるでしょう。

.. _zend.openid.introduction.standards:

サポートする OpenID 標準規格
------------------

``Zend_OpenId`` コンポーネントは、 次の標準規格に対応しています。

- OpenID Authentication protocol version 1.1

- OpenID Authentication protocol version 2.0 draft 11

- OpenID Simple Registration Extension version 1.0

- OpenID Simple Registration Extension version 1.1 draft 1



.. _`OpenID の公式サイト`: http://www.openid.net/
.. _`GMP 拡張モジュール`: http://php.net/gmp
