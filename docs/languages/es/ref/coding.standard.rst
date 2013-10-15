.. EN-Revision: none
.. _coding-standard:

*****************************************************
Estándares de codificación de Zend Framework para PHP
*****************************************************

.. _coding-standard.overview:

Introducción
------------

.. _coding-standard.overview.scope:

Alcance
^^^^^^^

Este documento provee las pautas para el formato del código y la documentación a personas y equipos que
contribuyan con Zend Framework. Muchos de los desarrolladores que usan Zend Framework han encontrado útiles estos
estándares debido a que el estilo de su código permanece consistente con otros códigos fuente basados en Zend
Framework. También debe resaltarse que especificar completamente los estándares de código requiere un esfuerzo
significativo.

.. note::

   Nota: A veces, los desarrolladores consideran el establecimiento de estándares más importante que lo que el
   estándar sugiere realmente al nivel más detallado de diseño. Estas pautas en los estándares de código de
   Zend Framework han demostrado funcionar bien en otros projectos de Zend Framework. Puede modificar estos
   estándares o usarlos en conformidad con los términos de nuestra `licencia`_

Temas incluídos en los estándares de código de Zend Framework:

- Dar formato a archivos *PHP*

- Convenciones de nombrado

- Estilo de código

- Documentación integrada

.. _coding-standard.overview.goals:

Objetivos
^^^^^^^^^

Los estándares de código resultan importantes en cualquier proyecto de desarrollo, pero son especialmente
importantes cuando muchos desarrolladores trabajan en el mismo proyecto. Los estándares de código ayudan a
asegurar que el código tenga una alta calidad, menos errores, y pueda ser mantenido fácilmente.

.. _coding-standard.php-file-formatting:

Formato de archivos PHP
-----------------------

.. _coding-standard.php-file-formatting.general:

General
^^^^^^^

Para archivos que contengan únicamente código *PHP*, la etiqueta de cierre ("?>") no está permitida. No es
requerida por *PHP*, y omitirla evita la inyección de espacios en blanco en la respuesta.

.. note::

   **IMPORTANTE:** La inclusión de datos binarios arbitrarios permitidos por ``__HALT_COMPILER()`` está prohibida
   en los archivos *PHP* de Zend Framework, así como en cualquier fichero derivado. El uso de esta característica
   sólo está permitido en algunos scripts de instalación.

.. _coding-standard.php-file-formatting.indentation:

Indentación
^^^^^^^^^^^

La indentación suele estar compuesta por 4 espacios. Las tabulaciones no están permitidas.

.. _coding-standard.php-file-formatting.max-line-length:

Tamaño máximo de línea
^^^^^^^^^^^^^^^^^^^^^^

La longitud recomendable para una línea de código es de 80 caracteres. Esto significa que los desarrolladores de
Zend deberían intentar mantener cada línea de su código por debajo de los 80 caracteres, siempre que sea
posible. No obstante, líneas más largas pueden ser aceptables en algunas situaciones. El tamaño máximo de
cualquier línea de código *PHP* es de 120 caracteres.

.. _coding-standard.php-file-formatting.line-termination:

Final de línea
^^^^^^^^^^^^^^

El Final de Línea sigue la convención de archivos de texto Unix. Las líneas deben acabar con un carácter
linefeed (LF). Los caracteres Linefeed están representados con el número 10 ordinal, o el número 0x0A
hexadecimal.

