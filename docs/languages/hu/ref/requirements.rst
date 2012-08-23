.. EN-Revision: none
.. _requirements:

*************
Követelmények
*************

.. _requirements.introduction:

Bevezetés
---------

A Zend Framework futtatásához egy *PHP* 5 értelmező és egy *PHP* parancsállományok futtatásához
megfelelően beállított webkiszolgáló szükséges. Néhány funkcióhoz további kiterjesztésekre vagy a
kiszolgáló egyéb lehetőségeire is szükség van; az esetek többségében a keretrendszer nélkülük is
használható, habár a teljesítmény csökkenhet, esetleg mellékesebb funkciók nem fognak maradéktalanul
működni. Efféle függőségre példa Apache környezetben a mod_rewrite, melyet „szép *URL*-ek”, mint pl.
„ ``http://example.com/user/edit``\ ” megvalósításához lehet használni. Ha a mod_rewrite nem elérhető a
keretrendszer beállítható úgy, hogy támogassa a „ ``http://example.com?controller=user&action=edit``\ ”
alakot. A szép *URL*-eket használhatjuk például a rövidebb szöveges megjelenítés kedvéért vagy
keresőoptimalizálási (*SEO*) megfontolásokból, azonban nincsenek közvetlen hatással az alkalmazás
funkcionalitására.

.. _requirements.version:

PHP verzió
^^^^^^^^^^

Ajánlott a *PHP* legújabb kiadása a válságos biztonsági és teljesítménybeli javítások okán. Jelenleg a
*PHP* 5.2.4 és későbbi kiadások támogatottak.

A Zend Keretrendszer átfogó egységtesztekkel rendelkezik, melyek PHPUnit 3.3.0-val vagy későbbivel
futtathatók.

.. _requirements.extensions:

PHP kiterjesztések
^^^^^^^^^^^^^^^^^^

Alább található egy táblázat, mely felsorolja a *PHP*-ban jellemzően megtalálható kiterjesztéseket és
azt, hogyan használja őket a Zend Framework. Tanácsos meggyőződni arról, hogy az alkalmazásunkban használt
összetevők által megkövetelt kiterjesztések elérhetők-e a *PHP* környezetünkben. A legtöbb alkalmazás
nem igényli az összes alant felsorolt kiterjesztést.

Az „erős” függőség azt jelenti, hogy az adott összetevő vagy osztályok nem működnek megfelelően a
szóban forgó kiterjesztés hiányában, míg a „gyenge” azt, hogy az összetevő használhatja a
kiterjesztést, ha az elérhető, de helyesen fog működni akkor is, ha nem. Sok komponens magától kihasználja
bizonyos kiterjesztések lehetőségeit a teljesítmény növelésére, amennyiben azok megtalálhatók, de saját
kódot futtatnak hasonló eredménnyel, ha nincsenek telepítve.

.. include:: requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Összetevők
^^^^^^^^^^

Alább található az összes rendelkezésre álló Zend Framework összetevőt felsoroló táblázat és az
általuk megkívánt *PHP* kiterjesztések. E táblázat segíthet kideríteni mely kiterjesztések szükségesek
egy alkalmazáshoz. Nem minden a keretrendszer által használt kiterjesztés szükséges az összes
alkalmazáshoz.

Az „erős” függőség azt jelenti, hogy az adott összetevő vagy osztályok nem működnek megfelelően a
szóban forgó kiterjesztés hiányában, míg a „gyenge” azt, hogy az összetevő használhatja a
kiterjesztést, ha az elérhető, de helyesen fog működni akkor is, ha nem. Sok komponens magától kihasználja
bizonyos kiterjesztések lehetőségeit a teljesítmény növelésére, amennyiben azok megtalálhatók, de saját
kódot futtatnak hasonló eredménnyel, ha nincsenek telepítve.

.. include:: requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Függőségek
^^^^^^^^^^

Alább található a Zend Framework összetevőit és azok más összetevőkkel való függőségeit mutató
táblázat. E táblázat segítséget jelenthet, amennyiben csak egyes összetevők használata szükséges a
teljes keretrendszer helyett.

Az „erős” függőség azt jelenti, hogy az adott összetevő vagy osztályok nem működnek megfelelően a
szóban forgó függésben tartó összetevő hiányában, míg a „gyenge” azt, hogy a komponens igényelheti a
másikat bizonyos esetekben vagy bizonyos illesztőkkel. Végül, az „állandó” azt jelenti, hogy ezen
összetevők minden esetben igénybe vannak véve alösszetevők által, az „al-” pedig, hogy igénybe lehetnek
véve bizonyos esetekben avagy bizonyos illesztőkkel.

.. note::

   Habár lehetséges egyes összetevőket a teljes keretrendszertől elkülönítve használni, érdemes észben
   tartani, hogy ez gondokhoz vezethet, mikor hiányoznak állományok, vagy az összetevők dinamikusan vannak
   használva.

.. include:: requirements.dependencies.table.rst

