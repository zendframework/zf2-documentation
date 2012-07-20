.. _zend.debug.dumping:

Stampa delle variabili
======================

Il metodo statico *Zend_Debug::dump()* stampa o restituisce le informazioni su una espressione. Questa semplice
tecnica di debug è comune poiché facile da usare in modo appropriato e non richiede alcuna inizializzazione,
strumenti speciali o un ambiente di debug.

.. _zend.debug.dumping.example:

.. rubric:: Esempio del metodo dump()

.. code-block::
   :linenos:


   Zend_Debug::dump($var, $label=null, $echo=true);


Il parametro *$var* specifica l'espressione o la variabile di cui il metodo *Zend_Debug::dump()* stampa le
informazioni.

Il parametro *$label* è una stringa da inserire prima dell'output di *Zend_Debug::dump()*. Può essere utile, per
esempio, per utilizzare delle etichette se si sta eseguendo il dump a schermo di informazioni su più variabili.

Il parametro booleano *$echo* specifica se l'output di *Zend_Debug::dump()* è stampato o no. Se *true*, l'output
è stampato. Indipendentemente dal valore del parametro *$echo*, questo metodo restituisce sempre il contenuto
dell'output.

Può essere utile sapere che, internamente, il metodo *Zend_Debug::dump()* racchiude la funzione PHP `var_dump()`_.
Se il flusso dell'output è riconosciuto come destinato ad una presentazione web, l'output di *var_dump()* è
codificato utilizzando `htmlspecialchars()`_ ed incluso all'interno dei tag (X)HTML *<pre>*.

.. tip::

   **Debug con Zend_Log**

   L'utilizzo di *Zend_Debug::dump()* è conveniente per il debug specifico durante lo sviluppo del software. E'
   possibile inserire o rimuovere rapidamente il codice necessario per stampare una variabile.

   Anche l'uso del componente :ref:`Zend_Log <zend.log.overview>` è da tenere in considerazione quando si desidera
   scrivere un sistema di debug del codice più permanente. Per esempio, è possibile impostare il livello di log a
   *DEBUG* ed il flusso di scrittura su Stream per eseguire la stampa della stringa restituita da
   *Zend_Debug::dump()*.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
