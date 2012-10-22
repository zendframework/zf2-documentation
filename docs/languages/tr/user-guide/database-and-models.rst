.. _user-guide.database-and-models:

######################
Veritabanı ve modeller
######################

Veritabanı
----------

``Album`` modülümüzün controller, action metodları ve view scriptlerini
hazırladığımıza göre artık uygulamamızın model bölümüne bakmanın zamanı geldi.
Unutmayın ki model, uygulamanın çekirdeğinin amacının (“iş kuralları” olarak
adlandırılan) bir parçasıdır ve bizim durumumuzda veritabanını kapsıyor.
Zend Framework'ün veritabanı tablosunda bul, yerleştir, güncelle ve sil
işlemlerini yapmamızı sağlayan ``Zend\Db\TableGateway\TableGateway`` sınıfını
kullanacağız.

PHP'nin PDO sürücüsünün yardımı ile MySQL veritabanını kullanacağız.
``zf2tutorial`` adında bir veritabanı oluşturun ve aşağıdaki SQL deyimlerini
çalıştırarak gerekli tabloları oluşturun ve birkaç veri ekleyin.

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

(Test verisi, bu dersin yapım zamanında Amazon UK’un en çok satanlar listesinden
alınmıştır!)

Artık veritabanımızda biraz veri var. Şimdi bu veriler için basit bir model
oluşturabiliriz.

Model dosyaları
---------------

Zend Framework bir ``Zend\Model`` komponenti sağlamaz. Çünkü model sizin kendi
iş mantığınızdır ve nasıl çalışmak istediğiniz size bağlıdır. İhtiyacınıza
bağlı olarak kullanabileceğiniz bir çok komponent mevcut. Yaklaşımlardan biri,
her varlık (entity) için ayrı bir model sınıfı oluşturmak ve yönlendirici
(mapper) nesneler ile bu varlıkları yükleyip veritabanına kaydetmek. Bir başkası:
Doctrine veya Propel gibi bir ORM kullanmak.

Bu ders için ``AlbumTable`` adında çok basit bir model oluşturacağız ve bu model
``Zend\Db\TableGateway\AbstractTableGateway`` sınıfından genişleyecek. Bu yapıda
her albüm nesnesi bir ``Album`` nesnesidir (*entity* olarak tabir edilir).
Bu, veritabanındaki veriye arayüz oluşturması için Tablo Veri Kapısı tasarım
deseninin (Table Data Gateway design pattern) bir uygulanışıdır. Dikkat: Tablo Veri
Kapısı büyük sistemlerde sınırlayıcı olabiliyor. Ayrıca veritabanı erişim
kodlarını controller action metodlarına koymak cazip gelebilir. Bu kodlar
``Zend\Db\TableGateway\AbstractTableGateway`` tarafından teşhir edildiğinden
*sakın bunu yapmayın*!

``Model`` dizininde ``Album`` entity'sini oluşturarak başlayalım:

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

``Album`` entity nesnemiz basit bir PHP sınıfıdır. ``Zend\Db``’nin
``AbstractTableGateway`` sınıfıyla çalışabilmek için, ``exchangeArray()``
metodunu eklememiz gerekiyor. Bu metod basitçe array olarak aktarılan veriyi
entity'nin özelliklerine aktarıyor. Daha sonra formumuzda kullanabilmek için
girdi filitresi (input filter) ekleyeceğiz.

Ama önce, şimdiye kadar oluşturduğumuz Album modelimizin beklendiği gibi
çalışıp çalışmadığını görmek için testleri yazalım:

.. code-block:: php

    // tests/module/Album/src/Album/Model/AlbumTest.php:
    namespace Album\Model;

    use PHPUnit_Framework_TestCase;

    class AlbumTest extends PHPUnit_Framework_TestCase
    {
        public function testAlbumInitialState()
        {
            $album = new Album();

            $this->assertNull($album->artist, '"artist" başlangıçta null olmalı');
            $this->assertNull($album->id, '"id" başlangıçta null olmalı');
            $this->assertNull($album->title, '"title" başlangıçta null olmalı');
        }

        public function testExchangeArraySetsPropertiesCorrectly()
        {
            $album = new Album();
            $data  = array('artist' => 'some artist',
                           'id'     => 123,
                           'title'  => 'some title');

            $album->exchangeArray($data);

            $this->assertSame($data['artist'], $album->artist, '"artist" doğru ayarlanmadı');
            $this->assertSame($data['id'], $album->id, '"title" doğru ayarlanmadı');
            $this->assertSame($data['title'], $album->title, '"title" doğru ayarlanmadı');
        }

        public function testExchangeArraySetsPropertiesToNullIfKeysAreNotPresent()
        {
            $album = new Album();

            $album->exchangeArray(array('artist' => 'some artist',
                                        'id'     => 123,
                                        'title'  => 'some title'));
            $album->exchangeArray(array());

            $this->assertNull($album->artist, '"artist" varsayılan olarak NULL olmalıydı');
            $this->assertNull($album->id, '"title" varsayılan olarak NULL olmalıydı');
            $this->assertNull($album->title, '"title" varsayılan olarak NULL olmalıydı');
        }
    }

3 şey için test yapıyoruz:

1. Bütün Albümün özellikleri (property) başlangıçta NULL olarak ayarlanmış mı?
2. ``exchangeArray()`` çağırıldığında Albümün özellikleri doğru şekilde atanıyor mu?
3. ``$data`` dizisinde anahtarları verilmeyen özellikler doğru şekilde NULL olarak atanacak mı?

Eğer ``phpunit``’i tekrar çalıştırırsak, bu üç soruya cevabın "EVET" olduğunu göreceğiz:

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    ........

    Time: 0 seconds, Memory: 5.50Mb

    OK (8 tests, 19 assertions)

Sonra, modülümüzün ``Model`` dizininde ``AlbumTable`` isimli bir sınıf oluşturup
bu sınıfı ``Zend\Db\TableGateway\AbstractTableGateway`` sınıfından genişleteceğiz:

.. code-block:: php

    // module/Album/src/Album/Model/AlbumTable.php:
    namespace Album\Model;

    use Zend\Db\Adapter\Adapter;
    use Zend\Db\ResultSet\ResultSet;
    use Zend\Db\TableGateway\AbstractTableGateway;

    class AlbumTable extends AbstractTableGateway
    {
        protected $table = 'album';

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

            $rowset = $this->select(array(
                'id' => $id,
            ));

            $row = $rowset->current();

            if (!$row) {
                throw new \Exception("Satır bulunamıyor: $id");
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
            } elseif ($this->getAlbum($id)) {
                $this->update(
                    $data,
                    array(
                        'id' => $id,
                    )
                );
            } else {
                throw new \Exception("Satır bulunamıyor: $id");
            }
        }

        public function deleteAlbum($id)
        {
            $this->delete(array(
                'id' => $id,
            ));
        }
    }

Burda birçok şey oluyor. İlk önce, veritabanındaki tablo adını içeren ``$table``
adında bir protected property (bu durumda ‘album’) oluşturduk. Sonra yapıcı
(constructor) oluşturup tek parametresi olarak veritabanı adaptörünü alan ve
bunu sınıfımızın adapter özelliğine atıyoruz. Daha sonra tablo kapısının
sonucuna, ne zaman yeni bir satır nesnesi oluşturursa bunu yapmak için ``Album``
nesnesini kullanmasını söylüyoruz. Bu şu anlama geliyor: gerekli olduğunda
başlatmaktansa, lazım olduğunda sistem daha önce başlatılmış nesnenin kopyasını
kullanıyor. Daha fazla ayrıntı için `PHP Constructor Best Practices and the
Prototype Pattern
<http://ralphschindler.com/2012/03/09/php-constructor-best-practices-and-the-prototype-pattern>`_
adresine bakın.

Daha sonra uygulamamızın veritabanı tablosuna arayüz oluşturabilmesi için
birkaç yardımcı metod oluşturuyoruz. ``fetchAll()`` metodu ``ResultSet`` olarak
bütün satırları veritabanından çeker. ``getAlbum()`` metodu tek bir satırı
``Album`` nesnesi olarak çeker. ``saveAlbum()`` ya veritabanında yeni bir satır
oluşturur ya da mevcut satırı günceller. ``deleteAlbum()`` metodu mevcut satırı
komple siler. Umuyoruz ki bu metodların kodları kendilerini açıklıyor.

