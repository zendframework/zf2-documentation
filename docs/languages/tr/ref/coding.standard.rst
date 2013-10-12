.. EN-Revision: none
.. _coding-standard:

************************************
Zend Framework PHP Kodlama Standardı
************************************

.. _coding-standard.overview:

Genel Açıklama
--------------

.. _coding-standard.overview.scope:

Kapsam
^^^^^^

Bu belge geliştiriciler ve geliştirici takımları veya Zend Framework üzerinde geliştirme yapanlar için
yönergeler ve kaynaklar sağlamaktadır. Kapsanan konular :



   - PHP Dosya Biçimlemesi

   - İsimlendirme Kuralları

   - Kodlama Stili

   - Satıriçi Belgelendirme



.. _coding-standard.overview.goals:

Amaçlar
^^^^^^^

Her geliştirme projesinde iyi kodlama standartları önemlidir , ama bilhassa birden fazla geliştirici aynı
proje üstünde çalıştığında önemlidir.Kodlama standartlarına sahip olmak kodun yüksek kaliteli , az
hatalı ve kolayca bakıma alınabilir olmasını sağlamaktadır.

.. _coding-standard.php-file-formatting:

PHP Dosya Biçimlemesi
---------------------

.. _coding-standard.php-file-formatting.general:

Genel
^^^^^

Sadece PHP kodu içeren dosyalar için kapama etiketi ("?>") kullanılmamalı. PHP tarafından ihtiyaç
duyulmamaktadır.Bunu eklememek takip eden whitespace karakterlerin kazayla çıktıya eklenmesini önlemektedir.

**ÖNEMLİ:** *__HALT_COMPILER()* ile ikili herhangi veri dahil edilebilir olmasına rağmen herhangi bir Zend
Framework PHP dosyasıyla veya bunlardan türetilen dosyalarda dahil etme engellenmiştir. Bu özelliğin
kullanımına sadece bazı özel kurulum betiklerinde izin verilmiştir.

.. _coding-standard.php-file-formatting.indentation:

Girintili Yazma
^^^^^^^^^^^^^^^

Satırbaşı boşluğu olarak tab olmadan 4 boşluk kullanın.

.. _coding-standard.php-file-formatting.max-line-length:

Maksimum Satır Uzunluğu
^^^^^^^^^^^^^^^^^^^^^^^

Hedef satır uzunluğu 80 karakterdir , örn. geliştiriciler mümkün olduğunca kodu pratik olan 80-sütün
sınırına yakın tutmalılar.Gene de daha uzun satırlar kabul edilebilir.Herhangi bir satır PHP kodunun
maksimum uzunluğu 120 karakterdir.

.. _coding-standard.php-file-formatting.line-termination:

Satır Sonlandırma
^^^^^^^^^^^^^^^^^

Satır sonlandırma unix metin dosyaları için standart bir yöntemdir.Satırlar mutlaka linefeed(LF) ile
bitmelidir.Linefeed'ler ordinal olarak 10 veya onaltılık olarak 0x0A şeklinde temsil edilir.

Carriage return(CR)'leri Macintosh bilgisayarlardaki gibi (0x0D) kullanmayın.

Carriage return/linefeed kombinasyonunu (CRLF) Windows bilgisayarlardaki gibi (0x0D, 0x0A) kullanmayın.

.. _coding-standard.naming-conventions:

İsimlendirme Kuralları
----------------------

.. _coding-standard.naming-conventions.classes:

Sınıflar
^^^^^^^^

Zend Framework sınıfların isimlerini bulundukları dizinlere eşlenmesini sağlayan bir isimlendirme kuralına
sahip. Zend Framework'ün kök dizini altındaki tüm sınıfların hiyerarşik olarak barındırıldığı "Zend/"
dizinidir.

Sınıf isimleri sadece alfanümerik karakterlerden oluşabilir. Numaralar sınıf isimlerinde kullanılabilirler
ancak bu kullanım uygun bulunmamaktadır. Altçizgilerin sadece konum ayıracının yerine kullanılmasına izin
verilir -- "Zend/Db/Table.php" dosya adı mutlaka "Zend\Db\Table" sınıfına eşleme yapmalıdır.

