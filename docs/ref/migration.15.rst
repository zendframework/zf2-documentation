.. _migration.15:

Zend Framework 1.5
==================

When upgrading from a previous release to Zend Framework 1.5 or higher you should note the following migration
notes.

.. _migration.15.zend.controller:

Zend_Controller
---------------

Though most basic functionality remains the same, and all documented functionality remains the same, there is one
particular **undocumented**"feature" that has changed.

When writing *URL*\ s, the documented way to write camelCased action names is to use a word separator; these are
'.' or '-' by default, but may be configured in the dispatcher. The dispatcher internally lowercases the action
name, and uses these word separators to re-assemble the action method using camelCasing. However, because *PHP*
functions are not case sensitive, you **could** still write *URL*\ s using camelCasing, and the dispatcher would
resolve these to the same location. For example, 'camel-cased' would become 'camelCasedAction' by the dispatcher,
whereas 'camelCased' would become 'camelcasedAction'; however, due to the case insensitivity of *PHP*, both will
execute the same method.

This causes issues with the ViewRenderer when resolving view scripts. The canonical, documented way is that all
word separators are converted to dashes, and the words lowercased. This creates a semantic tie between the actions
and view scripts, and the normalization ensures that the scripts can be found. However, if the action 'camelCased'
is called and actually resolves, the word separator is no longer present, and the ViewRenderer attempts to resolve
to a different location --``camelcased.phtml`` instead of ``camel-cased.phtml``.

Some developers relied on this "feature", which was never intended. Several changes in the 1.5.0 tree, however,
made it so that the ViewRenderer no longer resolves these paths; the semantic tie is now enforced. First among
these, the dispatcher now enforces case sensitivity in action names. What this means is that referring to your
actions on the url using camelCasing will no longer resolve to the same method as using word separators (i.e.,
'camel-casing'). This leads to the ViewRenderer now only honoring the word-separated actions when resolving view
scripts.

If you find that you were relying on this "feature", you have several options:

- Best option: rename your view scripts. Pros: forward compatibility. Cons: if you have many view scripts that
  relied on the former, unintended behavior, you will have a lot of renaming to do.

- Second best option: The ViewRenderer now delegates view script resolution to ``Zend_Filter_Inflector``; you can
  modify the rules of the inflector to no longer separate the words of an action with a dash:

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
     $inflector = $viewRenderer->getInflector();
     $inflector->setFilterRule(':action', array(
         new Zend_Filter_PregReplace(
             '#[^a-z0-9' . preg_quote(DIRECTORY_SEPARATOR, '#') . ']+#i',
             ''
         ),
         'StringToLower'
     ));

  The above code will modify the inflector to no longer separate the words with dash; you may also want to remove
  the 'StringToLower' filter if you **do** want the actual view script names camelCased as well.

  If renaming your view scripts would be too tedious or time consuming, this is your best option until you can find
  the time to do so.

- Least desirable option: You can force the dispatcher to dispatch camelCased action names with a new front
  controller flag, ``useCaseSensitiveActions``:

  .. code-block:: php
     :linenos:

     $front->setParam('useCaseSensitiveActions', true);

  This will allow you to use camelCasing on the url and still have it resolve to the same action as when you use
  word separators. However, this will mean that the original issues will cascade on through; you will likely need
  to use the second option above in addition to this for things to work at all reliably.

  Note, also, that usage of this flag will raise a notice that this usage is deprecated.


