.. EN-Revision: none
.. _zend.soap.wsdl:

WSDLアクセッサ
=========

.. note::

   WSDL文書による操作を行なうために、 内部的に ``Zend\Soap\Server``\
   コンポーネントによって ``Zend\Soap\Wsdl``\ が使われます。
   それでも、このクラスにより提供される機能を独自の必要性によって使うこともできます。
   ``Zend\Soap\Wsdl``\ パッケージは、パーサーとWSDL文書のビルダーを含みます。

   あなたに使う予定がなければ、この節を読み飛ばすことができます。

.. _zend.soap.wsdl.constructor:

Zend\Soap\Wsdlコンストラクタ
---------------------

``Zend\Soap\Wsdl``\ コンストラクタは３つのパラメータをとります:

   . *$name*- 記述されたウェブサービスの名前。

   . *$uri*- WSDLが利用できる *URI*
     (ファイルシステムのファイルへのリファレンスでも可)

   . *$strategy*- 複雑な型（オブジェクト）を検出する方策を
     識別するために用いられるオプションのフラグです。
     これはバージョン1.7以前はブール値 *$extractComplexTypes*\ でしたが、
     後方互換性のためにまだブール値として設定できます。
     デフォルトで、1.6の検出動作が設定されます。
     複雑な型の検出の方策について詳しくは、この節をご覧下さい: :ref:`
     <zend.soap.wsdl.types.add_complex>`



.. _zend.soap.wsdl.addmessage:

addMessage()メソッド
----------------

``addMessage($name, $parts)``\ メソッドは、新しいメッセージの説明をWSDL文書に加えます。
(/definitions/message 要素)

``Zend\Soap\Server``\ および ``Zend\Soap\Client``\ の機能に関して、
各々のメッセージはメソッドと対応します。

*$name*\ パラメータはメッセージの名前を示します。

*$parts*\ パラメータは *SOAP*\ 呼び出しパラメータを表すメッセージ部分の配列です。
それは連想配列です: 'part name' (*SOAP*\ 呼び出しパラメータ名) => 'part type'.

型マッピングの管理は ``addTypes()``\ や ``addTypes()``\ 、 および ``addComplexType()``\
メソッド（下記参照）を用いて実行されます。

.. note::

   メッセージ部分は 'element' または 'type' 属性を型決定のために使います。
   (`http://www.w3.org/TR/wsdl#_messages`_\ をご覧ください).

   'element' 属性は、データ型定義の対応する要素を参照しなければなりません。 'type'
   属性は、対応するcomplexType項目を参照します。

   標準XSD型のすべてで 'element' および 'complexType' 定義の両方があります。
   (`http://schemas.xmlsoap.org/soap/encoding/`_\ 参照)

   ``Zend\Soap\Wsdl::addComplexType()``\ メソッドを用いて追加されるであろう、
   標準ではない型のすべてがWSDL文書の '/definitions/types/schema/' セクションの 'complexType'
   ノードで記述されます。

   そして ``addMessage()``\ メソッドは型を表現するために、 常に 'type' 属性を使います。

.. _zend.soap.wsdl.add_port_type:

addPortType()メソッド
-----------------

``addPortType($name)``\ メソッドは指定されたポートタイプ名で WSDL文書 (/definitions/portType)
に新規のポートタイプを追加します。

``Zend\Soap\Server``\
の実装に関して定義されるウェブサービスメソッドのセットと結びつきます。

詳しくは `http://www.w3.org/TR/wsdl#_porttypes`_\ をご覧ください。

.. _zend.soap.wsdl.add_port_operation:

addPortOperation()メソッド
----------------------

``addPortOperation($portType, $name, $input = false, $output = false, $fault = false)``
メソッドは、新しいポート・オペレーションをWSDL文書 (/definitions/portType/operation) の
指定されたポート・タイプに加えます。

各々のポート・オペレーションは ``Zend\Soap\Server``\ 実装では、
クラス・メソッド（ウェブサービスがクラスに基づくならば）
または関数（ウェブサービスがメソッドセットに基づくならば）に対応します。

