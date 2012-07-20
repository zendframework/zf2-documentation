.. _introduction.installation:

Instalace
=========

Zend Framework je vytvořen s využitím objektově orientovaného PHP 5 a vyžaduje PHP 5.1.4 nebo vyšší.
Podívejte se na :ref:`systémové požadavky <requirements>` pro detailní informace.

Když je připraveno odpovídající prostředí, další krok je získání kopie Zend Frameworku, což může
být učiněno následujícími oficiálními cestami:

   - `Stáhnout poslední stabilní verzi.`_ Tato verze, dostupná v *.zip* nebo *.tar.gz*, je správná volba pro
     začátečníky se Zend Frameworkem.

   - `Stáhnout poslední noční snapshot.`_ Těm, kteří jsou ochotni pracovat na ostří nože, poskytuje
     noční snapshot poslední pokrok ve vývoji Zend Frameworku. Snapshoty jsou zabaleny buď jen s dokumentací
     v angličtině nebo ve všech dostupných jazycích. Pokud hodláte pracovat s nejnovějšími změnami ve
     vývoji Zend Frameworku, zvažte použití Subversion (SVN) klienta.

   - Použití `Subversion`_ (SVN) klienta. Zend Framework je open source software a Subversion repositář
     použitý pro jeho vývoj je veřejně přístupný. Zvažte využítí SVN pokud už používáte SVN pro
     vývoj svých aplikací, chcete přispívat zpět do frameworku nebo potřebuje využívat ještě nevydané
     verze frameworku.

     `Exportování`_ je užitečné, pokud potřebuje získat konkrétní revizi frameworku bez *.svn*
     adresářů, které jsou vytvořeny v pracovní kopii.

     `Checkout pracovní kopie`_ je je vhodný pokud chcete přispívat do Zend Frameworku a pracovní kopie může
     být kdykoliv aktualizována pomocí `svn update`_.

     `Externals definition`_ je vhodná pro vývojáře používající SVN pro správu pracovních kopií svých
     aplikací.

     URL hlavního vývojového stromu (trunk) Zend Framework repositáře je:
     `http://framework.zend.com/svn/framework/trunk`_



Až získáte kopii Zend Frameworku, musíte vaší aplikace umožnit přístup k třídám frameworku. Existuje
`několik cest, jak toho dosáhnout`_, vaše PHP `include_path`_ musí obsahovat cestu ke knihovně Zend Framework.

Jedna z nejdůležitějších vlastností Zend Frameworku je vlastní implementace `Front Controlleru`_ a
návrhového vzoru `Model-View-Controller`_ (MVC). :ref:`Začněte se Zend Framework MVC!
<zend.controller.quickstart>`

Protože komponenty Zend Frameworku jsou volně spojeny, mohou být použity jednotlivě, podle potřeby. Každá z
následujících kapitol popisuje použití konkrétní komponenty.



.. _`Stáhnout poslední stabilní verzi.`: http://framework.zend.com/download
.. _`Stáhnout poslední noční snapshot.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Exportování`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Checkout pracovní kopie`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`Externals definition`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/trunk`: http://framework.zend.com/svn/framework/trunk
.. _`několik cest, jak toho dosáhnout`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`Front Controlleru`: http://www.martinfowler.com/eaaCatalog/frontController.html
.. _`Model-View-Controller`: http://en.wikipedia.org/wiki/Model-view-controller
