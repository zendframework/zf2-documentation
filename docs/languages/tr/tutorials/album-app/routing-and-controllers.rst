.. _user-guide.routing-and-controllers:

#########################
Routing ve kontrollörler (Controller)
#########################

Albüm koleksiyonumuzu listelemek için basit bir envanter sistemi oluşturuyoruz.
Ana sayfa albüm koleksiyonumuzu listeleyecek ve ekleme, düzenleme, silme
işlemlerini yapabilmemiz için bize imkan sağlayacak. Bu sebeple aşağıdaki
sayfalar uygulamamız için gerekli:

+-----------------+-----------------------------------------------------------+
| Sayfa           | Açıklama                                                  |
+=================+===========================================================+
| Ana Sayfa       | Bu sayfa albümlerimizi listeleyecek ve albümlerimizi      |
|                 | silip düzenleyebilmemiz için link sağlayacak. Ayrıca yeni |
|                 | albümler ekleyebilmek için link sağlayacak.               |
+-----------------+-----------------------------------------------------------+
| Yeni Albüm Ekle | Bu sayfa yeni albüm eklemek için form sağlayacak.         |
+-----------------+-----------------------------------------------------------+
| Albüm Düzenle   | Bu sayfa albüm düzenleyebilmek için form sağlayacak.      |
+-----------------+-----------------------------------------------------------+
| Albüm Sil       | Bu sayfa albümü silmek istediğimizi onaylayacak ve        |
|                 | silecek.                                                  |
+-----------------+-----------------------------------------------------------+

Dosyalarımızı oluşturmadan önce framework'ün sayfaların organize edilişini nasıl
beklediğini anlamak önemlidir. Uygulamanın her sayfası *action* olarak tabir
edilir ve actionlar *controller*lar içinde, controllerlar da *modüller*
içinde gruplanır. Yani ilgili actionları bir controller içine
gruplayabilirsiniz. Mesela, bir haber controller'ı ``current``, ``archived`` ve
``view`` actionlarına sahip olabilir.

Albümleri etkileyecek dört adet sayfamız olduğu için, bunları ``AlbumController``
adında tek bir controller olarak ``Album`` modülünde dört action olarak
gruplayacağız. Bu 4 action aşağıdaki gibi olacak:

+-----------------+---------------------+------------+
| Sayfa           | Controller          | Action     |
+=================+=====================+============+
| Ana Sayfa       | ``AlbumController`` | ``index``  |
+-----------------+---------------------+------------+
| Yeni Albüm Ekle | ``AlbumController`` | ``add``    |
+-----------------+---------------------+------------+
| Albüm Düzenle   | ``AlbumController`` | ``edit``   |
+-----------------+---------------------+------------+
| Albüm Sil       | ``AlbumController`` | ``delete`` |
+-----------------+---------------------+------------+

Bir URL'nin belirli bir action'a yönlendirilmesi, modülün ``module.config.php``
dosyasındaki route'ları kullanarak yapılır. Albüm actionlarımız için bir route
ekleyeceğiz. Güncellenmiş modül konfigürasyon dosyası aşağıdaki gibidir.
Vurgulanmış satırlar eklenmesi gereken satırlardır:

.. code-block:: php
    :emphasize-lines: 9-27

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),

        // The following section is new and should be added to your file
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

Route'un adı ‘album’ ve ‘segment’ tipine sahip. Segment route'u URL içinde
belirli parçaları yer tutucu olarak atanmasına ve bu yer tutucuların parametreler
olarak saklanmasına yarar. Bu durumda **``/album[/:action][/:id]``** route'u,
``/album`` parçası ile başlayan bütün URL'ler bu route tanımlaması ile
eşleşecektir. Sonraki parça, opsiyonel action adı ve son olarak opsiyonel id
değeri ile eşleşecek. Kareli parantezler, o segmentin opsiyonel olmasını sağlar.
``constraints`` bölümü segmentler içindeki bilginin beklenen şekilde olduğuna
emin olmamızı sağlar. Yani actionlarımızı harf ile başlayan ve devamında
alfanümerik, alt-tire (_) ve tire (-) içeren bir ifadeye sınırladık. Ayrıca
id değerimizi de sadece sayılara sınırladık.

Bu route, aşağıdaki URL'lere sahip olmamıza olanak sağlıyor

+---------------------+------------------------------+------------+
| URL                 | Sayfa                        | Action     |
+=====================+==============================+============+
| ``/album``          | Ana sayfa (albüm listesi)    | ``index``  |
+---------------------+------------------------------+------------+
| ``/album/add``      | Yeni albüm ekle              | ``add``    |
+---------------------+------------------------------+------------+
| ``/album/edit/2``   | id'si 2 olan albümü düzenle  | ``edit``   |
+---------------------+------------------------------+------------+
| ``/album/delete/4`` | id'si 4 olan albümü sil      | ``delete`` |
+---------------------+------------------------------+------------+

Controller oluşturuluşu
=======================

