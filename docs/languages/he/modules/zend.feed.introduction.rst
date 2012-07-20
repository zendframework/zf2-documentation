.. _zend.feed.introduction:

הקדמה
=====

*Zend_Feed* מספק פונקציונליות לצריכת סנדקציה של RSS ו Atom. היא מספקת
תחביר טבעי לגישה לאלמנטים בתוך הסנדקציה, ערכי סנדקציה, וערכי
ערכים מסויימים. *Zend_Feed* מאפשר תמיכה רחבה לעריכה של מבנה הסנדקציה
והערכים עם אותו התחביר הטבעי, והמרת התוצאה בחזרה ל XML.

טכנית, *Zend_Feed* מכיל מחלקת בסיס *Zend_Feed*, מחלקות לא מוחשיות
*Zend_Feed_Abstract* ו *Zend_Feed_Entry_Abstract* אשר מייצגים סנדצקיות ורשומות,
הטמעות ספצפיות לסנדצקיות של RSS ו Atom, ותוספי עזרה אשר עושים את
העבודה מאחורי הקלעים.

בדוגמא למטה, אנחנו מדגימים שימוש פשוט בקבלת סנדקצית RSS ושמירה
של חלק ממנה אל מערך ב PHP, שלאחר מכן יהיה ניתן להדפיסו, שמירה במסד
הנתונים וכדומה.

.. note::

   **תהיו מודעים**

   סנדצקיות רבות מכילות ערוצים שונים וערכים שונים. המפרט של RSS
   מספק הרבה ערכים אופציונלים, אז יש להיות מודעים על כך ברגע
   שכותבים קוד אשר יעבוד עם תוכן RSS.

.. _zend.feed.introduction.example.rss:

.. rubric:: שימוש ב *Zend_Feed* על מידע מ RSS

.. code-block::
   :linenos:

   // Fetch the latest Slashdot headlines
   try {
       $slashdotRss =
           Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // feed import failed
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // Initialize the channel data array
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Loop over each channel item and store relevant data
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }



