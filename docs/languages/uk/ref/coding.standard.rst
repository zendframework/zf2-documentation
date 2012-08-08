.. EN-Revision: none
.. _coding-standard:

********************************************
Стандарт написання PHP коду в Zend Framework
********************************************

.. _coding-standard.overview:

Огляд
-----

.. _coding-standard.overview.scope:

Сфера застосування
^^^^^^^^^^^^^^^^^^

Цей документ надає вказівки щодо форматування коду та
документації для розробників та команд які роблять свій вклад
в розробку Zend Framework. Багато розробників що використовують Zend
Framework також знаходять корисним слідувати цим стандартам щоб
писати свій код у відповідності до всього коду Zend Framework. Варто
зазначити що докладено великих зусиль щоб як найбільш повно
описати стандарти кодування.

   .. note::

      Примітка: Sometimes developers consider the establishment of a standard more important than what that
      standard actually suggests at the most detailed level of design. Інколи розробники
      надають впровадженню стандарту важливішого значення ніж
      те, що стандарт дійсно пропонує, на найбільш деталізованому
      рівні розробки. Вказівки в стандартах кодування Zend Framework
      захоплюють практичні підходи що добре себе
      зарекомендували в проекті розробки Zend Framework. Дозволяється
      модифікувати ці стандарти або використовувати їх в
      незмінному стані у відповідності до положень нашої
      `ліцензії`_.

Теми що висвітлюються в стандартах кодування Zend Framework
включають:



   - Форматування *PHP* файлів

   - Принципи іменування

   - Стиль написання коду

   - Вбудована документація



.. _coding-standard.overview.goals:

Цілі
^^^^

Дотримання стандартів написання коду є важливим для будь
якого проекту, зокрема коли над одним проектом працюють кілька
розробників. Стандарти написання коду забезпечують високу
якість, меншу кількість помилок, та легкий супровід коду.

.. _coding-standard.php-file-formatting:

Форматування PHP файлів
-----------------------

.. _coding-standard.php-file-formatting.general:

Загальні положення
^^^^^^^^^^^^^^^^^^

Заборонено ставити закриваючий тег ("?>") для файлів що містять
виключно *PHP* код. Закриваючий тег необов'язковий для *PHP*, та
його відсутність допомагає уникнути випадкового попадання у
відповідь сервера пробілу що опинився в кінці файлу.

.. note::

   **Важливо**: Включення додаткового бінарного коду як це
   дозволено при використанні *__HALT_COMPILER()* заборонено для всіх
   *PHP* файлів в проекті Zend framework та похідних файлах. Використання
   такої можливості дозволено лише для деяких сценаріїв
   встановлення.

.. _coding-standard.php-file-formatting.indentation:

Відступи
^^^^^^^^

Використовувати відступ в 4 пробіли, без табуляції.

.. _coding-standard.php-file-formatting.max-line-length:

Максимальна довжина рядка
^^^^^^^^^^^^^^^^^^^^^^^^^

Дотримуватися довжини рядка в 80 символів, тобто розробники
повинні намагатись тримати код настільки близько до 80-ої
колонки наскільки це практично можливо. Проте, довші рядки
дозволені. Максимальна довжина будь-якого рядка *PHP* коду не
повинна перевищувати 120 символів.

.. _coding-standard.php-file-formatting.line-termination:

Завершення рядків
^^^^^^^^^^^^^^^^^

Завершення рядка в стандартний спосіб для текстових файлів Unix.
Рядки повинні завершуватися через переведення рядка (LF).
Переведення рядка представлено десятковим кодом 10, та
шістнадцятковим 0x0A.

