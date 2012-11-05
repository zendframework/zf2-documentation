.. EN-Revision: none
.. _zend.server.introduction:

הקדמה
=====

משפחת המחלקות של *Zend_Server* מאפשרות שימוש במספר מחלקות שרתיות
שונות, הכוללות *Zend\XmlRpc\Server*, *Zend\Rest\Server*, *Zend\Json\Server* u *Zend\Soap\Wsdl*.
*Zend\Server\Interface* מספקת ממשק אשר מדמה את מחלקת ה *SoapServer* ב PHP 5. כל
מחלקות השרת השונות צריכות להשתמש בממשק זה כדי להשתמש ב API
הסטנדרטי.

*Zend\Server\Reflection* מספק מנגנון שליטה ובקרה בבחינה עצמית של מחלקות
ופונקציות עם המחלקות של השרת, ומספק מידע המתאים לשימוש בעזרת
המתודות *getFunctions()* *loadFunctions()* של המחלקה *Zend\Server\Interface*.


