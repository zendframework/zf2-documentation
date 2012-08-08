.. EN-Revision: none
.. _migration.06:

Zend Framework 0.6
==================

Lors de la migration d'un version précédente vers Zend Framework 0.6 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.06.zend.controller:

Zend_Controller
---------------

L'utilisation de base des composants *MVC* n'a pas changé ; vous pouvez toujours faire comme suit :

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/chemin/vers/controleurs');

.. code-block:: php
   :linenos:

   /* -- créer un routeur -- */
   $router = new Zend_Controller_RewriteRouter();
   $router->addRoute('user', 'user/:username', array('controller' => 'user',
   'action' => 'info'));

   /* -- l'affecter à un contrôleur -- */
   $ctrl = Zend_Controller_Front::getInstance();
   $ctrl->setRouter($router);

   /* -- régler le répertoire des contrôleurs et distribuer -- */
   $ctrl->setControllerDirectory('/chemin/vers/controleurs');
   $ctrl->dispatch();

Nous encourageons l'utilisation de l'objet Réponse pour agréger le contenu et les en-têtes. Ceci permet un
basculement plus flexible entre les formats d'affichage (par exemple, *JSON* ou *XML* au lieu de *XHTML*) dans vos
applications. Par défaut, ``dispatch()`` va effectuer le rendu de la réponse, envoyant à la fois les en-têtes
et tout contenu. Vous pouvez aussi avoir le contrôleur frontal qui retourne la réponse en utilisant
``returnResponse()``, et qui ensuite effectue le rendu de la réponse suivant votre propre logique. Une version
future du contrôleur frontal peut mettre en application l'utilisation de l'objet Réponse via la `bufferisation de
sortie`_.

Il existe beaucoup d'autres fonctionnalités qui étendent l'API existante, et celles-ci sont décrites dans la
documentation.

Le changement le plus important auquel vous devrez faire attention apparaîtra quand vous tenterez de sous-classer
les différents composants. La clé se trouve ci-dessous :

- ``Zend_Controller_Front::dispatch()`` intercepte par défaut les exceptions dans l'objet réponse, et ne les
  affiche pas, afin d'éviter l'affichage d'information sensible du système. Vous pouvez surcharger ceci de
  différentes manières :

  - Régler ``throwExceptions()`` dans le contrôleur frontal :

    .. code-block:: php
       :linenos:

       $front->throwExceptions(true);

  - Régler ``renderExceptions()`` dans l'objet Réponse :

    .. code-block:: php
       :linenos:

       $response->renderExceptions(true);
       $front->setResponse($response);
       $front->dispatch();
       // ou :
       $front->returnResponse(true);
       $response = $front->dispatch();
       $response->renderExceptions(true);
       echo $response;

- ``Zend_Controller_Dispatcher_Interface::dispatch()`` accepte maintenant et retourne un objet :ref:`
  <zend.controller.request>` au lieu d'un élément du distributeur.

- ``Zend_Controller_Router_Interface::route()`` accepte maintenant et retourne un objet :ref:`
  <zend.controller.request>` au lieu d'un élément du distributeur.

- Les changements de ``Zend_Controller_Action`` incluent :

  - Le constructeur accepte maintenant exactement trois arguments, ``Zend_Controller_Request_Abstract $request``,
    ``Zend_Controller_Response_Abstract $response``, et le tableau facultatif ``$params``.
    ``Zend_Controller_Action::__construct()`` les utilise pour affecter la requête, la réponse, et les
    propriétés *invokeArgs* de l'objet, et si vous devez surcharger le constructeur, vous devez faire de même.
    La meilleure solution est d'utiliser la méthode ``init()`` pour réaliser toute configuration de l'instance,
    puisque cette méthode est appelée en tant que action finale du constructeur.

  - ``run()`` n'est plus défini en tant qu'élément final, mais n'est pas non plus utilisé par le contrôleur
    frontal ; son seul but apparaît lors de l'utilisation de la classe en tant que contrôleur de page. Il prend
    maintenant deux arguments facultatifs, un ``Zend_Controller_Request_Abstract $request`` et un
    ``Zend_Controller_Response_Abstract $response``.

  - ``indexAction()`` ne nécessite plus d'être défini, mais est recommandé en tant qu'action par défaut. Ceci
    permet lors de l'utilisation de *RewriteRouter* et des contrôleurs d'action de spécifier différentes
    méthodes d'action par défaut.

  - ``__call()`` peut être surchargé pour gérer automatiquement les actions non définies.

  - ``_redirect()`` prend maintenant un second paramètre facultatif, le code *HTTP* à retourner avec la
    redirection, et un troisième paramètre optionnel, ``$prependBase``, qui peut indiquer que l'URL de base
    enregistré avec l'objet requête peut être ajouté en tant que suffixe à l'URL spécifié.

  - La propriété *_action* n'existe plus. Cette propriété était un ``Zend_Controller_Dispatcher_Token``, qui
    n'existe plus maintenant. Le seul but de cet élément est de fournir l'information concernant le contrôleur,
    l'action et les paramètres d'URL de la requête. Cette information est maintenant disponible dans l'objet
    requête, et peut être interrogé comme ceci :

    .. code-block:: php
       :linenos:

       // Récupère le nom de controleur de la requête
       // L'accès se fait via : $this->_action->getControllerName().
       // L'exemple ci-dessous utilise getRequest(), bien que vous pourriez
       // accéder directement à la propriété $_request ;
       // l'utilisation de getRequest() est recommandée puisque la classe
       // parente peut surcharger l'accès à l'objet requête.
       $controller = $this->getRequest()->getControllerName();

       // Recupere le nom de l'action de la requete
       // L'acces se fait via : $this->_action->getActionName().
       $action = $this->getRequest()->getActionName();

       // Recupere les parametres de la requete
       // Ceci n'a pas changé ; les méthodes _getParams() et _getParam()
       // relaient simplement l'objet requete maintenant.
       $params = $this->_getParams();
       $foo = $this->_getParam('foo', 'default');
       // parametre de la requete 'foo', en utilisant 'default'
       // en tant que valeur par défaut si aucune valeur n'est trouvée

  - ``noRouteAction()`` a été effacée. La manière appropriée de gérer les méthodes d'actions non-existantes
    est de les router vers une action par défaut en utilisant ``__call()``\  :

    .. code-block:: php
       :linenos:

       public function __call($method, $args)
       {
           // Si la méthode requetee ne correspond a aucune methode 'Action',
           // on renvoie vers la méthode d'action par défaut :
           if ('Action' == substr($method, -6)) {
               return $this->defaultAction();
           }

           throw new Zend_Controller_Exception('Appel de methode invalide');
       }

- ``Zend_Controller_RewriteRouter::setRewriteBase()`` a été effacée. Utilisez plutôt
  ``Zend_Controller_Front::setBaseUrl()`` (ou Zend_Controller_Request_Http::setBaseUrl(), si vous utilisez cette
  classe de requête).

- ``Zend_Controller_Plugin_Interface`` a été remplacée par ``Zend_Controller_Plugin_Abstract``. Toutes les
  méthodes acceptent et retournent maintenant un objet :ref:` <zend.controller.request>` au lieu d'un élément du
  distributeur.



.. _`bufferisation de sortie`: http://php.net/manual/fr/ref.outcontrol.php
