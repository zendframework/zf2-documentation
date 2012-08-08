.. EN-Revision: none
.. _zend.soap.autodiscovery:

自動検出
====

.. _zend.soap.autodiscovery.introduction:

自動検出導入
------

Zend Frameworkの中で実装される *SOAP*\ 機能は、 すべてのステップをより単純な *SOAP*\
通信のために必要とされるようにすることを目的とします。

*SOAP*\ は言語に依存しないプロトコルです。 そのため、 *PHP*\ から *PHP*\
への通信だけのために使われないかもしれません。

Zend Frameworkが利用されるかもしれない *SOAP*\ アプリケーションのために、
３種類の構成があります:

   . *SOAP*\ サーバー *PHP*\ のアプリケーション <---> *SOAP*\ クライアント *PHP*\
     のアプリケーション

   . *SOAP*\ サーバー *PHP*\ ではないアプリケーション <---> *SOAP*\ クライアント *PHP*\
     のアプリケーション

   . *SOAP*\ サーバー *PHP*\ のアプリケーション <---> *SOAP*\ クライアント *PHP*\
     ではないアプリケーション



*SOAP*\ サーバーで提供される機能を常に知っていなければなりません。 `WSDL`_\ は
ネットワーク・サービス *API*\ を詳細に記述するために使われます。

WSDL言語は、十分に複雑です。 (詳しくは `http://www.w3.org/TR/wsdl`_\ をご覧下さい)
そのため、WSDLの正しい説明を用意することは困難です。

もう一つの問題は、すでに既存のWSDLの変化をネットワーク・サービス *API*\
で同期することです。

両方の問題は、WSDL自動生成によって解決されるかもしれません。 この必要条件は、
*SOAP*\ サーバー自動検出です。 それは *SOAP*\
サーバー・アプリケーションで使われる、
オブジェクトに類似したオブジェクトを組み立て、
必要な情報を引き出して、この情報を使う正しいWSDLを生成します。

*SOAP*\ サーバー・アプリケーションのためにZend Frameworkを使う２つの方法があります:

   - 分離されたクラスを使用

   - 関数のセットを使用



両方のメソッドは、Zend Framework 自動検出機能によってサポートされます。

``Zend_Soap_AutoDiscover``\ クラスも、 *PHP*\ から `XSD型`_\
までデータ型マッピングをサポートします。

これは自動検出機能の一般的な用法の例です。 ``handle()``\
関数はWSDLファイルを生成してブラウザーにポストします。

   .. code-block:: php
      :linenos:

      class My_SoapServer_Class {
      ...
      }

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->setClass('My_SoapServer_Class');
      $autodiscover->handle();



ファイルまたは *XML*\
ストリングとして保存するために生成されたWSDLファイルへのアクセスも必要ならば、
AutoDiscoverクラスが提供する ``dump($filename)``\ または ``toXml()``\ 関数を使えます。

.. note::

   **Zend_Soap_AutodiscoverはSOAPサーバーではありません**

   クラス ``Zend_Soap_AutoDiscover``\ が 単独で *SOAP*\
   サーバーの働きをしない点に注意することは、非常に重要です。
   それはWSDLを生成して、それがリスンしているurlにアクセスした誰にでも届けるだけです。

   *SOAP*\ エンドポイントUriがデフォルト値、 *'http://' .$_SERVER['HTTP_HOST'] .
   $_SERVER['SCRIPT_NAME']* を使いますが、 しかしこれは ``setUri()``\ 関数や
   ``Zend_Soap_AutoDiscover``\ クラスのコンストラクタのパラメータで変更できます。
   このエンドポイントではリクエストをリスンする ``Zend_Soap_Server``\
   クラスを準備しなくてはいけません。



      .. code-block:: php
         :linenos:

         if(isset($_GET['wsdl'])) {
             $autodiscover = new Zend_Soap_AutoDiscover();
             $autodiscover->setClass('HelloWorldService');
             $autodiscover->handle();
         } else {
             //ここで現行ファイルを指示します。
             $soap = new Zend_Soap_Server("http://example.com/soap.php?wsdl");
             $soap->setClass('HelloWorldService');
             $soap->handle();
         }



.. _zend.soap.autodiscovery.class:

クラスの自動検出
--------

クラスが *SOAP*\ サーバー機能を提供することに使われるならば、
同じクラスはWSDL生成のために ``Zend_Soap_AutoDiscover``\ に提供されなければなりません:

   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->setClass('My_SoapServer_Class');
      $autodiscover->handle();



WSDL生成の間、以下の規則が使われます:

   - 生成されたWSDLは、RPCスタイルのウェブサービスを記述します。

   - クラス名が、記述されているウェブサービスの名前として使われます。

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*\ が WSDLをデフォルトで利用できる
     *URI*\ として使われます、 しかし、それは ``setUri()``\
     メソッドによって上書きできます。

     それは、名前（記述された複雑な型を含む）に関連したすべてのサービスのための
     ターゲット名前空間としても使われます。

   - クラス・メソッドは、１つの `ポートタイプ`_\ に 結び付けられます。

     *$className . 'Port'*\ はポートタイプ名として使われます。

   - 各々のクラス・メソッドは、対応するポート操作として登録されます。

   - 各々のメソッド・プロトタイプは、対応するリクエスト/レスポンスメッセージを生成します。

     いくつかのメソッド・パラメータがオプションならば、
     メソッドはいくつかのプロトタイプを持つかもしれません。



