.. EN-Revision: none
.. _zend.captcha.adapters:

Captcha 适配器
===========

Zend Framework 缺省地带有下列适配器。

.. _zend.captcha.adapters.word:

Zend_Captcha_Word
-----------------

Zend_Captcha_Word 是个摘要适配器，它是 Dumb、Figlet 和 Image 适配器的基础。
，它提供了增变器用来指定字符长度、会话 TTL 、会话命名空间对象，如果你不想 使用
Zend_Session_Namespace，它提供了会话命名空间来用于持久。
另外，它封装了所有校验逻辑。

缺省地，字符长度为 8，会话超时为 5 分钟，Zend_Session_Namespace
用于持久（使用命名空间"Zend_Form_Captcha_<captcha ID>"）。

除了 *Zend_Captcha_Adapter* 接口要求的标准方法外， *Zend_Captcha_Word* 还有下列方法：

- *setWordLen($length)* 和 *getWordLen()* 指定生成的“字符”的长度和获取当前值。

- *setTimeout($ttl)* 和 *getTimeout()* 指定会话令牌的 time-to-live 和获取当前值。 *$ttl*
  以秒计。

- *setSessionClass($class)* 和 *getSessionClass()* 指定替代的 *Zend_Session_Namespace* 实现来持久
  captcha 令牌和获取当前值。

- *getId()* 获取当前令牌标识符。

- *getWord()* 获取用于 captcha 的生成字符，如果以前没有生成，它将生成一个。

- *setSession(Zend_Session_Namespace $session)* 指定一个会话对象用来持久 captcha 令牌；
  *getSession()* 获取当前会话对象。

所有字符 captchas 传递一个选项数组给构造器，或者把它们传递给 *setOptions()*
（或传递一个 *Zend_Config* 对象给 *setConfig()*\ ）。 缺省地，可能使用所有的键 *wordLen*\
、 *timeout* 和 *sessionClass* ；每个具体的实现可能定义另外的键或选项。

.. note::

   记住，Word 是个摘要类并且可能不能直接初始化。

.. _zend.captcha.adapters.dumb:

Zend_Captcha_Dumb
-----------------

Dumb 适配器通常是自解释的。它提供了随机字符串需要用反序输入来校验。
这样，它不是一个好的 CAPTCHA 方案，只用于测试或者最后的方案。 它继承
*Zend_Captcha_Word*\ 。

.. _zend.captcha.adapters.figlet:

Zend_Captcha_Figlet
-------------------

Figlet 适配器利用 :ref:`Zend_Text_Figlet <zend.text.figlet>` 来展示一个 Figlet 给用户。Figlet
captchas 只限于字符。

传递给构造器的选项也可以传递给适配器使用的 :ref:`Zend_Text_Figlet <zend.text.figlet>`
对象。 请参考关于配置选项的细节的文档。

.. _zend.captcha.adapters.image:

Zend_Captcha_Image
------------------

Image 适配器使用生成的字符并解析为图像，并把它变换成难以自动解密。 它需要 `GD
extension`_\ ，使用 TrueType 或 Freetype 支持的编译。目前，Image 适配器只能产生 PNG 图像。

*Zend_Captcha_Image* 集成 *Zend_Captcha_Word*\ ，并附加了下列方法：

- *setExpiration($expiration)* 和 *getExpiration()* 指定 captcha 图像可以保留在文件系统
  中的最大生命周期。一般长于会话的生命周期。每次调用 captcha 对象，
  垃圾收集就运行一次，过期的图像就被清除。过期值以秒计。

- *setGcFreq($gcFreq)* 和 *getGcFreg()* 指定垃圾收集运行的频度。每 *1/$gcFreq*
  垃圾收集就运行一次（缺省值为 100）。

- *setFont($font)* 和 *getFont()*
  指定要用的字体。它是到字体文件的全路径。如果没有设置这个值，captcha
  就在生成的时候抛出异常。字体是必需的。

- *setFontSize($fsize)* 和 *getFontSize()* 指定字体尺寸，以象素为单位，用于生成
  captcha。缺省值为 24px。

- *setHeight($height)* 和 *getHeight()* 指定生成 captcha 图像的高度，以象素为单位。缺省值为
  50px。

- *setWidth($width)* 和 *getWidth()* 指定生成 captcha 图像的宽度，以象素为单位。缺省值为
  200px 。

- *setImgDir($imgDir)* 和 *getImgDir()* 指定 captcha 图像存储的目录。缺省为 "./images/captcha/"
  ，相对于引导（bootstrap）脚本。

- *setImgUrl($imgUrl)* 和 *getImgUrl()* 指定用于 HTML 标记语言的 captcha 图像的相对路径。
  缺省为 "/images/captcha/"。

- *setSuffix($suffix)* 和 *getSuffix()* 指定文件名后缀。缺省为 ".png"
  。注：它的改变不影响产生的图像类型。

所有上述选项都可作为选项传递给构造器，只要去掉 'set' 方法前缀并
把首字母变成小写：如 "suffix"、 "height"、"imgUrl" 等。

.. _zend.captcha.adapters.recaptcha:

Zend_Captcha_ReCaptcha
----------------------

ReCaptcha 适配器利用 :ref:`Zend_Service_ReCaptcha <zend.service.recaptcha>` 来生成校验
captchas。它有下列方法：

- *setPrivKey($key)* 和 *getPrivKey()* 让你指定和 ReCaptcha
  服务一起使用的私钥。这必需在构造期间指定，尽管任何时候它都可以被覆盖。

- *setPubKey($key)* 和 *getPubKey()* 让你指定和 ReCaptcha
  服务一起使用的公钥。这必需在构造期间指定，尽管任何时候它都可以被覆盖。

- *setService(Zend_Service_ReCaptcha $service)* 和 *getService()* 让你指定并和 ReCaptcha
  服务对象交互使用。



.. _`GD extension`: http://php.net/gd
