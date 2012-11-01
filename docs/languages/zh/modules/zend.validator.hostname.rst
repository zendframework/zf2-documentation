.. EN-Revision: none
.. _zend.validator.set.hostnames:

主机名
===

Zend\Validate\Hostname允许你根据一组已知的规范来校验主机名。它检查三种不同的主机名：DNS主机名（例如domain.com），IP地址（例如1.2.3.4），和本地主机名（例如localhost）。缺省地，只有DNS主机名被匹配。

**基本用法**

一个基本用法的例子如下：

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/Hostname.php';
      $validator = new Zend\Validate\Hostname();
      if ($validator->isValid($hostname)) {
          // hostname appears to be valid
      } else {
          // hostname is invalid; print the reasons
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }



这个例子匹配主机名 *$hostname*\ 并在匹配失败的时候用 *$validator->getMessages()*\
来获得有用的错误信息。

**校验不同类型的主机名**

你可能发现你也想匹配IP地址，本地主机名，或者是所有允许类型的组合。这个可以在当你实例化它的时候通过传递参数给Zend\Validate\Hostname来实现。
参数应该是一个整型数，它来决定哪种主机名被允许。我们鼓励你使用常量。

Zend\Validate\Hostname 常量是： *ALLOW_DNS* 允许DNS主机名， *ALLOW_IP* 允许IP地址， *ALLOW_LOCAL*
允许本地网络名，和 *ALLOW_ALL* 允许所有三种类型。
你可以用下面的例子仅仅检查IP地址：

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Validate/Hostname.php';
      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_IP);
      if ($validator->isValid($hostname)) {
          // hostname appears to be valid
      } else {
          // hostname is invalid; print the reasons
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }





你可以用这些类型的组合，也可以用 *ALLOW_ALL*\
来接受所有主机名类型。例如，你可以通过如下例子实例化Zend\Validate\Hostname对象来接受DNS和本地主机名:


   .. code-block:: php
      :linenos:

      <?php

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS | Zend\Validate\Hostname::ALLOW_LOCAL);}



**校验国际域名**

一些国家代码顶级域名（ccTLDs），例如'de'（德国），在域名中支持国际字符。这些就是大家所知的国际域名（IDN）。这些域名可以用Zend\Validate\Hostname通过用于校验处理的扩展字符来匹配。

目前支持ccTLDs的有：



   - at (Austria)

   - ch (Switzerland)

   - li (Liechtenstein)

   - de (Germany)

   - fi (Finland)

   - hu (Hungary)

   - no (Norway)

   - se (Sweden)



匹配IDN域名就像使用标准主机名校验器一样简单，因为IDN匹配是缺省激活的。如果你想禁止IDN校验，可以通过传递参数给Zend\validate\Hostname构造器或通过
*$validator->setValidateIdn()*\ 方法来实现。

你可以象下面通过传递第二个参数给Zend\Validate\Hostname构造器来禁止IDN校验。

   .. code-block:: php
      :linenos:

      <?php

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS, false);

另外你可以通过传递 TRUE 或 FALSE 给 *$validator->setValidateIdn()* 来激活或者禁止 IDN
校验。如果你试图匹配一个当前不被支持的IDN主机名，并且如果有国际字符在其中，校验很可能会失败。当指定附加字符的ccTLD文件在Zend/Validate/Hostname下不存在时，一个正常的主机名校验将被执行。（这就是在解释上句话中为什么校验会失败，Jason
注）

请注意只有当你允许DNS主机名被校验，IDNs才能被校验。

**校验顶级域名**

缺省地主机名通过已知的TLDs列表来检查。如果不需要这个功能，它可以被禁止，就像禁止IDN支持一样。你可以通过传递第三个参数给Zend\Validate\Hostname构造器来禁止TLD校验。在下面的例子中，我们通过第二个参数来支持IDN校验。


   .. code-block:: php
      :linenos:

      <?php

      $validator = new Zend\Validate\Hostname(Zend\Validate\Hostname::ALLOW_DNS, true, false);

另外，你可以通过传递 TRUE 或 FALSE 给 *$validator->setValidateTld()* 来激活或禁止 TLD 校验。

请注意只有当你允许DNS主机名被校验，TLDs才能被校验。


