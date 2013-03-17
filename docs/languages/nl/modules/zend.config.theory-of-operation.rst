.. EN-Revision: d20ff153d1520703aaeaf52e7e6bf2213abd2ee0
.. _zend.config.theory_of_operation:

Werking
=======

De ``Zend\Config\Config`` constructor accepteert configuratiegegevens in de vorm van een
associatieve array, die multi-dimensionaal mag zijn, zodat de gegevens gestructureerd zijn van generiek
tot specifiek. Concrete adapter classes zorgen ervoor dat opgeslagen configuratiegegevens als een 
associatieve array aan de ``Zend\Config\Config`` constructor worden aangeleverd. Indien gewenst kunnen
associatieve arrays rechtstreeks aan de ``Zend\Config\Config`` constructor meegegeven worden, zodat
het gebruik van een reader class overbodig wordt.

Elke waarde in de array met configuratiegegevens wordt een property van het ``Zend\Config\Config`` object.
De array key wordt daarbij gebruikt als property name. Indien de waarde een array is, dan wordt deze
zelf ook omgezet naar een nieuw ``Zend\Config\Config`` object en ingvuld met de array data.
Dit gebeurt recursief zodat een hiërarchie met een willekeurig aantal niveaus van configuratiegegevens kan opgebouwd worden.

``Zend\Config\Config`` implementeert de `Countable`_ and `Iterator`_ zodat de configuratiegegevens makkelijk
toegankelijk zijn. Bijgevolg ondersteunen ``Zend\Config\Config`` objecten de `count()`_ functie en *PHP* constructs
zoals `foreach`_.

Configuratiegegevens kunnen standaard enkel ingelezen worden via ``Zend\Config\Config`` en wanneer je
gegevens tracht weg te schrijven (b.v. ``$config->database->host = 'example.com';``) zal er zich een exception voordoen.
Dit standaardgedrag kan gewijzigd worden via de constructor, waardoor gegevens wel overschrijfbaar worden.
Wanneer gegevens overschrijfbaar zijn, laat ``Zend\Config\Config`` ook toe om gegevens te verwijderen
(b.v. ``unset($config->database->host)``). De ``isReadOnly()`` methode kan gebruikt worden om te verifiëren
of gegevens overschrijfbaar zijn of niet en de ``setReadOnly()`` methode kan gebruikt worden om het 
``Zend\Config\Config`` object terug in read-only modus te plaatsen en verdere aanpassingen onmogelijk te maken.

.. note::

   **Het wijzigen van een configuratie slaat de wijzigingen niet op**

   Het is belangrijk om te beseffen dat wijzigingen van de configuratie in het geheugen geen invloed hebben
   op de configuratie die effectief op het opslagmedium is opgeslagen. Programma's voor het maken of beheren
   van configuratiegegevens voor de verschillende opslagmedia, vallen buiten het bereik van ``Zend\Config\Config``.
   Er zijn third-party open source oplossingen beschikbaar die het mogelijk maken om configuratiegegevens aan te
   maken en te beheren voor verschillende opslagmedia.
   
Als je twee ``Zend\Config\Config`` objecten hebt, kan je ze samenvoegen in één object met de ``merge()``
functie. Stel dat je ``$config`` en ``$localConfig`` hebt, dan kan je de gegevens van ``$localConfig`` overzetten
naar ``$config`` door middel van ``$config->merge($localConfig);``. De items in ``$localConfig`` zullen de
gelijknamige items in ``$config`` overschrijven.

.. note::

   Het ``Zend\Config\Config`` object dat de samenvoeging uitvoert moet aangemaakt zijn met de optie
   om wijzigingen toe te laten, door TRUE mee te geven als tweede parameter aan de constructor.
   Nadien kan de ``setReadOnly()`` methode gebruikt worden om verdere wijzigingen te voorkomen nadat
   de gegevens zijn samengevoegd.

.. _`Countable`: http://php.net/manual/en/class.countable.php
.. _`Iterator`: http://php.net/manual/en/class.iterator.php
.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
