.. EN-Revision: none
.. _introduction.installation:

Installazione
=============

Il Framework Zend è sviluppato con una programmazione in PHP 5 orientata agli oggetti e necessita di PHP 5.1.4 o
successivo. Fare riferimento all'appendice :ref:`requisiti di sistema <requirements>` per informazioni più
dettagliate.

Una volta che l'appropriato ambiente PHP è disponibile, lo step successivo è avere una copia del Framework Zend
che può essere ufficialmente ottenuta con uno dei seguenti metodi:



   - `Scaricamento dell'ultima versione stabile.`_ Questa versione, disponibile in entrambi i formati *.zip* e
     *.tar.gz*, è una buona scelta per chi è nuovo al Framework Zend.

   - `Scaricamento dell'ultima istantanea notturna.`_ Per chi desidera essere all'avanguardia, le istantanee
     notturne rappresentano l'ultimo progresso nello sviluppo del Framework Zend. Le istantanee incorporano sia la
     documentazione Inglese sia tutte le altre lingue disponibili. Se si prevede di lavorare con l'ultima versione
     di sviluppo del Framework Zend, si consideri l'utilizzo di un client Subversion (SVN).

   - Utilizzo di un client `Subversion`_ (SVN). Il Framework Zend è un software open source ed il deposito dei
     pacchetti Subversion utilizzato nello sviluppo è disponibile pubblicamente. Si consideri di utilizzare SVN
     per scaricare il Framework Zend se SVN è già in uso nello sviluppo della propria applicazione, si desidera
     contribuire allo sviluppo framework o è necessario aggiornare la propria versione disponibile del framework
     con una frequenza maggiore rispetto al rilascio delle nuove versioni.

     L'`esportazione`_ è utile nel caso in cui sia necessario ottenere una particolare revisione del framework
     senza le cartelle *.svn* create automaticamente per una copia di lavoro.

     `L'esecuzione di un checkout di una copia di lavoro`_ è utile per contribuire allo sviluppo del Framework
     Zend ed una copia di lavoro può essere aggiornata in qualunque momento con `svn update`_.

     `Una definizione esternaa`_ è particolarmente utile per gli sviluppatori che già utilizzano SVN per gestire
     le proprie copie di lavoro.

     L'URL della branca principale (ndt. chiamata trunk in inglese) del deposito SVN di Zend Framework è:
     http://framework.zend.com/svn/framework/trunk



Una volta che una copia del Framework Zend è a disposizione, l'applicazione necessita di poter accedere alle
classi del framework. Sebbene ci siano `diversi modi per farlo`_, la direttiva PHP `include_path`_ deve contenere
il percorso alla libreria del Framework Zend (ndt. sottocartella library disponibile nella cartella library del
framework).

Una delle funzionalità più utili del Framework Zend è la sua implementazione dei pattern `Front Controller`_ e
`Model-View-Controller`_ (MVC). :ref:`Ecco un'introduzione all'MVC nel Framework Zend!
<zend.controller.quickstart>`

Poiché i componenti del Framework Zend sono interconnessi in modo piuttosto limitato, diversi componenti possono
essere selezionati per un uso indipendente in base alle necessità. Ciascuno dei capitoli seguenti documenta l'uso
di un particolare componente.



.. _`Scaricamento dell'ultima versione stabile.`: http://framework.zend.com/download/stable
.. _`Scaricamento dell'ultima istantanea notturna.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`esportazione`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`L'esecuzione di un checkout di una copia di lavoro`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`Una definizione esternaa`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`diversi modi per farlo`: http://www.php.net/manual/it/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/it/ini.core.php#ini.include-path
.. _`Front Controller`: http://www.martinfowler.com/eaaCatalog/frontController.html
.. _`Model-View-Controller`: http://it.wikipedia.org/wiki/Model-View-Controller
