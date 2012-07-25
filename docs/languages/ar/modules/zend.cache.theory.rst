.. _zend.cache.theory:

مفهوم الـ caching
=================

هناك ثلاث مفاهيم رئيسية فى Zend_Cache. الأول هو المعرف المميز و هو
عيارة عن string و الذى يستخدم لتعريف البيانات المسجلة فى الـ cache.
الثانى هو التعليمة *'lifeTime'* كما رأيتها فى المثال السابق, هى تعرف
الفترة الزمنية التى يتم اعتبار البيانات المحفوظة فى الـ cache و
بهذا المعرف قابلة للإستخدام "طازجة" . المفهوم الثالث هو التنفيذ
الشرطى للأكواد, حيث يتم اهمال جزء من الكود و لا يتم تنفيذه و هذا
يزيد من كفائة الأداء (performance) . الدالة الأساسية (*()Zend_Cache_Core::get*) تم
تصميمها لتعيد false عندما لا تجد البيانات المطلوبة فى الـ cache
قابلة للإستخدام . هذا يسمح للمستخدم النهائى (انت المبرمج) من
تحديد جزء من الكود الذى يريد عمل cache له داخل جملة *{ ... }()if* حيث ان
الشرط هو هذه الدالة من Zend_Cache . فى نهاية هذه البلوكات يجب ان تقوم
بحفظ الناتج , بإستخدام (*()Zend_Cache_Core::save*).

.. note::

   عملية التنفيذ الشرطى للأكواد لا تكن مهمة فى بعض الحالات ( مثل
   إستخدام الـ frontend المسمى *Function*) حيث سيكون الجزء المنطقى من
   الكود معرف داخل الـ frontend نفسه.

.. note::

   المصطلح 'Cache hit' و الذى رأيته فى المثال نستخدمه للتعبير عن انه
   تم إيجاد بيانت فى الـ cache تنتمى لهذا المعرف و هذه البيانات
   قابلة للإستخدام و "طازجة" (بمعنى اخر لم تنتهى فترة صلاحيتها).
   المصطلح 'cache miss' هو عكس ما سبق, فعندما يحدث cache miss يجب ان تقوم
   بإنتاج بياناتك من جديد (كما يحدث فى الأوضاع الطبيعية) ثم تقم
   بعمل cache لها . و عندما يحدث cache hit تقم الـ backend تلقائياً بجلب
   البيانات من الـ cache .

.. _zend.cache.factory:

الـ factory method فى Zend_Cache
--------------------------------

طريقة جيدة لإنشاء frontend instance قابل لإستخدام من *Zend_Cache* نستعرضها
فى المثال التالى :

   .. code-block:: php
      :linenos:

      <?php

      # We "load" the Zend_Cache factory
      require 'Zend/Cache.php';

      # We choose a backend (for example 'File' or 'Sqlite'...)
      $backendName = '[...]';

      # We choose a frontend (for example 'Core', 'Output', 'Page'...)
      $frontendName = '[...]';

      # We set an array of options for the choosen frontend
      $frontendOptions = array([...]);

      # We set an array of options for the choosen backend
      $backendOptions = array([...]);

      # We make the good instance
      # (of course, the two last arguments are optional)
      $cache = Zend_Cache::factory($frontendName, $backendName, $frontendOptions, $backendOptions);

      ?>


فى الأمثلة التالية سنعتبر ان المتغير *cache$* يحتوى frontend instance صالح
للإستخدام كما هو موضح فى المثال السابق, و انك تفهم كيفية تمرير
parameters للـ backends التى تود إستخدامها.

.. note::

   دائما إستخدم *()Zend_Cache::factory* لتنشئ frontend instance . إنشاء الـ frontend
   instance و الـ backends instance بنفسك مباشرة لن يعمل كما تتوقع.

.. _zend.cache.tags:

إستخدام الـ tags
----------------

الـ tags طرق لتقسيم البيانات فى الـ cache الى اقسام معرفة, عندما تقم
بحفظ cache بإستخدام *()save* يمكنك ان تقم بتمرير array تحتوى على الـ tags
التى تتوافق مع هذا الـ record (او البيانت المخزنة فى الـ cache ) .
بالتالى ستستطيع حذف كل الـ cache records المنسوبة الى tag او مجموعة tags
محددة.

.. code-block:: php
   :linenos:

   <?php

   $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));

   ?>
.. _zend.cache.clean:

تنظيف الـ cache
---------------

لحذف او تحديد معرف cache على انه غير قابل للإستخدام, يمكنك استخدام
*()remove* كما فى المثال التالى :

.. code-block:: php
   :linenos:

   <?php

   $cache->remove('idToRemove');

   ?>
لحذف او تحديد اكثر من معرف cache على انهم غير قابلين للإستخدام,
يمكنك استخدام *()clean*, على سبيل المثال يمكنك حذف كل الـ cache records .

.. code-block:: php
   :linenos:

   <?php

   // clean all records
   $cache->clean(Zend_Cache::CLEANING_MODE_ALL);

   // clean only outdated
   $cache->clean(Zend_Cache::CLEANING_MODE_OLD);

   ?>
إن اردت حذف الـ cache records التى تنتمى الى tags محددة, مثلا 'tagA' و 'tagC'
يمكنك استخدام :

.. code-block:: php
   :linenos:

   <?php

   $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('tagA', 'tagC'));

   ?>
الـ cleaning modes المتوفرة هى : *CLEANING_MODE_ALL* تقوم بحذف كل الـ cache records
الموجودة , *CLEANING_MODE_OLD* تقوم بحذف الـ records القديمة او الغير صالحة
للإستخدام , *CLEANING_MODE_MATCHING_TAG* تقوم بحذف كل الـ records التى تنتمى الى
مجموعة tags محددة , *CLEANING_MODE_NOT_MATCHING_TAG* تقوم بحذف كل الـ records التى لا
تنتمى الى مجموعة الـ tags الممررة.