それも、指定されたパラメータ、 *$input*\ や *$output*\ および *$fault*\ に従って、
対応するポート・オペレーション・メッセージを加えます。

   .. note::

      ``Zend\Soap\Server``\ クラスに基づいてサービスを記述するために、 ``Zend\Soap\Server``\
      コンポーネントは各々のポート・オペレーションのために2つのメッセージを生成します:


         - *$methodName . 'Request'*\ という名前で入力メッセージ。

         - *$methodName . 'Response'*\ という名前で出力メッセージ。





詳しくは `http://www.w3.org/TR/wsdl#_request-response`_\ をご覧ください。

.. _zend.soap.wsdl.add_binding:

addBinding()メソッド
----------------

``addBinding($name, $portType)``\ メソッドは、新しいバインディングをWSDL文書
(/definitions/binding) に加えます。

'binding' WSDL文書ノードでは、
メッセージ形式と特定のportTypeによって定義されるオペレーションとメッセージに関するプロトコル詳細を定義します。
(`http://www.w3.org/TR/wsdl#_bindings`_\ をご覧ください)

メソッドはバインディング・ノードをつくって、それを返します。
それから、実際のデータで満たすために使われるかもしれません。

``Zend\Soap\Server``\ の実装ではWSDL文書の 'binding' 要素のために *$serviceName . 'Binding'*
の名前が使われます。

.. _zend.soap.wsdl.add_binding_operation:

addBindingOperation()メソッド
-------------------------

``addBindingOperation($binding, $name, $input = false, $output = false, $fault = false)``
メソッドはバインディング要素 (/definitions/binding/operation)
に指定された名前で操作を追加します。

指定されたパラメータに従って、 入力・出力・false値を持つ 'operation'
要素を加えるために、 入力（ *$binding*\ パラメータ）として ``addBinding()``\
によって返される *XML_Tree_Node*\ オブジェクトをそのメソッドは取得します。

``Zend\Soap\Server``\ の実装で、 'soap:body' 要素を '<soap:body use="encoded"
encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"/> として定義している入出力エントリで、
ウェブサービス・メソッドごとに対応するバインディング・エントリを加えます。

詳しくは `http://www.w3.org/TR/wsdl#_bindings`_\ をご覧ください。

.. _zend.soap.wsdl.add_soap_binding:

addSoapBinding()メソッド
--------------------

``addSoapBinding($binding, $style = 'document', $transport = 'http://schemas.xmlsoap.org/soap/http')``
メソッドは、指定されたスタイルとトランスポート（ ``Zend\Soap\Server``\ の実装では、
*HTTP*\ についてRPCスタイルを使用します）で *SOAP*\ バインディング項目 ('soap:binding')
をバインディング要素（それは、あるポートタイプにすでにリンクされます）に追加します。

'/definitions/binding/soap:binding' 要素は、 バインディングが *SOAP*\
プロトコル形式に束縛されることを示すのに用いられます。

詳しくは `http://www.w3.org/TR/wsdl#_bindings`_\ をご覧ください。

.. _zend.soap.wsdl.add_soap_operation:

addSoapOperation()メソッド
----------------------

``addSoapOperation($binding, $soap_action)``\ メソッドは、 *SOAP*\ 操作項目 ('soap:operation')
を指定されたアクションでバインディング要素に加えます。 'soap:operation' 要素の
'style' 属性は、（RPC指向か文書指向の）プログラミング・モデルが ``addSoapBinding()``\
メソッドを使用しているかもしれないので使われません。

'/definitions/binding/soap:operation' 要素の 'soapAction' 属性は、
この操作のためにSOAPActionヘッダの値を指定します。 この属性は *HTTP*\ を通じた *SOAP*\
で必須です。 他のトランスポートのために指定しては **いけません**\ 。

``Zend\Soap\Server``\ の実装では、 *SOAP*\ 操作アクション名のために *$serviceUri . '#' .
$methodName*\ を使います。

詳しくは `http://www.w3.org/TR/wsdl#_soap:operation`_\ をご覧ください。

.. _zend.soap.wsdl.add_service:

addService()メソッド
----------------

``addService($name, $port_name, $binding, $location)``\ メソッドは
指定したウェブサービス名やポートタイプ及びバインディング、ロケーションとともに
WSDL文書に '/definitions/service' 要素を追加します。

WSDL
1.1では、サービスごとにいくつかのポートタイプ(操作のセット)を持つことができます。
この能力は ``Zend\Soap\Server``\ の実装では使われず、 ``Zend\Soap\Wsdl``\
クラスでサポートされません。

