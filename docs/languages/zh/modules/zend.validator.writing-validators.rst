.. EN-Revision: none
.. _zend.validator.writing_validators:

编写校验器
=====

尽管提供了一组通用的校验器，但不可避免地，开发者还将为他们特定的需求来编写定制的校验器。编写定制的校验器的任务将在本节描述。

*Zend\Validate\Interface* 定义了三个方法， *isValid()*\ ， *getMessages()* 和 *getErrors()*,
为了创建校验对象，它们可以在用户的类里被实现。实现 *Zend\Validate\Interface*\
接口的对象可以用 *Zend\Validate\Validate::addValidator()* 添加到校验链里。这样的对象也可以和
:ref:`Zend\Filter\Input <zend.filter.input>`\ 一起使用。

也许你已经从上面关于 的描述中推断出，不论一个值是否被校验成功，校验类为Zend
Framework返回一个布尔值。它们也提供关于 **why**\
一个值校验失败的信息。校验失败原因的有效性对于不同用途的应用程序可能很有价值，象为可用性分析提供的统计量。

基本校验失败消息的功能在 *Zend\Validate\Abstract*\
中实现。当创建一个校验类，简单地扩展 *Zend\Validate\Abstract*\
来包括这个功能。在扩展类里你将实现 *isValid()*
方法逻辑和定义消息变量和消息模板，它和可能发生的校验失败类型相对应。如果校验测试一个值失败，
*isValid()* 应该返回 *false*\ 。如果这个值通过校验测试， *isValid()* 应该返回 *true*\ 。

一般地， *isValid()*\
方法不应该抛出任何异常，除了不可能决定输入值是否有效。一些抛出异常的合情合理的例子可能是如果文件不能被打开，LDAP服务器不能被联系，或者数据库连接无效，并且有些事情必须由校验成功或失败来决定。

.. _zend.validator.writing_validators.example.simple:

.. rubric:: 创建简单校验类

下面的例子演示如何编写一个非常简单的定制的校验器。在这个例子中，校验规则简单，输入值必须是浮点数值。


   .. code-block:: php
      :linenos:

      class MyValid_Float extends Zend\Validate\Abstract
      {
          const FLOAT = 'float';

          protected $_messageTemplates = array(
              self::FLOAT => "'%value%' is not a floating point value"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_float($value)) {
                  $this->_error(self::FLOAT);
                  return false;
              }

              return true;
          }
      }


这个类为它的单个校验失败消息定义了一个模板，它包括内置的魔术参数， *%value%*\
。如果校验失败，对 *_setValue()*\
的调用准备了自动插入被测试的值到失败消息的对象。对 *_error()*\
的调用跟踪校验失败的原因。因为这个类只定义了一个失败消息，没有必要为 *_error()*\
提供带有失败消息名字的模板。

.. _zend.validator.writing_validators.example.conditions.dependent:

.. rubric:: 编写有独立条件的校验类

下面的例子演示一组稍微复杂的校验规则，要求输入值是数字并有最小值和最大值的范围。由于下面确切的原因之一，输入值校验失败：




   - 输入值不是数字。

   - 输入值小于允许的最小值。

   - 输入值大于允许的最大值。



这些校验失败的原因被翻译为在类中的定义：

   .. code-block:: php
      :linenos:

      class MyValid_NumericBetween extends Zend\Validate\Abstract
      {
          const MSG_NUMERIC = 'msgNumeric';
          const MSG_MINIMUM = 'msgMinimum';
          const MSG_MAXIMUM = 'msgMaximum';

          public $minimum = 0;
          public $maximum = 100;

          protected $_messageVariables = array(
              'min' => 'minimum',
              'max' => 'maximum'
          );

          protected $_messageTemplates = array(
              self::MSG_NUMERIC => "'%value%' is not numeric",
              self::MSG_MINIMUM => "'%value%' must be at least '%min%'",
              self::MSG_MAXIMUM => "'%value%' must be no more than '%max%'"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_numeric($value)) {
                  $this->_error(self::MSG_NUMERIC);
                  return false;
              }

              if ($value < $this->minimum) {
                  $this->_error(self::MSG_MINIMUM);
                  return false;
              }

              if ($value > $this->maximum) {
                  $this->_error(self::MSG_MAXIMUM);
                  return false;
              }

              return true;
          }
      }


Public 属性 *$minimum* 和 *$maximum*
分别为成功校验一个值被建立用来提供最小和最大值边界。这个类也定义了两个消息变量和public属性相对应并允许
*min* 和 *max* 与 *value* 一起被用在作为魔术参数的消息模板，

注意如果任何在 *isValid()*\
中的校验检查失败，一个恰当的失败消息被准备，并且方法立即返回 *false*\
。这些校验规则因此继续独立。换句话说，如果一个测试失败，不需要测试任何后来的校验规则。然而这本来不是个案例。下面的例子示例如何编写带有独立校验规则的类，校验对象返回什么校验企图失败的。

.. _zend.validator.writing_validators.example.conditions.independent:

.. rubric:: 带有独立条件、多重失败原因的校验

考虑编写一个为密码加强强度的校验类－当用户被要求为帮助使用户账户安全而选择符合一定条件的密码。让我们假设口令安全条件加强那个密码：




   - 至少8个字符长，

   - 包括至少一个大写字母，

   - 包括至少一个小写字母，

   - 并至少包括一个数字字符。



下面的类实现这些校验条件：

   .. code-block:: php
      :linenos:

      class MyValid_PasswordStrength extends Zend\Validate\Abstract
      {
          const LENGTH = 'length';
          const UPPER  = 'upper';
          const LOWER  = 'lower';
          const DIGIT  = 'digit';

          protected $_messageTemplates = array(
              self::LENGTH => "'%value%' must be at least 8 characters in length",
              self::UPPER  => "'%value%' must contain at least one uppercase letter",
              self::LOWER  => "'%value%' must contain at least one lowercase letter",
              self::DIGIT  => "'%value%' must contain at least one digit character"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              $isValid = true;

              if (strlen($value) < 8) {
                  $this->_error(self::LENGTH);
                  $isValid = false;
              }

              if (!preg_match('/[A-Z]/', $value)) {
                  $this->_error(self::UPPER);
                  $isValid = false;
              }

              if (!preg_match('/[a-z]/', $value)) {
                  $this->_error(self::LOWER);
                  $isValid = false;
              }

              if (!preg_match('/\d/', $value)) {
                  $this->_error(self::DIGIT);
                  $isValid = false;
              }

              return $isValid;
          }
      }


注意在 *isValid()*\ 中的四个条件测试不立即返回 *false*\ 。这允许校验类提供 **所有的**\
输入的密码不符合要求的原因。如果例如一个用户打算输入"*#$%*"字符串作为密码，
*isValid()*\ 将导致所有四个校验失败消息被后来的 *getMessages()*\ 调用返回。


