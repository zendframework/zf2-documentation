.. EN-Revision: none
.. _zend.feed.custom-feed:

מחלקות סנדקציה מותאמות אישית
============================

לבסוף, ניתן להרחיב את מחלקות ה *Zend_Feed* אם תרצה להזין ולספק פורמט
מותאם אישית שלך, או להוסיף פונקציונליות מדוייקת יותר לניהול
ותפעול של אלמנטים.

הנה דוגמא למחלקה מותאמת אישית לניהול תגי Atom אשר מטפלת בתגיות
*myns:* בעצמה. דע שזה גם מבצע את הקריאה אל *registerNamespace()*, כדי שהמשתמש
הסופי לא יצטרך לדאוג לגבי שם התגית הזאת.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: הרחבת מחלקת ניהול הסנדקציה של Atom

.. code-block:: php
   :linenos:

   /**
    * The custom entry class automatically knows the feed URI (optional) and
    * can automatically add extra namespaces.
    */
   class MyEntry extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend_Feed::registerNamespace('myns',
                                        'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   parent::__set('myns:updated', $value);
                   break;

               default:
                   parent::__set($var, $value);
           }
       }

       public function __call($var, $unused)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }


אז כדי להשתמש במחלקה זו, יהיה צורך רק בליצור אובייקט שלה ולקרוא
לערך *myUpdated*:

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // method-style call is handled by __call function
   $entry->myUpdated();
   // property-style call is handled by __get function
   $entry->myUpdated;



