.. EN-Revision: none
.. _zend.captcha.operation:

Captcha Anwendung
=================

Alle *CAPTCHA* Adapter implementieren ``Zend_Captcha_Adapter``, welches wie folgt aussieht:

.. code-block:: php
   :linenos:

   interface Zend_Captcha_Adapter extends Zend_Validate_Interface
   {
       public function generate();

       public function render(Zend_View $view, $element = null);

       public function setName($name);

       public function getName();

       public function getDecorator();

       // Zusätzlich um das Zend_Validate_Interface zu befriedigen:
       public function isValid($value);

       public function getMessages();

       public function getErrors();
   }

Die benannten Getter- und Settermethoden werden verwenden um den *CAPTCHA* Identifikator zu spezifizieren und zu
empfangen. ``getDecorator()`` kann verwendet werden um einen ``Zend_Form`` Dekorator entweder durch seinen Namen zu
Spezifizieren oder indem ein aktuelles Dekoratorobjekt zurückgegeben wird. Der interessantesten Methoden sind aber
``generate()`` und ``render()``. ``generate()`` wird verwendet um das *CAPTCHA* Token zu erstellen. Dieser Prozess
speichert das Token typischerweise in der Session damit es in nachfolgenden Anfragen verglichen werden kann.
``render()`` wird verwendet um die Informationen die das *CAPTCHA* repräsentieren darzustellen - ob es ein Bild
ist, ein Figlet, ein logisches Problem, oder andere *CAPTCHA*.

Ein typischer Verwendungsfall könnte wie folgt aussehen:

.. code-block:: php
   :linenos:

   // Eine Instanz von Zend_View erstellen
   $view = new Zend_View();

   // Originale Anfrage:
   $captcha = new Zend_Captcha_Figlet(array(
       'name' => 'foo',
       'wordLen' => 6,
       'timeout' => 300,
   ));

   $id = $captcha->generate();
   echo "<form method=\"post\" action=\"\">";
   echo $captcha->render($view);
   echo "</form>";

   // Eine nachfolgende Anfrage:
   // Angenommen das Captcha wurde wie vorher eingestellt, dann wäre der Wert von
   // $_POST['foo'] ein Schlüssel/Wert Array:
   // id => captcha ID, input => captcha value
   if ($captcha->isValid($_POST['foo'], $_POST)) {
       // Validated!
   }


