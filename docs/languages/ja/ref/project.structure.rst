.. EN-Revision: none
.. _project-structure:

********************************************
Zend Framework MVC アプリケーションのために推奨されるプロジェクト構造
********************************************

.. _project-structure.overview:

概要
--

たくさんの開発者が、比較的柔軟な環境でZend Frameworkプロジェクトのための
最善のプロジェクト構造のガイダンスを望みます。 「柔軟な」環境とは、
それらのアプリケーションを実行し、かつ安全にするための
最も理想的なプロジェクト構造を達成するために、
必要に応じてそれらのファイルシステムとウェブサーバ構成を開発者が操作できる
環境です。 デフォルトのプロジェクト構造では、
それらの配置で開発者がそのような柔軟性を持つと仮定します。

以下のディレクトリ構造は、
複雑なプロジェクトのために最大限に拡張可能に設計されています。
その一方で、プロジェクトのためのフォルダとファイルの単純なサブセットを
より単純な必要条件で提示します。
この構造も、モジュラー及び非モジュラー両方のZend
Frameworkアプリケーションのために、 変更なしで動作します。 ``.htaccess``\
ファイルは、 この付録に含まれる :ref:`リライト構成ガイド <project-structure.rewrite>`
で定めるウェブサーバでも、 *URL*\ リライト機能を必要とします。

このプロジェクト構造で、可能性があるすべてのZend Frameworkプロジェクト条件を
サポートすることは意図していません。 ``Zend_Tool``\
によって使われるデフォルトのプロジェクト・プロフィールは、
このプロジェクト構造を反映します。
しかし、この構造でサポートされない必要条件を持つアプリケーションでは、
カスタム・プロジェクト・プロフィールを使わなければなりません。

.. _project-structure.project:

推奨されるプロジェクト・ディレクトリ構造
--------------------

.. code-block:: text
   :linenos:

   <project name>/
       application/
           configs/
               application.ini
           controllers/
               helpers/
           forms/
           layouts/
               filters/
               helpers/
               scripts/
           models/
           modules/
           services/
           views/
               filters/
               helpers/
               scripts/
           Bootstrap.php
       data/
           cache/
           indexes/
           locales/
           logs/
           sessions/
           uploads/
       docs/
       library/
       public/
           css/
           images/
           js/
           .htaccess
           index.php
       scripts/
           jobs/
           build/
       temp/
       tests/

以下では、一覧に記載されたディレクトリ毎に利用例を記述します。

