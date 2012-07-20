.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

Descripción del Objeto Select
-----------------------------

El objeto ``Zend_Db_Select`` object representa una declaración de consulta *SELECT* de *SQL*. La clase tiene
métodos para agregar partes individuales a la consulta. Se pueden especificar algunas partes de la consulta usando
los métodos en *PHP* y sus estructuras de datos, y la clase forma la sintaxis *SLQ* correcta. Después de
construir la consulta, puede ejecutarla como si se hubiera escrito como un string.

Las posibilidades de ``Zend_Db_Select`` incluyen:

- Métodos Orientados a objetos para especificar consultas *SQL* pieza-a-pieza;

- Abstracción de partes de las consultas *SQL*, independiente de la Base de datos;

- Entrecomillado automático de identificadores de metadatos en la mayoría de los casos, soportanto
  identificadores que contienen palabras reservadas de *SQL* y caracteres especiales;

- Entrecomillado de identificadores y valores, para ayudar a reducir el riesgo de ataque por inyección *SQL*.

El uso de ``Zend_Db_Select`` no es obligatorio. Para consultas *SELECT* muy simples, es usualmente más simple
especificar la consulta completa como un string y ejecutarla usando un método del Adapter como ``query()`` o
``fetchAll()``. Usar ``Zend_Db_Select`` es útil si se necesita ensamblar una consulta *SELECT* proceduralmente, o
basada en condiciones lógicas en la aplicación.

.. _zend.db.select.creating:

Creando un Objeto Select
------------------------

Se puede crear una instancia del objeto ``Zend_Db_Select`` usando el método ``select()`` de un objeto
``Zend_Db_Adapter_Abstract``.

.. _zend.db.select.creating.example-db:

.. rubric:: Ejemplo del método select() del adaptador

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = $db->select();

Otra manera de crear el objeto ``Zend_Db_Select`` es con su constructor, especificando el adaptador de base de
datos como un argumento.

.. _zend.db.select.creating.example-new:

.. rubric:: Ejemplo de creación de un nuevo objeto Select

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = new Zend_Db_Select($db);

.. _zend.db.select.building:

Construyendo consultas Select
-----------------------------

Cuando se construye una consulta, puede agregar cláusulas a ésta, una por una. Hay un método separado para
agregar cada una al objeto ``Zend_Db_Select``.

.. _zend.db.select.building.example:

.. rubric:: Ejemplo de uso de métodos que agregan cláusulas

.. code-block:: php
   :linenos:

   // Crear el objeto Zend_Db_Select
   $select = $db->select();

   // Agregar una cláusula FROM
   $select->from( ...specify table and columns... )

   // Agregar una cláusula WHERE
   $select->where( ...specify search criteria... )

   // Agregar una cláusula ORDER BY
   $select->order( ...specify sorting criteria... );

También puede utilizar la mayoría de los métodos del objeto ``Zend_Db_Select`` con una interfaz fluida. Una
interfaz fluida significa que cada método devuelve una referencia al objeto que se ha llamado, así se puede
llamar inmediatamente a otro método.

.. _zend.db.select.building.example-fluent:

.. rubric:: Ejemplo de uso de la interfaz fluida

.. code-block:: php
   :linenos:

   $select = $db->select()
       ->from( ...specify table and columns... )
       ->where( ...specify search criteria... )
       ->order( ...specify sorting criteria... );

Los ejemplos en esta sección muestran el uso de la interfaz fluída, pero también se puede usar la interfaz
no-fluída en todos los casos. A menudo es necesario utilizar la interfaz no-fluída, por ejemplo, si su
aplicación necesita realizar cierta lógica antes de añadir una cláusula a la consulta.

.. _zend.db.select.building.from:

Agregando una cláusula FROM
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Especifique la tabla para esta consulta usando el método ``from()``. Se puede especificar el nombre de la tabla
como un string. ``Zend_Db_Select`` aplica el identificador entrecomillando el nombre de la tabla, así puede
utilizar caracteres especiales.

.. _zend.db.select.building.from.example:

.. rubric:: Ejemplo del método from()

.. code-block:: php
   :linenos:

   // Construye la consulta:
   //   SELECT *
   //   FROM "products"

   $select = $db->select()
                ->from( 'products' );

