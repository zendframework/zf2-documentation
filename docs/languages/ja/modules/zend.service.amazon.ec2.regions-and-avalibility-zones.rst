.. _zend.service.amazon.ec2.zones:

Zend_Service_Amazon_Ec2:リージョンおよび利用可能ゾーン
=======================================

アマゾンEC2は、リージョンおよび利用可能ゾーン毎にインスタンスを設置する能力を提供します。
リージョンは、分散した地理的地域または国に分散します。
利用可能ゾーンは、リージョンの中に位置し、
他の利用可能ゾーンでの破損から保護されるために設計され、
同じリージョン内の利用可能ゾーンへのネットワーク連結性を安価で低く潜在的に提供します。
分散した利用可能ゾーンでインスタンスを開始することによって、
アプリケーションを単一の利用可能ゾーンの失敗から保護できます。

.. _zend.service.amazon.ec2.zones.regions:

アマゾンEC2リージョン
------------

必須条件を満たす場所で、アマゾンEC2インスタンスを開始できるように、
アマゾンEC2は、複数のリージョンを提供します。
たとえば、ヨーロッパの顧客とより親しいか、または法的要求を満たすために、
ヨーロッパでインスタンスを開始したいかもしれません。

アマゾンEC2リージョンは、
他のアマゾンEC2リージョンからそれぞれ完全に分離されるように設計されています。
これは最も良くあり得る破損や、独立性、および安定性を提供します。
そして、それはEC2リソース毎の場所感覚を明白にもたらします。

.. _zend.service.amazon.ec2.zones.regions.example:

.. rubric:: 利用可能リージョンを表示

*describe*\ は、アカウントがアクセスすべきリージョンを見つけるために使われます。

*describe*\ は、リージョンが利用できる情報を含む配列を返します。
各配列はregionNameおよびregionUrlを含みます。

.. code-block:: php
   :linenos:

   $ec2_region = new Zend_Service_Amazon_Ec2_Region('aws_key','aws_secret_key');
   $regions = $ec2_region->describe();

   foreach($regions as $region) {
       print $region['regionName'] . ' -- ' . $region['regionUrl'] . '<br />';
   }

.. _zend.service.amazon.ec2.zones.availability:

アマゾンEC2利用可能ゾーン
--------------

インスタンスを開始するとき、利用可能ゾーンを任意に指定できます。
利用可能ゾーンを指定しなければ、アマゾンEC2はあなたが使用しているリージョン内で1つを選択します。
最初のインスタンスを開始するとき、利用可能ゾーンの既定値を受け取ることを勧めます。
それにより、アマゾンEC2で、システムの健康状態と利用可能容量に基づいて、
最も良い利用可能ゾーンを選択できます。 たとえ他のインスタンスを実行中でも、
新規のインスタンスが既存のインスタンスに緊密である、または分離する必要がなければ、
利用可能なゾーンを指定することを考慮しないかもしれません。

.. _zend.service.amazon.ec2.zones.availability.example:

.. rubric:: 利用可能ゾーンを表示

*describe*\ は、各利用可能ゾーンの状態を探すために使われます。

*describe*\ は、ゾーンが利用できる情報を含む配列を返します。
各配列はzoneNameおよびzoneStateを含みます。

.. code-block:: php
   :linenos:

   $ec2_zones = new Zend_Service_Amazon_Ec2_Availabilityzones('aws_key',
                                                              'aws_secret_key');
   $zones = $ec2_zones->describe();

   foreach($zones as $zone) {
       print $zone['zoneName'] . ' -- ' . $zone['zoneState'] . '<br />';
   }


