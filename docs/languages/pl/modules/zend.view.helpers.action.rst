.. _zend.view.helpers.initial.action:

Helper Action
=============

Helper *Action* pozwala skryptom widoku na uruchomienie konkretnej akcji kontrolera; wynik wywołania znajdujący
się w obiekcie odpowiedzi zostaje zwrócony. Możemy go użyć gdy dana akcja generuje zawartość, którą
możemy wielokrotnie wykorzystać lub zawartość w rodzaju wdigeta.

Akcje które wywołują metodę *_forward()* lub przekierowują będą uznane za nieprawidłowe i helper zwróci
pusty łańcuch znaków.

Interfejs helpera *Action* jest podobny jak w większości komponentów MVC które wywołują akcje kontrolerów:
*action($action, $controller, $module = null, array $params = array())*. Parametry *$action* oraz *$controller* są
wymagane; jeśli moduł nie zostanie określony, przyjęty zostanie moduł domyślny.

.. _zend.view.helpers.initial.action.usage:

.. rubric:: Proste użycia helpera Action

Przykładem może być kontroler *CommentController* zawierający akcję *listAction()*, którą chcesz wywołać
aby pobrać dla obecnego żądania listę komentarzy:

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?= $this->action('list', 'comment', null, array('count' => 10)); ?>
       </div>
   </div>



