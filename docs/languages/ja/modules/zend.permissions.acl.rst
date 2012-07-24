.. _zend.permissions.acl.introduction:

導入
==

``Zend_Acl`` は、軽量で柔軟なアクセス制御リスト (*ACL*)
機能と権限管理機能を提供します。アプリケーションでは一般に、
保護されたオブジェクトへのアクセスを制御するためにこれらの機能を使用します。

このドキュメントにおいて、

- **リソース (Resource)** とは、アクセス制御の対象となるオブジェクトのことです。

- **ロール (Role)**
  とは、リソースに対してのアクセスを要求するオブジェクトのことです。

簡単に言うと、 **ロールがリソースに対してのアクセスを要求する**
ということです。たとえば、ある人が自動車を利用したいと考えているとしましょう。
この場合、自動車を誰が利用できるのかが管理されているとすると
「ある人」がロールで「自動車」がリソースとなります。

アクセス制御リスト (*ACL*) での設定によって、アプリケーションは
要求してきたオブジェクト (ロール) が制限されたオブジェクト (リソース)
へのアクセスを認められているかどうかを制御します。

.. _zend.permissions.acl.introduction.resources:

リソース
----

``Zend_Acl`` では、リソースを作成するのは簡単です。 ``Zend_Acl`` の
``Zend_Acl_Resource_Interface`` に、
開発者がリソースを作成するの手助けする機能が含まれています。
リソースクラスは、単にこのインターフェイスを実装するだけで作成できます。
このインターフェイスに含まれるメソッドはひとつだけで、それは ``getResourceId()``
です。このメソッドにより、 ``Zend_Acl``
ではそのオブジェクトがリソースであると判断します。さらに、
基本的なリソースの実装を含む ``Zend_Acl_Resource`` が ``Zend_Acl``
にインクルードされています。
開発者は、必要な部分だけを拡張することでリソースを作成できます。

``Zend_Acl`` は、ツリー構造を提供しています。これを用いて複数のリソース
("アクセス制御されているエリア") を追加できます。
リソースはこのようにツリー構造で管理されるので、全般的なもの
(ルートに近いほう) から特殊なもの (末端に近いほう) までを扱うことができます。
特定のリソースに対して問い合わせを行うと、
リソースの階層をたどって自動的に上位階層への問い合わせも行われます。
これにより、規則を階層化して管理すること実現できます。
たとえば、ある都市のすべての建物に適用されるデフォルトの規則がある場合に、
それを各建物に適用する代わりに都市に対して適用することができるようになります。
中にはこの規則の例外となる建物もあるかもしれません。 ``Zend_Acl``
では、このような状況も簡単に処理できます。
例外的な規則を適用する建物については、建物に対して直接規則を定義すればいいのです。
リソースは、単一のリソースしか継承することができません。
そしてその継承元のリソースがまた別の親リソースを継承し……
といった具合になります。

``Zend_Acl`` は、リソースに対する権限 ("create"、"read"、"update"、"delete" など)
もサポートしており、すべての権限あるいは一部の権限に影響を及ぼす規則を、
リソースに対して割り当てることができます。

.. _zend.permissions.acl.introduction.roles:

ロール
---

リソースと同様、ロールを作成するのも簡単です。Zend_Acl の ``Zend_Acl_Role_Interface``
に、 開発者がロールを作成するの手助けする機能が含まれています。
ロールクラスは、単にこのインターフェイスを実装するだけで作成できます。
このインターフェイスに含まれるメソッドはひとつだけで、それは ``getRoleId()``
です。このメソッドにより、 Zend_Acl
はそのオブジェクトがロールであると判断します。さらに、
基本的なロールの実装を含む ``Zend_Acl_Role`` が ``Zend_Acl``
にインクルードされています。
開発者は、必要な部分だけを拡張することでリソースを作成できます。

