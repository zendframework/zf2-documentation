.. EN-Revision: none
.. _zend.form.elements:

Tworzenie elementów formularza za pomocą klasy Zend\Form\Element
================================================================

Formularz składa się z elementów, które zazwyczaj odpowiadają elementom formularzy HTML. Klasa
Zend\Form\Element obsługuje pojedyncze elementy formularza w takich zakresach:

- weryfikacja (czy wysłane dane są poprawne?)

  - przechowywanie kodów i komunikatów o błędach jakie wystąpiły podczas weryfikacji

- filtrowanie (w jaki sposób element jest przygotowany do weryfikacji i wyświetlenia?)

- renderowanie (jak element jest wyświetlany?)

- dane meta i atrybuty (jakie dodatkowe informacje opisują element?)

Klasa bazowa *Zend\Form\Element* jest domyślnie skonfigurowana dla wielu przypadków użycia, jednak najlepiej
jest rozszerzyć tę klasę aby utworzyć najczęściej używane elementy. Dodatkowo Zend Framework zawiera pewną
ilość standardowych elementów XHTML; możesz o nich przeczytać :ref:`w rozdziale Standardowe Elementy
<zend.form.standardElements>`.

.. _zend.form.elements.loaders:

Ładowanie wtyczek
-----------------

Klasa *Zend\Form\Element* używa klasy :ref:`Zend\Loader\PluginLoader <zend.loader.pluginloader>` aby umożliwić
programistom określenie ścieżek, w których znajdują się alternatywne weryfikatory, filtry i dekoratory.
Każda z tych wtyczek ma przypisaną własną klasę ładującą je, a do ich modyfikacji używany jest zestaw
metod dostępowych.

W metodach obsługujących ładowanie wtyczek używane są następujące typy: 'validate', 'filter' oraz
'decorator'. Wielkość liter w nazwach typów nie jest istotna.

Metody używane do obsługi ładowania wtyczek to:

- *setPluginLoader($loader, $type)*: *$loader* jest obiektem klasy ładującej wtyczki, a *$type* jest jednym z
  typów określonych wyżej. Metoda ustawia obiekt ładujący wtyczki dla danego typu.

- *getPluginLoader($type)*: zwraca klasę ładującą wtyczkę powiązaną z typem *$type*.

- *addPrefixPath($prefix, $path, $type = null)*: adds a prefix/path association to the loader specified by *$type*.
  If *$type* is null, it will attempt to add the path to all loaders, by appending the prefix with each of
  "\_Validate", "\_Filter", and "\_Decorator"; and appending the path with "Validate/", "Filter/", and
  "Decorator/". If you have all your extra form element classes under a common hierarchy, this is a convenience
  method for setting the base prefix for them.

- *addPrefixPaths(array $spec)*: allows you to add many paths at once to one or more plugin loaders. It expects
  each array item to be an array with the keys 'path', 'prefix', and 'type'.

Własne weryfikatory, filtry i dekoratory są łatwym sposobem na użycie pewnej własnej funkcjonalności w wielu
formularzach.

.. _zend.form.elements.loaders.customLabel:

.. rubric:: Własna etykieta

One common use case for plugins is to provide replacements for standard classes. For instance, if you want to
provide a different implementation of the 'Label' decorator -- for instance, to always append a colon -- you could
create your own 'Label' decorator with your own class prefix, and then add it to your prefix path.

Spróbujmy stworzyć własny dekorator dla etykiety. Damy jego klasie przedrostek "My_Decorator", a sama klasa
będzie znajdować się w pliku "My/Decorator/Label.php".

.. code-block::
   :linenos:

   class My_Decorator_Label extends Zend\Form_Decorator\Abstract
   {
       protected $_placement = 'PREPEND';

       public function render($content)
       {
           if (null === ($element = $this->getElement())) {
               return $content;
           }
           if (!method_exists($element, 'getLabel')) {
               return $content;
           }

           $label = $element->getLabel() . ':';

           if (null === ($view = $element->getView())) {
               return $this->renderLabel($content, $label);
           }

           $label = $view->formLabel($element->getName(), $label);

           return $this->renderLabel($content, $label);
       }

       public function renderLabel($content, $label)
       {
           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'APPEND':
                   return $content . $separator . $label;
               case 'PREPEND':
               default:
                   return $label . $separator . $content;
           }
       }
   }


