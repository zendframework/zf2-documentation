.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Panoramica
----------

*Zend_Uri* è un componente che fornisce supporto nella manipolazione e validazione di `Uniform Resource
Identifier`_ (URI). *Zend_Uri* esiste principalmente come servizio per altri componenti, ad esempio
*Zend_Http_Client*, ma è altrettanto utile come componente autonomo.

Gli URI cominciano sempre con uno schema, seguito da ':' (due punti). La costruzione dei differenti tipi di schema
varia sensibilmente. La classe *Zend_Uri* fornisce un metodo factory che restituisce una sottoclasse di se stessa
specializzata su uno schema specifico. La sotto classe è chiamata *Zend_Uri_<scheme>*, dove *<scheme>* è lo
schema in caratteri minuscoli con la prima lettera maiuscola. Lo schema HTTPS rappresenta un'eccezione alla regola
poiché è anch'esso gestito da *Zend_Uri_Http*.

.. _zend.uri.creation:

Creazione di un nuovo URI
-------------------------

*Zend_Uri* costruirà un nuovo URI da zero solo se lo schema è passato a *Zend_Uri::factory()*.

.. _zend.uri.creation.example-1:

.. rubric:: Esempio di creazione di un nuovo URI con *Zend_Uri::factory()*

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   //  Per creare un nuovo URI da zero, passare solo lo schema
   $uri = Zend_Uri::factory('http');

   // $uri instanceof Zend_Uri_Http

Per creare un nuovo URI da zero è sufficiente passare solo lo schema a *Zend_Uri::factory()* [#]_. Se si fornisce
uno schema non supportato verrà generata un'eccezione *Zend_Uri_Exception*.

Se lo schema o l'URI fornito è supportato, *Zend_Uri::factory()* restituirà una sottoclasse di se stessa
specializzata nello schema da creare.

.. _zend.uri.manipulation:

Manipolazione di un URI esistente
---------------------------------

Per manipolare un URI esistente passare l'intero URI a *Zend_Uri::factory()*.

.. _zend.uri.manipulation.example-1:

.. rubric:: Esempio di manipolazione di un URI esistente con *Zend_Uri::factory()*

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   // Per manipolare un URI esistente, passarlo come parametro
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri instanceof Zend_Uri_Http

L'URI è parsato e validato. Se l'URI non è valido verrà immediatamente generata un'eccezione
*Zend_Uri_Exception*. Altrimenti, *Zend_Uri::factory()* restituirà una sottoclasse di se stessa specializzata
nello schema da manipolare.

.. _zend.uri.validation:

Validazione di un URI
---------------------

Si può usare la funzione *Zend_Uri::check()* se è solo necessario validare un URI esistente.

.. _zend.uri.validation.example-1:

.. rubric:: Esempio di validazione di un URI con *Zend_Uri::check()*

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   // Validazione del formato dell'URI
   $valid = Zend_Uri::check('http://uri.in.questione');

   // $valid è TRUE per un URI valido, altrimenti FALSE.

*Zend_Uri::check()* restituisce un booleano, una forma molto più conveniente che utilizzare *Zend_Uri::factory()*
e catturare l'eccezione.

.. _zend.uri.instance-methods:

Metodi d'istanza in comune
--------------------------

Ogni istanza di una sottoclasse di *Zend_Uri* (es. *Zend_Uri_Http*) contiene diversi metodi d'istanza utili per
lavorare con ogni tipo di URI.

.. _zend.uri.instance-methods.getscheme:

Restituzione dello Schema dell'URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lo schema dell'URI è la parte dell'URI che precede i ":" (due punti). Per esempio, in *http://www.zend.com* lo
schema è *http*.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Esempio di restituzione dello schema di un oggetto *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

Il metodo d'istanza *getScheme()* restituisce solo la parte corrispondente allo schema dell'oggetto URI.

.. _zend.uri.instance-methods.geturi:

Restituzione dell'intero URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Esempio di restituzione dell'intero URI di un oggetto *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

Il metodo *getUri()* restituisce una stringa corrispondente alla rappresentazione dell'intero URI.

.. _zend.uri.instance-methods.valid:

Validazione dell'URI
^^^^^^^^^^^^^^^^^^^^

*Zend_Uri::factory()* esegue sempre una validazione dell'URI passato e non crea una nuova istanza di una
sottoclasse di *Zend_Uri* se l'URI fornito è invalido. Tuttavia, dopo la creazione di un'istanza di una
sottoclasse di *Zend_Uri* da un nuovo URI o da uno esistente, è possibile che l'URI diventi invalido
successivamente ad una manipolazione.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Esempio di validazione di un oggetto *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

Il metodo d'istanza *valid()* fornisce un modo per controllare che l'oggetto URI sia ancora valido.



.. _`Uniform Resource Identifier`: http://www.w3.org/Addressing/

.. [#] Al momento in cui si scrive, Zend_Uri supporta solo gli schemi HTTP e HTTPS.