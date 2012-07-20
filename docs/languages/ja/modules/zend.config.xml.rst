.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` を使用すると、シンプルな *XML*
形式で保存した設定データを、オブジェクトのプロパティとして扱えるようになります。
*XML* ファイルあるいは文字列のルート要素は設定には関係しないので、
任意の名前がつけられます。 その直下のレベルの *XML*
要素が設定データのセクションに対応します。 セクションレベルの要素の下に *XML*
要素を配置することで、 階層構造をサポートします。 末端レベルの *XML*
要素が設定データの値に対応します。 セクションの継承は、 *XML* の属性 **extends**
でサポートされます。この属性の値が、
データを継承しているセクション名を表します。

.. note::

   **返り値の型**

   ``Zend_Config_Xml`` で読み込んだ設定データは、
   常に文字列形式で返されます。必要に応じて、
   文字列から適切な型に変換してください。

.. _zend.config.adapters.xml.example.using:

.. rubric:: Zend_Config_Xml の使用法

この例は、 ``Zend_Config_Xml`` を使用して *XML*
ファイルから設定データを読み込むための基本的な方法を説明するものです。
この例では、運用環境の設定と開発環境の設定を両方管理しています。
開発環境用の設定データは運用環境用のものと非常に似ているので、
開発環境用のセクションは運用環境用のセクションを継承させています。
今回の場合なら、逆に運用環境用のセクションを開発環境用のものから継承させてもいいでしょう。
そうしたからといって特に状況が複雑になるわけではありません。
ここでは、次のような内容の設定データが ``/path/to/config.xml``
に存在するものとします。

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter>pdo_mysql</adapter>
               <params>
                   <host>db.example.com</host>
                   <username>dbuser</username>
                   <password>secret</password>
                   <dbname>dbname</dbname>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host>dev.example.com</host>
                   <username>devuser</username>
                   <password>devsecret</password>
               </params>
           </database>
       </staging>
   </configdata>

次に、開発者が開発環境用の設定データを *XML*
ファイルから読み込むことを考えます。 これは簡単なことで、単に *XML*
ファイルとセクションを指定するだけです。

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host;   // "dev.example.com" と出力します
   echo $config->database->params->dbname; // "dbname" と出力します

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Zend_Config_Xml におけるタグの属性の使用

``Zend_Config_Xml`` では、設定内でノードを定義する際にさらに 2
通りの方法を用意しています。 どちらも属性を使用するものです。 **extends** 属性や
**value** 属性は予約語 (後者は、属性を使う 2 番目の方法で使用します)
となり、使用できません。属性を使用する方法のひとつは、
親ノードに属性を追加するものです。 これが、そのノードの子と見なされます。

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret" dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser" password="devsecret"/>
           </database>
       </staging>
   </configdata>

もうひとつの方法は、設定ファイルの記述量を減らすことはありません。
ただ、同じタグ名を何度も書く必要がなくなるので保守性は上がります。
単純に空のタグを作成し、その値を **value** 属性に含めます。

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter value="pdo_mysql"/>
               <params>
                   <host value="db.example.com"/>
                   <username value="dbuser"/>
                   <password value="secret"/>
                   <dbname value="dbname"/>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host value="dev.example.com"/>
                   <username value="devuser"/>
                   <password value="devsecret"/>
               </params>
           </database>
       </staging>
   </configdata>

.. note::

   **XML 文字列**

   ``Zend_Config_Xml`` は、データベースなどから取得した *XML*
   文字列を直接読み込むこともできます。
   文字列はコンストラクタの最初のパラメータとして渡し、最初は **'<?xml'**
   で始まらなければなりません。

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config>
          <production>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      $config = new Zend_Config_Xml($string, 'staging');

.. note::

   **Zend_Config XML 名前空間**

   ``Zend_Config`` は独自の *XML*
   名前空間を持っており、パース処理に機能を追加できます。
   これを使用するには、名前空間 *URI* ``http://framework.zend.com/xml/zend-config-xml/1.0/``
   をルートノードで定義しなければなりません。

   この名前空間を有効にすると、 *PHP*
   の定数を設定ファイル内で使用できるようになります。 **extends**
   属性が新しい名前空間に移動し、 ``NULL`` 名前空間では非推奨となります。
   これは、Zend Framework 2.0 で完全に削除される予定です。

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config xmlns:zf="http://framework.zend.com/xml/zend-config-xml/1.0/">
          <production>
              <includePath>
                  <zf:const zf:name="APPLICATION_PATH"/>/library</includePath>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging zf:extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      define('APPLICATION_PATH', dirname(__FILE__));
      $config = new Zend_Config_Xml($string, 'staging');

      echo $config->includePath; // "/var/www/something/library" と表示します


