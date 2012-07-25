.. _zend.measure.introduction:

הקדמה
=====

מחלקות ה *Zend_Measure_** מספקות דרך כללית וקלה לעבודה עם מדידות. שימוש
במחלקות ה *Zend_Measure_**, מאפשר לך להפוך מדידות ליחידות שונות מאותו
הסוג. הם יכולים להתווסף, להחסיר ולהשוואת אחד מול השני. מערך
שהתקבל ממשתמש בשפה המקומית שלו, ניתן לקבל את יחידת המדידה
המדוייקת. עשרות יחידות מדידה נתמכות.

.. _zend.measure.introduction.example-1:

.. rubric:: המרת מדידות

הדוגמאות המקדימות הבאות מציגות כיצד ניתן להמיר יחידות מדידה
אוטומטית. כדי להמיר מדידה, הערך שלו והסוג חייבים להיות ידועים
מראש. הערך יכול להיות מסוג מספר שלם, עשרוני ואפילו סטרינג עם
המספר המייצג אותו. המרות ניתן לבצע רק אם שני היחידות מאותו סוג,
לא בין שני סוגים שונים.

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Length(100, Zend_Measure_Length::METER, $locale);

   // Convert meters to yards
   echo $unit->convertTo(Zend_Measure_Length::YARD);


*Zend_Measure_** מכיל תמיכה בכמה יחידות מדידה שונות. כדי לקרוא לכל אחת
מיחידות המדידה יש להשתמש בסוג ציון מסויים: *Zend_Measure_<TYPE>::NAME_OF_UNIT*,
איפה זה <TYPE> מייצג ערך מספרי או פיזי ידוע. לכל יחידת מדידה יש
גורם המרה ויחידת תצוגה. רשימה מלאה אודות יחידות התצוגה וההמרה
ניתן לקרוא ב :ref:`סוגי מדידה <zend.measure.types>`.

.. _zend.measure.introduction.example-2:

.. rubric:: יחידת המדידה *meter*

יחידת המדידה *meter* נועדה למדידת מרחק, לכן הערך הקבוע שלה נתן
למציאה במחלקת *Length*. כדי להשתמש בסוג מדידה זה, יש להשתמש בסוג
הציון *Length::METER*. יחידת התצוגה של סוג מדידה זה היא *m*.

.. code-block:: php
   :linenos:

   echo Zend_Measure_Length::STANDARD;  // outputs 'Length::METER'
   echo Zend_Measure_Length::KILOMETER; // outputs 'Length::KILOMETER'

   $unit = new Zend_Measure_Length(100,'METER');
   echo $unit;
   // outputs '100 m'



