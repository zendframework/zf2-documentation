.. EN-Revision: none
.. _coding-standard:

**********************************
Zend Framework PHP Coding Standard
**********************************

.. _coding-standard.overview:

Overview
--------

.. _coding-standard.overview.scope:

Scope
^^^^^

본 문서는 젠드 프래임워크를 개발하는 개발자 개인과 팀 혹은 단체에게 가이드라인과
리소스를 제공하는 문서입니다. 본문서에서는 다음의 주제들이 다루어 집니다.:

   - PHP 파일의 포멧 형식

   - 이름 규칙

   - 코딩 스타일

   - Inline Documentation



.. _coding-standard.overview.goals:

목표
^^

바람직한 코딩 규약은 어떤 프로젝트에서나 중요한 요소로 작용합니다. 특히 동일
프로젝트를 여러명의 개발자가 동시에 작업할경우 더더욱 중요합니다. 코딩의 표준
규약은 소스 코드 자체의 높은 품질과, 적은 버그 그리고 손쉬운 유지관리에 많은
도움을 줍니다.

.. _coding-standard.php-file-formatting:

PHP 파일의 포멧
----------

.. _coding-standard.php-file-formatting.general:

일반 사항
^^^^^

오직 PHP코드만을 포함한 파일에서는, 코드의 맺음 태그("?>")가 절대 허용되지
않습니다. 이는 PHP에 의해서 허용되지 않는 부분입니다. 맺음 태그를 포함하지 않는
것은 공백문자열이 아웃풋된 결과에 삽입되지 않도록 하기 위한 조취입니다.

**주의:** *__HALT_COMPILER()*\ 에 의해서 생성된 임의적인 바이너리 데이터의 포함은 젠드
프래임워크 php파일 혹은 젠드 프래임워크에 의해 생성된 모든 파일에서 허용되지
않습니다. 이러한 기능의 사용은 특별한 설치 스크립트에 의해서만 허용됩니다.

.. _coding-standard.php-file-formatting.indentation:

인덴트
^^^

탭(Tab)이 아닌 4개의 공백문자(space)를 이용해 주십시오.

.. _coding-standard.php-file-formatting.max-line-length:

최대 허용 라인 줄수
^^^^^^^^^^^

한줄에 허용되는 글자수는 80글자를 기준으로 삼습니다. 개발자는 가능한한 한줄안에
80컬럼내의 문자가 삽입되도록 해주십시요. 그러나 그 이상의 글자도 가능은 합니다.
PHP 코드의 최대 허용 글자수는 120 캐릭터입니다.

.. _coding-standard.php-file-formatting.line-termination:

라인 터미네이션(줄바꾸기)
^^^^^^^^^^^^^^

라인 터미네이션(줄바꾸기)은 유닉스 텍스트 파일의 그것과 동일합니다. 라인은
라인피드(LF)로 항상 끝나야 합니다. 라인피드(Linefeeds)는 오디날(ordinal) 10 혹은 16진수로
0x0A로 표현합니다.

메킨토시 컴퓨터에서 쓰이는 캐리지 리턴(CR,0x0D)은 이용하지 마십시오.

윈도우 컴퓨터에서 쓰이는 return/linefeed 조합(CRLF,0x0D, 0x0A)은 이용하지 마십시오.

.. _coding-standard.naming-conventions:

이름 규칙
-----

.. _coding-standard.naming-conventions.classes:

클라스
^^^

젠드 프래임워크는 클라스 이름과 그 클래스가 존재하는 디렉토리의 위치가 상호
매칭되는 구조를 가지고 있습니다.젠드 프래임워크의 최상위 디렉토리는
"Zend/"디렉토리이며 모든 클라스들은 이 아래에 계층적으로 위치하게 됩니다.

클라스 이름은 오직 알파벳만 포함할수 있습니다. 클라스 이름에 숫자가 허용은
되지만 권장되지는 않습니다. 밑줄(\_)은 경로 구분자를 대체하는 역활로만 쓰입니다.
-- 파일이름 "Zend/Db/Table.php"는 클라스 이름 "Zend\Db\Table"와 매칭이 되어야 합니다.