Eğer sınıf adı birden çok kelimeden oluşuyorsa , her yeni kelimenin ilk harfi büyük harfe çevrilmelidir.
Ardışık büyütülmüş harflere izin verilmez, ör. "ZendPdf" sınıf ismi kabul edilirken "ZendPDF" sınıf
adı kabul edilmez.

Zend tarafından veya katılımcı ortak firmalardan biri tarafından yazılan ve Zend Framework ile dağıtılan
Zend Framework sınıfları "Zend\_" ile başlamalı ve bundan dolayı hiyerarşik olarak "Zend/" dizini içinde
yerini almalı.

Bunlar sınıflar için kabul edilebilir isimler :

   .. code-block:: php
      :linenos:

      Zend_Db

      Zend_View

      Zend\View\Helper

**ÖNEMLİ:** Framework ile çalışan fakat framework'ün bir parçası olmayan kod ör. framework'ün son
kullanıcısı tarafından yazılan ve Zend veya framework'e ortak şirketlerin olmayan kod asla "Zend\_" ile
başlamamalıdır.

.. _coding-standard.naming-conventions.interfaces:

Arayüzler
^^^^^^^^^

Arayüz sınıfları diğer sınıflarla aynı kurallara uymalıdır (yukarıya bakın) , buna rağmen aşağıdaki
örneklerde olduğu gibi mutlaka "Interface" kelimesi ile bitmeli :

   .. code-block:: php
      :linenos:

      Zend\Log_Adapter\Interface
      Zend\Controller_Dispatcher\Interface



.. _coding-standard.naming-conventions.filenames:

Dosya Adları
^^^^^^^^^^^^

Diğer tüm dosyalar için sadece alfanümerik karakterler , altçizgiler ve tire karakteri ("-") kullanılabilir.
Boşluklar ve geri kalan karakterler kullanılamaz.

PHP kodu içeren her dosya mutlaka ".php" dosya uzantısına sahip olmalıdır. Bu örnekler yukarıdaki
bölümdeki sınıf isimlerini içererek kabul edilebilen dosya isimleri göstermektedir :

   .. code-block:: php
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php

Dosya isimleri yukarıda açıklandığı gibi sınıf adına göre eşleşmeyi takip etmelidir.

.. _coding-standard.naming-conventions.functions-and-methods:

Fonksiyonlar ve Metodlar
^^^^^^^^^^^^^^^^^^^^^^^^

Fonksiyon isimleri sadece alfanümerik karakterler içerebilir. Altçizgiler fonksiyon isimlerinde kullanılamaz.
Numaralar kullanılabilir ancak bu kullanım uygun bulunmamaktadır

Fonksiyon isimleri her zaman küçük harfle başlamalı. Fonksiyon ismi birden fazla kelimeden oluştuğunda her
kelimenin ilk harfi büyük olmalı. Buna genellikle "camelCaps" metodu denir.

Fonksiyon isimleri uzun yazılmalı.Fonksiyon isimlerinin uzun olması kodun pratik olarak anlaşılabilirliğini
artırdığından , fonksiyon isimleri mümkün olduğunca uzun olmalı.

Bunlar kabul edilebilir fonksiyon isimleri:

   .. code-block:: php
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()



Nesneye dayalı programlamada nesne erişirleri(accessor) "get" veya "set" önekleri almalı. Dizayn kalıpları
kullanırken mesela iskelet veya fabrika kalıbları , methodun adı kalıbın adını içermeliki kalıb kolayca
tanımlanabilsin.

Fonksiyonlar ("floating functions") genel kapsamda kullanılabilir ancak bu kullanım uygun bulunmamaktadır. Bu
fonksiyonları static bir sınıf'ın içine koymalısınız.

.. _coding-standard.naming-conventions.variables:

Değişkenler
^^^^^^^^^^^

Değişken isimleri sadece alfanümerik karakterleden oluşabilir.Altçizgi kullanılamaz. Değişken isimlerinde
numaralar kullanılabilir ancak bu kullanım uygun bulunmamaktadır.

"private" veya "protected" construct'ı ile tanımlanmış sınıf üyesi değişkenlerin değişken isminin ilk
harfi altçizgi olmalı.Bu fonksiyon adında altçizgi kullanılabilir tek kullanım şeklidir. "public" ile
tanımlanmış üye değişkenler asla altçizgi ile başlamamalı.

Fonksiyon isimlerinde (bölüm 3.3,yukarıda) olduğu gibi değişken isimleride her zaman küçük harfle
başlamalı ve "camelCaps" kuralına uymalı.

Değişkenler pratik olabilecek kadar uzun olmalı. "$i" ve "$n" gibi kısa ve öz değişken isimleri küçük
döngüler dışında kullanılmamalı. Eğer bir döngü 20 satırdan fazla ise , indisler için olan
değişkenlerin daha açıklayıcı isimleri olmalı.

.. _coding-standard.naming-conventions.constants:

Sabitler
^^^^^^^^

Sabitler hem altçizgi hemde alfanümerik karakterler içerebilir. Sabit isimlerinde sayılar kullanılabilir.

Sabitlerin tüm harfleri mutlaka büyük olmalı.

Okunabilirliği artırmak için sabitlerdeki kelimeler altçizgilerle ayrılmalı. Örneğin
*EMBED_SUPPRESS_EMBED_EXCEPTION* kabul olmasına karşın *EMBED_SUPPRESSEMBEDEXCEPTION* kabul edilmez.

Sabitler "const" construct'ı kullanılarak sınıf üyeleri olarak tanımlanmalı. Sabitler genel kapsamda
"define" ile tanımlanabilmesine karşın bu tanımlama uygun görülmemektedir.

.. _coding-standard.coding-style:

Kodlama Stili
-------------

.. _coding-standard.coding-style.php-code-demarcation:

PHP Kodu Sınırlaması
^^^^^^^^^^^^^^^^^^^^

PHP kodu her zaman için tam,standart PHP tagleri ile ayrılmalı :

   .. code-block:: php
      :linenos:

      <?php

      ?>


