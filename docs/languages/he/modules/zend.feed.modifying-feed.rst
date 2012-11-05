.. EN-Revision: none
.. _zend.feed.modifying-feed:

עריכה של תבנית הסנדקציה
=======================

התחביר הטבעי של *Zend_Feed* ניתן להרחבה כדי לבנות ולערוך סנדצקיות
ופריטים באותו אופן שהוא קורא אותם. ניתן להמיר את האובייקטים
החדשים שנוצרו או הקיימים שנערכו בחזרה לפורמט XML תקין לשמירה אל
קובץ או לשליחה לשרת.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: עריכה של פריט בסנדקציה

.. code-block:: php
   :linenos:

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'This is a new title';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();


הקוד למעלה ידפיס תוכן XML מלא עם הפריט החדש שנוסף, הכולל גם את כל
התגים הדרושים של קובץ XML.

יש לדעת שהקוד למעלה יעבוד גם אם לפריט אין ערך של "עורך". ניתן
להשתמש בכמה רמות של *->* לגישה את האלמנט הרצוי; כל הרמות הלא
קיימות יווצרו במידה וצריך.

אם הנכם צריכים להשתמש בסוג אחר של סנדקציה מלבד *atom:*, *rss:*, *osrss:*
יהיה עליכם לרשום אותו קודם למחלקה *Zend_Feed* על ידי שימוש ב
*Zend\Feed\Feed::registerNamespace()*. אם הנך עורך אלמנט קיים הוא תמיד ישמור את הסוג
שלו. כשהנך מוסיף אלמנט, הוא יוסיף אותו לסוג ברירת המחדל של
הסנדקציה אלה אם כן תגדיר את זה אחרת.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: יצירת אלמנטים לסנדקציה עם סוג מותאם אישית

.. code-block:: php
   :linenos:

   $entry = new Zend\Feed_Entry\Atom();
   // id is always assigned by the server in Atom
   $entry->title = 'my custom entry';
   $entry->author->name = 'Example Author';
   $entry->author->email = 'me@example.com';

   // Now do the custom part.
   Zend\Feed\Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'my first custom value';
   $entry->{'myns:container_elt'}->part1 = 'first nested custom part';
   $entry->{'myns:container_elt'}->part2 = 'second nested custom part';

   echo $entry->saveXML();



