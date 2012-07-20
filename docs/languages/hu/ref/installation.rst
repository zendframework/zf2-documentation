.. _introduction.installation:

Telepítés
=========

Lásd a :ref:`követelmények függeléket <requirements>` a Zend Framework követelményeinek részletes
áttekintéséért.

A telepítés rendkívül egyszerű. A keretrendszer letöltését és kicsomagolását követően ``library/``
mappát hozzá kell adni az include path elejéhez. Célszerű lehet még más – esetleg megosztott – helyre
mozgatni az állományrendszerben.

- `Az utolsó stabil kiadás letöltése.`_ Ez a mind ``.zip``, mind ``.tar.gz`` alakban elérhető változat jó
  választás az új felhasználóknak.

- `A legutóbbi éjjeli pillanatkép letöltése.`_ Azok számára, akik elég bátrak az élen járni, az éjjeli
  pillanatképek reprezentálják a Zend Framework fejlesztésének legutóbbi lépéseit. A pillanatképek
  elérhetők mind kizárólag angol, mind pedig az összes elérhető nyelvű dokumentációval együtt
  csomagolva. Aki mindenképp a legfrissebb fejlesztésekkel kíván dolgozni, annak érdemes fontolóra vennie egy
  Subversion (SVN) ügyfél használatát.

- `Subversion`_ (*SVN*) ügyfél használata. A Zend Framework nyílt forrású szoftver, és a fejlesztéséhez
  használt Subversion tárolója nyílvánosan hozzáférhető. Egy *SVN* ügyfél használata megfontolandó
  azoknak, akik már most is *SVN*-t használnak alkalmazásaik fejlesztéséhez, részt akarnak venni a
  keretrendszer fejlesztésében, vagy sokkal sűrűbben kell frissíteniük a keretrendszer-verziójukat, mint
  ahogy a kiadások megjelennek.

  `Az exportálás`_ egy adott átirat letöltése a munkapéldányokban létrejövő ``.svn`` könyvtárak
  nélkül.

  `Egy munkapéldány letöltése`_ szükséges a közreműködéshez. A munkapéldányok bármikor naprakészre
  hozhatók az `svn update`_, a változtatások pedig felküldhetők az *SVN* tárolónkba az `svn commit`_
  paranccsal.

  `Egy külső meghatározás`_ igen kényelmes azon fejlesztők számára, akik már használnak SVN-t
  alkalmazásaik munkapéldányainak kezeléséhez.

  Az URL a Zend Framework SVN tárolójának törzséhez: `http://framework.zend.com/svn/framework/trunk`_.

Ha rendelkezésre áll a Zend Framework egy példánya, az alkalmazásnak hozzá kell férnie a keretrendszer
osztályaihoz. `Noha ez sokféleképp megoldható`_, a *PHP* `include_path`_-nak tartalmaznia kell a Zend Framework
osztálykönyvtárát.

A Zend egy `gyorstalpalót`_ kínál a minél gyorsabb indulás érdekében. Ez egy kiváló útja elkezdeni
tanulni a keretrendszert valós vilégbéli példákra építve.

Mivel a Zend Framework összetevői lazán kapcsolódnak egymáshoz, minden alkalmazás némiképp egyedi
összeállításukat használhatja. Az elkövetkező fejezetek a Zend Keretrendszert összetevőnként tárgyaló,
átfogó kézikönyvet alkotnak.



.. _`Az utolsó stabil kiadás letöltése.`: http://framework.zend.com/download/latest
.. _`A legutóbbi éjjeli pillanatkép letöltése.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Az exportálás`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Egy munkapéldány letöltése`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`Egy külső meghatározás`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/trunk`: http://framework.zend.com/svn/framework/trunk
.. _`Noha ez sokféleképp megoldható`: http://www.php.net/manual/hu/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/hu/ini.core.php#ini.include-path
.. _`gyorstalpalót`: http://framework.zend.com/docs/quickstart
