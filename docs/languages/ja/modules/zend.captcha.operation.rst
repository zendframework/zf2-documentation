.. _zend.captcha.operation:

Captcha の方法
===========

すべての *CAPTCHA* アダプタは ``Zend_Captcha_Adapter`` を実装しています。
これは次のようなインターフェイスです。

.. code-block:: php
   :linenos:

   interface Zend_Captcha_Adapter extends Zend_Validate_Interface
   {
       public function generate();

       public function render(Zend_View $view, $element = null);

       public function setName($name);

       public function getName();

       public function getDecorator();

       // Zend_Validate_Interface のための追加のメソッド
       public function isValid($value);

       public function getMessages();

       public function getErrors();
   }

name アクセサを使用して、 *CAPTCHA* の識別子を設定したり取得したりします。
``getDecorator()`` を使用して ``Zend_Form`` のデコレータを指定します。
名前、あるいは実際のデコレータオブジェクトを返します。
しかし、本当に大事なのは ``generate()`` と ``render()`` です。 ``generate()`` は、 *CAPTCHA*
トークンを作成します。 通常は、このトークンをセッションに保存し、
その後のリクエストの内容と比較することになります。 ``render()`` は *CAPTCHA* の情報を
(画像や figlet、なぞなぞなどの形式で) レンダリングします。

典型的な使用例は、次のようになります。

.. code-block:: php
   :linenos:

   // Zend_View インスタンスを作成します
   $view = new Zend_View();

   // 最初のリクエスト
   $captcha = new Zend_Captcha_Figlet(array(
       'name' => 'foo',
       'wordLen' => 6,
       'timeout' => 300,
   ));

   $id = $captcha->generate();
   echo "<form method=\"post\" action=\"\">";
   echo $captcha->render($view);
   echo "</form>";

   // それ以降のリクエスト
   // すでに captcha が準備済みで、$_POST['foo'] の中身が
   // 次のようなキー/値の配列になっているものとします
   // id => captcha ID, input => captcha value
   if ($captcha->isValid($_POST['foo'], $_POST)) {
       // 正解!
   }


