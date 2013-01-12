.. _user-guide.overview:

#############################
Zend Framework 2'ye Başlarken
#############################

Bu ders serisi, Zend Framework 2 kullanımı hakkında başlangıç bilgisi vermesi
amacıyla, Model-View-Controller mimarisi kullanılarak, veritabanı destekli basit
bir uygulama oluşturulmasını kapsayacaktır. Dersler bittiğinde ZF2’nin nasıl işlediğini
öğrenebilmeniz için kurcalayabileceğiniz çalışan bir ZF2 uygulamasına sahip olacaksınız.

.. note::

    Bu ders boyunca bazı önemli terimler orjinalliğini koruması için ingilizce
    anlamlarıyla kullanılacaktır.

.. _user-guide.overview.assumptions:

Bazı varsayımlar
----------------

Bu ders serisi Apache web sunucusu üzerinde PHP 5.3.10 ve PDO uzantısı ile ulaşılabilen
bir MySQL sunucusuna sahip olduğunuzu varsayar. Apache kurulumunuz, ``mod_rewrite``
eklentisine kurulu ve çalışır halde sahip olması gerekiyor.

Ayrıca Apache kurulumunuzun ``.htaccess`` dosyalarını desteklediğinden emin olmanız
gerekiyor. Bunu sağlamak için genelde aşağıdaki kısmı:

.. code-block:: apache

    AllowOverride None

aşağıdaki ile değiştirip

.. code-block:: apache

    AllowOverride FileInfo

``httpd.conf`` dosyasınn içinde yapmanız yeterli olur. Tam ayrıntıya ulaşmak için
kullandığınız sürümün dökümantasyonunu kontrol edin. Eğer mod_rewrite ve .htaccess
düzgün şekilde ayarlanmamışsa, ana sayfa harici herhangi bir sayfaya ulaşamazsınız.

Öğretici Uygulama
-----------------

Oluşturacağımız uygulama, hangi müzik albümlerine sahip olduğumuzu gösteren basit
bir envanter uygulamasıdır. Ana sayfa, koleksiyonumuzu listeleyecek ve CD'lerimizi
eklememize, düzenlememize ve silmemize imkan verecek. Websitemizde dört sayfaya
ihtiyaç duyacağız:

+-----------------+-----------------------------------------------------------+
| Sayfa           | Açıklama                                                  |
+=================+===========================================================+
| Albüm listesi   | Bu sayfa albümlerimizi listeleyecek ve albümlerimizi      |
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

Ayrıca verilerimizi veritabanında depolamamız gerekiyor. Bunun için aşağıdaki
sütunlara ait bir tablo gerekiyor:

+------------+--------------+-------+-----------------------------+
| Sütun Adı  | Tipi         | Boş?  | Notlar                      |
+============+==============+=======+=============================+
| id         | integer      | No    | Primary key, auto-increment |
+------------+--------------+-------+-----------------------------+
| artist     | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+
| title      | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+

