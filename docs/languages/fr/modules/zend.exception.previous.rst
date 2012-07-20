.. _zend.exception.previous:

Exceptions précédentes
======================

Depuis Zend Framework 1.10, ``Zend_Exception`` utilise les exceptions PHP 5.3 concernant l'exception précédente.
Simplement, dans un bloc ``catch``, il est possible d'envoyer une exception faisant référence à la précédente,
ce qui améliore le contexte de débogage. Ce support dans Zend Framework apporte le support complet de PHP 5.3
concernant les exceptions.

L'exception précedente s'utilise comme troisième paramètre du constructeur de la classe Exception.

.. _zend.exception.previous.example:

.. rubric:: Exceptions précedentes

.. code-block:: php
   :linenos:

   try {
       $db->query($sql);
   } catch (Zend_Db_Statement_Exception $e) {
       if ($e->getPrevious()) {
           echo '[' . get_class($e)
               . '] a comme exception précédente ['
               . get_class($e->getPrevious())
               . ']' . PHP_EOL;
       } else {
           echo '[' . get_class($e)
               . '] n'a pas d'exception qui la précède'
               . PHP_EOL;
       }

       echo $e;
       // affiche toutes les exception à commencer par la première, puis
       // dépile.
   }


