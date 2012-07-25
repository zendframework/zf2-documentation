.. _zend.captcha.operation:

פעולת אנטי-ספאם
===============

כל האובייקטים המוחשיים של CAPTCHA מיישמים את *Zend_Captcha_Adapter*, שנראה
ככה:

.. code-block:: php
   :linenos:

   interface Zend_Captcha_Adapter extends Zend_Validate_Interface
   {
       public function generate();

       public function render(Zend_View $view, $element = null);

       public function setName($name);

       public function getName();

       public function getDecorator();

       // Additionally, to satisfy Zend_Validate_Interface:
       public function isValid($value);

       public function getMessages();

       public function getErrors();
   }


מתודות ה *setName()* ו *getName()* נועדו להגדיר ולהחזיר את המזהה היחודי של
ה captcha. *getDecorator()* יכול לשמש בתור שימוש באובייקט עיצוב של Zend_Form,
בין אם זה על ידי הזנת השם או החזרת האובייקט של העיצוב עצמו. כל
העבודה החשובה נעשית אבל במתודת *generate()* ו *render()*. *generate()* נועד כדי
ליצור את המפתח היחודי ל captcha. תהליך זה בדרך כלל ישמור את הזהה
היחודי הזה ב session או בכל מקום אחר שתוכלו לאחר מכן להשוות מולו.
*render()* נועד להציג את המידע אשר יאמת את הפרטים מול המזהה היחודי
שנשמר קודם לכן, בין אם זה הצגת תמונה, טקסט רנדומלי או בעיה לוגית
כלשהי.

דוגמא לשימוש סטנדרטי נראה כך:

.. code-block:: php
   :linenos:

   // Creating a Zend_View instance
   $view = new Zend_View();

   // Originating request:
   $captcha = new Zend_Captcha_Figlet(array(
       'name' => 'foo',
       'wordLen' => 6,
       'timeout' => 300,
   ));
   $id = $captcha->generate();
   echo $captcha->render($view);

   // On subsequent request:
   // Assume captcha setup as before, and $value is the submitted value:
   if ($captcha->isValid($_POST['foo'], $_POST)) {
       // Validated!
   }



