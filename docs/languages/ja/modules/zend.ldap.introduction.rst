.. _zend.ldap.introduction:

導入
==

``Zend_Ldap`` は *LDAP*\ 操作を行うクラスです。 バインドだけが可能で、 *LDAP*
ディレクトリ内のエントリの検索や変更には対応していません。

.. _zend.ldap.introduction.theory-of-operations:

動作原理
----

現在このコンポーネントは、OpenLDAPまたはActiveDirectory（AD）サーバのような 単一の
*LDAP*\ サーバへのバインディングを概念的に表現して、 *LDAP*\
サーバに対する活動を実行できる 主要な ``Zend_Ldap``\ クラスから成ります。
バインディングのパラメータは、明示的に、または、オプション配列の形で提供されるかもしれません。
``Zend_Ldap_Node``\ は、 単一の *LDAP*\
ノードのためにオブジェクト指向インタフェースを提供します。 そして、 *LDAP*\
ベースのドメイン・モデルのために、
アクティブ・レコードのようなインターフェースの基盤を作ることに使うことができます。

属性の設定や取得 (日付値、パスワード、ブール値など)のような *LDAP*\
項目上での活動の実行や (``Zend_Ldap_Attribute``)、 *LDAP*\ フィルタ文字列の作成や修正
(``Zend_Ldap_Filter``)、 *LDAP*\ 識別名 (DN)の操作 (``Zend_Ldap_Dn``)
をおこなうためのいくつかのヘルパー・クラスをコンポーネントで提供します。

その上、 OpenLDAPとActiveDirectoyサーバの ``Zend_Ldap_Node_Schema``\ のために ブラウズする
*LDAP*\ スキーマ、 そして OpenLDAPサーバやActiveDirectoryサーバ、 Novell
eDirectoryサーバのためのサーバ情報取得
(``Zend_Ldap_Node_RootDse``)をコンポーネントで抽象します。

``Zend_Ldap`` クラスの使用法は *LDAP* サーバの形式によって異なり、
以下のいずれかのパターンとなります。

OpenLDAP を使用している場合は、以下の例のようになります (AD を使って **いない**
場合は **bindRequiresDn** オプションが重要となることに注意しましょう):