Nota: No use retornos de carro (carriage returns, CR) como en las fuentes de Apple (0x0D) o la combinación de
retorno de carro - linefeed (*CRLF*) estandar para sistemas operativos Windows (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Convenciones de Nombres
-----------------------

.. _coding-standard.naming-conventions.classes:

Clases
^^^^^^

Zend Framework se estandariza una convencion de nombres de clases donde los nombres de las clases apuntan
directamente a las carpetas en las que estan contenidas. La carpeta raiz de la biblioteca estandar de Zend
Framework es la carpeta "Zend/", mientras que la carpeta raíz de las bibliotecas extra de Zend Framework es la
carpeta "ZendX/". Todas las clases de Zend Framework están almacenadas jerárquicamente bajo estas carpetas raíz.

Los nombres de clases pueden contener sólo caracteres alfanuméricos. Los números están permitidos en los
nombres de clase, pero desaconsejados en la mayoría de casos. Las barras bajas (\_) están permitidas solo como
separador de ruta (el archivo "``Zend/Db/Table.php``" debe apuntar al nombre de clase "``Zend\Db\Table``").

Si el nombre de una clase esta compuesto por mas de una palabra, la primera letra de cada palabra debe aparecer en
mayúsculas. Poner en mayúsculas las letras siguientes no está permitido, ej: "ZendPDF" no está permitido,
mientras que "``ZendPdf``" es admisible.

Estas convenciones definen un mecanismo de pseudo-espacio de nombres para Zend Framework. Zend Framework adoptará
la funcionalidad *PHP* de espacio de nombres cuando esté disponible y sea factible su uso en las aplicaciones de
nuestros desarrolladores.

Vea los nombres de clase en las bibliotecas estandar y adicionales (extras) como ejemplos de esta convención de
nombres.

.. note::

   **IMPORTANTE:** El código que deba distribuirse junto a las bibliotecas de Zend Framework, pero no forma parte
   de las bibliotecas estándar o extras de Zend (e.g.: código o bibliotecas que no estén distribuídas por Zend)
   no puede empezar nunca por "Zend\_" o "ZendX\_".

.. _coding-standard.naming-conventions.abstracts:

Clases Abstractas
^^^^^^^^^^^^^^^^^

En general, las clases abstractas siguen las mismas convenciones que las :ref:`clases
<coding-standard.naming-conventions.classes>`, con una regla adicional: Los nombres de las clases abstractas deben
acabar con el término, "Abstract", y ese término no debe ser precedida por un guión bajo. Ejemplo,
``Zend\Controller\Plugin\Abstract`` es considerado un nombre no válido, pero ``Zend\Controller\PluginAbstract`` o
``Zend\Controller\Plugin\PluginAbstract`` serian nombres válidos.

.. note::

   Esta convención de nombres es nuevo con la versión 1.9.0 de Zend Framework. Las clases que preceden aquella
   versión no pueden seguir esta regla, pero serán renombradas en el futuro a fin de cumplir la regla.

.. _coding-standard.naming-conventions.interfaces:

Interfaces
^^^^^^^^^^

En general, las clases abstractas siguen las mismas convenciones que las :ref:`classes
<coding-standard.naming-conventions.classes>`, con una regla adicional: Los nombres de las interfaces opcionalmente
pueden acabar con el término, "Interface",pero término no debe ser precedida por un guión bajo. Ejemplo,
``Zend\Controller\Plugin\Interface`` es considerado un nombre no válido, pero ``Zend\Controller\PluginInterface``
o ``Zend\Controller\Plugin\PluginInterface`` serian nombres válidos.

Si bien esta regla no es necesaria, se recomienda encarecidamente su uso, ya que proporciona una buena referencia
visual a los desarrolladores, como saber que archivos contienen interfaces en lugar de clases.

.. note::

   Esta convención de nombres es nuevo con la versión 1.9.0 de Zend Framework. Las clases que preceden aquella
   versión no pueden seguir esta regla, pero serán renombradas en el futuro a fin de cumplir la regla.

.. _coding-standard.naming-conventions.filenames:

Nombres de Archivo
^^^^^^^^^^^^^^^^^^

Para cualquier otro archivo, sólo caracteres alfanuméricos, barras bajas (\_) y guiones (-) están permitidos.
Los espacios en blanco están estrictamente prohibidos.

Cualquier archivo que contenga código *PHP* debe terminar con la extensión "``.php``", con la excepción de los
scripts de la vista. Los siguientes ejemplos muestran nombres de archivo admisibles para clases de Zend
Framework..:

.. code-block:: php
   :linenos:

   Zend/Db.php

   Zend/Controller/Front.php

   Zend/View/Helper/FormRadio.php

Los nombres de archivo deben apuntar a nombres de clases como se describe arriba.

.. _coding-standard.naming-conventions.functions-and-methods:

Funciones y Métodos
^^^^^^^^^^^^^^^^^^^

Los nombres de funciones pueden contener únicamente caracteres alfanuméricos. Las guiones bajos (\_) no estan
permitidos. Los números están permitidos en los nombres de función pero no se aconseja en la mayoría de los
casos.

Los nombres de funciones deben empezar siempre con una letra minúscula. Cuando un nombre de función consiste en
más de una palabra, la primera letra de cada nueva palabra debe estar en mayúsculas. Esto es llamado comúnmente
como formato "camelCase".

Por norma general, se recomienda la elocuencia. Los nombres de función deben ser lo suficientemente elocuentes
como para describir su propósito y comportamiento.

Estos son ejemplos de nombres de funciones admisibles:

.. code-block:: php
   :linenos:

   filterInput()

   getElementById()

   widgetFactory()

Para la programación orientada a objetos, los métodos de acceso para las instancias o variables estáticas deben
ir antepuestos con un "get" o un "set". Al implementar el patron de diseño, tales como el patrón singleton o el
patrón factory, el nombre del método debe contener en la práctica el nombre del patrón para describir su
comportamiento de forma más completa.

Para el caso en que los métodos son declarados con el modificador "private" o "protected", el primer carácter del
nombre de la variable debe ser una barra baja (\_). Este es el único uso admisible de una barra baja en un nombre
de método. Los métodos declarados como públicos no deberían contener nunca una barra baja.

Las funciones de alcance global (también llamadas "funciones flotantes") están permitidas pero desaconsejadas en
la mayoría de los casos. Considere envolver esas funciones en una clase estática.

.. _coding-standard.naming-conventions.variables:

Variables
^^^^^^^^^

Los nombres de variables pueden contener caracteres alfanuméricos. Las barras bajas (\_) no están permitidas. Los
números están permitidos en los nombres de variable pero no se aconseja en la mayoría de los casos.

Para las variables de instancia que son declaradas con el modificador "private" o "protected", el primer carácter
de la variable debe ser una única barra baja (\_). Este es el único caso admisible de una barra baja en el nombre
de una variable. Las variables declaradas como "public" no pueden empezar nunca por barra baja.

Al igual que los nombres de funciones (ver sección 3.3), los nombres de variables deben empezar siempre con una
letra en minúscula y seguir la convención "camelCaps".

Por norma general, se recomienda la elocuencia. Las variables deberían ser siempre tan elocuentes como prácticas
para describir los datos que el desarrollador pretende almacenar en ellas. Variables escuetas como "``$i``" y
"``$n``" están desaconsejadas, salvo para el contexto de los bucles más pequeños. Si un bucle contiene más de
20 líneas de código, las variables de índice deberían tener nombres más descriptivos.

.. _coding-standard.naming-conventions.constants:

Constantes
^^^^^^^^^^

Las constantes pueden contener tanto caracteres alfanuméricos como barras bajas (\_). Los números están
permitidos.

Todos las letras pertenecientes al nombre de una constante deben aparecer en mayúsculas.

Las palabras dentro del nombre de una constante deben separarse por barras bajas (\_). Por ejemplo,
``EMBED_SUPPRESS_EMBED_EXCEPTION`` está permitido, pero ``EMBED_SUPPRESSEMBEDEXCEPTION`` no.

Las constantes deben ser definidas como miembros de clase con el modificador "const". Definir constantes en el
alcance global con la función "define" está permitido pero no recomendado.

.. _coding-standard.coding-style:

Estilo de código
----------------

.. _coding-standard.coding-style.php-code-demarcation:

Demarcación de código PHP
^^^^^^^^^^^^^^^^^^^^^^^^^

El código *PHP* debe estar delimitado siempre por la forma completa de las etiquetas *PHP* estándar:

.. code-block:: php
   :linenos:

   <?php

   ?>

Las etiquetas cortas (short tags) no se permiten nunca. Para archivos que contengan únicamente código *PHP*, la
etiqueta de cierre debe omitirse siempre (Ver :ref:` <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Cadenas de Caracteres
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.strings.literals:

Cadenas Literales de Caracteres
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando una cadena es literal (no contiene sustitución de variables), el apóstrofo o "comilla" debería ser usado
siempre para delimitar la cadena:

.. code-block:: php
   :linenos:

   $a = 'Example String';

.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

Cadenas Literales de Caracteres que Contengan Apóstrofos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando una cadena literal de caracteres contega apóstrofos, es permitido delimitar la cadena de caracteres con
"comillas dobles". Esto es especialmente útil para sentencias ``SQL``:

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";

En esta sintáxis es preferible escapar apóstrofes, ya que es mucho más fácil de leer.

.. _coding-standard.coding-style.strings.variable-substitution:

Sustitución de Variables
^^^^^^^^^^^^^^^^^^^^^^^^

La sustitución de variables está permitida en cualquiera de estas formas:

.. code-block:: php
   :linenos:

   $greeting = "Hello $name, welcome back!";

   $greeting = "Hello {$name}, welcome back!";

Por consistencia, esta forma no está permitida:

.. code-block:: php
   :linenos:

   $greeting = "Hello ${name}, welcome back!";

.. _coding-standard.coding-style.strings.string-concatenation:

Concatenación de cadenas
^^^^^^^^^^^^^^^^^^^^^^^^

Las cadenas deben ser concatenadas usando el operador punto ("."). Un espacio debe añadirse siempre antes y
después del operador "." para mejorar la legibilidad:

.. code-block:: php
   :linenos:

   $company = 'Zend' . ' ' . 'Technologies';

Al concatenar cadenas con el operador ".", se recomienda partir la sentencia en múltiples líneas para mejorar la
legibilidad. En estos casos, cada linea sucesiva debe llevar un margen de espacios en blanco de forma que el
operador "." está alineado bajo el operador "=":

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` FROM `people` "
        . "WHERE `name` = 'Susan' "
        . "ORDER BY `name` ASC ";

.. _coding-standard.coding-style.arrays:

Arrays
^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Arrays Indexados Numéricamente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

No están permitidos números negativos como índices.

Un array indexado puede empezar por cualquier valor no negativo, sin embargo, no se recomiendan índices base
distintos a 0.

Al declarar arrays indexados con la función ``array``, un espacio de separación deben añadirse después de cada
coma, para mejorar la legibilidad:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio');

Se permite declarar arrays indexados multilínea usando la construcción "array". En este caso, cada línea
sucesiva debe ser tabulada con cuatro espacios de forma que el principio de cada línea está alineado:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500);

Alternativamente, el elemento inicial del array puede comenzar en la siguiente línea. Si es así, debe ser
alineado en un nivel de sangría superior a la línea que contiene la declaración del array, y todas las sucesivas
líneas deben tener la mismo indentación, el paréntesis de cierre debe ser en una nueva línea al mismo nivel de
indentación que la línea que contiene la declaración del array:

.. code-block:: php
   :linenos:

   $sampleArray = array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500,
   );

