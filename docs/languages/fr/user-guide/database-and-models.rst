.. _user-guide.database-and-models:

###################
La base de données et les modèles
###################

La base de données
------------

Maintenant que nous avons configuré les actions et les vues du module ``Album``,
nous pouvons nous intéresser à la partie modèle de notre application.
Rappelez-vous que le modèle est le composant qui est en charge des objectifs
principaux de l'application (les "règles métier") et, dans notre cas, interagit
avec la base de données.
Nous utiliserons la classe ``Zend\Db\TableGateway\TableGateway`` qui est en
charge de lire, ajouter, modifier et supprimer des enregisrements d'une table
de la base de données.

Nous utiliserons MySQL, au travers du pilote PHP PDO. Il convient alors de créer
une base de données appelée ``zf2tutorial``, puis d'exécuter les requêtes
suivantes pour créer la table album avec quelques données.

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

(Les données de test choisies sont issues des Bestsellers sur Amazon UK au
moment de la rédaction de ces lignes !)

Nous avons maintenant un jeu de données en base et nous pouvons écrire un
modèle très simple.

Les fichiers de modèles
---------------

Zend Framework ne fournit pas un composant ``Zend\Model`` car le modèle
représente votre logique métier et c'est donc à vous de décider comment il doit
fonctionner. Il y a plusieurs composants que vous pouvez utiliser en fonction
de vos besoins. Une approche possible est d'avoir une classe modèle représentant
chaque entité de votre application et d'utiliser des objets mapper qui chargent
et sauvegardent ces entitées dans la base de données. Une autre solution est
d'utiliser un ORM comme Doctrine ou Propel.

Pour ce tutoriel, nous allons créer un modèle très simple en implémentant une
classe ``AlbumTable`` qui étend ``Zend\Db\TableGateway\TableGateway`` pour
laquelle chaque album est un objet ``Album`` (il s'agit d'une *entité*).
C'est une implémentation du design pattern Table Data Gateway qui permet
d'interagir avec les données d'une table.
Soyez bien concients que le pattern Table Data Gateway peut se révéler limité
pour des systèmes de taille importante. Il y a aussi la tentation
d'implémenter les accès à la base directement dans les actions du controleur
car ils sont exposés par ``Zend\Db\TableGateway\AbstractTableGateway``.
*Ne faites surtout pas ça*!

Commençons par créer notre classe entité ``Album`` du répertoire ``Model``:

.. code-block:: php

    <?php
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

Notre objet entité ``Album`` est une simple classe PHP. Afin de travailler avec
la classe ``AbstractTableGateway`` de ``Zend\Db``, nous avons besoin de coder
la méthode ``exchangeArray()``. Cette méthode copie simplement les données
passées en tableau vers les propriétés de notre entité. Nous ajouterons par la
suite un filtre de contrôle pour utiliser les données issues d'un formulaire.

Mais d'abord, vérifions que ce modèle Album se comporte comme attendu.
Ecrivons quelques tests pour en être sûrs.
Pour cela, nous créons un fichier ``AlbumTest.php`` dans le dossier
``module/Album/test/AlbumTest/Model``:

.. code-block:: php

    namespace AlbumTest\Model;

    use Album\Model\Album;
    use PHPUnit_Framework_TestCase;

    class AlbumTest extends PHPUnit_Framework_TestCase
    {
        public function testAlbumInitialState()
        {
            $album = new Album();

            $this->assertNull($album->artist, '"artist" should initially be null');
            $this->assertNull($album->id, '"id" should initially be null');
            $this->assertNull($album->title, '"title" should initially be null');
        }

        public function testExchangeArraySetsPropertiesCorrectly()
        {
            $album = new Album();
            $data  = array('artist' => 'some artist',
                           'id'     => 123,
                           'title'  => 'some title');

            $album->exchangeArray($data);

            $this->assertSame($data['artist'], $album->artist, '"artist" was not set correctly');
            $this->assertSame($data['id'], $album->id, '"id" was not set correctly');
            $this->assertSame($data['title'], $album->title, '"title" was not set correctly');
        }

        public function testExchangeArraySetsPropertiesToNullIfKeysAreNotPresent()
        {
            $album = new Album();

            $album->exchangeArray(array('artist' => 'some artist',
                                        'id'     => 123,
                                        'title'  => 'some title'));
            $album->exchangeArray(array());

            $this->assertNull($album->artist, '"artist" should have defaulted to null');
            $this->assertNull($album->id, '"id" should have defaulted to null');
            $this->assertNull($album->title, '"title" should have defaulted to null');
        }
    }

