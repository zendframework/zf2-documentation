.. EN-Revision: none
.. _zend.validator.set.email_addresses:

Email 地址
========

*Zend\Validate\EmailAddress*\
允许你校验一个email地址。首先校验器把email地址分成local-part和@hostname并试图按照email地址和主机名的规范来匹配它。

**基本用法**

一个基本用法的例子如下：

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress();
      if ($validator->isValid($email)) {
          // email appears to be valid
      } else {
          // email is invalid; print the reasons
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }


这个例子匹配email地址 *$email*\ 并在匹配失败的时候用 *$validator->getMessages()*\
来获得有用的错误信息。

**复杂的local parts**

*Zend\Validate\EmailAddress*\
根据RFC2822来匹配任何有效的email地址。例如，有效的email地址包括 *bob@domain.com*,
*bob+jones@domain.us*, *"bob@jones"@domain.com* 和 *"bob jones"@domain.com*\
。一些过时的email格式目前不再校验（例如email地址中的回车符或"\\"符）。

**校验不同类型的主机名**

Email地址中的主机名部分依靠 :ref:`Zend\Validate\Hostname <zend.validator.set.hostnames>`\
来校验。尽管你希望IP地址和本地主机名也被接受，但缺省地只有像 *domain.com*\
格式的DNS主机名被接受。 当然如果你想如愿，需要实例化 *Zend\Validate\EmailAddress*\
并传递一个参数来指明哪种主机名你想接受。更多的细节包含在 *Zend\Validate\Hostname*\
中。 下面的例子显示如何同时接受DNS和本地主机名：

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress(Zend\Validate\Hostname::ALLOW_DNS | Zend\Validate\Hostname::ALLOW_LOCAL);
      if ($validator->isValid($email)) {
          // email appears to be valid
      } else {
          // email is invalid; print the reasons
          foreach ($validator->getMessages() as $message) {
              echo "$message\n";
          }
      }




**检查主机名是否确实接受email**

email地址的格式正确并不意味着这个email地址确实存在。为解决这个问题，你可以用MX校验来检查一个MX(email)条目的主机名是否存在于DNS的纪录里。这将告诉你这个主机名接受email，但并不告诉你确切的email地址是有效的。

MX
检查不是缺省地激活的，并且目前只支持UNIX平台。为激活MX检查，你可以传递第二个参数给
*Zend\Validate\EmailAddress*\ 构造器。

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress(Zend\Validate\Hostname::ALLOW_DNS, true);


另外你可以传递 *true* 或 *false* 给 *$validator->setValidateMx()* 来激活或禁止 MX 校验。

用激活这个设置的网络函数将用来为你所想校验的email地址的主机名中的MX记录的存在做检查。请注意这将可能把你的脚本变慢。

**校验国际域名**

*Zend\Validate\EmailAddress*
也将匹配存在于某些域名中的国际字符。这就是国际域名（IDN）支持。这个是缺省激活，你可以通过用存在于
*Zend\Validate\EmailAddress* 中的内部的 *Zend\Validate\Hostname* 对象来改变设置来禁止。

   .. code-block:: php
      :linenos:

      $validator->hostnameValidator->setValidateIdn(false);


关于 *setValidateIdn()* 更多的信息在 *Zend\Validate\Hostname* 文档中。

请注意你有你允许DNS 主机名被校验，国际域名（IDNs）才被校验。

**校验顶级域名**

缺省地用已知的TLDs列表来检查主机名。你可以通过用存在于 *Zend\Validate\EmailAddress*
中的内部的 *Zend\Validate\Hostname* 对象来改变设置来禁止。

   .. code-block:: php
      :linenos:

      $validator->hostnameValidator->setValidateTld(false);


关于 *setValidateTld()* 更多的信息在 *Zend\Validate\Hostname* 文档中。

请注意你有你允许DNS 主机名被校验，顶级域名（TLDs）才被校验。