Puede especificar un nombre de correlación (también llamado a veces "alias de tabla") para una tabla. En lugar de
un string, se usa un array asociativo que mapee el nombre de correlación con el nombre de la tabla. En otras
cláusulas de consulta *SQL*, utilice nombre de correlación. Si su consulta se une con más de una tabla,
``Zend_Db_Select`` genera una correlación unica de nombres basados en el nombre de la tabla, para una tabla a la
cual no se le espicifique un nombre de correlación.

.. _zend.db.select.building.from.example-cname:

.. rubric:: Ejemplo especificando una tabla con nombre de correlación

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->from( array('p' => 'products') );

Algunos *RDBMS* apoyan el uso de un especificador de esquema para una tabla. Puede especificar el nombre de la
tabla como " "*schemaName.tableName*" ", donde ``Zend_Db_Select`` entrecomillará cada parte individualmente, o
tambien puedes especificar el nombre de esquema por separado. Un nombre de esquema especificado en el nombre de la
tabla toma precedencia en sobre un esquema dado por separado en el caso de que ambos sean dados.

.. _zend.db.select.building.from.example-schema:

.. rubric:: Ejemplo especificando un nombre de esquema

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT *
   //   FROM "myschema"."products"

   $select = $db->select()
                ->from( 'myschema.products' );

   // o

   $select = $db->select()
                ->from('products', '*', 'myschema');

.. _zend.db.select.building.columns:

Agregando Columnas
^^^^^^^^^^^^^^^^^^

En el segundo argumento del método ``from()``, puede especificar las columnas que seleccionar desde la tabla
respectiva. Si no especifica columnas, por defecto será "``*``", el comodín *SQL* para "todas las columnas".

Puede listar las columnas en un simple array de strings, o en un array asociativo mapeando los alias de columnas a
su nombre de tabla. Si solo se especifica una columna en la consulta y no necesita especificar un alias de columna,
puede listarla solo con un string en lugar de un array.

Si se entrega un array vacío como el argumento de las tablas, no se incluirán columnas en el resultado. Vea un
:ref:`código de ejemplo <zend.db.select.building.join.example-no-columns>` en la sección del método ``join()``.

Puedes especificar el nombre de columna como "*nombreCorrelacionado.nombreDeColumna*". ``Zend_Db_Select``
entrecomillará cada parte individualmente. Si no especifica un nombre de correlación para una columna, se usará
el nombre de correlación para la tabla nombrada en el método actual ``from()``.

.. _zend.db.select.building.columns.example:

.. rubric:: Ejemplos especificando columnas

.. code-block:: php
   :linenos:

   // Construir esta consulta:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'));

   // Construir la misma consulta, especificando nombres de correlación
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('p.product_id', 'p.product_name'));

   // Construir esta consulta con una alias para una columna:
   //   SELECT p."product_id" AS prodno, p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('prodno' => 'product_id', 'product_name'));

.. _zend.db.select.building.columns-expr:

Agregando una Expresión en las Columns
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las columnas en consultas *SQL* a veces son expresiones, no simples columnas de una tabla. Las expresiones no
deberían tener nombres de correlación o entrecomillado aplicado. Si sus columnas contienen paréntesis,
``Zend_Db_Select`` las reconoce como una expresión.

Tambien puede crear un objeto de tipo ``Zend_Db_Expr`` explícitamente, para prevenir que el string sea tratado
como columna. ``Zend_Db_Expr`` es una clase mínima, que contiene un simple string. ``Zend_Db_Select`` reconoce el
objeto de tipo ``Zend_Db_Expr`` y lo convierte de vuelta en el string, pero no le aplica ninguna alteración, tal
como el entrecomillado o la correlación de nombres.

.. note::

   El Uso de ``Zend_Db_Expr`` para nombres de columnas no es necesario si la expresión de la columna contiene
   paréntesis; ``Zend_Db_Select`` reconoce y trata el string como expresión, saltándose el entrecomillado y la
   correlación de nombres.

.. _zend.db.select.building.columns-expr.example:

.. rubric:: Ejemplos especificando columnas que contienen expresiones

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", LOWER(product_name)
   //   FROM "products" AS p
   // Una expresion con parentesis implicitamente se transforma en
   // un Zend_Db_Expr.

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'LOWER(product_name)'));

   // Construya esta consulta:
   //   SELECT p."product_id", (p.cost * 1.08) AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' => '(p.cost * 1.08)')
                      );

   // Construya esta consulta usando Zend_Db_Expr explícitamente:
   //   SELECT p."product_id", p.cost * 1.08 AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' =>
                                 new Zend_Db_Expr('p.cost * 1.08'))
                       );

En los casos anteriores, ``Zend_Db_Select`` no altera el string para aplicar correlación de nombres o
entrecomillado de identificadores. Si estos cambios son necesarios para resolver ambigüedades, deberías realizar
cambios manualmente en el string.

Si el nombre de su columna es alguna palabra reservada de *SQL* o contiene caracteres especiales, debería usar el
método ``quoteIdentifier()`` del Adapdator e interpolar el resultado en un string. El método
``quoteIdentifier()`` usa entrecomillado *SQL* para delimitar el identificador, the identifier, dejando en claro
que es un identificador de tabla o columna y no otra parte de la sintaxis *SQL*.

Su código es más independiente de la base de datos si se usa el método ``quoteIdentifier()`` en vez de las
excribir literalmente las comillas en la cadena, debido a que algunos *RDBMS* no usan simbolos estándar para
entrecomillar identificadores. El método ``quoteIdentifier()`` está diseñado para usar los símbolos apropiados
para entrecomillar basado en el tipo del adaptador. El método ``quoteIdentifier()`` también escapa cual caracter
de comilla que aparezca en el nombre del identificador mismo.

.. _zend.db.select.building.columns-quoteid.example:

.. rubric:: Ejemplo de entrecomillado de columnas en una expresión

.. code-block:: php
   :linenos:

   // Construya esta consulta, entrecomillando el nombre
   // especial de la columna llamada "from" en la expresión:
   //   SELECT p."from" + 10 AS origin
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('origin' =>
                                 '(p.' . $db->quoteIdentifier('from') . ' + 10)')
                      );

.. _zend.db.select.building.columns-atomic:

Agregar columnas a una tabla FROM o JOIN existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Puede haber casos en los que desea agregar columnas a una tabla FROM o JOIN después de que estos métodos han sido
llamados. El método ``columns()`` permite agregar columnas en cualquier punto antes de ejecutar la consulta.
Puedes pasar las columnas bien como un string, un ``Zend_Db_Expr`` o un array de estos elementos. El segundo
argumento para este método puede ser omitido, implicando que las columnas serán agregadas a una tabla FROM, en
otro caso debería usarse un nombre de correlación existente.

.. _zend.db.select.building.columns-atomic.example:

.. rubric:: Ejemplos agregando columnas con el método columns()

.. code-block:: php
   :linenos:

   // Construir la consulta:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'product_id')
                ->columns('product_name');

   // Construir la misma consulta, especificando correlación de nombres:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'p.product_id')
                ->columns('product_name', 'p');
                // Alternativamente puede usar columns('p.product_name')

.. _zend.db.select.building.join:

Agregar Otra Tabla a la Consulta Query con JOIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Muchas consultas útiles involucran el uso de un *JOIN* para combinar filas de multiples tablas. Puedes agregar
tablas a una consulta ``Zend_Db_Select`` usando el método ``join()``. Usar este método, es similar al método
``from()``, excepto que puedes especificar una condición de unión en la mayoría de los casos.

.. _zend.db.select.building.join.example:

.. rubric:: Ejemplo del método join()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", p."product_name", l.*
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id');

El segundo argumento ``join()`` es un string que es usado como condición de unión. Esta es una expresión que
declara un criterio por el cual las filas en una tabla concuerdan con las filas de la otra tabla. Puedes
especificar correlación de nombres en esta expresión.

.. note::

   No se aplica entrecomillado en la expresión especificada para la condición de unión; si tienes problemas con
   nombres que necesitan ser entrecomillados, deberás usar ``quoteIdentifier()`` para formar el string de
   condición de unión.

El tercer argumento ``join()`` es un array de nombres de columnas, como al usar el método ``from()``. Este es por
defecto "***", soporta correlación de nombres, expresiones, y ``Zend_Db_Expr`` de la misma manera que el array de
nombres de columnas en el método ``from()``.

