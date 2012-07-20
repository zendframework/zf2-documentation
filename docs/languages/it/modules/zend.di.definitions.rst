.. _zend.di.definition:

Definizioni Zend\\Di
====================

Le definizioni sono il modo in cui Zend\\Di cerca di capire la struttura che deve andare a collegare. Questo
significa che se tu scrivi in modo non ambiguo, chiaro e conciso, Zend\\Di ha ottime chance di capire come
collegare le cose insieme senza aggiungere troppa complessità.

.. _zend.di.definition.definitionlist:

DefinitionList
--------------

Le definizioni sono introdotte dall'oggetto Zend\\Di\\Di tramite una lista di definizione implementata come
Zend\\Di\\DefinitionList (SplDoublyLinkedList). L'ordine è importante. Le definizioni in cima alla lista saranno
consultate prima delle definizioni alla fine della lista.

Nota: Non ha importanza la strategia di definizione che decidi di usare, è importante che i tuoi autoloader siano
configurati e pronti all'uso.

.. _zend.di.definition.runtimedefinition:

RuntimeDefinition
-----------------

Di default la DefinitionList istanziata da Zend\\Di\\Di, quando nessun'altra DefinitionList è disponbile, ha una
Definition\\RuntimeDefinition interna. La RuntimeDefinition risponderà alle query sulle classi tramite la
Reflection (riflessione). Queste definizioni Runtime utilizzano una qualunque informazione dentro i metodi: la loro
firma, il nome dei parametri, il tipo di dato dei parametri, e i valori di default per stabilire se qualcosa di
opzionale o obbligatorio quando viene invocato un metodo. Più è esplicito il nome del tuo metodo e la sua firma e
più sarà semplice per Zend\\Di\\Definition\\RuntimeDefinition stabilire la struttura del tuo codice.

Questo è come il costruttore della RuntimeDefinition appare:

.. code-block:: php
   :linenos:

   public function __construct(IntrospectionStrategy $introspectionStrategy = null, array $explicitClasses = null)
   {
       $this->introspectionStrategy = ($introspectionStrategy) ?: new IntrospectionStrategy();
       if ($explicitClasses) {
           $this->setExplicitClasses($explicitClasses);
       }
   }

L'IntrospectionStrategy è un oggetto che determina i ruoli, o le linee guida, come la RuntimeDefinition cercherà
le informazioni sulle tue classi. Le cose che sa fare:

- Utilizzare o meno le (Annotations) annotazioni (Le annotazioni sono dispendiose e spente di default,
  approfondisci nella sezione dedicata)

- Quali nomi dei metodi da includere nella introspezioni di default, il pattern /^set[A-Z]{1}\\w*/ è registrato di
  default.

- Quali nomi interfaccia rappresentano l'interfaccia di iniezione. Di default, il pattern /\\w*Aware\\w*/ è
  registrato.

Il costruttore per l'IntrospectionStrategy apparirà così:

.. code-block:: php
   :linenos:

   public function __construct(AnnotationManager $annotationManager = null)
   {
       $this->annotationManager = ($annotationManager) ?: $this->createDefaultAnnotationManager();
   }

Questo significa che un AnnotationManager non è richiesto, ma se tu vuoi creare uno speciale AnnotationManager con
le tue annotazioni, e anche voler creare uno speciale AnnotationManager con le sue annotazioni e anche voler
estendere la RuntimeDefinition per usare queste speciali Annotations, questo è il modo per farlo.

RuntimeDefinition può anche essere utilizzato per cercare in tutte le classi (implicito di default) esplicitamente
per cercare particolari classi predefinite. Questo è utile quando la tua strategia per ispezionare un set di
classi potrebbe differire da quella di un'altra strategia per una altro set di classi. Questo può essere ottenuto
utilizzando il metodo setExplicitClasses() oppure passando una lista di classi come secondo argomento al
costruttore del RuntimeDefinition.

.. _zend.di.definition.compilerdefinition:

CompilerDefinition
------------------

Il CompilerDefinition è molto simile al RuntimeDefinition con l'eccezione che può essere caricato con pià
informazioni con l'obiettivo di "compilare" una definizione. Questo è utile quando non vuoi fare tutte le chiamate
(spesso costose) alla riflessione e l'analisi delle annotazioni durante le richieste della tua applicazione.
Utilizzando il compilatore, una definizione può essere creata e scritta su disco per essere utilizzata durante una
richiesta di contro al task di scansione del codice.

Per esempio, assumiamo che vogliamo creare uno script che crearà le definizioni per qualcuna delle nostre
librerie:

.. code-block:: php
   :linenos:

   // in "package name" format
   $components = array(
       'My_MovieApp',
       'My_OtherClasses',
   );

   foreach ($components as $component) {
       $diCompiler = new Zend\Di\Definition\CompilerDefinition;
       $diCompiler->addDirectory('/path/to/classes/' . str_replace('_', '/', $component));

       $diCompiler->compile();
       file_put_contents(
           __DIR__ . '/../data/di/' . $component . '-definition.php',
           '<?php return ' . var_export($diCompiler->toArrayDefinition()->toArray(), true) . ';'
       );
   }

Questo creerà una coppia di file che ritornerneranno un array di definizioni per quella classe. Per utilizzarlo in
una applicazioni, il seguente codice sarà sufficiente:

.. code-block:: php
   :linenos:

   protected function setupDi(Application $app)
   {
       $definitionList = new DefinitionList(array(
           new Definition\ArrayDefinition(include __DIR__ . '/path/to/data/di/My_MovieApp-definition.php'),
           new Definition\ArrayDefinition(include __DIR__ . '/path/to/data/di/My_OtherClasses-definition.php'),
           $runtime = new Definition\RuntimeDefinition(),
       ));
       $di = new Di($definitionList, null, new Configuration($this->config->di));
       $di->instanceManager()->addTypePreference('Zend\Di\LocatorInterface', $di);
       $app->setLocator($di);
   }

Il codice sopra vuole essere più di qualcosa ma mettere nella tua applicazione o nel bootstrap di un modulo.
Questo rappresenta il modo più semplice e performante per configurare il tuo DiC da utilizzare.

.. _zend.di.definition.classdefinition:

ClassDefinition
---------------

L'idea dietro l'utilizzo della ClassDefinition è duplice. Primo, potresti voler sovrascrivere qualche informazione
dentro alla RuntimeDefinition. Secondo, potresti semplicemente definire la tua classe con un xml, ini o php file
descrivendone la struttura. Questa definizione di classe può essere alimentata tramite il Configuration oppure
direttamente istanziando e registrando un Definition con la DefinitionList.

Todo - example