Now we can tell the element to use this plugin path when looking for decorators:

.. code-block::
   :linenos:

   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');


Alternately, we can do that at the form level to ensure all decorators use this path:

.. code-block::
   :linenos:

   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');


With this path added, when you add a decorator, the 'My/Decorator/' path will be searched first to see if the
decorator exists there. As a result, 'My_Decorator_Label' will now be used when the 'Label' decorator is requested.

.. _zend.form.elements.filters:

Filtry
------

It's often useful and/or necessary to perform some normalization on input prior to validation – for instance, you
may want to strip out all HTML, but run your validations on what remains to ensure the submission is valid. Or you
may want to trim empty space surrounding input so that a StringLength validator will not return a false positive.
These operations may be performed using *Zend_Filter*, and *Zend\Form\Element* has support for filter chains,
allowing you to specify multiple, sequential filters to utilize. Filtering happens both during validation and when
you retrieve the element value via *getValue()*:

.. code-block::
   :linenos:

   $filtered = $element->getValue();


Filtry mogą być dodane na dwa sposoby:

- przekazanie konkretnego egzemplarza obiektu filtra

- przekazanie nazwy filtra – krótkiej lub pełnej nazwy

Zobaczmy kilka przykładów:

.. code-block::
   :linenos:

   // Konkretny egzemplarz obiektu filtra:
   $element->addFilter(new Zend\Filter\Alnum());

   // Pełna nazwa filtra:
   $element->addFilter('Zend\Filter\Alnum');

   // Krótka nazwa filtra:
   $element->addFilter('Alnum');
   $element->addFilter('alnum');


Krótkie nazwy są zazwyczaj nazwą klasy filtra pozbawioną przedrostka. W domyślnym przypadku, będzie to
oznaczało że pomijamy przedrostek 'Zend_Filter\_'. Nie jest też konieczne aby pierwsza litera była wielka.

.. note::

   **Użycie własnych klas filtrów**

   Jeśli posiadasz własny zestaw klas filtrów, możesz przekazać klasie *Zend\Form\Element* informacje o tym za
   pomocą metody *addPrefixPath()*. Na przykład jeśli posiadasz filtry z przedostkiem 'My_Filter' możesz
   przekazać do klasy *Zend\Form\Element* informację w taki sposób:

   .. code-block::
      :linenos:

      $element->addPrefixPath('My_Filter', 'My/Filter/', 'filter');


   (Zauważ że trzeci argument oznacza typ wtyczek dla którego określamy przedrostek)

Jęśli w potrzebujesz niefiltrowaną wartość użyj metody *getUnfilteredValue()*:

.. code-block::
   :linenos:

   $unfiltered = $element->getUnfilteredValue();


Aby uzyskać więcej informacji o filtrach zobacz :ref:`dokumentację klasy Zend_Filter
<zend.filter.introduction>`.

Metody powiązane z filtrami to:

- *addFilter($nameOfFilter, array $options = null)*

- *addFilters(array $filters)*

- *setFilters(array $filters)* (nadpisuje wszystkie filtry)

- *getFilter($name)* (pobiera obiekt filtra)

- *getFilters()* (pobiera wszystkie filtry)

- *removeFilter($name)* (usuwa filtr)

- *clearFilters()* (usuwa wszystkie filtry)

.. _zend.form.elements.validators:

Weryfikatory
------------

If you subscribe to the security mantra of "filter input, escape output," you'll want to validate ("filter input")
your form input. In *Zend_Form*, each element includes its own validator chain, consisting of *Zend\Validate\**
validators.

Weryfikatory mogą być dodane na dwa sposoby:

- przekazanie konkretnego egzemplarza obiektu weryfikatora

- przekazanie nazwy weryfikatora – krótkiej lub pełnej nazwy

Zobaczmy kilka przykładów:

.. code-block::
   :linenos:

   // Konkretny egzemplarz obiektu weryfikatora:
   $element->addValidator(new Zend\Validate\Alnum());

   // Pełna nazwa klasy:
   $element->addValidator('Zend\Validate\Alnum');

   // Krótka nazwa weryfikatora:
   $element->addValidator('Alnum');
   $element->addValidator('alnum');