Para no seleccionar columnas de una tabla, use un array vacío para la lista de columnas. El uso de esto trabaja
con el método ``from()`` también, pero en general deseará algunas columnas de la tabla primaria en sus
consultas, a la vez que no se desean columnas de la tabla unida.

.. _zend.db.select.building.join.example-no-columns:

.. rubric:: Ejemplo especificando ninguna columna

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array() ); // empty list of columns

Note el array vacío ``array()`` en el ejemplo anterior en lugar de una lista de columnas de la tabla unida.

SQL tiene muchos tipos de uniones. Vea una lista a continuación para los métodos que soporta cada tipo de unión
en ``Zend_Db_Select``.

- ``INNER JOIN`` con los métodos ``join(table, join, [columns])`` o ``joinInner(table, join, [columns])``.

  Éste es el tipo de unión más comun. Las filas de cada tabla son comparadas usando la condición de unión
  especificada. El resultado incluye solo las filas que satisfacen la condición. El resultado puede ser vacío si
  no hay filas que satisfagan la condición.

  Todos los *RDBMS* soportan este tipo de unión.

- ``LEFT JOIN`` con el método ``joinLeft(table, condition, [columns])``.

  Todas las filas de tabla a la izquierda del operando son incluidas, pareando las filas de la tabla a la derecha
  del operando, y las columnas de la tabla a la derecha del operando son rellenadas con ``NULL``\ s si no existen
  filas que coincidan con la tabla a la izquierda.

  Todos los *RDBMS* soportan este tipo de unión.

- ``RIGHT JOIN`` con el método ``joinRight(table, condition, [columns])``.

  Unión exterior por la derecha es el complementario de la unión exterior por la izquierda. Todas las filas de la
  tabla a la derecha del operando son incluidas, pareando las filas de la tabla a la izquierda del operando
  incluidas, y las columnas de la tabla a la izquierda del operando son rellenadas con ``NULL``\ s si no existen
  filas que coincidan con la tabla de la derecha.

  Algunos *RDBMS* no soportan este tipo de join, pero en general, cualquier unión por la derecha puede
  representarse por una unión por la izquierda invirtiendo el orden de las tablas.

- ``FULL JOIN`` con el método ``joinFull(table, condition, [columns])``.

  Una unión externa total es como una combinación de una unión exterior por la izquierda y una unión exterior
  por la derecha. Todas las filas de ambas tablas son incluidas, vinculadas entre sí en la misma fila si
  satisfacen la condición de unión, y en otro caso, se vinculan con valores ``NULL``'s en lugar de columnas de la
  otra tabla.

  Algunos *RDBMS* no soportan este tipo de unión.

- ``CROSS JOIN`` con el método ``joinCross(table, [columns])``.

  Una unión cruzada es un Producto Cartesiano. Cada fila en la primera tabla es pareada con cada una en la segunda
  tabla. Por lo tanto, el número de filas en el resultado es igual al producto del número de filas en cada tabla.
  Puede filtrar el conjunto de resultados con el uso de condiciones en un cláusula ``WHERE``; de esta forma una
  unión cruzada es similar a la antigua sintaxis de unión en *SQL*-89.

  El método ``joinCross()`` no tiene parámetros para especificar una condición de unión. Algunos *RDBMS* S no
  soportan este tipo de unión.

- ``NATURAL JOIN`` con el método ``joinNatural(table, [columns])``.

  Una unión natural compara cualquier columa(s) que aparezca con el nombre en ambas tablas. La comparación es el
  equivalente de todas las columna(s); comparando las columnas usando desigualdad no es una unión natural. Solo la
  unión interna natural es soportada por este API, aun cuando *SQL* permita una unión externa natural.

  El método ``joinNatural()`` no tiene parámetros para especificar una condición.

Además de los métodos de unión, puede simplificar las consultas usando métodos JoinUsing. En vez de proveer una
condición completa a la unión, simplemente pase el nombre de columna en la que se hará la unión y el objeto
``Zend_Db_Select`` completa la condición.

.. _zend.db.select.building.joinusing.example:

.. rubric:: Ejemplo de método joinUsing()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT *
   //   FROM "table1"
   //   JOIN "table2"
   //   ON "table1".column1 = "table2".column1
   //   WHERE column2 = 'foo'

   $select = $db->select()
                ->from('table1')
                ->joinUsing('table2', 'column1')
                ->where('column2 = ?', 'foo');