Nous testons trois choses:

1. Est-ce que toutes les propriétés de Album sont initialement NULL ?
2. Est-ce que ces propriétés vont être correctement alimentées lorsque nous appellerons ``exchangeArray()`` ?
3. Est-ce qu'une valeur NULL par défaut sera utilisée pour les propriétés dont la clé est absente du tableau ``$data`` ?

Si nous lançons ``phpunit`` une nouvelle fois, nous allons confirmer que la réponse à ces trois question est "OUI":

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ........

    Time: 0 seconds, Memory: 5.50Mb

    OK (8 tests, 19 assertions)

Ensuite, nous créons notre fichier ``AlbumTable.php`` dans le dossier ``module/Album/src/Album/Model`` de cette façon:

.. code-block:: php

    <?php
    namespace Album\Model;

    use Zend\Db\TableGateway\TableGateway;

    class AlbumTable
    {
        protected $tableGateway;

        public function __construct(TableGateway $tableGateway)
        {
            $this->tableGateway = $tableGateway;
        }

        public function fetchAll()
        {
            $resultSet = $this->tableGateway->select();
            return $resultSet;
        }

        public function getAlbum($id)
        {
            $id  = (int) $id;
            $rowset = $this->tableGateway->select(array('id' => $id));
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

            $id = (int)$album->id;
            if ($id == 0) {
                $this->tableGateway->insert($data);
            } else {
                if ($this->getAlbum($id)) {
                    $this->tableGateway->update($data, array('id' => $id));
                } else {
                    throw new \Exception('Form id does not exist');
                }
            }
        }

        public function deleteAlbum($id)
        {
            $this->tableGateway->delete(array('id' => $id));
        }
    }

Beaucoup de choses se sont passées ici.
Premièrement, nous alimentons l'attribut protégé ``$tableGateway`` avec l'instance
``TableGateway`` passée dans le constructeur. Nous l'utiliserons par la suite
pour effectuer des opérations sur la table en base pour nos albums.

Nous créons ensuite quelques méthodes que notre application utilisera pour
interagir avec la passerelle vers les tables.
``fetchAll()`` lit tous les enregistrements albums de la base dans un ``ResultSet``,
``getAlbum()`` lit un seul enregistrement dans un objet ``Album``,
``saveAlbum()`` ajoute ou modifie une ligne dans la base et ``deleteAlbum()``
supprime complètement une ligne. Le code de chacune de ces méthodes est, nous
l'espérons, assez explicite.

Utiliser le ServiceManager pour configurer le table gateway et injecter dans l'objet AlbumTable
-----------------------------------------------------------------------------------------

Afin de n'utiliser qu'une seule et même instance de notre ``AlbumTable``, nous
allons utiliser le ``ServiceManager`` pour définir la création de cette instance.
C'est assez facile à faire au sein de la classe Module à l'endroit où nous
avons déjà implementé une méthode appelée ``getServiceConfig()`` qui est
automatiquement appelée par le ``ModuleManager`` et appliquée au ``ServiceManager``.
Nous serons alors capables de retrouver cette instance dans notre
controleur lorsque nous en aurons besoin.

Pour configurer le ``ServiceManager``, nous pouvons soit fournir le nom de la
classe à instancier ou une factory (closure or fonction de rappel) qui va
instancier l'objet quand le ``ServiceManager`` en aura besoin. Nous commencons par
implementer ``getServiceConfig()`` pour fournir une factory qui créee une
``AlbumTable``. Ajouter cette méthode à la fin du fichier ``Module.php`` dans
``module/Album``.

.. code-block:: php
    :emphasize-lines: 5-8,14-32

    <?php
    namespace Album;

    // Add these import statements:
    use Album\Model\Album;
    use Album\Model\AlbumTable;
    use Zend\Db\ResultSet\ResultSet;
    use Zend\Db\TableGateway\TableGateway;

    class Module
    {
        // getAutoloaderConfig() and getConfig() methods here

        // Add this method:
        public function getServiceConfig()
        {
            return array(
                'factories' => array(
                    'Album\Model\AlbumTable' =>  function($sm) {
                        $tableGateway = $sm->get('AlbumTableGateway');
                        $table = new AlbumTable($tableGateway);
                        return $table;
                    },
                    'AlbumTableGateway' => function ($sm) {
                        $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                        $resultSetPrototype = new ResultSet();
                        $resultSetPrototype->setArrayObjectPrototype(new Album());
                        return new TableGateway('album', $dbAdapter, null, $resultSetPrototype);
                    },
                ),
            );
        }
    }