- **application/**: このディレクトリは、アプリケーションを含みます。
  構成や利用されるサービス、及びブートストラップ・ファイルと同様に、 *MVC*\
  システムを収納します。

  - **configs/**: アプリケーション全体の設定のディレクトリ

  - **controllers/**, **models/**, **views/**:
    これらのディレクトリは、デフォルトのコントローラ、モデルまたは
    ビューのディレクトリとして用いられます。
    アプリケーション・ディレクトリの中にこれらの３つのディレクトリを持たせると、
    グローバルな ``controllers/models/views`` を持つ モジュラー・プロジェクトと同様に、
    単純なプロジェクトを始めるための最良のレイアウトが提供されます。

  - **controllers/helpers/**: これらのディレクトリにはアクション・ヘルパーを含みます。
    アクション・ヘルパーは、デフォルト・モジュールのための "``Controller_Helper_``"、
    または他のモジュールの "<Module>_Controller_Helper" として\ namespace されます。

  - **layouts/**: このレイアウト・ディレクトリは、 *MVC* ベースのレイアウト用です。
    ``Zend_Layout`` は *MVC* ベース、 及び非 *MVC* ベースのレイアウトができるので、
    このディレクトリの位置は、レイアウトがコントローラとは１対１の関係ではなく、
    ``views/`` 内のテンプレートから独立していることを反映します。

  - **modules/**: モジュールにより、開発者は
    一組の関連したコントローラを論理的に系統化されたグループに分類できます。
    モジュール・ディレクトリ配下の構造は、
    アプリケーション・ディレクトリ配下の構造に似ています。

  - **services/**: このディレクトリは、 アプリケーションによって、
    またはモデルのための `サービス・レイヤ`_ を実装するために提供される、
    アプリケーションに依存したウェブ・サービス・ファイルのためのものです。

  - **Bootstrap.php**: このファイルはアプリケーションのためのエントリ・ポイントで、
    ``Zend_Application_Bootstrap_Bootstrapper`` を実装するべきです。
    このファイルのための目的は、アプリケーションを起動すること、
    及びそれらを初期化することによって、コンポーネントがアプリケーションを利用できるようにすることです。

- **data/**: このディレクトリは、
  揮発性でおそらく一時的なアプリケーションのデータを格納するための場所を提供します。
  このディレクトリのデータの障害は、アプリケーションが失敗する原因になるかもしれません。
  また、このディレクトリの情報は、サブバージョン・リポジトリに関与するかもしれませんし、
  関与しないかもしれません。 このディレクトリの物体の例は、
  セッション・ファイル、キャッシュ・ファイル、sqlite データベース、
  そしてログとインデックスです。

- **docs/**: このディレクトリは、生成されたか、または直接編集された
  ドキュメンテーションを含みます。

- **library/**:
  このディレクトリは、アプリケーションが依存する共通ライブラリのため、 *PHP*
  ``include_path`` 上になければなりません。 開発者は、 *PHP*
  のマニュアル（ゼンド自体によって確立されるそれらだけでなく）の
  `ユーザレベルでの命名の 手引き`_
  に沿って、一意の名前空間内のこのディレクトリ配下に
  それらのアプリケーション・ライブラリーのコードを置かなければなりません。
  このディレクトリは、 Zend Framework 自体も含むかもしれません。
  もしそうなら、それを ``library/Zend/`` にしまうでしょう。

- **public/**:
  このディレクトリは、アプリケーションのためにすべての公開ファイルを含みます。
  ``index.php`` は ``Zend_Application`` をセットアップして、実行します。
  そして、それは順番に ``application/Bootstrap.php`` ファイルを実行します。
  結果としてフロント・コントローラをディスパッチすることになります。
  ウェブサーバのウェブ・ルートは、このディレクトリに一般的にセットされます。

- **scripts/**: このディレクトリは、メンテナンスやビルド・スクリプトを含みます。
  このようなスクリプトは、コマンド・ライン、クロン、
  または実行時には実行されず、アプリケーションの\ correct 機能の一部である\ phing
  ビルドされたスクリプトを含むかもしれません。

- **temp/**: ``temp/``
  フォルダは、一時的なアプリケーションデータのためにとっておかれます。
  この情報は一般的に、アプリケーション svn リポジトリには入れられません。
  ``temp/`` ディレクトリ配下のデータが削除されると、
  データがもう一度リストアされるか、再キャッシュされるまで、
  アプリケーションは、パフォーマンスが低下した状態で動作し続ける可能性があります。

- **tests/**: このディレクトリは、アプリケーションのテストを含みます。
  これらは手書きや、PHPUnit テスト、Selenium-RC ベースのテスト、
  またはその他の何かのテスト・フレームワークに基づきます。
  既定では、ライブラリーのコードは ``library/``
  ディレクトリのディレクトリ構造をまねることによりテストできます。
  さらに、アプリケーションのための機能テストは、 ``application/``
  ディレクトリの構造
  （アプリケーション・サブディレクトリを含む）をまねて書けました。

.. _project-structure.filesystem:

モジュール構造
-------

モジュールのためのディレクトリ構造は、推奨されたプロジェクト構造の中の
``application/`` ディレクトリのそれを模倣しなければなりません。

.. code-block:: text
   :linenos:

   <modulename>
       configs/
           application.ini
       controllers/
           helpers/
       forms/
       layouts/
           filters/
           helpers/
           scripts/
       models/
       services/
       views/
           filters/
           helpers/
           scripts/
       Bootstrap.php

これらのディレクトリの目的は、推奨されたプロジェクト・ディレクトリ構造に関してと全く同じままです。

.. _project-structure.rewrite:

リライト設定ガイド
---------

*URL* リライトは、 *HTTP* サーバの共通機能です。
しかしながら、ルールと構成は、それらの間ではなはだしく異なります。
下記は、書いた時点で利用できる、ポピュラーな様々なウェブサーバを通じた
多少の共通するアプローチです。

.. _project-structure.rewrite.apache:

Apache HTTPサーバ
^^^^^^^^^^^^^^

移行の例では全て、 ``mod_rewrite`` （ Apache にバンドルされた公式モジュール）
を使います。 それを使うために、 ``mod_rewrite`` はコンパイル時に含まれるか、
動的共用オブジェクト (*DSO*) として許可されなければなりません。
詳しくは、あなたのバージョンの `Apache ドキュメント`_\ を参照してください。

.. _project-structure.rewrite.apache.vhost:

バーチャルホスト内でのリライト
^^^^^^^^^^^^^^^

これは非常に基本的なバーチャルホスト定義です。
これらのルールは、一致するファイルが ``document_root`` 配下で見つかった時を除き、
リクエスト全てを ``index.php`` に導きます。

.. code-block:: text
   :linenos:

   <VirtualHost my.domain.com:80>
       ServerName   my.domain.com
       DocumentRoot /path/to/server/root/my.domain.com/public

       RewriteEngine off

       <Location />
           RewriteEngine On
           RewriteCond %{REQUEST_FILENAME} -s [OR]
           RewriteCond %{REQUEST_FILENAME} -l [OR]
           RewriteCond %{REQUEST_FILENAME} -d
           RewriteRule ^.*$ - [NC,L]
           RewriteRule ^.*$ /index.php [NC,L]
       </Location>
   </VirtualHost>

``index.php`` の前におかれたスラッシュ ("/") に注意してください。 ``.htaccess``
でのルールはこの点に関しては異なります。

.. _project-structure.rewrite.apache.htaccess:

.htaccessファイル内でのリライト
^^^^^^^^^^^^^^^^^^^^

下記は ``mod_rewrite``\ を利用する ``.htaccess``\ ファイルの例です。
これは、リライト・ルールだけを定義し、 ``index.php``
から先行するスラッシュが省略されたことを除けば、
バーチャルホストの設定に似ています。

.. code-block:: text
   :linenos:

   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]
   RewriteRule ^.*$ index.php [NC,L]

``mod_rewrite``\ を設定する方法はたくさんあります。
もし、詳細をお好みでしたら、Jayson Minard の `Blueprint for PHP Applications: Bootstrapping`_\
をご覧下さい。

.. _project-structure.rewrite.iis:

Microsoft Internet Information サーバ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

バージョン 7.0 現在、 *IIS* には現在標準的なリライト・エンジンが含まれます。
適切なリライトルールを作成するために、以下の構成を使うかもしれません。

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
       <system.webServer>
           <rewrite>
               <rules>
                   <rule name="Imported Rule 1" stopProcessing="true">
                       <match url="^.*$" />
                       <conditions logicalGrouping="MatchAny">
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsFile" pattern=""
                                ignoreCase="false" />
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsDirectory"
                                pattern=""
                                ignoreCase="false" />
                       </conditions>
                       <action type="None" />
                   </rule>
                   <rule name="Imported Rule 2" stopProcessing="true">
                       <match url="^.*$" />
                       <action type="Rewrite" url="index.php" />
                   </rule>
               </rules>
           </rewrite>
       </system.webServer>
   </configuration>



.. _`サービス・レイヤ`: http://www.martinfowler.com/eaaCatalog/serviceLayer.html
.. _`ユーザレベルでの命名の 手引き`: http://www.php.net/manual/ja/userlandnaming.php
.. _`Apache ドキュメント`: http://httpd.apache.org/docs/
.. _`Blueprint for PHP Applications: Bootstrapping`: http://devzone.zend.com/a/70
