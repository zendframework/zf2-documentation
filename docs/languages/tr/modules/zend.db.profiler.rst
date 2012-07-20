.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Giriş
-----

*Zend_Db_Profiler* sorgularınızın profillenmesine imkan verir. Profiller bağdaştırıcı tarafından işlenen
sorguları hem de sorguları çalıştırmak için geçen süreyi içerir ve gerçekleştirilen sorguların
sınıflarınıza ek hata ayıklama kodu eklemeden incelenmesini mümkün kılar. Ayrıca gelişmiş kullanım
geliştiriciye hangi sorguların profilleneceğini filtrelemeye izin verir.

Profilleyiciyi (profiler'ı) bağdaştırıcı yapıcısına gerekli direktifi vererek yada bağdaştırıcıdan
sonra etkinleştirmesini isteyerek etkinleştirebilirsiniz.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Db.php';

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
       'profiler' => true  // profilleyiciyi aç; kapatmak için false yapın (varsayılan)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // profilleyiciyi kapat:
   $db->getProfiler()->setEnabled(false);

   // profilleyiciyi aç:
   $db->getProfiler()->setEnabled(true);

*profiler* seçeneğinin değeri esnektir.Tipine göre farklı yorumlanır. Çoğu zaman basit bir boole değer
kullanmalısınız ama diğer tipler profilleyicinin davranışını özelleştirmenizi sağlar.

Boole argüman *true* ise profilleyiciyi etkinleştirir , veya *false* ise etkisizleştirir. Profilleyici sınıfı
bağdaştırıcı'nın varsayılan profilleyici sınıfı , örneğin *Zend_Db_Profiler*.

   .. code-block::
      :linenos:

      $params['profiler'] = true;
      $db = Zend_Db::factory('PDO_MYSQL', $params);



Profilleyicinin bir instance'ı bağdaştırıcının o nesneyi kullanmasını sağlar. Nesne *Zend_Db_Profiler*
veya bu nedenle altsınıf(subclass) tipinde olmalı.Profilleyicinin etkinleştirilmesi ayrı olarak yapıldı.

   .. code-block::
      :linenos:

      $profiler = MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $params['profiler'] = $profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);



Argüman '*enabled*', '*instance*', ve '*class*' anahtarlarından herhangi birini içeren birleşmeli dizi
olabilir. '*enabled*' ve '*instance*' anahtarları boole ve yukarıda belgelenen örnek tiplere uyar. '*class*'
anahtarı özel bir profilleyici kullanmak için bir sınıfı isimlendirmek için kullanılır. Sınıf mutlaka
*Zend_Db_Profiler* veya altsınıf olmalı. Sınıfın yapıcı argümanları olmadan intance'ı oluşturuldu.
'*instance*' seçeneği sağlandığında '*class*' seçeneği gözardı edilir.

   .. code-block::
      :linenos:

      $params['profiler'] = array(
          'enabled' => true,
          'class'   => 'MyProject_Db_Profiler'
      );
      $db = Zend_Db::factory('PDO_MYSQL', $params);



Son olarak argüman yukarıda açıklandığı gibi dizi anahtarları olarak işlem gören özellikler içeren
*Zend_Config* tipinin nesnesi olabilir. Örneğin "config.ini" dosyası takip eden veriyi içerebilir:

   .. code-block::
      :linenos:

      [main]
      db.profiler.class   = "MyProject_Db_Profiler"
      db.profiler.enabled = true

Yapılandırma takip eden PHP kodu ile uygulanabilir:

   .. code-block::
      :linenos:

      $config = new Zend_Config_Ini('config.ini', 'main');
      $params['profiler'] = $config->db->profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);

'*instance*' özelliği aşağıdaki gibi kullanılabilir:

   .. code-block::
      :linenos:

      $profiler = new MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $configData = array(
          'instance' => $profiler
          );
      $config = new Zend_Config($configData);
      $params['profiler'] = $config;
      $db = Zend_Db::factory('PDO_MYSQL', $params);



.. _zend.db.profiler.using:

Profilleyiciyi Kullanma
-----------------------

Herhangi bir noktada bağdaştırıcının *getProfiler()* metodu ile profilleyiciyi yakalayın:

.. code-block::
   :linenos:
   <?php
   $profiler = $db->getProfiler();

Bu *Zend_Db_Profiler* nesnesinin instance'ını döndürür. Bu instance ile geliştirici çeşitli metodlar ile
sorgularınızı gözden geçirebilir:

- *getTotalNumQueries()* profillenen sorguların toplam adedini döndürür.

- *getTotalElapsedSecs()* profillenen tüm sorgular için geçen toplam süreyi saniye olarak döndürür.

- *getQueryProfiles()* sorgu profillerini dizi olarak döndürür.

- *getLastQueryProfile()* sorgunun bitip bitmemesine bakmaksızın son sorgu profilini döndürür.(Bitmediyse
  bitiş zamanı null olur)

- *clear()* stack'teki eski sorgu profillerini temizler.

*getLastQueryProfile()*'ın döndürdüğü değer ve *getQueryProfiles()*'ın her öğesi her sorgunun kendisiyle
denetlenmesini sağlayan *Zend_Db_Profiler_Query* nesneleridir:

- *getQuery()* sorgunun SQL metnini döndürür. Paremetreleriyle hazırlanmış deyimin SQL metni sorgunun
  hazırlandığı zamanki metindir bu yüzden paremetre yer tutucularını içerir , deyim çalıştırıldığı
  zamanki değerleri değil.