Krótkie nazwy są zazwyczaj nazwą klasy weryfikatora pozbawioną przedrostka. W domyślnym przypadku, będzie to
oznaczało że pomijamy przedrostek 'Zend_Validate\_'. Nie jest też konieczne aby pierwsza litera była wielka.

.. note::

   **Użycie własnych klas weryfikatorów**

   Jeśli posiadasz własny zestaw klas weryfikatorów, możesz przekazać klasie *Zend\Form\Element* informacje o
   tym za pomocą metody *addPrefixPath()*. Na przykład jeśli posiadasz weryfikatory z przedostkiem
   'My_Validator' możesz przekazać do klasy *Zend\Form\Element* informację w taki sposób:

   .. code-block::
      :linenos:

      $element->addPrefixPath('My_Validator', 'My/Validator/', 'validate');


   (Zauważ że trzeci argument oznacza typ wtyczek dla którego określamy przedrostek)

If failing a particular validation should prevent later validators from firing, pass boolean *true* as the second
parameter:

.. code-block::
   :linenos:

   $element->addValidator('alnum', true);


If you are using a string name to add a validator, and the validator class accepts arguments to the constructor,
you may pass these to the third parameter of *addValidator()* as an array:

.. code-block::
   :linenos:

   $element->addValidator('StringLength', false, array(6, 20));


Arguments passed in this way should be in the order in which they are defined in the constructor. The above example
will instantiate the *Zend\Validate\StringLenth* class with its *$min* and *$max* parameters:

.. code-block::
   :linenos:

   $validator = new Zend\Validate\StringLength(6, 20);


.. note::

   **Określanie własnych komunikatów o błędach**

   Some developers may wish to provide custom error messages for a validator. *Zend\Form\Element::addValidator()*'s
   *$options* argument allows you to do so by providing the key 'messages' and setting it to an array of key/value
   pairs for setting the message templates. You will need to know the error codes of the various validation error
   types for the particular validator.

   A better option is to use a *Zend\Translator\Adapter* with your form. Error codes are automatically passed to
   the adapter by the default Errors decorator; you can then specify your own error message strings by setting up
   translations for the various error codes of your validators.

Możesz także ustawić wiele weryfikatorów na raz, używając metody *addValidators()*. Podstawowym sposobem
użycia jest przekazanie tablicy tablic, gdzie każda z tablic posiada od 1 do 3 wartości, zgodnych z wywołaniem
metody *addValidator()*:

.. code-block::
   :linenos:

   $element->addValidators(array(
       array('NotEmpty', true),
       array('alnum'),
       array('stringLength', false, array(6, 20)),
   ));


If you want to be more verbose or explicit, you can use the array keys 'validator', 'breakChainOnFailure', and
'options':

.. code-block::
   :linenos:

   $element->addValidators(array(
       array(
           'validator'           => 'NotEmpty',
           'breakChainOnFailure' => true),
       array('validator' => 'alnum'),
       array(
           'validator' => 'stringLength',
           'options'   => array(6, 20)),
   ));


Ten przykład pokazuje w jaki sposób możesz skonfigurować weryfikatory w pliku konfiguracyjnym:

.. code-block::
   :linenos:

   element.validators.notempty.validator = "NotEmpty"
   element.validators.notempty.breakChainOnFailure = true
   element.validators.alnum.validator = "Alnum"
   element.validators.strlen.validator = "StringLength"
   element.validators.strlen.options.min = 6
   element.validators.strlen.options.max = 20


Notice that every item has a key, whether or not it needs one; this is a limitation of using configuration files --
but it also helps make explicit what the arguments are for. Just remember that any validator options must be
specified in order.

Aby sprawdzić poprawność elementu przekaż wartość do metody: *isValid()*:

.. code-block::
   :linenos:

   if ($element->isValid($value)) {
       // prawidłowy
   } else {
       // nieprawidłowy
   }


.. note::

   **Weryfikowane są przefiltrowane wartości**

   *Zend\Form\Element::isValid()* filtruje wartości za pomocą ustawionych filtrów zanim zostanie przeprowadzona
   weryfikacja. Zobacz :ref:`rozdział Filtry <zend.form.elements.filters>` aby uzyskać więcej informacji.