.. note::

   **重要!**

   WSDL自動検出では、パラメータを決定して型を返すために、
   開発者により提供される *PHP* docblockを利用します。
   実際、スカラー型にとっては、パラメータ型を決定する唯一の方法です。
   そして、戻り型にとっては、それらを決定する唯一の方法です。

   つまり、正しくて詳細で完全なdocblockを提供することは習慣というだけではなく、
   発見するクラスのために必要です。

.. _zend.soap.autodiscovery.functions:

関数の自動検出
-------

関数のセットが *SOAP*\ サーバー機能を提供することに使われるならば、
同じセットはWSDL生成のために ``Zend_Soap_AutoDiscovery``\ に提供されなければなりません:

   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->addFunction('function1');
      $autodiscover->addFunction('function2');
      $autodiscover->addFunction('function3');
      ...
      $autodiscover->handle();



WSDL生成の間、以下の規則が使われます:

   - 生成されたWSDLは、RPCスタイルのウェブサービスを記述します。

   - 現在のスクリプト名が、記述されているウェブサービスの名前として使われます。

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*\ が WSDLを利用できる *URI*\
     として使われます。

     それは、名前（記述された複雑な型を含む）に関連したすべてのサービスのための
     ターゲット名前空間としても使われます。

   - 関数は、１つの `ポートタイプ`_\ に 結び付けられます。

     *$functionName . 'Port'*\ はポートタイプ名として使われます。

   - 各々の関数は、対応するポート操作として登録されます。

   - 各々の関数プロトタイプは、対応するリクエスト/レスポンスメッセージを生成します。

     いくつかのメソッド・パラメータがオプションなら、
     関数はいくつかのプロトタイプを持つかもしれません。



.. note::

   **重要!**

   WSDL自動検出では、パラメータを決定して、型を返すために、
   開発者により提供される *PHP* docblockを利用します。
   実際、スカラー型にとっては、パラメータ型を決定する唯一の方法です。
   そして、戻り型にとっては、それらを決定する唯一の方法です。

   つまり、正しくて詳細で完全なdocblockを提供することは習慣というだけではなく、
   発見するクラスのために必要です。

.. _zend.soap.autodiscovery.datatypes:

データ型の自動検出
---------

入出力データ型は、以下のマッピングを用いて、ネットワーク・サービス型に変換されます:




   - *PHP*\ 文字列 <-> *xsd:string*

   - *PHP* integer <-> *xsd:int*

   - *PHP* floatおよびdouble値 <-> *xsd:float*

   - *PHP*\ ブール値 <-> *xsd:boolean*

   - *PHP*\ 配列 <-> *soap-enc:Array*

   - *PHP*\ オブジェクト <-> *xsd:struct*

   - *PHP*\ クラス <-> 複雑な型のストラテジーに基づいた (:ref:`
     <zend.soap.wsdl.types.add_complex>`\ 参照) [#]_

   - type[] または object[] (例えば int[]) <-> 複雑な型のストラテジーに基づいた

   - *PHP* void <-> 空の型

   - なんらかの理由でこれらの型のいずれとも型が一致しなければ、 *xsd:anyType*\
     が使われます。

*xsd:* が "http://www.w3.org/2001/XMLSchema" ネームスペースであるところでは、 *soap-enc:* は
"http://schemas.xmlsoap.org/soap/encoding/" ネームスペースで、 *tns:* はサービスのための "target
namespace" です。

.. _zend.soap.autodiscovery.wsdlstyles:

WSDLバインディングスタイル
---------------

WSDLは、異なるトランスポートのメカニズムとスタイルを提供します。
これは、WSDLのバインディング・セクションの範囲内で、 *soap:binding*\ および *soap:body*\
タグに影響を及ぼします。
クライアント毎に、本当に機能するオプションについて、それぞれの必要条件があります。
したがって、自動検出クラスでどんな *setClass*\ や *addFunction*\
メソッドでも呼び出す前に、 スタイルを設定できます。



   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      // デフォルトは 'use' => 'encoded' 及び
      // 'encodingStyle' => 'http://schemas.xmlsoap.org/soap/encoding/' です。
      $autodiscover->setOperationBodyStyle(
                          array('use' => 'literal',
                                'namespace' => 'http://framework.zend.com')
                      );

      // デフォルトは 'style' => 'rpc' 及び
      // 'transport' => 'http://schemas.xmlsoap.org/soap/http' です。
      $autodiscover->setBindingStyle(
                          array('style' => 'document',
                                'transport' => 'http://framework.zend.com')
                      );
      ...
      $autodiscover->addFunction('myfunc1');
      $autodiscover->handle();





.. _`WSDL`: http://www.w3.org/TR/wsdl
.. _`http://www.w3.org/TR/wsdl`: http://www.w3.org/TR/wsdl
.. _`XSD型`: http://www.w3.org/TR/xmlschema-2/
.. _`ポートタイプ`: http://www.w3.org/TR/wsdl#_porttypes

.. [#] ``Zend_Soap_AutoDiscover``\ は複雑な型のための検出アルゴリズムとして
       ``Zend_Soap_Wsdl_Strategy_DefaultComplexType``\ クラスで生成されます。
       AutoDiscoverコンストラクタの最初のパラメータは、
       ``Zend_Soap_Wsdl_Strategy_Interface``\ を実装した、
       どんな複雑な型ストラテジーでも、クラスの名前を持つ文字列でもとります。
       *$extractComplexType*\ との後方互換性のために、 ブール変数は ``Zend_Soap_Wsdl``\
       のように解析されます。 詳しくは :ref:`複雑な型を追加することについて
       Zend_Soap_Wsdlマニュアル <zend.soap.wsdl.types.add_complex>`\ をご覧下さい。