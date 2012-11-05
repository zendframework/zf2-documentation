.. EN-Revision: none
.. _zend.session.global_session_management:

全局会话管理
======

会话的默认行为可以由 *Zend_Session*\
的一些静态方法来改变。使用Zend_Session来处理和操作所有的全局会话管理，包括使用
*Zend\Session\Core::setOptions()* 方法对 `PHP内置的会话模块提供的常用配置选项`_\
的配置。例如，不能确保使用安全的 *save_path*\
和PHP会话模块使用的唯一的cookie名，那么使用 *Zend\Session\Session::setOptions()* 会引发安全问题。

.. _zend.session.global_session_management.configuration_options:

配置选项
----

当第一个会话命名空间被请求时，Zend_Session就会自动启动PHP会话，除非已经和
:ref:`Zend\Session\Session::start() <zend.session.advanced_usage.starting_a_session>`\
一起启动了。内部PHP的会话将会按照Zend_Session的默认配置开启，除非先前调用过
*Zend\Session\Session::setOptions()*\ 修改了配置。

设置会话配置选项，包括基本名（在"*session.*"之后的名字部分）作为传递给
*Zend\Session\Session::setOptions()*\
的数组的键。数组里相应的值用来设置会话选项值。如果开发者没有设置选项，Zend_Session将首先使用推荐的缺省选项，接着就是缺省的php.ini设置。关于这些选项的最好实践的社区反馈应该发送到
`fw-auth@lists.zend.com`_\ 。

.. _zend.session.global_session_management.setoptions.example:

.. rubric:: 使用Zend_Config配置Zend_Session

使用 :ref:`Zend\Config\Ini <zend.config.adapters.ini>`\
配置这个组件（Zend_Session），首先添加配置选项到INI文件：

.. code-block:: php
   :linenos:

   ; Accept defaults for production
   [production]
   ; bug_compat_42
   ; bug_compat_warn
   ; cache_expire
   ; cache_limiter
   ; cookie_domain
   ; cookie_lifetime
   ; cookie_path
   ; cookie_secure
   ; entropy_file
   ; entropy_length
   ; gc_divisor
   ; gc_maxlifetime
   ; gc_probability
   ; hash_bits_per_character
   ; hash_function
   ; name should be unique for each PHP application sharing the same domain name
   name = UNIQUE_NAME
   ; referer_check
   ; save_handler
   ; save_path
   ; serialize_handler
   ; use_cookies
   ; use_only_cookies
   ; use_trans_sid

   ; remember_me_seconds = <integer seconds>
   ; strict = on|off


   ; Development inherits configuration from production, but overrides several values
   [development : production]
   ; Don't forget to create this directory and make it rwx (readable and modifiable) by PHP.
   save_path = /home/myaccount/zend_sessions/myapp
   use_only_cookies = on
   ; When persisting session id cookies, request a TTL of 10 days
   remember_me_seconds = 864000

接着，加载配置文件并传递它的数组表达给 *Zend\Session\Session::setOptions()*\ ：

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Config/Ini.php';
   $config = new Zend\Config\Ini('myapp.ini', 'development');

   require_once 'Zend/Session.php';
   Zend\Session\Session::setOptions($config->toArray());

