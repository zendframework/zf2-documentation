.. _zend.db.adapter:

Zend_Db_Adapter
===============

Zend_Db ve alakalı sınıflar Zend Framework için basit SQL veri tabanı arayüzü sağlamaktadır.
Zend_Db_Adapter PHP uygulamalarınızı ilişkisel veri tabanı yönetim sistemlerine(RDBMS) bağlamak için
kullanılan temel sınıftır. Farklı RDBMS'ler için farklı bağdaştırıcı sınıfları mevcuttur.

Zend_Db sağlayıcıya özel PHP eklentileri ile genel arayüz arasında köprü oluşturarak , az bir emek ile PHP
uygulamalarınızı bir kere yazıp farklı RDBMS'ler ile yerleştirilmesine yardım eder.

Bağdaştırıcı sınıfının arayüzü `PHP Data Objects (PDO)`_ eklentisinin arayüzüne benzer. Zend_Db takip
eden RDPMS markaları için PDO sürücüsü bağdaştırıcı sınıfları sağlamaktadır:

- MySQL, `pdo_mysql`_ PHP eklentisini kullanarak

- Microsoft SQL Server, `pdo_mssql`_ PHP eklentisini kullanarak

- Oracle, `pdo_oci`_ PHP eklentisini kullanarak

- PostgreSQL, `pdo_pgsql`_ PHP eklentisini kullanarak

- SQLite, `pdo_sqlite`_ PHP eklentisini kullanarak

Ek olarak , Zend_Db takip eden RDBMS markaları için PHP veri tabanı eklentilerini kullanan bağdaştırıcı
sınıfları sağlamaktadır:

- MySQL, `mysqli`_ PHP eklentisini kullanarak

- Oracle, `oci8`_ PHP eklentisini kullanarak

- IBM DB2, `ibm_db2`_ PHP eklentisini kullanarak

.. note::

   Her Zend_Db bağdaştırıcısı PHP eklentisi kullanmaktadır. Zend_Db bağdaştırıcısını kullanabilmek
   için karşılık gelen PHP eklentisi PHP ortamınızda aktif durumda olmalıdır. Örneğin , PDO Zend_Db
   bağdaştırıcılarından herhangi birini kullandığınızda , PDO eklentisini ve kullandığınız marka
   RDBMS'in PDO sürücüsünü aktif hale getirmelisiniz.

.. _zend.db.adapter.connecting:

Bağdaştırıcı ile veri tabanına Bağlanmak
----------------------------------------

Bu kısım veri tabanı bağdaştırıcısı instance'ı oluşturulmasını açıklar. Bu PHP uygulamanızdan RDBMS
sunucunuza bağlantı yapmaya benzer.

.. _zend.db.adapter.connecting.constructor:

Zend_Db Bağdaştırıcısı yapıcısı(Constructor'ı) kullanmak
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bir bağdaştırıcının yapıcısını kullanarak bir bağdaştırıcının instance'ını oluşturabilirsiniz.
Bağdaştırıcı yapıcısı bağlantıyı tanımlamak için parametreler dizisi olan bir argüman almaktadır.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Bağdaştırıcı yapıcısı kullanmak

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Zend_Db Factory kullanmak
^^^^^^^^^^^^^^^^^^^^^^^^^

Direk olarak Bağdaştırıcı yapıcısı(constructor) kullanmaya alternatif olarak bağdaştırıcının statik
metodunu *Zend_Db::factory()* kullanarak bağdaştırıcı instance'ı olşturulabilir.Bu metod istem sırasında
Bağdaştırıcı sınıf dosyasını :ref:`Zend_Loader::loadClass() <zend.loader.load.class>` kullanarak dinamik
olarak yükler.

İlk argüman Bağdaştırıcı sınıfının esas adını adlandıran string argümandır. Örneğin 'Pdo_Mysql'
string'i Zend_Db_Adapter_Pdo_Mysql sınıfını karşılamaktadır. İkinci argüman aynı Bağdaştırıcı
yapıcısına verilen parametreler dizisi gibidir.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Bağdaştırıcı factory metodunu kullanmak

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Db.php';
   // Zend_Db_Adapter_Pdo_Mysql sınıfını otomatik yükle ve instance'ını oluştur.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Zend_Db_Adapter_Abstract sınıfını genişleten bir sınıf oluşturup , sınıf adını "Zend_Db_Adapter" paket
öneki ile isimlendirmediyseniz bağdaştırınızı yüklemek için bağdaştırıcı sınıfının kılavuzluk
eden kısmını parametre dizisindeki 'adapterNamespace' anahtarı ile belirtirseniz *factory()* metodunu
kullanabilirsiniz.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Bağdaştırıcı factory metodunun özel bağdaştırıcı sınıfı için kullanılması

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Db.php';

   // Otomatik olarak MyProject_Db_Adapter_Pdo_Mysql sınıfını yükle ve instance'ını oluştur.
   $db = Zend_Db::factory('Pdo_Mysql', array(
                       'host'             => '127.0.0.1',
                       'username'         => 'webuser',
                       'password'         => 'xxxxxxxx',
                       'dbname'           => 'test',
                       'adapterNamespace' => 'MyProject_Db_Adapter'
               ));

.. _zend.db.adapter.connecting.factory-config:

Zend_Config'in Zend_Db Factory ile Kullanımı
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

İsterseniz *factory()* metodunun her iki argümanını :ref:`Zend_Config <zend.config>` tipinde nesne olarak
belirtebilirsiniz.

Eğer ilk argüman yapılandırma nesnesi ise kullanılacak sınıfı adlandıran *adapter* özelliği içermesi
beklenir. İsteğe bağlı olarak nesne bağdaştırıcı parametre adlarına karşı gelen alt özellikleri
barındıran *params* adlı özelliği içerebilir. Bu sadece *factory()* metodunun ikinci argümanı
olmadığında kullanılır.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Bağdaştırıcı factory metodunun Zend_Config nesnesiyle kullanımı

Aşağıdaki örnekte Zend_Config nesnesi diziden oluşturuldu. Ayrıca veriyi harici bir dosyadan da
yükleyebilirsiniz , örneğin :ref:`Zend_Config_Ini <zend.config.adapters.ini>` veya :ref:`Zend_Config_Xml
<zend.config.adapters.xml>` ile.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Config.php';
   require_once 'Zend/Db.php';

   $config = new Zend_Config(
                   array(
                       'database' => array(
                               'adapter' => 'Mysqli',
                               'params' => array(
                               'dbname' => 'test',
                               'username' => 'webuser',
                               'password' => 'secret',
                               )
                           )
                       )
                   );

                   $db = Zend_Db::factory($config->database);
                   ));

*factory()* metodunun ikinci argümanı bağdaştırıcı parametrelerine karşı gelen kayıtları içeren
birleşmeli dizi olabilir. Bu argüman isteğe bağlı. Eğer ilk argüman Zend_Config tiplerindeyse tüm
parametreleri içerdiği varsayılır ve ikinci argüman gözardı edilir.

