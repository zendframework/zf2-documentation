.. EN-Revision: none
.. _zend.progressbar.introduction:

Zend_ProgressBar
================

.. _zend.progressbar.whatisit:

הקדמה
-----

*Zend_ProgressBar* הינו רכיב ליצירה ועדכון של בר התקדמות בסביבות עבודה
שונות. הוא מכיל חלק מרכזי, אשר מדפיס את ההתקדמות דרך אחד
מהמתאמים הנתנים לשימוש. בכל עדכון, הוא מקבל ערך אבסולוטי והודעה
אופציונלית, ואז קורא למתאם עם הערך המחושב האחוז והזמן שנשאר.

.. _zend.progressbar.basic:

שימוש בסיסי ב Zend_Progressbar
------------------------------

*Zend_ProgressBar* הוא די פשוט בשימוש שלו. כל מה שצריך לעשות זה ליצור
אובייקט חדש של *Zend_ProgressBar*, הגדרת ערך מינימלי וערך מקסימלי,
ולבחור בסוג המתאם לשימוש ולהצגת הנתונים. אם תרצו לעבד קובץ
תצטרכו לעשות משהו כזה:

.. code-block:: php
   :linenos:

   $progressBar = new Zend_ProgressBar($adapter, 0, $fileSize);

   while (!feof($fp)) {
       // Do something

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();


בשלב הראשון, אובייקט של *Zend_ProgressBar* נוצר, עם מתאם מסויים, ערך
מינימלי שהוא 0 וערך מקסימלי שהוא בעצם הגודל של הקובץ. לאחר מכן
הקובץ מעובד ובכל פעם בלולאה ההתקמות מעודכנת עם הערך החדש על פי
מספר הבתים שהועלו. בסופה של הלולאה, ההתקדמות הסתיימה.

ניתן גם לקרוא למתודת ה *update()* של *Zend_ProgressBar* ללא פרמטרים, שבסך הכל
מחשבת את הזמן המוערך ומודיע למתאם. זה שימוש כשאין לך מידע לעדכן
אבל אתה רוצה שבר ההתקדמות התעדכן.

.. _zend.progressbar.persistent:

התקדמות קבועה
-------------

אם הנך רוצה שבר ההתקדמות יהיה קבוע בכל עמוד ובמספר רב של בקשות,
תוכל לתת שם שישמש בתור מזהה יחודי בתור פרמטר רבעי כשהאובייקט
נוצר. במקרה הזה, בר ההתקדמות לא ידווח למתאם אשר יצר את האובייקט
אלה רק מתי שהמתודות *update()* או *finish()* יקראו. כמו כן הערך הנוכחי,
סטטוס ההודעה וזמן ההתחלה כדי לחשב את זמן הסיום המשוער יוחזרו
בבקשה הבאה בכל פעם.

.. _zend.progressbar.adapters:

מתאמים סטנדרטיים
----------------

*Zend_ProgressBar* מגיע עם המתאמים הבאים:



   - :ref:` <zend.progressbar.adapter.console>`

   - :ref:` <zend.progressbar.adapter.jspush>`

   - :ref:` <zend.progressbar.adapter.jspull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

