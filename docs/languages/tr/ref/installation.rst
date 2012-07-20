.. _introduction.installation:

Kurulum
=======

Zend Framework nesneye dayalı PHP 5 ile oluşturuldu ve PHP 5.1.4 veya yenisine ihtiyaç duyar. Lütfen daha
ayrıntılı bilgi için :ref:`sistem gereksinimleri eki <requirements>`\ ne bakın.

Uygun PHP ortamı mevcutsa , sıradaki adım Zend Framework'ün takip eden metodlardaki gibi resmi olarak elde
edilebilecek bir kopyasını almak :



   - `En son kararlı sürümü indirin.`_ Bu versiyon Zend Framework'e yeni olanlar için iyi bir seçim olan
     *.zip* ve *.tar.gz* formatlarında mevcut.

   - `En son gecelik snaphot'ı indirin.`_ Gözüne kestirenler için , gecelik snapshotlar Zend Framework'ün
     gelişiminin son ilerleyişini göstermektedir. Snaptshotlar sadece ingilizce belgelerle ya da diğer tüm
     mevcut dillerde belgelerle paketlenir. Eğer ileride en son Zend Framework geliştirmeleriyle çalışmayı
     planlıyorsanız , Subversion (SVN) istemcisi kullanmayı dikkate alın.

   - `Subversion`_ (SVN) istemcisi kullanmak. Zend Framework açık kaynak kodlu yazılımdır ve geliştirilmesi
     için kullanılan Subversion deposu alenen mevcuttur.Eğer zaten SVN'yi uygulama geliştirmek için
     kullanıyor ve framework'e katkıda bulunmak istiyorsanız veya , yeni sürüm çıkışlarından daha sık
     olarak framework versiyonunuzu güncellemeniz gerekiyorsa SVN ile Zend Framework'ü almayı göz önünde
     tutmalısınız.

     `İhraç etme`_, eğer belirli bir framework revizyonunu çalışan kopyada oluşturulduğu gibi *.svn*
     dizinleri olmadan almak istiyorsanız yararlı bir seçim.

     `Çalışan kopyayı çekme`_ Zend Framework'e katkıda bulunabileceğiniz zaman iyidir , ve çalışan kopya
     istediğiniz herhangi bir zaman `svn update`_ ile güncellenebilir.

     `Externals değişkeni`_ zaten SVN kullanmakta olan geliştiriciler için uygulamaların çalışan
     kopyalarını yönetmeye son derece uygun.

     Zend Framework SVN deposunun trunk'ının URL'si : `http://framework.zend.com/svn/framework/trunk`_



Zend Framework'ün mevcut bir kopyasına sahip olduğunuzda , uygulamanızın framework sınıflarına
erişebiliyor olması gerekiyor aksi halde `bunu sağlamanın birkaç yolu`_ var. ,PHP `include_path`_'inizin Zend
Framework kütüphanesi yolunu içermesi gerekiyor.

Zend Framework'ün en kullanışlı özelliklerinden biride `Front Controller`_ ve `Model-View-Controller`_ (MVC)
kalıplarının uyarlanması. :ref:`Zend Framework MVC ile başlayın! <zend.controller.quickstart>`

Zend Framework gevşek olarak bir araya getirilmiş olmasada , birçok bileşeni gerekli olduğunda bağımsız
kullanım için seçilebilir. Takip eden herbir bölüm herbir bileşenin kullanımını belgelemektedir.



.. _`En son kararlı sürümü indirin.`: http://framework.zend.com/download/stable
.. _`En son gecelik snaphot'ı indirin.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`İhraç etme`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Çalışan kopyayı çekme`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`Externals değişkeni`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/trunk`: http://framework.zend.com/svn/framework/trunk
.. _`bunu sağlamanın birkaç yolu`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`Front Controller`: http://www.martinfowler.com/eaaCatalog/frontController.html
.. _`Model-View-Controller`: http://en.wikipedia.org/wiki/Model-view-controller
