.. EN-Revision: none
.. _zend.feed.findFeeds:

קבלת קישורי סנדקציה מאתרים
==========================

מרבית האתרים כיום מכילים תגי *<link>* אשר מכוונים לסנדצקיות עם
תוכן רלוונטי לאותו עמוד. *Zend_Feed* מאפשר לך לקבל את כל הסנדקציות
אשר נמצאות בעמוד מרוחק על ידי שימוש במתודה אחת פשוטה:

.. code-block:: php
   :linenos:

   $feedArray = Zend\Feed\Feed::findFeeds('http://www.example.com/news.html');


בדוגמא למעלה *findFeeds()* מחזיר מערך עם אובייקטים שך *Zend\Feed\Abstract* אשר
מכוונים לתגי *<link>* אשר נמצאים בעמוד news.html. תלוי בסוג של כל
סנדקציה, כל אלמנט במערך ה *$feedArray* יכול להיות אובייקט של *Zend\Feed\Rss*
או *Zend\Feed\Atom*. *Zend_Feed* יזרוק *Zend\Feed\Exception* במידה ותכשל הפעולה, כמו HTTP
404 או סנדקציה שהיא לא כתובה כראוי.


