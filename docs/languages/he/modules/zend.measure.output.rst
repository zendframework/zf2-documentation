.. _zend.measure.output:

הדפסת מדידות
============

ניתן להדפיס את המדידות במספר דרכים.

:ref:`הדפסה אוטומטית <zend.measure.output.auto>`

:ref:`הדפסת ערכים <zend.measure.output.value>`

:ref:`הדפסה עם יחידת המדידה <zend.measure.output.unit>`

:ref:`הדפסה בתור סטרינג מקומי <zend.measure.output.unit>`

.. _zend.measure.output.auto:

הדפסה אוטומטית
--------------

*Zend_Measure* תומך בהדפסת הנתונים אוטומטית.



      .. _zend.measure.output.auto.example-1:

      .. rubric:: הדפסה אוטומטית

      .. code-block::
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89 Meter";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit;




.. note::

   **הדפסת מדידה**

   ניתן להציג את ערך המדידה בעזרת שימוש פשוט בפונקציות `echo`_ או
   `print`_.

.. _zend.measure.output.value:

הדפסת ערכים
-----------

ערך המדידה ניתן להדפסה על ידי קריאה ל *getValue()*.



      .. _zend.measure.output.value.example-1:

      .. rubric:: הדפסת ערך

      .. code-block::
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89 Meter";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit->getValue();




מתודת ה *getValue()* מאפשרת הזנה של פרמטר אחד אופציונלי אשר מעיד על
'*round*' אשר יעגל את הערך שיוזחר, מאפשר הצגה של הערך כשהוא מעוגל
למספר מסויים. כברירת מחדל זה יופיע תמיד ב '*2*'.

.. _zend.measure.output.unit:

הדפסה עם יחידת המדידה
---------------------

הפונקציה *getType()* מחזירה את יחידת המדידה הנוכחית.



      .. _zend.measure.output.unit.example-1:

      .. rubric:: הדפסה עם יחידת המדידה

      .. code-block::
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Weight($mystring,
                                         Zend_Measure_Weight::POUND,
                                         $locale);

         echo $unit->getType();




.. _zend.measure.output.localized:

הדפסה בתור סטרינג מקומי
-----------------------

הדפסת הסטרינג בפורמט מקומי של המשתמש אשר צופה היא לעיתים הדרך
המועדפת. לדוגמא, המדידה "1234567.8" תוצג בתור "1.234.567,8" בגרמניה. אפשרות
זו תיהיה קיימת בגרסאות הבאות.



.. _`echo`: http://php.net/echo
.. _`print`: http://php.net/print
