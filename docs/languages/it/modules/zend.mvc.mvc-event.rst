.. _zend.mvc.mvc-event:

MvcEvent
========

Il layer MVC di ZF2 incorpora ed utilizza un tipo ``Zend\EventManager\EventDescription`` custom,
``Zend\Mvc\MvcEvent``. Questo evento è creato durante ``Zend\Mvc\Application::run()`` ed è passato direttamente a
tutti gli eventi che sono avviati. In aggiunta, se marchi i tuoi controller con l'interfaccia
``Zend\Mvc\InjectApplicationEvent``, questa sarà iniettata in quei controller.

``MvcEvent`` aggiungere accessori e mutatori per le seguenti:

- ``Request``

- ``Response``

- ``Router``

- ``RouteMatch``

- "Result", tipicamente il risultato dell'esecuzione di un controller

I metodi che definisce sono:

- ``setRequest($request)``

- ``getRequest()``

- ``setResponse($response)``

- ``getResponse()``

- ``setRouter($router)``

- ``getRouter()``

- ``setRouteMatch($routeMatch)``

- ``getRouteMatch()``

- ``setResult($result)``

- ``getResult()``

Dentro ``Application::run()``, l'evento è iniettato con la Request, Response e il Router immediatamente. Seguendo
l'evento ``route``, questo sarà iniettato anche nell'oggetto ``RouteMatch`` incapsulando il risultato del routing.

Fichè questo oggetto è passato in giro attraverso lo MVC, è un luogo comune dove ricevere i risultati del
routing, il router, e gli oggetti richiesta e risposta. In aggiunta, noi incoraggiamo l'impostazione dei risultati
dell'esecuzione nell'evento, per permettere agli event listener di ispezionarlo ed utilizzarli nella loro
esecuzione. Un esempio, il risultato potrebbe essere passato ad un view renderer.


