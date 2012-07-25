.. _zend.filter.writing_filters:

כתיבת פילטרים
=============

Zend_Filter מספק כמה פילטרים שימושיים ונפוצים, אבל לעיתים מתכנתים
ירצו לכתוב פילטרים בעצמם לדרישות שלהם. כדי ליצור פילטר חדש וכדי
להשתמש בו לאחר מכן בשרשור הפילטרים יש ליצור מחלקה אשר תיישם את
*Zend_Filter_Interface*./

*Zend_Filter_Interface* מגדירה מתודה אחת בלבדף *filter()*, אשר ניתן לכלול אותה
במחלקות שונות. אובייקט שמיישם את הממשק, ניתן יהיה להוסיף אותו
לשרשרת הפילטרים בעזרת *Zend_Filter::addFilter()*.

הדוגמא הבאה מציגה כיצד ניתן לכתוב פילטר בעצמכם:

   .. code-block:: php
      :linenos:

      class MyFilter implements Zend_Filter_Interface
      {
          public function filter($value)
          {
              // perform some transformation upon $value to arrive on $valueFiltered

              return $valueFiltered;
          }
      }




כדי להוסיף את הפילטר שנכתב מעלה לשרשרת הפילטרים ניתן לבצע זאת
בעזרת:

   .. code-block:: php
      :linenos:

      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new MyFilter());





