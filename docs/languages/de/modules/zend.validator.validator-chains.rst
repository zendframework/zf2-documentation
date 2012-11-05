.. EN-Revision: none
.. _zend.validator.validator_chains:

Kettenprüfungen
===============

Oft sollen mehrere Prüfungen an dem selben Wert in einer bestimmten Reihenfolge durchgeführt werden. Der folgende
Code demonstriert einen Weg um das Beispiel der :ref:`Einführung <zend.validator.introduction>` zu Lösen, wo ein
Benutzername zwischen 6 und 12 Alphanumerischen Zeichen lang sein muss:

.. code-block:: php
   :linenos:

   // Eine Prüfkette erstellen und die Prüfungen hinzufügen
   $validatorChain = new Zend\Validate\Validate();
   $validatorChain->addValidator(
                       new Zend\Validate\StringLength(array('min' => 6,
                                                            'max' => 12)))
                  ->addValidator(new Zend\Validate\Alnum());

   // Den Benutzernamen prüfen
   if ($validatorChain->isValid($username)) {
       // Benutzername das die Prüfung bestanden
   } else {
       // Der Benutzername hat die Prüfung nicht bestanden; Gründe ausdrucken
       foreach ($validatorChain->getMessages() as $message) {
           echo "$message\n";
       }
   }

Prüfungen werden in der Reihenfolge durchgeführt in der Sie ``Zend_Validate`` hinzugefügt wurden. Im obigen
Beispiel wird der Benutzername zuerst geprüft um sicherzustellen das die Länge zwischen 6 und 12 Zeichen
beträgt, und anschließend wird geprüft um sicherzustellen das er nur alphanumerische Zeichen enthält. Die
zweite Prüfung, für alphanumerische Zeichen, wird durchgeführt egal ob die Prüfung der Länge zwischen 6 und 12
Zeichen erfolgreich war oder nicht. Das bedeutet, dass wenn beide Prüfungen fehlschlagen, ``getMessages()`` die
Fehlermeldungen von beiden Prüfungen zurück gibt.

In einigen Fällen macht es Sinn eine Prüfung die Kette abbrechen zu lassen wenn der Prüfprozess fehlschlägt.
``Zend_Validate`` unterstützt solche Fälle mit dem zweiten Parameter der ``addValidator()`` Methode. Durch Setzen
von ``$breakChainOnFailure`` zu ``TRUE`` bricht die hinzugefügte Prüfung die Ausführung der Kette bei einem
Fehler ab und verhindert damit die Ausführung von jeglichen anderen Prüfungen welche für diese Situation als
unnötig oder nicht richtig erkannt werden. Wenn das obige Beispiel wie folgt geschrieben wird, wird die
alphanumerische Prüfung nicht stattfinden wenn die Prüfung der Stringlänge fehlschlägt:

.. code-block:: php
   :linenos:

   $validatorChain->addValidator(
                       new Zend\Validate\StringLength(array('min' => 6,
                                                            'max' => 12)),
                       true)
                  ->addValidator(new Zend\Validate\Alnum());

Jegliches Objekt welches das ``Zend\Validate\Interface`` enthält kann in einer Prüfkette verwendet werden.


