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

If you want to work on a document in a language different from English, please
include the name of the language in the branch name.

For instance, if you want to propose a new document in Italian you have to use the
following naming convention: `feature/it/<doc>`, where `it` is Italian.
The same convention is applied on the fix or update: `fix/it/<doc>`.

You can find the supported languages in the `docs/languages` subdirectory.


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

By default, the `make html` command renders the documentation in English.
To render in a different language you have to specify the LANG in the command line.

For instance, to render the documentation in Italian (`it`), execute the following command:

    make html LANG=it

You can find the supported languages in the `docs/languages` subdirectory.

After you've made changes to .rst files, you can run `make html` again to update HTML for changed pages.

## TRANSLATION

If you want to begin a new translation, you need to create a new subdirectory in the 'docs/languages' directory.
The name of the directory must be the [ISO 639-1 code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
for your language.

The compilation process takes all English files in the directory 'docs/languages/en' and overwrites them with those
in your language directory if it exists with the same filename in the same tree. If you want to translate a file,
copy the English file to your directory and start the translation. When the translation is completed, you have
to add a revcheck tag like '.. EN-Revision: 1a526e4' at the top of the file. '1a526e4' are the 7 first characters
of the English commit on which your translation is based. This helps the maintainer of the translation to know if
there exist one or multiple modifications of the English file that need to be added to the translation.

All revcheck tags have been initialized to 'none'. This indicates to all maintainers of translations that it needs
at least one review of the file after the automatic migration from ZF1 (Docbook to reST). We will provide in a
next future a visual tool for translators to be able to detect non-translated files or outdated files (based on
the revcheck tag).

In this philosophy, you can translate an image if you want. But there are 2 specific files at the
root of the English directory that you must not translate:
 - 'index.rst'
 - 'snippets.rst'

All sentences in these files that need a translation are handled by the reST substitution syntax. You can find them
in the 'translated-snippets.rst' file.
