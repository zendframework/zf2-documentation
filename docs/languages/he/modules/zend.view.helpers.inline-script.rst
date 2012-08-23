.. EN-Revision: none
.. _zend.view.helpers.initial.inlinescript:

תוסף עזרה לסקריפטים
===================

תגית ה *<script>* ב HTML משמשת בעיקר כדי להוסיף קוד סקריפט בצד הלקוח
ישירות בעמוד, או להוסיף קישור לקובץ סקריפט חיצוני. תוסף העזרה
*InlineScript* מאפשר לך לנהל את שניהם. הוא נגזר מ :ref:`HeadScript
<zend.view.helpers.initial.headscript>`, וכל מתודה מתוסף עזרה זה היא זמינה; למרות
זאת, השתמש ב *inlineScript()* במקום *headScript()*.

.. note::

   **השתמש בתוסף העזרה InlineScript בתוכן ה HTML**

   יש להשתמש ב *InlineScript* כשהנכם רוצים להוסיף סקריפטים ישירות לקוד
   ה HTML של העמוד. הוספת הסקריפטים בסוף העמוד הם הדרך הנכונה
   להוספת סקריפטים, כדי לזרז את תהליך הצגת העמוד.

   חלק מספריות ה JS הנפוצות כיום צריכות להתווסף בין תגי ה *head* בתוך
   קוד ה HTML בעמוד; השתמשו ב :ref:`HeadScript <zend.view.helpers.initial.headscript>` כדי
   להוסיף סקריפטים אלו.


