.. EN-Revision: none
.. _zend.service.recaptcha:

Zend_Service_ReCaptcha
======================

.. _zend.service.recaptcha.introduction:

הקדמה
-----

*Zend_Service_ReCaptcha* מספק תמיכה בשירות ה `reCAPTCHA`_. כפי שמוסבר באתר reCAPTCHA,
"reCAPTCHA הינו שירות ווב חינמי אשר מציג מילים מתוך ספרות למניעת
ספאם ושימוש של האתר והתוכן בצורה לא חוקית ולמטרת ספאם.". כל reCAPTCHA
דורש מהמשתמש להזין שתי מילים, המילה הראשונה היא בעצם ה captcha
עצמה, והשנייה היא טקסט כלשהו שנסרק אשר מונע מתוכנת OCR לנסות
ולפענח אותו. ההשערה היא שבמידה והמילה הראשונה הוזנה כפי שצריך
רוב הסיכויים שגם השנייה תיהיה נכונה.

כדי להשתמש בשירות של reCAPTCHA, תצטרך `להרשם`_ לשירות ולהוסיף דומיין
אחד או יותר כדי לקבל מפתחות זיהוי.

.. _zend.service.recaptcha.simplestuse:

שימוש בסיסי
-----------

יצירת אובייקט *Zend_Service_ReCaptcha* חדש עם העברת המפתחות שלכם בתור
פרמטרים:

.. code-block:: php
   :linenos:

   $recaptcha = new Zend_Service_ReCaptcha($pubKey, $privKey);


כדי להציג את הטקסט יש להשתמש במתודה *getHTML()*:

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();


כשהטופס נשלח, אתם תקבלו שני שדות, 'recaptcha_challenge_field' ו
'recaptcha_response_field'. העבירו את שני השדות למתודה *verify()*:

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );


ברגע שיש לכם את התוצאה מהמתודה, בדקו זאת אם היא תקינה. התוצאה
הינה אובייקט של *Zend_Service_ReCaptcha_Response*, אשר מספק מתודה *isValid()*.

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // Failed validation
   }


יותר פשוט יהיה להשתמש במתאם :ref:`ReCaptcha <zend.captcha.adapters.recaptcha>`
*Zend_Captcha*, או להשתמש במתאם בתור בסיס ל :ref:`אלמנט טפסים
<zend.form.standardElements.captcha>`. במקרה הזה, הפרטים של התצוגה והאימות מול
reCAPTCHA נעשים אוטומטית.



.. _`reCAPTCHA`: http://recaptcha.net/
.. _`להרשם`: http://recaptcha.net/whyrecaptcha.html