.. note::

   **Weryfikacja w kontekście**

   *Zend\Form\Element::isValid()* supports an additional argument, *$context*. *Zend\Form\Form::isValid()* passes the
   entire array of data being processed to *$context* when validating a form, and *Zend\Form\Element::isValid()*,
   in turn, passes it to each validator. This means you can write validators that are aware of data passed to other
   form elements. As an example, consider a standard registration form that has fields for both password and a
   password confirmation; one validation would be that the two fields match. Such a validator might look like the
   following:

   .. code-block::
      :linenos:

      class My_Validate_PasswordConfirmation extends Zend\Validate\Abstract
      {
          const NOT_MATCH = 'notMatch';

          protected $_messageTemplates = array(
              self::NOT_MATCH => 'Password confirmation does not match'
          );

          public function isValid($value, $context = null)
          {
              $value = (string) $value;
              $this->_setValue($value);

              if (is_array($context)) {
                  if (isset($context['password_confirm'])
                      && ($value == $context['password_confirm']))
                  {
                      return true;
                  }
              } elseif (is_string($context) && ($value == $context)) {
                  return true;
              }

              $this->_error(self::NOT_MATCH);
              return false;
          }
      }


Validators are processed in order. Each validator is processed, unless a validator created with a true
*breakChainOnFailure* value fails its validation. Be sure to specify your validators in a reasonable order.

Po nieudanej weryfikacji możesz pobrać kody i komunikaty błędów:

.. code-block::
   :linenos:

   $errors   = $element->getErrors();
   $messages = $element->getMessages();


(Uwaga: komunikaty o błędach są zwracane jako asocjacyjna tablica w postaci par kod / komunikat.)

In addition to validators, you can specify that an element is required, using *setRequired(true)*. By default, this
flag is false, meaning that your validator chain will be skipped if no value is passed to *isValid()*. You can
modify this behavior in a number of ways:

- By default, when an element is required, a flag, 'allowEmpty', is also true. This means that if a value
  evaluating to empty is passed to *isValid()*, the validators will be skipped. You can toggle this flag using the
  accessor *setAllowEmpty($flag)*; when the flag is false, then if a value is passed, the validators will still
  run.

- By default, if an element is required, but does not contain a 'NotEmpty' validator, *isValid()* will add one to
  the top of the stack, with the *breakChainOnFailure* flag set. This makes the required flag have semantic
  meaning: if no value is passed, we immediately invalidate the submission and notify the user, and prevent other
  validators from running on what we already know is invalid data.

  If you do not want this behavior, you can turn it off by passing a false value to
  *setAutoInsertNotEmptyValidator($flag)*; this will prevent *isValid()* from placing the 'NotEmpty' validator in
  the validator chain.

Aby uzyskać więcej informacji o weryfikatorach, zobacz :ref:`dokumentację klasy Zend_Validate
<zend.validate.introduction>`.

.. note::

   **Użycie klasy Zend\Form\Elements jako weryfikatora**

   Klasa *Zend\Form\Element* implementuje interfejs *Zend\Validate\Interface*, co oznacza, że element może być
   także użyty jako weryfikator, w zastosowaniu nie związanym z formularzami.

Metody powiązane z weryfikatorami to:

- *setRequired($flag)* and *isRequired()* allow you to set and retrieve the status of the 'required' flag. When set
  to boolean *true*, this flag requires that the element be in the data processed by *Zend_Form*.

- *setAllowEmpty($flag)* and *getAllowEmpty()* allow you to modify the behaviour of optional elements (i.e.,
  elements where the required flag is false). When the 'allow empty' flag is true, empty values will not be passed
  to the validator chain.

- *setAutoInsertNotEmptyValidator($flag)* allows you to specify whether or not a 'NotEmpty' validator will be
  prepended to the validator chain when the element is required. By default, this flag is true.

- *addValidator($nameOrValidator, $breakChainOnFailure = false, array $options = null)*

- *addValidators(array $validators)*

- *setValidators(array $validators)* (nadpisuje wszystkie weryfikatory)

