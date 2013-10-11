.. _user-guide.modules:

########
Modüller
########

Zend Framework 2 modül sistemi kullanır ve siz ana uygulamaya özel kodlarınızı
modüller içinde organize edersiniz. İskelet uygulama tarafından sağlanan
Application modülü bütün uygulamaya önyükleme, hata ve route konfigürasyonu
sağlamak için hazırlanmıştır. Bu modül genelde uygulama seviyesinde controller’lar,
uygulamanın anasayfası için kullanılır. Fakat bu derslerde albüm listesinin
ana sayfada olmasını istediğimiz için varsayılanı kullanmayacağız.

Bütün kodlarımızı konfigürasyon ile birlikte, controller’lar, modeller, formlar ve
view’leri kapsayacak ``Album`` adında bir modüle koyacağız. Ayrıca gerektikçe
``Application`` modülünde ufak değişiklikler yapacağız.

Şimdi gerekli olan dizinlerle başlayalım..

Album modülünü kurmak
---------------------

``module`` dizini altında ``Album`` isimli bir dizin oluşturun ve içindeki
dizinleri aşağıdaki gibi oluşturun:

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /config
                /src
                    /Album
                        /Controller
                        /Form
                        /Model
                /view
                    /album
                        /album

Gördüğünüz gibi ``Album`` modülü farklı tipteki dosyalar için farklı dizinlere
sahip. ``Album`` isimuzayında yaşayacak olan PHP dosyalarındaki sınıflar
``src/Album`` dizinine yerleştirilmeli. Böylece modülümüz içinde birden fazla
isimuzayı (namespace) bulundurabiliriz. View dizini ayrıca ``album`` adında
modülümüzün view scriptlerini barındırabileceği bir alt dizine sahip.

Modülü yükleyip konfigüre edebilmek için, Zend Framework 2 ``ModuleManager``
komponenti sağlıyor. Bu komponent, ana dizinin modül dizininde (``module/Album``)
``Module.php`` dosyasına bakacak ve ``Album\Module`` isimli bir sınıf bulmayı
umacak. Bunun sebebi, verilen modülün isimuzayının verilen modül ismiyle aynı
olması gerektiğidir.

``Album`` modülinde ``Module.php`` isimli bir dosya oluşturun:

.. code-block:: php

    // module/Album/Module.php
    namespace Album;

    use Zend\ModuleManager\Feature\AutoloaderProviderInterface;
    use Zend\ModuleManager\Feature\ConfigProviderInterface;

    class Module implements AutoloaderProviderInterface, ConfigProviderInterface
    {
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\ClassMapAutoloader' => array(
                    __DIR__ . '/autoload_classmap.php',
                ),
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    ),
                ),
            );
        }

        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

``ModuleManager``, ``getAutoloaderConfig()`` ve ``getConfig()`` metodlarını
bizim için otomatik olarak çağıracaktır.

Dosyaların otomatik olarak yüklenmesi (Autoloading)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``getAutoloaderConfig()`` metodumuz, ZF2’nin ``AutoloaderFactory`` sınıfı ile
uyumlu bir dizi değişken (array) döndürür. Bu dizi değişkeni düzenleyerek
``ClassmapAutoloader`` için bir sınıf haritası dosyası tanımlıyoruz. Ayrıca
bu modülün isimuzayını (namespace) ``StandardAutoloader``’a ekliyoruz. Standart
otomatik yükleyici (Autoloader), bir isim uzayına ve bu isim uzayını nerede
bulacağını ister. PSR-0 uyumludur ve sınıf isimleri direkt olarak dosyalarını
işaret eder. `PSR-0 kuralları
<https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md>`_.

Geliştirme süreci içinde olduğumuzdan dosyaları classmap ile yüklememiz gerekmiyor.
Yani boş bir dizi değişken (array) döndüren bir dosya oluşturmamız yeterli.
``autoload_classmap.php`` adında bir dosya oluşturun ve içine aşağıdaki kodu
ekleyin:

.. code-block:: php

    // module/Album/autoload_classmap.php:
    return array();

Bu dosya içinde boş bir dizi değişken (array) verdiğimiz için otomatik yükleyici
ne zaman ``Album`` isimuzayı içinde bir sınıfa bakmak istese ``StandardAutoloader``’ı
fallback olarak kullanır.

.. note::

    Composer’ı kullandığımız için, alternatif olarak ``getAutoloaderConfig()``
    metodunu uygulamak yerine ``"Application": "module/Application/src"``
    tanımını ``composer.json`` dosyasında ``psr-0`` anahtarı altına ekleyebilirsiniz.
    Eğer bu şekilde devam ederseniz, ``php composer.phar update`` komutunu
    Composer’ın otomatik yükleme dosyalarını güncellemesi için çalıştırmalısınız.

Konfigürasyon
-------------

Otomatik yükleyiciyi kayıt ettiğimize göre şimdi ``getConfig()`` metoduna hızlı
bir bakış atalım. Bu metod basit olarak ``config/module.config.php`` dosyasını
yüklüyor.

``Album`` modülü için aşağıdaki konfigürasyon dosyasını oluşturun:

.. code-block:: php

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

Konfigürasyon bilgisi, ilgili komponentlere ``ServiceManager`` tarafından
aktarılır. Bize iki temel bölüm gerekiyor: ``controllers`` ve
``view_manager``. Controllers bölümü modül tarafından sağlanan controller’ların
listesini tutar. Biz, ``AlbumController`` adında ``Album\Controller\Album``’ün
refere ettiği tek bir controller’a ihtiyaç duyacağız. Controller anahtarı
tüm modüller içinde eşsiz olmalıdır. Bu sebeple önüne modülümüzün adını ekledik.

``view_manager`` bölümü içinde, ``TemplatePathStack`` konfigürasyonuna view
dizinimizi bildireceğiz. Bu durum ``Album`` modülünün view scriptlerinin
``view/`` dizininde bulunmasını sağlıyor.

Uygulamaya yeni modülümüz hakkında bilgilendirmek
-------------------------------------------------

Şimdi ``ModuleManager``’a bu yeni modülün varlığını bildirmemiz gerekiyor. Bu işlem
iskelet uygulama tarafından sağlanan ``config/application.config.php`` dosyası
içinde yapılır. Bu dosyayı güncelleyerek ``modules`` bölümüne ``Album`` modülünü
ekleyin. İşlemden sonra dosya aşağıdaki gibi gözükecektir:

(Changes required are highlighted using comments.)

.. code-block:: php
    :emphasize-lines: 5

    // config/application.config.php:
    return array(
        'modules' => array(
            'Application',
            'Album',                  // <-- Add this line
        ),
        'module_listener_options' => array(
            'config_glob_paths'    => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                './module',
                './vendor',
            ),
        ),
    );

Gördüğünüz gibi ``Album`` modülümüzü ``Application`` modülünden sonra
modül listesine ekledik.

Modülümüz artık kendi kodlarımızı içine ekleyebilmemiz için hazır
