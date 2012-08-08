.. EN-Revision: none
.. _zend.filter.filter_chains:

שרשור פילטרים
=============

לעיתים קרובות יהיה צורך בשימוש בכמה פילטרים על ערך כלשהו בסדר
כלשהו. לדוגמא טופס התחברות מאפשר הזנת שם משתמש שצריך להיות
באותיות בלבד וכל האותיות צריכות להיות קטנות. *Zend_Filter* מאפשר
שימוש בשרשור מתודות בצורה קלה ויעילה. הדוגמא הבאה מציגה כיצד
ניתן לשרשר פילטרים בתור מתודות על השם משתמש שהוזן בטופס
התחברות:

   .. code-block:: php
      :linenos:

      <// Create a filter chain and add filters to the chain
      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new Zend_Filter_Alpha())
                  ->addFilter(new Zend_Filter_StringToLower());

      // Filter the username
      $username = $filterChain->filter($_POST['username']);


פילטרים מורצים בסדר בהם הם נופסים ל *Zend_Filter*. בדוגמא למעלה, כל מה
שלא אותיות ומספרים מערך של השם משתמש בטופס ההתחברות מוסר, ורק
לאחר מכן כל אותיות גדולות הופכות לקטנות.

כל אובייקט אשר משתמש ב *Zend_Filter_Interface* ניתן להשתמש בו בשרשור
פילטרים.


