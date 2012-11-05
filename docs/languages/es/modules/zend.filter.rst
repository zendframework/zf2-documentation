.. EN-Revision: none
.. _zend.filter.introduction:

Introducción
============

El componente ``Zend_Filter`` proporciona un conjunto de filtros de datos comúnmente necesarios. También
proporciona un sencillo mecanismo de encadenar varios filtros que se puedan aplicar a un solo dato en un orden
definido por el usuario.

.. _zend.filter.introduction.definition:

¿Qué es un filtro?
------------------

En el mundo físico, un filtro se suele utilizar para eliminar partes no deseadas de lo ingresado, y la vez lo
ingresado pasa a través de un filtro de salida (por ejemplo, el café). En este caso, un filtro es un operador que
devuelve una parte de los datos de entrada. Este tipo de filtro es útil para aplicaciones web, para la supresión
de entradas ilegales y/o que no se ajustan, eliminación de los espacios en blanco innecesarios, etc

Esta definición básica de un filtro puede ser extendido para incluir transformaciones generalizadas sobre la
entrada. Una transformación común requerida en las aplicaciones web es la de escapar las entidades *HTML*. Por
ejemplo, si un campo del formulario es completado automáticamente y contiene datos no verificados (por ejemplo,
datos ingresados desde un navegador web), este valor debe estar libre de las entidades *HTML* o sólo contener
entidades *HTML* de forma escapada, a fin de evitar comportamientos no deseados y vulnerabilidades de seguridad.
Para cumplir este requerimiento, las entidades *HTML* que aparecen en los datos introducidos deben ser suprimidos o
escapados. Por supuesto, el enfoque más adecuado depende del contexto y de la situción. Un filtro que quita las
entidades *HTML* funciona dentro del ámbito o alcance de la primera definición del filtro - un operador que
produce un subconjunto de la entrada. Un filtro que escapa a las entidades *HTML*, sin embargo, transforma la
entrada (por ejemplo, "*&*" se transforma en "*&amp;*"). El Apoyo a los casos de uso como para la web los
desarrolladores es importante, y "filtrar", en el contexto de la utilización de ``Zend_Filter``, los medios para
realizar algunas transformaciones en los datos de entrada.

.. _zend.filter.introduction.using:

Uso básico de los filtros
-------------------------

Having this filter definition established provides the foundation for ``Zend\Filter\Interface``, which requires a
single method named ``filter()`` to be implemented by a filter class.

Following is a basic example of using a filter upon two input data, the ampersand (*&*) and double quote (*"*)
characters:

   .. code-block:: php
      :linenos:

      $htmlEntities = new Zend\Filter\HtmlEntities();

      echo $htmlEntities->filter('&'); // &
      echo $htmlEntities->filter('"'); // "



.. _zend.filter.introduction.static:

Usando el método estático staticFilter()
----------------------------------------

If it is inconvenient to load a given filter class and create an instance of the filter, you can use the static
method ``Zend\Filter\Filter::filterStatic()`` as an alternative invocation style. The first argument of this method is a
data input value, that you would pass to the ``filter()`` method. The second argument is a string, which
corresponds to the basename of the filter class, relative to the Zend_Filter namespace. The ``staticFilter()``
method automatically loads the class, creates an instance, and applies the ``filter()`` method to the data input.

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::filterStatic('&', 'HtmlEntities');



You can also pass an array of constructor arguments, if they are needed for the filter class.

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::filterStatic('"', 'HtmlEntities', array(ENT_QUOTES));



The static usage can be convenient for invoking a filter ad hoc, but if you have the need to run a filter for
multiple inputs, it's more efficient to follow the first example above, creating an instance of the filter object
and calling its ``filter()`` method.

Also, the ``Zend\Filter\Input`` class allows you to instantiate and run multiple filter and validator classes on
demand to process sets of input data. See :ref:` <zend.filter.input>`.

.. _zend.filter.introduction.static.namespaces:

Namespaces
^^^^^^^^^^

When working with self defined filters you can give a forth parameter to ``Zend\Filter\Filter::filterStatic()`` which is
the namespace where your filter can be found.

.. code-block:: php
   :linenos:

   echo Zend\Filter\Filter::filterStatic(
       '"',
       'MyFilter',
       array($parameters),
       array('FirstNamespace', 'SecondNamespace')
   );

``Zend_Filter`` allows also to set namespaces as default. This means that you can set them once in your bootstrap
and have not to give them again for each call of ``Zend\Filter\Filter::filterStatic()``. The following code snippet is
identical to the above one.

.. code-block:: php
   :linenos:

   Zend\Filter\Filter::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   echo Zend\Filter\Filter::filterStatic('"', 'MyFilter', array($parameters));
   echo Zend\Filter\Filter::filterStatic('"', 'OtherFilter', array($parameters));

For your convinience there are following methods which allow the handling of namespaces:

- **Zend\Filter\Filter::getDefaultNamespaces()**: Returns all set default namespaces as array.

- **Zend\Filter\Filter::setDefaultNamespaces()**: Sets new default namespaces and overrides any previous set. It accepts
  eighter a string for a single namespace of an array for multiple namespaces.

- **Zend\Filter\Filter::addDefaultNamespaces()**: Adds additional namespaces to already set ones. It accepts eighter a
  string for a single namespace of an array for multiple namespaces.

- **Zend\Filter\Filter::hasDefaultNamespaces()**: Returns ``TRUE`` when one or more default namespaces are set, and
  ``FALSE`` when no default namespaces are set.


