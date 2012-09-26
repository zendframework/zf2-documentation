TODO
====

The following is a list of documentation that needs work. If you plan to work on
a component, please drop a note to the ZF contributors mailing list
(http://framework.zend.com/archives/contributors) and/or
[the #zftalk.dev IRC channel](irc://irc.freenode.net/zftalk.dev).

Needs refactor from ZF1
-----------------------

The following documentation needs to be refactored from the ZF1 version.
Typically, this will mean updating class names to reference namespaced versions,
and potentially updating code samples to reflect any API changes.

- Dom
- Feed
- File
- Filter
- Json
- Markup (Note that this is now in its own repository, and the API may change in
  the future)
- Mime
- Navigation (Quickstart is missing, View helpers need to be revised, copy config [examples from ZF1](http://framework.zend.com/manual/1.12/en/zend.navigation.containers.html#zend.navigation.containers.creating))
- Paginator
- ProgressBar
- Serializer
- Server
- Soap
- Tag
- Text
- XmlRpc

New Components needing documentation
------------------------------------

The following are new components in need of documentation. In some cases, the
components existed previously, but have been rewritten.

- Escaper
- Math
- Session (Enrico Zimuel has begun this)
- Uri

Incomplete documentation
------------------------

The following documentation is incomplete. Typically, a quickstart and/or
example section is present, but full documentation is missing.

- Code
- Console (everything except Getopt is new in this component, and needs to be
  documented)
- Crypt
- Db
- Di
- EventManager
- I18n
- InputFilter
- Log
- Mail
- ServiceManager
- Stdlib
- View

Broken documentation
--------------------

The following documentation is complete, but is incorrect due to API changes
that happened before release. You will likely need to contact somebody in IRC or
on the mailing list to determine what needs to be fixed.

- Cache
- Http
- Loader
- ModuleManager
- Mvc
