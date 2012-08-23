.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

צריכת ערך סנדקציה בודד
======================

אלמנטים של סנדקצית אטום בודדת *<entry>* הם גם תקינים בפני עצמם. בדרך
כלל הקישור לערך בודד הוא הקישור לכל הסנדקציה ולאחר מכן */<entryId>*
שמהווה בעצם מספר רשומה, כמו למשל *http://atom.example.com/feed/1*.

אם הנכם קוראים ערך בודד, עדיין יווצר אובייקט *Zend_Feed_Atom* חדש, אבל
הוא יצור אוטומטית פיד אנונימי כדי להכיל את הערך שנלקח.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: קריאת ערך סנדקציה בודד

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'The feed has: ' . $feed->count() . ' entry.';

   $entry = $feed->current();


לחלופין, תוכלו להכווין את האובייקט ישירות לערך הבודד על ידי
הזנת קישור ישיר לאותו ערך:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: שימוש באובייקט סנדקציה ישירות לערך סנדקציה בודד

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();



