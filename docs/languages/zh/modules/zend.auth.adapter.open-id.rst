.. _zend.auth.adapter.openid:

Open ID Authentication
======================

.. _zend.auth.adapter.openid.introduction:

简介
--

*Zend_Auth_Adapter_OpenId* 允许认证用户使用远程 OpenID
服务器，这样的认证过程假设用户只提交他们的 OpenID 身份给 web
程序，接着他们被重定向到 OpenID 的提供者通过密码或其它办法来验证身份，本地的 web
程序是永远不会知道密码的。

OpenID 身份只是个指向一些 web 页面的 HTTP URL，在 URL
中带有适当的用户和特别标签的信息，在标签中描述使用哪个服务器和提交哪个身份到那里。关于
OpenID 请参考 `OpenID 官方网站`_.

*Zend_Auth_Adapter_OpenId* 类是 *Zend_OpenId_Consumer* 组件的封装，而 *>Zend_OpenId_Consumer* 组件实现
OpenID 认证协议自己。

.. note::

   *Zend_OpenId* 利用有效的 `GMP extension`_\ 。当使用 *Zend_Auth_Adapter_OpenId* 时，可以考虑打开
   GMP extension 来改善性能。

.. _zend.auth.adapter.openid.specifics:

细节
--

作为 *Zend_Auth* 的适配器， *Zend_Auth_Adapter_OpenId* 类实现了 *Zend_Auth_Adapter_Interface*\ ，而
*Zend_Auth_Adapter_Interface* 定义了一个方法 － *authenticate()*\
。这个方法执行认证，但在调用之前要准备号对象，适配器准备包括设置 OpenID
身份和其它 *Zend_OpenId* 特殊选项。

然而和其它 *Zend_Auth* 的适配器不同，它在外部服务器上执行认证并在两次分开的 HTTP
请求中完成，所以必须调用 *Zend_Auth_Adapter_OpenId::authenticate()*
两次。第一次这个方法不返回，但重定向用户到他们的 OpenID
服务器，然后在服务器上认证后又重定向回来，第二次请求的脚本必须再调用
*Zend_Auth_Adapter_OpenId::authenticate()*
来校验从服务器返回的重定向请求带来的签名，然后完成认证处理，最后，这个方法将返回期望的
*Zend_Auth_Result* 对象。

下面的例子展示 *Zend_Auth_Adapter_OpenId* 的用法。正如前面所说，
*Zend_Auth_Adapter_OpenId::authenticate()* 被调用两次。第一次 － 在提交 HTML 表单之后，当
*$_POST['openid_action']* 设置给 *"login"*\ 时；第二次 － 在从 OpenID 服务器重定向 HTTP
之后，当 *$_GET['openid_mode']* 或 *$_POST['openid_mode']* 被设置。

.. code-block::
   :linenos:

   <?php
   $status = "";
   $auth = Zend_Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode']) ||
       isset($_POST['openid_mode'])) {
       $result = $auth->authenticate(
           new Zend_Auth_Adapter_OpenId(@$_POST['openid_identifier']));
       if ($result->isValid()) {
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
       } else {
           $auth->clearIdentity();
           foreach ($result->getMessages() as $message) {
               $status .= "$message<br>\n";
           }
       }
   } else if ($auth->hasIdentity()) {
       if (isset($_POST['openid_action']) &&
           $_POST['openid_action'] == "logout") {
           $auth->clearIdentity();
       } else {
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>
   */


允许和下面这些方法一起来定制 OpenID 认证过程：从 OpenID
服务器上接收在分开的页面上的重定向；指定网站的 "root"。在这种情况下，使用
*Zend_OpenId_Consumer_Storage* 或 *Zend_Controller_Response*\ 。也可以使用注册扩展（Registration
Extension）来从 OpenID 服务器上获取用户信息。所有这些可能性在 *Zend_OpenId_Consumer*
有详细描述。



.. _`OpenID 官方网站`: http://www.openid.net/
.. _`GMP extension`: http://php.net/gmp
