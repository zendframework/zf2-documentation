.. EN-Revision: none
.. _zend.view.helpers.initial.headtitle:

תוסף העזרה HeadTitle
====================

אלמנט תגית *<title>* ב HTML נועד להצגת כותרת העמוד שכרגע מוצג. תוסף
העזרה *HeadTitle* מאפשר ליצור ולשמור את הכותרת לשימוש ותצוגה בשלב
מאוחר יותר.

תוסף העזרה *HeadTitle* הוא יישום משמעותי של :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`. הוא דורש את המתודה *toString()* כדי להכפות
יצירת תג *<title>*, ומוסיף אותו למתודת ה *headTitle()* לשמירה מהירה ופשוטה
ולהתקבצות של כל האלמנטים. השימוש במתודה זו היא *headTitle($title, $setType =
'APPEND')*; כברירת מחדל, הערך שנוסף מצורף לקבוצת האלמנטים שכבר
קיימים, אבל ניתן להגדיר או 'PREPEND' כדי להוסיף בראש הרשימה או 'SET'
לשכתב את כל הרשימה בערך זה.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: שימוש בסיסי בתוסף

תוכל להגדיר תג כותרת בכל שלב. שימוש נכון בדרך כלל הוא לשמור
כותרת בכל שלב במערכת: אתר, קונטרולר, מתודה ולפעמים גם דברים
נוספים.

.. code-block:: php
   :linenos:

    // setting the controller and action name as title segments:
   $request = Zend_Controller_Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // setting the site in the title; possibly in the layout script:
   $this->headTitle('Zend Framework');

   // setting a separator string for segments:
   $this->headTitle()->setSeparator(' / ');


ברגע שהינך מוכן להציג את הכותרת בתבנית התצוגה, פשוט יש להדפיס
את התוסף:

.. code-block:: php
   :linenos:

   <!-- renders <action> / <controller> / Zend Framework -->
   <?= $this->headTitle() ?>



