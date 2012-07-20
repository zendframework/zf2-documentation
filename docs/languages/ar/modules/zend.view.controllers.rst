.. _zend.view.controllers:

جزء الـ Controller
==================

الـ controller هو حيث يتم إنشاء نسخة من Zend_View و إعدادها , أنت بعد ذلك
تقم بإنشاء متغيرات جديدة فيها و إعطائها قيم ليتم إستخدامها فى
الـ view , ثم تقوم بالأمر بأن يتم معاجلة الـ view و إنتاج الخرج الذى
سيتم عرضه.

.. _zend.view.controllers.assign:

إنشاء متغيرات و إعطائها قيم
---------------------------

يجب أن يقوم الـ controller خاصتك بإنشاء المتغيرات التى يحتاج إليها
فى الـ view و تمريرها له قبل أن يقوم بنقل التحكم إلى الكود الخاص
بالـ view , بشكل طبيعى يمكنك إضافة متغيرات إلى الـ view عن طريق الـ
properties الخاصة بالنسخة التى أنشئتها من Zend_View :

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   ?>

لكن ربما هذا سيكون مزعج فى حالة أنك قد قمت مسبقاً بجمع كل القيم
التى تريد تمريرها فى مصفوفة أو فى كائن.

الـ method المسمى ()assign يسمح لك بإنشاء متغيرات من مصفوفة أو كائن
(بشكل مفكك) , المثال التالى لديه نفس التأثير الذى تقوم به عملية
إنشاء المتغيرات واحد-واحد .

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();

   // assign an array of key-value pairs, where the
   // key is the variable name, and the value is
   // the assigned value.
   $array = array(
       'a' => "Hay",
       'b' => "Bee",
       'c' => "Sea",
   );
   $view->assign($array);

   // do the same with an object's public properties;
   // note how we cast it to an array when assigning.
   $obj = new StdClass;
   $obj->a = "Hay";
   $obj->b = "Bee";
   $obj->c = "Sea";
   $view->assign((array) $obj);
   ?>

أيضاً, يمكنك ان تستخدم الـ method المسمى assign لإنشاء متغيرت بطريقة
واحد-واحد , و ذلك عن طريق تمرير اسم المتغير الذى تريد إنشائه كـ
string , ثم فى البراميتر الثانى مرر قيمة المتغير .

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->assign('a', "Hay");
   $view->assign('b', "Bee");
   $view->assign('c', "Sea");
   ?>

.. _zend.view.controllers.render:

معالجة(تصيير) جزء الـ View
--------------------------

بمجرد إنتهائك من عملية إنساب المتغيرات التى تحتاجها فى الـ view ,
يجب أن يقوم الـ controller بأمر Zend_View أن يقوم بمعالجة view محدد , يمكن
القيام بهذا عن طريق إستدعاء الـ method المسمى ()render , لاحظ أن هذا
الـ method سيقوم بإرجاع الـ view بعد معالجته و لن يقوم بطباعته, لذلك
أنت تحتاج لطباعته بنفسك فى الوقت الذى يناسبك.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   echo $view->render('someView.php');
   ?>

.. _zend.view.controllers.script-paths:

مسارات أجزاء الـ View
---------------------

الأعدادات الأساسية لـ Zend_View تعتبر أن الملفات التى تحتوى أجزاء
الـ view خاصتك تتواجد فى مسارات لها علاقة "relative" مع مكان تواجد
الكود الذى يستدعيها, على سبيل المثال : إن كان الـ controller خاصتك
موجود فى "path/to/app/controllers/" و هو يقوم بإستدعاء ('view->render('someView.php$ ,
سيقوم Zend_View بالبحث فى المسار "path/to/app/controllers/someView.php/".

من الطبيعى أن تكون ملفات الـ view خاصتك محفوظة فى مسار أخر , لكى
تخبر Zend_View أين يجب عليه أن يبحث عن ملفات الـ view , يمكنك إستخدام
الـ method المسمى ()setScriptPath .

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->setScriptPath('/path/to/app/views');
   ?>

الأن عندما ستقوم بإستدعاء ('view->render('someView.php$ , سيتم البحث فى
المسار "path/to/app/views/someView.php/".

فى الحقيقة, يمكنك عمل مرصوصة من المسارات بإستخدام الـ method
المسمى ()addScriptPath , كلما قمت بإضافة مسار جديد إلى المرصوصة , سيقوم
Zend_View بالبحث فى المسارات التى تم إضافتها إلى المرصوصة من أخر
واحد تم إضافته إلى المرصوصة صعوداً إلى أول من تم إضافته لجلب
جزء الـ view المراد معالجته, هذا يسمح لك بأن تقوم بالتغطية على الـ
views الأساسية و إستخدام views أخرى , و هذا سيسمح لك بأن تقوم بإنشاء
themes أو skins خاصة لبعض الـ views , مع أمكانية ترك views أخرى بدون.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->addScriptPath('/path/to/app/views');
   $view->addScriptPath('/path/to/custom/');

   // now when you call $view->render('booklist.php'), Zend_View will
   // look first for "/path/to/custom/booklist.php", then for
   // "/path/to/app/views/booklist.php", and finally in the current
   // directory for "booklist.php".
   ?>