上述大多数选项没有做解释，因为可以在PHP的官方文档中找到他们的解释，但这些特定的事项在下面注释。


   - boolean *strict*- 当使用 *new Zend\Session\Namespace*\ 时，禁止自动启动 *Zend_Session*\ 。

   - integer *remember_me_seconds*-
     该选项指明了当用户代理结束（比如浏览器应用程序终止）后，会话标识符还将保存在cookie中的时长。

   - string *save_path*- 该值跟系统相关，开发者需提供一个PHP程序有读写权限的目录的
     **绝对路径**\ 。如果可写的路径没有被提供，那么当启动时， *Zend_Session*
     将抛出一个异常。（例如，当 *start()*\ 被调用）

     .. note::

        **安全风险**

        如果其他应用程序有读这个目录路径的权限，那么就有发生会话劫持的可能性。如果其他应用程序有写这个目录路径的权限，那么就有发生
        `会话污染`_\
        的可能性。如果这个目录路径是与其他用户或PHP应用程序共享的，那么会引起大量的安全问题，包括会话数据盗窃，会话劫持，垃圾回收冲突（举例来说，另一个用户的PHP应用程序可能会删除你的应用程序的会话文件）。

        例如，攻击者可以访问受害者的站点，获得会话cookie。在访问攻击者的站点执行
        *var_dump($_SESSION)*\
        之前，他（攻击者）编辑cookie路径为在相同服务器上的他自己的域名。知道了有关受害者会话的详细信息，攻击者就可以修改受害者的会话状态（也就是会话中毒），把会话路径改回受害者的站点，然后使得来自受害者站点的请求使用已被污染了的会话。同个服务器上的两个应用程序不能读写对方应用程序的
        *save_path*\ ，但如果 *save_path*\
        是可以猜测的，且攻击者拥有这2个站点其中一个的控制权，攻击者就可以修改他的站点会话的
        *save_path*\ 为另一个站点的会话的 *save_path*\ ，从而就造成了会话污染。因此，
        *save_path*\ 的值不能公开，且对每个应用程序必须是唯一的、安全的。

   - string *name*- 该值跟系统相关，开发者需为基于应用程序提供一个 **唯一**\ 的值。

     .. note::

        **安全风险**

        如果 *php.ini*\ 中 *session.name*\
        的值是相同的（例如，默认为“PHPSESSID”），且在同个域名下面有两个及以上的PHP应用程序，那么当访问者访问这些站点时它们共享了会话数据。此外，很可能引起会话数据的破坏。

   - boolean *use_only_cookies*- 为了不引入更多的安全风险，不要修改该选项的默认值。

        .. note::

           **安全风险**

           如果该选项没有被激活，攻击者使用攻击者站点上的链接，可以轻松的固定受害人的会话标识符，比如：
           *http://www.example.com/index.php?PHPSESSID=fixed_session_id*\
           。假使受害者还没有一个example.com站点会话标识符的cookie，那么会话固定就成功了。一旦受害者使用了攻击者指定的会话标识符，那么攻击者就能劫持受害者的会话，并模仿受害者的用户代理，试图假装成受害者。





.. _zend.session.global_session_management.headers_sent:

错误：Headers Already Sent
-----------------------

如果你看到错误信息，"Cannot modify header information - headers already sent" 或者 "You must call ...
before any output has been sent to the browser; output started in
..."，那么仔细检查最近的和这信息有关联的原因（函数或方法）。任何请求发送HTTP头的动作，象发送一个cookie，必须在发送正常的输出（非缓冲输出）之前完成，除非使用PHP的输出缓冲。

- 经常使用 `output buffering`_\ 就能足够防止这个问题，并帮助提高性能。例如，在
  *php.ini*\ 里，"*output_buffering =
  65535*"允许有64K的缓冲。即使输出缓冲在生产服务器上提高性能是一个良好的策略，仅仅依靠缓冲来解决"headers
  already
  sent"还是不够。应用程序一定不能超过缓冲的大小，否则无论什么时候输出发送（先于HTTP头）超过缓冲的大小，问题就会发生。

- 作为选择，尝试重新安排应用程序逻辑，这样先于发送任何输出，动作处理头被执行。

- 如果一个Zend_Session方法导致这个错误信息，仔细检查这个方法，并确保它的使用在应用程序中是必须的。例如，
  *destroy()*
  缺省的用法也发送HTTP头来使客户端的会话cookie过期。如果这不是必须的，那么使用
  *destroy(false)*\ ，因为设置cookie的指令和HTTP头一起发送。

- 作为选择，尝试重新安排应用程序逻辑，这样先于发送任何输出，动作处理头被执行。

- 删除任何结束"*?>*"标记，如果它们出现在PHP源文件的末尾。它们是必须的，并且新行和其它在结束标记之后的最近的可见的空白字符可以触发输出给客户。

.. _zend.session.global_session_management.session_identifiers:

会话标识符
-----

