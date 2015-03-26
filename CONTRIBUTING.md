# CONTRIBUTING

To contribute to the Zend Framework 2 documentation you can send us a
[pull request](https://help.github.com/articles/using-pull-requests) using GitHub, that's it!

If you are not familiar with github you can read the
[Zend Framework Git Guide](https://github.com/zendframework/zf2/blob/master/README-GIT.md)
using the repository `git://github.com/zendframework/zf2-documentation.git` instead of
`git://github.com/zendframework/zf2.git`.

We only ask you to use a couple of conventions:

 - If you want to propose a new doc we use the `feature/<doc>` branch name convention,
   where `<doc>` is the name of the document that you want to create;

 - To fix or update a document we use the `fix/<doc>` branch name convention,
   where `<doc>` is the name of the document that you want to fix or update;

## DOCUMENT FORMAT

The Zend Framework 2 documentation is written using the
[reStructuredText](http://en.wikipedia.org/wiki/ReStructuredText) format.

If you are not familiar with this format we suggest to have a look at this
[reStructuredText primer](http://sphinx.pocoo.org/rest.html).

To render the documentation we use the [Sphinx](http://sphinx.pocoo.org/) project. At the moment we support only
the **HTML** render format but we are going to support soon the **PDF** and **ePub** formats.

There is a soft limit on the max line length of 115 characters. It is recommended to keep this limit whenever
possible.

## RENDER THE DOCUMENTATION

In order to render the documentation you have to install [Sphinx](http://sphinx.pocoo.org/) version 1.1.0 or newer.
Sphinx requires Python and several Python libraries to run.

If your system already has a package with Sphinx, make sure that it is version 1.1 or higher. At the time of writing
this, Debian systems provide Sphinx version 0.6 or 1.0.8 and will refuse to work correctly with this documentation.

To install latest Sphinx on a Debian-based system, use the following commands:

    > apt-get install python-setuptools python-pygments
    > easy_install -U Sphinx
    > sphinx-build --version
      Sphinx v1.1.3
      Usage: /usr/local/bin/sphinx-build ....

To render the documentation in HTML format:

 1. Clone the [git repository](git://github.com/zendframework/zf2-documentation.git) or download and extract an
 archive with documentation.
 1. Enter the `docs/` subdirectory;
 1. Run `make html`

The HTML documentation will be generated in `docs/_build/html`.

After you've made changes to .rst files, you can run `make html` again to update HTML for changed pages.