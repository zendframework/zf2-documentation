.. _zend.validate.validator_chains:

שרשור פונקציות אימות
====================

לפעמים יהיה צורך בלבצע מספר בדיקות ואימותים שונים על אותו ערך
בסדר מסויים. הדוגמא הבאה מציגה כיצד לפתור את הבעיה אשר מוצגת
:ref:`בהקדמה <zend.validate.introduction>`, איפה ששם המשתמש צריך להיות בין 6 ל 12
תווים ובאותיות בלבד:

   .. code-block::
      :linenos:

      // Create a validator chain and add validators to it
      $validatorChain = new Zend_Validate();
      $validatorChain->addValidator(new Zend_Validate_StringLength(6, 12))
                     ->addValidator(new Zend_Validate_Alnum());

      // Validate the username
      if ($validatorChain->isValid($username)) {
          // username passed validation
      } else {
          // username failed validation; print reasons
          foreach ($validatorChain->getMessages() as $message) {
              echo "$message\n";
          }
      }


הפונקציות מורצות בסדר בהם הם מתווספות ל *Zend_Validate*. בדוגמא למעלה,
שם המשתמש קודם נבדדק שהוא בין 6 ל 12 תווים, ואז הוא נבדק כדי
לוודאות שהוא מכיל רק אותיות ומספרים. הבדיקה השנייה תמיד תרוץ,
גם אם שם המשתמש הוא לא בטווח של 6 עד 12 והבדיקה הראשונה תחזיר
שגיאה הבדיקה השנייה תרוץ גם כן ובמידה והיא גם תחזיר פסוק שקר גם
היא תחזיר שגיאה, לאחר מכן במידה ושני הבדיקות נכשלו *getMessages()*
יחזיר את הודעות השגיאה משני הבדיקות.

בחלק מהמקרים זה הגיוני לשבור את שרשרת הבדיקות במידה ואחת
מהבדיקות מחזירה פסוק שקר. *Zend_Validate* תומכת בסוג פעולה זה על ידי
הוספת פרמטר שני למתודת *addValidator()*. על ידי הצבת ערך *true* לפרמטר
השני שהוא בעצם *$breakChainOnFailure* הבדיקה שנוספה תשבור את השרשרת במידה
והיא תחזיר פסוק שקר אשר יעצרו וימנעו מהרצה של פונקציות בדיקה
נוספות שבאות לאחר מכן. אם הדוגמא למעלה הייתה כתובה כך, אז הבדיקה
של אימות שם המשתמש שהוא אותיות ומספרים בלבד לא הייתה מתבצעת
במידה והבדיקה הראשונה תחזיר פסוק שקר:

   .. code-block::
      :linenos:

      $validatorChain->addValidator(new Zend_Validate_StringLength(6, 12), true)
              ->addValidator(new Zend_Validate_Alnum());




כל אובייקט אשר מיישם את *Zend_Validate_Interface* יכול להתקיים בתור שרשרת
האימות.