만약 클라스 이름이 하나 이상의 단어로 이루어진경우, 각 단어의 첫번째 단어는
대문가 되어야 합니다. 하지만 클라스이름에서 연이은 대문자의 조합은 허용되지
않습니다. 예를 들면 "ZendPDF"는 허용되지 않는 형태이고 "ZendPdf"는 허용되는
형태입니다.

프레임워크와 함꼐 배포되어지는 젠드사 혹은 젠드사의 파트너 회사들의 클라스들은
항상 "Zend\_" 라는 문구로 시작되며 "Zend/" 디렉토리 아래에 계층적으로 위치하게
됩니다.

클라스 명으로 허용되는 예들:

   .. code-block::
      :linenos:

      Zend_Db

      Zend_View

      Zend\View\Helper

**주의:**\ 프레임워크와 연동은 되지만 프레임워크의 일부가 아닌 코드들은 (젠드나
젠트 파트너사 가 아닌 일반 사용자에 의해 제작된 코드) "Zend\_"라는 이름으로
시작해서는 절대 안됩니다.

.. _coding-standard.naming-conventions.interfaces:

인터페이스
^^^^^

인터페이스 클라스들은 다른 클라스들과 마찬가지의 이름 규칙을 이용합니다. 단
인터페이스들은 그 클라스 이름의 마지막이 "Interface"로 끝나야 합니다. 예:

   .. code-block::
      :linenos:

      Zend\Log_Adapter\Interface
      Zend\Controller_Dispatcher\Interface



.. _coding-standard.naming-conventions.filenames:

파일이름
^^^^

그 외에 모든 파일들은 알파벳과 밑줄(\_) 그리고 대쉬(-)만이 그 이름에 허용됩니다.
공백문자는 허용되지 않습니다.

어떠한 파일이던 PHP 코드를 포함하고 있는 파일들은 ".php"의 확장자를 가져야 합니다.
다음의 예제들은 윗 섹션에서 예를 들었던 클라스들이 포함된 허용가능한
파일이름들입니다:

   .. code-block::
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php

파일이름들은 반드시 위에 기술된 대로 클라스 이름에 매핑되어야 합니다.

.. _coding-standard.naming-conventions.functions-and-methods:

함수(Function)와 메소드들
^^^^^^^^^^^^^^^^^^

Function의 이름들은 알파벳만이 허용됩니다. 밑줄(\_)은 허용되지 않습니다.
Function이름에 숫자는 허용이 되나 권장되는 사항은 아닙니다.

Function 이름들은 항상 소문자로 시작하여야 합니다. Function 이름이 하나의 문자
이상으로 이루어져 있을경우 새로 덧붙여지는 새 단어의 첫글자는 대문자야여 합니다.
이는 일반적으로 "camelCaps" 방식이라고 불리어 집니다.

Function 이름을 그 기능을 짐작할수 있게 만드는것은 권장됩니다. 그 기능을 짐작할수
있게 지어진 Function의 이름은 코드를 이해하는데 실질적으로 많은 도움이 됩니다.

다음은 권장되는 Function 이름들의 예입니다:

   .. code-block::
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()



객체 지형 언어에서 객제에 대한 접근자들은 항상 "get"이나 "set"이라는 접두어를
가지고 있습니다. Singleton 이나 Factory pattern등의 디자인 패턴을 이용하는 경우, 메소드
이름들은 해당 패턴들을 좀더 쉽게 인식할수있는 패턴 이름을 포함하고 있어야
합니다.

전역(global scope, floating functions) 함수는 허용이 되지만 권장되지 않습니다. 하나
Function은 하나의 스타틱 클라스안에서만 이루어지기를 권장합니다.

.. _coding-standard.naming-conventions.variables:

변수
^^

변수명은 오직 알파멧만 허용이 됩니다. 밑줄(\_)은 허용되지 않습니다. 변수명에
숫자는 허용이 되지만 권장되지는 않습니다.