.. _zend.db.adapter.connecting.parameters:

Bağdaştırıcı Parametreleri
^^^^^^^^^^^^^^^^^^^^^^^^^^

Aşağıdaki liste Zend_Db Bağdaştırıcı sınıfı tarafından tanımlanan genel parametreleri
açıklamaktadır.

- **host**: veri tabanı sunucusunun hostname'ini veya IP adresini barındıran string.Eğer veri tabanı , PHP
  uygulaması ile aynı host'da çalışıyorsa 'localhost' veya '12.0.0.1' kullanabilirsiniz.

- **username**: RDBMS sunucusuna oturum açmayı sağlayan hesap tanımlayıcısı.

- **password**: RDBMS sunucuna oturum açmak için zorunlu olan hesap şifresi.

- **dbname**: RDBMS sunucusundaki veri tabanı instance adı.

- **port**: Bazı RDBMS sunucuları yönetici tarafından belirlenen port numarasından ağ trafiği kabul
  edebilir. Port parametresi PHP uygulamanızın RDBMS sunucusunda tanımlı olan port numarası ile eşleşmesi
  için port numarasını belirlemeye yarar.

- **options**: Bu parametre tüm Zend_Db_Adapter sınıflarına genel olan seçeneklerin birleşmeli dizisidir.

- **driver_options**: Bu parametre verilen veri tabanı eklentisine ilişkin ek seçenekler birleşmeli dizisidir.
  Bu parametrenin bir tipik kullanımı ise PDO sürücüsünün özniteliklerini(attribute) vermektir.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Factory'ye case-folding seçeneği vermek

Bu seçeneği *Zend_Db::CASE_FOLDING*. sabiti ile belirtebilirsiniz. Bu , PDO ve IBM DB veri tabanı
sürücülerindeki sorgu sonuç setlerindeki string anahtarlarının küçük , büyük harf durumunu ayarlamaya
yarayan *ATTR_CASE* özniteliğine karşılık gelmektedir. Bu seçeneğin aldığı değerler
*Zend_Db::CASE_NATURAL* (varsayılan), *Zend_Db::CASE_UPPER*, ve *Zend_Db::CASE_LOWER*.

