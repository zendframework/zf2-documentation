.. _zend.progress-bar.adapter.console:

Console Adapter
^^^^^^^^^^^^^^^

``Zend\ProgressBar\Adapter\Console`` is a text-based adapter for terminals. It can automatically detect terminal
widths but supports custom widths as well. You can define which elements are displayed with the progressbar and as
well customize the order of them. You can also define the style of the progressbar itself.

.. note::

   **Automatic console width recognition**

   *shell_exec* is required for this feature to work on \*nix based systems. On windows, there is always a fixed
   terminal width of 80 character, so no recognition is required there.

You can set the adapter options either via the *set** methods or give an array or a ``Zend\Config\Config`` instance with
options as first parameter to the constructor. The available options are:

- *outputStream*: A different output-stream, if you don't want to stream to STDOUT. Can be any other stream like
  *php://stderr* or a path to a file.

- *width*: Either an integer or the ``AUTO`` constant of ``Zend\Console\ProgressBar``.

- *elements*: Either ``NULL`` for default or an array with at least one of the following constants of
  ``Zend\Console\ProgressBar`` as value:

  - ``ELEMENT_PERCENT``: The current value in percent.

  - ``ELEMENT_BAR``: The visual bar which display the percentage.

  - ``ELEMENT_ETA``: The automatic calculated ETA. This element is firstly displayed after five seconds, because in
    this time, it is not able to calculate accurate results.

  - ``ELEMENT_TEXT``: An optional status message about the current process.

- *textWidth*: Width in characters of the ``ELEMENT_TEXT`` element. Default is 20.

- *charset*: Charset of the ``ELEMENT_TEXT`` element. Default is utf-8.

- *barLeftChar*: A string which is used left-hand of the indicator in the progressbar.

- *barRightChar*: A string which is used right-hand of the indicator in the progressbar.

- *barIndicatorChar*: A string which is used for the indicator in the progressbar. This one can be empty.


