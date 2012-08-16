.. EN-Revision: none
.. _zend.server.introduction:

הקדמה
=====

משפחת המחלקות של *Zend_Server* מאפשרות שימוש במספר מחלקות שרתיות
שונות, הכוללות *Zend_XmlRpc_Server*, *Zend_Rest_Server*, *Zend_Json_Server* u *Zend_Soap_Wsdl*.
*Zend_Server_Interface* מספקת ממשק אשר מדמה את מחלקת ה *SoapServer* ב PHP 5. כל
מחלקות השרת השונות צריכות להשתמש בממשק זה כדי להשתמש ב API
הסטנדרטי.

*Zend_Server_Reflection* מספק מנגנון שליטה ובקרה בבחינה עצמית של מחלקות
ופונקציות עם המחלקות של השרת, ומספק מידע המתאים לשימוש בעזרת
המתודות *getFunctions()* *loadFunctions()* של המחלקה *Zend_Server_Interface*.


