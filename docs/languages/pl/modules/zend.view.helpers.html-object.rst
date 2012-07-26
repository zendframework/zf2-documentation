.. _zend.view.helpers.initial.object:

Helpery HTML Object
===================

Element HTML *<object>* używany jest do wstawiania do kodu strony takich elementów interaktywnych jak Flash czy
QuickTime. Helpery te pozwalają na łatwe wstawianie tych obiektów.

Obecnie dostępne są cztery helpery Object:

- *formFlash* Generuje kod do wstawiania plików Flash.

- *formObject* Generuje kod do wstawiania własnego obiektu

- *formPage* Generuje kod do wstawiania innych stron (X)HTML.

- *formQuicktime* Generuje kod do wstawiania plików QuickTime.

Wszystkie te helpery mają podobny interfejs. Z tego powodu w dokumentacji pokażemy przykłady tylko dwóch z
nich.

.. _zend.view.helpers.initial.object.flash:

.. rubric:: Helper Flash

Dołączanie plików Flash do twojej strony jest bardzo łatwe. Jedynym wymaganym argumentem jest adres URI pliku.

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>


Wyświetli to następujący kod HTML:

.. code-block:: php
   :linenos:

   <object data="/path/to/flash.swf"
           type="application/x-shockwave-flash"
           classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
           codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>


Dodatkowo możesz określić atrybuty, parametry i zawartość jaka ma być zrenderowana wraz z obiektem
*<object>*. Zostanie do zademonstrowane za pomocą helpera *htmlObject*.

.. _zend.view.helpers.initial.object.object:

.. rubric:: Konfigurowanie obiektu poprzez przekazanie dodatkowych argumentów

Pierwszy argument w helperze jest zawsze wymagany. Określa on adres URL zasobu, który chcesz dołączyć do
dokumentu (X)HTML. Drugi argument jest wymagany tylko w helperze *htmlObject*. Inne helpery posiadają poprawną
domyślną wartość dla tego argumentu. Trzeci argument jest używany do przekazywania atrybutów do obiektu
elementu. Akceptuje on tablicę par klucz-wartość. Przykładem mogą być atrybuty *classid* oraz *codebase*.
Czwarty argument przyjmuje także tylko tablice elementów w postaci klucz-wartość i używa ich do elementów
*<param>*. Ostatni argument umożliwia przekazanie dodatkowej zawartości do obiektu. Zobacz przykład używający
wszystkich argumentów.

.. code-block:: php
   :linenos:

   echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   );

   /*
   Spowoduje to wyświetlenie:

   <object data="/path/to/file.ext" type="mime/type"
       attr1="aval1" attr2="aval2">
       <param name="param1" value="pval1" />
       <param name="param2" value="pval2" />
       some content
   </object>
   */