Cette méthode retourne un tableau de ``factories`` qui sont toutes fusionnées
par le ``ModuleManager`` avant d'être transmises au ``ServiceManager``. La
factory de ``Album\Model\AlbumTable`` utilise le ``ServiceManager`` pour créer
un ``AlbumTableGateway`` à tranmettre vers ``AlbumTable``. Nous indiquons aussi
au ``ServiceManager`` qu'un objet ``AlbumTableGateway`` est créé en obtenant un
``Zend\Db\Adapter\Adapter`` (également en provenance du ``ServiceManager``) et
que cet adaptateur est utilisé pour créer un objet ``TableGateway``. Le
``TableGateway`` est informé d'utiliser un objet ``Album`` chaque fois qu'il
crée un nouvel enregistrement résultat. La classe TableGateway utilise le
prototype pour la création d'ensembles de résultats et pour les entités.
Cela signifie qu'au lieu d'instancier l'objet quand il en a besoin, le système
clone un objet précédemment instancié. Pour plus de détails, voir
`PHP Constructor Best Practices and the Prototype Pattern <http://ralphschindler.com/2012/03/09/php-constructor-best-practices-and-the-prototype-pattern>`_.

Enfin, nous avons besoin de configurer le ``ServiceManager`` pour qu'il puisse
savoir comment obtenir un ``Zend\Db\Adapter\Adapter``. Ceci est effectué en
utilisant une factory appelée ``Zend\Db\Adapter\AdapterServiceFactory`` que
nous pouvons configurer dans le système de configuration fusionnée. Le
``ModuleManager`` de Zend Framework 2 fusionne toutes les fichiers de
configuration ``module.config.php`` de chaque module et fusionne ensuite les
fichiers du dossier ``config/autoload`` (les fichiers ``*.global.php`` et
ensuite les fichiers ``*.local.php``). Nous allons ajouter la configuration de
notre base de données au fichier ``global.php`` qui sera ajouté au système de
contrôle de version. Vous pouvez utiliser ``local.php`` (exclu du SCV) pour
stocker les informations de connexion à votre base si vous le souhaitez.
Modifiez ``config/autoload/global.php`` (à la racine de du Zend Skeleton, et non
pas dans le module Album) avec le code suivant:

.. code-block:: php

    <?php
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

Vous devriez garder les infos de connexion dans ``config/autoload/local.php``
pour qu'elles ne soient pas intégrées au dépôt git (car ``local.php`` est
ignoré):

.. code-block:: php

    <?php
    return array(
        'db' => array(
            'username' => 'VOTRE NOM UTILISATEUR',
            'password' => 'VOTRE MOT DE PASSE',
        ),
    );

Tester
-------

Ecrivons quelques tests pour tout ce code que nous venons d'écrire.
Premièrement, nous avons besoin d'une classe de test ``AlbumTable``.
Créez un fichier ``AlbumTableTest.php`` dans ``module/Album/test/AlbumTest/Model``

.. code-block:: php

    <?php
    namespace AlbumTest\Model;

    use Album\Model\AlbumTable;
    use Album\Model\Album;
    use Zend\Db\ResultSet\ResultSet;
    use PHPUnit_Framework_TestCase;

    class AlbumTableTest extends PHPUnit_Framework_TestCase
    {
        public function testFetchAllReturnsAllAlbums()
        {
            $resultSet        = new ResultSet();
            $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway',
                                               array('select'), array(), '', false);
            $mockTableGateway->expects($this->once())
                             ->method('select')
                             ->with()
                             ->will($this->returnValue($resultSet));

            $albumTable = new AlbumTable($mockTableGateway);

            $this->assertSame($resultSet, $albumTable->fetchAll());
        }
    }


