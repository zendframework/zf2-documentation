.. _zend.version.reading:

הצגת גרסאת Zend Framework
=========================

*Zend_Version* מספקת שימוש בערך קבוע במחלקה *Zend_Version::VERSION* אשר מכיל
סטרינג המייצג את הגרסא של מערכת ה Zend Framework אשר הינך משתמש בה.
לדוגמא *Zend_Version::VERSION* יכול להציג "1.7.4".

המתודה הסטטית *Zend_Version::compareVersion($version)* מבוססת על הפונקציה של PHP
`version_compare()`_. מתודה זו מחזירה -1 אם הגרסא שצויינה ישנה יותר מהגרסא
הנוכחית של Zend Framework, 0 אם הם זהים, ו +1 אם הגרסא שצויינה עדכנית
יותר מהגרסא הנוכחית של Zend Framework אשר הינך משתמש בה.

.. _zend.version.reading.example:

.. rubric:: דוגמא לשימוש במתודת *compareVersion()*

.. code-block:: php
   :linenos:

   // returns -1, 0 or 1
   $cmp = Zend_Version::compareVersion('2.0.0');




.. _`version_compare()`: http://php.net/version_compare
