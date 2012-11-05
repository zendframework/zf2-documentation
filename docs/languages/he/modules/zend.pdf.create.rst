.. EN-Revision: none
.. _zend.pdf.create:

יצירת וטעינת קבצי PDF
=====================

מחלקת ה *ZendPdf* מייצגת את מסמכי ה PDF ומספקת פעולת אשר קשורות
למסמכים.

כדי ליצור מסמך חדש, יש ליצור קודם כל אובייקט *ZendPdf* חדש.

*ZendPdf* גם מספקת שני מתודות סטטיות לטעינה של קובץ PDF קיים. אלו הם
המתודות *ZendPdf\Pdf::load()* ו *ZendPdf\Pdf::parse()*. שניהם מחזירות אובייקט *ZendPdf*
כתוצאה או זורקות שגיאת חריג במידה וישנה שגיאה.

.. _zend.pdf.create.example-1:

.. rubric:: יצירת קובץ PDF חדש או טעינה של אחד קיים

.. code-block:: php
   :linenos:

   ...
   // Create a new PDF document
   $pdf1 = new ZendPdf\Pdf();

   // Load a PDF document from a file
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // Load a PDF document from a string
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...


קבצי ה PDF תומכים בעדכוני מסמכים. לכן בכל פעם שמסמך מעודכן גרסא
חדשה שלו נוצרת. *ZendPdf* מאפשר קבלת המסמך בגרסא מסויימת שלו.

ניתן להגדיר את הגרסא כפרמטר שני במתודות *ZendPdf\Pdf::load()* ו *ZendPdf\Pdf::parse()*
או על ידי קריאה למתודה *ZendPdf\Pdf::rollback()*. [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: קבלת גרסא מסויימת של קובץ PDF

.. code-block:: php
   :linenos:

   ...
   // Load the previous revision of the PDF document
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // Load the previous revision of the PDF document
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // Load the first revision of the PDF document
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...




.. [#] *ZendPdf\Pdf::rollback()* חייבת להקרא לפני כל שינוי שנעשה במסמך, אחרת
       צורת ההתנהגות של המתודה לא מוגדרת.