Al utilizar esta última declaración, recomendamos la utilización de una coma detrás de el último elemento de
la matriz, lo que minimizará el impacto de añadir nuevos elementos en las siguientes líneas, y ayuda a
garantizar que no se produzcan errores debido a la falta de una coma.

.. _coding-standard.coding-style.arrays.associative:

Arrays Asociativos
^^^^^^^^^^^^^^^^^^

Al declarar arrays asociativos con la construcción ``array``, se recomienda partir la declaración en múltiples
líneas. En este caso, cada línea sucesiva debe ser tabuladas con cuatro espacios de forma que tanto las llaves
como los valores están alineados:

.. code-block:: php
   :linenos:

   $sampleArray = array('firstKey'  => 'firstValue',
                        'secondKey' => 'secondValue');

Alternativamente, el elemento inicial del array puede comenzar en la siguiente línea. Si es así, debe ser
alineado en un nivel de sangría superior a la línea que contiene la declaración del array, y todas las sucesivas
líneas deben tener la mismo indentación, el paréntesis de cierre debe ser en una nueva línea al mismo nivel de
indentación que la línea que contiene la declaración del array: Para mejor legibilidad, los diversos operadores
de asiganción "=>" deben ser rellenados con espacios en blanco hasta que se alinien.

.. code-block:: php
   :linenos:

   $sampleArray = array(
       'firstKey'  => 'firstValue',
       'secondKey' => 'secondValue',
   );

