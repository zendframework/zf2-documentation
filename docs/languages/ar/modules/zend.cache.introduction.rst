.. EN-Revision: none
.. _zend.cache.introduction:

مقدمة
=====

*Zend_Cache* يوفر إمكانية عمل cache للبيانات.

عملية الـ caching فى إطار عمل Zend يتم إدارتها من خلال مجموعة من الـ
frontends فى حين ان سجلات الـ cache يتم حفظها و استرجاعها عن طريق backend
adapters مثل (*File*, *Sqlite*, *Memcache*...) و يستخدم ايضا IDs و tags. بهذه الطريقة
يكن من السهل حذف مجموعات محددة من السجلات بعد ذلك. على سبيل
المثال ("حذف كل سجلات الـ cache المعرفة بـ tag معين")

Core هو (*Zend_Cache_Core*) و هو يمثل المرونة و الشمولية و قابلية تعديل
الخصائص (configurable). حتى الأن يوجد مجموعة من الـ cache frontends تمتد عن
*Zend_Cache_Core* و التى ستخدم احتياجاتك. و هى : *Output*, *File*, *Function* و *Class*.

.. rubric:: إنشاء frontend بواسطة *()Zend_Cache::factory*

*()Zend_Cache::factory* ينشئ الـ objects المتوافقة معا و التى ستحتاجها لإتمام
عملك. فى هذا المثال, سنستخدم frontend و هو *Core* و سنستخدم ايضا backend
وهو *File*.

   .. code-block:: php
      :linenos:

      <?php
      require_once 'Zend/Cache.php';

      $frontendOptions = array(
         'lifeTime' => 7200, // cache lifetime of 2 hours
         'automaticSerialization' => true
      );

      $backendOptions = array(
          'cacheDir' => './tmp/' // Directory where to put the cache files
      );

      // getting a Zend_Cache_Core object
      $cache = Zend_Cache::factory('Core', 'File', $frontendOptions, $backendOptions);

      ?>


الأن لدينا frontend و أيضا يمكننا عمل cache لأى نوع من البيانات (لأننا
قمنا بتشغيل الـ serialization ) . على سبيل المثال , يمكننا عمل cache
لبيانات ناتجة عن تنفيذ استعلام كبير على قاعدة بيانات . بعد عمل
cache لهذه البيانات, لن نحتاج الى ان نتصل حتى بقاعدة البيانات فى
المرات القادمة; كل ما علينا هو جلب هذه البيانات من الـ cache و
استخدامها (سيتم عمل unserialization للبيانات ضمنيا ).

   .. code-block:: php
      :linenos:

      <?php

      // $cache initialized in previous example

      // see if a cache already exists:
      if(!$result = $cache->load('myresult')) {

          // cache miss; connect to the database

          $db = Zend_Db::factory( [...] );

          $result = $db->fetchAll('SELECT * FROM huge_table');

          $cache->save($result, 'myresult');

      } else {

          // cache hit! shout so that we know
          echo "This one is from cache!\n\n";

      }

      print_r($result);

      ?>


.. rubric:: عمل cache للخرج بإستخدام الـ Output frontend الخاصة بـ *Zend_Cache*

سنقوم بتحديد الأماكن التى نريد عمل cache لخرجها و ذلك بإستخدامنا
لبعض الأكواد الشرطية, سنضع بلوك الكود المحدد ما بين الـ method
المسمى *()start* و الأخر المسمى *()end*. ( هذا يعيد هيكلة المثال الأول و
هذه هى الفكرة الأساسية للـ caching ).

بالداخل ستقوم بإخراج البيانات كالمعتاد, كل الخرج سيكن قد تم عمل
cache له عندما يتم الوصول الى *()end*. عند تشغيل هذا الكود مرة اخرى, لن
يتم تنفيذ الكود المحدد فى هذا المكان لكن سيتم جلب البيانات من
الـ cache - و هذا طالما ان البيانات فى الـ cache مازالت قابلة
للإستخدام .

   .. code-block:: php
      :linenos:

      <?php

      $frontendOptions = array(
         'lifeTime' => 30,                  // cache lifetime of half a minute
         'automaticSerialization' => false  // this is default anyway
      );

      $backendOptions = array('cacheDir' => './tmp/');

      $cache = Zend_Cache::factory('Output', 'File', $frontendOptions, $backendOptions);

      // we pass a unique identifier to the start() method
      if(!$cache->start('mypage')) {
          // output as usual:

          echo 'Hello world! ';
          echo 'This is cached ('.time().') ';

          $cache->end(); // the output is saved and sent to the browser
      }

      echo 'This is never cached ('.time().').';

      ?>


لاحظ اننا نقوم بإخراج ناتج الدالة *()time* مرتين; و هذا نستخدمه هنا
فقط للتوضيح. جرب ان تشغل هذا مرة ثم قم بإعادة تشغيله عدة مرات
متتالية, ستلاحظ ان الرقم الأول لا يتغير و لكن الرقم الثانى
يتغير مع مرور الوقت, هذا لأن الرقم الأول تم اخراجه فى منطقة الـ
cache المحددة فى الكود و بالتالى تم حفظه فى الـ cache على عكس بقية
البيانات المخرجة. بعد نصف دقيقة سيصبح الرقمين متساويين لأن
فترة صلاحية البيانات فى الـ cache قد انتهت ( لقد قمنا بوضع قيمة
lifeTime الى 30 ثانية ). و بهذا سيتم تحديث قيمة البيانات المخزنة فى
الـ cache من جديد. - جرب هذا بنفسك فى متصفحك لتفهم ما يحدث.

.. note::

   عند إستخدام Zend_Cache, ركز على إعطاء معرف مميز للـ cache (الذى تمرره
   الى *()start* و *()save*) و يجب الا يتكرر فى عمليات cache اخرى. الوقوع فى
   هذا الخطأ سيسبب تداخل بين البيانات و اسوأ ما سيحدث هو أن هذه
   البيانات ستظهر فى اماكن ظهور بيانات أخرى.