"private"나 "protected"로 선언된 클라스 멤버 변수들은 그 이름의 첫 시작이 하나의
밑줄(\_)로 시작되어야 합니다. 이는 Function 이름에서 밑줄이 허용되는 유일한
경우입니다. "Publice"으로 정의된 맴버 변수들은 밑줄(\_)로 시작되어서는 안됩니다.

Function 이름과 같이 (섹션 3.3을 참고) 변수의 이름들은 소문자로 시작되면 "camelCaps"의
대소문자 규정을 따릅니다.

그 특성을 나타내는 설명구의 이름은 권장됩니다. 변수들은 가능한한 그 역활을
나타내는 쪽으로 이름지어져야 합니다. "$i" 나 "$n"과 같은 단순한 변수명은 단순한
반복문에서를 제외하고는 권장되지 않습니다. 만약 반복구문이 20줄 이상의 크기라면
변수의 이름은 좀더 그 역활이 기술되어있는 쪽으로 지어져야 합니다.

.. _coding-standard.naming-conventions.constants:

상수
^^

상수의 이름들은 알바벳 캐릭터와 밑줄(\_)을 동시에 포함할수 있습니다. 상수의
이름에 숫자는 허용됩니다.

상수의 이름은 반드시 대문자로 이루어져야 합니다.

시각적으로 좀더 쉬운 해독을 위하여, 상수의 단어들은 밑줄(\_)로 나뉘어 져야 합니다.
예를 들어 *EMBED_SUPPRESS_EMBED_EXCEPTION*\ 은 허용되어 지나 *EMBED_SUPPRESSEMBEDEXCEPTION*\ 은
허용되지 않습니다.

상수는 반드시 "const" 지시어를 써서 클라스 맴버로 정의되어야 합니다. 전역변수로서
"define" 지시어와 함께 정의된 상수는 가능은 하나 권장되지 않습니다.

.. _coding-standard.coding-style:

코딩 스타일
------

.. _coding-standard.coding-style.php-code-demarcation:

PHP 코드의 구분
^^^^^^^^^^

PHP 코드는 항상 완젹한 표준 PHP 테그의 형태로 구분지어져야 합니다:

   .. code-block::
      :linenos:
      <?php

      ?>


