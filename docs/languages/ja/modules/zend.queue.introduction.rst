.. _zend.queue.introduction:

導入
==

``Zend_Queue``\ は、 固有の待ち行列クライアント・オブジェクトを作成するために、
ファクトリ関数を提供します。

メッセージ待ち行列は、分散処理のための方法です。
たとえば、ジョブ・ブローカー・アプリケーションは、
いろいろなソースからジョブのために複数のアプリケーションを扱うかもしれません。

送り手と受け手を持つ待ち行列 "``/queue/applications``" をつくれるでしょう。
送り手は、メッセージサービスに、
または、メッセージサービスに接続できた(Web)アプリケーションに間接的に接続できる
いかなる利用可能なソースかもしれません。

送り手は、待ち行列にメッセージを送ります:

.. code-block:: xml
   :linenos:

   <resume>
       <name>John Smith</name>
       <location>
           <city>San Francisco</city>
           <state>California</state>
           <zip>00001</zip>
       </location>
       <skills>
           <programming>PHP</programming>
           <programming>Perl</programming>
       </skills>
   </resume>

待ち行列の受け手または消費者は、メッセージに気付いて、レジュメを処理します。

コードから制御フローを抽出したり、
メトリクや変換操作、そしてメッセージ待ち行列のモニタリングを提供したりする
待ち行列に適用できる多くのメッセージ発信パターンがあります。
メッセージ発信パターンに関する良い本は `Enterprise Integration Patterns: Designing, Building,
and Deploying Messaging Solutions (Addison-Wesley Signature Series)`_ (ISBN-10 0321127420; ISBN-13
978-0321127426)です。



.. _`Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions (Addison-Wesley Signature Series)`: http://www.amazon.co.jp/Enterprise-Integration-Patterns-Designing-Addison-Wesley/dp/0321200683