Artık controller'ımızı oluşturmaya hazırız. Zend Framework 2'de controller,
genel olarak ``{Controller name}Controller`` olarak isimlendirilen bir sınıftır.
``{Controller name}``'in büyük harfle başlamak zorunda olduğunu unutmayın. Bu
sınıf ``Controller`` dizininde ``{Controller name}Controller.php`` adında bir
dosya içine konulmalıdır. Bizim durumumuzda dizin ``module/Album/src/Album/Controller``
olacaktır. Her action controller sınıfı içindeki ``{action name}Action`` şeklinde
adlandırılması gereken public method olmak zorundadır ve ``{action name}`` küçük
harfle başlamalıdır.

.. note::

    Bu kural gereğidir. Zend Framework 2 ``Zend\Stdlib\Dispatchable`` interface'ini
    uygulamak zorunda olmaları haricinde pek bir kısıtlama uygulamaz. Framework
    bizim için iki abstract sınıf sağlar: ``Zend\Mvc\Controller\AbstractActionController``
    ve ``Zend\Mvc\Controller\AbstractRestfulController``. Biz standart
    ``AbstractActionController``'ı kullanacağız, Fakat eğer bir RESTful web
    servisi yazmayı düşünüyorsanız, ``AbstractRestfulController`` kullanışlı
    olabilir

Şimdi devam edelim ve controller sınımızı oluşturalım:

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

    Modülü controllerımız hakkında ‘controller’ bölümünde
    ``config/module.config.php`` kısmında haberdar etmiştik.

Şimdi kullanmak istediğimiz actionlarımızı tanımlayalım. View dosyalarını
tanımlayana kadar bu actionlar çalışmayacaktır. Her action için URL aşağıdaki
gibidir:

+--------------------------------------------+----------------------------------------------------+
| URL                                        | Çağırılan metod                                    |
+============================================+====================================================+
| http://zf2-tutorial.localhost/album        | ``Album\Controller\AlbumController::indexAction``  |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/add    | ``Album\Controller\AlbumController::addAction``    |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/edit   | ``Album\Controller\AlbumController::editAction``   |
+--------------------------------------------+----------------------------------------------------+
| http://zf2-tutorial.localhost/album/delete | ``Album\Controller\AlbumController::deleteAction`` |
+--------------------------------------------+----------------------------------------------------+

Artık uygulamamızın her sayfası için çalışan router'ımız ve actionlarımız var.

Şimdi view ve model katmanını hazırlamaya başlayabiliriz.

View scriptlerinin başlatılması
-------------------------------

Görünümlerimizi uygulamamızla birleştirmek için tek gerekli olan birkaç view
dosyası... Bu dosyalar ``DefaultViewStrategy`` tarafından çalıştırılacak ve
controller action metodundan döndürülen değişkenler ve view modelleri bu
dosyaya aktarılacak. Bu dosyalar modülümüzün views dizininde, controller ismi
ile aynı isme sahip bir dizin içinde saklanır. Aşağıdaki dört dosyayı şimdilik
boş olarak oluşturun:

* ``module/Album/view/album/album/index.phtml``
* ``module/Album/view/album/album/add.phtml``
* ``module/Album/view/album/album/edit.phtml``
* ``module/Album/view/album/album/delete.phtml``

Artık veritabanından ve modellerden başlayarak herşeyi doldurmaya başlayabiliriz.

Testlerin yazımı
----------------

Albüm controller'ımız henüz pek birşey yapmıyor. Test etmesi kolay olmalı.

Aşağıdaki içeriğe sahip
``zf2-tutorial/tests/module/Album/src/Album/Controller/AlbumControllerTest.php``
dosyasını oluşturun:

.. code-block:: php

    <?php

    namespace Album\Controller;

    use Album\Controller\AlbumController;
    use Zend\Http\Request;
    use Zend\Http\Response;
    use Zend\Mvc\MvcEvent;
    use Zend\Mvc\Router\RouteMatch;
    use PHPUnit_Framework_TestCase;

    class AlbumControllerTest extends PHPUnit_Framework_TestCase
    {
        protected $controller;
        protected $request;
        protected $response;
        protected $routeMatch;
        protected $event;

        public function testAddActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'add');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
            $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
        }

        public function testDeleteActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'delete');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
            $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
        }

        public function testEditActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'edit');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
            $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
        }

        public function testIndexActionCanBeAccessed()
        {
            $this->routeMatch->setParam('action', 'index');

            $result   = $this->controller->dispatch($this->request);
            $response = $this->controller->getResponse();

            $this->assertEquals(200, $response->getStatusCode());
            $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
        }

        public function setUp()
        {
            $this->controller = new AlbumController();
            $this->request    = new Request();
            $this->routeMatch = new RouteMatch(array('controller' => 'album'));
            $this->event      = new MvcEvent();
            $this->event->setRouteMatch($this->routeMatch);
            $this->controller->setEvent($this->event);
        }
    }

ve ``phpunit`` komutunu çalıştırın.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .....

    Time: 0 seconds, Memory: 5.75Mb

    OK (5 tests, 10 assertions)