테그의 단축형은 허용되지 않습니다. 오직 PHP 코드만을 포함하고 있는 파일의 경우,
맺음 테그는 반드시 생략하여야 합니다.(See :ref:` <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

문자열
^^^

.. _coding-standard.coding-style.strings.literals:

단순 문자열
^^^^^^

어떠한 변수도 포함하지 않은 단순 문자열의 경우 단따옴표 혹은 어퍼스트로피를
이용하여 문자열을 구별지어야 합니다:

   .. code-block::
      :linenos:

      $a = 'Example String';



.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

단따옴표를 포함한 문자열
^^^^^^^^^^^^^

문자열 자체가 어퍼스트로피(단따옴표)를 포함하고 있는 경우, "상따옴표"를 이용하여
구별되어 질수 있습니다. 이는 특히 SQL 구문의 처리시 유용합니다:

   .. code-block::
      :linenos:

      $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";

The above syntax is preferred over escaping apostrophes.

.. _coding-standard.coding-style.strings.variable-substitution:

변수의 치환
^^^^^^

변수의 치환은 다음 두가지 방법으로 허용됩니다.:

   .. code-block::
      :linenos:

      $greeting = "Hello $name, welcome back!";

      $greeting = "Hello {$name}, welcome back!";



동일성을 위하여 다음의 형태는 허용되지 않습니다:

   .. code-block::
      :linenos:

      $greeting = "Hello ${name}, welcome back!";



.. _coding-standard.coding-style.strings.string-concatenation:

변수의 연결
^^^^^^

문자변수들은 "." 연산자를 이용하여 상호 연결됩니다. 좀더 편안한 가독을 위해
반드시 공백문자열이 "." 연산자 전후에 위치해야 합니다:

   .. code-block::
      :linenos:

      $company = 'Zend' . 'Technologies';



"." 연산자를 이용하여 문자열을 합칠때, When concatenating strings with the "." operator, it is
permitted to break the statement into multiple lines to improve readability. In these cases, each successive line
should be padded with whitespace such that the "."; operator is aligned under the "=" operator:

   .. code-block::
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Susan' "
           . "ORDER BY `name` ASC ";



.. _coding-standard.coding-style.arrays:

어레이
^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

산술 인덱스 어레이
^^^^^^^^^^

음수는 인텍스로서 허용되지 않습니다.

An indexed array may be started with any non-negative number, however this is discouraged and it is recommended
that all arrays have a base index of 0.

When declaring indexed arrays with the *array* construct, a trailing space must be added after each comma delimiter
to improve readability:

   .. code-block::
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');



It is also permitted to declare multiline indexed arrays using the "array" construct. In this case, each successive
line must be padded with spaces such that beginning of each line aligns as shown below:

   .. code-block::
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);



.. _coding-standard.coding-style.arrays.associative:

Associative Arrays
^^^^^^^^^^^^^^^^^^

When declaring associative arrays with the *array* construct, it is encouraged to break the statement into multiple
lines. In this case, each successive line must be padded with whitespace such that both the keys and the values are
aligned:

   .. code-block::
      :linenos:

      $sampleArray = array('firstKey'  => 'firstValue',
                           'secondKey' => 'secondValue');



.. _coding-standard.coding-style.classes:

Classes
^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Class Declaration
^^^^^^^^^^^^^^^^^

Classes must be named by following the naming conventions.

The brace is always written on the line underneath the class name ("one true brace" form).

Every class must have a documentation block that conforms to the PHPDocumentor standard.

Any code within a class must be indented four spaces.

Only one class is permitted per PHP file.

Placing additional code in a class file is permitted but discouraged. In these files, two blank lines must separate
the class from any additional PHP code in the file.

This is an example of an acceptable class declaration:

   .. code-block::
      :linenos:

      /**
       * Documentation Block Here
       */
      class SampleClass
      {
          // entire content of class
          // must be indented four spaces
      }



.. _coding-standard.coding-style.classes.member-variables:

클라스 뱀버 변수
^^^^^^^^^

Member variables must be named by following the variable naming conventions.

Any variables declared in a class must be listed at the top of the class, prior to declaring any functions.

The *var* construct is not permitted. Member variables always declare their visibility by using one of the
*private*, *protected*, or *public* constructs. Accessing member variables directly by making them public is
permitted but discouraged in favor of accessor variables (set/get).

.. _coding-standard.coding-style.functions-and-methods:

Functions and Methods
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Function and Method Declaration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Functions must be named by following the naming conventions.

Functions inside classes must always declare their visibility by using one of the *private*, *protected*, or
*public* constructs.

Like classes, the brace is always written on the line underneath the function name ("one true brace" form). There
is no space between the function name and the opening parenthesis for the arguments.

Functions in the global scope are strongly discouraged.

This is an example of an acceptable function declaration in a class:

   .. code-block::
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
              // entire content of function
              // must be indented four spaces
          }
      }



**NOTE:** Passing by-reference is permitted in the function declaration only:

   .. code-block::
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



Call-time pass by-reference 는 금지되어 있습니다.

반환되는 값은 괄호로 처리되여서는 안됩니다. 괄호안에 쌓인 반환값은 젠드
프레임워크의 가독력을 방해하며 반환되는 리퍼런스로 메소드가 변환될시 코드에
피해를 줄수도 있습니다.

   .. code-block::
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

Function과 Method의 사용
^^^^^^^^^^^^^^^^^^^^

Function의 인자(arguments)들은 콤파 구분자와 하나의 공백문자로 구분되어 집니다. 다음은
세개의 인자를 가지고 있는 Function의 허용예입니다:

   .. code-block::
      :linenos:

      threeArguments(1, 2, 3);



Call-time pass by-reference is prohibited. See the function declarations section for the proper way to pass
function arguments by-reference.

For functions whose arguments permitted arrays, the function call may include the "array" construct and can be
split into multiple lines to improve readability. In these cases, the standards for writing arrays still apply:

   .. code-block::
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);



.. _coding-standard.coding-style.control-statements:

Control Statements
^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If / Else / Elseif
^^^^^^^^^^^^^^^^^^

Control statements based on the *if* and *elseif* constructs must have a single space before the opening
parenthesis of the conditional, and a single space after the closing parenthesis.

Within the conditional statements between the parentheses, operators must be separated by spaces for readability.
Inner parentheses are encouraged to improve logical grouping of larger conditionals.

The opening brace is written on the same line as the conditional statement. The closing brace is always written on
its own line. Any content within the braces must be indented four spaces.

   .. code-block::
      :linenos:

      if ($a != 2) {
          $a = 2;
      }



For "if" statements that include "elseif" or "else", the formatting must be as in these examples:

   .. code-block::
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

PHP allows for these statements to be written without braces in some circumstances. The coding standard makes no
differentiation and all "if", "elseif" or "else" statements must use braces.

Use of the "elseif" construct is permitted but highly discouraged in favor of the "else if" combination.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Control statements written with the "switch" construct must have a single space before the opening parenthesis of
the conditional statement, and also a single space after the closing parenthesis.

All content within the "switch" statement must be indented four spaces. Content under each "case" statement must be
indented an additional four spaces.

.. code-block::
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

The construct *default* may never be omitted from a *switch* statement.

**NOTE:** It is sometimes useful to write a *case* statement which falls through to the next case by not including
a *break* or *return* in that case. To distinguish these cases from bugs, any *case* statement where *break* or
*return* are omitted must contain the comment "// break intentionally omitted".

.. _coding-standards.inline-documentation:

Inline Documentation
^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Documentation Format
^^^^^^^^^^^^^^^^^^^^

All documentation blocks ("docblocks") must be compatible with the phpDocumentor format. Describing the
phpDocumentor format is beyond the scope of this document. For more information, visit: `http://phpdoc.org/`_

All source code file written for Zend Framework or that operates with the framework must contain a "file-level"
docblock at the top of each file and a "class-level" docblock immediately above each class. Below are examples of
such docblocks.

.. _coding-standards.inline-documentation.files:

Files
^^^^^

Every file that contains PHP code must have a header block at the top of the file that contains these phpDocumentor
tags at a minimum:

   .. code-block::
      :linenos:

      /**
       * Short description for file
       *
       * Long description for file (if any)...
       *
       * LICENSE: Some license information
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://www.zend.com/license/3_0.txt   PHP License 3.0
       * @link       http://dev.zend.com/package/PackageName
       * @since      File available since Release 1.2.0
      */



.. _coding-standards.inline-documentation.classes:

Classes
^^^^^^^

Every class must have a docblock that contains these phpDocumentor tags at a minimum:

   .. code-block::
      :linenos:

      /**
       * Short description for class
       *
       * Long description for class (if any)...
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://www.zend.com/license/3_0.txt   PHP License 3.0
       * @version    Release: @package_version@
       * @link       http://dev.zend.com/package/PackageName
       * @since      Class available since Release 1.2.0
       * @deprecated Class deprecated in Release 2.0.0
       */



.. _coding-standards.inline-documentation.functions:

Functions
^^^^^^^^^

Every function, including object methods, must have a docblock that contains at a minimum:



   - A description of the function

   - All of the arguments

   - All of the possible return values



It is not necessary to use the "@access" tag because the access level is already known from the "public",
"private", or "protected" construct used to declare the function.

Function이나 Method의 익셉션 throw 할경우, @thorws를 이용해야 합니다:

   .. code-block::
      :linenos:

      @throws exceptionclass [description]





.. _`http://phpdoc.org/`: http://phpdoc.org/
