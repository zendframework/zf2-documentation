.. EN-Revision: none
.. _zend.config.introduction:

مقدمة
=====

تم تصميم *Zend_Config* لتُبسّط عملية الوصول و أستخدام بيانات
الأعدادات "configuration data" داخل التطبيقات , حيث توفرالوصول إلى هذه
البيانات بنفس الطريقة المتبعة لقرائة قيمة property فى أى كائن PHP
عادى, و يمكن أن تأتى هذه البيانات من عدّة وسائط حفظ بيانات تدعم
جفظ البيانات بهيكلة هرمية, فحالياً توفر *Zend_Config* ادوات لقرائة
انواع من البيانات المحفوظة فى ملفات نصية و هى :ref:`Zend\Config\Ini
<zend.config.adapters.ini>` و :ref:`Zend\Config\Xml <zend.config.adapters.xml>`.

.. rubric:: إستخدام Zend_Config Per Se

من الطبيعى توقع أن المبرمجين سيستخدمون أحد الـ adapter classes أو الـ
"classes التوفيقية" مثل :ref:`Zend\Config\Ini <zend.config.adapters.ini>` أو :ref:`Zend\Config\Xml
<zend.config.adapters.xml>`, لكن إن كانت بيانات الأعدادات متوفرة فى مصفوفة
PHP عادية, يمكن تمرير هذه البيانات إلى *Zend_Config* فى الـ constructor , و
ذلك يفضل لتغليف البيانات داخل واجهة كأنية.

.. code-block:: php
   :linenos:

   <?php
   // Given an array of configuration data
   $configArray = array(
       'webhost' => 'www.example.com',
       'database' => array(
           'type'     => 'pdo_mysql',
           'host'     => 'db.example.com',
           'username' => 'dbuser',
           'password' => 'secret',
           'name'     => 'dbname'
       )
   );

   // Create the object-oriented wrapper upon the configuration data
   require_once 'Zend/Config.php';
   $config = new Zend\Config\Config($configArray);

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;

   // Use the configuration data to connect to the database
   $myApplicationObject->databaseConnect($config->database->type,
                                         $config->database->host,
                                         $config->database->username,
                                         $config->database->password,
                                         $config->database->name);
كما هو موضح فى المثال السابق , *Zend_Config* توفر امكانية الوصول إلى
البيانات الممرة إليه بنفس الطريقة المتبعة لقرائة قيم property من
أى كائن PHP عادى.


