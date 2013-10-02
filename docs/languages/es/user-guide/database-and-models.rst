.. _user-guide.database-and-models:

#######################
Base de Datos y Modelos 
#######################

La base de datos
----------------

Ahora que tenemos configurado el módulo ``Album`` con el controlador, acciones y vistas, 
es momento de mirar el modelo de nuestra aplicación. Recuerda que el modelo es la parte 
central de la aplicación (conocido como “reglas de negocio“) y, 
en nuestro caso, se refiere a la base de datos. Haremos uso de la
clase ``Zend\Db\TableGateway\TableGateway`` de Zend Framework que se utiliza para buscar, 
agregar, actualizar y eliminar filas de una tabla de una base de datos.


Nosotros vamos a utilizar MySQL, a través del driver PDO de PHP, para crear una 
base de datos llamada ``zf2tutorial`` y ejecutar las siguientes sentencias SQL 
para crear la tabla album con algunos datos.

.. code-block:: sql

    CREATE TABLE album (
      id int(11) NOT NULL auto_increment,
      artist varchar(100) NOT NULL,
      title varchar(100) NOT NULL,
      PRIMARY KEY (id)
    );
    INSERT INTO album (artist, title)
        VALUES  ('The  Military  Wives',  'In  My  Dreams');
    INSERT INTO album (artist, title)
        VALUES  ('Adele',  '21');
    INSERT INTO album (artist, title)
        VALUES  ('Bruce  Springsteen',  'Wrecking Ball (Deluxe)');
    INSERT INTO album (artist, title)
        VALUES  ('Lana  Del  Rey',  'Born  To  Die');
    INSERT INTO album (artist, title)
        VALUES  ('Gotye',  'Making  Mirrors');

(La datos de prueba elegida, fueron el listado de Bestsellers de 
Amazon UK al momento de escribir la versión de este tutorial)

Ahora tenemos algunos datos en nuestra base de datos y podemos escribir 
un modelo muy simple para esto.

Los archivos del modelo 
-----------------------

Zend Framework no proporciona un componente Zend\Model puesto que el modelo 
es la lógica de negocio y te toca decidir cómo quieres que funcione. Hay muchos 
componentes que puedes utilizar dependiendo de tus necesidades. Un enfoque consiste 
en tener clases del modelo que representen a cada entidad de tu aplicación y luego 
usar objetos de mapeo para cargar y guardar las entidades en la base de datos. 
Otra es utilizar un ORM como Doctrine o Propel.


Para este tutorial, vamos a crear un modelo muy simple mediante la creación de 
una clase ``AlbumTable`` que hereda de ``Zend\Db\TableGateway\TableGateway`` donde cada 
objeto album es un objeto de ``Album`` (conocido como una *entidad*). Esto es una 
implementación del patrón de diseño Table Data Gateway el cual permite la interconexión 
con los datos de una tabla de la base de datos. Ten en cuenta que el patrón 
Table Data Gateway puede llegar a ser limitante en sistemas más grandes. 
También existe la tentación de poner el código de acceso a la base de datos 
en los métodos Action del controlador ya que están expuestos por ``Zend\Db\TableGateway\AbstractTableGateway``. 
¡No me hagas esto!

Vamos a empezar con nuestra clase ``Album`` que se encuentra dentro del directorio ``Model``:

.. code-block:: php

    // module/Album/src/Album/Model/Album.php:
    namespace Album\Model;

    class Album
    {
        public $id;
        public $artist;
        public $title;

        public function exchangeArray($data)
        {
            $this->id     = (isset($data['id'])) ? $data['id'] : null;
            $this->artist = (isset($data['artist'])) ? $data['artist'] : null;
            $this->title  = (isset($data['title'])) ? $data['title'] : null;
        }
    }

Nuestro objeto ``Album`` es uma simple clase PHP. Para poder trabajar con la clase
``Zend\Db``’s ``AbstractTableGateway``, tenemos que usar el método
``exchangeArray()``. Este método simplemente copia los datos pasados 
en un array a las propiedades de nuestra entidad. Añadiremos un filtro de entrada para utilizar con nuestro 
formulario más tarde.

Después extendemos ``Zend\Db\TableGateway\AbstractTableGateway`` y creamos nuestro propia
clase ``AlbumTable`` en el directorio ``Model`` del módulo, así:

.. code-block:: php

    // module/Album/src/Album/Model/AlbumTable.php:
    namespace Album\Model;

    use Zend\Db\Adapter\Adapter;
    use Zend\Db\ResultSet\ResultSet;
    use Zend\Db\TableGateway\AbstractTableGateway;

    class AlbumTable extends AbstractTableGateway
    {
        protected $table ='album';

        public function __construct(Adapter $adapter)
        {
            $this->adapter = $adapter;
            $this->resultSetPrototype = new ResultSet();
            $this->resultSetPrototype->setArrayObjectPrototype(new Album());
            $this->initialize();
        }

        public function fetchAll()
        {
            $resultSet = $this->select();
            return $resultSet;
        }

        public function getAlbum($id)
        {
            $id  = (int) $id;
            $rowset = $this->select(array('id' => $id));
            $row = $rowset->current();
            if (!$row) {
                throw new \Exception("Could not find row $id");
            }
            return $row;
        }

        public function saveAlbum(Album $album)
        {
            $data = array(
                'artist' => $album->artist,
                'title'  => $album->title,
            );
            $id = (int) $album->id;
            if ($id == 0) {
                $this->insert($data);
            } else {
                if ($this->getAlbum($id)) {
                    $this->update($data, array('id' => $id));
                } else {
                    throw new \Exception('Form id does not exist');
                }
            }
        }

        public function deleteAlbum($id)
        {
            $this->delete(array('id' => $id));
        }
    }

Aquí ocurren muchas cosas. En primer lugar, asignamos a la propiedad protegida ``$table``
el nombre de la tabla en la base de datos, ‘album’ en este caso. Entonces escribimos un
constructor que tome un adaptador para la base de datos como único parámetro y lo asigne
a la propiedad adapter de nuestra clase. Entonces, necesitamos decirle al result set del
table gateway que cada vez que cree un nuevo objeto fila (row), debería utilizar un objeto
``Album`` para hacerlo. Las clases ``TableGateway`` utilizan el patrón prototipo para la
creación de result sets y entidades. Esto significa que en lugar de instanciar
cuando es necesario, el sistema clona un objeto previamente instanciado. Mire
`PHP Constructor Best Practices and the Prototype Pattern 
<http://ralphschindler.com/2012/03/09/php-constructor-best-practices-and-the-prototype-pattern>`_
para mas detalles.

Entonces creamos algunos métodos de ayuda que nuestra aplicación utilizará como interfaz
con la tabla de la base de datos. ``fetchAll()`` recupera todas las filas de albums de la
base de datos como un ``ResultSet``, ``getAlbum()`` recupera una única fila como un
objeto ``Album``, ``saveAlbum()`` crea una nueva fila en la base de datos o
actualiza una fila que ya existe y ``deleteAlbum()`` elimina la fila completamente.
El código para cada uno de estos métodos, afortunadamente, se explica por sí solo.

Utilizando ServiceManager para configurar las credenciales de la base de datos e inyección en el controlador
------------------------------------------------------------------------------------------------------------

Para utilizar siempre la misma instancia de nuestro ``AlbumTable``, utilizaremos el
``ServiceManager`` para definir como crear una. Esto se hace de manera simple en la
clase Module donde creamos un método llamado ``getServiceConfig()`` que es
automáticamente llamado por el ``ModuleManager`` y aplicado en el ``ServiceManager``.
Entonces podremos recuperarlo en nuestro controlador cuando lo necesitemos.

Para configurar el ``ServiceManager``, podemos suministrar el nombre de la clase
para que sea instanciada o una factoría que instancie el
objeto cuando el ``ServiceManager`` lo necesite. Empezamos por implementar 
``getServiceConfig()`` para proveer una factoría que cree un ``AlbumTable``. Añada
este método al final de la clase ``Module``.

.. code-block:: php

    // module/Album/Module.php:
    namespace Album;

    // Add this import statement:
    use Album\Model\AlbumTable;

    class Module
    {
        // getAutoloaderConfig() and getConfig() methods here

        // Add this method:
        public function getServiceConfig()
        {
            return array(
                'factories' => array(
                    'Album\Model\AlbumTable' =>  function($sm) {
                        $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                        $table     = new AlbumTable($dbAdapter);
                        return $table;
                    },
                ),
            );
        }
    }