简介：在基于ZF的应用程序中有关会话使用的问题，提倡使用浏览器的cookie是最佳的实践，而不是把会话的标识符跟在URL后面的方式来追踪用户。Zend_Session组件默认的只有cookie才能保持会话标识符。cookie的值是浏览器会话的唯一标识符。PHP内置的会话模块使用这个标识符以保持站点访问者与每个访问者的持久会话数据之间一对一的关系。Zend_Session组件包装了会话存储器（
*$_SESSION*\
）并提供了一个面向对象的接口。不幸的是，如果攻击者能访问受害者的cookie值（会话标识符），攻击者就能劫持受害者的会话。这个问题不仅在PHP中存在，在Zend
Framework中也存在。 *regenerateId()*\
方法能使应用程序重新生成会话标识符（储存在访问者的cookie中），标识符为一个随机的、不可预计的值。注意：虽然“用户代理(user
agent)”和“Web浏览器(web
browser)”不相同，为了使得本章节更易读，我们使用的这两个术语可以互换。

为什么？：如果攻击者获得了受害者有效的会话标识符，攻击者就可能假扮成一个有效的用户（受害者），得到了访问机密信息或者操作受害者在你的应用程序中的数据。更新会话标识符有利于阻碍会话劫持的发生。如果会话标识符改变了，攻击者就不知道新的会话标识，也就不能用新的会话标识劫持受害者的会话了。即使攻击者能够访问旧的会话标识，
*regenerateId()*\
将会话数据从旧的标识符下移到了新的标识符下，所以通过旧的会话标识符访问不到会话数据。

何时使用 *regenerateId()*\ ：在你的Zend框架程序引导文件中添加 *Zend\Session\Session::regenerateId ()*\
，以最安全的方式重新生成用户Web浏览器cookie中的会话标识符。如果不需要有条件的判定何时重新生成会话标识符，那么这样的方式就没什么缺陷。虽然在每个请求中重新生成会话标识预防了几种攻击的途径，但是不是每个请求需要这么做。因此，应用程序通常设法动态的确定在有较大风险的情况下，重新生成会话标识符。当站点的访问者权限上升时（比如，访问者在编辑你的个人信息前，要重新验证用户）或者敏感的会话参数发生改变时，可以考虑使用
*regenerateId()*\ 创建新的会话标识符。如果你调用了 *rememberMe()*\ 之后，就不需要调用
*regeneraterId()*\ ，因为前者已经调用了后者。如果用户成功登录了站点，调用
*rememberMe()*\ 方法来取代调用 *regenerateId()*\ 方法。

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation:

会话劫持和会话固定
^^^^^^^^^

消除 `跨站脚本攻击（XSS）漏洞`_\ 有利于防止会话劫持的发生。根据 `Secunia`_\
的统计，不管使用何种语言创建web应用程序，XSS问题经常发生。期望应用程序不存在跨站脚本攻击漏洞，还不如按照下面的最佳实践最小化损失，当攻击发生时。在跨站脚本攻击中，攻击者不需要直接访问受害者的网络。如果受害者已经存在一个会话
cookie，那么跨站脚本攻击的Javascript脚本会允许攻击者读取受害者的cookie并偷取会话。如果受害者还不存在会话cookie，利用跨站脚本攻击漏洞注入Javascript脚本，攻击者在受害者浏览器上创建一个已知会话标识符的cookie，然后在攻击者的系统中也创建同样的
cookie，这样就劫持受害者的会话。如果受害者访问了攻击者的站点，那么攻击者还能仿真受害者用户代理的一些其他特征。如果你的站点存在着XSS漏洞，攻击者就可能插入一段AJAX脚本，秘密的访问攻击者的站点，导致攻击者知道了受害者的浏览器特征，又知悉受害者站点的会话。然而，倘若站点开发者正确地设置了
*save_path*\ 选项，那么攻击者也不能任意地修改服务器端的PHP会话状态。

当第一次使用用户会话时，调用 *Zend\Session\Session::regenerateId()*\
不能防止会话固定攻击，除非你能辨别最初的会话是否是攻击者伪装成受害者。初听，这个跟前面所描述的是自相矛盾的，直到我们认为攻击者首先在你的站点上发起了一个真实的会话。如果会话第一次是被攻击者开启的，那么攻击者也就知道了初始化(*regenerateId()*)后的结果（新的会话标识）。攻击者在XSS漏洞中使用这个新的会话标识，或者通过攻击者站点上的链接注入这个新的会话标识（只在
*use_only_cookies = off*\ 时有效）。

