.. _zend.captcha.introduction:

導入
==

`CAPTCHA`_ とは "Completely Automated Public Turing test to tell Computers and Humans Apart
(コンピュータと人間を区別するための、
完全に自動化された公開チューリングテスト)" のことです。 送られてきた情報が、
自動処理によるものなのか人間が送信したものなのかを判断するために使用します。
典型的な使用例は、フォームの投稿処理です。
ユーザ認証は不要だが、スパム投稿を防ぎたいといった場合に使用します。

Captcha にはさまざまな方式があります。
なぞなぞを使ったりつぶれたフォントで表示したり、
あるいは複数の画像の中から関連するものを選ばせたりといったものです。
``Zend_Captcha`` はさまざまなバックエンドを提供し、 単体でも ``Zend_Form``
と組み合わせても使用できるようにすることを目指しています。



.. _`CAPTCHA`: http://en.wikipedia.org/wiki/Captcha
