.. _migration.08:

Zend Framework 0.8
==================

Lors de la migration d'un version précédente vers Zend Framework 0.8 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.08.zend.controller:

Zend_Controller
---------------

Pour les versions précédentes, l'utilisation basique des composants *MVC* reste la même :

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/chemin/vers/controleurs');

Cependant, la structure des dossiers a subi une réorganisation, certains composants ont été effacés, et
d'autres ont été soit renommés soit ajoutés. Les changements incluent :

- ``Zend_Controller_Router`` a été effacé en faveur du routeur de réécriture ("rewrite router").

- ``Zend_Controller_RewriteRouter`` a été renommé en ``Zend_Controller_Router_Rewrite``, et promu en tant que
  routeur standard fourni avec le framework ; ``Zend_Controller_Front`` l'utilise par défaut si aucun autre
  routeur n'est fourni.

- Une nouvelle classe de route à utiliser avec le routeur de réécriture a été introduite,
  ``Zend_Controller_Router_Route_Module``; elle couvre la route par défaut utilisée par le *MVC*, et supporte les
  :ref:`modules de contrôleurs <zend.controller.modular>`.

- ``Zend_Controller_Router_StaticRoute`` a été renommé en ``Zend_Controller_Router_Route_Static``.

- ``Zend_Controller_Dispatcher`` a été renommé en ``Zend_Controller_Dispatcher_Standard``.

- Les arguments de ``Zend_Controller_Action::_forward()`` ont changés. La signature est maintenant :

  .. code-block:: php
     :linenos:

     final protected function _forward($action,
                                       $controller = null,
                                       $module = null,
                                       array $params = null);

  ``$action`` est toujours obligatoire ; si aucun contrôleur n'est spécifié, une action dans le contrôleur
  courant est considérée. ``$module`` est toujours ignoré à moins que ``$controller`` ne soit spécifié. Pour
  finir, tout ``$params`` fourni sera ajouté à l'objet requête. Si aucun contrôleur ou module n'est
  nécessaire, mais que des paramètres le sont, passez simplement ``NULL`` pour ces valeurs.