Kısa taglere izin verilmez. Sadece PHP kodu içeren dosyalarda kapama tagi her zaman için gözardı edilmeli
(bakınız :ref:` <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Stringler
^^^^^^^^^

.. _coding-standard.coding-style.strings.literals:

Yalın Stringler
^^^^^^^^^^^^^^^

Bir string yalın olduğunda (değişken değişimi olmadığında) , kesme işareti veya "tek tırnak" her zaman
stringi ayırmak için kullanılır:

   .. code-block:: php
      :linenos:

      $a = 'Örnek String';



.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

Kesme işareti içeren Yalın Stringler
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bir yalın string kesme işareti içerdiği zaman string tırnak işareti veya çift tırnak ile ayrılmalı. Bu
özellikle SQL ifadelerine uygun :

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";

Yukarıdaki söz dizimi tek tırnak escapelemeye göre tercih edilir.

.. _coding-standard.coding-style.strings.variable-substitution:

Değişken Yerine koyma
^^^^^^^^^^^^^^^^^^^^^

Değişken yerine koyma şu iki şekilde yapılabilir :

   .. code-block:: php
      :linenos:

      $greeting = "Merhaba $isim, tekrar hoşgeldin!";

      $greeting = "Merhaba {$isim}, tekrar hoşgeldin!";



Tutarlılık için bu kullanıma izin verilmez :

   .. code-block:: php
      :linenos:

      $greeting = "Merhaba ${isim}, tekrar hoşgeldin!";



.. _coding-standard.coding-style.strings.string-concatenation:

String Birleştirme
^^^^^^^^^^^^^^^^^^

Stringler "." operetörü ile birleştirilebilirler. Okunabilirliği artırmak için "." operatöründen önce ve
sonra boşluk bırakılmalı :

   .. code-block:: php
      :linenos:

      $company = 'Zend' . 'Technologies';



Stringleri "." operetörü ile birleştirirken okunabilirliği artırmak için ifadeyi birden çok satıra
bölebiliriz.Bu gibi durumlarda her başarılı satır "." operatörünün "=" operatörünün altına döşendiği
gibi whitespace ile takviye edilmeli :

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Susan' "
           . "ORDER BY `name` ASC ";



.. _coding-standard.coding-style.arrays:

Diziler
^^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Sayısal İndeksli Diziler
^^^^^^^^^^^^^^^^^^^^^^^^

Negatif sayılar indis olamaz.

İndeksli bir dizi negatif olmayan bir sayı ile başlayabilir halbuki bu uygun değildir ve tüm dizilerin
başlangıç indeksi 0 olmalı.

İndeksli dizileri *array* construct'ı ile tanımlarken , okunabilirliği artırmak için her virgül
ayıracından sonra boşluk bırakılmalı :

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');



"array" construct'ı ile çok satırlı indeksli diziler de tanımlanabilir. Bu durumda aşağıda gösterildiği
gibi her başarılı satırın başlangıcı aynı hizaya gelecek şekilde boşluklarla takviye edilmeli :

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);



.. _coding-standard.coding-style.arrays.associative:

Birleşmeli Diziler
^^^^^^^^^^^^^^^^^^

Birleşmeli dizileri *array* construct'ı ile tanımlarken ifadeyi satırlara bölmek tavsiye edilir. Bu durumda
her başarılı satır her anahtar ve değer aynı hizaya gelecek şekilde whitespace ile takviye edilmeli:

   .. code-block:: php
      :linenos:

      $sampleArray = array('ilkAnahtar'  => 'ilkDeger',
                           'ikinciAnahtar' => 'ikinciDeger');



.. _coding-standard.coding-style.classes:

Sınıflar
^^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Sınıf Tanımlama
^^^^^^^^^^^^^^^

Sınıflar takip eden isimlendirme kurallarına göre isimlendirilmeli.

Büyük parantez her zaman sınıf isminin hemen antındaki satıra yazılır ("Bir gerçek büyük parantez"
formu).

Her sınıfın PHPDocumentor standardına uyan bilgilendirme kısmı olmalı.

Sınıf içindeki her kod içeriden 4 boşluk ile başlamalı.

Bir PHP dosyasında bir sınıf olabilir.

Sınıf dosyası içine ek kod eklenebilir ancak bu uygun bulunmuyor. Böyle dosyalarda iki boş satır sınıf ile
ek PHP kodunu birbirinden ayırmalı.

Kabul edilebilir sınıf tanımlaması örneği :

   .. code-block:: php
      :linenos:

      /**
       * Bilgilendirme kısmı buraya
       */
      class SampleClass
      {
          // sınıfın tüm içeriği
          // içeriden 4 boşluk ile başlamalı
      }



.. _coding-standard.coding-style.classes.member-variables:

Sınıf Üyesi Değişkenler
^^^^^^^^^^^^^^^^^^^^^^^

Üye değişkenler takip eden değişken isimlendirme kurallarına göre isimlendirilmeli.

Sınıf içinde tanımlanmış her değişken sınıfın en üstünde , herhangi bir fonksiyon tanımlamadan
listelenmeli.

*var* construct'ına izin verilmez. Üye değişkenler görünürlüklerini her zaman *private*, *protected* veya
*public* constructlarından biriyle tanımlar.Üye değişkenlere direk erişim için onları public yapabilirsiniz
ama erişir değişkenler (set/get) kabul gördüğünden bu yöntem uygun değildir.

.. _coding-standard.coding-style.functions-and-methods:

Fonksiyonlar ve Metodlar
^^^^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Fonksion ve Metod Tanımlaması
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fonksiyonlar takip eden isimlendirme kurallarına göre isimlendirilmeli.

Sınıflar içindeki fonksiyonlar görünürlüklerini her zaman *private*, *protected* veya *public*
constructlarından biriyle tanımlanmalı.

Sınıflarda olduğu gibi , her zaman büyük parantez fonksiyon isminin altındaki satıra yazılır.("Bir gerçek
büyük parantez" formu). Fonksiyon ismi ile fonksiyon argümanları için açılan parantez arasında boşluk
bulunmaz.

Genel kapsamda fonksiyon kullanmak kesinlikle uygun bulunmuyor.

Bir sınıfta kabuledilebilir fonksiyon tanımlaması örneği :

   .. code-block:: php
      :linenos:

      /**
       * Bilgilendirme kısmı buraya
       */
      class Foo
      {
          /**
           * Bilgilendirme kısmı buraya
           */
          public function bar()
          {
              // fonksiyonun tüm içeriği
              // içeriden 4 boşluk ile başlamalı
          }
      }



**NOT:** Referans atamasına sadece fonksiyon tanımlamasında izin veriliyor :

   .. code-block:: php
      :linenos:

      /**
       * Bilgilendirme kısmı buraya
       */
      class Foo
      {
          /**
          * Bilgilendirme kısmı buraya
           */
          public function bar(&$baz)
          {}
      }



Çağrı anında referans ile aktarım yapılamaz.

Return değeri parantez içine anlınmamalı. Bu okunabilirliğe engel olabilir ayrıca ilerde eğer metod referans
ile return yapacak şekilde değişirse kodun çalışmasını durdurabilir.

   .. code-block:: php
      :linenos:

      /**
      * Bilgilendirme kısmı buraya
       */
      class Foo
      {
          /**
           * YANLIŞ
           */
          public function bar()
          {
              return($this->bar);
          }

          /**
           * DOĞRU
           */
          public function bar()
          {
              return $this->bar;
          }
      }



.. _coding-standard.coding-style.functions-and-methods.usage:

Fonksiyon ve Metod Kullanımı
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fonksiyon argümanları virgülden ayıracından sonra bir boşluk bırakılarak yazılır. Üç argüman alan bir
fonksiyon için kabul edilebilir bir fonksiyon çağrısı örneği:

   .. code-block:: php
      :linenos:

      threeArguments(1, 2, 3);



Çağrı anında referans ile aktarım yapılamaz. Fonksiyon argümanlarını referans ile aktarmak için fonksiyon
tanımlamaları bölümüne bakın.

Argüman olarak dizileri alabilen fonksiyonlar için fonksiyon çağrısı "array" construct'ını içerebilir ve
okunabilirliği artırmak için satırlara ayrılabilir. Bu gibi durumlarda dizi yazım kuralları geçerliliğini
korur:

   .. code-block:: php
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);



.. _coding-standard.coding-style.control-statements:

Kontrol İfadeleri
^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If / Else / Elseif
^^^^^^^^^^^^^^^^^^

*if* ve *elseif* constructlarına dayanan kontrol ifadelerinde koşulun açılan parantezinden önce ve kapama
parantezinden sonra bir boşluk bırakılmalı.

Parantezler içindeki koşullu ifadelerdeki operatörler okunabilirliği artırmak için boşluklarla ayrılmalı.
Daha geniş koşulların mantıksal gruplandırılmasını geliştirmesi için iç parantez kullanılmalı.

Açılış parantezi koşullu ifade ile aynı satırda yazılır. Kapanış parantezi ise her zaman kendi
satırına yazılır. Parantezler içindeki herhangi bir içerik dört boşluk bırakılarak yazılmalı.

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      }



"else" veya "else" içeren "if" ifadeleri için biçimlendirme bu örneklerdeki gib olmalı :

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      } else {
          $a = 7;
      }


      if ($a != 2) {
          $a = 2;
      } elseif ($a == 3) {
          $a = 4;
      } else {
          $a = 7;
      }

PHP kimi durumlarda buradaki ifadelerin büyük parantez kullanmadan yazılmasına izin verir. Kodlama
standardında bir fark olmaz ve tüm "if" , "elseif" veya "else" ifadeleri büyük parantez kullanmak zorundadır.

"elseif" construct'ı kullanılabilir ama "else if" kombinasyonunun kabul görmesinden dolayı kullanılması uygun
görülmemektedir.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

"switch" construct'ı ile yazılan kontrol ifadelerinde koşulun açılış parantezinden önce ve koşulun
kapanış parantezinden sonra bir boşluk bırakılmalı.

"switch" ifadesi içindeki tüm içerik içerinden dört boşluk ile başlamalı. "case" ifadesi altındaki her
içerik ek olarak içeriden dört boşluk ile başlamalı.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

*switch* ifadelerinde *default* construct'ı asla ihmal edilmemeli.

**NOT:**\ Bazen *break* veya *return* eklemeyerek sıradaki case'e düşen *case* ifadesi yazmak yararlıdır. Bu
gibi durumları hatalardan ayırt etmek için *break* veya *return* ihmal edilmiş *case* ifadelerine "// break
intentionally omitted"("//break kasıtlı olarak koyulmadı") yorumu eklenmeli.

.. _coding-standards.inline-documentation:

Satıriçi Belgelendirme
^^^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Belgelendirme Biçimi
^^^^^^^^^^^^^^^^^^^^

Tüm bilgilendirme kısımları ("docblocks") phpDocumentor biçimi ile uyumlu olmalı. phpDocumenter biçimini
açıklamak bu belgenin kapsamı dışındadır. Daha fazla bilgi için lütfen ziyaret edin :
`http://phpdoc.org/`_

Zend Framework için veya Zend Framework ile çalışan her kaynak kod dosyası her dosyanın üstünde "dosya
seviyesinde" ve her sınıfın üstünde "sınıf seviyesinde" bilgilendirme kısmı içermelidir. Aşağıdakiler
bilgilendirme kısmı örnekleri :

.. _coding-standards.inline-documentation.files:

Dosyalar
^^^^^^^^

PHP kodu içeren her dosya üst kısmında en az aşağıdaki kadar phpDocumentor tagleri içerecek şekilde bir
başlık kısmına sahip olmalı:

.. code-block:: php
   :linenos:

   /**
    * Zend Framework (http://framework.zend.com/)
    *
    * Long description for file (if any)...
    *
    * @link      http://github.com/zendframework/zf2 for the canonical source repository
    * @copyright Copyright (c) 2005-2013 Zend Technologies USA Inc. (http://www.zend.com)
    * @license   http://framework.zend.com/license/new-bsd New BSD License
    * @since     File available since Release 1.5.0
    */

.. _coding-standards.inline-documentation.classes:

Sınıflar
^^^^^^^^

Her sınıf en az aşağıdaki kadar phpDocumentor tagleri içerecek şekilde bilgilendirme kısmı içermeli :

.. code-block:: php
   :linenos:

   /**
    * Short description for class
    *
    * Long description for class (if any)...
    *
    * @since      Class available since Release 1.5.0
    * @deprecated Class deprecated in Release 2.0.0
    */

.. _coding-standards.inline-documentation.functions:

Fonksiyonlar
^^^^^^^^^^^^

Her fonksiyon ,nesne methodları en az aşağıdaki gibi bilgilendirme kısmı içermeli:



   - Fonksiyonun açıklaması

   - Tüm argümanlar

   - Tüm olası dönüş değerleri



Fonksiyonun erişim seviyesi fonksiyon tanımlanırken "public","private" veya "protected" construct'ları ile
tanımlandığı için "@access" taginin kullanılmasına gerek yoktur.

Eğer fonksiyon/metod kural dışı durum(exception) fırlatabiliyorsa , @throws kullanın:

   .. code-block:: php
      :linenos:

      @throws exceptionclass [açıklama]





.. _`http://phpdoc.org/`: http://phpdoc.org/