.. code-block:: php
   :linenos:

   $options = array(
       'host'              => 's0.foo.net',
       'username'          => 'CN=user1,DC=foo,DC=net',
       'password'          => 'pass1',
       'bindRequiresDn'    => true,
       'accountDomainName' => 'foo.net',
       'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

Microsoft AD を使う場合の簡単な例です:

.. code-block:: php
   :linenos:

   $options = array(
       'host'                   => 'dc1.w.net',
       'useStartTls'            => true,
       'username'               => 'user1@w.net',
       'password'               => 'pass1',
       'accountDomainName'      => 'w.net',
       'accountDomainNameShort' => 'W',
       'baseDn'                 => 'CN=Users,DC=w,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('bcarter',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

ここでは、 ``getCanonicalAccountName()`` メソッドで、 アカウントの DN
を取得していることに注意しましょう。
これはただ単に、このクラスに現在存在するコードの例をできるだけ多く見せたいからです。

.. _zend.ldap.introduction.theory-of-operations.automatic-username-canonicalization:

バインド時のユーザ名自動正規化
^^^^^^^^^^^^^^^

**bindRequiresDN** が ``TRUE``\ で、 かつ DN
形式のユーザ名がオプションで設定されていない場合、 ``bind()`` を DN
でないユーザ名でコールするとバインドに失敗します。 しかし、DN
形式のユーザ名がオプションで設定されていれば、 ``Zend_Ldap``\
はまずそのユーザ名でバインドを行い、 ``bind()``\
で指定したユーザ名に対応するアカウントの DN を取得した上で 改めてその DN
でバインドしなおします。

この振る舞いは :ref:`Zend_Auth_Adapter_Ldap <zend.auth.adapter.ldap>` にとっては重要です。
これは、ユーザが指定したユーザ名を直接 ``bind()`` に渡します。

次の例では、DN でないユーザ名 '**abaker**' を ``bind()`` で使用する方法を示します:

.. code-block:: php
   :linenos:

   $options = array(
           'host'              => 's0.foo.net',
           'username'          => 'CN=user1,DC=foo,DC=net',
           'password'          => 'pass1',
           'bindRequiresDn'    => true,
           'accountDomainName' => 'foo.net',
           'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend_Ldap($options);
   $ldap->bind('abaker', 'moonbike55');
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend_Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

この例において ``bind()`` をコールすると、 ユーザ名 '**abaker**' が DN 形式でないことと
**bindRequiresDn** が ``TRUE`` であることから、まず '``CN=user1,DC=foo,DC=net``' と '**pass1**'
を用いてバインドします。それから '**abaker**' の DN を取得し、
いったんバインドを解除したうえであらためて '``CN=Alice Baker,OU=Sales,DC=foo,DC=net``'
でバインドしなおします。

.. _zend.ldap.introduction.theory-of-operations.account-name-canonicalization:

アカウント名の正規化
^^^^^^^^^^

**accountDomainName**\ および **accountDomainNameShort**\ オプションは、
次のふたつの目的で使用します。 (1) 複数ドメインによる認証
(どちらか一方が使えないときの代替機能) を実現する。 (2) ユーザ名を正規化する。
特に、名前の正規化の際には **accountCanonicalForm**\
オプションで指定した形式を使用します。
このオプションの値は、次のいずれかとなります:

.. _zend.ldap.using.theory-of-operation.account-name-canonicalization.table:

.. table:: accountCanonicalFormのオプション

   +-----------------------+-+-----------------------------------------+
   |名前                     |値|例                                        |
   +=======================+=+=========================================+
   |ACCTNAME_FORM_DN       |1|CN=Alice Baker,CN=Users,DC=example,DC=com|
   +-----------------------+-+-----------------------------------------+
   |ACCTNAME_FORM_USERNAME |2|abaker                                   |
   +-----------------------+-+-----------------------------------------+
   |ACCTNAME_FORM_BACKSLASH|3|EXAMPLE\\abaker                          |
   +-----------------------+-+-----------------------------------------+
   |ACCTNAME_FORM_PRINCIPAL|4|abaker@example.com                       |
   +-----------------------+-+-----------------------------------------+

デフォルトの正規化は、アカウントのドメイン名のオプションが
どのように設定されているかによって変わります。 **accountDomainNameShort**
が指定されている場合は、デフォルトの **accountCanonicalForm** の値は
``ACCTNAME_FORM_BACKSLASH`` となります。 それ以外の場合は、もし **accountDomainName**
が設定されていればデフォルトは ``ACCTNAME_FORM_PRINCIPAL`` となります。

アカウント名の正規化をすることで、 ``bind()``
に何が渡されたのかにかかわらずアカウントの識別に用いる文字列が一貫性のあるものになります。
たとえば、ユーザがアカウント名として ``abaker@example.com`` あるいは単に **abaker**
だけを指定したとしても、 **accountCanonicalForm** が 3
に設定されていれば正規化後の名前は **EXAMPLE\abaker** となります。

.. _zend.ldap.introduction.theory-of-operations.multi-domain-failover:

複数ドメインの認証とフェイルオーバー
^^^^^^^^^^^^^^^^^^

``Zend_Ldap`` コンポーネント自身は、 複数サーバでの認証を試みません。 しかし、
``Zend_Ldap`` はこのような場合に対応するようにも設計されています。
サーバのオプションを指定した配列の配列を順にたどり、
個々のサーバへのバインドを試みるのです。上で説明したように、 ``bind()``
は自動的に名前を正規化します。したがって、ユーザが ``abaker@foo.net``
を指定したか、あるいは **W\bcarter** や **cdavis** と指定したかにはかかわらず、
``bind()`` メソッドが成功するかどうかは
バインド時に認証情報が正しく指定されたかどうかによって決まります。

次の例では、複数ドメインでの認証と
フェイルオーバー機能を実装するために必要な技術を説明します:

.. code-block:: php
   :linenos:

   $acctname = 'W\\user2';
   $password = 'pass2';

   $multiOptions = array(
       'server1' => array(
           'host'                   => 's0.foo.net',
           'username'               => 'CN=user1,DC=foo,DC=net',
           'password'               => 'pass1',
           'bindRequiresDn'         => true,
           'accountDomainName'      => 'foo.net',
           'accountDomainNameShort' => 'FOO',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'OU=Sales,DC=foo,DC=net',
       ),
       'server2' => array(
           'host'                   => 'dc1.w.net',
           'useSsl'                 => true,
           'username'               => 'user1@w.net',
           'password'               => 'pass1',
           'accountDomainName'      => 'w.net',
           'accountDomainNameShort' => 'W',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'CN=Users,DC=w,DC=net',
       ),
   );

   $ldap = new Zend_Ldap();

   foreach ($multiOptions as $name => $options) {

       echo "Trying to bind using server options for '$name'\n";

       $ldap->setOptions($options);
       try {
           $ldap->bind($acctname, $password);
           $acctname = $ldap->getCanonicalAccountName($acctname);
           echo "SUCCESS: authenticated $acctname\n";
           return;
       } catch (Zend_Ldap_Exception $zle) {
           echo '  ' . $zle->getMessage() . "\n";
           if ($zle->getCode() === Zend_Ldap_Exception::LDAP_X_DOMAIN_MISMATCH) {
               continue;
           }
       }
   }

何らかの理由でバインドに失敗すると、その次のセットのサーバオプションでバインドを試みます。

``getCanonicalAccountName()`` をコールすると、 正規化したアカウント名を取得できます。
これを使用して、アプリケーションから関連データを取得できるようになります。
**accountCanonicalForm = 4** をすべてのサーバのオプションに設定することで、
どのサーバを使用する場合にも一貫した正規化が行えるようになっています。

ドメイン部つきのアカウント名 (単なる **abaker** ではなく ``abaker@foo.net`` や **FOO\abaker**
など)
を指定した場合は、そのドメインが設定済みのオプションのどれとも一致しなければ
特別な例外 ``LDAP_X_DOMAIN_MISMATCH`` が発生します。
この例外は、そのアカウントがサーバに見つからないことを表します。
この場合はバインドは行われず、 サーバとの余計な通信は発生しません。
この例では **continue** という指示は無意味であることに注意しましょう。
しかし、実際には、エラー処理やデバッグなどのために ``LDAP_NO_SUCH_OBJECT`` と
``LDAP_INVALID_CREDENTIALS`` だけではなく ``LDAP_X_DOMAIN_MISMATCH``
もチェックすることになるでしょう。

上のコードは、 :ref:`Zend_Auth_Adapter_Ldap <zend.auth.adapter.ldap>`
の中で使用するコードと非常によく似ています。実際のところ、
複数ドメインとフェイルオーバー機能をもつ *LDAP* 基本認証を行うのなら、
この認証アダプタを使用する (あるいはコードをコピーする) ことをおすすめします。