Al utilizar esta última declaración, recomendamos la utilización de una coma detrás de el último elemento de
la matriz, lo que minimizará el impacto de añadir nuevos elementos en las siguientes líneas, y ayuda a
garantizar que no se produzcan errores debido a la falta de una coma.

.. _coding-standard.coding-style.classes:

Clases
^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Declaración de clases
^^^^^^^^^^^^^^^^^^^^^

Las Clases deben ser nombradas de acuerdo a las convencion de nombres de Zend Framework.

La llave "{" deberá escribirse siempre en la línea debajo del nombre de la clase ("one true brace").

Cada clase debe contener un bloque de documentación acorde con el estándar de PHPDocumentor.

Todo el código contenido en una clase debe ser separado con cuatro espacios.

Únicamente una clase está permitida por archivo *PHP*.

Incluir código adicional en archivos de clase está permitido pero esta desaconsejado. En archivos de ese tipo,
dos líneas en blanco deben separar la clase de cualquier código *PHP* adicional en el archivo de clase.

A continuación se muestra un ejemplo de una declaración de clase que es permitida:

.. code-block:: php
   :linenos:

   /**
    * Bloque de Documentación aquí
    */
   class SampleClass
   {
       // el contenido de la clase
       // debe separarse con cuatro espacios
   }

