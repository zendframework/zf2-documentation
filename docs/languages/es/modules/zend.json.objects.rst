.. EN-Revision: none
.. _zend.json.advanced:

Uso Avanzado de Zend_Json
=========================

.. _zend.json.advanced.objects1:

Objetos JSON
------------

Cuando se codifican objetos *PHP* como *JSON*, todas las propiedades públicas de ese objeto serán codificadas en
un objeto *JSON*.

*JSON* no permite referencias a objetos, de manera que debe tenerse cuidado de no codificar objetos con referencias
recursivas. Si tiene problemas con la recursión, ``Zend\Json\Json::encode()`` y ``Zend\Json\Encoder::encode()``
permiten un segundo parámetro opcional para comprobar si hay recursión; si un objeto es serializado dos veces, se
emitirá una excepción.

La decodificación de objetos *JSON* plantea una dificultad adicional, sin embargo, ya que los objetos Javascript
se corresponden más estrechamente a un array asociativo de *PHP*. Algunos sugieren que debe pasarse un
identificador de clase, y una instancia del objeto de esa clase debe crearse y alimentarla con datos de pares
clave/valor del objeto *JSON*; otros consideran que esto podría plantear un considerable riesgo de seguridad.

Por defecto, ``Zend_Json`` decodificará objetos *JSON* como arrays asociativos. Sin embargo, si desea retornar un
objeto, puede especificar esto:

.. code-block:: php
   :linenos:

   // Decodifica objetos JSON como objetos PHP
   $phpNative = Zend\Json\Json::decode($encodedValue, Zend\Json\Json::TYPE_OBJECT);

Por lo tanto, cualquiera de los objetos decodificados son devueltos como objetos ``stdClass`` con propiedades
correspondientea a pares clave/valor en la notación *JSON*.

La recomendación de Zend Framework es que el desarrollador debe decidir cómo decodificar objetos *JSON*. Si debe
crearse un objeto de un determinado tipo, puede ser creado en el código del desarrollador y alimentado con datos
de los valores decodificados utilizando ``Zend_Json``.

.. _zend.json.advanced.objects2:

Codificando Objetos PHP
-----------------------

Si se codifican objetos *PHP* por defecto, el mecanismo de codificación sólo tiene acceso a las propiedades
públicas de estos objetos. Cuando se implementa un método ``toJson()`` en un objeto a codificar, ``Zend_Json``
llama a este método y espera que el objeto devuelva una representación *JSON* de su estado interno.

.. _zend.json.advanced.internal:

Codificador/Decodificador Interno
---------------------------------

Zend_Json tiene dos modos diferentes dependiendo de si ext/json está habilitada o no en su instalación *PHP*. Si
ext/json está instalado por defecto, las funciones ``json_encode()`` y ``json_decode()`` se utilizan para la
codificación y decodificación *JSON*. Si ext/json no está instalado, una implementación de Zend Framework en
código *PHP* es utilizada para la codificación/decodificación. Esto es considerablemente más lento que usando
la extensión de *PHP*, pero se comporta exactamente igual.

También algunas veces puede querer utilizar el codificador/decodificador interno incluso si tiene ext/json
instalado. Puede hacer esto llamando a:

.. code-block:: php
   :linenos:

   Zend\Json\Json::$useBuiltinEncoderDecoder = true:

.. _zend.json.advanced.expr:

Expresiones JSON
----------------

Javascript hace uso intenso de las funciones anónimas de llamadas de retorno, que pueden guardarse en variables
del objeto *JSON*. Aunque solo funcionan si no regresaron dentro comillas dobles, que es lo que hace naturalmente
``Zend_Json``. Con la Expression de apoyo para Zend_Json este apoyo puede codificar objetos *JSON* con callbacks
validos de javascript. Esto funciona tanto con ``json_encode()`` como con el codificador interno.

Un callback javascript se representa usando el objeto ``Zend\Json\Expr``. Este implementa el patrón del objeto
valor y es inmutable. Se puede establecer la expresión de javascript como el primer argumento del constructor. Por
defecto ``Zend\Json\Json::encode`` no codifica callbacks javascript, usted tiene que pasar la opción
``'enableJsonExprFinder' = true`` dentro de la función ``encode``. Si se habilita, la expresión de apoyo trabaja
para todas las expresiones anidadas en grandes estructuras de objetos. Un ejemplo de uso se vería así:

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend\Json\Expr('function() {'
                 . 'alert("Yo soy un callback válido de javascript '
                 . 'creado por Zend_Json"); }'),
       'other' => 'sin expresión',
   );
   $jsonObjectWithExpression = Zend\Json\Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


