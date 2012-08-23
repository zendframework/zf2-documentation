.. EN-Revision: none
.. _zend.permissions.acl.refining:

アクセス制御の洗練
=========

.. _zend.permissions.acl.refining.precise:

的確なアクセス制御
---------

:ref:`先ほどの節 <zend.permissions.acl.introduction>`\ で定義した基本的な *ACL* では、さまざまな規則を
*ACL* 全体 (すべてのリソース) に対して適用しました。
しかし実際には、アクセス制御にはさまざまな例外がつきものですし、
もっと複雑なものになるでしょう。 ``Zend\Permissions\Acl``
では、このような目的のためにも直感的で柔軟な方法で対応できます。

例にあげた *CMS* では大半のユーザを 'staff' グループでまとめて管理していました。
ここでは新しく 'marketing' グループを作成し、 *CMS*
のニュースレターや最新ニュースへのアクセスを許可させる必要があるでしょう。
このグループには、ニュースレターや最新ニュースの公開や保存権限があれば十分でしょう。

さらに 'staff' グループに対しては、ニュースの内容は閲覧できますが
最新ニュースの改変はできないようにします。 最後に、(administrators を含む) 全員は
'お知らせ' を保存できないようにします。これは、1 日から 2
日程度の有効期限しか持たないものだからです。

まず、ロールレジストリを変更してこれらの変更を反映させます。 'marketing'
グループを作成して 'staff' と同様の基本権限を持たせることにしたので、 'marketing'
を作成し、'staff' の権限を継承させます。

.. code-block:: php
   :linenos:

   // 新しいグループ marketing は staff の権限を引き継ぎます
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');

次に、これらのアクセス制御は特定のリソース (例: "newsletter"、"latest news"、"announcement
news") に限定されることに注目しましょう。ここで、これらのリソースを追加します。

.. code-block:: php
   :linenos:

   // 規則を適用するリソースを作成します

   // ニュースレター
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // ニュース
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // 最新ニュース
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // お知らせ
   $acl->addResource(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');

そして、次のような特別な規則を、 *ACL* の該当範囲に適用します。

.. code-block:: php
   :linenos:

   // Marketing は、ニュースレターおよび最新ニュースを公開、保存できなければなりません
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Staff (そして継承による marketing) は最新ニュースの改変ができません
   $acl->deny('staff', 'latest', 'revise');

   // 全員 (administrators を含む) はお知らせを保存することができません
   $acl->deny(null, 'announcement', 'archive');

これで、最新の変更内容を反映した *ACL* への問い合わせが行えるようになります。

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied となります

.. _zend.permissions.acl.refining.removing:

アクセス制御の削除
---------

*ACL* からひとつあるいは複数のアクセス規則を削除するには、 ``removeAllow()``
メソッドあるいは ``removeDeny()`` メソッドを使用します。 ``allow()`` および ``deny()``
と同様、 ``NULL`` 値を指定すると
すべてのロールやリソース、権限を表すことになります。

.. code-block:: php
   :linenos:

   // 最新ニュースの改変拒否を staff (そして継承による marketing) から削除します
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // allowed となります

   // ニュースレターの公開や保存の権限を、marketing から取り除きます
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied となります

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied";
   // denied となります

上で説明したように、徐々に権限を変更していくこともできますが、 権限に対して
``NULL`` 値を設定すると、 このような変更を一括で行うことができます。

.. code-block:: php
   :linenos:

   // marketing に対して、最新のニュースへのアクセスを許可します
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed となります

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied";
   // allowed となります