Las clases que extiendan otras clases o interfaces deberían declarar sus dependencias en la misma línea siempre
que sea posible.

.. code-block:: php
   :linenos:

   class SampleClass extends FooAbstract implements BarInterface
   {
   }

Si como resultado de esas declaraciones, la longitud de la línea excede la longitud del :ref:`Tamaño máximo de
línea <coding-standard.php-file-formatting.max-line-length>`, se debe romper la línea antes de la palabra clave
"extends" y / o "implements" e indentarlo con un nivel de indentación (4 espacios).

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

Variables de miembros de clase
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las variables de miembros de clase deben ser nombradas de acuerdo con las conveciones de nombrado de variables de
Zend Framework.

Cualquier variable declarada en una clase debe ser listada en la parte superior de la clase, por encima de las
declaraciones de cualquier método.

La construcción **var** no está permitido. Las variables de miembro siempre declaran su visibilidad usando uno
los modificadores ``private``, ``protected``, o ``public``. Dar acceso a las variables de miembro declarándolas
directamente como public está permitido pero no se aconseja en favor de accesor methods (set & get).

.. _coding-standard.coding-style.functions-and-methods:

Funciones y Métodos
^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Declaración de Funciones y Métodos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las Funciones deben ser nombradas de acuerdo a las convenciones de nombrado de Zend Framework.

Los métodos dentro de clases deben declarar siempre su visibilidad usando un modificador ``private``,
``protected``, o ``public``.

Como en las clases, la llave "{" debe ser escrita en la línea siguiente al nombre de la función ("one true brace"
form). No está permitido un espacio entre el nombre de la función y el paróntesis de apertura para los
argumentos.

Las funciones de alcance global no están permitidas.

Lo siguiente es un ejemplo de una declaración admisible de una función en una clase:

.. code-block:: php
   :linenos:

   /**
    * Bloque de Documentación aquí
    */
   class Foo
   {
       /**
        * Bloque de Documentación aquí
        */
       public function bar()
       {
           // el contenido de la función
           // debe separarse con cuatro espacios
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

   **NOTA:** El paso por referencia es el único mecanismo de paso de parámetros permitido en una declaración de
   método.

.. code-block:: php
   :linenos:

   /**
    * Bloque de Documentación aquí
    */
   class Foo
   {
       /**
        * Bloque de Documentación aquí
        */
       public function bar(&$baz)
       {}
   }

La llamada por referencia está estrictamente prohibida.

El valor de retorno no debe estar indicado entre paréntesis. Esto podría afectar a la legibilidad, además de
romper el código si un método se modifica posteriormente para que devuelva por referencia.

.. code-block:: php
   :linenos:

   /**
    * Bloque de Documentación aquí
    */
   class Foo
   {
       /**
        * INCORRECTO
        */
       public function bar()
       {
           return($this->bar);
       }

       /**
        * CORRECTO
        */
       public function bar()
       {
           return $this->bar;
       }
   }

.. _coding-standard.coding-style.functions-and-methods.usage:

Uso de Funciones y Métodos
^^^^^^^^^^^^^^^^^^^^^^^^^^

Los argumentos de la función tendrían que estar separados por un único espacio posterior después del
delimitador coma. A continuación se muestra un ejemplo de una invocación admisible de una función que recibe
tres argumentos:

.. code-block:: php
   :linenos:

   threeArguments(1, 2, 3);

La llamada por referencia está estrictamente prohibida. Vea la sección de declaraciones de funciones para el
método correcto de pasar argumentos por referencia.

Al pasar arrays como argumentos a una función, la llamada a la función puede incluir el indicador "hint" y puede
separarse en múltiples líneas para aumentar la legibilidad. En esos casos, se aplican las pautas normales para
escribir arrays:

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

Sentencias de Control
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If/Else/Elseif
^^^^^^^^^^^^^^

Las sentencias de control basadas en las construcciones **if** y **elseif** deben tener un solo espacio en blanco
antes del paréntesis de apertura del condicional y un solo espacio en blanco después del paréntesis de cierre.

Dentro de las sentencias condicionales entre paréntesis, los operadores deben separarse con espacios, por
legibilidad. Se aconseja el uso de paréntesis internos para mejorar la agrupación lógica en expresiones
condicionales más largas.

La llave de apertura "{" se escribe en la misma línea que la sentencia condicional. La llave de cierre "}" se
escribe siempre en su propia línea. Cualquier contenido dentro de las llaves debe separarse con cuatro espacios en
blanco.

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

Para las declaraciones "if" que incluyan "elseif" o "else", las convenciones de formato son similares a la
construcción "if". Los ejemplos siguientes demuestran el formato correcto para declaraciones "if" con
construcciones "else" y/o "elseif":

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

*PHP* permite escribir sentencias sin llaves -{}- en algunas circunstancias. Este estándar de código no hace
ninguna diferenciación- toda sentencia "if", "elseif" o "else" debe usar llaves.

El uso de la construcción "elseif" está permitido pero no se aconseja, en favor de la combinación "else if".

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Las declaraciones de control escritas con la declaración "switch" deben tener un único espacio en blanco antes
del paréntesis de apertura del condicional y después del paréntesis de cierre.

Todo contenido dentro de una declaración "switch" debe separarse usando cuatro espacios. El contenido dentro de
cada declaración "case" debe separarse usando cuatro espacios adicionales.

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

La construcción ``default`` no debe omitirse nunca en una declaración ``switch``.

.. note::

   **NOTA:** En ocasiones, resulta útil escribir una declaración ``case`` que salta al siguiente case al no
   incluir un ``break`` o ``return`` dentro de ese case. Para distinguir estos casos de posibles errores, cualquier
   declaración donde ``break`` o ``return`` sean omitidos deberán contener un comentario indicando que se
   omitieron intencionadamente.

.. _coding-standards.inline-documentation:

Documentación integrada
^^^^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Formato de documentación
^^^^^^^^^^^^^^^^^^^^^^^^

Todos los bloques de documentación ("docblocks") deben ser compatibles con el formato de phpDocumentor. Describir
el formato de phpDocumentor está fuera del alcance de este documento. Para más información, visite:
`http://phpdoc.org/`_

Todos los archivos de clase deben contener un bloque de documentación "a nivel de archivo" al principio de cada
archivo y un bloque de documentación "a nivel de clase" inmediatamente antes de cada clase. Ejemplo de estos
bloques de documentación pueden encontrarse debajo.

.. _coding-standards.inline-documentation.files:

Archivos
^^^^^^^^

Cada archivo que contenga código *PHP* debe tener un bloque de documentación al principio del archivo que
contenga como mínimo las siguientes etiquetas phpDocumentor:

.. code-block:: php
   :linenos:

   /**
    * Zend Framework (http://framework.zend.com/)
    *
    * Long description for file (if any)...
    *
    * @link      http://github.com/zendframework/zf2 for the canonical source repository
    * @copyright Copyright (c) 2005-2013 Zend Technologies USA Inc. (http://www.zend.com)
    * @license   http://framework.zend.com/license/new-bsd New BSD License
    * @since     File available since Release 1.5.0
    */

.. _coding-standards.inline-documentation.classes:

Clases
^^^^^^

Cada clase debe contener un bloque de documentación que contenga como mínimo las siguientes etiquetas
phpDocumentor:

.. code-block:: php
   :linenos:

   /**
    * Short description for class
    *
    * Long description for class (if any)...
    *
    * @since      Class available since Release 1.5.0
    * @deprecated Class deprecated in Release 2.0.0
    */

.. _coding-standards.inline-documentation.functions:

Funciones
^^^^^^^^^

Cada función, incluyendo métodos de objeto, debe contener un bloque de documentación que contenga como mínimo:

- Una descripción de la función

- Todos los argumentos

- Todos los posibles valores de retorno

No es necesario incluir la etiqueta "@access" si el nivel de acceso es conocido de antemano por el modificador
"public", "private", o "protected" usado para declarar la función.

Si una función/método puede lanzar una excepción, utilice @throws para todos los tipos de excepciones conocidas:

.. code-block:: php
   :linenos:

   @throws exceptionclass [description]



.. _`licencia`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
