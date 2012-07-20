.. _zend.db.statement:

Zend_Db_Statement
=================

Además de algunos métodos convenientes tales como ``fetchAll()`` e ``insert()`` documentados en :ref:`
<zend.db.adapter>`, puede usarse un objeto de declaración para obtener más opciones al ejecutar consultas y
devolver conjuntos de resultados. Esta sección describe cómo obtener una instancia de un objeto de declaración y
cómo usar sus métodos.

``Zend_Db_Statement`` está basado en el objeto PDOStatement en la extensión `PHP Data Objects`_.

.. _zend.db.statement.creating:

Creando una Declaración
-----------------------

Típicamente, un objeto de declaración statement es devuelto por el método ``query()`` de la clase de Adaptador
de la base de datos. Este método es un modo general de preparar una declaración *SQL*. El primer parámetro es un
string conteniendo la declaración *SQL*. El segundo parámetro (opcional) es un array de valores para vincular
posiciones de parámetros en el string *SQL*.

.. _zend.db.statement.creating.example1:

.. rubric:: Crear un objeto de declaración SQL con query()

.. code-block:: php
   :linenos:

   $stmt = $db->query(
               'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?',
               array('goofy', 'FIXED')
           );

El objeto de declaración corresponde a una declaración *SQL* que ha sido preparada y ejecutada una vez con
valores vinculados especificados. Si la declaración fue una consulta SELECT u otro tipo de declaración que
devuelve un conjunto de resultados, ahora estará lista para extraer resultados.

Puede crear una declaración con su constructor, pero éste es un uso menos típico. No hay un método factory para
crear el objeto, así que es necesario cargar una clase de declaración específica y llamar a su constructor. Pase
el objeto Adaptador como el primer parámetro, y un string conteniendo la declaración *SQL* como el segundo
parámetro. La declaración es preparada pero no ejecutada.

.. _zend.db.statement.creating.example2:

.. rubric:: Usando un constructor de declaración SQL

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

.. _zend.db.statement.executing:

Ejecutando la declaración
-------------------------

Necesita ejecutar un objeto de declaración si lo crea con el constructor, o si desea ejecutar la misma
declaración varias veces. Use el método ``execute()`` del mismo objeto de declaración. El único parámetro es
un array de valores a vincular a posiciones de parámetros en la declaración.

Si usa **parámetros posicionales**, o los que están marcados por un signo de interrogación (**?**), pase los
valores de vinculación en un array plano.

.. _zend.db.statement.executing.example1:

.. rubric:: Ejecutar una declaración con parámetros posicionales

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array('goofy', 'FIXED'));

Si usa **parámetros nombrados**, o los que son indicados por un string identificador precedido por un caracter de
dos puntos (**:**), pase el valor en un array asociativo. Las claves de este array deben coincidir con el nombre de
los parámetros.

.. _zend.db.statement.executing.example2:

.. rubric:: Ejecutando una declaración con parámetros nombrados

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE ' .
          'reported_by = :reporter AND bug_status = :status';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array(':reporter' => 'goofy', ':status' => 'FIXED'));

Las declaraciones *PDO* soportan tanto parámetros posicionales como parámetros nombrados, pero no ambos tipos en
la misma declaración *SQL*. Algunas clases ``Zend_Db_Statement`` para extensiones no-PDO soportan solo un tipo de
parámetro o el otro.

.. _zend.db.statement.fetching:

Extrayendo Resultados de una declaración SELECT
-----------------------------------------------

Puede llamar a métodos del objeto de declaración para obtener filas desde declaraciones *SQL* que producen
conjuntos de resultados. SELECT, SHOW, DESCRIBE y EXPLAIN son ejemplos de declaraciones que producen un conjunto de
resultados. INSERT, UPDATE, and DELETE son ejemplo de declaraciones que no producen un conjunto de resultados.
Puede ejecutar las últimas declaraciones de *SQL* usando ``Zend_Db_Statement``, pero no puede llamar a los
métodos que extraen filas de resultados desde éste.

.. _zend.db.statement.fetching.fetch:

Extrayendo una Fila Simple desde un Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para extraer una fila desde el conjunto de resultados, use el método ``fetch()`` del objeto de declaración. Los
tres parámetros de este método son opcionales:

- **Estilo de Extracción** es el primer parámetro. Éste controla la estructura en la que será devuelta la fila.
  Vea :ref:` <zend.db.adapter.select.fetch-mode>` para la descripción de un valor válido los correspondientes
  formatos de datos.

- **Orientación del Cursor** es el segundo parámetro. Por omisión es Zend_Db::FETCH_ORI_NEXT, lo cual
  simplemente significa que cada llamada a ``fetch()`` devuelve la siguiente fila del resultado, en el orden
  devuelto por el *RDBMS*.