.. code-block::
   :linenos:
   <?php
   $options = array(
       Zend_Db::CASE_FOLDING => Zend_Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: Otomatik tırnaklama seçeneğini factory'ye vermek

Bu seçeneği *Zend_Db::AUTO_QUOTE_IDENTIFIERS* sabiti le belirtebilirsiniz. Eğer değer *true* ise , tablo
isimleri , sütun isimleri , hatta alias'lar gibi tanımlayacılar Bağdaştırıcı nesnesi tarafından
oluşturulan SQL sözdiziminde sınırlandırılır. Bu SQL kelimeleri veya özel karakter içeren
tanımlayıcılar kullanmayı kolaylaştırır. Eğer değer *false* ise tanımlayıcılar otomatik olarak
sınırlandırılmaz. Eğer tanımlayıcıları sınırlamanız gerekiyorsa *quoteIdentifier()* metodunu kullanarak
kendiniz yapmalısınız.

.. code-block::
   :linenos:
   <?php
   $options = array(
       Zend_Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: PDO sürücü seçeneklerini factory'ye vermek

.. code-block::
   :linenos:
   <?php
   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.getconnection:

Tembel Bağlantıları Yönetmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bağdaştırıcı sınıfının instance'ı oluşturulurken RDBMS sunucusuna bağlantı hemen sağlanmaz.
Bağdaştırıcı bağlantı parametrelerini saklar ve ilk sorguyu çalıştırdığınız zaman fiili
bağlantıyı gerçekleştirir. Bu Bağdaştırıcı nesnesi oluşturmanın hızlı ve ucuz olmasını sağlar.
Eğer uygulamanız mevcut isteğe cevap verdiği zaman veri tabanı sorguları çalıştırmanız gerektiğinden
emin değilseniz bile Bağdaştırıcı sınıfı instance'ı oluşturabilirsiniz.

Eğer Bağdaştırıcıyı RDBMS'e bağlanmaya zorlamanız gerekiyorsa , *getConnection()* metodunu kullanın. Bu
metod kendi PHP veri tabanı eklentisinde daha önce gösterildiği gibi bağlantı için nesne döndürür.
Örneğin PDO sürücüleri için herhangi bir Bağdaştırıcı sınıfını kullandığınızda ,
*getConnection()* metodu kendine özgü veri tabanına canlı bağlantı başlattıktan sonra PDO nesnesini
döndürür.

Geçersiz hesap bilgileri sunulması veya diğer RDBMS sunucusuna bağlantı problemleri sonucunda exception
yakalamak için bağlanmaya zorlamak faydalı olabilir. veri tabanında ilk sorgu çalıştırıldığı zamandan
ziyade bu exeption'lar bağlantı yapılana kadar ortaya çıkmaz, eğer exeptionları bir yerde idare ediyorsanız
uygulama kodunuzu basitleştirmenize yardım edebilir.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Bağlantı exeption'larının idare edilmesi

.. code-block::
   :linenos:
   <?php
   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // muhtemelen geçersiz oturum bilgisi ,veya belki de RDBMS çalışmıyor
   } catch (Zend_Exception $e) {
       // muhtemelen factory() belirli Bağdaştırıcı sınıfını yükleyemedi
   }

.. _zend.db.adapter.example-database:

Örnek veri tabanı
-----------------

Zend_Db sınıfları için belgelerde sınıfların ve metodların kullanımını tasvir etmek için birtakım
basit tablolar kullanıyoruz. Bu örnek tablolar bir yazılım geliştirme projesinde hataların takibi için bilgi
depolayabilir. veri tabanı dört tablodan oluşuyor:

- **accounts** hata izleme veri tabanında her kullanıcının bilgisini tutuyor.

- **products** hata raporlanabilecek herbir ürün hakkında bilgi tutuyor.

- **bugs** Hatalar hakkında bilgi tutuyor , hatanın şuanki durumu , hatayı raporlayan kişi , hatayı
  düzeltmek için atanmış kişi , düzeltmeyi doğrulamak için atanmış kişi.

- **bugs_products** Hatalar ile ürünler arasındaki ilişkiyi tutuyor. Bu çoktan çoğa (many-to-many)
  ilişkiselliği sağlar , çünkü verilen hata birden çok ürün ile ilgili olabilir , ve tabiki verilen
  ürünün birden çok hatası olabilir.

Takip eden SQL veri tanımlama dili sözde kodu(pseudocode) örnek veri tabanındaki tabloları açıklamaktadır.
Bu örnek tablolar Zend_Db için otomatikleştirilmiş birim testleri(unit test) tarafından yaygınca
kullanılmıştır.

.. code-block::
   :linenos:

   CREATE TABLE accounts (
     account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
     product_id        INTEGER NOT NULL PRIMARY KEY,
     product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
     bug_id            INTEGER NOT NULL PRIMARY KEY,
     bug_description   VARCHAR(100),
     bug_status        VARCHAR(20),
     reported_by       VARCHAR(100) REFERENCES accounts(account_name),
     assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
     verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
     bug_id            INTEGER NOT NULL REFERENCES bugs,
     product_id        INTEGER NOT NULL REFERENCES products,
     PRIMARY KEY       (bug_id, product_id)
   );

Ayrıca dikkat ederseniz *bugs* tablosu *accounts* tablosunu kaynak gösteren birçok foreign key içeriyor. Bu
foreign key'lerin herbiri verilen hata için *accounts* tablosundaki farklı bir satırı kaynak gösterebilir.

Aşağıdaki şema örnek veri tabanının fiziksel veri modelini tasvir etmektedir.

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Sorgu Sonuçlarını Okumak
------------------------

Bu bölüm SELECT sorguları çalıştırabileceğiniz ve sorgu sonuçlarına erişebileceğiniz Bağdaştırıcı
sınıfı metodlarını açıklamaktadır.

.. _zend.db.adapter.select.fetchall:

Tüm sonuç listesinin alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SQL SELECT sorgusu çalıştırıp , sonuçlarını *fetchAll()* metodunu kullanarak tek bir adımda
getirebilirsiniz.

Bu metodun aldığı ilk argüman SELECT deyimini içeren bir string'dir. Alternatif olarak ilk argüman bir
sınıfın nesnesi :ref:`Zend_Db_Select <zend.db.select>` olabilir. Bağdaştırıcı otomatik olarak bu nesneyi
SELECT deyiminin string gösterimine dönüştürür.

*fetchAll()*'ın ikinci argümanı SQL deyiminde sembol yerini alan değerler dizisidir.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: fetchAll() kullanmak

.. code-block::
   :linenos:
   <?php
   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Sonuç alma (Fetch) Modunun değiştirilmesi
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Varsayılan olarak *FetchAll()* herbiri ilişkili dizi olan satırlar dizisi geri döndürür. İlişkili dizinin
anahtarları select sorgusunda isimlendirilen sütunlar veya sütun takma isimleridir (alias).

*setFetchMode()* metodunu kullanarak sonuç alma modunu belirleyebilirsiniz. Desteklenen modlar sabitler
tarafından tanımlanmaktadır:

- **Zend_Db::FETCH_ASSOC**: Veriyi ilişkili diziler olarak döndürür. Dizi anahtarları string olarak sütun
  adlarıdır. Bu Zend_Db_Adapter sınıflarında varsayılan sonuç alma modudur.

  Eğer select listesi aynı isimli sütunlar içeriyorsa , örneğin JOIN ile farklı tablolardan geliyorsa
  ilişkili dizide verilen isim için sadece bir girdi olabilir. Eğer FETCH_ASSOC modunu kullanırsanız , eşsiz
  dizi anahtarları sağlamak için SELECT sorgunuzda sütun takma isimlerini (alias) belirlemelisiniz.

  Bu stringler varsayılan olarak veri tabanı sürücüsünden döndüğü gibi döner.Bu tipik olarak RDBMS
  sunucusundaki sütun imlasıdır. Bu stringlerin küçük,büyük harf durumunu *Zend_Db::CASE_FOLDING*
  seçeneğini kullanarak belirleyebilirsiniz.Bunu bir örnekle desteklemek gerekirse , bakınız :ref:`
  <zend.db.adapter.connecting.parameters.example1>`.

- **Zend_Db::FETCH_NUM**: veriyi dizi içinde diziler olarak döndürür. Bu diziler sorgunun select listesi
  alanlarının pozizyonlarına karşı gelen tamsayılar tarafından indekslenir.

- **Zend_Db::FETCH_BOTH**: veriyi dizi içinde diziler olarak döndürür. Dizi anahtarları FETCH_ASSOC modunda
  kullanıldığı gibi hem stringler hemde FETCH_NUM modunda kullanıldığı gibi tamsayılardır.Dikkat edilirse
  dizideki öğe sayısı FETCH_ASSOC veya FETCH_NUM kullanımındakinin iki katıdır.

- **Zend_Db::FETCH_COLUMN**: veriyi değerler dizisi olarak döndürür. Her dizideki değer sonuç listesindeki
  bir sütundan dönen değerdir. Varsayılan olarak bu 0 ile indekslenmiş ilk sütundur.

- **Zend_Db::FETCH_OBJ**: veriyi nesneler dizisi olarak döndürür. Varsayılan sınıf PHP yerleşik stdClass
  sınıfıdır. Sonuç listesinin sütunları nesnenin genel (public) özellikleridir.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: setFetchMode() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result nesneler dizisi
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Sonuç listesinin Birleşmeli Dizi olarak Alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*fetchAssoc()* metodu sonuç alma moduna bakmaksızın veriyi birleşmeli diziler olarak döndürür.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: fetchAssoc() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result sonuç alma moduna rağmen birleşmeli diziler dizisi
   echo $result[0]['bug_description'];

.. _zend.db.adapter.select.fetchcol:

Sonuç Listesinden bir Sütunun Alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*fetchCol()* metodu sonuç alma moduna bakmaksızın veriyi değerler dizisi olarak döndürür. Bu sorgu
tarafından döndürülen ilk sütunu döndürür. Sorgu tarafından döndürülen diğer sütunlar döndürülmez.
Eğer ilk sütundan başka sütunu döndürmeniz gerkiyorsa bakınız :ref:`
<zend.db.statement.fetching.fetchcolumn>`.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: fetchCol() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchCol('SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // bug_description'ı içeriyor;bug_id döndürülmedi
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Sonuç Listesinden Anahtar-Değer Çiftlerinin Alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*fetchPairs()* metodu satır başına tek bir kayıt gelecek şekilde veriyi anahtar-değer çiftleri birleşmeli
dizisi olarak döndürür.Bu birleşmeli dizinin anahtarı SELECT sorgusu tarafından döndürülen ilk sütundur.
Değer ise SELECT sorgusu tarafından döndürülen ikinci sütundur. Sorgu tarafından döndürülen herhangi
diğer sütunlar gözardı edilir.

Döndürülen ilk sütun eşsiz değerler içerecek şekilde SELECT sorgunuzu tasarlamalısınız. Eğer ilk
sütunda birbirinin kopyası değerler bulunuyorsa birleşmeli dizideki kayıtların üzerine yazılacaktır.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: fetchPairs() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Sonuç listesinden Bir Satırın Alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*fetchRow()* metodu mevcut sonuç alım modunu kullanarak veri döndürür ama sadece sonuç listesinin ilk
satırını döndürür.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: fetchRow() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');
   // dikkat edilirse $result tek bir nesne , nesneler dizisi değil
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Sonuç listesinden Bir Niceliğin Alınması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*fetchOne()* metodu *fetchRow()* ile *fetchCol()* metodunun kombinasyonuna benzediğinden dolayı sadece sonuç
listesinden alınan ilk satırı ve satırdaki ilk sütun değerini döndürür. Bundan dolayı tek bir nicelik
döndürür , dizi veya nesne değil.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: fetchOne() Kullanımı

.. code-block::
   :linenos:
   <?php
   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // bu yalnızca string değerdir
   echo $result;

.. _zend.db.adapter.write:

Değişikliklerin veri tabanına Yazılması
---------------------------------------

Bağdaştırıcı sınıfını yeni veri yazmak için veya varolan veriyi değiştirmek için kullanabilirsiniz. Bu
bölüm bu işlemleri yapma metodlarını açıklıyor.

.. _zend.db.adapter.write.insert:

Veri Eklenmesi
^^^^^^^^^^^^^^

*insert()* metodunu kullarak veri tabanınızdaki tabloya yeni satırlar ekliyebilirsiniz. İlk argüman tablo
adı, ve ikinci argüman ise sütun isimlerini veri değerlerine eşleyen birleşmeli dizi.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Tabloya Veri Eklemek

.. code-block::
   :linenos:
   <?php
   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Veri dizisine eklemediğiniz sütunlar veri tabanına belirtilmez. Bu sebepten SQL INSERT deyiminin uyduğu
kurallara uyarlar: Eğer sütunun DEFAULT deyimi varsa sütun oluşturulan satırda varsayılan değeri alır ,
aksi halde sütun boş(NULL) durumda bırakılır.

Varsayılan olarak veri dizinizdeki değerler parametreler kullanılarak eklenir. Bu bazı tip güvenlik sorunları
riskini azaltır. Veri dizinizdeki değerlere kaçış (escaping) veya tırnaklama (quoting) uygulamanıza gerek
yok.

Veri dizisinde tırnak içinde tutulmaması gereken durumda SQL ifadesi sayılan değerlere ihtiyaç
duyabilirsiniz. Varsayılan olarak string veri değerleri yalın string olarak sayılır. Değerin SQL ifadesi
olduğunu , bundan dolayı tırnak içine alınmaması gerektiğini belirtmek için düz metin olarak vermek yerine
veri dizisindeki değeri Zend_Db_Expre tipinde nesne olarak verin.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: İfadelerin Tabloya Eklenmesi

.. code-block::
   :linenos:
   <?php
   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Oluşturulmuş Değere Erişmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bazı RDBMS markaları brincil anahtarların otomatik artışını (auto_increment) destekler. Bu şekilde
tanımlanmış bir tablo , yeni satır eklenmesinde (INSERT) otomatik olarak birincil anahtar değeri oluşturur.
*insert()* metodunun döndürdüğü değer son eklenen ID **değildir**, çünkü tablo otomatik artan sütuna
sahip olmayabilir. Bunun yerine dönen değer etkilenen satır sayısıdır. ( genellikle 1)

Eğer tablonuz otomatik artan birincil anahtar ile tanımlanmış ise , ekleme ardından *lastInsertId()* metodunu
çağırabilirsiniz. Bu metod mevcut veri tabanı bağlantısı kapsamında oluşturulan son değeri döndürür.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Otomatik artış anahtarı için lastInsertId() kullanımı

.. code-block::
   :linenos:
   <?php
   $db->insert('bugs', $data);

   // otomatik artışlı sütun tarafından oluşturulan son değeri döndür
   $id = $db->lastInsertId();

Bazı RDBMS markaları eşsiz değerler üreterek birincil anahtar vazifesi gören sequence nesnesi destekliyor.
Sequence'i desteklemek için *lastInsertId()* metodu iki tane isteğe bağlı string argüman alıyor. Değerler
üreten bir sequence için sequence'i tablo ve sütun isimleri kullanılarak adlandırma kuralına uyduğun
varsayılarak bu argümanlar tablo ve sütunları isimlendirir ve "\_seq" sonekini alır. Bu PostgreSQL tarafından
kullanılan seri (SERIAL) sütunlar için sequenceları adlandırma kuralına dayanır. Örneğin "bug_id" birincil
anahtar sütunlu "bugs" tablosu "bugs_bug_id_seq" olarak adlandırılmış sequence kullanır.

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: lastInsertId()'nin sequence için kullanılması

.. code-block::
   :linenos:
   <?php
   $db->insert('bugs', $data);

   // 'bugs_bug_id_seq' sequence'i tarafından üretilen son değeri döndür.
   $id = $db->lastInsertId('bugs', 'bug_id');

   // alternatif olarak 'bugs_seq' squence'i tarafından üretilen son değeri döndür.
   $id = $db->lastInsertId('bugs');

Eğer sequence nesnenizin adı bu adlandırma kuralına uymuyorsa , bunun yerine *lastSequenceId()* metodunu
kullanın. Bu metod sequence'i harfi harfine adlandıran tek bir string argüman alıyor.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: lastSequenceId() Kullanımı

.. code-block::
   :linenos:
   <?php
   $db->insert('bugs', $data);

   // 'bugs_id_gen' sequence'i tarafından üretilen son değeri döndür.
   $id = $db->lastSequenceId('bugs_id_gen');

Sequence'ları desteklemeyen RDBMS markaları için ,bunlara MySQL , Microsoft SQL Server ve SQLite'da dahil ,
lastInsertId() metoduna verilen argümanlar gözardı edilir ve döndürülen değer mevcut bağlantı sırasında
INSERT işlemleri ile meydana gelen en son değer döndürülür. Bu RDBMS markaları için lastSequenceId() metodu
herzaman için *null* döndürür.

.. note::

   **Neden "SELECT MAX(id) FROM table" kullanılmamalı ?**

   Bazen bu sorgu tabloya en son eklenen birincil anahtar değerini döndürür.Ancak bu tekniğin birden çok
   istemcinin veri tabanına kayıt eklediği ortamlarda kullanılması güvenli değildir. İstemci uygulamanız
   tarafından Max(id) sorgusu gerçekleştirildiği sırada başka bir istemcinin başka bir satır eklemesi
   mümküm ve işte bu yüzden bu eninde sonunda gerçekleşecektir. Böylece geri döndürülen değer sizin
   eklediğiniz satırı değil , diğer istemci tarafından eklenen satırı tanımlıyacak. Bunun ne zaman
   gerçekleştiğini bilmeninde bir yolu yok.

   "repeatable read" gibi güçlü hareket(transaction) yalıtım modu kullanılması riski azaltabilir ama , bazı
   RDBMS markaları bunun için gerekli hareket yalıtımını(isolation) desteklemez veya uygulamanız tasarımı
   gereği daha düşük seviye hareket yalıtımı kullanır.

   Üstelik yeni birincil anahtar değeri elde etmek için "MAX(id)+1" ifadesinin kullanılması da güvenli
   değildir çünkü iki istemci eş zamanlı olarak bu sorguyu gerçekleştirebilir ve sonra ikiside gelecek
   INSERT işlemleri için hesaplanan aynı değeri kullanır.

   Tüm RDBMS markalarının eşsiz değerler üretmek ve üretilen son değeri geri döndürmek için
   mekanizmaları vardır. Bu mekanizmalar ister istemez hareket yalıtımı kapsamı dışında çalışıyor bu
   yüzden iki istemcinin aynı değeri üretmesi ve başka bir istemci tarafından değer üretildiğinde
   istemcinizin bağlantısına bildirilme şansı yoktur.

.. _zend.db.adapter.write.update:

Verinin Güncellenmesi
^^^^^^^^^^^^^^^^^^^^^

Bağdaştırıcının *update()* metodunu kullanarak veri tabanı tablosundaki satırları güncelleyebilirsiniz.
Bu metod üç argüman alıyor: ilki tablonun adı ; ikincisi değiştirilecek sütunları alacakları yeni
değerlere eşleyen birleşmeli dizi.

Veri dizisindeki değerler düz string muamelesi görür. Veri dizisinde SQL ifadeleri kullanımı hakkında daha
fazla bilgi için bakınız :ref:` <zend.db.adapter.write.insert>`

Üçüncü argüman değişecek satırlar için kriter olarak kullanılan SQL ifadesi içeren stringdir.Bu
argümandaki değerler ve tanımlayıcılara tırnaklanma veya kaçış uygulanmaz. String'e dinamik içeriğin
güvenle eklenmesinden siz sorumlusunuz. Buna yardımcı olacak metodlar için bakınız :ref:`
<zend.db.adapter.quoting>`.

Geri döndürülen değer güncelleme işleminden etkilenen satır sayısıdır.

.. _zend.db.adapter.write.update.example:

.. rubric:: Satırların güncellenmesi

.. code-block::
   :linenos:
   <?php
   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

Eğer üçüncü argümanı koymazsanız veri tabanı tablosundaki tüm satırlar veri dizisinde belirtilen
değerler ile güncellenir.

Üçüncü argümana stringler dizisi verirseniz , bu stringler *AND* operatörü ile ayrıştırılmış ifadede
terimler olarak birleştirilir.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Satırların ifadeler dizisi kullanılarak güncellenmesi

.. code-block::
   :linenos:
   <?php
   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // SQL'in son hali:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Veri Silme
^^^^^^^^^^

*delete()* metodunu kullanarak veri tabanı tablosundan satırlar silebilirsiniz. Bu metod iki argüman alıyor:
ilki tabloyu isimlendiren string.

İkinci argüman silinecek satırlar için kriter olarak kullanılan SQL ifadesi içeren string.Bu argümandaki
değerler ve tanımlayıcılara tırnaklanma veya kaçış uygulanmaz.String'e dinamik içeriğin güvenle
eklenmesinden siz sorumlusunuz. Buna yardımcı olacak metodlar için bakınız :ref:` <zend.db.adapter.quoting>`.

Geri döndürülen değer silme işleminden etkilenen satır sayısıdır.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Satırların silinmesi

.. code-block::
   :linenos:
   <?php
   $n = $db->delete('bugs', 'bug_id = 3');

Eğer üçüncü argümanı koymazsanız bunun sonucunda veri tabanı tablosundaki tüm satırlar silinir.

Üçüncü argümana stringler dizisi verirseniz , bu stringler *AND* operatörü ile ayrıştırılmış ifadede
terimler olarak birleştirilir.

.. _zend.db.adapter.quoting:

Değerlerin ve Tanımlayıcıların Tırnaklanması
--------------------------------------------

SQL sorgularını biçimlendirdiğiniz zaman sık sık PHP değişkenlerinin değerlerini SQL ifadesine eklemeniz
gerekir.Bu risklidir çünkü , eğer PHP string'i tırnak sembolü gibi belli sembolleri içerirse geçersiz SQL'e
sebep olur. Örneğin takip eden sorgudaki tırnakların dengesizliğine dikkat edin:

   .. code-block::
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



En kötüsü ise böyle kod hatalarının web uygulamanızın işlevini değiştirmek isteyen biri tarafından
tasarlanarak sömürülebilmesi(exploitlenmesi). Eğer PHP değişkeninizin değerini HTTP parametresi veya başka
bir mekanizma ile belirtebiliyorlarsa , kişinin okumaya yetkisi olmayabilecek verinin geri döndürülmesi gibi
SQL sorgunuzun yapmasını istemediğiniz şeyleri yapmasını sağlayabilirler. Bu "SQL Injection" olarak bilinen
ciddi ve yaygın uygulama güvenliği ihlali tekniğidir (bakınız `http://en.wikipedia.org/wiki/SQL_Injection`_).

Zend_Db Bağdaştırıcı sınıfı PHP kodunuzun SQL Injection saldırılarına karşı açıkları azaltmanıza
yardımcı olan kullanışlı fonksiyonlar sağlamaktadır. Çözüm ise PHP değerlerindeki tırnaklar gibi özel
karakterlere SQL stringlerinize katılmadan kaçış uygulamak(escaping).

.. _zend.db.adapter.quoting.quote:

quote() Kullanımı
^^^^^^^^^^^^^^^^^

*quote()* metodu boyutsuz(vektörel olmayan) bir argüman alıyor. Değeri kullandığınız RDBMS'e göre özel
karakterlere kaçış uygulayarak ve string değer sınırlayıcıları ile çevreleyip döndürür. Standart SQL
string değer sınırlayıcısı tek tırnaktır (*'*).

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: quote() Kullanımı

.. code-block::
   :linenos:
   <?php
   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Dikkat , *quote()*'un döndürdüğü değer string etrafındaki tırnak sınırlayıcılarınıda içeriyor. Bu
özel karakterlere kaçış uygulayan bazı fonksiyonlardan farklı ama tırnak sınırlayıcılarını eklemiyor ,
örneğin `mysql_real_escape_string()`_.

Kullanıldıkları SQL veritipi bağlamında değerlerin tırnaklanması veya tırnaklanmaması gerekebilir.
Örneğin bazı RDBMS markalarında tam sayı değerler eğer tamsayı tipinde bir sütunla veya ifadeyle
karşılaştırılıyorsa string gibi tırnaklanmamalı. Diğer bir ifadeyle , *intColumn*'un SQL veritipinin
*INTEGER* olduğunu varsayarsak bazı SQL yürütmelerinde takip eden sorgu hata verecektir.

   .. code-block::
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



Belirttiğiniz SQL veritipi için opsiyonel ikinci argümanı kullanabilirsiniz.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: quote()'un SQL tipi ile kullanımı

.. code-block::
   :linenos:
   <?php
   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quoteType($value, 'INTEGER');


Her Zend_Db_Adapter sınıfı sayısal SQL veritiplerini karşı gelen RDBMS markaları için kodlamıştır.
Ayrıca sabitleri (*Zend_Db::INT_TYPE*, *Zend_Db::BIGINT_TYPE*, ve *Zend_Db::FLOAT_TYPE*) kullanarak daha RDBMS
bağımsız şekilde kod yazabilirsiniz.

Tabloların anahtar sütunlarına başvuran SQL sorguları üretirken Zend_Db_Table SQL tiplerini *quote()*'a
belirtir.

.. _zend.db.adapter.quoting.quote-into:

quoteInto() Kullanımı
^^^^^^^^^^^^^^^^^^^^^

Tırnaklamanın en tipik kullanım şekli bir PHP değişkenini SQL ifadesi veya deyimine katmaktır. *quoteInto()*
metodunu kullanarak bunu bir adımda yapabilirsiniz. Bu metod iki argüman alıyor: ilk argüman yer tutucu
sembolü (*?*) içeren string , ve ikinci argüman ise yer tutucu yerine koyulacak bir değer veya PHP değişkeni
olmalı.

Yer tutucu sembolü birçok RDBMS markası tarafından kullanılan konumsal parametreler için kullanan sembolle
aynıdır , ama *quoteInto()* metodu sadece sorgu parametrelerini öykünür(emule eder). Metod basitce değeri
stringe ekler , özel karakterlere kaçış uygular ve etrafını tırnaklar. Doğru sorgu parametreleri SQL
stringi ile parametrelerin ayrılmasını , deyim RDBMS sunucusundaymış gibi ayıklanmasına sağlar.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: quoteInto() Kullanımı

.. code-block::
   :linenos:
   <?php
   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

*quoteInto()*'nun opsiyonel üçüncü parametresini SQL veri tipi belirtmek için kullanabilirsiniz.Sayısal
tipler tırnaklanmaz ve diğer tipler tırnaklanır.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: quoteInto()'nun SQL tipi ile kullanımı

.. code-block::
   :linenos:
   <?php
   $sql = $db->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

quoteIdentifier() Kullanımı
^^^^^^^^^^^^^^^^^^^^^^^^^^^

SQL sözdiziminde değişken olması gerekebilecek tek kısım değerler değil. Eğer PHP değişkenlerini
tabloları,sütunları veya diğer tanımlayıcıları isimlendirmek için kullanıyorsanız bu stringleri de
tırnaklamanız gerekebilir. Varsayılan olarak SQL tanımlayıcıları PHP ve diğer programlama dilleri gibi bir
sözdizim kuralına sahip. Örneğin tanımlayıcılar boşluk,noktalama işareti, özel karakter, veya
uluslararası karekter içermemeli. Ayrıca bazı kelimeler SQL sözdizimi için ayrılmıştır ve bunlar
tanımlayıcı olarak kullanılmamalı.

Ancak bununla birlikte SQL'in **sınırlandırılmış tanımlayıcılar (delimited identifiers)** olarak bilinen
tanımlayıcıların belirtilmesine daha geniş seçeneklere izin veren bir özelliği var. Eğer SQL
tanımlayıcılarını düzgün tırnak tipleriyle kapsarsanız tırnaksız yazımı hatalı olacak
tanımlayıcıları kullanabilirsiniz. Sınırlandırılmış tanımlayıcılar boşluk,noktalama,uluslararası
karakter içerebilir. Ayrıcı SQL ayrılmış kelimelerini tanımlayıcı sınırlandırıcıları ile
kapsarsanız kullanabilirsiniz.

*quoteIdentifier()* metodu *quote()* metodu gibi çalışır ama tanımlayıcı sınırlandırıcı karakterlerini
kullandığınız bağdaştırıcıya uygun olarak stringe uygular. Örneğin , standart SQL tanımlayıcı
sınırlandırıcıları için (*"*) çift tırnak kullanır. MySQL varsayılan olarak ters tırnak (*`*)
kullanır. Ayrıca *quoteIdentifier()* metodu string argüman içerisindeki özel karakterlere kaçış uygular.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: quoteIdentifier() Kullanımı

.. code-block::
   :linenos:
   <?php
   // tablo adımız SQL ayrılmış kelimesi olabilir
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

SQL sınırlandırılmış tanımlayıcılar tırnaklanmamış tanımlayıcılardan farklı olarak küçük-büyük
harf duyarlıdır. Bu nedenle sınırlandırılmış tanımlayıcılar kullanacaksanız tanımlayıcıların
yazımı tam olarak şemanızda olduğu gibi , harflerin küçük-büyük harf durumuda dahil olmak üzere tıpa
tıp aynı olmalı.

Çoğu durumda Zend_Db sınıfları tarafından üretilen SQL'de varsayılan olarak tüm tanımlayıcılar otomatik
olarak sınırlandırılır. Bu davranışı *Zend_Db::AUTO_QUOTE_IDENTIFIERS* seçeneği ile
değiştirebilirsiniz.Bunu Bağdaştırcı instance'ı oluşturken belirtin. Bakınız :ref:`
<zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Veri tabanı Hareketlerinin(Transactionların) Kontrolü
-----------------------------------------------------

Veri tabanları hareketleri birden çok tabloda çalışsa dahi tekbir değişiklikle teslim edilebilir(commit)
veya geri alınabilir(roll back) işin mantıksal birimleri olarak tanımlar.Veri tabanı sürücüsü sorguları
dolaylı olarak yönetiyor olsa da veri tabanındaki tüm sorgular hareket bağlamında çalıştırılır.
Çalıştırdığınız her deyim için hareket oluşturulur ve SQL deyiminiz çalıştırıldıktan sonra teslim
edilir işte buna **auto-commit** denir. Varsayılan olarak tüm Zend_Db Bağdaştırıcı sınıfları auto-commit
modunda işliyor.

Alternatif olarak hareketin başlangıcını ve çözünürlülüğünü belirtebilir böylece bir işlemde ne
kadar SQL sorgusunun bir gruba dahil oldup teslim edildiğini (veya geri alındığını) kontrol edebilirsiniz.
Bir hareketi başlatmak için *beginTransaction()* metodunu kullanın. Siz açıkca ortadan kaldırana kadar
,sonraki SQL deyimleri aynı hareket bağlamında çalıştırılır.

Hareketi ortadan kaldırmak için *commit()* veya *rollBack()* metodlarından birini kullanın. *commit()* metodu
vaat edildiği gibi hareket sırasında yapılan değişiklikleri işaretler , bunun anlamı diğer hareketlerde
çalışan sorgulara bu değişikliklerin gözükeceğidir.

*rollBack()* metodu tersini yapar:hareket sırasında yaptığınız değişiklikleri göz ardı eder.
Değişiklikler etkin olarak yapılmamıştır , dönen verinin durumu harekete başlamadan önceki gibidir. Ancak
hareketi geri almak aynı zamanda çalışan hareketler tarafından yapılan değişiklikleri etiklemeyecektir.

Hareketi ortadan kaldırdıktan sonra *Zend_Db_Adapter* siz tekrar *beginTransaction()* çağırana kadar
auto-commit modunu döndürür.

.. _zend.db.adapter.transactions.example:

.. rubric:: Tutarlılığı sağlamak için Hareketin Yönetilmesi

.. code-block::
   :linenos:
   <?php
   // Açıkca hareketi başlat.
   $db->beginTransaction();

   try {
       // Birkaç sogu çalıştırmayı dene:
       $db->query(...);
       $db->query(...);
       $db->query(...);

       //Eğer hepsi başarılıysa hareketi teslim et ve tüm değişiklikler
       // bir kerede teslim edilsin.
       $db->commit();

   } catch (Exception $e) {
       // Eğer sorgulardan herhangi biri başarısız olur ve
       // exeption fırlatırsa tüm hareketi geri almak ve
       // başarılı olsa dahi hareketde yapılan değişikleri
       // geri çevirmek istiyoruz.
       // Böylece ya hep beraber teslim ediliyor
       // yada hiçbiri teslim edilmiyor.

       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Listeleme ve Açıklama Tabloları
-------------------------------

*listTables()* metodu mevcut veritabanındaki tabloları isimlendiren string dizisi döndürür.

*describeTable()* metodu tablo hakkında birleşmeli metadata dizisi geri döndürür. Bu metodun ilk argümanına
tablo adını string olarak belirtir. İkinci argüman isteğe bağlı ve bulunduğu tabloda şemayı
isimlendiriyor.

Dönen birleşmeli dizinin anahtarları tablonun sütun adlarıdır. Her sütuna karşı gelen değer ayrıca takip
eden anahtarları ve değerleriyle birleşmeli dizidir:

.. _zend.db.adapter.list-describe.metadata:

.. table:: describeTable()'ın döndürdüğü Metadata alanları

   +----------------+---------+---------------------------------------------------------------------------+
   |Anahtar         |Tip      |Açıklama                                                                   |
   +================+=========+===========================================================================+
   |SCHEMA_NAME     |(string) |Bu tablonun var oluduğu veri tabanı şemasının adı.                         |
   +----------------+---------+---------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Bu sütunun ait olduğu tablonun adı.                                        |
   +----------------+---------+---------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Sütunun adı.                                                               |
   +----------------+---------+---------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Sütunun tablodaki sırası.                                                  |
   +----------------+---------+---------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |Sütunun veritipinin RDBMS adı.                                             |
   +----------------+---------+---------------------------------------------------------------------------+
   |DEFAULT         |(string) |Eğer varsa sütunun varsayılan değeri.                                      |
   +----------------+---------+---------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|Tablo SQL NULL'ları kabul ediyorsa True , tablonun NULL kısıtı yoksa false.|
   +----------------+---------+---------------------------------------------------------------------------+
   |LENGTH          |(integer)|Tablonun RDBMS tarafından raporlanan uzunluğu veya boyutu.                 |
   +----------------+---------+---------------------------------------------------------------------------+
   |SCALE           |(integer)|SQL NUMERIC 'in veya DECIMAL'ın derecesi.                                  |
   +----------------+---------+---------------------------------------------------------------------------+
   |PRECISION       |(integer)|SQL NUMERIC'in veya DECIMAL'ın duyarlılığı.                                |
   +----------------+---------+---------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|Eğer tamsayı tabanlı tip işaretsiz olarak bildirilmişse True.              |
   +----------------+---------+---------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|Eğer sütun birincil anahtarın bir parçası ise True.                        |
   +----------------+---------+---------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Birincil anahtardaki sütunun sırasal(1'den başlayan) pozisyonu.            |
   +----------------+---------+---------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|Sütun otomatik oluşturulmuş değer kullanıyorsa True.                       |
   +----------------+---------+---------------------------------------------------------------------------+

Tablo adıyla ve isteğe bağlı şema adıyla eşleşen tablo yoksa *describeTable()* boş dizi döndürür.

.. _zend.db.adapter.closing:

Bağlantının Kapatılması
-----------------------

Genellikle veri tabanı bağlantısının kapatılması gerekmez. PHP otomatik olarak istek sonunda tüm
kaynakları temizler. Veri tabanı eklentileri kaynak nesnesi temizlendiği zaman bağlantıyı kapatacak şekilde
dizayn edilmiştir.

Ancak birçok veri tabanı bağlantısı başlatan PHP betiğiniz(script'iniz) varsa RDBMS sunucunuzun kapasitesini
tüketmemek için bağlantıyı kapatmanız gerekebilir. Bağdaştırıcının *closeConnection()* metodunu var
olan veri tabanı bağlantısını kapatmak için kullanabilirsiniz.

.. _zend.db.adapter.closing.example:

.. rubric:: Veri tabanı bağlantısının kapatılması

.. code-block::
   :linenos:
   <?php
   $db->closeConnection();

.. note::

   **Zend_Db sürekli(persistent) bağlantıları destekliyor mu?**

   Sürekli bağlantıların kullanımı Zen_Db tarafından desteklenmiyor veya tercih edilmiyor.

   Sürekli bağlantıların kullanımı RDBMS sunucusunda fazla boş bağlantının olmasına sebep olabilir , bu
   bağlantı oluşturmak için gereken ek yükü azaltarak sağlayacağınız performans artışından daha çok
   problem getirecektir.

   Veri tabanı bağlantılarının durumu vardır. Öyleki RDBMS sunucusunda bazı nesneler oturum kapsamında var
   olur. Örnek olarak kilitler,kullanıcı değişkenleri,geçici tablolar ve son çalıştırılan sorgu
   hakkında etkilenen satırlar , üretilen son id değeri gibi bilgiler. Eğer sürekli bağlantılar
   kullanırsanız uygulamanız önceki PHP isteği tarafından oluşturulan geçersiz veya yetkisiz veriye
   erişebilir.

.. _zend.db.adapter.other-statements:

Diğer Veri tabanı deyimlerinin çalıştırılması
---------------------------------------------

PHP veri tabanı eklentisi tarafından sağlanan bağlantı nesnesine direk bağlantı kurma ihtiyacınız olacak
durumlar olabilir. Bu eklentilerin kimisi Zend_Db_Adapter_Abstract tarafından kapsanmayan özellikler sunabilir.

Örneğin Zend_Db'nin çalıştırdığı tüm SQL deyimleri önce hazırlanır sonra çalıştırılır. Ancak
bazı veri tabanı özellikleri hazırlanmış deyimlerle uyumsuzdur. CREATE ve ALTER gibi DDL deyimleri MySQL'de
hazırlanamaz. Ayrıca MySQL 5.1.17 öncesinde SQL deyimleri `MySQL Query Cache`_'den faydalanmaz.

Çoğu PHP veri tabanı eklentisi SQL deyimlerini hazırlamadan çalıştıran metod sağlamaktadır. Örneğin ,
PDO'de bu metod *exec()*'dir. PHP eklentisindeki bağlantı nesnesine getConnection() kullanarak direk
erişebilirsiniz.

.. _zend.db.adapter.other-statements.example:

.. rubric:: PDO bağdaştırıcısında hazırlanmamış deyim çalıştırmak

.. code-block::
   :linenos:
   <?php
   $result = $db->getConnection()->exec('DROP TABLE bugs');

Benzer şekilde PHP veri tabanı eklentilerine özel diğer metodlara ulaşabilirsiniz. Bilerek bunun yapılması
uygulamanızı belli marka RDBMS'ler için sağlanan veri tabanı eklentisinin arayüzüyle sınırlandırabilir.

Zend_Db'nin gelecek sürümlerinde fonksiyonellik için desteklenen PHP veritabanı eklentilerine mahsus method
giriş noktaları ekleme fırsatı olacak. Bu geriye uyumluluğu etkilemeyecek.

.. _zend.db.adapter.adapter-notes:

Belirli Bağdaştırılar üzerine Notlar
------------------------------------

Bu bölüm farkında olmanız gereken bağdaştırıcı sınıfları arasındaki farkları listeliyor.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Db2' adıyla belirtin.

- Bu bağdaştırıcı ibm_db2 PHP eklentisini kullanıyor.

- IBM DB2 sequence'leri ve otomatik artan anahtarları desteklemektedir. Bu yüzden *lastInsertId()* metodunun
  argümanları isteğe bağlıdır. Eğer argüman vermezseniz bağdaştırıcı otomatik artışlı anahtar için
  üretilen son değeri döndürecektir. Eğer argüman verirseniz bağdaştırıcı kuralına göre isimlendirilen
  sequence'in ('**table**\ _ **column**\ _seq') ürettiği son değeri döndürecektir.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Mysqli' adıyla belirtin.

- Bu bağdaştırıcı mysqli PHP eklentisinden faydalanmaktadır.

- MySQL sequence'ları desteklemiyor bu yüzden *lastInsertId()* argümanlarını yok sayar ve otomatik artışlı
  anahtar içi üretilen son değeri döndürür. *lastSequenceId()* metodu *null* döndürür.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Oracle' adıyla belirtin.

- Bu bağdaştırıcı oci8 PHP eklentisini kullanıyor.

- Oracle otomatik artan anahtarları desteklemiyor bu yüzden *lastInsertId()*'ye veya *lastSequenceId()*'ye
  sequence'in adını belirtmelisiniz.

- Oracle eklentisi konumsal parametreleri desteklemiyor. Adlandırılan parametreleri kullanmalısınız.

- Şu anda *Zend_Db::CASE_FOLDING* seçeneği Oracle bağdaştırıcısı tarafından desteklenmiyor. Bu seçeneği
  Oracle ile kullanabilmek için PDO OCI bağdaştırıcısını kullanmalısınız.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

IBM DB2 ve Informix Dynamic Server (IDS) için PDO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Ibm' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_ibm PHP eklentilerini kullanıyor.

- En azından PDO_IBM eklentisinin 1.2.2 sürümünü kullanmalısınız. Eğer bu eklentinin daha öncesi bir
  sürümüne sahipseniz PDO_IBM eklentisini PECL'den güncellemelisiniz.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Mssql' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_mssql PHP eklentilerini kullanıyor.

- Microsoft SQL Server sequence'ları desteklemiyor bu yüzden *lastInsertId()* argümanlarını yok sayar ve
  otomatik artışlı anahtar içi üretilen son değeri döndürür. *lastSequenceId()* metodu *null* döndürür.

- Zend_Db_Adapter_Pdo_Mssql SQL Server veri tabanına bağlanır bağlanmaz *QUOTED_IDENTIFIER ON* yapar. Bu
  sürücünün tanıtıcı sınırlandırmaları için SQL Server'ın köşeli parantezi yerine standart SQL
  tanıtıcı sınırlandırıcı sembolü (*"*) kullanmasını sağlar.

- Seçenekler dizisinde *pdoType*'ı anahtar olarak belirtebilirsiniz. Değer "mssql"(varsayılan) ,"dblib",
  "freetds" , veya "sybase" olabilir. Bu seçenek bağdaştırıcının DSN string'ini inşa sırasında
  kullandığı DSN önekini etkiler. "freetds" ve "sybase"`FreeTDS`_ kütüphane seti için kullanılan "sybase:"
  önekini içerir. Ayrıca bu sürücede kullanılan DSN önekleri hakkında daha çok bilgi için bakınız
  `http://www.php.net/manual/en/ref.pdo-dblib.connection.php`_

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Mysql' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_mysql eklentilerini kullanıyor.

- MySQL sequence'ları desteklemiyor , bu yüzden *lastInsertId()* argümanlarını yok sayar ve otomatik
  artışlı anahtar içi üretilen son değeri döndürür. *lastSequenceId()* metodu *null* döndürür.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Oci' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_oci PHP eklentilerini kullanıyor.

- Oracle otomatik artışlı anahtarları desteklemiyor bu yüzden sequence'in adını *lastInsertId()* veya
  *lastSequenceId()*'ye belirtmelisiniz.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Pgsql' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_pgsql eklentilerini kullanıyor.

- PostgreSQL otomatik artışlı anahtarları hem de sequence'ları destekliyor. Bu nedenle *lastInsertId()*
  argümanları isteğe bağlı. Eğer hiç argüman vermezseniz bağdaştırıcı otomatik artışlı anahtar
  için üretilen son değeri döndürür. Eğer argümanları verirseniz bağdaştırıcı bağdaştırıcı
  kuralına göre isimlendirilen sequence'in ('**table**\ _ **column**\ _seq') ürettiği son değeri
  döndürecektir.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Bu bağdaştırıcıyı factory() metoduna 'Pdo_Sqlite' adıyla belirtin.

- Bu bağdaştırıcı pdo ve pdo_sqlite eklentilerini kullanıyor.

- SQLite sequence'ları desteklemiyor , bu yüzden *lastInsertId()* argümanlarını yok sayar ve otomatik
  artışlı anahtar içi üretilen son değeri döndürür. *lastSequenceId()* metodu *null* döndürür.

- SQLite2 veri tabanına bağlanmak için Pdo_Sqlite bağdaştırcısının instance'ını oluştururken
  parametreler dizisine *'dsnprefix'=>'sqlite2'* ekleyin.

- Hafızadaki (in-memory) SQLite veri tabanına bağlanmak için Pdo_Sqlite bağdaştırcısının instance'ını
  oluştururken parametreler dizisine *'dsnprefix'=>'sqlite2'* ekleyin.

- PHP için SQLite sürücüsünün eski sürümleri sonuç listesinde kısa sütun adları kullanılmasını
  sağlamak için gerekli olan PRAGMA komutlarını desteklemiyor gibi. Eğer join sorgusu yaptığınızda sonuç
  listeniz "tabloadı.sütunadı" şeklinde problemli dönüyorsa PHP'nin güncel sürümüne terfi etmelisiniz.



.. _`PHP Data Objects (PDO)`: http://www.php.net/pdo
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_mssql`: http://www.php.net/pdo-mssql
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`http://en.wikipedia.org/wiki/SQL_Injection`: http://en.wikipedia.org/wiki/SQL_Injection
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL Query Cache`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/en/ref.pdo-dblib.connection.php`: http://www.php.net/manual/en/ref.pdo-dblib.connection.php