ServiceManager’ı kullanarak veritabanı kimlik bilgilerini konfigüre etmek ve controller’a enjekte etmek
-------------------------------------------------------------------------------------------------------

Her zaman ``AlbumTable``’ın aynı oturumunu kullanmak için ``ServiceManager``'a
nasıl yeni bir tane oluşturulacağını tarif edeceğiz. Bu en kolay, Modül sınıfında
``getServiceConfig()`` isimli bir metod oluşturarak yapılabilir. ``ModuleManager``
otomatik olarak bu metodu çağıracak ve içindeki tanımlamaları ``ServiceManager``’a
aktaracaktır. Daha sonra controller’ımız içinde istediğimiz zaman çağırabileceğiz.

``ServiceManager``’ı konfigüre edebilmek için ya oturum başlatılacak sınıfın
adını ya da factory (closure ya da callback) kullanarak ``ServiceManager``’ın
gerektiğinde oturum başlatabilmesini sağlamak gerekiyor. ``getServiceConfig()``’i
uygulayarak ``AlbumTable``’ı oluşturması için bir factory oluşturarak
başlayalım. Bu metodu ``Module`` sınıfının en altına ekleyin:

.. code-block:: php
    :emphasize-lines: 4-5,11-23

    // module/Album/Module.php:
    namespace Album;

    // bu ekleme deyimini ekleyin:
    use Album\Model\AlbumTable;

    class Module
    {
        // getAutoloaderConfig() ve getConfig() metodları burda

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

Bu metod bir dizi içinde ``factories`` içerir ve hepsi ``ModuleManager``
tarafından birleştirilir ve ``ServiceManager``’a aktarılır. Ayrıca
``ServiceManager``’ı, ``Zend\Db\Adapter\Adapter`` nesnesini nasıl çağıracağını
bilmesi için konfigüre etmemiz gerekiyor. Bu işlem,
``Zend\Db\Adapter\AdapterServiceFactory` isminde bir factory ile birleştirilmiş
config sistemi içinde tanımlamaları yaparak yapılabilir. Zend Framework 2’nin
``ModuleManager``’ı her modülün ``module.config.php`` dosyalarını birleştirir
sonra ``config/autoload`` dizini içindeki (ilk olarak ``*.global.php`` sonra
``*.local.php`` dosyaları) dosyaları birleştirir. Biz, veritabanı
konfigürasyon dosyalarını ``global.php`` dosyasına koyacağız. Bu dosyayı
versiyon kontrol sisteminize commit etmelisiniz. İsterseniz ``local.php`` dosyasını
(VCS’nin dışında) veritabanı kimlik bilgilerini saklamak için kullanabilirsiniz:

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

Veritabanı kimlik bilgilerinizi ``config/autoload/local.php`` dosyasına
atmalısınız. Böylelikle git repository'nize bu dosya eklenmeyecek. (``local.php``
dosyaları görmezden gelinir):

.. code-block:: php

    // config/autoload/local.php:
    return array(
        'db' => array(
            'username' => 'KULLANICI ADINIZ',
            'password' => 'ŞİFRENİZ',
        ),
    );

Artık ``ServiceManager`` bizim için bir ``AlbumTable`` oturumu başlatabilir.
Controller’ımıza bu oturumu getirmek için bir metod ekleyebiliriz.
``AlbumController`` sınıfı içine ``getAlbumTable()`` adında bir metod oluşturun:

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

Ayrıca aşağıdakini de:

.. code-block:: php

    protected $albumTable;

sınıfın en başına eklemelisiniz.

artık modelimizle iletişime geçebilmek için controller’ımız içinde istediğimiz
zaman ``getAlbumTable()`` metodunu çağırabiliriz. Şimdi ``index`` action’u
çağırıldığında albüm listesini getirerek başlayalım.

Albümleri Listelemek
--------------------

Albümleri listeleyebilmek için, albümleri modelimizden çekip view’imize
aktarmalıyız. Bunu yapabilmek için ``AlbumController``’ın ``indexAction()``’unu
doldurmamız gerekiyor. ``AlbumController``’ın ``indexAction()``’unu aşağıdaki
gibi güncelleyin:

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

Zend Framework 2 ile, view için değişkenler tanımlayabilmek için yapıcısının
(constructor) ilk parametresi dizi değişken (array) olan bir ``ViewModel``
oturumunu action’dan return ediyoruz. Bu değişkenler otomatik olarak view
scriptine aktarılacak. ``ViewModel`` nesnesi ayrıca view scriptini değiştirmemize
olanak sağlıyor. Bu tanımlamayı yapmadıkça standartı ``{controller name}/{action
name}``’dir. Artık ``index.phtml`` view scriptini doldurabiliriz:

.. code-block:: php

    <?php
    // module/Album/view/album/album/index.phtml:

    $title = 'My albums';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>
    <p>
        <a href="<?php echo $this->url('album', array('action'=>'add'));?>">Yeni albüm ekle</a>
    </p>

    <table class="table">
    <tr>
        <th>Başlık</th>
        <th>Sanatçı</th>
        <th>&nbsp;</th>
    </tr>
    <?php foreach ($albums as $album) : ?>
    <tr>
        <td><?php echo $this->escapeHtml($album->title);?></td>
        <td><?php echo $this->escapeHtml($album->artist);?></td>
        <td>
            <a href="<?php echo $this->url('album',
                array('action'=>'edit', 'id' => $album->id));?>">Düzenle</a>
            <a href="<?php echo $this->url('album',
                array('action'=>'delete', 'id' => $album->id));?>">Sil</a>
        </td>
    </tr>
    <?php endforeach; ?>
    </table>

İlk yaptığımız işlem, sayfanın başlığını tanımlamak (layout içinde kullanılıyor)
ve ``headTitle()`` view yardımcısını (view helper) kullanarak ``<head>`` bölümü
içinde, browser’ın başlık kısmında görüntülenmesi için kullanıyoruz. Sonra
yeni albüm ekleyebilmek için bir link oluşturuyoruz.

``url()`` ihtiyacımız olan linkleri oluşturabilmek için Zend Framework 2
tarafından sağlanan bir view yardımcısıdır. İlk parametresi, URL’nin oluşturulması
için route bilgisini gerektirir ve ikinci parametre route'umuzdaki yer tutucuların
dizi değişken olarak alır. Bizim durumumuzda ‘album’ route'umuzdaki iki adet
yer tutucu olarak tanımlanan ``action`` ve ``id`` değişkenlerini kullanacağız.

Controller action’u içinde atadığımız ``$albums`` değişkenini yineliyoruz
(iterate). Zend Framework 2’nin view sistemi otomatik olarak bu değişkenlerin
view scriptinin kapsamı içine dahil eder. Böylelikle Zend Framework 1’deki gibi
bunların önüne ``$this->`` eklemek ile uğraşmamız gerekmez. Fakat isterseniz
bu şekilde de kullanabilirsiniz.

Daha sonra her albümün başlığını, sanatcısını, düzenlemek ve silmek için gerekli
linklerin gösterimini sağlayan bir tablo oluşturuyoruz. Standart ``foreach:``
döngüsünün alternatif bir versiyonunu kullanarak, albüm listesi üzerinde yineleme
yapıyoruz. Süslü parantezleri aramaktansa başlangıç ve bitişini görmek bu şekilde
daha kolay oluyor. Yine ``url()`` view yardımcısını düzenle ve sil linklerini
oluşturmak için kullanıyoruz.

.. note::

    XSS açıklarından kendimizi koruyabilmemiz için ``escapeHtml()``
    view yardımcısını daima kullanın.

Eğer http://zf2-tutorial.localhost/album adresini açarsanız aşağıdaki gibi bir
sayfa görmeniz gerekiyor:

.. image:: ../images/user-guide.database-and-models.album-list.png
    :width: 940 px
