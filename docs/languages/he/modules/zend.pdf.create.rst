.. _zend.pdf.create:

יצירת וטעינת קבצי PDF
=====================

מחלקת ה *Zend_Pdf* מייצגת את מסמכי ה PDF ומספקת פעולת אשר קשורות
למסמכים.

כדי ליצור מסמך חדש, יש ליצור קודם כל אובייקט *Zend_Pdf* חדש.

*Zend_Pdf* גם מספקת שני מתודות סטטיות לטעינה של קובץ PDF קיים. אלו הם
המתודות *Zend_Pdf::load()* ו *Zend_Pdf::parse()*. שניהם מחזירות אובייקט *Zend_Pdf*
כתוצאה או זורקות שגיאת חריג במידה וישנה שגיאה.

.. _zend.pdf.create.example-1:

.. rubric:: יצירת קובץ PDF חדש או טעינה של אחד קיים

.. code-block::
   :linenos:

   ...
   // Create a new PDF document
   $pdf1 = new Zend_Pdf();

   // Load a PDF document from a file
   $pdf2 = Zend_Pdf::load($fileName);

   // Load a PDF document from a string
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...


קבצי ה PDF תומכים בעדכוני מסמכים. לכן בכל פעם שמסמך מעודכן גרסא
חדשה שלו נוצרת. *Zend_Pdf* מאפשר קבלת המסמך בגרסא מסויימת שלו.

ניתן להגדיר את הגרסא כפרמטר שני במתודות *Zend_Pdf::load()* ו *Zend_Pdf::parse()*
או על ידי קריאה למתודה *Zend_Pdf::rollback()*. [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: קבלת גרסא מסויימת של קובץ PDF

.. code-block::
   :linenos:

   ...
   // Load the previous revision of the PDF document
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Load the previous revision of the PDF document
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Load the first revision of the PDF document
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...




.. [#] *Zend_Pdf::rollback()* חייבת להקרא לפני כל שינוי שנעשה במסמך, אחרת
       צורת ההתנהגות של המתודה לא מוגדרת.