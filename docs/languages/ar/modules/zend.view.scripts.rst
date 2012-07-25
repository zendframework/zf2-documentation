.. _zend.view.scripts:

جزء الـ View
============

بمجرد إنتهاء الـ controller خاصتك من عملية نَسب المتغيرات إلى نسخة
Zend_View و إستدعاء ()render , يقوم Zend_View بجلب محتويات ملف الـ view و
ينفذها داخل المدى "scope" الخاص بنسخة الـ Zend_View , لذلك داخل أكواد
الـ view خاصتك تكون this$ تشير إلى نسخة الـ Zend_View نفسها .

المتغيرات التى تم نسبها إلى الـ view من قبل الـ controller يتم الإشارة
إليها على انها instance properties (أى properties تنتمى للنسخة فقط) , على سبيل
المثال : إن قام الـ controller بنسب متغير بأسم 'something' , يمكنك الأشار
إليه داخل كود الـ view كـ this->something$ , (هذا يسمح لك بمعرفة أى
المتغيرات تم نسبها إلى النسخة و أى المتغيرات داخلية فى كود الـ
view نفسه).

لنتذكر من جديد, ها هو مثال كود الـ view من فصل "مقدمة الـ Zend_view" .

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- A table of some books. -->
       <table>
           <tr>
               <th>Author</th>
               <th>Title</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>There are no books to display.</p>

   <?php endif; ?>

.. _zend.view.scripts.escaping:

تجاهل "escaping" المخرجات
-------------------------

واحدة من أهم المهام التى يجب تنفيذها فى كود الـ view هى أن تتأكد
من أن المخرجات قد تم عمل تجاهل لها أو escaping دائماً , و هذا أهم من
أشياء كثيرة أخرى , هذا يساعد فى تجنب هجمات الـ cross-site scripting , فإن
لم تكن تستخدم دالة أو method أو مساعد "helper" يقوم بعملية التجاهل
"escaping" بنفسه , فيجب عليك أنت أن تقوم بعمل تجاهل لمحتويات
متغيراتك قبل إخراجهم دائماً .

Zend_View يأتى مع method يسمى ()escape و هو الذى يقوم لك بعملية التجاهل
للمخرجات.

.. code-block:: php
   :linenos:

   <?php
   // bad view-script practice:
   echo $this->variable;

   // good view-script practice:
   echo $this->escape($this->variable);
   ?>

الأعدادات الأساسية للـ method المسمى ()escape هى أن يعتمد على دالة لغة
PHP المسمى ()htmlspecialchars لعمل تجاهل , لكن إعتماداً على بيئة عمل
تطبيقك , ربما تود أن تتم عملية التجاهل للمخرجات بطريقة أخرى ,
إستخدم الـ method المسمى ()setEscape و أنت فى مستوى الـ controller لتخبر
Zend_View عن ما الذى يجب إستدعائه (callback) عند تنفيذ عملية تجاهل
المخرجات.

.. code-block:: php
   :linenos:

   <?php
   // create a Zend_View instance
   $view = new Zend_View();

   // tell it to use htmlentities as the escaping callback
   $view->setEscape('htmlentities');

   // or tell it to use a static class method as the callback
   $view->setEscape(array('SomeClass', 'methodName'));

   // or even an instance method
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // and then render your view
   echo $view->render(...);
   ?>

الدالة أو الـ method الذى سيتم عمل callback له يجب أن يستلم القيمة التى
سيقوم بتجاهلها فى البراميتر الأول , و كل البراميترات الأخرى يجب
أن تكون أختيارية.

.. _zend.view.scripts.templates:

أنظمة القوالب
-------------

أيضاً لغة PHP نفسها عبارة عن نظام قوالب قوى, لكن بعض المطورين يرى
أنها قوية جدا أو معقدة بالنسبة إلى المصممين الذين سيستخدمون
القوالب. لذلك , كود الـ view من الممكن إستخدامه لإنشاء نسخ أو
معالجة كائنات قوالب منفصلة , مثل قوالب PHPLIB-style , كود الـ view لهذا
النوع من النشاطات من الممكن أن بيدو مثل هذا :

.. code-block:: php
   :linenos:

   <?php
   include_once 'template.inc';
   $tpl = new Template();

   if ($this->books) {
       $tpl->setFile(array(
           "booklist" => "booklist.tpl",
           "eachbook" => "eachbook.tpl",
       ));

       foreach ($this->books as $key => $val) {
           $tpl->set_var('author', $this->escape($val['author']);
           $tpl->set_var('title', $this->escape($val['title']);
           $tpl->parse("books", "eachbook", true);
       }

       $tpl->pparse("output", "booklist");
   } else {
       $tpl->setFile("nobooks", "nobooks.tpl")
       $tpl->pparse("output", "nobooks");
   }
   ?>

و هذه هى الملفات الأخرى ذات الصلة المفروض وجودها :

.. code-block:: php
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>Author</th>
           <th>Title</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>There are no books to display.</p>



