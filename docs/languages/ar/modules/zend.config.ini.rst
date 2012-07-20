.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

يوفر *Zend_Config_Ini* للمبرمج امكانية حفظ البيانات الخاصة بإعدادات
البرنامج , و ذلك بصيغة الـ INI المألوفة , ثم تمكنه من قرائه هذه
البيانات داخل برنامجه بيسر من خلال استخدامه لنفس القواعد
النحوية التى يستخمدها عند قرائته لقيمة محفوظة فى property داخل
كائن PHP عادى.

صيغة الـ INI توفر أمكانية إنشاء بيانات مرتبة على شكل هرمى و
امكانية التوارث بين أقسام البيانات , حفظ البيانات بشكل هرمى
مدعوم حالياً عن طريق الفصل بين اسماء المفاتيح "Keys" بإستخدام
نقطة (*.*), و يمكن لأى قسم من أقسام البيانات أن يرث من قسم بيانات
أخر عن طريق إلحاق أسم القسم بنقطة مزدوجة (*:*) ثم إلحاقها بأسم
القسم الذى سيتم الوراثة منه.

.. note::

   **parse_ini_file**

   تستخدم *Zend_Config_Ini* دالة PHP تسمى `()parse_ini_file`_, يرجى أن تقوم بمراجعة
   دليل المبرمج الخاص بلغة PHP لتتعرف على سلوك هذه الدالة, و الذى
   ينطبق على *Zend_Config_Ini*, مثل كيف يتم التعامل مع القيم الخاصة *true* و
   *false* و *yes* و *no* و *null*.

.. rubric:: إستخدام Zend_Config_Ini

هذا المثال يوضح إستخدام بسيط لـ *Zend_Config_Ini* لتحميل بيانات
الأعدادات من ملف INI , فى هذا المثال يوجد بيانات الأعدادات الخاصة
بكل من مرحلة الأنتاج "production" و مرحلة التجهيز "staging" , و لأن بيانات
الأعدادات الخاصة بمرحلة الـ staging تتشابه كثيراً مع تلك الخاصة
بمرحلة الـ production , فتم جعل قسم بيانات الـ staging يرث من قسم بيانات
الـ production , ربما هذا لا ينطبق على بعض الحالات الأكثر تعقيداً و
لكن دعونا نفترض أن بيانات الأعدادت التالية محفوظة على المسار
*path/to/config.ini/*:

.. code-block::
   :linenos:
   ; Production site configuration data
   [production]
   webhost           = www.example.com
   database.type     = pdo_mysql
   database.host     = db.example.com
   database.username = dbuser
   database.password = secret
   database.name     = dbname

   ; Staging site configuration data inherits from production and
   ; overrides values as necessary
   [staging : production]
   database.host     = dev.example.com
   database.username = devuser
   database.password = devsecret
الأن و لنفترض أن مطور البرنامج يريد تحميل بيانات الأعدادات
الخاصة بمرحلة الـ staging من ملف الـ INI , بالفعل إنه من السهل تحميل
هذه البيانات فقط عن طريق تحديد مسار ملف الـ INI و أسم قسم
البيانات staging :

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Config/Ini.php';

   $config = new Zend_Config_Ini('/path/to/config.ini', 'staging');

   echo $config->database->host; // prints "dev.example.com"
   echo $config->database->name; // prints "dbname"


.. _`()parse_ini_file`: http://php.net/parse_ini_file