Dans ce test, nous introduisons le concept `d'objets Mock
<http://www.phpunit.de/manual/3.6/en/test-doubles.html#test-doubles.mock-objects>`_.
Une explication plus détaillée de l'objet Mock est hors du champs de
ce tutoriel, mais il s'agit principalement d'un objet qui agit en lieu et place
d'un autre et qui se comporte d'une manière prédéfinie. Comme nous testons ici
``AlbumTable`` et PAS la classe ``TableGateway`` (l'équipe Zend a déjà testé la
classe ``TableGateway`` et nous savons qu'elle fonctionne), nous voulons juste
nous assurer que notre classe ``AlbumTable`` interagit comme nous l'attendons
avec la classe ``TableGatway``. Au dela de cela, nous vérifions que la méthode
``fetchAll()`` de ``AlbumTable`` va appeler la méthode ``select()`` de
l'attribut ``$tableGateway`` sans aucun paramètre. Si c'est bien le cas, elle
doit retourner un objet ``ResultSet``. Enfin, nous nous attendons à ce que ce
même objet ``ResultSet`` soit retourné à la méthode appelante. Ce test doit se
dérouler correctement, et nous pouvons ajouter le reste des méthodes de test :

.. code-block:: php

    public function testCanRetrieveAnAlbumByItsId()
    {
        $album = new Album();
        $album->exchangeArray(array('id'     => 123,
                                    'artist' => 'The Military Wives',
                                    'title'  => 'In My Dreams'));

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('select'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        $this->assertSame($album, $albumTable->getAlbum(123));
    }

    public function testCanDeleteAnAlbumByItsId()
    {
        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('delete'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('delete')
                         ->with(array('id' => 123));

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->deleteAlbum(123);
    }

    public function testSaveAlbumWillInsertNewAlbumsIfTheyDontAlreadyHaveAnId()
    {
        $albumData = array('artist' => 'The Military Wives', 'title' => 'In My Dreams');
        $album     = new Album();
        $album->exchangeArray($albumData);

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('insert'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('insert')
                         ->with($albumData);

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testSaveAlbumWillUpdateExistingAlbumsIfTheyAlreadyHaveAnId()
    {
        $albumData = array('id' => 123, 'artist' => 'The Military Wives', 'title' => 'In My Dreams');
        $album     = new Album();
        $album->exchangeArray($albumData);

        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array($album));

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway',
                                           array('select', 'update'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));
        $mockTableGateway->expects($this->once())
                         ->method('update')
                         ->with(array('artist' => 'The Military Wives', 'title' => 'In My Dreams'),
                                array('id' => 123));

        $albumTable = new AlbumTable($mockTableGateway);
        $albumTable->saveAlbum($album);
    }

    public function testExceptionIsThrownWhenGettingNonexistentAlbum()
    {
        $resultSet = new ResultSet();
        $resultSet->setArrayObjectPrototype(new Album());
        $resultSet->initialize(array());

        $mockTableGateway = $this->getMock('Zend\Db\TableGateway\TableGateway', array('select'), array(), '', false);
        $mockTableGateway->expects($this->once())
                         ->method('select')
                         ->with(array('id' => 123))
                         ->will($this->returnValue($resultSet));

        $albumTable = new AlbumTable($mockTableGateway);

        try
        {
            $albumTable->getAlbum(123);
        }
        catch (\Exception $e)
        {
            $this->assertSame('Could not find row 123', $e->getMessage());
            return;
        }

        $this->fail('Expected exception was not thrown');
    }

Examinons un peu nos tests. Nous testons que:

1. Nous pouvons retrouver un unique album par son ID.
2. Nous pouvons supprimer des albums.
3. Nous pouvons sauvegarder un nouvel album.
4. Nous pouvons modifier les albums existants.
5. Nous allons rencontrer une exception si nous tentons de récupérer un album qui n'existe pas.

Parfait ! Notre classe ``AlbumTable`` est testée. Let's move on!

Retour au contrôleur
----------------------

Maintenant que le ``ServiceManager`` peut créer une instance ``AlbumTable`` pour
nous, nous pouvons ajouter une méthode du contrôleur pour récupérer cette
instance. Ajoutez ``getAlbumTable()`` à la classe ``AlbumController``:

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

Vous devez également ajouter:

.. code-block:: php

    protected $albumTable;

au début de la classe.

Nous pouvons désormais appeler ``getAlbumTable()`` depuis notre contrôleur quand
nous avons besoin pour interagir avec notre modèle. Assurons nous que cela
fonctionne en écrivant un test.

Ajoutez ce test à votre classe ``AlbumControllerTest``:

.. code-block:: php

    public function testGetAlbumTableReturnsAnInstanceOfAlbumTable()
    {
        $this->assertInstanceOf('Album\Model\AlbumTable', $this->controller->getAlbumTable());
    }

Si le service locator est correctement configuré dans ``Module.php``, nous
devrions avoir une instance de ``Album\Model\AlbumTable`` en appelant ``getAlbumTable()``.

Lister les albums
--------------

Pour pouvoir lister les albums, nous avons besoin de les récupérer à partir du
modèle et les transmettre à la vue. Pour cela, nous alimentons ``indexAction()``
de ``AlbumController``. Modifiez ``indexAction()`` dans ``AlbumController``
comme ceci:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    // ...
        public function indexAction()
        {
            return new ViewModel(array(
                'albums' => $this->getAlbumTable()->fetchAll(),
            ));
        }
    // ...

Avec Zend Framework 2, pour pouvoir aimenter les variables de vue, nous
retournons une instance ``ViewModel`` pour laquelle le premier paramètre du
constructeur est un tableau contenant les données dont nous avons besoin. Elles
sont alors automatiquement passées au script de vue. L'objet ``ViewModel`` nous
autorise également à changer le script de vue utilisé, mais le comportement par
défaut est d'utiliser ``{controller name}/{action name}``. Nous pouvons
maintenant alimenter le script de vue ``index.phtml``:

.. code-block:: php

    <?php
    // module/Album/view/album/album/index.phtml:

    $title = 'My albums';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>
    <p>
        <a href="<?php echo $this->url('album', array('action'=>'add'));?>">Add new album</a>
    </p>

    <table class="table">
    <tr>
        <th>Title</th>
        <th>Artist</th>
        <th>&nbsp;</th>
    </tr>
    <?php foreach ($albums as $album) : ?>
    <tr>
        <td><?php echo $this->escapeHtml($album->title);?></td>
        <td><?php echo $this->escapeHtml($album->artist);?></td>
        <td>
            <a href="<?php echo $this->url('album',
                array('action'=>'edit', 'id' => $album->id));?>">Edit</a>
            <a href="<?php echo $this->url('album',
                array('action'=>'delete', 'id' => $album->id));?>">Delete</a>
        </td>
    </tr>
    <?php endforeach; ?>
    </table>

La première chose que nous faisons est d'alimenter le titre pour la page
(utilisé dans le layout) et nous fixons également le titre pour la section
``<head>`` qui va s'afficher dans la barre de titre du navigateur en utilisant
l'aide de vue ``headTitle()``. Nous ajoutons ensuite un lien pour ajouter un
nouvel album.

L'aide de vue ``url()`` est fournie par Zend Framework 2 et est utilisée pour
créer les liens nécessaires. Le premier paramètre de ``url()`` est le nom de la
route que nous souhaitons utiliser pour la construction de l'URL, et le second
paramètre est un tableau des variables de cette route. Dans notre cas, nous
utilisons la route ‘album’ qui accepte deux variables : ``action`` et ``id``.

Nous itérons sur les ``$albums`` que nous avons assignés dans l'action du
contrôleurt. Le système de vues de Zend Framework 2 assure que ces variables
sont automatiquement extraites dans la portée du script de vue, et nous n'avons
alors pas à les préfixer par ``$this->`` comme nous en avions l'habitude avec
Zend Framework 1; quoi qu'il en soit, vous pouvez quand même le faire.

Nous créons ensuite une table pour afficher chaque titre et artiste de l'album,
et nous fournissons and des liens pour permettre de modifier et de supprimer les
enregistrements. Une boucle standard ``foreach:`` est utilisée pour itérer sur la
liste des albums, et nous utilisons la syntaxe alternative utlisant les doubles
points et ``endforeach;`` car c'est plus simple à utiliser et à lire plutôt que
de devoir appareiller des accolades. Encore une fois, l'aide de vue ``url()``
est utilisée pour créer les liens de modification et de suppression.

.. note::

    Nous utilisons systématiquement l'aide de vue ``escapeHtml()`` pour nous
    protéger des failles XSS.

Si vous ouvrez la page http://zf2-tutorial.localhost/album vous devriez voir
ceci:

.. image:: ../images/user-guide.database-and-models.album-list.png
    :width: 940 px
