.. EN-Revision: none
.. _zend.captcha.adapters:

CAPTCHA アダプタ
============

次のアダプタが、Zend Framework に同梱されています。

.. _zend.captcha.adapters.word:

Zend\Captcha\Word
-----------------

``Zend\Captcha\Word`` は抽象アダプタで、 その他の大半の *CAPTCHA*
アダプタの基底クラスとなります。
指定できる機能は、単語の長さやセッションの有効期限、
使用するセッション名前空間オブジェクト、 ``Zend\Session\Namespace``
を使いたくない場合に使用するセッション名前空間クラスです。 ``Zend\Captcha\Word``
は、すべての検証ロジックをカプセル化します。

デフォルトでは、単語の長さは 8 文字です。またセッションのタイムアウトは 5
分、情報の永続化には ``Zend\Session\Namespace`` を使用します (使用する名前空間は
"``Zend\Form_Captcha\<captcha ID>``" です)。

``Zend\Captcha\Adapter`` インターフェイスのメソッドのほかに、 ``Zend\Captcha\Word``
は次のメソッドを公開しています。

- ``setWordLen($length)`` と ``getWordLen()`` で、生成される "単語"
  の文字数を設定したり現在の値を取得したりします。

- ``setTimeout($ttl)`` と ``getTimeout()``
  で、セッショントークンの有効期限を設定したり現在の値を取得したりします。
  ``$ttl`` は秒数で指定します。

- ``setUseNumbers($numbers)`` and ``getUseNumbers()`` allow you to specify if numbers will be considered as
  possible characters for the random work or only letters would be used.

- ``setSessionClass($class)`` と ``getSessionClass()`` で、 *CAPTCHA* トークンの永続化に使用する
  ``Zend\Session\Namespace`` の実装を設定したり 現在の値を取得したりします。

- ``getId()`` で、現在のトークン識別子を取得します。

- ``getWord()`` で、 *CAPTCHA* に使用するために生成した単語を取得します。
  まだ生成されていない場合は、まず生成してからそれを返します。

- ``setSession(Zend\Session\Namespace $session)`` で、 *CAPTCHA*
  トークンの永続化に使用するセッションオブジェクトを設定します。 ``getSession()``
  で、現在のセッションオブジェクトを取得します。

すべての Word *CAPTCHA* は、コンストラクタにオプションの配列を渡すことができます。
別の方法として、その配列を ``setOptions()`` で渡す (あるいは ``Zend_Config``
オブジェクトを ``setConfig()`` で渡す) こともできます。 デフォルトで、 **wordLen**\ 、
**timeout** および **sessionClass** のキーをすべて使用します。
各具象実装では、それ以外のキーを使用したり
違う方法でオプションを使用したりしているかもしれません。

.. note::

   ``Zend\Captcha\Word`` は抽象クラスであり、
   直接そのインスタンスを作成することはできません。

.. _zend.captcha.adapters.dumb:

Zend\Captcha\Dumb
-----------------

``Zend\Captch\Dumb`` アダプタは、その名が示すとおりのものです。
ランダムな文字列を用意し、それを逆からタイプさせることで検証を行います。
これは *CAPTCHA* の手法としてはあまりよいものではないので、
テスト用に使うのみにしておきましょう。
あるいは、ほかに手がない場合の最後の手段としてのみ使うようにしましょう。
このアダプタは ``Zend\Captcha\Word`` を継承しています。

.. _zend.captcha.adapters.figlet:

Zend\Captcha\Figlet
-------------------

``Zend\Captcha\Figlet`` アダプタは、 :ref:`Zend\Text\Figlet <zend.text.figlet>` を使用して Figlet
をユーザに表示します。

コンストラクタに渡されたオプションは、アダプタが使用する :ref:`Zend\Text\Figlet
<zend.text.figlet>` オブジェクトにも渡されます。
使用できる設定オプションについては、 :ref:`Zend\Text\Figlet <zend.text.figlet>`
のドキュメントを参照ください。

.. _zend.captcha.adapters.image:

Zend\Captcha\Image
------------------