Примітка: Не використовувати повернення каретки (CR) у
відповідності до ОС Apple (0x0D) або комбінацію повернення каретки -
переведення рядка (CRLF) що є стандартом для ОС Windows (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Принципи іменування
-------------------

.. _coding-standard.naming-conventions.classes:

Класи
^^^^^

Zend Framework standardizes on a class naming convention whereby the names of the classes directly map to the
directories in which they are stored. The root level directory of Zend Framework's standard library is the "Zend/"
directory, whereas the root level directory of Zend Framework's extras library is the "ZendX/" directory. All Zend
Framework classes are stored hierarchically under these root directories..

Class names may only contain alphanumeric characters. Numbers are permitted in class names but are discouraged in
most cases. Underscores are only permitted in place of the path separator; the filename "``Zend/Db/Table.php``"
must map to the class name "``Zend_Db_Table``".

If a class name is comprised of more than one word, the first letter of each new word must be capitalized.
Successive capitalized letters are not allowed, e.g. a class "Zend_PDF" is not allowed while "``Zend_Pdf``" is
acceptable.

These conventions define a pseudo-namespace mechanism for Zend Framework. Zend Framework will adopt the *PHP*
namespace feature when it becomes available and is feasible for our developers to use in their applications.

See the class names in the standard and extras libraries for examples of this classname convention.

.. note::

   **Important**: Code that must be deployed alongside Zend Framework libraries but is not part of the standard or
   extras libraries (e.g. application code or libraries that are not distributed by Zend) must never start with
   "Zend\_" or "ZendX\_".

.. _coding-standard.naming-conventions.abstracts:

Abstract Classes
^^^^^^^^^^^^^^^^

In general, abstract classes follow the same conventions as :ref:`classes
<coding-standard.naming-conventions.classes>`, with one additional rule: abstract class names must end in the term,
"Abstract", and that term must not be preceded by an underscore. As an example, ``Zend_Controller_Plugin_Abstract``
is considered an invalid name, but ``Zend_Controller_PluginAbstract`` or ``Zend_Controller_Plugin_PluginAbstract``
would be valid names.

.. note::

   This naming convention is new with version 1.9.0 of Zend Framework. Classes that pre-date that version may not
   follow this rule, but will be renamed in the future in order to comply.

.. _coding-standard.naming-conventions.interfaces:

Interfaces
^^^^^^^^^^

In general, interfaces follow the same conventions as :ref:`classes <coding-standard.naming-conventions.classes>`,
with one additional rule: interface names may optionally end in the term, "Interface", but that term must not be
preceded by an underscore. As an example, ``Zend_Controller_Plugin_Interface`` is considered an invalid name, but
``Zend_Controller_PluginInterface`` or ``Zend_Controller_Plugin_PluginInterface`` would be valid names.

While this rule is not required, it is strongly recommended, as it provides a good visual cue to developers as to
which files contain interfaces rather than classes.

.. note::

   This naming convention is new with version 1.9.0 of Zend Framework. Classes that pre-date that version may not
   follow this rule, but will be renamed in the future in order to comply.

.. _coding-standard.naming-conventions.filenames:

Filenames
^^^^^^^^^

For all other files, only alphanumeric characters, underscores, and the dash character ("-") are permitted. Spaces
are strictly prohibited.

Any file that contains *PHP* code should end with the extension "``.php``", with the notable exception of view
scripts. The following examples show acceptable filenames for Zend Framework classes:

.. code-block:: php
   :linenos:

   Zend/Db.php

   Zend/Controller/Front.php

   Zend/View/Helper/FormRadio.php

File names must map to class names as described above.

.. _coding-standard.naming-conventions.functions-and-methods:

Functions and Methods
^^^^^^^^^^^^^^^^^^^^^

Function names may only contain alphanumeric characters. Underscores are not permitted. Numbers are permitted in
function names but are discouraged in most cases.

Function names must always start with a lowercase letter. When a function name consists of more than one word, the
first letter of each new word must be capitalized. This is commonly called "camelCase" formatting.

Verbosity is generally encouraged. Function names should be as verbose as is practical to fully describe their
purpose and behavior.

These are examples of acceptable names for functions:

.. code-block:: php
   :linenos:

   filterInput()

   getElementById()

   widgetFactory()

For object-oriented programming, accessors for instance or static variables should always be prefixed with "get" or
"set". In implementing design patterns, such as the singleton or factory patterns, the name of the method should
contain the pattern name where practical to more thoroughly describe behavior.

For methods on objects that are declared with the "private" or "protected" modifier, the first character of the
method name must be an underscore. This is the only acceptable application of an underscore in a method name.
Methods declared "public" should never contain an underscore.

Functions in the global scope (a.k.a "floating functions") are permitted but discouraged in most cases. Consider
wrapping these functions in a static class.

.. _coding-standard.naming-conventions.variables:

Variables
^^^^^^^^^

Variable names may only contain alphanumeric characters. Underscores are not permitted. Numbers are permitted in
variable names but are discouraged in most cases.

For instance variables that are declared with the "private" or "protected" modifier, the first character of the
variable name must be a single underscore. This is the only acceptable application of an underscore in a variable
name. Member variables declared "public" should never start with an underscore.

As with function names (see section 3.3) variable names must always start with a lowercase letter and follow the
"camelCaps" capitalization convention.

Verbosity is generally encouraged. Variables should always be as verbose as practical to describe the data that the
developer intends to store in them. Terse variable names such as "``$i``" and "``$n``" are discouraged for all but
the smallest loop contexts. If a loop contains more than 20 lines of code, the index variables should have more
descriptive names.

.. _coding-standard.naming-conventions.constants:

Constants
^^^^^^^^^

Constants may contain both alphanumeric characters and underscores. Numbers are permitted in constant names.

All letters used in a constant name must be capitalized, while all words in a constant name must be separated by
underscore characters.

For example, ``EMBED_SUPPRESS_EMBED_EXCEPTION`` is permitted but ``EMBED_SUPPRESSEMBEDEXCEPTION`` is not.

Constants must be defined as class members with the "const" modifier. Defining constants in the global scope with
the "define" function is permitted but strongly discouraged.

.. _coding-standard.coding-style:

Coding Style
------------

.. _coding-standard.coding-style.php-code-demarcation:

PHP Code Demarcation
^^^^^^^^^^^^^^^^^^^^

*PHP* code must always be delimited by the full-form, standard *PHP* tags:

.. code-block:: php
   :linenos:

   <?php

   ?>

Short tags are never allowed. For files containing only *PHP* code, the closing tag must always be omitted (See
:ref:`General standards <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Strings
^^^^^^^

.. _coding-standard.coding-style.strings.literals:

String Literals
^^^^^^^^^^^^^^^

When a string is literal (contains no variable substitutions), the apostrophe or "single quote" should always be
used to demarcate the string:

.. code-block:: php
   :linenos:

   $a = 'Example String';

.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

String Literals Containing Apostrophes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a literal string itself contains apostrophes, it is permitted to demarcate the string with quotation marks or
"double quotes". This is especially useful for ``SQL`` statements:

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` from `people` "
        . "WHERE `name`='Fred' OR `name`='Susan'";

This syntax is preferred over escaping apostrophes as it is much easier to read.

.. _coding-standard.coding-style.strings.variable-substitution:

Variable Substitution
^^^^^^^^^^^^^^^^^^^^^

Variable substitution is permitted using either of these forms:

.. code-block:: php
   :linenos:

   $greeting = "Hello $name, welcome back!";

   $greeting = "Hello {$name}, welcome back!";

For consistency, this form is not permitted:

.. code-block:: php
   :linenos:

   $greeting = "Hello ${name}, welcome back!";

.. _coding-standard.coding-style.strings.string-concatenation:

String Concatenation
^^^^^^^^^^^^^^^^^^^^

Strings must be concatenated using the "." operator. A space must always be added before and after the "." operator
to improve readability:

.. code-block:: php
   :linenos:

   $company = 'Zend' . ' ' . 'Technologies';

When concatenating strings with the "." operator, it is encouraged to break the statement into multiple lines to
improve readability. In these cases, each successive line should be padded with white space such that the ".";
operator is aligned under the "=" operator:

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` FROM `people` "
        . "WHERE `name` = 'Susan' "
        . "ORDER BY `name` ASC ";

.. _coding-standard.coding-style.arrays:

Arrays
^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Numerically Indexed Arrays
^^^^^^^^^^^^^^^^^^^^^^^^^^

Negative numbers are not permitted as indices.

An indexed array may start with any non-negative number, however all base indices besides 0 are discouraged.

When declaring indexed arrays with the ``Array`` function, a trailing space must be added after each comma
delimiter to improve readability:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio');

It is permitted to declare multi-line indexed arrays using the "array" construct. In this case, each successive
line must be padded with spaces such that beginning of each line is aligned:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500);

Alternately, the initial array item may begin on the following line. If so, it should be padded at one indentation
level greater than the line containing the array declaration, and all successive lines should have the same
indentation; the closing paren should be on a line by itself at the same indentation level as the line containing
the array declaration:

.. code-block:: php
   :linenos:

   $sampleArray = array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500,
   );

When using this latter declaration, we encourage using a trailing comma for the last item in the array; this
minimizes the impact of adding new items on successive lines, and helps to ensure no parse errors occur due to a
missing comma.

.. _coding-standard.coding-style.arrays.associative:

Associative Arrays
^^^^^^^^^^^^^^^^^^

When declaring associative arrays with the ``Array`` construct, breaking the statement into multiple lines is
encouraged. In this case, each successive line must be padded with white space such that both the keys and the
values are aligned:

.. code-block:: php
   :linenos:

   $sampleArray = array('firstKey'  => 'firstValue',
                        'secondKey' => 'secondValue');

Alternately, the initial array item may begin on the following line. If so, it should be padded at one indentation
level greater than the line containing the array declaration, and all successive lines should have the same
indentation; the closing paren should be on a line by itself at the same indentation level as the line containing
the array declaration. For readability, the various "=>" assignment operators should be padded such that they
align.

.. code-block:: php
   :linenos:

   $sampleArray = array(
       'firstKey'  => 'firstValue',
       'secondKey' => 'secondValue',
   );

When using this latter declaration, we encourage using a trailing comma for the last item in the array; this
minimizes the impact of adding new items on successive lines, and helps to ensure no parse errors occur due to a
missing comma.

.. _coding-standard.coding-style.classes:

Classes
^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Class Declaration
^^^^^^^^^^^^^^^^^

Classes must be named according to Zend Framework's naming conventions.

The brace should always be written on the line underneath the class name.

Every class must have a documentation block that conforms to the PHPDocumentor standard.

All code in a class must be indented with four spaces.

Only one class is permitted in each *PHP* file.

Placing additional code in class files is permitted but discouraged. In such files, two blank lines must separate
the class from any additional *PHP* code in the class file.

The following is an example of an acceptable class declaration:

.. code-block:: php
   :linenos:

   /**
    * Documentation Block Here
    */
   class SampleClass
   {
       // all contents of class
       // must be indented four spaces
   }

Classes that extend other classes or which implement interfaces should declare their dependencies on the same line
when possible.

.. code-block:: php
   :linenos:

   class SampleClass extends FooAbstract implements BarInterface
   {
   }

If as a result of such declarations, the line length exceeds the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>`, break the line before the "extends" and/or "implements"
keywords, and pad those lines by one indentation level.

.. code-block:: php
   :linenos:

   class SampleClass
       extends FooAbstract
       implements BarInterface
   {
   }

If the class implements multiple interfaces and the declaration exceeds the maximum line length, break after each
comma separating the interfaces, and indent the interface names such that they align.

.. code-block:: php
   :linenos:

   class SampleClass
       implements BarInterface,
                  BazInterface
   {
   }

.. _coding-standard.coding-style.classes.member-variables:

Class Member Variables
^^^^^^^^^^^^^^^^^^^^^^

Member variables must be named according to Zend Framework's variable naming conventions.

Any variables declared in a class must be listed at the top of the class, above the declaration of any methods.

The **var** construct is not permitted. Member variables always declare their visibility by using one of the
``private``, ``protected``, or ``public`` modifiers. Giving access to member variables directly by declaring them
as public is permitted but discouraged in favor of accessor methods (set & get).

.. _coding-standard.coding-style.functions-and-methods:

Functions and Methods
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Function and Method Declaration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Functions must be named according to Zend Framework's function naming conventions.

Methods inside classes must always declare their visibility by using one of the ``private``, ``protected``, or
``public`` modifiers.

As with classes, the brace should always be written on the line underneath the function name. Space between the
function name and the opening parenthesis for the arguments is not permitted.

Functions in the global scope are strongly discouraged.

The following is an example of an acceptable function declaration in a class:

.. code-block:: php
   :linenos:

   /**
    * Documentation Block Here
    */
   class Foo
   {
       /**
        * Documentation Block Here
        */
       public function bar()
       {
           // all contents of function
           // must be indented four spaces
       }
   }

In cases where the argument list exceeds the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>`, you may introduce line breaks. Additional arguments to the
function or method must be indented one additional level beyond the function or method declaration. A line break
should then occur before the closing argument paren, which should then be placed on the same line as the opening
brace of the function or method with one space separating the two, and at the same indentation level as the
function or method declaration. The following is an example of one such situation:

.. code-block:: php
   :linenos:

   /**
    * Documentation Block Here
    */
   class Foo
   {
       /**
        * Documentation Block Here
        */
       public function bar($arg1, $arg2, $arg3,
           $arg4, $arg5, $arg6
       ) {
           // all contents of function
           // must be indented four spaces
       }
   }

.. note::

   **Note**: Pass-by-reference is the only parameter passing mechanism permitted in a method declaration.

.. code-block:: php
   :linenos:

   /**
    * Documentation Block Here
    */
   class Foo
   {
       /**
        * Documentation Block Here
        */
       public function bar(&$baz)
       {}
   }

Call-time pass-by-reference is strictly prohibited.

The return value must not be enclosed in parentheses. This can hinder readability, in additional to breaking code
if a method is later changed to return by reference.

.. code-block:: php
   :linenos:

   /**
    * Documentation Block Here
    */
   class Foo
   {
       /**
        * WRONG
        */
       public function bar()
       {
           return($this->bar);
       }

       /**
        * RIGHT
        */
       public function bar()
       {
           return $this->bar;
       }
   }

.. _coding-standard.coding-style.functions-and-methods.usage:

Function and Method Usage
^^^^^^^^^^^^^^^^^^^^^^^^^

Function arguments should be separated by a single trailing space after the comma delimiter. The following is an
example of an acceptable invocation of a function that takes three arguments:

.. code-block:: php
   :linenos:

   threeArguments(1, 2, 3);

Call-time pass-by-reference is strictly prohibited. See the function declarations section for the proper way to
pass function arguments by-reference.

In passing arrays as arguments to a function, the function call may include the "array" hint and may be split into
multiple lines to improve readability. In such cases, the normal guidelines for writing arrays still apply:

.. code-block:: php
   :linenos:

   threeArguments(array(1, 2, 3), 2, 3);

   threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500), 2, 3);

   threeArguments(array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500
   ), 2, 3);

.. _coding-standard.coding-style.control-statements:

Control Statements
^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If/Else/Elseif
^^^^^^^^^^^^^^

Control statements based on the **if** and **elseif** constructs must have a single space before the opening
parenthesis of the conditional and a single space after the closing parenthesis.

Within the conditional statements between the parentheses, operators must be separated by spaces for readability.
Inner parentheses are encouraged to improve logical grouping for larger conditional expressions.

The opening brace is written on the same line as the conditional statement. The closing brace is always written on
its own line. Any content within the braces must be indented using four spaces.

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   }

If the conditional statement causes the line length to exceed the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>` and has several clauses, you may break the conditional into
multiple lines. In such a case, break the line prior to a logic operator, and pad the line such that it aligns
under the first character of the conditional clause. The closing paren in the conditional will then be placed on a
line with the opening brace, with one space separating the two, at an indentation level equivalent to the opening
control statement.

.. code-block:: php
   :linenos:

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   }

The intention of this latter declaration format is to prevent issues when adding or removing clauses from the
conditional during later revisions.

For "if" statements that include "elseif" or "else", the formatting conventions are similar to the "if" construct.
The following examples demonstrate proper formatting for "if" statements with "else" and/or "elseif" constructs:

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   } else {
       $a = 7;
   }

   if ($a != 2) {
       $a = 2;
   } elseif ($a == 3) {
       $a = 4;
   } else {
       $a = 7;
   }

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   } elseif (($a != $b)
             || ($b != $c)
   ) {
       $a = $c;
   } else {
       $a = $b;
   }

