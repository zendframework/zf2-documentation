# CONTRIBUTING

To contribute to the Zend Framework 2 documentation you can send us a *pull request*
using github, that's it!

If you are not familiar with github you can read the [Zend Framework Git Guide](http://framework.zend.com/wiki/display/ZFDEV2/Zend+Framework+Git+Guide)
using the repository https://github.com/zendframework/zf2-documentation instead of https://github.com/zendframework/zf2/.

We only ask you to use a couple of conventions:

 - if you want to propose a new doc we use the `feature/doc` branch name convention,
   where `doc` is the name of the document that you want to create;

 - to fix or update a document we use the `fix/doc` branch name convention.

If you want to work on a document in a language different from English, you have to
include the name of the language in the branch name.

For instance, if you want to propose a new document in Italian you have to use the
following naming convention: `feature/it/doc`, where `it` is Italian.
The same convention is applied on the fix or update: `fix/it/doc`.

You can find the supported languages in the `docs/languages` subdirectory.


## DOCUMENT FORMAT

The Zend Framework 2 documentation is written using the [reStructuredText](http://en.wikipedia.org/wiki/ReStructuredText) format.

If you are not familiar with this format we suggest to have a look at this [reStructuredText primer](http://sphinx.pocoo.org/rest.html).

To render the documentation we use the [Sphinx](http://sphinx.pocoo.org/) project. At the moment we support only
the **HTML** render format but we are going to support soon the **PDF** and **ePub** formats.


## RENDER THE DOCUMENTATION

In order to render the documentation you have to install [Sphinx](http://sphinx.pocoo.org/).

To render the documentation in HTML format:

 -  enter the `docs/` subdirectory;
 -  execute the `make html` command.

The documentation will be generated in the `_build/html` subdirectory.

By default, the `make html` command renders the documentation in English.
To render in a different language you have to specify the LANG in the command line. 

For instance, to render the documentation in Italian, execute the following command:

    ```sh
    % make html LANG=it
    ```

You can find the supported languages in the `docs/languages` subdirectory.
