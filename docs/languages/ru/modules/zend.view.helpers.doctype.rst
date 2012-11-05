.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

Помощник Doctype
================

Валидные HTML- и XHTML-документы должны включать в себя декларацию
*DOCTYPE*. Написание этих деклараций сложно для запоминания, кроме
того, от выбранного типа документа зависит то, как должны
выводиться элементы в вашем документе (например,
экранирование через CDATA в элементах *<script>* и *<style>*).

Помощник *Doctype* позволяет указать один из следующих типов:

- *XHTML11*

- *XHTML1_STRICT*

- *XHTML1_TRANSITIONAL*

- *XHTML1_FRAMESET*

- *XHTML_BASIC1*

- *HTML4_STRICT*

- *HTML4_LOOSE*

- *HTML4_FRAMESET*

- *HTML5*

Вы можете также определить любой другой тип, если он является
синтаксически корректным.

Помощник *Doctype* является частной реализацией :ref:`помощника
Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Использование помощника Doctype

Вы можете указать декларацию DOCTYPE в любой момент времени. Но
помощники, использующие эту декларацию при формированиии
вывода, увидят ее только после того, как она была определена.
Поэтому лучше всего указывать ее в вашем файле загрузки:

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View_Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

И затем выводить ее в самом начале вашего скрипта вида:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: Извлечение DOCTYPE

Если нужно узнать тип документа, то вы можете сделать это путем
вызова метода *getDoctype()* объекта, возвращаемого при вызове
помощника.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();

Часто требуется только узнать, соответствует ли декларация
языку XHTML или нет. В этом случае метода *isXhtml()* будет достаточно:

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // сделать что-то
   }