*PHP* allows statements to be written without braces in some circumstances. This coding standard makes no
differentiation- all "if", "elseif" or "else" statements must use braces.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Control statements written with the "switch" statement must have a single space before the opening parenthesis of
the conditional statement and after the closing parenthesis.

All content within the "switch" statement must be indented using four spaces. Content under each "case" statement
must be indented using an additional four spaces.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

The construct ``default`` should never be omitted from a ``switch`` statement.

.. note::

   **Note**: It is sometimes useful to write a ``case`` statement which falls through to the next case by not
   including a ``break`` or ``return`` within that case. To distinguish these cases from bugs, any ``case``
   statement where ``break`` or ``return`` are omitted should contain a comment indicating that the break was
   intentionally omitted.

.. _coding-standards.inline-documentation:

Inline Documentation
^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Documentation Format
^^^^^^^^^^^^^^^^^^^^

All documentation blocks ("docblocks") must be compatible with the phpDocumentor format. Describing the
phpDocumentor format is beyond the scope of this document. For more information, visit: `http://phpdoc.org/`_

All class files must contain a "file-level" docblock at the top of each file and a "class-level" docblock
immediately above each class. Examples of such docblocks can be found below.

.. _coding-standards.inline-documentation.files:

Files
^^^^^

Every file that contains *PHP* code must have a docblock at the top of the file that contains these phpDocumentor
tags at a minimum:

