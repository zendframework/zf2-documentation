
Zend_ProgressBar_Adapter_Console
================================

``Zend_ProgressBar_Adapter_Console`` is a text-based adapter for terminals. It can automatically detect terminal widths but supports custom widths as well. You can define which elements are displayed with the progressbar and as well customize the order of them. You can also define the style of the progressbar itself.

.. note::
    **Automatic console width recognition**

    shell_execis required for this feature to work on *nix based systems. On windows, there is always a fixed terminal width of 80 character, so no recognition is required there.

You can set the adapter options either via theset*methods or give an array or a ``Zend_Config`` instance with options as first parameter to the constructor. The available options are:


