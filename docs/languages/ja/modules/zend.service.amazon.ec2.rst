.. EN-Revision: none
.. _zend.service.amazon.ec2:

Zend_Service_Amazon_Ec2
=======================

.. _zend.service.amazon.ec2.introduction:

導入
--

``Zend_Service_Amazon_Ec2``\
は融通性のあるクランドコンピューティング(EC2)へのインターフェイスを提供します。

.. _zend.service.amazon.ec2.whatis:

Amazon Ec2とは？
-------------

Amazon EC2は、 *API*\ や役に立つツールやユーティリティーを使って、
Amazonのデータセンターにあるサーバインスタンスを起動したり管理したりできるWebサービスです。
あなたはいつでも必要なだけ、合法な限り、Amazon
EC2サーバインスタンスを使うことができます。

.. _zend.service.amazon.ec2.staticmethods:

静的メソッド
------

Ec2 クラスの使い勝手をよくするために、ふたつの静的メソッドが用意されています。
これは、Ec2 の任意の要素から実行することができます。 最初の静的メソッドは
*setKeys* で、 使用する *AWS* アクセスキーをデフォルトのキーとして定義します。
新しいオブジェクトを作成する際に、
コンストラクタにキーを渡す必要がなくなります。

.. _zend.service.amazon.ec2.staticmethods.setkeys:

.. rubric:: setKeys() の例

.. code-block:: php
   :linenos:

   Zend_Service_Amazon_Ec2_Ebs::setKeys('aws_key','aws_secret_key');

作業するリージョンを設定するには、 *setRegion* をコールして Amazon Ec2
リージョンを設定します。 現在使用できるリージョンは us-east-1 と eu-west-1
のふたつだけです。 無効な値を渡した場合は例外をスローします。

.. _zend.service.amazon.ec2.staticmethods.setregion:

.. rubric:: setRegion() の例

.. code-block:: php
   :linenos:

   Zend_Service_Amazon_Ec2_Ebs::setRegion('us-east-1');

.. note::

   **Amazon Ec2 リージョンの設定**

   別の方法として、各クラスを作成する際のコンストラクタの 3
   番目の引数としてリージョンを設定することもできます。