- *getValidator($name)* (pobiera obiekt weryfikatora)

- *getValidators()* (pobiera wszystkie obiekty weryfikatorów)

- *removeValidator($name)* (usuwa obiekt weryfikatora)

- *clearValidators()* (usuwa wszystkie obiekty weryfikatorów)

.. _zend.form.elements.validators.errors:

Custom Error Messages
^^^^^^^^^^^^^^^^^^^^^

At times, you may want to specify one or more specific error messages to use instead of the error messages
generated by the validators attached to your element. Additionally, at times you may want to mark the element
invalid yourself. As of 1.6.0, this functionality is possible via the following methods.

- *addErrorMessage($message)*: add an error message to display on form validation errors. You may call this more
  than once, and new messages are appended to the stack.

- *addErrorMessages(array $messages)*: add multiple error messages to display on form validation errors.

- *setErrorMessages(array $messages)*: add multiple error messages to display on form validation errors,
  overwriting all previously set error messages.

- *getErrorMessages()*: retrieve the list of custom error messages that have been defined.

- *clearErrorMessages()*: remove all custom error messages that have been defined.

- *markAsError()*: mark the element as having failed validation.

- *hasErrors()*: determine whether the element has either failed validation or been marked as invalid.

- *addError($message)*: add a message to the custom error messages stack and flag the element as invalid.

- *addErrors(array $messages)*: add several messages to the custom error messages stack and flag the element as
  invalid.

- *setErrors(array $messages)*: overwrite the custom error messages stack with the provided messages and flag the
  element as invalid.

All errors set in this fashion may be translated. Additionally, you may insert the placeholder "%value%" to
represent the element value; this current element value will be substituted when the error messages are retrieved.

.. _zend.form.elements.decorators:

Dekoratory
----------

One particular pain point for many web developers is the creation of the XHTML forms themselves. For each element,
the developer needs to create markup for the element itself, typically a label, and, if they're being nice to their
users, markup for displaying validation error messages. The more elements on the page, the less trivial this task
becomes.

*Zend\Form\Element* tries to solve this issue through the use of "decorators". Decorators are simply classes that
have access to the element and a method for rendering content. For more information on how decorators work, please
see the section on :ref:`Zend\Form\Decorator <zend.form.decorators>`.

Domyśle dekoratory używane przez klasę *Zend\Form\Element* to:

- **ViewHelper**: określą klasę pomocniczą widoku, która ma być użyta do renderowania określonego elementu.
  Atrybut 'helper' może być użyty aby określić która klasa pomocnicza ma być użyta. Domyślnie klasa
  *Zend\Form\Element* określa domyślną klasę pomocniczą jako 'formText', jednak klasy rozszerzające
  określają inne klasy pomocnicze.

- **Errors**: dołączą komunikaty błędów do elementu używając klasy *Zend\View_Helper\FormErrors*. Jeśli
  błędów nie ma nic nie zostaje dołączone.

- **HtmlTag**: otacza element i błędy znacznikiem HTML <dd>.

- **Label**: prepends a label to the element using *Zend\View_Helper\FormLabel*, and wraps it in a <dt> tag. If no
  label is provided, just the definition term tag is rendered.

.. note::

   **Domyślne dekoratory nie muszą być ładowane**

   Domyślny zestaw dekoratorów jest ładowany podczas inicjowania obiektu. Możesz to zablokować określając
   opcję 'disableLoadDefaultDecorators' konstruktora:

   .. code-block::
      :linenos:

      $element = new Zend\Form\Element('foo',
                                       array('disableLoadDefaultDecorators' =>
                                            true)
                                       );


   Ta opcja może być użyta równolegle wraz z dowolnymi innymi opcjami jakie przekażesz, zarówno w postaci
   tablicy opcji jak i obiektu *Zend_Config*.

Z tego względu, że kolejność w jakiej rejestrowane są dekoratory ma znaczenie -- dekoratory są uruchamiane w
takiej kolejności w jakiej zostały zarejestrowane -- musisz się upewnić, że rejestrujesz je w odpowiedniej
kolejności lub użyć opcji pozwalającej na zarejestrowanie dekoratora w konkretnej pozycji. Poniżej jako
przykład został zamieszczony przykładowy kod, który rejestruje domyślne dekoratory:

.. code-block::
   :linenos:

   $this->addDecorators(array(
       array('ViewHelper'),
       array('Errors'),
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));


The initial content is created by the 'ViewHelper' decorator, which creates the form element itself. Next, the
'Errors' decorator fetches error messages from the element, and, if any are present, passes them to the
'FormErrors' view helper to render. The next decorator, 'HtmlTag', wraps the element and errors in an HTML <dd>
tag. Finally, the last decorator, 'label', retrieves the element's label and passes it to the 'FormLabel' view
helper, wrapping it in an HTML <dt> tag; the value is prepended to the content by default. The resulting output
looks basically like this:

.. code-block::
   :linenos:

   <dt><label for="foo" class="optional">Foo</label></dt>
   <dd>
       <input type="text" name="foo" id="foo" value="123" />
       <ul class="errors">
           <li>"123" is not an alphanumeric value</li>
       </ul>
   </dd>


Aby uzyskać więcej informacji o dekoratorach, zobacz :ref:`dokumentację klasy Zend\Form\Decorator
<zend.form.decorators>`.

.. note::

   **Użycie wielu dekoratorów tego samego typu**

   Internally, *Zend\Form\Element* uses a decorator's class as the lookup mechanism when retrieving decorators. As
   a result, you cannot register multiple decorators of the same type; subsequent decorators will simply overwrite
   those that existed before.

   To get around this, you can use **aliases**. Instead of passing a decorator or decorator name as the first
   argument to *addDecorator()*, pass an array with a single element, with the alias pointing to the decorator
   object or name:

   .. code-block::
      :linenos:

      // Alias dla 'FooBar':
      $element->addDecorator(array('FooBar' => 'HtmlTag'),
                             array('tag' => 'div'));

      // Pobieramy dekorator:
      $decorator = $element->getDecorator('FooBar');


   Do metod *addDecorators()* oraz *setDecorators()* musisz przekazać opcję 'decorator' znajdującą się w
   tablicy reprezentującej dekorator.

   .. code-block::
      :linenos:

      // Dodanie dwóch dekoratorów 'HtmlTag', ustawiając nazwę jednego z nich na 'FooBar':
      $element->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // I pobranie ich póżniej:
      $htmlTag = $element->getDecorator('HtmlTag');
      $fooBar  = $element->getDecorator('FooBar');


Metody powiązane z dekoratorami to:

- *addDecorator($nameOrDecorator, array $options = null)*

- *addDecorators(array $decorators)*

- *setDecorators(array $decorators)* (nadpisuje wszystkie dekoratory)

- *getDecorator($name)* (pobiera obiekt dekoratora)

- *getDecorators()* (pobiera wszystkie dekoratory)

- *removeDecorator($name)* (usuwa dekorator)

- *clearDecorators()* (usuwa wszystkie dekoratory)

.. _zend.form.elements.metadata:

Dane meta i atrybuty
--------------------

*Zend\Form\Element* obsługuje wiele atrybutów i danych meta dla elementów. Te atrybuty to:

- **name**: nazwa elementu. Używa metod dostępowych *setName()* oraz *getName()*.

- **label**: etykieta elementu. Używa metod dostępowych *setLabel()* oraz *getLabel()*.

- **order**: pozycja w której element ma być wstawiony w formularzu. Używa metod dostępowych *setOrder()* oraz
  *getOrder()*.

- **value**: obecna wartość elementu. Używa metod dostępowych *setValue()* oraz *getValue()*.

- **description**: opis elementu; zazwyczaj używane do utworzenia often used to provide tooltip or javascript
  contextual hinting describing the purpose of the element. Używa metod dostępowych *setDescription()* oraz
  *getDescription()*.

- **required**: flag indicating whether or not the element is required when performing form validation. Uses the
  *setRequired()* and *getRequired()* accessors. This flag is false by default.

- **allowEmpty**: flag indicating whether or not a non-required (optional) element should attempt to validate empty
  values. When true, and the required flag is false, empty values are not passed to the validator chain, and
  presumed true. Uses the *setAllowEmpty()* and *getAllowEmpty()* accessors. This flag is true by default.

