.. _user-guide.routing-and-controllers:

############################
Enrutamiento y controladores
############################

Vamos a construir un sistema de inventario muy simple para mostrar nuestra
colección de albums. La página de inicio va a listar nuestra colección y nos va a permitir añadir, editar y
eliminar albums. De ahí que las páginas requeridas sean las siguientes:

+-----------------+--------------------------------------------------------------+
| Página          | Descripción                                                  |
+=================+==============================================================+
| Inicio          | Mostrará el listado de discos y proveerá enlaces para        |
|                 | editarlos y modificarlos. Además, proveerá un enlace para    |
|                 | añadir nuevos albums.                                        |
+-----------------+--------------------------------------------------------------+
| Añadir album    | Esta página proveerá un formulario para añadir un album.     |
+-----------------+--------------------------------------------------------------+
| Editar album    | Esta página proveerá un formulario para editar un album.     |
+-----------------+--------------------------------------------------------------+
| Eliminar album  | Esta página confirmará que queremos eliminar un album y      |
|                 | después se eliminará.                                        |
+-----------------+--------------------------------------------------------------+

Antes de comenzar a montar nuestros archivos, es importante entender como espera el
framework que las páginas estén organizadas. Cada página de la aplicación es conocida como una
*acción* y las acciones están agrupadas dentro de *controladores* contenidos en *módulos*.
De esta forma, agrupará generalmente acciones relacionadas dentro de un mismo controlador;
por ejemplo, un controlador de noticias debería tener acciones ``current``, ``archived`` y ``view``.

Como tenemos cuatro páginas que están todas relacionadas con albums, vamos a agruparlas en un controlador
único ``AlbumController`` dentro de nuestro módulo ``Album`` como cuatro acciones.
Las cuatro acciones serán:

+-----------------+---------------------+------------+
| Página          | Controlador         | Acción     |
+=================+=====================+============+
| Inicio          | ``AlbumController`` | ``index``  |
+-----------------+---------------------+------------+
| Añadir album    | ``AlbumController`` | ``add``    |
+-----------------+---------------------+------------+
| Editar album    | ``AlbumController`` | ``edit``   |
+-----------------+---------------------+------------+
| Eliminar album  | ``AlbumController`` | ``delete`` |
+-----------------+---------------------+------------+

El mapeo de una URL a una acción particular se realiza utilizando rutas definidas
en el archivo ``module.config.php`` del módulo. Añadiremos una ruta para nuestras
acciones de album. Este es el archivo de configuración actualizado, con el nuevo código comentado.

.. code-block:: php

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        
        // La siguiente sección es nueva y debería ser añadida a su fichero
        'router' => array(
            'routes' => array(
                'album' => array(
                    'type'    => 'segment',
                    'options' => array(
                        'route'    => '/album[/:action][/:id]',
                        'constraints' => array(
                            'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                            'id'     => '[0-9]+',
                        ),
                        'defaults' => array(
                            'controller' => 'Album\Controller\Album',
                            'action'     => 'index',
                        ),
                    ),
                ),
            ),
        ),

        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

El nombre de la ruta es ´album´ y tiene un tipo de ´segmento´. La ruta del segmento
nos permite especificar lugares de almacenamiento en el patrón URL que serán mapeados
a los parámetros nombrados en la ruta. En este caso, la ruta es
**``/album[/:action][/:id]``** que coincidirá con cualquier ruta que comience con
``/album``. El siguiente segmento será un id opcional. Los corchetes indican
que un segmento es opcional. La sección de restricciones nos permite asegurar que los
caracteres dentro de un segmento son los esperados, por lo que limitamos las acciones a
comenzar con una letra y posteriormente solo caracteres alfanuméricos,
guiones bajos o guiones simples. También limitamos el id a un número.

Esta ruta nos permite tener las siguientes URLs:

+---------------------+------------------------------+------------+
| URL                 | Página                       | Acción     |
+=====================+==============================+============+
| ``/album``          | Inicio (Lista de albums)     | ``index``  |
+---------------------+------------------------------+------------+
| ``/album/add``      | Añadir nuevo album           | ``add``    |
+---------------------+------------------------------+------------+
| ``/album/edit/2``   | Editar album con id 2        | ``edit``   |
+---------------------+------------------------------+------------+
| ``/album/delete/4`` | Eliminar album con id 4      | ``delete`` |
+---------------------+------------------------------+------------+

Crear el controlador
====================

Ahora estamos listos para comenzar a montar nuestro controlador. En Zend Framework 2, el controlador
es una clase generalmente llamada ``{Controller name}Controller``. Note que
``{Controller name}`` debe empezar con una letra mayúscula. Esta clase reside en un archivo
llamado ``{Controller name}Controller.php`` dentro del directorio ``Controller`` del
módulo. En nuestro caso es ``module/Album/src/Album/Controller``. Cada acción es
un método público dentro de la clase controlador llamado ``{action name}Action``.
En este caso ``{action name}`` debe comenzar con una letra minúscula.

.. note::

    Esto es por convención. Zend Framework 2 no provee demasiadas
    restricciones en los controladores además del deber de implementar la
    interfaz ``Zend\Stdlib\Dispatchable``. El framework provee dos clases
    abstractas que hacen esto por nosotros: ``Zend\Mvc\Controller\AbstractActionController``
    y ``Zend\Mvc\Controller\AbstractRestfulController``. Nosotros utilizaremos el
    ``AbstractActionController`` estándar, pero si lo que pretende es escribir un
    servicio web con REST, ``AbstractRestfulController`` podría serle útil.

Sigamos adelante y creemos nuestra clase controlador:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    namespace Album\Controller;

    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    
    class AlbumController extends AbstractActionController
    {
        public function indexAction()
        {
        }
    
        public function addAction()
        {
        }
    
        public function editAction()
        {
        }
    
        public function deleteAction()
        {
        }
    }

.. note::

    Ya hemos informado al módulo acerca de nuestro controlador en la
    sección ‘controller’ de ``config/module.config.php``.

Ahora tenemos montadas las cuatro acciones que queremos utilizar. No funcionarán aún
hasta que montemos las vistas. Las URLs para cada acción son:

+--------------------------------------------+----------------------------------------------------+
| URL                                        | Método llamado                                     |
+============================================+====================================================+
| http://zf2-tutorial.localhost/album        | ``Album\Controller\AlbumController::indexAction``  |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/add    | ``Album\Controller\AlbumController::addAction``    |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/edit   | ``Album\Controller\AlbumController::editAction``   |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/delete | ``Album\Controller\AlbumController::deleteAction`` |
+--------------------------------------------+----------------------------------------------------+

Ahora tenemos un router funcionando y las acciones están montadas para cada una de las páginas de nuestra
aplicación.

Es el momento de construir las vistas y el modelo.

Inicializar los scripts de vista
--------------------------------

Para integrar la vista en nuestra aplicación todo lo que necesitamos hacer es crear algunos
ficheros script de vista. Estos ficheros serán ejecutados por ``DefaultViewStrategy`` y serán
pasados cualquier variable o modelo de vista que sean devueltos desde el método acción del
controlador. Estos scripts de vista están almacenados en nuestro directorio de vistas del módulo dentro de un
directorio llamado como el controlador. Cree ahora estos cuatro archivos vacíos:

* ``module/Album/view/album/album/index.phtml``
* ``module/Album/view/album/album/add.phtml``
* ``module/Album/view/album/album/edit.phtml``
* ``module/Album/view/album/album/delete.phtml``

Ahora podemos comenzar a completar todo, comenzando por nuestra base de datos y los modelos.