``Zend_Acl`` では、あるロールは他の複数のロールを継承できます。
これは、それぞれのロールの規則を継承することをサポートするためのものです。
たとえば、"sally" のようなユーザロールは、"editor" かつ "administrator"
のように複数の親ロールに属することもありえるでしょう。 この場合、開発者は
"editor" および "administrator" にそれぞれ別に規則を定義します。 そして "sally"
がその両方を継承することにします。 "sally"
に規則を直接定義する必要はありません。

複数のロールからの継承は非常に便利ですが、
多重継承は複雑な問題を引き起こすこともあります。
次の例は、あいまいな条件になったときに ``Zend_Acl``
がそれをどう解決するかを示すものです。

.. _zend.permissions.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: ロールの多重継承

以下のコードでは、基本となる三つのロール "guest"、"member" および "admin"
を定義しています。他のロールはこれらを継承することになります。 次に、"someUser"
というロールを作成してこれらの三つのロールを継承します。 これらのロールが配列
*$parents* にあらわれる順序が重要となります。 問い合わせ先のロール (ここでは
"someUser" にアクセス規則が定義されていないが その継承元 (ここでは "guest"、"member"
および "admin") には定義されているという場合、 ``Zend_Acl`` はそちらを検索します。

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $acl->addRole(new Zend_Acl_Role('guest'))
       ->addRole(new Zend_Acl_Role('member'))
       ->addRole(new Zend_Acl_Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend_Acl_Role('someUser'), $parents);

   $acl->add(new Zend_Acl_Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

"someUser" ロールおよび "someResource" に対する規則は定義されていないので、 ``Zend_Acl``
は、その規則が "someUser" の継承元ロールで定義されているものとして検索します。
まず "admin" ロールを探しますが、ここではアクセス規則が定義されていません。 次に
"member" ロールを探し、ここで ``Zend_Acl`` が規則を発見します。つまり "member" は
"someResource" へのアクセスを許可されているということです。

しかし、仮に ``Zend_Acl`` がさらに別の親に対しても規則の検索を続けたとすると、
"guest" は "someResource" へのアクセスが拒否されていることに気づくことでしょう。
これは問題となります。というのも、"someUser" は "someResource"
へのアクセスが許可されていると同時に拒否されているわけで、
それぞれ別の親ロールから取得した規則が衝突することになるからです。

``Zend_Acl`` では、このような衝突の可能性を解決するために、
直近に継承されたロールの優先度が高くなるようにしています。
今回の場合は、"member" のほうが "guest" ロールより先に調べられ、例のコードの出力は
"allowed" となります。

.. note::

   複数の親をロールに指定する場合は、承認クエリでの規則の検索順を覚えておきましょう。
   最後に指定した親が最初に対象となります。

.. _zend.permissions.acl.introduction.creating:

アクセス制御リストの作成
------------

アクセス制御リスト (*ACL*)
を使用して、物理的あるいは仮想的なオブジェクトの組み合わせを
お望みどおりに表現できます。しかしここでは、説明用として、
基本的なコンテンツ管理システム (*CMS*) の *ACL* を考えます。
これは、さまざまな領域で複数階層のグループを管理するものです。 新しい *ACL*
オブジェクトを作成するには、何もパラメータを指定せずに *ACL*
のインスタンスを作成します。

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

.. note::

   開発者が "allow" 規則を指定しない限り、 ``Zend_Acl``
   はあらゆるロールのすべてのリソース上の権限からのアクセスも拒否します。

.. _zend.permissions.acl.introduction.role_registry:

ロールの登録
------

コンテンツ管理システムでは、ほとんどすべての場面で権限階層の管理が必要となります。
これにより、ユーザの編集権限を決定します。たとえば 'Guest'
グループに対してはデモ用に限定したアクセス権限のみを許可し、 'Staff'
グループは通常の操作をする大半の *CMS* ユーザ用に作成し、 'Editor'
グループにはコンテンツの公開やレビュー、保存や削除の権限を与え、 最後に
'Administrator' は、その他のすべてのグループの権限に加えて
機密情報の管理やユーザ管理、バックエンドの設定データ、
バックアップ、そしてエクスポート機能を与えるといったようになります。
これらの権限を、ロールレジストリで表すことができます。 各グループの権限を
'親の' グループから継承させ、 そのグループに固有の権限を追加で定義します。
これらの権限を整理すると、次のようになります。

.. _zend.permissions.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: サンプル CMS 用のアクセス制御

   +-------------+-----------------------------------+------------------------------+
   |名前           |権限                                 |継承する権限の継承元                    |
   +=============+===================================+==============================+
   |Guest        |View                               |なし                            |
   +-------------+-----------------------------------+------------------------------+
   |Staff        |Edit, Submit, Revise               |Guest                         |
   +-------------+-----------------------------------+------------------------------+
   |Editor       |Publish, Archive, Delete           |Staff                         |
   +-------------+-----------------------------------+------------------------------+
   |Administrator|(すべてのアクセスを許可)                      |なし                            |
   +-------------+-----------------------------------+------------------------------+

この例では ``Zend_Acl_Role`` を用いていますが、 ``Zend_Acl_Role_Interface``
を実装しているオブジェクトなら何でも使用可能です。
これらのグループを、次のようにしてロールレジストリに追加します。

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   // Zend_Acl_Role を使用して、グループをロールレジストリに追加します
   // Guest はアクセス制御を受け継ぎません
   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);

   // Staff は guest の権限を継承します
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);

   /*
   あるいは、上の内容は次のように書くこともできます
   $acl->addRole(new Zend_Acl_Role('staff'), 'guest');
   */

   // Editor は staff の権限を継承します
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');

   // Administrator はアクセス制御を受け継ぎません
   $acl->addRole(new Zend_Acl_Role('administrator'));