``Zend\Captcha\Image`` アダプタは、
生成された単語を受け取ってそれを画像としてレンダリングし、
それをいろいろな方法で歪めて自動判読を困難にします。 これを使用するには、 `GD
拡張モジュール`_ を TrueType あるいは Freetype
のサポートつきでコンパイルする必要があります。 現在、 ``Zend\Captcha\Image``
アダプタが生成できるのは *PNG* 画像のみです。

``Zend\Captcha\Image`` は ``Zend\Captcha\Word`` を継承しており、
さらに次のメソッドを公開しています。

- ``setExpiration($expiration)`` と ``getExpiration()`` で、 *CAPTCHA*
  画像をファイルシステム上に残す期間を設定します。
  通常、これはセッションの有効期間より長くします。 *CAPTCHA*
  オブジェクトが起動されるたびにガベージコレクションが働き、
  期限切れとなった画像が削除されます。 値は秒数で指定します。

- ``setGcFreq($gcFreq)`` と ``getGcFreg()``
  で、ガベージコレクションが働く頻度を設定します。ガベージコレクションは、
  ``1/$gcFreq`` 回のコールごとに実行されます。 デフォルトは 100 です。

- ``setFont($font)`` と ``getFont()`` で、使用するフォントを指定します。 ``$font`` には、
  使用するフォントのパスをフルパス形式で指定する必要があります。
  この値を設定しなければ、 *CAPTCHA* の生成時に例外がスローされます。
  フォントは必須です。

- ``setFontSize($fsize)`` と ``getFontSize()`` で、 *CAPTCHA*
  を生成する際に使用するフォントのサイズをピクセル単位で設定します。
  デフォルトは 24px です。

- ``setHeight($height)`` と ``getHeight()`` で、生成される *CAPTCHA*
  画像の高さをピクセル単位で指定します。 デフォルトは 50px です。

- ``setWidth($width)`` と ``getWidth()`` で、生成される *CAPTCHA*
  画像の幅をピクセル単位で指定します。 デフォルトは 200px です。

- ``setImgDir($imgDir)`` と ``getImgDir()`` で、 *CAPTCHA*
  画像を保存するディレクトリを指定します。 デフォルトは "``./images/captcha/``"
  で、これは起動スクリプトからの相対パスとなります。

- ``setImgUrl($imgUrl)`` と ``getImgUrl()`` で、 *HTML* マークアップ時に使用する *CAPTCHA*
  画像への相対パスを指定します。 デフォルトは "``/images/captcha/``" です。

- ``setSuffix($suffix)`` と ``getSuffix()`` で、 *CAPTCHA*
  画像ファイル名の拡張子を指定します。デフォルトは "``.png``" です。注意:
  これを変更したからといって、
  生成される画像の形式が変わるわけではありません。

- ``setDotNoiseLevel($level)`` and ``getDotNoiseLevel()``, along with ``setLineNoiseLevel($level)`` and
  ``getLineNoiseLevel()``, allow you to control how much "noise" in the form of random dots and lines the image
  would contain. Each unit of ``$level`` produces one random dot or line. The default is 100 dots and 5 lines. The
  noise is added twice - before and after the image distortion transformation.

上のすべてのオプションは、コンストラクタのオプションとして指定できます。
その際には、メソッド名の先頭の 'set' を取り除いて先頭を小文字にした名前 ("suffix",
"height", "imgUrl" など) を使用します。

.. _zend.captcha.adapters.recaptcha:

Zend\Captcha\ReCaptcha
----------------------

``Zend\Captcha\ReCaptcha`` アダプタは、 :ref:`Zend\Service\ReCaptcha <zend.service.recaptcha>`
を使用して *CAPTCHA* の生成と検証を行います。 次のメソッドを公開しています。

- ``setPrivKey($key)`` と ``getPrivKey()`` で、ReCaptcha
  サービスで使用する秘密鍵を指定します。
  これはオブジェクトの作成時に指定する必要がありますが、
  その後いつでも上書きできます。

- ``setPubKey($key)`` と ``getPubKey()`` で、ReCaptcha サービスで使用する公開鍵を指定します。
  これはオブジェクトの作成時に指定する必要がありますが、
  その後いつでも上書きできます。

- ``setService(Zend\Service\ReCaptcha $service)`` と ``getService()`` で、 ReCaptcha
  サービスオブジェクトを取得したり取得したりします。



.. _`GD 拡張モジュール`: http://php.net/gd