Cada uno de los métodos aplicables para uniones en el componente ``Zend_Db_Select`` tiene su correspondiente
método 'using' (usando)

- ``joinUsing(table, join, [columns])`` y ``joinInnerUsing(table, join, [columns])``

- ``joinLeftUsing(table, join, [columns])``

- ``joinRightUsing(table, join, [columns])``

- ``joinFullUsing(table, join, [columns])``

.. _zend.db.select.building.where:

Agregar una cláusula WHERE
^^^^^^^^^^^^^^^^^^^^^^^^^^

Puede especificar un criterio para restringir las filas de resultado usando el método ``where()``. El primer
argumento de este método es una expresión *SQL*, y esta expresión es usada como una expresión *SQL* ``WHERE``
en la consulta.

.. _zend.db.select.building.where.example:

.. rubric:: Ejemplo del método where()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE price > 100.00

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > 100.00');

.. note::

   No se aplica entrecomillado en una expresión dada en el método ``where()`` u ``orWhere()``. Si tiene nombres
   de columnas que necesitan ser entrecomillados, debe usar el método ``quoteIdentifier()`` para formar el string
   de la condición.

El segundo argumento del método ``where()`` es opcional. Es un valor para sustituir en la expresión.
``Zend_Db_Select`` entrecomilla el valor y lo sustituye por un signo de interrogación ("``?``") en la expresión.

Este método acepta solo un parámetro. Si tiene una expresión en la cual necesita sustituir múltiples variables,
deberá formar el string manualmente, interpolando variables y realizando entrecomillado manualmente.

.. _zend.db.select.building.where.example-param:

.. rubric:: Ejemplo de parámetro en el método where()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)

   $minimumPrice = 100;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice);

You can pass an array as the second parameter to the ``where()`` method when using the SQL IN operator.

.. _zend.db.select.building.where.example-array:

.. rubric:: Example of an array parameter in the where() method

.. code-block:: php
   :linenos:

   // Build this query:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (product_id IN (1, 2, 3))

   $productIds = array(1, 2, 3);

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('product_id IN (?)', $productIds);

You can invoke the ``where()`` method multiple times on the same ``Zend_Db_Select`` object. The resulting query
combines the multiple terms together using *AND* between them.

.. _zend.db.select.building.where.example-and:

.. rubric:: Ejemplo de métodos where() múltiples

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)
   //     AND (price < 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice)
                ->where('price < ?', $maximumPrice);

Si necesita combinar terminos usando *OR*, use el método ``orWhere()``. Este método se usa del mismo modo que el
método ``where()``, excepto que el término especificado es precedido por *OR*, en lugar de *AND*.

.. _zend.db.select.building.where.example-or:

.. rubric:: Ejemplo del método orWhere()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00)
   //     OR (price > 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price < ?', $minimumPrice)
                ->orWhere('price > ?', $maximumPrice);

``Zend_Db_Select`` automáticamente pone paréntesis alrededor de cada expresión que especifique usando el método
``where()`` u ``orWhere()``. Esto ayuda a asegurar que la precedencia del operador Booleano no cause resultados
inesperados.

.. _zend.db.select.building.where.example-parens:

.. rubric:: Ejemplos de Expresiones Booleanas con paréntesis

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00 OR price > 500.00)
   //     AND (product_name = 'Apple')

   $minimumPrice = 100;
   $maximumPrice = 500;
   $prod = 'Apple';

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where("price < $minimumPrice OR price > $maximumPrice")
                ->where('product_name = ?', $prod);

En el ejemplo anterior, los resultados deberían ser diferentes sin paréntesis, porque *AND* tiene precedencia
más alta respecto a *OR*. ``Zend_Db_Select`` aplica el parentesis con un efecto tal que la expresión en sucesivas
llamadas al método ``where()`` vincula de forma más fuerte el *AND* que combina las expresiones.

.. _zend.db.select.building.group:

Agregando una cláusula GROUP BY
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En *SQL*, la cláusula ``GROUP BY`` permite reducir el número de filas del resultado de una consulta a una fila
por cada valor único encontrado en la(s) columna(s) nombrada(s) en la cláusula ``GROUP BY``.

