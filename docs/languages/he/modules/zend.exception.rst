.. _zend.exception.using:

שימוש בחריגים
=============

*Zend_Exception* היא פשוט מחלקת הבסיס לשימוש בחריגים שנזרקים במערכת ה
Zend Framework

.. _zend.exception.using.example:

.. rubric:: תפיסת חריג שנזרק

הקוד הבא מציג כיצד נתן לתפוס חריג שנזרק במערכת ה Zend Framework

.. code-block::
   :linenos:

   try {
       // Calling Zend_Loader::loadClass() with a non-existant class will cause
       // an exception to be thrown in Zend_Loader
       Zend_Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // Other code to recover from the error
   }


*Zend_Exception* יכולה להיות המחלקה שתשמש בתור המחלקה שתתפוס את כל
החריגים שנזרקים במערכת ה Zend Framework. זה יכול להיות שימושי
כשהמערכת לא יכולה להשתקם מתפיסה של חריג מסויים.

הדוקומנטציה של כל רכיב ב Zend Framework מכיל מידע אודות החריגים
שנזרקים מכל מתודה במחלקה, ההשלכות של כל חריג שנזרק נסיבות זריקת
החריג, והמחלקה של כל החריגים שיכולים להזרק.