如果你能辨别使用相同会话标识符的受害者和攻击者，那么就可以直接处理会话劫持了。然而，这样的区分常常陷于可用性权衡的形式中，因为区别的方法常常是不严密的。举例来说，如果当前请求的IP与创建会话的请求的IP来自不同的国家，那么当前请求大概就是攻击者发起的。在以下的情形下，对于web应用程序就可能很难区别受害者和攻击者了：


   - \- 攻击者首先在你的站点上发起一个会话，以获得一个合法的会话标识符

   - \-
     攻击者利用你的站点上的XSS漏洞，在受害者的浏览器上创建具有相同标识符且有效的会话cookie（也就是会话固定）

   - \-
     受害者和攻击者来自同一个上网代理（比如他们都处于一个大公司的同一个防火墙后面，像AOL）

下面的代码使得攻击者很难获得受害者当前的会话标识符，除非攻击者已经完成上面的第一二两步。

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation.example:

.. rubric:: 会话固定

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Session/Namespace.php';
   $defaultNamespace = new Zend\Session\Namespace();

   if (!isset($defaultNamespace->initialized)) {
       Zend\Session\Session::regenerateId();
       $defaultNamespace->initialized = true;
   }

.. _zend.session.global_session_management.rememberme:

rememberMe(integer $seconds)
----------------------------

通常，用户代理结束时，会话也就结束了，比如当用户退出浏览器。然而，你的应用程序可能通过持久cookies的使用提供扩展用户会话超过客户端程序的生命期的能力。在会话被启动来控制在持久会话cookie过期之前时间的长度之前使用
*Zend\Session\Session::rememberMe()*\ 。如果你没有指定秒数，那么会话cookie的生命期缺省为
*remember_me_seconds*\ ，它可以用 *Zend\Session\Session::setOptions()*\
来设置。为了帮助阻止会话固定/劫持，当用户成功地通过你的程序的认证，使用这个函数（例如，从一个“登录”表单）。

.. _zend.session.global_session_management.forgetme:

forgetMe()
----------

此函数补充了 *rememberMe()*\ ，当用户代理终止时，写入一个有结束生命期的会话cookie。

.. _zend.session.global_session_management.sessionexists:

sessionExists()
---------------

这个方法用来确定当前用户请求是否已经存在会话。这个方法可在会话开启之前使用，且这个方法独立于与
*Zend_Session*\ 和 *Zend\Session\Namespace*\ 的其他方法。

.. _zend.session.global_session_management.destroy:

destroy(bool $remove_cookie = true, bool $readonly = true)
----------------------------------------------------------

*Zend\Session\Session::destroy()*\
，删除当前会话的所有数据。然而，PHP中的变量还未知情，所以你的会话命名空间（
*Zend_Session*\ 的实例）还是可读的。为了完成“登出”动作，设置可选的参数为 *true*\
（缺省为true）来删除用户代理端的会话cookie。可选的 *$readonly*\ 参数删除了创建新的
*Zend\Session\Namespace*\ 实例和为 *Zend_Session*\ 方法写入会话数据存储的能力。

如果你看到错误信息"Cannot modify header information - headers already sent" ， 那么要么避免使用
*true* 作为第一个参数（会话cookie的请求删除），要么参考 :ref:`
<zend.session.global_session_management.headers_sent>` 。这样， *Zend\Session\Session::destroy(true)*
一定要么在PHP发送HTTP头之前被调用，要么输出缓冲被允许。并且，为防止触发在调用
*destroy()*\ 之前发送输出，输出发送的总数不能超过缓冲的大小。

.. note::

   **Throws**

   缺省地， *$readonly*\ 是被激活的，之后写会话数据的动作，将会抛出一个异常。

.. _zend.session.global_session_management.stop:

stop()
------

这个方法只是更改了 *Zend_Session*\
中的一个标志位，以阻止之后向会话数据存储器中写数据。我们特别希望您能反馈关于这个特性的看法。当程序的执行转移到视图相关的代码上时，以免滥用，临时关闭
*Zend\Session\Namespace*\ 实例和 *Zend_Session*\
中的方法向会话数据存储器写数据的能力，试图通过这些实例或方法向会话数据存储器写数据的动作，都将会抛出一个异常。