- **Compensación** es el tercer parámetro. Si la orientación del cursor es Zend_Db::FETCH_ORI_ABS, entonces el
  offset es el número ordinal de las filas que devolver. Si la orientación del cursor es Zend_Db::FETCH_ORI_REL,
  entonces el offset es relativo a la posición del cursor antes de que ``fetch()`` fuera llamado.

``fetch()`` devuelve ``FALSE`` si todas las filas del conjunto de resultados han sido extraídas.

.. _zend.db.statement.fetching.fetch.example:

.. rubric:: Usando fetch() en un bucle

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   while ($row = $stmt->fetch()) {
       echo $row['bug_description'];
   }

Vea también `PDOStatement::fetch()`_.

.. _zend.db.statement.fetching.fetchall:

Extrayendo un Conjunto de Resultados completo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para extraer todas las filas de un resultado en un solo paso, use el método ``fetchAll()``. Esto es equivalente a
llamar al método ``fetch()`` en un bucle devolviendo todas las filas en una array. El método ``fetchAll()``
acepta 2 parámetros. El primero es el estilo de extracción, descrito anteriormente, y el segundo indica el
número de la columa que devolver, cuando el estilo de extracción es Zend_Db::FETCH_COLUMN.

.. _zend.db.statement.fetching.fetchall.example:

.. rubric:: Usando fetchAll()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $rows = $stmt->fetchAll();

   echo $rows[0]['bug_description'];

Vea también `PDOStatement::fetchAll()`_.

.. _zend.db.statement.fetching.fetch-mode:

Cambiando el Modo de extracción
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Por defecto, el objeto de declaración devuelve filas de un conjunto de resultados como array asociativo, mapeando
los nombres de columnas a los valores de la columna. Se puede especificar un formato diferente para que la clase de
declaración devuelva las filas, tal como se puede con la clase Adaptadora. Puede usar él método
``setFetchMode()`` para establecer el modo de extracción. Especifique el modo de extracción usando las constantes
de la clase Zend_Db: FETCH_ASSOC, FETCH_NUM, FETCH_BOTH, FETCH_COLUMN, and FETCH_OBJ. Vea :ref:`
<zend.db.adapter.select.fetch-mode>` para más información de estos modos. Llamadas subsiguientes a los métodos
de la declaración ``fetch()`` o ``fetchAll()`` usan el modo de extracción especificado.

.. _zend.db.statement.fetching.fetch-mode.example:

.. rubric:: Configurando un modo de extracción

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $stmt->setFetchMode(Zend_Db::FETCH_NUM);

   $rows = $stmt->fetchAll();

   echo $rows[0][0];

Vea también `PDOStatement::setFetchMode()`_.

.. _zend.db.statement.fetching.fetchcolumn:

Extrayendo una Única Columna desde un Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para devolver una única columna de la siguiente fila del conjunto de resultados, use ``fetchColumn()``. El
parámetro opcional es el índice de la columna (integer), y por defecto es 0. Este método devuelve un valor
escalar, o ``FALSE`` si todas las filas del conjunto de resultados han sido extraídas.

Note que este método opera diferente que el método ``fetchCol()`` de la clase Adaptadora. El método
``fetchColumn()`` de una declaración devuelve un único valor desde una fila. El método ``fetchCol()`` de un
adaptador devuelve un array de valores, tomados desde la primera columa de todas las del conjunto de resultados.

.. _zend.db.statement.fetching.fetchcolumn.example:

.. rubric:: Usando fetchColumn()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $bug_status = $stmt->fetchColumn(2);

Vea también `PDOStatement::fetchColumn()`_.

.. _zend.db.statement.fetching.fetchobject:

Extrayendo una Fila como un Objeto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para extraer una fila desde un conjunto de resultados estructurado como un Objeto, use el método
``fetchObject()``. Este método tiene 2 parámetros opcionales. El primer parámetro es un string con el nombre de
la clase del objeto que devolver; por defecto será 'stdClass'. El segundo parámetro es un array de valores que
será pasado al constructor de la clase.

.. _zend.db.statement.fetching.fetchobject.example:

.. rubric:: Usando fetchObject()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $obj = $stmt->fetchObject();

   echo $obj->bug_description;

Vea también `PDOStatement::fetchObject()`_.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`PDOStatement::fetch()`: http://www.php.net/PDOStatement-fetch
.. _`PDOStatement::fetchAll()`: http://www.php.net/PDOStatement-fetchAll
.. _`PDOStatement::setFetchMode()`: http://www.php.net/PDOStatement-setFetchMode
.. _`PDOStatement::fetchColumn()`: http://www.php.net/PDOStatement-fetchColumn
.. _`PDOStatement::fetchObject()`: http://www.php.net/PDOStatement-fetchObject
