.. EN-Revision: none
.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

הקדמה
-----

מחלקה זו מייצגת חלק בודד מהודעת MIME. היא מכילה את התוכן של ההודעה
ואת המידע אודות הקידוד שלה, סוג התוכן ושם הקובץ המקורי. היא
מספקת מתודה ליצירת סטרינג מהמידע שנשמר. אובייקטים של *Zend_Mime_Part*
ניתנים להוספה אל :ref:`Zend_Mime_Message <zend.mime.message>` כדי להרכיב הודעה
מרובה חלקים מלאה.

.. _zend.mime.part.instantiation:

התקנה
-----

*Zend_Mime_Part* נקראת ונוצרת עם הוספת פרמטר שמהווה סטרינג שמייצג את
התוכן של החלק החדש. הסוג בדרך כלל מוגדר ל OCTET-STREAM, קידוד הינו
8ביט. לאחר יצירת *Zend_Mime_Part*, ניתן להגדירו על ידי הצבת ערכים
לתכונות שלו:

.. code-block:: php
   :linenos:

   public $type = Zend_Mime::TYPE_OCTETSTREAM;
   public $encoding = Zend_Mime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   public $boundary;
   public $location;
   public $language;


.. _zend.mime.part.methods:

מתודות
------

*getContent()* מחזיר את התוכן המקודד של ה MimePart בתור סטרינג על ידי
שימוש בקידוד שהוגדר בערך $encoding. ערכים חוקיים הם Zend_Mime::ENCODING_*
המרת קידודים לא נעשית.

*getHeaders()* מחזיר את הכותרים של ה MimePart כפי שהם נוצרו בתכונות
הניתנות לגישה של המחלקה. התכונות צריכות להיות מוגדרות בהתאם
לפני קריאה למתודה זו.

   - *$charset* חייב להיות מוגדר לקידוד של התוכן עצמו כדי שיוצג כמו
     שצריך.

   - *$id* ניתן להגדרה כדי לזהות תוכן מסויים לתמונות פנימיות בתוך
     אימייל HTML.

   - *$filename* מכיל את שם הקובץ אשר ניתן יהיה להוריד למחשב.

   - *$disposition* מגדיר בין אם הקובץ יהיה קובץ להורדה בתור צירוף, או
     ישמש בתור קובץ פנימי של האימייל.

   - *$description* משומש רק למטרות מידע

   - *$boundary* הגדרת סטרינג בתור גבול

   - *$location* יכול לשמש בתור קישור אשר מקושר לתוכן

   - *$language* מגדיר שפות בתוכן




