.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

对Flickr搜索的介绍
------------------------

*Zend_Service_Flickr* i是一组用来使用Flickr REST Web Service 的简单API. 为了可以使用Flickr web
services, 你必须拥有 API key. 获取key或需要Flickr REST Web Service更多详细信息, 请访问 `Flickr
API Documentation`_.

在下面的例子中, 我们使用 *tagSearch()* 方法来搜索tag中有 "php"的照片 .

.. rubric:: 简单的 Flickr 照片搜索

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }
   ?>
.. note::

   *tagSearch()* 可以接受第二个(可选的)参数提供更多选项.

.. _zend.service.flickr.finding-users:

查找 Flickr 用户
--------------------

*Zend_Service_Flickr* 提供三种不同的方法来得到 Flickr的用户信息:

- *userSearch()*:
  接受一个以空格来作为分隔符的(由tag构成)查询字符串，用数组的方式(可选)来指定搜索选项,
  返回一个 *Zend_Service_Flickr_ResultSet* 对象.

- *getIdByUsername()*: 以字符串的格式返回与给定用户名关联的用户 ID

- *getIdByEmail()*: 以字符串的格式返回与给定email地址关联的用户 ID

.. rubric:: 用email地址来查找Flickr用户

在这个例子中, 我们有一个Flickr用户的e-mail 地址, 并用 *userSearch()* 方法获得用户的信息:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }
   ?>
.. _zend.service.flickr.getimagedetails:

获得 Flickr 图像详细资料
--------------------------------

*Zend_Service_Flickr*\
使我们可以使用给定的图像id来非常方便快捷的得到图像的详细信息,使用
*getImageDetails()* 方法, 如下面的例子:

.. rubric:: 获得 Flickr 图像详细资料

一旦你有一个Flickr 图像的ID,获得它的详细信息将是小事一桩:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Service/Flickr.php';

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "Image ID $imageId is $image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Click for Image</a>\n";
   ?>
.. _zend.service.flickr.classes:

Zend_Service_Flickr 类
-----------------------

下面列出的是将由 *tagSearch()* 和 *userSearch()*\ 返回的一些类:

   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

代表一个Flickr search的结果集.

.. note::

   该对象实现了 *SeekableIterator* 接口,我们可以很方便的进行遍历 (如 foreach ), 也可以用
   *seek()*\ 直接访问指定的结果 . .

.. _zend.service.flickr.classes.resultset.properties:

属性
^^^^^^

.. table:: Zend_Service_Flickr_ResultSet 属性

   +---------------------+------+---------------------------------------------+
   |名称                   |类别    |描述                                           |
   +=====================+======+=============================================+
   |totalResultsAvailable|int   |所有有效结果的数量                                    |
   +---------------------+------+---------------------------------------------+
   |totalResultsReturned |int   |所有结果的数量                                      |
   +---------------------+------+---------------------------------------------+
   |firstResultPosition  |int   |当前结果集在所有结果集中的偏移                              |
   +---------------------+------+---------------------------------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


返回这个结果集中所有结果的数量

:ref:`Back to Class List <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Flickr query中的一个单一图片结果

.. _zend.service.flickr.classes.result.properties:

属性
^^^^^^

.. table:: Zend_Service_Flickr_Result 属性

   +-----------+-------------------------+---------------------------------------------------------+
   |名称         |类别                       |描述                                                       |
   +===========+=========================+=========================================================+
   |id         |int                      |图片 ID                                                    |
   +-----------+-------------------------+---------------------------------------------------------+
   |owner      |int                      |相片所有者的 NSID.                                             |
   +-----------+-------------------------+---------------------------------------------------------+
   |secret     |string                   |一个用于构建url的key                                            |
   +-----------+-------------------------+---------------------------------------------------------+
   |server     |string                   |用于构建url的服务器名称                                            |
   +-----------+-------------------------+---------------------------------------------------------+
   |title      |string                   |相片的title                                                 |
   +-----------+-------------------------+---------------------------------------------------------+
   |ispublic   |boolean                  |相片是否是公开的                                                 |
   +-----------+-------------------------+---------------------------------------------------------+
   |isfriend   |boolean                  |因为你是相片所有者的朋友，相片对你可见                                      |
   +-----------+-------------------------+---------------------------------------------------------+
   |isfamily   |boolean                  |因为你是相片所有者的亲属，相片对你可见                                      |
   +-----------+-------------------------+---------------------------------------------------------+
   |license    |string                   |相片基于什么license                                            |
   +-----------+-------------------------+---------------------------------------------------------+
   |date_upload|string                   |上传相片的时间                                                  |
   +-----------+-------------------------+---------------------------------------------------------+
   |date_taken |string                   |拍照的时间                                                    |
   +-----------+-------------------------+---------------------------------------------------------+
   |owner_name |string                   |相片所有者的名字                                                 |
   +-----------+-------------------------+---------------------------------------------------------+
   |icon_server|string                   |用来装配图标 URLs的服务器                                          |
   +-----------+-------------------------+---------------------------------------------------------+
   |Square     |Zend_Service_Flickr_Image|一个 75x75像素大小的预览图                                         |
   +-----------+-------------------------+---------------------------------------------------------+
   |Thumbnail  |Zend_Service_Flickr_Image|一个100像素大小的预览图                                            |
   +-----------+-------------------------+---------------------------------------------------------+
   |Small      |Zend_Service_Flickr_Image|一个240像素大小的图片                                             |
   +-----------+-------------------------+---------------------------------------------------------+
   |Medium     |Zend_Service_Flickr_Image|一个500像素大小的图片                                             |
   +-----------+-------------------------+---------------------------------------------------------+
   |Large      |Zend_Service_Flickr_Image|一个640像素大小的图片                                             |
   +-----------+-------------------------+---------------------------------------------------------+
   |Original   |Zend_Service_Flickr_Image|原始图片                                                     |
   +-----------+-------------------------+---------------------------------------------------------+

:ref:`Back to Class List <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

代表由Flickr搜索返回的图片

.. _zend.service.flickr.classes.image.properties:

属性
^^^^^^

.. table:: Zend_Service_Flickr_Image 属性

   +--------+------+-----------------------------------------------------+
   |名称      |类别    |描述                                                   |
   +========+======+=====================================================+
   |uri     |string|原始图片的URI                                             |
   +--------+------+-----------------------------------------------------+
   |clickUri|string|图片相关的可点击的URI (如 Flickr 的页面)                          |
   +--------+------+-----------------------------------------------------+
   |width   |int   |图片的宽度                                                |
   +--------+------+-----------------------------------------------------+
   |height  |int   |图片的高度                                                |
   +--------+------+-----------------------------------------------------+

:ref:`Back to Class List <zend.service.flickr.classes>`



.. _`Flickr API Documentation`: http://www.flickr.com/services/api/
