.. EN-Revision: none
.. _zend.validator.validator_chains:

校验器链
====

通常，多个校验器按照特定的顺序被用于某些值。下面的代码示范一个办法去解决
:ref:`introduction <zend.validator.introduction>`\
中的例子的要求，即用户名必须在6到12个字符的文字数字组合：

   .. code-block:: php
      :linenos:

      // Create a validator chain and add validators to it
      $validatorChain = new Zend\Validate\Validate();
      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12))
                     ->addValidator(new Zend\Validate\Alnum());

      // Validate the username
      if ($validatorChain->isValid($username)) {
          // username passed validation
      } else {
          // username failed validation; print reasons
          foreach ($validatorChain->getMessages() as $message) {
              echo "$message\n";
          }


校验器按照它们被加到 *Zend_Validate*\
的顺序执行。在上面的例子中，用户名首先被检查来确保它的长度在6到12个字符，然后它被检查来确保它只包含文字和数字。不管第一个校验（检查长度是否6到12）是否成功，第二个校验（检查是否文字数字组合）总被执行。这就意味着如果两个校验都失败，
*getMessages()*\ 将为两个校验器都返回失败信息。

在某些情况下，如果校验过程失败， 让校验器中断校验器链符合常识。 *Zend_Validate* 在
*addValidator()*\ 方法中使用第二个参数来支持这样的用例。通过设置 *$breakChainOnFailure*\ 为
*true*\
，如果校验失败，校验器将中断校验器链执行，这样就避免了在这个情形下运行其他已经被决定是不必要的或不适当的校验。如果上面的例子被写成如下，如果字串长度校验失败，文字数字组合校验就不会发生：


   .. code-block:: php
      :linenos:

      $validatorChain->addValidator(new Zend\Validate\StringLength(6, 12), true)
                     ->addValidator(new Zend\Validate\Alnum());




任何实现 *Zend\Validate\Interface*\ 的对象都可以被用作校验器链。