``Zend\Soap\Server``\ の実装に使用します:

   - ウェブサービス名として *$name . 'Service'*

   - ポートタイプ名として *$name . 'Port'*

   - バインディング名として *'tns:' . $name . 'Binding'* [#]_

   - クラスを使うウェブサービスの定義のためのサービス *URI*\ としてスクリプトの
     *URI* [#]_

*$name*\ がクラスを使うウェブサービス定義モードのためのクラス名と
関数のセットを使うウェブサービス定義モードのためのスクリプト名前であるところ。

詳しくは `http://www.w3.org/TR/wsdl#_services`_\ をご覧ください。

.. _zend.soap.wsdl.types:

型のマッピング
-------

``Zend_Soap`` WSDLアクセッサの実装では、 *PHP*\ と *SOAP*\
型の間で以下の型マッピングを使用します:

   - *PHP*\ 文字列 <-> *xsd:string*

   - *PHP* integer <-> *xsd:int*

   - *PHP* floatおよびdouble値 <-> *xsd:float*

   - *PHP*\ ブール値 <-> *xsd:boolean*

   - *PHP*\ 配列 <-> *soap-enc:Array*

   - *PHP*\ オブジェクト <-> *xsd:struct*

   - *PHP*\ クラス <-> 複雑な型のストラテジーに基づいた (:ref:`
     <zend.soap.wsdl.types.add_complex>`\ 参照) [#]_

   - *PHP* void <-> 空の型

   - なんらかの理由でこれらの型のいずれとも型が一致しなければ、 *xsd:anyType*\
     が使われます。

*xsd:* が "http://www.w3.org/2001/XMLSchema" ネームスペースであるところでは、 *soap-enc:* は
"http://schemas.xmlsoap.org/soap/encoding/" ネームスペースで、 *tns:* はサービスのための "target
namespace" です。

.. _zend.soap.wsdl.types.retrieve:

型情報の取得
^^^^^^

``getType($type)``\ メソッドは、指定された *PHP*
型をマップするために用いられるかもしれません:

.. code-block:: php
   :linenos:

   ...
   $wsdl = new Zend\Soap\Wsdl('My_Web_Service', $myWebServiceUri);

   ...
   $soapIntType = $wsdl->getType('int');

   ...
   class MyClass {
       ...
   }
   ...
   $soapMyClassType = $wsdl->getType('MyClass');

.. _zend.soap.wsdl.types.add_complex:

複雑な型の情報を追加する
^^^^^^^^^^^^

``addComplexType($type)``\ メソッドは、 複雑な型（ *PHP*\
クラス）をWSDL文書に追加するために使われます。

メソッド・パラメータの対応する複雑な型を追加するか、型を返すために、
``getType()``\ メソッドによってそれは自動的に使われます。

その検出とビルドのアルゴリズムは、複雑な型に対して現在実装中の検出ストラテジーに基づきます。
文字列でのクラス名指定、 または、コンストラクタの第３パラメータとして
``Zend\Soap\Wsdl\Strategy\Interface``\ を実装したインスタンス、 または、 ``Zend\Soap\Wsdl``\ の
*setComplexTypeStrategy($strategy)*\ 関数の利用のいずれかにより、
検出ストラテジーを設定できます。 以下の検出ストラテジーが、現在存在します:

- クラス ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``:
  デフォルトで許可されます（第3のコンストラクタ・パラメータが設定されないとき）。
  クラス型の public 属性項目を反復して、
  複雑なオブジェクト型のサブタイプとして登録します。

- クラス ``Zend\Soap\Wsdl\Strategy\AnyType``: 単純なXSD型 xsd:anyType
  に、すべての複雑な型を投げます。 複雑な型検出のこのショートカットが *PHP*\
  のような型検査の弱い言語により、うまく取り扱われるかどうか注意してください。

- クラス ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeSequence``:
  このストラテジーにより、以下のようにタイプの戻りパラメータを指定できます:
  *int[]*\ または *string[]*. Zend Framework バージョン 1.9 以降、 それは単純な *PHP*\
  型（例えばint）、文字列、ブール値、floatなどを取り扱えるばかりではなく、
  オブジェクトおよびオブジェクトの配列も指定できます。

- クラス ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeComplex``:
  このストラテジーにより、非常に複雑な多数のオブジェクトを見つけることができます。
  オブジェクト型は ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``\ に基づいて
  検出されます。配列はその定義の周囲を包まれます。

- クラス ``Zend\Soap\Wsdl\Strategy\Composite``: このストラテジーは、 ``connectTypeToStrategy($type,
  $strategy)``\ メソッドを通じて 希望するストラテジーに *PHP*\
  の複雑な型（クラス名）を接続することによって、
  すべてのストラテジーを結合できます。 完全なタイプマップを、 *$type*-> *$strategy*
  のペアを持つ配列として コンストラクタに与えられます。
  もし未知の型の追加が必要であれば、第２パラメータで使われるデフォルト・ストラテジーを指定します。
  このパラメータのデフォルトは、 ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``\ です。

``addComplexType()``\ メソッドは、指定された *PHP*\ クラスの名前で、
記述された複雑な型ごとに '/definitions/types/xsd:schema/xsd:complexType' 要素を生成します。

クラスのプロパティは、プロパティをWSDL記述にインクルードしておくために、記述された
*PHP*\ 型でdocblock部を持って **いなければなりません**\ 。

``addComplexType()``\
は型がWSDL文書の型セクションの範囲内ですでに記述されるかどうか調べます。

このメソッドが型定義部で２回以上再帰で呼ばれると、それは重複を防ぎます。

詳しくは `http://www.w3.org/TR/wsdl#_types`_\ をご覧ください。

.. _zend.soap.wsdl.add_documentation:

addDocumentation()メソッド
----------------------

``addDocumentation($input_node, $documentation)``\ メソッドは、 オプションの 'wsdl:document'
要素を用いて人間の読める文書を追加します。

'/definitions/binding/soap:binding' 要素は、 バインディングが *SOAP*\
プロトコル構成にバインドされることを示すために使われます。

詳しくは `http://www.w3.org/TR/wsdl#_documentation`_\ をご覧ください。

.. _zend.soap.wsdl.retrieve:

確定したWSDL文書を取得
-------------

``toXML()``\ や ``toDomDocument()``\ および ``dump($filename = false)``\ メソッドは、 WSDL文書を
*XML*\ やDOMの構造もしくはファイルとして取得するために使われるかもしれません。



.. _`http://www.w3.org/TR/wsdl#_messages`: http://www.w3.org/TR/wsdl#_messages
.. _`http://schemas.xmlsoap.org/soap/encoding/`: http://schemas.xmlsoap.org/soap/encoding/
.. _`http://www.w3.org/TR/wsdl#_porttypes`: http://www.w3.org/TR/wsdl#_porttypes
.. _`http://www.w3.org/TR/wsdl#_request-response`: http://www.w3.org/TR/wsdl#_request-response
.. _`http://www.w3.org/TR/wsdl#_bindings`: http://www.w3.org/TR/wsdl#_bindings
.. _`http://www.w3.org/TR/wsdl#_soap:operation`: http://www.w3.org/TR/wsdl#_soap:operation
.. _`http://www.w3.org/TR/wsdl#_services`: http://www.w3.org/TR/wsdl#_services
.. _`http://www.w3.org/TR/wsdl#_types`: http://www.w3.org/TR/wsdl#_types
.. _`http://www.w3.org/TR/wsdl#_documentation`: http://www.w3.org/TR/wsdl#_documentation

.. [#] *'tns:' namespace*\ はスクリプトの *URI* (*'http://' .$_SERVER['HTTP_HOST'] .
       $_SERVER['SCRIPT_NAME']*) として定義されます。
.. [#] *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*
.. [#] デフォルトで、 ``Zend\Soap\Wsdl``\ は複雑な型のための検出アルゴリズムとして
       ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``\ クラスで生成されます。
       AutoDiscoverコンストラクタの最初のパラメータは、
       ``Zend\Soap\Wsdl\Strategy\Interface``\ を実装した、
       どんな複雑な型ストラテジーでも、クラスの名前を持つ文字列でもとります。
       *$extractComplexType*\ との後方互換性のために、
       ブール変数は、以下の方法で解析されます: もし ``TRUE`` なら、
       ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``\ 、 もし ``FALSE`` なら、
       ``Zend\Soap\Wsdl\Strategy\AnyType``\ 。