- **autoInsertNotEmptyValidator**: flag indicating whether or not to insert a 'NotEmpty' validator when the element
  is required. By default, this flag is true. Set the flag with *setAutoInsertNotEmptyValidator($flag)* and
  determine the value with *autoInsertNotEmptyValidator()*.

Elementy formularzy mogą wymagać dodatkowych danych meta. Przykładowo dla elementów formularzy XHTML możesz
chcieć określić takie atrybuty jak 'class' czy 'id'. Do obsługi tego istnieje kilka metod dostępowych:

- **setAttrib($name, $value)**: dodaje atrybut

- **setAttribs(array $attribs)**: tak jak metoda addAttribs(), ale nadpisuje atrybuty

- **getAttrib($name)**: pobiera wartość jednego atrybutu

- **getAttribs()**: pobiera wszystkie atrybuty w postaci par klucz/wartość

Most of the time, however, you can simply access them as object properties, as *Zend\Form\Element* utilizes
overloading to facilitate access to them:

.. code-block::
   :linenos:

   // Odpowiednik metody $element->setAttrib('class', 'text'):
   $element->class = 'text;


By default, all attributes are passed to the view helper used by the element during rendering, and rendered as HTML
attributes of the element tag.

.. _zend.form.elements.standard:

Standardowe elementy
--------------------

Komponent *Zend_Form* posiada duży zestaw standardowych elementów; przeczytaj rozdział :ref:`Standardowe
Elementy <zend.form.standardElements>` aby poznać więcej szczegółów.

.. _zend.form.elements.methods:

Metody klasy Zend\Form\Element
------------------------------

Klasa *Zend\Form\Element* posiada bardzo dużo metod. Poniżej zamieszczono podsumowanie ich sygnatur,
pogrupowanych na podstawie typu:

- Konfiguracja:

  - *setOptions(array $options)*

  - *setConfig(Zend_Config $config)*

- I18N:

  - *setTranslator(Zend\Translator\Adapter $translator = null)*

  - *getTranslator()*

  - *setDisableTranslator($flag)*

  - *translatorIsDisabled()*

- Właściwości:

  - *setName($name)*

  - *getName()*

  - *setValue($value)*

  - *getValue()*

  - *getUnfilteredValue()*

  - *setLabel($label)*

  - *getLabel()*

  - *setDescription($description)*

  - *getDescription()*

  - *setOrder($order)*

  - *getOrder()*

  - *setRequired($flag)*

  - *getRequired()*

  - *setAllowEmpty($flag)*

  - *getAllowEmpty()*

  - *setAutoInsertNotEmptyValidator($flag)*

  - *autoInsertNotEmptyValidator()*

  - *setIgnore($flag)*

  - *getIgnore()*

  - *getType()*

  - *setAttrib($name, $value)*

  - *setAttribs(array $attribs)*

  - *getAttrib($name)*

  - *getAttribs()*

- Ładowanie wtyczek i ścieżki:

  - *setPluginLoader(Zend\Loader_PluginLoader\Interface $loader, $type)*

  - *getPluginLoader($type)*

  - *addPrefixPath($prefix, $path, $type = null)*

  - *addPrefixPaths(array $spec)*

- Weryfikacja:

  - *addValidator($validator, $breakChainOnFailure = false, $options = array())*

  - *addValidators(array $validators)*

  - *setValidators(array $validators)*

  - *getValidator($name)*

  - *getValidators()*

  - *removeValidator($name)*

  - *clearValidators()*

  - *isValid($value, $context = null)*

  - *getErrors()*

  - *getMessages()*

- Filtrowanie:

  - *addFilter($filter, $options = array())*

  - *addFilters(array $filters)*

  - *setFilters(array $filters)*

  - *getFilter($name)*

  - *getFilters()*

  - *removeFilter($name)*

  - *clearFilters()*

- Renderowanie:

  - *setView(Zend\View\Interface $view = null)*

  - *getView()*

  - *addDecorator($decorator, $options = null)*

  - *addDecorators(array $decorators)*

  - *setDecorators(array $decorators)*

  - *getDecorator($name)*

  - *getDecorators()*

  - *removeDecorator($name)*

  - *clearDecorators()*

  - *render(Zend\View\Interface $view = null)*

