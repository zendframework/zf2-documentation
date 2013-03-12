TODO
====

The ZF2 documentation has its roots in the ZF1 documentation. Therefore, some sections are outdated, some are missing,
and some are just plain wrong. The following is the list of documentation sections that need work.
Everyone is welcome to fork and edit the documentation, but if you plan to seriously work on a component,
please first drop a note to the ZF contributors mailing list (http://framework.zend.com/archives/contributors)
and/or to the [#zftalk.dev IRC channel](irc://irc.freenode.net/zftalk.dev).

Alternatively, some issues are reported to the
[documentation issue tracker](https://github.com/zendframework/zf2-documentation/pull/714/files), if you're looking
for issues to fix, you can pick an issue there as well.

Components that need refactoring
--------------------------------

The following documentation sections need to be refactored from the ZF1 docs.
Typically, this will mean updating class names to reference namespaced versions,
and potentially updating code samples to reflect any API changes.

- Dom  (Lead: Matthew Weier O'Phinney (weierophinney))
- File (Lead: Chris Martin (cgmartin))
- Json (Lead: Matthew Weier O'Phinney (weierophinney)); work begun by Robert Basic (robertbasic))
- Markup (Note that this is now in its own repository, and the API may change in
  the future)
- Navigation (Lead: Kyle Spraggs (spiffyjr))
- Paginator (Lead: Matthew Weier O'Phinney (weierophinney))
- ProgressBar (Lead: Ben Scholzen (DASPRiD))
- Serializer (Lead: Marc Bennewitz (marc-mabe))

New Components with no documentation
------------------------------------

The following are new components in need of documentation. In some cases, the
components existed previously, but have been rewritten.

- Escaper (Lead: Pádraic Brady (PadraicB))
- Math (Lead: Enrico Zimuel (ezimuel))
- Session (Enrico Zimuel has begun this)
- Uri (Lead: Shahar Evron (shahar))

Incomplete documentation
------------------------

The following documentation sections are incomplete. Typically, a quickstart and/or
example section is present, but full documentation is missing.

- Code (Lead: Ralph Schindler (ralphschindler))
- Console (Needs quickstart and examples) (Lead: Artur Bodera (ThinkScape);
  work begun by weierophinney)
- Crypt (Lead: Enrico Zimuel (ezimuel))
- Db (Lead: Ralph Schindler (ralphschindler))
- Di (Lead: Ralph Schindler (ralphschindler))
- EventManager (Lead: Matthew Weier O'Phinney (weierophinney))
- Form (Lead: Chris Martin (cgmartin) and Michael Gallego (Bakura))
- I18n (Lead: Ben Scholzen (DASPRiD))
- InputFilter (Lead: Matthew Weier O'Phinney (weierophinney))
- Log (Lead: Enrico Zimuel (ezimuel))
- Mail (Lead: Dolf Schimmel (Freeaqingme))
- ServiceManager (Lead: Ralph Schindler (ralphschindler))
- Stdlib (Lead: Matthew Weier O'Phinney (weierophinney))

Broken documentation
--------------------

The following documentation sections are complete, but incorrect, due to API changes
that happened before release. You will likely need to contact somebody in IRC or
on the mailing list to determine what needs to be fixed.

- Cache (Lead: Marc Bennewitz (marc-mabe))
- Http (Lead: Dolf Schimmel (Freeaqingme)); work begun by Adam Lundrigan (adamlundrigan)
- Loader (Lead: Matthew Weier O'Phinney (weierophinney))
- ModuleManager (Lead: Evan Coury (EvanDotPro))
- Mvc (Lead: Matthew Weier O'Phinney (weierophinney))
- View (Lead: Matthew Weier O'Phinney (weierophinney))
- Learning Dependency Injection