En ``Zend_Db_Select``, puede especificar la(s) columna(s) que usar para el cálculo de grupos de filas usando el
método ``group()``. El argumento de este método es una columna o un array de columnas que se usarán en la
cláusula ``GROUP BY``.

.. _zend.db.select.building.group.example:

.. rubric:: Ejemplo del método group()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id');

Como el array de columnas del método ``from()``, se puede usar correlación de nombres en el string de nombre de
columna, y la columna será entrecomillada como un identificador, salvo que el string contenga paréntesis o sea un
objeto de tipo ``Zend_Db_Expr``.

.. _zend.db.select.building.having:

Agregando una cláusula HAVING
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En *SQL*, la cláusula ``HAVING`` aplica una condición de restricción en grupos de filas. Es similar a una
cláusula ``WHERE`` aplicando una condición de restricción a las filas. Pero las 2 cláusulas son diferentes
porque las condiciones ``WHERE`` son aplicadas antes que definan los grupos, mientras que las condiciones
``HAVING`` son aplicadas después que los grupos son definidos.

En ``Zend_Db_Select``, puede especificar condiciones para restringir grupos usando el método ``having()``. Su uso
es similar al del método ``where()``. El primer agumento es un string conteniendo una expresión *SQL*. El segundo
argumento es un valor que es usado para reemplazar un parámetro marcador de posición en la expresión *SQL*. Las
expresiones dadas en multiples invocaciones al método ``having()`` son combinadas usando el operador Booleano
``AND``, o el operador *OR* si usa el método ``orHaving()``.

.. _zend.db.select.building.having.example:

.. rubric:: Ejemplo del método having()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   HAVING line_items_per_product > 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->having('line_items_per_product > 10');

.. note::

   No se aplica entrecomillado a expresiones dadas al método ``having()`` u ``orHaving()``. Si tiene nombres de
   columnas que deban ser entrecomillados, deberá usar ``quoteIdentifier()`` para formar el string de la
   condición.

.. _zend.db.select.building.order:

Agregar una cláusula ORDER BY
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En *SQL*, la cláusula *ORDER BY* especifica una o más columnas o expresiones por el cual el resultado de la
consulta será ordenado. Si multiples columnas son listadas, las columnas secundarias serán usadas para resolver
relaciones; el orden de clasificación es determinado por columnas secundarias si la columna anterior contiene
valores idénticos. El orden por defecto es del menor valor al mayor valor. Puede también ordenar de mayor a menor
valor para una columna dada en la lista espeificando la palabra clave ``DESC`` después de la columna.

En ``Zend_Db_Select``, puede usar el método ``order()`` para especificar una columna o un array de columnas por el
cual ordenar. Cada elemento del array es un string nombrando la columna. Opcionalmente con la palabra reservada
``ASC`` o ``DESC`` siguiendola, separada por un espacio.

Como en el método ``from()`` y ``group()``, los nombres de columnas son entrecomillados como identificadores, a
menos que contengan paréntesis o sean un obheto de tipo ``Zend_Db_Expr``.

.. _zend.db.select.building.order.example:

.. rubric:: Ejemplo del método order()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   ORDER BY "line_items_per_product" DESC, "product_id"

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->order(array('line_items_per_product DESC',
                              'product_id'));

.. _zend.db.select.building.limit:

Agregando una cláusula LIMIT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algunos *RDBMS* extienden una consulta *SQL* con una cláusula conocida como ``LIMIT``. Esta cláusuala reduce el
número de filas en el resultado a no más de un número especificado. También puede especificar saltar el número
de filas antes de empezar la salida. Esta característica hace más fácil tomar un subconjunto de resultados, por
ejemplo cuando mostramos los resultados de una consulta en páginas progresivas de salida.

En ``Zend_Db_Select``, puede usar el método ``limit()`` para especificar la cantidad de filas y el número de
filas que saltar. El **primer** argumento es el método es el número de filas deseado. El **segundo** argument es
el número de filas que saltar.

.. _zend.db.select.building.limit.example:

.. rubric:: Ejemplo del método limit()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20
   // Equivalente  a:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 20 OFFSET 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limit(10, 20);

