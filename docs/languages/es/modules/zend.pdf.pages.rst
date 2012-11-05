.. EN-Revision: none
.. _zend.pdf.pages:

Trabajando con Páginas
======================

.. _zend.pdf.pages.creation:

Creación de Páginas
-------------------

Las páginas en un documento *PDF* están representadas como instancias ``ZendPdf\Page`` en ``ZendPdf``.

Las páginas *PDF* o bien son cargadas desde una *PDF* ya existente o creadas usando la *API* ``ZendPdf``.

Se pueden crear nuevas páginas instanciando directamente al objeto ``ZendPdf\Page`` o llamando al método
``ZendPdf\Pdf::newPage()``, que devuelve un objeto ``ZendPdf\Page``. ``ZendPdf\Pdf::newPage()`` crea una página que ya
está agregada a un documento. Las páginas no agregadas no pueden ser utilizadas con múltiples documentos *PDF*,
pero son algo más eficientes. [#]_

El método ``ZendPdf\Pdf::newPage()`` y el constructor ``ZendPdf\Page`` toman los mismos parámetros que especifican
el tamaño de la página. Pueden tomar el tamaño de la página ($x, $y) en puntos (1/72 pulgadas) o una constante
predefinida representando un tipo de página:

   - ZendPdf\Page::SIZE_A4

   - ``ZendPdf\Page::SIZE_A4_LANDSCAPE``

   - ``ZendPdf\Page::SIZE_LETTER``

   - ``ZendPdf\Page::SIZE_LETTER_LANDSCAPE``



Las páginas del documento se almacenados en el atributo público ``$pages`` de la clase ``ZendPdf``. El atributo
posee un array de objetos ``ZendPdf\Page`` y define completamente las instancias y el orden de las páginas. Este
array puede manipularse como cualquie otro array *PHP*:

.. _zend.pdf.pages.example-1:

.. rubric:: Administración de Páginas de un Documento PDF

.. code-block:: php
   :linenos:

   ...
   // Invertir el orden de las páginas.
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Agregar una nueva página.
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Page::SIZE_A4);
   // Agregar una nueva página.
   $pdf->pages[] = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   // Eliminar la página especificada.
   unset($pdf->pages[$id]);

   ...

.. _zend.pdf.pages.cloning:

Clonado de Páginas
------------------

La página *PDF* existente puede ser clonada creando un nuevo objeto ``ZendPdf\Page`` con una página existente
como parámetro:

.. _zend.pdf.pages.example-2:

.. rubric:: Clonando una Página Existente

.. code-block:: php
   :linenos:

   ...
   // Almacenar la página plantilla en una variable
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Agregar una nueva página.
   $page1 = new ZendPdf\Page($template);
   $pdf->pages[] = $page1;
   ...

   // Agregar otra página.
   $page2 = new ZendPdf\Page($template);
   $pdf->pages[] = $page2;
   ...

   // Eliminar la página fuente de la plantilla de los documentos.
   unset($pdf->pages[$templatePageIndex]);

   ...

Es útil si necesita crear varias páginas utilizando una plantilla.

.. caution::

   Importante! La página clonada comparte algunos recursos de *PDF* con una página plantilla, la que puede ser
   utilizada sólo en el mismo documento como una página plantilla. El documento modificado pueden guardarse como
   uno nuevo.



.. [#] Es una limitación de la versión actual de Zend Framework. Será eliminada en futuras versiones. Pero las
       páginas no agregadas siempre dan mejor resultado (más óptimo) para compartir páginas entre los
       documentos.