.. EN-Revision: none
.. _zend.validator.introduction:

简介
==

Zend_Validate
组件提供一组通用的校验器。它也提供了一个简单的校验器链机制，即在用户定义的顺序下，多个校验器可以被用于单个的数据。

.. _zend.validator.introduction.definition:

什么是校验器（validator）?
------------------

校验器根据要求检查它的输入并产生一个布尔结果--是否输入被成功校验。如果输入不符合要求，校验器另外地提供信息来说明输入不符合要求。

例如，一个 web 应用可能要求一个用户名的长度在6
到12个字符并可能只包含数字和文字。一个校验器可以被用来确保用户名符合要求。如果一个用户名不符合一个或者全部两个要求，知道它到底不符合哪个要求将非常有用。

.. _zend.validator.introduction.using:

校验器的基本用法
--------

用这种方法定义校验为 *Zend_Validate_Interface*\ 提供了基础，它定义了两个方法， *isValid()*
和 *getMessages()*\ 。 *isValid()*\
方法根据提供的值来校验，当且仅当这个值通过校验条件，它返回 *true*\ 。

如果 *isValid()*\ 返回 *false*\ ， *getMessages()*
返回一个消息数组来解释校验失败的原因。数组键是识别校验失败原因的短字符串，数组的值是相对应的人类可读的字符串消息。键和值是独立于类的；每个校验类定义它自己的校验失败消息和独一无二的键来识别它们。每个类也有
*const*\ 定义用来为校验失败原因匹配每个识别器。

.. note::

   *getMessages()* 方法只为最近 *isValid()*\ 的调用返回校验失败消息。对 *isValid()*\
   每个调用清除由前一个 *isValid()*\ 调用导致的任何消息和错误，因为很可能每个
   *isValid()*\ 调用用于不同的输入值。

下面的例子示例一个e-mail地址的校验：

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/EmailAddress.php';

      $validator = new Zend_Validate_EmailAddress();

      if ($validator->isValid($email)) {
          // email 有效
      } else {
          // email 无效; 打印原因
          foreach ($validator->getMessages() as $messageID => $message) {
              echo "Validation failure '$messageID': $message\n";
          }
      }




.. _zend.validator.introduction.messages:

定制消息
----

校验类提供了一个 *setMessage()*\ 方法，你可以指定校验失败后由 *getMessages()*\
返回的消息的格式。这个方法的第一个参数是一个包含错误信息的的字符串。你可以在字符串中包含令牌，它将被和校验器相关的数据替换。所有的校验器都支持令牌
*%value%*\ ；这被你传递给 *isValid()*\
的值替换。其它的令牌按情况在每个校验类中被支持。例如， *%max%*\ 是一个被
*Zend_Validate_LessThan*\ 支持的令牌。The *getMessageVariables()*\
方法返回一个被校验器支持的令牌变量的数组。

第二个可选的参数是一个字符串，它识别是否校验失败消息模板被设置，当校验类定义了多于一个失败的原因的时候，这很有用。如果你忽略第二个参数，
*setMessage()*\
假定你指定的消息应该被用为在校验类中声明的第一个消息模板。许多校验类只定义了一个错误消息模板，所以不需要指定哪个消息模板需要修改。



   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/StringLength.php';

      $validator = new Zend_Validate_StringLength(8);

      $validator->setMessage(
          'The string \'%value%\' is too short; it must be at least %min% characters',
          Zend_Validate_StringLength::TOO_SHORT);

      if (!$validator->isValid('word')) {
          $messages = $validator->getMessages();
          echo $current($messages);

          // echoes "The string 'word' is too short; it must be at least 8 characters"
      }




你可以用 *setMessages()*\ 方法设置多个消息。它的参数是一个包含key/message对的数组。

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/StringLength.php';

      $validator = new Zend_Validate_StringLength(8, 12);

      $validator->setMessages( array(
          Zend_Validate_StringLength::TOO_SHORT => 'The string \'%value%\' is too short',
          Zend_Validate_StringLength::TOO_LONG  => 'The string \'%value%\' is too long'
      ));




如果你的应用程序要求更灵活的校验失败报告，你可以访问和消息令牌同名的属性，这个消息令牌由给定的校验类支持。
*value*\ 属性在校验器中总是有效；它是一个你指定作为 *isValid()*\
的参数的值。其他属性按照情况在每个校验类中被支持。

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/StringLength.php';

      $validator = new Zend_Validate_StringLength(8, 12);

      if (!validator->isValid('word')) {
          echo 'Word failed: '
              . $validator->value
              . '; its length is not between '
              . $validator->min
              . ' and '
              . $validator->max
              . "\n";
      }




.. _zend.validator.introduction.static:

使用静态 is() 方法
------------

如果加载一个校验类并创建这个校验器的实例不方便，你可以使用静态方法
*Zend_Validate::is()*\
作为可选的调用风格。第一个参数是一个数据输入值，你将把它传递给 *isValid()*\
方法。第二个参数是一个字符串，它和校验类的基本名字对应，和 *Zend_Validate*\
名字空间相关。 *is()*\ 方法自动加载这个类，创建一个实例，并应用 *isValid()*\
方法到数据输入。

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate.php';

      if (Zend_Validate::is($email, 'EmailAddress')) {
          // 是, email 有效
      }




如果校验器需要，你也可以传递一个构造器参数的数组。

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate.php';

      if (Zend_Validate::is($value, 'Between', array(1, 12))) {
          // Yes, $value is between 1 and 12
      }




和 *isValid()*\ 方法一样， *is()*\ 方法返回一个布尔值。当使用静态 *is()*\
方法时，校验失败消息不可用。

静态用法对于调用专用校验器可能方便，但如果为多重输入运行一个校验器，使用非静态用法更有效，创建一个校验器对象的实例并调用
*isValid()*\ 方法。

并且， *Zend_Filter_Input*
类允许你按需求实例化和运行多个过滤器和校验器类来处理输入数据集合，参见 :ref:`
<zend.filter.input>`\ 。


