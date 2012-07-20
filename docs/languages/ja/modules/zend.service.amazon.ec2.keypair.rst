.. _zend.service.amazon.ec2.keypairs:

Zend_Service_Amazon_Ec2: Keypairs
=================================

Keypairsはインスタンスにアクセスするために使われます。

.. _zend.service.amazon.ec2.keypairs.create:

.. rubric:: Amazon Keypairの新規作成

*create*\ は、
新しいインスタンスを開始するときに、2048ビットのRSAキー・ペアを新規作成して、
このキー・ペアを参照文に引用するために使用できる一意のIDを返します。

*create*\ はkeyName、keyFingerprint及びkeyMaterialを含む配列を返します。

.. code-block:: php
   :linenos:

   $ec2_kp = new Zend_Service_Amazon_Ec2_Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->create('my-new-key');

.. _zend.service.amazon.ec2.keypairs.delete:

.. rubric:: Amazon Keypairの削除

*delete*\ はキー・ペアを削除します。
これは、それが新しいインスタンスで使われるのを防ぐだけです。
keypairで現在実行中のインスタンスは、今まで通りそれらに接続可能です。

*delete*\ はブール値の ``TRUE`` または ``FALSE`` を返します。

.. code-block:: php
   :linenos:

   $ec2_kp = new Zend_Service_Amazon_Ec2_Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->delete('my-new-key');

.. _zend.service.amazon.ec2.describe:

.. rubric:: Amazon Keypairの記述

*describe*\ は、利用できるキー・ペアに関する情報を返します。
キー・ペアを指定すると、それらのキー・ペアに関する情報が返されます。
これ以外の場合には、登録したすべてのキー・ペアの情報が返されます。

*describe*\ はkeyName及びkeyFingerprintを含む配列を返します。

.. code-block:: php
   :linenos:

   $ec2_kp = new Zend_Service_Amazon_Ec2_Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->describe('my-new-key');


