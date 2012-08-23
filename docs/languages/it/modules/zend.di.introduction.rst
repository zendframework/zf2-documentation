.. EN-Revision: none
.. _zend.di.intro:

Introduzione a Zend\\Di
=======================

.. _zend.di.intro.di:

Dependency Injection (Iniezione delle dipendenze)
-------------------------------------------------

Dependency Injection (chiamata DI) è un concetto che viene navigato molto e discusso sul web. Semplicemente,
vogliamo spiegare che l'atto di iniettare le dipendenze è semplice come nell'esempio successivo:

.. code-block:: php
   :linenos:

   $b = new MovieLister(new MovieFinder));

Sopra, MovieFinder è una dipendenza di MovieLister e Movie Finder è iniettato dentro MovieLister. Se non ti è
familiare il concetto di DI, qui ci sono un paio di ottime letture: `Matthew Weier O'Phinney's Analogy`_, `Ralph
Schindler's Learning DI`_, oppure `Fabien Potencier's Series`_ su DI.

.. _zend.di.intro.dic:

Dependency Injection Containers (Contenitori DI)
------------------------------------------------

Quando il tuo codice è scritto in modo che tutte le tue dipendenze sono iniettate dentro gli oggetti da
utilizzare, potresti scoprire che il semplice atto di legare gli oggetti è diventato più complesso. Questo questo
diventa reale e tu scopri che stai creando del codice ripetuto, questo allora, diventa una eccellente opportinità
per utilizzare un Dependency Injection Container.

Nella sua forma più semplice, un Dependency Injection Container (che successivamente chiameremo DiC per brevità),
è un oggetto capace di creare altri oggetti su richiesta e gestire il "legame", o l'iniezione delle dipendenze per
gli oggetti richiesti. Poichè i patterns che gli sviluppatori utilizzano nello scrivere del codice utile per il DI
variano, i DiC sono generalmente più compatti rispetto ad un pattern specifico o frameworks DiC più grandi.

Zend\\Di è un DiC framework. Mentre per il codice più semplice non è necessaria una configurazione ed i casi
d'uso sono abbastanze semplici; per del codice più complicato, Zend\\Di è in grado di essere configurato per
legare questi casi d'uso complicati.



.. _`Matthew Weier O'Phinney's Analogy`: http://weierophinney.net/matthew/archives/260-Dependency-Injection-An-analogy.html
.. _`Ralph Schindler's Learning DI`: http://ralphschindler.com/2011/05/18/learning-about-dependency-injection-and-php
.. _`Fabien Potencier's Series`: http://fabien.potencier.org/article/11/what-is-dependency-injection
