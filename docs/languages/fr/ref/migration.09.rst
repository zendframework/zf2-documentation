.. EN-Revision: none
.. _migration.09:

Zend Framework 0.9
==================

Lors de la migration d'un version précédente vers Zend Framework 0.9 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.09.zend.controller:

Zend_Controller
---------------

0.9.3 introduit les :ref:`aides d'actions <zend.controller.actionhelpers>`. En lien avec ce changement, les
méthodes suivantes ont été effacées puisqu'elles sont maintenant encapsulées dans :ref:`l'aide d'action
redirector <zend.controller.actionhelpers.redirector>`\  :

- ``setRedirectCode()`` à remplacer par ``Zend_Controller_Action_Helper_Redirector::setCode()``.

- ``setRedirectPrependBase()`` à remplacer par ``Zend_Controller_Action_Helper_Redirector::setPrependBase()``.

- ``setRedirectExit()`` à remplacer par ``Zend_Controller_Action_Helper_Redirector::setExit()``.

Lisez la :ref:`documentation des aides d'actions <zend.controller.actionhelpers>`\ pour plus d'informations sur la
récupération ou la manipulation des objets "helper", et la :ref:`documentation du helper redirector
<zend.controller.actionhelpers.redirector>`\ pour plus d'informations sur le réglage des options de redirection
(de même que pour les méthodes alternatives de redirection).


