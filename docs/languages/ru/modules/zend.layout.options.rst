.. _zend.layout.options:

Опции конфигурирования Zend_Layout
==================================

*Zend_Layout* имеет свой набор конфигурационных опций. Они могут
быть установлены путем вызова соответствующих аксессоров,
путем передачи массива или объекта *Zend_Config* конструктору или
методу *startMvc()*, передачей массива опций методу *setOptions()* или
передачей объекта *Zend_Config* методу *setConfig()*.

- **layout**: используемый макет. Использует текущий инфлектор для
  определения пути к скрипту макета, соответствующего данному
  имени макета. По умолчанию используется имя 'layout', и оно
  соответствует скрипту 'layout.phtml'. Аксессоры -*setLayout()* и *getLayout()*.

- **layoutPath**: базовый путь к скрипту макета. Аксессоры: *setLayoutPath()* и
  *getLayoutPath()*.

- **contentKey**: переменная макета, используемая для содержимого по
  умолчанию (при использовании с компонентами MVC). Значением по
  умолчанию является 'content'. Аксессоры -*setContentKey()* и *getContentKey()*.

- **mvcSuccessfulActionOnly**: действует при использовании с компонентами
  MVC. Если действие бросает исключение, и этот флаг установлен в
  true, то рендеринг макета не будет произведен (это сделано для
  предотвращения повторного рендеринга макета при
  использовании :ref:`плагина ErrorHandler <zend.controller.plugins.errorhandler>`). По
  умолчанию он установлен в true. Аксессоры -*setMvcSuccessfulActionOnly()* и
  *getMvcSuccessfulActionOnly()*.

- **view**: объект вида, используемый для рендеринга. При
  использовании с компонентами MVC *Zend_Layout* будет пытаться
  использовать объект вида, зарегистрированный в :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, если объект вида не был передан
  явным образом. Аксессоры -*setView()* и *getView()*.

- **helperClass**: класс помощника действия, применяемый при
  использовании *Zend_Layout* с компонентами MVC. По умолчанию это
  *Zend_Layout_Controller_Action_Helper_Layout*. Аксессоры -*setHelperClass()* и *getHelperClass()*.

- **pluginClass**: класс плагина фронт-контроллера, применяемый при
  использовании *Zend_Layout* с компонентами MVC. По умолчанию это
  *Zend_Layout_Controller_Plugin_Layout*. Аксессоры -*setPluginClass()* и *getPluginClass()*.

- **inflector**: инфлектор, используемый для определения путей к
  скрипту вида по имени макета, подробнее об этом читайте в
  :ref:`документации по инфлектору Zend_Layout <zend.layout.advanced.inflector>`.
  Аксессоры -*setInflector()* и *getInflector()*.

.. note::

   **helperClass и pluginClass должны передаваться startMvc()**

   Для того чтобы установка опций *helperClass* и *pluginClass* произвела
   нужный эффект, эти опции должны быть переданы методу *startMvc()*.
   Если они устанавливаются позже, то это не произведет нужного
   действия.

.. _zend.layout.options.examples:

Примеры
-------

Следующие примеры предполагают наличие следующих массива
опций и объекта конфигурации:

.. code-block:: php
   :linenos:

   <?php
   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/path/to/layouts',
       'contentKey' => 'CONTENT',  // игнорируется, если не используется MVC
   );
   ?>
.. code-block:: php
   :linenos:

   <?php
   /**
   [layout]
   layout = "foo"
   layoutPath = "/path/to/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');
   ?>
.. _zend.layout.options.examples.constructor:

.. rubric:: Передача опций конструктору или startMvc()

Как конструктор, так и статический метод *startMvc()* могут
принимать массив опций или объект *Zend_Config* с опциями для
конфигурирования экземпляра *Zend_Layout*.

Передача массива:

.. code-block:: php
   :linenos:

   <?php
   // Использование конструктора:
   $layout = new Zend_Layout($options);

   // Использование startMvc():
   $layout = Zend_Layout::startMvc($options);
   ?>
Использование объекта конфигурации:

.. code-block:: php
   :linenos:

   <?php
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

   // Использование конструктора:
   $layout = new Zend_Layout($config);

   // Использование startMvc():
   $layout = Zend_Layout::startMvc($config);
   ?>
Как правило, это наиболее легкий способ настройки экземпляра
*Zend_Layout*.

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: Использование setOption() и setConfig()

Иногда нужно сконфигурировать объект *Zend_Layout* после того, как
он уже был инстанцирован. Методы *setOptions()* и *setConfig()* позволяют
сделать это легко и быстро:

.. code-block:: php
   :linenos:

   <?php
   // Использование массива опций:
   $layout->setOptions($options);

   // Использование объекта Zend_Config:
   $layout->setConfig($options);
   ?>
Но следует иметь в виду, что некоторые опции, такие, как *pluginClass*
и *helperClass* не будут действовать, если были переданы с
использованием этих методов, их следует передавать
конструктору или методу *startMvc()*.

.. _zend.layout.options.examples.accessors:

.. rubric:: Использование аксессоров

И наконец, вы можете конфигурировать свой экземпляр с помощью
аксессоров. Все аксессоры реализуют fluent interface, это значит, что
их вызовы могут следовать непосредственно друг за другом:

.. code-block:: php
   :linenos:

   <?php
   $layout->setLayout('foo')
          ->setLayoutPath('/path/to/layouts')
          ->setContentKey('CONTENT');
   ?>

