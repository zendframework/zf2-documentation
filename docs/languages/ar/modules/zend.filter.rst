.. EN-Revision: none
.. _zend.filter.filter:

Zend_Filter
===========

.. _zend.filter.filter.introduction:

مقدمة
-----

توفر ``Zend_Filter`` مكتبة من الـ static methods لفلترة البيانات , و لفلترة
البيانات المدخلة من المستخدم , يجب ان تستخدم :ref:` <zend.filter.input>`
بدلا منها, و ذلك لأنها توفر بيئة كاملة لفلترة البيانات المدخلة
من المستخدم , و لكن لأن ``Zend_Filter_Input`` تم تصميمه فى الأصل للـ arrays ,
فيمكن ان يكن ``Zend_Filter`` مفيد عند فلترة البيانات ذات البعد الواحد
(strings او اعداد), لأنها تتصرف مثل الدوال المتوفرة فى لغة PHP:

.. code-block:: php
   :linenos:

       <?php

       $alphaUsername = Zend_Filter::getAlpha('John123Doe');

       /* $alphaUsername = 'JohnDoe'; */

       ?>

.. _zend.filter.filter.usecases:

امثلة
-----

فى كل من الأمثة التالية , ``value$`` تمثل قيمة ذات بعد واحد .

Whitelist Filtering:

.. code-block:: php
   :linenos:

       <?php

       if (Zend_Filter::isEmail($value)) {
           /* $value is a valid email format. */
       } else {
           /* $value is not a valid email format. */
       }

       ?>

Blind Filtering:

.. code-block:: php
   :linenos:

       <?php

       $alphaName = Zend_Filter::getAlpha($value);

       ?>

Blacklist Filtering:

.. code-block:: php
   :linenos:

       <?php

       $taglessComment = Zend_Filter::noTags($value);

       ?>


