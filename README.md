# Welcome to the *Zend Framework 2* documentation

## RELEASE INFORMATION

This documentation is based on *Zend Framework 2* (master branch)


## VIEW THE DOCUMENTATION ONLINE

We used the [readthedocs.org](http://readthedocs.org/) project to render online the development version of the
documentation of Zend Framework 2.

You can read the development online documentation in 
[http://zf2.readthedocs.org](http://zf2.readthedocs.org/en/latest/index.html).

You can read the last stable documentation in 
[http://packages.zendframework.com/docs/latest/manual/en/](http://packages.zendframework.com/docs/latest/manual/en/).

## BUILDING DOCUMENTATION

Building the documentation requires [Sphinx](http://sphinx-doc.org/). Further requirements are _Pygments_, _docutils_ and _markupsafe_, installable with `pip install`.

Descend into the `docs/` directory, and run `make` with one of the following
targets:

- `epub` - build epub (ebook) documentation (requires
  [Calibre](http://calibre-ebook.com/) to build cross-platform epub versions)
- `help` - build Windows help files
- `html` - build HTML documentation
- `info` - build Unix info pages
- `latexpdf` - build PDF documentation (requires a working `latex` toolchain)
- `man` - build Unix manpages
- `text` - build ANSI text manual files

Examples:

```sh
make html
```

You can cleanup by running `make clean`.

## CONTRIBUTING

If you wish to contribute to the documentation of Zend Framework 2, please read the
CONTRIBUTING.md file.

If you don't know where to begin, or where you can best help, please review the
TODO.md file.

## LICENSE

The files in this archive are released under the Zend Framework license.
You can find a copy of this license in LICENSE.txt.

## ACKNOWLEDGEMENTS

The Zend Framework team would like to thank all the [contributors](https://github.com/zendframework/zf2-documentation/contributors) to the Zend
Framework Documentation project, our corporate sponsor, and you, the Zend Framework user.
Please visit us sometime soon at http://framework.zend.com.
