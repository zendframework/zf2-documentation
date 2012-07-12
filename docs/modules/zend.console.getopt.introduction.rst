
Introduction
============

The ``Zend_Console_Getopt`` class helps command-line applications to parse their options and arguments.

Users may specify command-line arguments when they execute your application. These arguments have meaning to the application, to change the behavior in some way, or choose resources, or specify parameters. Many options have developed customary meaning, for example ``--verbose`` enables extra output from many applications. Other options may have a meaning that is different for each application. For example, ``-c`` enables different features in ``grep`` , ``ls`` , and ``tar`` .

Below are a few definitions of terms. Common usage of the terms varies, but this documentation will use the definitions below.

For example, in ``mysql --user=root mydatabase`` , ``mysql`` is acommand, ``--user=root`` is anoption, ``--user`` is aflag, ``root`` is aparameterto the option, and ``mydatabase`` is an argument but not an option by our definition.

``Zend_Console_Getopt`` provides an interface to declare which flags are valid for your application, output an error and usage message if they use an invalid flag, and report to your application code which flags the user specified.

.. note::
    **Getopt is not an Application Framework**

     ``Zend_Console_Getopt`` doesnotinterpret the meaning of flags and parameters, nor does this class implement application workflow or invoke application code. You must implement those actions in your own application code. You can use the ``Zend_Console_Getopt`` class to parse the command-line and provide object-oriented methods for querying which options were given by a user, but code to use this information to invoke parts of your application should be in another *PHP* class.

The following sections describe usage of ``Zend_Console_Getopt`` .


