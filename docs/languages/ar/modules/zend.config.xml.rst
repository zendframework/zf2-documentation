.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

يوفر *Zend_Config_Xml* للمبرمج امكانية حفظ البيانات الخاصة بإعدادات
البرنامج , و ذلك بصيغة XML بسيطة , ثم تمكنه من قرائه هذه البيانات
داخل برنامجه بيسر من خلال استخدامه لنفس القواعد النحوية التى
يستخمدها عند قرائته لقيمة محفوظة فى property داخل كائن PHP عادى.

عنصر الجزر أو الـ "root element" الخاص بملف الـ XML يعتبر غير مهم هنا و
يمكن اعطائه أى أسم تريده, أما المستوى الأول من عناصر الـ XML
يعتبر مُحدِد لأقسام البيانات , و توفر صيغة XML امكانية ترتيب
البيانات بشكل هرمى عن طريق عمل تداخل "nesting" بين العناصر فى
المستويات أدنى مستوى أقسام البيانات, و سيتم اعتبار محتويات أخر
عنصر فى هذا التداخل على انه القيمة "value" التى سيحملها هذا العتصر
الهرمى البنية, أما وراثة الأقسام لبعضها فمدعومة عن طريقة خاصية
"attribute" خاصة تسمى *extends*, و يجب أن يتم تعريف قيمة هذا الـ attribute فى
قسم البيانات الذى يقوم بالوراثة من قسم بيانات أخر , حيث ستكون
قيمة هذا الـ attribute هى أسم قسم البيانات الذى سيتم الوراثة منه.

.. note::

   **Return type**

   البيانات المقرؤة من خلال *Zend_Config_Xml* يتم اعتبارها دائما على
   انها من النوع string , و تم ترك عملية تحويل البيانات من نوع string
   إلى أى نوع بيانات أخر إلى المبرمجين ليتمكنوا من سد أحتياجاتهم
   الخاصة .

.. rubric:: إستخدام Zend_Config_Xml

هذا المثال يوضح إستخدام بسيط لـ *Zend_Config_Xml* لتحميل بيانات
الأعدادات من ملف INI , فى هذا المثال يوجد بيانات الأعدادات الخاصة
بكل من مرحلة الأنتاج "production" و مرحلة التجهيز "staging" , و لأن بيانات
الأعدادات الخاصة بمرحلة الـ staging تتشابه كثيراً مع تلك الخاصة
بمرحلة الـ production , فتم جعل قسم بيانات الـ staging يرث من قسم بيانات
الـ production , ربما هذا لا ينطبق على بعض الحالات الأكثر تعقيداً و
لكن دعونا نفترض أن بيانات الأعدادت التالية محفوظة على المسار
*path/to/config.ini/*:

.. code-block::
   :linenos:
   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <type>pdo_mysql</type>
               <host>db.example.com</host>
               <username>dbuser</username>
               <password>secret</password>
               <name>dbname</name>
           </database>
       </production>
       <staging extends="production">
           <database>
               <host>dev.example.com</host>
               <username>devuser</username>
               <password>devsecret</password>
           </database>
       </staging>
   </configdata>
الأن و لنفترض أن مطور البرنامج يريد تحميل بيانات الأعدادات
الخاصة بمرحلة الـ staging من ملف الـ XML , بالفعل إنه من السهل تحميل
هذه البيانات فقط عن طريق تحديد مسار ملف الـ XML و أسم قسم
البيانات staging :

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Config/Xml.php';

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->host; // prints "dev.example.com"
   echo $config->database->name; // prints "dbname"

