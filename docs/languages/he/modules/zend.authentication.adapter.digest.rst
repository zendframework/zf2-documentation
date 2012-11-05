.. EN-Revision: none
.. _zend.authentication.adapter.digest:

אימות מתקדם
===========

.. _zend.authentication.adapter.digest.introduction:

הקדמה
-----

`אימות מתקדם`_ הינה שיטת אימות בעזרת פרוטוקול HTTP אשר משפרת את
`אימות בסיסי`_ על ידי מתן אפשרות לאמת נתונים של משתמש דרך שרתים
ללא צורך בהעברת הסיסמא בתור טקסט רגיל.

מתאם זה מאפשר לאמת מול קבצי טקסט המכילים שורות התואמים
לאלמנטים הבסיסים של אימות מתקדם:

   - שם משתמש, כמו "*joe.user*"

   - תחום, לדוגמא "*לוח בקרה*"

   - הצפנת MD5 של שם המשתמש, התחום והסיסמא, מופרדים בנקודותיים.

האלמנטים למעלה מופרדים בנקודותיים, כמו בדוגמא הבאה ("*somePassword*"):

.. code-block:: php
   :linenos:

   someUser:Some Realm:fde17b91c3a510ecbaf7dbd37f59d4f8


.. _zend.authentication.adapter.digest.specifics:

מאפיינים
--------

רכיב *Zend\Auth_Adapter\Digest*, אשר משמש בתור מתאם אימות מתקדם, דורש כמה
פרמטרים:

   - שם הקובץ - שם הקובץ שמולו כל שאילתות האימות יבוצעו.

   - תחום - התחום שבו האימות מתבצע עליו

   - שם משתמש - שם משתמש לאימות

   - סיסמא - סיסמא למשתמש של אותו תחום

פרמטרים אלו צריכים להיות מוגדרים לפני הקריאה אל *authenticate()*.

.. _zend.authentication.adapter.digest.identity:

זהות
----

המתאם המתקדם מחזיר אובייקט של *Zend\Auth\Result*, אשר נוצרה עם הזהות
בתור מערך אשר מכיל מפתחות של *realm* ו *username*. הערכים במערך מקושרים
למפתחות אשר הוגדרו לפני קריאה ל *authenticate()*.

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth_Adapter\Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Some Realm
       [username] => someUser
   )
   */




.. _`אימות מתקדם`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`אימות בסיסי`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