- *getQueryParams()* hazırlanmış sorguları çalıştırırken kullanılan paremetreleri dizi olarak
  döndürür. Bu uç paremetreleri ve deyimin *execute()* metoduna gelen argümaları içerir. Dizinin
  anahtarları konumsaldır ( 1 tabanlı) veya isimlendirilmiş (string) paremetre indislidir.

- *getElapsedSecs()* sorgunun çalıştığı süreyi saniye olarak döndürür.

*Zend_Db_Profiler*'ın sağladığı bilgi uygulamalardaki darboğazları profillemede ve çalıştırılan
sorgularda hata ayıklamada yararlıdır. Örneğin , tam olarak son çalıştırılan sorguyu görmek için :

.. code-block::
   :linenos:
   <?php
   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();

Muhtemelen sayfa yavaş oluşturuluyor;ilk önce profilleyici ile tüm sorgular için toplam kaç saniye
harcandığını belirleyin ve en uzun çalışan sorguyu bulmak için sorguları teker teker kontrol edin:

.. code-block::
   :linenos:
   <?php
   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo $totalTime . ' saniye içinde '. $queryCount .' adet sorgu çalıştırıldı' . "\n";
   echo 'Ortalama sorgu süresi : ' . $totalTime / $queryCount . ' saniye' . "\n";
   echo 'Saniye başı sorgu sayısı: ' . $queryCount / $totalTime . "\n";
   echo 'En uzun sorgu süresi: ' . $longestTime . "\n";
   echo "En uzun sorgu: \n" . $longestQuery . "\n";

.. _zend.db.profiler.advanced:

İleri Profilleyici Kullanımı
----------------------------

Sorgu denetlemeye ek olarak , profilleyici geliştiriciye hangi sorguların profilleneceğini filtrelemeye imkan
sağlar. Takip eden metodlar *Zend_Db_Profiler* isntance'ında çalışır:

.. _zend.db.profiler.advanced.filtertime:

Sorgu için harcanan süreye göre filtreleme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterElapsedSecs()* geliştiriciye sorgunun profillenmesi için geçmesi gereken mininimum süreyi belirleme
imkanı sağlar. Bu filtreyi kaldırmak için metoda null değer verin.

.. code-block::
   :linenos:
   <?php
   // Sadece en az 5 saniye süren sorguları profille:
   $profiler->setFilterElapsedSecs(5);

   // Süresine bakmaksızın tüm sorguları profille:
   $profiler->setFilterElapsedSecs(null);

.. _zend.db.profiler.advanced.filtertype:

Sorgu tipine göre filtreleme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterQueryType()* geliştiriciye hangi tip sorguların profilleneceğini bellirleme imkanı verir; birden çok
tip profillemek için mantıksal OR kullanın. Sorgu tipleri takip eden *Zend_Db_Profiler* sabitleri tarafından
tanımlanmıştır:

- *Zend_Db_Profiler::CONNECT*: bağlantı işlemleri veya veri tabanı seçimi.

- *Zend_Db_Profiler::QUERY*: Diğer tiplere uymayan genel veri tabanı sorguları.

- *Zend_Db_Profiler::INSERT*: veri tabanına yeni veri ekleyen herhangi bir sorgu , genellikle INSERT'li SQL.

- *Zend_Db_Profiler::UPDATE*: mevcut veriyi güncelleyen herhangi bir sorgu , genellikle UPDATE'li SQL.

- *Zend_Db_Profiler::DELETE*: mevcut veriyi silen herhangi bir sorgu , genellikle DELETE'li SQL.

- *Zend_Db_Profiler::SELECT*: mevcut veriyi getiren herhangi bir sorgu , genellikle SELECT'li SQL.

- *Zend_Db_Profiler::TRANSACTION*: herhangi hareket işlemi start transaction , commit veya rollback gibi.

*setFilterQueryType* ile var olan herhangi filtreyi argüman olarak sadece *null* vererek kaldırabilirsiniz.

.. code-block::
   :linenos:
   <?php
   // Sadece SELECT sorgularını profille
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // SELECT, INSERT, ve UPDATE sorgularını profille
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // DELETE sorgularını profille  ( böylece verinin neden kaybolmaya devam ettiğini anlayabilelim)
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Tüml filtreleri kaldır
   $profiler->setFilterQueryType(null);

.. _zend.db.profiler.advanced.getbytype:

Sorgu tipine göre profillere erişmek
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterQueryType()* kullanmak oluşturulan profilleri azaltabilir.Buna rağmen bazen tüm profilleri tutmak
yararlı olabilir ama bunlara ihtiyacınız olduğu anda bakın. *getQueryProfiles()*'ın bir diğer özelliği ise
ilk argüman olarak sorgu tipini (veya sorgu tiplerinin mantıksal kombinasyonu) vererek bu filtrelemeyi anında
yapabilmesidir ; sorgu tipi sabitleri listesi için bakınız :ref:` <zend.db.profiler.advanced.filtertype>`.

.. code-block::
   :linenos:
   <?php
   // Sadece SELECT sorgusu profillerine eriş
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Sadece SELECT, INSERT, and UPDATE  sorgusu profillerine eriş
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // DELETE sorgularına eriş ( böylece verinin neden kaybolmaya devam ettiğini
   // anlayabilelim)
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);