.. _zend.session.global_session_management.writeclose:

writeClose($readonly = true)
----------------------------

关闭会话，把 *$_SESSION*\
数组中的数据写到后台的存储器中（文件、数据库），完成内部数据的转换。可选的
*$readonly*\ 布尔参数可以通过抛出基于企图通过 *Zend_Session*\ 或者 *Zend\Session\Namespace*\
写入会话的一个异常来删除写的能力。

.. note::

   **Throws**

   缺省地， *$readonly*\
   是被激活的，之后向会话数据存储器写数据的动作讲抛出异常。然而，一些遗留的应用程序期望
   *$_SESSION*\ 在会话通过 *session_write_close()*\
   关闭后仍然可以写。虽然不是最佳的实践，但 *$readonly*\
   选项对有需要的人还是有用的。

.. _zend.session.global_session_management.expiresessioncookie:

expireSessionCookie()
---------------------

该方法向客户端发送一个过期的会话cookie，以引起客户端删除会话cookie。通常这个技术被用来执行客户端登出请求。

.. _zend.session.global_session_management.savehandler:

setSaveHandler(Zend\Session_SaveHandler\Interface $interface)
-------------------------------------------------------------

对于大多数开发者来说缺省的save
handler已经足够了。这个方法只是以面向对象的方式包装了一下 `session_set_save_handler()`_\
函数。

.. _zend.session.global_session_management.namespaceisset:

namespaceIsset($namespace)
--------------------------

这个方法用来检查某会话命名空间是否存在，或者某会话命名空间下的某个索引是否存在。

.. note::

   **Throws**

   如果 *Zend_Session*\ 没有被标记为可读（比如在 *Zend_Session*\
   开启之前），将会抛出一个异常。

.. _zend.session.global_session_management.namespaceunset:

namespaceUnset($namespace)
--------------------------

使用 *namespaceUnset($namespace)*\
注销某个命名空间及其内容，而不用为某个命名空间创建Zend_Session实例，然后迭代它删除每个条目。如果被注销的变量为数组，且该数组包含了其他对象，而这些对象又被其他变量引用，这些对象仍然是可访问的。不要期望
*namespaceUnset*\
方法会“深”注销/删除命名空间下条目的内容。更详细的解释，请参考PHP手册中的
`References Explained`_

.. note::

   **Throws**

   如果命名空间不可读（比如执行了 *destroy()*\ 之后），将会抛出一个异常。

.. _zend.session.global_session_management.namespaceget:

namespaceGet($namespace)
------------------------

不赞成的：在 *Zend\Session\Namespace*\ 中用 *getIterator()*\ 。 这个方法返回 *$namespace*\
命名空间的内容数组 *$name*\
。如果你有合理的理由认为该方法是公有的，请反馈到我们的邮件列表：
`fw-auth@lists.zend.com`_\ 。实际上，所有参与相关话题讨论的，我们都是欢迎的。

.. note::

   **Throws**

   如果 *Zend_Session*\ 没有被标记为可读（比如在 *Zend_Session*\
   开启之前），将会抛出一个异常。

.. _zend.session.global_session_management.getiterator:

getIterator()
-------------

使用 *getIterator()*\ 方法，可获得一个包含所有命名空间名字的数组。

.. note::

   **Throws**

   如果 *Zend_Session*\ 没有被标记为可读（比如在 *Zend_Session*\
   开启之前），将会抛出一个异常。



.. _`PHP内置的会话模块提供的常用配置选项`: http://www.php.net/session#session.configuration
.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`会话污染`: http://en.wikipedia.org/wiki/Session_poisoning
.. _`output buffering`: http://php.net/outcontrol
.. _`跨站脚本攻击（XSS）漏洞`: http://en.wikipedia.org/wiki/Cross_site_scripting
.. _`Secunia`: http://secunia.com/
.. _`session_set_save_handler()`: http://php.net/session_set_save_handler
.. _`References Explained`: http://php.net/references
