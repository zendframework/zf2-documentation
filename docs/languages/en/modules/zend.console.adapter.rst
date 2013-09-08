.. _zend.console.adapter:

Console adapters
==================

Zend Framework 2 provides console abstraction layer, which works around various bugs and limitations in operating
systems. It handles displaying of colored text, retrieving console window size, charset and provides basic line
drawing capabilities.

.. seealso::

    Console Adapters can be used for a low-level access to the console. If you plan on building functional console
    applications you do not normally need to use adapters. Make sure to
    :doc:`read about console MVC integration first <zend.console.introduction>`, because it provides a convenient way
    for running modular console applications without directly writing to or reading from console window.


Retrieving console adapter
--------------------------

If you are using :doc:`MVC controllers <zend.mvc.controllers>` you can obtain Console adapter instance using
Service Manager.

.. code-block:: php
    :linenos:
    :emphasize-lines: 8

    namespace Application;
    
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\Console\Adapter\AdapterInterface as Console;
    use Zend\Console\Exception\RuntimeException;

    class ConsoleController extends AbstractActionController
    {
        public function testAction()
        {
            $console = $this->getServiceLocator()->get('console');
            if (!$console instanceof Console) {
                throw new RuntimeException('Cannot obtain console adapter. Are we running in a console?');
            }
        }
    }

If you are using ``Zend\Console`` without MVC, we can get adapter using the following code:

.. code-block:: php
    :linenos:
    :emphasize-lines: 5

    use Zend\Console\Console;
    use Zend\Console\Exception\RuntimeException as ConsoleException;

    try {
        $console = Console::getInstance();
    } catch (ConsoleException $e) {
        // Could not get console adapter - most likely we are not running inside a console window.
    }

.. note::

    For practical and security reasons, ``Console::getInstance()`` will always throw an exception if you attempt to
    get console instance in a non-console environment (i.e. when running on a HTTP server). You can override this
    behavior by manually instantiating one of ``Zend\Console\Adapter\*`` classes.


Using console adapter
-----------------------------

Window size and title
^^^^^^^^^^^^^^^^^^^^^

**$console->getWidth()**
    (`int`) Get real console window width in characters.

**$console->getHeight()**
    (`int`) Get real console window height in characters.

**$console->getSize()**
    (`array`) Get an ``array( $width, $height)`` with current console window dimensions.

**$console->getTitle()**
    (`string`) Get console window title.

.. note::

    For UTF-8 enabled consoles (terminals) dimensions represent the number of multibyte characters (real characters).

.. note::

    On consoles with virtual buffers (i.e. MS Windows Command Prompt) width and height represent visible (real) size,
    without scrolling the window. For example - if the window scrolling width is 120 chars, but it's real, visible width
    is 80 chars, ``getWidth()`` will return ``80``.

Character set
^^^^^^^^^^^^^

**$console->isUtf8()**
    (`boolean`) Is the console UTF-8 compatible (can display unicode strings) ?

**$console->getCharset()**
    (`Zend\\Console\\Charset\\CharsetInterface`) This method will return one of ``Console\Charset\*`` classes that represent
    the readable charset that can be used for line-drawing. It is automatically detected by the adapter.

Writing to console
^^^^^^^^^^^^^^^^^^^

**$console->write( string $text, $color = null, $bgColor = null )**
    Write a ``$text`` to the console, optionally using foreground ``$color`` and background ``$bgColor``.
    Color value is one of the constants in ``Zend\Console\ColorInterface``.

**$console->writeLine( string $text, $color = null, $bgColor = null )**
    Write a single line of ``$text`` to the console. This method will output a newline character at the end of text
    moving console cursor to next line.

**$console->writeAt( string $text, int $x, int $y, $color = null, $bgColor = null )**
    Write ``$text`` at the specified ``$x`` and ``$y`` coordinates of console window. Top left corner of the screen
    has coordinates of ``$x = 1; $x = 1``. To retrieve far-right and bottom coordinates, use ``getWidth()`` and
    ``getHeight()`` methods.


Reading from console
^^^^^^^^^^^^^^^^^^^^^^

**$console->readChar( string $mask = null )**
    (`string`) Read a single character from console. Optional ``(string) $mask`` can be provided to force entering only a
    selected set of characters. For example, to read a single digit, we can use the following syntax:
    ``$digit = $console->readChar('0123456789');``

**$console->readLine( int $maxLength = 2048 )**
    (`string`) Read a single line of input from console. Optional ``(int) $maxLength`` can be used to limit the length
    of data that will be read. The line will be returned **without ending newline character**.


Miscellaneous
^^^^^^^^^^^^^

**$console->hideCursor()**
    Hide blinking cursor from console.

**$console->showCursor()**
    Show blinking cursor in console.

**$console->clear()**
    Clear the screen.

**$console->clearLine()**
    Clear the line that the cursor currently sits at.


