.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

תוסף עזרה ה Doctype
===================

קוד HTML ו XHTML תקני צריכים להכיל הגדרה של *DOCTYPE*. מלבד זה שקשה לזכור
אותם, ערכים אלו משפיעים על אופן העבודה של אלמנטים אחרים בעמוד
שלכם ואופן התצוגה שלהם, לדוגמא הברחת תגי CDATA בתוך אלמנטים *<script>*
ו *<style>*

תוסף העזרה *Doctype* מאפשר לך לקבוע אחד מהערכים הבאים:

- *XHTML11*

- *XHTML1_STRICT*

- *XHTML1_TRANSITIONAL*

- *XHTML1_FRAMESET*

- *XHTML_BASIC1*

- *HTML4_STRICT*

- *HTML4_LOOSE*

- *HTML4_FRAMESET*

- *HTML5*

ניתן גם להגדיר ערך מותאם אישית בתנאי שהוא מוגדר כראוי.

תוסף העזרה *Doctype* הוא יישום בסיסי של :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: שימוש בסיסי

ניתן להגדיר את אלמנט זה בכל שלב, אך רצוי לעשות זאת בתחילת
המערכת, בקובץ ה bootstrap

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View_Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');


ולאחר מכן להציג אותו בראש העמוד שלך:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>


.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: קבלת הערך

אם אתה צריך לדעת מהו הערך שהוגדר תוכל לעשות זאת על ידי קריאה
למתודה *getDoctype()* על האובייקט, שמוחזר על ידי שימוש בתוסף.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();


בדרך כלל תרצה לדעת אם הערך הוא תקין מבחינת XHTML או לא; בישביל זה
שימוש ב *isXhtml()* יספיק:

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // do something differently
   }



