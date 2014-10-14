.. _introduction.installation:

************
Installation
************

.. _installation.composer:

Using Composer
----------------------------

The recommended way to start a new Zend Framework project is to clone the skeleton
application and use ``composer`` to install dependencies using the ``create-project``
command:

.. code-block:: text
   :linenos:

   curl -s https://getcomposer.org/installer | php --
   php composer.phar create-project -sdev --repository-url="https://packages.zendframework.com" zendframework/skeleton-application path/to/install

Alternately, clone the repository and manually invoke ``composer`` using the shipped
``composer.phar``:

.. code-block:: text
   :linenos:

   cd my/project/dir
   git clone git://github.com/zendframework/ZendSkeletonApplication.git
   cd ZendSkeletonApplication
   php composer.phar self-update
   php composer.phar install

(The ``self-update`` directive is to ensure you have an up-to-date ``composer.phar``
available.)

Another alternative for downloading the project is to grab it via `curl`, and
then pass it to `tar`:

.. code-block:: text
   :linenos:

   cd my/project/dir
   curl -#L https://github.com/zendframework/ZendSkeletonApplication/tarball/master | tar xz --strip-components=1

You would then invoke ``composer`` to install dependencies per the previous
example.

.. _installation.git.submodules:

Using Git submodules
--------------------
Alternatively, you can install using native git submodules:

.. code-block:: text
   :linenos:

   git clone git://github.com/zendframework/ZendSkeletonApplication.git --recursive

Web Server Setup
----------------

PHP CLI Server
^^^^^^^^^^^^^^

The simplest way to get started if you are using PHP 5.4 or above is to start the
internal PHP cli-server in the root directory:

.. code-block:: text
   :linenos:

   php -S 0.0.0.0:8080 -t public/ public/index.php

This will start the cli-server on port 8080, and bind it to all network
interfaces.

.. note::

   The built-in CLI server is *for development only*.

Apache Setup
^^^^^^^^^^^^

To use Apache, setup a virtual host to point to the ``public/`` directory of the
project. It should look something like below:

.. code-block:: text
   :linenos:

   <VirtualHost *:80>
      ServerName zf2-tutorial.localhost
      DocumentRoot /path/to/zf2-tutorial/public

      <Directory /path/to/zf2-tutorial/public>
          AllowOverride All
          Order allow,deny
          Allow from all
      </Directory>
   </VirtualHost>

or, if you are using Apache 2.4 or above:

.. code-block:: text
   :linenos:

   <VirtualHost *:80>
      ServerName zf2-tutorial.localhost
      DocumentRoot /path/to/zf2-tutorial/public

      <Directory /path/to/zf2-tutorial/public>
          AllowOverride All
          Require all granted
      </Directory>
   </VirtualHost>

.. _installation.rewrite.configuration:

Rewrite Configuration
,,,,,,,,,,,,,,,,,,,,,

*URL* rewriting is a common function of *HTTP* servers, and allows all HTTP requests to be routed through
the ``index.php`` entry point of a Zend Framework Application.

Apache comes bundled with the  module``mod_rewrite`` for URL rewriting. To use it, ``mod_rewrite`` must
either be included at compile time or enabled as a Dynamic Shared Object (*DSO*). Please consult the
`Apache documentation`_ for your version for more information.

The Zend Framework Skeleton Application comes with a ``.htaccess`` that includes rewrite rules to cover
most use cases:

.. code-block:: text
   :linenos:

   RewriteEngine On
   # The following rule tells Apache that if the requested filename
   # exists, simply serve it.
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]
   # The following rewrites all other queries to index.php. The
   # condition ensures that if you are using Apache aliases to do
   # mass virtual hosting, the base path will be prepended to
   # allow proper resolution of the index.php file; it will work
   # in non-aliased environments as well, providing a safe, one-size
   # fits all solution.
   RewriteCond %{REQUEST_URI}::$1 ^(/.+)(.+)::\2$
   RewriteRule ^(.*) - [E=BASE:%1]
   RewriteRule ^(.*)$ %{ENV:BASE}index.php [NC,L]

.. _installation.iis:

Microsoft Internet Information Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As of version 7.0, *IIS* ships with a standard rewrite engine. You may use the following configuration to
create the appropriate rewrite rules.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
       <system.webServer>
           <rewrite>
               <rules>
                   <rule name="Imported Rule 1" stopProcessing="true">
                       <match url="^.*$" />
                       <conditions logicalGrouping="MatchAny">
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsFile" pattern=""
                                ignoreCase="false" />
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsDirectory"
                                pattern=""
                                ignoreCase="false" />
                       </conditions>
                       <action type="None" />
                   </rule>
                   <rule name="Imported Rule 2" stopProcessing="true">
                       <match url="^.*$" />
                       <action type="Rewrite" url="index.php" />
                   </rule>
               </rules>
           </rewrite>
       </system.webServer>
   </configuration>

.. _`Apache documentation`: http://httpd.apache.org/docs/
