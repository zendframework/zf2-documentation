.. EN-Revision: none
.. _zend.captcha.operation:

Captcha 操作
==========

所有具体的 CAPTCHA 对象实现 *Zend_Captcha_Adapter*\ ，如下所示：

.. code-block:: php
   :linenos:

   interface Zend_Captcha_Adapter extends Zend_Validate_Interface
   {
       public function generate();

       public function render(Zend_View $view, $element = null);

       public function setName($name);

       public function getName();

       public function getDecorator();

       // Additionally, to satisfy Zend_Validate_Interface:
       public function isValid($value);

       public function getMessages();

       public function getErrors();
   }


增变器和访问器用于指定和获取 captcha 的标识符。 *getDecorator()*
可用通过名称或返回一个装饰器对象来指定一个 Zend_Form 装饰器。
然而用法的关键之处是 *generate()* 和 *render()*\ 。 *generate()* 用于生成 captcha
令牌。这个过程一般存储令牌到会话，所以你 可以根据后来的请求来比较。 *render()*
用来解析表示 captcha 的信息 － 可以是图像、figlet 或逻辑问题等。

一般的用例如下：

.. code-block:: php
   :linenos:

   // Originating request:
   $captcha = new Zend_Captcha_Figlet(array(
       'name' => 'foo',
       'wordLen' => 6,
       'timeout' => 300,
   ));
   $id = $captcha->generate();
   echo $captcha->render();

   // On subsequent request:
   // Assume captcha setup as before, and $value is the submitted value:
   if ($captcha->isValid($_POST['foo'], $_POST)) {
       // Validated!
   }