.. _zend.form.elements.config:

Konfiguracja
------------

Konstruktor klasy *Zend\Form\Element*\ przyjmuje w parametrze tablicę opcji lub obiekt *Zend_Config* zawierający
pcje. Klasa może być także skonfigurowana za pomocą metod *setOptions()* oraz *setConfig()*. Generalnie klucze
nazwane są w taki sposób:

- If 'set' + key refers to a *Zend\Form\Element* method, then the value provided will be passed to that method.

- Otherwise, the value will be used to set an attribute.

Oto wyjątki od tej zasady:

- *prefixPath* will be passed to *addPrefixPaths()*

- The following setters cannot be set in this way:

  - *setAttrib* (though *setAttribs* **will** work)

  - *setConfig*

  - *setOptions*

  - *setPluginLoader*

  - *setTranslator*

  - *setView*

As an example, here is a config file that passes configuration for every type of configurable data:

.. code-block::
   :linenos:

   [element]
   name = "foo"
   value = "foobar"
   label = "Foo:"
   order = 10
   required = true
   allowEmpty = false
   autoInsertNotEmptyValidator = true
   description = "Foo elements are for examples"
   ignore = false
   attribs.id = "foo"
   attribs.class = "element"
   ; ustawia atrybut 'onclick'
   onclick = "autoComplete(this, '/form/autocomplete/element')"
   prefixPaths.decorator.prefix = "My_Decorator"
   prefixPaths.decorator.path = "My/Decorator/"
   disableTranslator = 0
   validators.required.validator = "NotEmpty"
   validators.required.breakChainOnFailure = true
   validators.alpha.validator = "alpha"
   validators.regex.validator = "regex"
   validators.regex.options.pattern = "/^[A-F].*/$"
   filters.ucase.filter = "StringToUpper"
   decorators.element.decorator = "ViewHelper"
   decorators.element.options.helper = "FormText"
   decorators.label.decorator = "Label"


.. _zend.form.elements.custom:

Własne elementy
---------------

Możesz tworzyć własne elementy po prostu rozszerzając klasę *Zend\Form\Element*. Powodami aby to zrobić mogą
być:

- Elements that share common validators and/or filters

- Elements that have custom decorator functionality

There are two methods typically used to extend an element: *init()*, which can be used to add custom initialization
logic to your element, and *loadDefaultDecorators()*, which can be used to set a list of default decorators used by
your element.

As an example, let's say that all text elements in a form you are creating need to be filtered with *StringTrim*,
validated with a common regular expression, and that you want to use a custom decorator you've created for
displaying them, 'My_Decorator_TextItem'; additionally, you have a number of standard attributes, including 'size',
'maxLength', and 'class' you wish to specify. You could define such an element as follows:

.. code-block::
   :linenos:

   class My_Element_Text extends Zend\Form\Element
   {
       public function init()
       {
           $this->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator')
                ->addFilters('StringTrim')
                ->addValidator('Regex', false, array('/^[a-z0-9]{6,}$/i'))
                ->addDecorator('TextItem')
                ->setAttrib('size', 30)
                ->setAttrib('maxLength', 45)
                ->setAttrib('class', 'text');
       }
   }


You could then inform your form object about the prefix path for such elements, and start creating elements:

.. code-block::
   :linenos:
   <?php
   $form->addPrefixPath('My_Element', 'My/Element/', 'element')
        ->addElement('foo', 'text');


The 'foo' element will now be of type *My_Element_Text*, and exhibit the behaviour you've outlined.

Another method you may want to override when extending *Zend\Form\Element* is the *loadDefaultDecorators()* method.
This method conditionally loads a set of default decorators for your element; you may wish to substitute your own
decorators in your extending class:

.. code-block::
   :linenos:

   class My_Element_Text extends Zend\Form\Element
   {
       public function loadDefaultDecorators()
       {
           $this->addDecorator('ViewHelper')
                ->addDecorator('DisplayError')
                ->addDecorator('Label')
                ->addDecorator('HtmlTag',
                               array('tag' => 'div', 'class' => 'element'));
       }
   }


There are many ways to customize elements; be sure to read the API documentation of *Zend\Form\Element* to know all
the methods available.


