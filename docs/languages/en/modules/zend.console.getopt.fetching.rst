.. _zend.console.getopt.fetching:

Fetching Options and Arguments
==============================

After you have declared the options that the ``Zend\Console\Getopt`` object should recognize, and supply arguments
from the command-line or an array, you can query the object to find out which options were specified by a user in a
given command-line invocation of your program. The class implements magic methods so you can query for options by
name.

The parsing of the data is deferred until the first query you make against the ``Zend\Console\Getopt`` object to
find out if an option was given, the object performs its parsing. This allows you to use several method calls to
configure the options, arguments, help strings, and configuration options before parsing takes place.

.. _zend.console.getopt.fetching.exceptions:

Handling Getopt Exceptions
--------------------------

If the user gave any invalid options on the command-line, the parsing function throws a
``Zend\Console\Exception\RuntimeException``. You should catch this exception in your application code. You can use the
``parse()`` method to force the object to parse the arguments. This is useful because you can invoke ``parse()`` in
a **try** block. If it passes, you can be sure that the parsing won't throw an exception again. The exception
thrown has a custom method ``getUsageMessage()``, which returns as a string the formatted set of usage messages for
all declared options.

.. _zend.console.getopt.fetching.exceptions.example:

Catching Getopt Exceptions
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   try {
       $opts = new Zend\Console\Getopt('abp:');
       $opts->parse();
   } catch (Zend\Console\Exception\RuntimeException $e) {
       echo $e->getUsageMessage();
       exit;
   }

Cases where parsing throws an exception include:

- Option given is not recognized.

- Option requires a parameter but none was given.

- Option parameter is of the wrong type. E.g. a non-numeric string when an integer was required.

.. _zend.console.getopt.fetching.byname:

Fetching Options by Name
------------------------

You can use the ``getOption()`` method to query the value of an option. If the option had a parameter, this method
returns the value of the parameter. If the option had no parameter but the user did specify it on the command-line,
the method returns ``TRUE``. Otherwise the method returns ``NULL``.

.. _zend.console.getopt.fetching.byname.example.setoption:

Using getOption()
^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $b = $opts->getOption('b');
   $p_parameter = $opts->getOption('p');

Alternatively, you can use the magic ``__get()`` function to retrieve the value of an option as if it were a class
member variable. The ``__isset()`` magic method is also implemented.

.. _zend.console.getopt.fetching.byname.example.magic:

Using \__get() and \__isset() Magic Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   if (isset($opts->b)) {
       echo "I got the b option.\n";
   }
   $p_parameter = $opts->p; // null if not set

If your options are declared with aliases, you may use any of the aliases for an option in the methods above.

.. _zend.console.getopt.fetching.reporting:

Reporting Options
-----------------

There are several methods to report the full set of options given by the user on the current command-line.

- As a string: use the ``toString()`` method. The options are returned as a space-separated string of
  ``flag=value`` pairs. The value of an option that does not have a parameter is the literal string "``TRUE``".

- As an array: use the ``toArray()`` method. The options are returned in a simple integer-indexed array of strings,
  the flag strings followed by parameter strings, if any.

- As a string containing *JSON* data: use the ``toJson()`` method.

- As a string containing *XML* data: use the ``toXml()`` method.

In all of the above dumping methods, the flag string is the first string in the corresponding list of aliases. For
example, if the option aliases were declared like ``verbose|v``, then the first string, ``verbose``, is used as the
canonical name of the option. The name of the option flag does not include any preceding dashes.

.. _zend.console.getopt.fetching.remainingargs:

Fetching Non-option Arguments
-----------------------------

After option arguments and their parameters have been parsed from the command-line, there may be additional
arguments remaining. You can query these arguments using the ``getRemainingArgs()`` method. This method returns an
array of the strings that were not part of any options.

.. _zend.console.getopt.fetching.remainingargs.example:

Using getRemainingArgs()
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setArguments(array('-p', 'p_parameter', 'filename'));
   $args = $opts->getRemainingArgs(); // returns array('filename')

``Zend\Console\Getopt`` supports the *GNU* convention that an argument consisting of a double-dash signifies the
end of options. Any arguments following this signifier must be treated as non-option arguments. This is useful if
you might have a non-option argument that begins with a dash. For example: "``rm -- -filename-with-dash``".