.. note::

   La sintaxis de ``LIMIT`` no está soportada por todos los *RDBMS* brands. Algunos *RDBMS* requieren diferente
   sintaxis para soportar una funcionalidad similar Cada clase ``Zend_Db_Adapter_Abstract`` incluye un método para
   producir el *SQL* apropiado para cada *RDBMS*.

Use el método ``limitPage()`` como un modo alternativo de especificar la cantidad de filas y el offset. Este
método permite limitar el conjunto resultado a una serie de subconjuntos de tamaño fijo de filas del total del
resultado de la consulta. En otras palabras, puede especificar el tamaño de una "página" de resultados, y el
número ordinal de la página simple donde se espera que devuelva la consulta. El número de página es el primer
argumento del método ``limitPage()``, y la longitud de la página es el segundo argumento. Ambos son argumentos
requeridos; no tienen valores por omisión.

.. _zend.db.select.building.limit.example2:

.. rubric:: Ejemplo del método limitPage()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limitPage(2, 10);

.. _zend.db.select.building.distinct:

Agregar el modificador DISTINCT a la consulta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El método ``distinct()`` permite agregar la palabra clave a la consulta ``DISTINCT`` a su consulta *SQL*.

.. _zend.db.select.building.distinct.example:

.. rubric:: Ejemplo del método distinct()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT DISTINCT p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->distinct()
                ->from(array('p' => 'products'), 'product_name');

.. _zend.db.select.building.for-update:

Agregar el modificador FOR UPDATE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El método ``forUpdate()`` permite agregar el modificador *FOR UPDATE* a su consulta *SQL*.

.. _zend.db.select.building.for-update.example:

.. rubric:: Example of forUpdate() method

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT FOR UPDATE p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->forUpdate()
                ->from(array('p' => 'products'));

.. _zend.db.select.building.union:

Building a UNION Query
^^^^^^^^^^^^^^^^^^^^^^

You can build union queries with ``Zend_Db_Select`` by passing an array of ``Zend_Db_Select`` or SQL Query strings
into the ``union()`` method. As second parameter you can pass the ``Zend_Db_Select::SQL_UNION`` or
``Zend_Db_Select::SQL_UNION_ALL`` constants to specify which type of union you want to perform.

.. _zend.db.select.building.union.example:

.. rubric:: Example of union() method

.. code-block:: php
   :linenos:

   $sql1 = $db->select();
   $sql2 = "SELECT ...";

   $select = $db->select()
       ->union(array($sql1, $sql2))
       ->order("id");

.. _zend.db.select.execute:

Ejecutando consultas Select
---------------------------

En esta sección se describe cómo ejecutar una consulta representada por un objeto ``Zend_Db_Select``.

.. _zend.db.select.execute.query-adapter:

Ejecutando Consultas SelectExecuting desde el Adaptador de Base de Datos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Puede ejecutar la consulta representada por el objeto ``Zend_Db_Select`` pasándolo como primer argumento al
método ``query()`` de un objeto ``Zend_Db_Adapter_Abstract``. Use objetos ``Zend_Db_Select`` en lugar de un string
de consulta.

El método ``query()`` devuelve un objeto de tipo ``Zend_Db_Statement`` o PDOStatement, dependiendo del tipo de
adaptador.

.. _zend.db.select.execute.query-adapter.example:

.. rubric:: Ejemplo usando el método adaptador query() del Adaptador de Base de datos

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $db->query($select);
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.query-select:

Ejecutando Consultas Select desde el Objeto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Como alternativa al uso del método ``query()`` del objeto adaptador, puede usar el método ``query()`` del objeto
``Zend_Db_Select``. Ambos métodos devuelven un objeto de tipo ``Zend_Db_Statement`` o PDOStatement, dependiendo
del tipo de adaptador.

.. _zend.db.select.execute.query-select.example:

.. rubric:: Ejempo usando el método query() del objeto Select

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $select->query();
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.tostring:

Convertiendo un Objeto Select a un String SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si necesita acceder a una represantación en un string de la consulta *SQL* correspondiente al objeto
``Zend_Db_Select``, use el método ``__toString()``.

.. _zend.db.select.execute.tostring.example:

.. rubric:: Ejemplo del método \__toString()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $sql = $select->__toString();
   echo "$sql\n";

   // La salida es el string:
   //   SELECT * FROM "products"

.. _zend.db.select.other:

Otros Métodos
-------------

Esta sección describe otros métodos de ``Zend_Db_Select`` que no han sido cubiertos antes: ``getPart()`` y
``reset()``.

.. _zend.db.select.other.get-part:

Obtener Partes de un Objeto Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El método ``getPart()`` devuelve una representación de una parte de su consulta *SQL*. Por ejemplo, puede usar
este método para devolver un array de expresiones para la cláusula ``WHERE``, o el array de columnas (o
expresiones de columnas) que estan en la lista del ``SELECT``, o los valores de la cantidad y comienzo para la
cláusula ``LIMIT``.

El valor de retorno no es un string conteniendo un fragmento de la sintaxis *SQL*. El valor de retorno es una
representación, típicamente un array con una estructura que contiene valores y expresiones. Cada parte de la
consulta tiene una estructura diferente.

El único argumento del método ``getPart()`` es un string que identifica qué parte del la consulta Select va a
devolver. Por ejemplo, el string *'from'* identifica la parte del objeto Select que almacena la información de las
tablas de la cláusula ``FROM``, incluyendo uniones de tablas.

La clase ``Zend_Db_Select`` define constantes que puedes usar para las partes de la consulta *SQL*. Puede usar
estas definiciones de constantes, o los strings literales.

.. _zend.db.select.other.get-part.table:

.. table:: Constantes usedas por getPart() y reset()

   +----------------------------+----------------+
   |Constante                   |Valor del String|
   +============================+================+
   |Zend_Db_Select::DISTINCT    |'distinct'      |
   +----------------------------+----------------+
   |Zend_Db_Select::FOR_UPDATE  |'forupdate'     |
   +----------------------------+----------------+
   |Zend_Db_Select::COLUMNS     |'columns'       |
   +----------------------------+----------------+
   |Zend_Db_Select::FROM        |'from'          |
   +----------------------------+----------------+
   |Zend_Db_Select::WHERE       |'where'         |
   +----------------------------+----------------+
   |Zend_Db_Select::GROUP       |'group'         |
   +----------------------------+----------------+
   |Zend_Db_Select::HAVING      |'having'        |
   +----------------------------+----------------+
   |Zend_Db_Select::ORDER       |'order'         |
   +----------------------------+----------------+
   |Zend_Db_Select::LIMIT_COUNT |'limitcount'    |
   +----------------------------+----------------+
   |Zend_Db_Select::LIMIT_OFFSET|'limitoffset'   |
   +----------------------------+----------------+

.. _zend.db.select.other.get-part.example:

.. rubric:: Ejemplo del método getPart()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products')
                ->order('product_id');

   // Puede especificar un string literal para especificar la parte
   $orderData = $select->getPart( 'order' );

   // Puede usar una constante para especificar la misma parte
   $orderData = $select->getPart( Zend_Db_Select::ORDER );

   // El valor de retorno puede ser una estructura en un array, no un string.
   // Cada parte tiene distinta estructura.
   print_r( $orderData );

.. _zend.db.select.other.reset:

Restableciendo Partes de un Objeto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El método ``reset()`` permite limpiar una parte específica de la consulta *SQL*, o limpia todas las partes de la
consulta *SQL* si omite el argumento.

El argumento es opcional. Puede especificar la parte de la consulta que será limpiada, usando los mismos strings
que usa el argumento del método ``getPart()``. La parte de la consulta que especifique se reestablecerá a su
estado por omisión.

Si omite el parámetro, ``reset()`` cambia todas las partes de la consulta a su estado por omisión. Esto hace que
el objeto ``Zend_Db_Select`` sea equivalente a crear un nuevo objeto, como si acabase de instanciarlo.

.. _zend.db.select.other.reset.example:

.. rubric:: Ejemplo del método reset()

.. code-block:: php
   :linenos:

   // Construya esta consulta:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_name"

   $select = $db->select()
                ->from(array('p' => 'products')
                ->order('product_name');

   // Requisito cambiado, en su lugar un orden diferente de columnas:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_id"

   // Limpia una parte para poder redefinirla
   $select->reset( Zend_Db_Select::ORDER );

   // Y especificar una columna diferente
   $select->order('product_id');

   // Limpia todas las partes de la consulta
   $select->reset();


