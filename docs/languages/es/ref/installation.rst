.. _introduction.installation:

***********
Instalación
***********

Véase el apéndice :ref:`requisitos <requirements>` para una lista detallada de requisitos para Zend Framework.

La instalación del Zend Framework es muy simple. Una vez que haya descargado y descomprimido el framework, deberá
añadir la carpeta ``/library`` de la distribución al principio de su "include path". También puede mover la
carpeta "library" a cualquier otra posición (compartida o no) de su sistema de archivos.

- `Descargar la última versión estable.`_ Esta versión esta disponible en formatos ``.zip``. ``.tar.gz``, es una
  buena opción para aquellos que comienzan o son nuevos en Zend Framework.

- `Download the latest nightly snapshot.`_ For those who would brave the cutting edge, the nightly snapshots
  represent the latest progress of Zend Framework development. Snapshots are bundled with documentation either in
  English only or in all available languages. If you anticipate working with the latest Zend Framework
  developments, consider using a Subversion (*SVN*) client.

- Using a `Subversion`_ (*SVN*) client. Zend Framework is open source software, and the Subversion repository used
  for its development is publicly available. Consider using *SVN* to get Zend Framework if you already use *SVN*
  for your application development, want to contribute back to the framework, or need to upgrade your framework
  version more often than releases occur.

  `Exporting`_ is useful if you want to get a particular framework revision without the ``.svn`` directories as
  created in a working copy.

  `Check out a working copy`_ if you want contribute to Zend Framework, a working copy can be updated any time with
  `svn update`_ and changes can be commited to our *SVN* repository with the `svn commit`_ command.

  An `externals definition`_ is quite convenient for developers already using *SVN* to manage their application's
  working copies.

  The *URL* for the trunk of Zend Framework's *SVN* repository is:
  `http://framework.zend.com/svn/framework/standard/trunk`_

Una vez que tenga disponible una copia de Zend Framework, su aplicación necesita poder acceder a las clases del
framework. Aunque hay `diferentes maneras de lograr esto`_, su `include_path`_ de *PHP* necesita contener una ruta
a la librería de Zend Framework.

Zend provides a `QuickStart`_ to get you up and running as quickly as possible. This is an excellent way to begin
learning about the framework with an emphasis on real world examples that you can built upon.

Ya que los componentes de Zend Framework están débilmente conectados, tiene la opción de usar cualquier
combinación de ellos en sus aplicaciones. Los siguientes capítulos presentan una referencia exhaustiva de Zend
Framework, componente a componente.



.. _`Descargar la última versión estable.`: http://framework.zend.com/download
.. _`Download the latest nightly snapshot.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Exporting`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Check out a working copy`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`externals definition`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`diferentes maneras de lograr esto`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`QuickStart`: http://framework.zend.com/docs/quickstart