Este método devuelve un array de ``factories`` que son todas combinadas por
el ``ModuleManager`` antes de pasar al ``ServiceManager``. También necesitamos
configurar el ``ServiceManager`` para que sepa como tomar un
``Zend\Db\Adapter\Adapter``. Esto se hace utilizando una factoría llamada
``Zend\Db\Adapter\AdapterServiceFactory`` que podemos configurar dentro del
sistema de configuración. El ``ModuleManager`` de Zend Framework 2 combina toda la
configuración del fichero ``module.config.php`` de cada módulo y entonces une
los archivos en ``config/autoload`` (archivos ``*.global.php`` y entonces ``*.local.php``).
Añadiremos la información de configuración de nuestra base de datos en ``global.php``
que deberá asignar a su sistema de control de versiones. Puede utilizar ``local.php`
(aparte del VCS) para almacenar las credenciales para su base de datos si lo desea.

.. code-block:: php

    // config/autoload/global.php:
    return array(
        'db' => array(
            'driver'         => 'Pdo',
            'dsn'            => 'mysql:dbname=zf2tutorial;host=localhost',
            'driver_options' => array(
                PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
            ),
        ),
        'service_manager' => array(
            'factories' => array(
                'Zend\Db\Adapter\Adapter' 
                        => 'Zend\Db\Adapter\AdapterServiceFactory',
            ),
        ),
    );

Debería poner las credenciales de su base de datos en ``config/autoloader/local.php``
ya que no están en el repositorio git (``local.php`` es ignorado):

.. code-block:: php

    // config.autoload/local.php:
    return array(
        'db' => array(
            'username' => 'YOUR USERNAME HERE',
            'password' => 'YOUR PASSWORD HERE',
        ),
    );

Ahora que el ``ServiceManager`` puede crear una instancia de ``AlbumTable`` para nosotros,
podemos añadir un método al controlador para recuperarla. Añada ``getAlbumTable()`` a la
clase ``AlbumController``:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
        public function getAlbumTable()
        {
            if (!$this->albumTable) {
                $sm = $this->getServiceLocator();
                $this->albumTable = $sm->get('Album\Model\AlbumTable');
            }
            return $this->albumTable;
        }

Debería añadir también:

.. code-block:: php

    protected $albumTable;

al principio de la clase.

Ahora podemos llamar a ``getAlbumTable()`` desde dentro de nuestro controlador cuando lo necesitemos
para interactuar con nuestro modelo. Empecemos con una lista de albums donde la acción
``index`` es llamada.

Listado de álbumes 
------------------

Para listar los albums, necesitamos recuperarlos del modelo y pasarlos
a la vista. Para hacer esto, completamos ``indexAction()`` dentro de
``AlbumController``. Actualiza la acción ``indexAction()`` así:

.. code-block:: php

    module/Album/src/Album/Controller/AlbumController.php:
    // ...
        public function indexAction()
        {
            return new ViewModel(array(
                'albums' => $this->getAlbumTable()->fetchAll(),
            ));
        }
    // ...

Con Zend Framework 2, para establecer variables en la vista, devolvemos una
instancia de ``ViewModel`` donde el primer parámetro del constructor es un array
de la acción que contiene los datos que necesitamos. Estos son entonces automáticamente pasados
al script de vista. El objeto ``ViewModel`` también nos permite cambiar el script de
vista que es utilizado, pero por defecto utiliza ``{controller name}/{action
name}``. Ahora podemos completar el script de vista ``index.phtml``:

.. code-block:: php

    <?php 
    // module/Album/view/album/album/index.phtml:

    $title = 'My albums';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>

    <p><a href="<?php echo $this->url('album', array( 
            'action'=>'add'));?>">Add new album</a></p>

    <table class="table">
    <tr>
        <th>Title</th>
        <th>Artist</th>
        <th>&nbsp;</th>
    </tr>
    <?php foreach($albums as $album) : ?>
    <tr>
        <td><?php echo $this->escapeHtml($album->title);?></td>
        <td><?php echo $this->escapeHtml($album->artist);?></td>    <td>
            <a href="<?php echo $this->url('album',
                array('action'=>'edit', 'id' => $album->id));?>">Edit</a>
            <a href="<?php echo $this->url('album',
                array('action'=>'delete', 'id' => $album->id));?>">Delete</a>
        </td>
    </tr>
    <?php endforeach; ?>
    </table>

Lo primero que hacemos es establecer el título para la página (utilizado en el diseño) y
además establecer el título para la sección ``<head>`` utilizando el método de ayuda
``headTitle()`` que lo mostrará en la barra de títulos del navegador. Entonces creamos un link
para añadir un nuevo album.

El método de ayuda ``url()`` es provisto por Zend Framework 2 y es utilizado para crear
los links que necesitamos. El primer parámetro para ``url()`` es el nombre de la ruta que queremos utilizar
para la construcción de la URL, y el segundo parámetro es un array de todas las
variables para encajar en los lugares de almacenamiento a utilizar. En este caso utilizamos nuestra
ruta ‘album’ que está montada para aceptar dos variables: ``action`` and ``id``.

Iteramos sobre la variable ``$albums`` que habíamos asignado en la acción del controlador. El
sistema de vistas de Zend Framework 2 automáticamente asegura que estas variables son
extraídas en el ámbito del script de vista, por lo que no tenemos que preocuparnos
de prefijarlas con ``$this->`` como teníamos que hacer con Zend Framework 1;
no obstante puede hacerlo si lo desea.

Entonces creamos una tabla para mostrar el título y el artista de cada album, y proveemos
links para permitir editar y eliminar cada disco. Utilizamos un bucle estándar ``foreach:``
para iterar sobre la lista de albums, y utilizamos la forma alternativa utilizando
dos puntos y ``endforeach;`` ya que es más sencillo escanear que probar y emparejar.
De nuevo, el método de ayuda ``url()`` es utilizado para crear los links de edición y
eliminación.

.. note::

    Siempre utilizamos el método de ayuda ``escapeHtml()`` para ayudar a protegernos
    contra vulnerabilidades XSS.

Si abre http://zf2-tutorial.localhost/album debería ver algo como esto:

.. image:: ../images/user-guide.database-and-models.album-list.png
    :width: 940 px