.. _user-guide.unit-testing.rst:

##############
Birim Testleri
##############

Katı bir birim test paketi özellikle bir çok kişinin katıldığı devamlı
geliştirmeler için esastır. Her kod değişiminden sonra geriye dönüp tüm ilgili
komponentleri manuel olarak test etmek zordur. Birim testleri, bir değişiklik
yapıtığınızda uygulamanızın komponentlerini otomatik olarak test edecek ve
birşey çalışmadığında testleri yazdığınız zamanki gibi çalışmadığını
söyleyecektir.

Zend Framework 2 API'si `PHPUnit <http://phpunit.de/>`_ kullanıyor aynı şekilde
bu ders uygulamasıda... Birim testlerinin ayrıntılı anlatımı bu ders kapsamının
dışında olduğu için sadece takip eden sayfalardaki komponentlerin örnek
testlerini sağlayacağız. Bu ders, PHPUnit'e sahip olduğunuzu varsayar.

Testlerin dizinini ayarlamak
----------------------------

Projenizin ana dizininde aşağıdaki alt dizinleriyle ``tests`` adında bir dizin
oluşturun

.. code-block:: text

    zf2-tutorial/
        /tests
            /module
                /Application
                    /src
                        /Application
                            /Controller

``tests`` dizininin yapısı projenizin kaynak koduyla tamamiyle aynı olmalıdır.
Böylelikle testlerinizi iyi organize edilmiş bir şekilde kolayca bulabilirsiniz.
Sonra, test modelleriniz için uygun dizinler oluşturacaksınız fakat şimdilik
Application modülünde IndexController var.

Testlerinizi Bootstrap etmek
----------------------------

Şimdi, ``zf-tutorial/tests/`` dizininde ``phpunit.xml`` isimli bir dosya
oluşturun:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>

    <phpunit bootstrap="bootstrap.php">
        <testsuites>
            <testsuite name="zf2tutorial">
                <directory>./</directory>
            </testsuite>
        </testsuites>
    </phpunit>

Ve yine aynı şekilde ``zf-tutorial/tests/`` dizinine ``bootstrap.php``
dosyasını oluşturun:

.. code-block:: php

    <?php
    chdir(dirname(__DIR__));

    include __DIR__ . '/../init_autoloader.php';

    Zend\Mvc\Application::init(include 'config/application.config.php');

Bootstrap dosyasının içeriği neredeyse ``zf-tutorial/public/index.php``
dosyasının içeriği ile aynıdır.

İlk controller testiniz
-----------------------

Şimdi ``zf-tutorial/tests/module/Application/src/Application/Controller`` dizini
altında ``IndexControllerTest.php`` adında bir dosya oluşturun. Aşağıdakileri
dosyaya ekleyin:

.. code-block:: php

    <?php

    namespace Application\Controller;

    use Application\Controller\IndexController;
    use Zend\Http\Request;
    use Zend\Http\Response;
    use Zend\Mvc\MvcEvent;
    use Zend\Mvc\Router\RouteMatch;
    use PHPUnit_Framework_TestCase;

    class IndexControllerTest extends PHPUnit_Framework_TestCase
    {
        protected $controller;
        protected $request;
        protected $response;
        protected $routeMatch;
        protected $event;

        public function setUp()
        {
            $this->controller = new IndexController();
            $this->request    = new Request();
            $this->routeMatch = new RouteMatch(array('controller' => 'index'));
            $this->event      = new MvcEvent();
            $this->event->setRouteMatch($this->routeMatch);
            $this->controller->setEvent($this->event);
        }
    }

Bu kodlarda neler olup bittiğinin ayrıntılı açıklaması için Tom Oram'ın
`Unit Testing a ZF 2 Controller <http://devblog.x2k.co.uk/unit-testing-a-zend-framework-2-controller/>`_
yazısını okuyabilirsiniz..

Şimdi, aşağıdaki metodu ``IndexControllerTest`` sınıfının içine ekleyin:

.. code-block:: php

    public function testIndexActionCanBeAccessed()
    {
        $this->routeMatch->setParam('action', 'index');

        $result   = $this->controller->dispatch($this->request);
        $response = $this->controller->getResponse();

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertInstanceOf('Zend\View\Model\ViewModel', $result);
    }

Bu test, anasayfa cevabının HTTP statüsünün 200 olduğunu ve controller'ın return
değerinin ``Zend\View\Model\ViewModel`` oturumu olup olmadığını doğrular.

Testing
-----------

Son olarak konsolunuzda ``cd`` komutu ile ``zf-tutorial/tests/`` dizinine gidin
ve ``phpunit`` komutunu çalıştırın. Eğer aşağıdaki gibi bir çıktı görürseniz
uygulamanız daha fazla test için hazır demektir.

.. code-block:: text

    PHPUnit 3.5.15 by Sebastian Bergmann.

    .

    Time: 0 seconds, Memory: 5.75Mb

    OK (1 test, 2 assertions)