.. code-block:: php
   :linenos:

   /**
    * Short description for file
    *
    * Long description for file (if any)...
    *
    * LICENSE: Some license information
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @link       http://framework.zend.com/package/PackageName
    * @since      File available since Release 1.5.0
   */

The ``@category`` annotation must have a value of "Zend".

The ``@package`` annotation must be assigned, and should be equivalent to the component name of the class contained
in the file; typically, this will only have two segments, the "Zend" prefix, and the component name.

The ``@subpackage`` annotation is optional. If provided, it should be the subcomponent name, minus the class
prefix. In the example above, the assumption is that the class in the file is either "``Zend_Magic_Wand``", or uses
that classname as part of its prefix.

.. _coding-standards.inline-documentation.classes:

Classes
^^^^^^^

Every class must have a docblock that contains these phpDocumentor tags at a minimum:

.. code-block:: php
   :linenos:

   /**
    * Short description for class
    *
    * Long description for class (if any)...
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @version    Release: @package_version@
    * @link       http://framework.zend.com/package/PackageName
    * @since      Class available since Release 1.5.0
    * @deprecated Class deprecated in Release 2.0.0
    */

The ``@category`` annotation must have a value of "Zend".

The ``@package`` annotation must be assigned, and should be equivalent to the component to which the class belongs;
typically, this will only have two segments, the "Zend" prefix, and the component name.

The ``@subpackage`` annotation is optional. If provided, it should be the subcomponent name, minus the class
prefix. In the example above, the assumption is that the class described is either "``Zend_Magic_Wand``", or uses
that classname as part of its prefix.

.. _coding-standards.inline-documentation.functions:

Functions
^^^^^^^^^

Every function, including object methods, must have a docblock that contains at a minimum:

- A description of the function

- All of the arguments

- All of the possible return values

It is not necessary to use the "@access" tag because the access level is already known from the "public",
"private", or "protected" modifier used to declare the function.

If a function or method may throw an exception, use @throws for all known exception classes:

.. code-block:: php
   :linenos:

   @throws exceptionclass [description]



.. _`ліцензії`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
