.. _zend.view.migration:

עדכון מגרסאות קודמות
====================

פרק זה נועד בעיקר למידע אודות עדכון המערכות שלכם שנכתבו על גבי
גרסאות קודמות של Zend Framework ודורשות עדכונים מסויימים כדי לעבוד עם
הגרסאות החדשות.

.. _zend.view.migration.zf5748:

עדכון מגרסאות קודמות ל 1.7.5
----------------------------

לפני גרסאת 1.7.5, צוות Zend Framework קבל דיווח על פירצת אבטחה אשר מאפשרת
הוספת קובץ מקומי במתודת ה *Zend_View::render()*. הפרצה היא מסוג Local File
Inclusion (LFI). בגרסאות קודמות ל 1.7.5 המתודה הזאת אפשרה כברירת מחדל
להוסיף קבצי תצוגה אשר הכילו ציון לתקיה הראשית או תיקיה אחת מעלה
לדוגמא "../" או "..\\" . זה מאפשר לפרצת אבטחה מסוג LFI אם הקובץ תצוגה
שאמור להיות מוצג מתקבל על ידי הזנת משתמש לדוגמא:

.. code-block:: php
   :linenos:

   // Where $_GET['foobar'] = '../../../../etc/passwd'
   echo $view->render($_GET['foobar']); // LFI inclusion

כעת *Zend_View* כברירת מחדל תזרוק שגיאה על ידי חריגים ברגע שיהיה
ניסיון בטעינת קובץ בדרך זו.

.. _zend.view.migration.zf5748.disabling:

ביטול הגנה מפני LFI במתודת ה render()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

מאחר וכמה מתכנתים דווחו שהם משתמשים בדרך זו של טעינה של קבצים
אשר לא מתקבלים על ידי הזנת משתמשים, נוצר סימון מיוחד אשר מאפשר
ביטול ההגנה זו כברירת מחדל. ישנם 2 דרכים לעשות זאת: על ידי העברת
הפרמטר 'lfiProtectionOn' כשיוצרים את אובייקט התצוגה, או על ידי קריאה
למתודת ה *setLfiProtection()*.

.. code-block:: php
   :linenos:

   // Disabling via constructor
   $view = new Zend_View(array('lfiProtectionOn' => false));

   // Disabling via exlicit method call:
   $view = new Zend_View();
   $view->setLfiProtection(false);


