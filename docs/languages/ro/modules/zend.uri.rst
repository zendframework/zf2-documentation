.. EN-Revision: none
.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Privire de ansamblu
-------------------

*Zend_Uri* este o componentă care ajută la manipularea şi validarea `Identificatorilor uniformi de resurse`_
(URI-uri). *Zend_Uri* există în primul rând pentru a servi alte componente cum ar fi *Zend_Http_Client*, dar
este utilă şi ca o componentă de sine stătătoare.

URI-urile încep întotdeauna cu schema, urmată de caracterul două puncte. Construcţia diverselor şi
multiplelor scheme diferă semnificativ. Clasa *Zend_Uri* dispune de o fabrică (factory) care creează o subclasă
a sa specializată pentru fiecare schemă. Subclasa se va numi *Zend_Uri_<schemă>*, unde *<schemă>* este schema
scrisă cu litere mici şi prima literă majusculă. O excepţie de la această regulă este HTTPS, care e de
asemenea gestionată de *Zend_Uri_Http*.

.. _zend.uri.creation:

Crearea unui nou identificator de resursă (URI)
-----------------------------------------------

*Zend_Uri* va construi un nou URI de la zero doar dacă pasaţi o schemă metodei *Zend_Uri::factory()*.

.. rubric:: Crearea unui nou URI cu *Zend_Uri::factory()*

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   // Pentru a crea un nou URI de la zero, pasaţi doar schema.
   $uri = Zend_Uri::factory('http');

   // $uri instanceof Zend_Uri_Http?>

Pentru a crea un nou identificator de resursă (URI) de la zero, pasaţi metodei *Zend_Uri::factory()* doar schema.
[#]_. Dacă se pasează o schemă nesuportată, va fi aruncată o excepţie *Zend_Uri_Exception*.

Dacă schema sau identificatorul de resursă pasat este suportat, *Zend_Uri::factory()* va întoarce o subclasă a
ei care este specializată în schema care trebuie creată.

.. _zend.uri.manipulation:

Manipularea unui identificator de resursă (URI) existent
--------------------------------------------------------

Pentru a manipula un identificator de resursă existent, pasaţi întregul identificator (URI) metodei
*Zend_Uri::factory()*.

.. rubric:: Manipularea unui identificator de resursă (UR) existent cu *Zend_Uri::factory()*

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   // Pentru a manipula un URI existent, pasaţi-l ca parametru.
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri instanceof Zend_Uri_Http?>

Identificatorul de resursă va fi analizat şi validat. Dacă e găsit invalid, va fi aruncată o excepţie
*Zend_Uri_Exception* imediat. În caz contrar, *Zend_Uri::factory()* va întoarce o subclasă a sa care este
specializată în schema care urmează a fi manipulată.

.. _zend.uri.validation:

Validarea unui URI
------------------

Funcţia *Zend_Uri::check()* poate fi utilizată doar dacă validarea unui URI existent este necesară într-un
moment anume.

.. _zend.uri.validation.example-1:

.. rubric:: Validarea unui URI cu *Zend_Uri::check()*

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   // Validează dacă un URI dat este bine format
   $valid = Zend_Uri::check('http://uri.de.validat');

   // $valid este TRUE pentru un URI valid sau FALSE în caz contrar.?>

*Zend_Uri::check()* întoarce rezultatul operaţiei ca tip boolean, lucru care se poate dovedi mai convenabil
decât folosirea metodei *Zend_Uri::factory()* şi prinderea excepţiei.

.. _zend.uri.instance-methods:

Metode obişnuite de creat instanţe
----------------------------------

Fiecare instanţă a unei subclase *Zend_Uri* (ex: *Zend_Uri_Http*) are mai multe metode de instanţiere care se
dovedesc a fi utile în lucrul cu orice tip de URI.

.. _zend.uri.instance-methods.getscheme:

Obţinerea schemei identificatorului (URI)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Schema unui URI este partea acelui URI care precedă caracterul două puncte. De exemplu, schema identificatorului
*http://www.zend.com* este *http*.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Obţinerea schemei dintr-un obiect *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

Metoda *getScheme()* întoarce doar partea din URI care conţine schema obiectului URI.

.. _zend.uri.instance-methods.geturi:

Obţinerea întregului identificator (URI)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Obţinerea întregului identificator dintr-un obiect *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

Metoda *getUri()* întoarce textul reprezentând întregul URI.

.. _zend.uri.instance-methods.valid:

Validarea unui identificator (URI)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Uri::factory()* va valida întotdeauna orice URI pasat ei şi nu va crea o nouă instanţă de subclasă
*Zend_Uri* dacă identificatorul pasat nu este valid. Cu toate acestea, după ce subclasa *Zend_Uri* este
instanţiată pentru un nou URI sau unul existent şi valid, e posibil ca identificatorul să devină ulterior
invalid datorită manipulării părţilor sale componente.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Validarea unui obiect *Zend_Uri_**

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

Metoda *valid()* oferă o cale de a verifica dacă un obiect URI este încă valid.



.. _`Identificatorilor uniformi de resurse`: http://www.w3.org/Addressing/

.. [#] La momentul acestei scrieri, Zend_Uri suporta doar schemele HTTP şi HTTPS.