.. _zend.permissions.acl.introduction.defining:

アクセス制御の定義
---------

*ACL* に適切なロールが含まれた状態になりました。これで、リソースに対して
ロールがどのようにアクセスするのかという規則を定義できる状態になりました。
この例では特定のリソースを定義していないことにお気づきかもしれません。
この場合、規則はすべてのリソースに対して適用されます。 ``Zend_Acl``
を使用すると、全般的なものであろうが特殊なものであろうが
規則を適用するだけで定義できるようになります。
リソースやロールは、その継承元で定義されている規則を引き継ぐからです。

.. note::

   一般に、 ``Zend_Acl`` は指定された規則に従います。
   ただし、より詳細な規則が別途適用されている場合は例外です。

そのため、複雑な規則の組み合わせを最小限のコードで定義できるようになります。
上で定義した基本的な権限を適用するには、次のようにします。

.. code-block:: php
   :linenos:

   $acl = new Zend_Acl();

   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');
   $acl->addRole(new Zend_Acl_Role('administrator'));

   // Guest は、コンテンツを閲覧することのみが可能です
   $acl->allow($roleGuest, null, 'view');

   /*
   上と同じ内容を、このように書くこともできます
   $acl->allow('guest', null, 'view');
   //*/

   // Staff は guest の権限をすべて引き継いだうえで、さらに追加の権限を必要とします
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor は、staff の権限 (view、edit、submit および revise)
   // を引き継いだうえで、さらに追加の権限を必要とします
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator は何も引き継ぎませんが、すべての権限が認められています
   $acl->allow('administrator');

上の ``allow()`` のコールにおける ``NULL`` は、
規則をすべてのリソースに対して適用することを意味します。

.. _zend.permissions.acl.introduction.querying:

ACL への問い合わせ
-----------

これで、柔軟な *ACL* が作成できました。これにより、
ウェブアプリケーションの使用者が、
ある機能を使用するために必要な権限を持っているかを調べられるようになりました。
問い合わせを行うのは簡単で、単に ``isAllowed()`` メソッドを使用するだけです。

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied";
   // guest から引き継いでいるので allowed となります

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied";
   // 'update' 用の規則がないので denied となります

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied";
   // administrator はすべての権限が許可されているので allowed となります

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied";
   // administrator はすべての権限が許可されているので allowed となります

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied";
   // administrator はすべての権限が許可されているので allowed となります


