.. _zend.layout.options:

Zend_Layout options de configuration
====================================

``Zend_Layout`` possède quelques options. Vous pouvez les spécifier grâce à des accesseurs. Autrement, en
passant un tableau ou un objet ``Zend_Config`` au constructeur, ou à ``startMvc()``. Un tableau d'options peut
aussi être passé à ``setOptions()``, un objet ``Zend_Config`` peut être passé à ``setConfig()``. Les options
de configuration sont les suivantes :

- **layout**: le nom du script de layout. L'inflecteur traduit alors ceci en nom de fichier. Par défaut, il s'agit
  de "layout" traduit vers "layout.phtml". Les accesseurs sont ``setLayout()`` et ``getLayout()``.

- **layoutPath**: l'url de base vers les scripts de layout. Les accesseurs sont ``setLayoutPath()`` et
  ``getLayoutPath()``.

- **contentKey**: la variable de layout utilisée pour accéder au contenu par défaut (lorsqu'utilisée couplée
  avec *MVC*). La valeur par défaut est "content". Pour les accesseurs : ``setContentKey()`` et
  ``getContentKey()``.

- **mvcSuccessfulActionOnly**: si une action envoie une exception et que cette option vaut ``TRUE``, alors le
  layout ne sera pas rendu. (Ceci évite un double rendu alors que le plugin :ref:`ErrorHandler
  <zend.controller.plugins.standard.errorhandler>` est activé). Par défaut cette option est à ``TRUE``. Ses
  accesseurs : ``setMvcSuccessfulActionOnly()`` et ``getMvcSuccessfulActionOnly()``.

- **view**: l'objet de vue (``Zend_View``) utilisée par le layout pour rendre son script. Utilisé avec *MVC*,
  ``Zend_Layout`` cherchera à récupérer la vue via l'aide :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, si aucun objet de vue ne lui est passé explicitement. Les
  accesseurs sont ``setView()`` et ``getView()``.

- **helperClass**: la classe représentant l'aide d'action lorsque ``Zend_Layout`` est utilisé avec les composants
  *MVC*. Par défaut il s'agit de ``Zend_Layout_Controller_Action_Helper_Layout``. Les accesseurs sont
  ``setHelperClass()`` et ``getHelperClass()``.

- **pluginClass**: la classe représentant le plugin de contrôleur frontal lorsque ``Zend_Layout`` est utilisé
  avec les composants *MVC*. Par défaut, il s'agit de ``Zend_Layout_Controller_Plugin_Layout``. Les accesseurs
  sont ``setPluginClass()`` et ``getPluginClass()``.

- **inflector**: l'inflecteur utilisé pour la résolution des noms de layout vers les scripts de layout. Voyez
  :ref:`la documentation spécifique pour plus de détails <zend.layout.advanced.inflector>`. Les accesseurs sont
  ``setInflector()`` et ``getInflector()``.

.. note::

   **Vous devez passer les helperClass et pluginClass à startMvc()**

   Pour que les paramètres *helperClass* et *pluginClass* agissent, vous devez les passer en options à
   ``startMvc()``. Si vous les spécifiez après, ils seront ignorés.

.. _zend.layout.options.examples:

Exemples
--------

Les exemples sont basés sur les paramètres ``$options`` et ``$config`` suivants :

.. code-block:: php
   :linenos:

   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/chemin/vers/layouts',
       'contentKey' => 'CONTENT'
       // ignorés si MVC n'est pas utilisé
   );

.. code-block:: php
   :linenos:

   /**
   [layout]
   layout = "foo"
   layoutPath = "/chemin/vers/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/chemin/vers/layout.ini', 'layout');

.. _zend.layout.options.examples.constructor:

.. rubric:: Passer des options au constructeur ou à startMvc()

Le constructeur et la méthode statique ``startMvc()`` acceptent soit un tableau d'options, soit un objet
``Zend_Config``.

Voyons le cas du tableau :

.. code-block:: php
   :linenos:

   // Avec le constructeur :
   $layout = new Zend_Layout($options);

   // Avec startMvc():
   $layout = Zend_Layout::startMvc($options);

Et maintenant avec l'objet de configuration :

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/chemin/vers/layout.ini', 'layout');

   // Cas du constructeur:
   $layout = new Zend_Layout($config);

   // Via startMvc():
   $layout = Zend_Layout::startMvc($config);

C'est la manière la plus simple de configurer votre objet ``Zend_Layout``.

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: Utilisation de setOptions() et setConfig()

Pour configurer ``Zend_Layout`` après l'avoir instanciée, utilisez les méthodes ``setOptions()`` et
``setConfig()`` sur l'objet :

.. code-block:: php
   :linenos:

   // Utilisation d'un tableau d'options:
   $layout->setOptions($options);

   // Utilisation d'un objet Zend_Config:
   $layout->setConfig($options);

Notez cependant que certaines options comme *pluginClass* et *helperClass* n'auront aucun effet avec ses méthodes.
Elles doivent être passées au constructeur ou à la méthode ``startMvc()``.

.. _zend.layout.options.examples.accessors:

.. rubric:: Utilisation des accesseurs

Enfin, vous pouvez aussi configurer votre objet de ``Zend_Layout`` grâce à ses accesseurs. Ils peuvent s'utiliser
chaînés (interface fluide):

.. code-block:: php
   :linenos:

   $layout->setLayout('foo')
          ->setLayoutPath('/chemin/vers/layouts')
          ->setContentKey('CONTENT');


