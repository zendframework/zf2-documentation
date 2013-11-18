.. _zendpdf.interactive-features:

Interactive Features
====================

.. _zendpdf.pages.interactive-features.destinations:

Destinations
------------

A destination defines a particular view of a document, consisting of the following items:

- The page of the document to be displayed.

- The location of the document window on that page.

- The magnification (zoom) factor to use when displaying the page.

Destinations may be associated with outline items (:ref:`Document Outline (bookmarks)
<zendpdf.pages.interactive-features.outlines>`), annotations (:ref:`Annotations
<zendpdf.pages.interactive-features.annotations>`), or actions (:ref:`Actions
<zendpdf.pages.interactive-features.actions>`). In each case, the destination specifies the view of the document
to be presented when the outline item or annotation is opened or the action is performed. In addition, the optional
document open action can be specified.

.. _zendpdf.pages.interactive-features.destinations.types:

Supported Destination Types
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following types are supported by ``ZendPdf`` component.

.. _zendpdf.pages.interactive-features.destinations.types.zoom:

ZendPdf\Destination\Zoom
^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the coordinates (left, top) positioned at the upper-left corner of the window and
the contents of the page magnified by the factor zoom.

Destination object may be created using ``ZendPdf\Destination\Zoom::create($page, $left = null, $top = null, $zoom
= null)`` method.

Where:

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$left`` is a left edge of the displayed page (float).

- ``$top`` is a top edge of the displayed page (float).

- ``$zoom`` is a zoom factor (float).

``NULL``, specified for ``$left``, ``$top`` or ``$zoom`` parameter means "current viewer application value".

``ZendPdf\Destination\Zoom`` class also provides the following methods:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

- ``Float`` ``getZoomFactor()``;

- ``setZoomFactor(float $zoom)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit:

ZendPdf\Destination\Fit
^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the coordinates (left, top) positioned at the upper-left corner of the window and
the contents of the page magnified by the factor zoom. Display the specified page, with its contents magnified just
enough to fit the entire page within the window both horizontally and vertically. If the required horizontal and
vertical magnification factors are different, use the smaller of the two, centering the page within the window in
the other dimension.

Destination object may be created using ``ZendPdf\Destination\Fit::create($page)`` method.

Where ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

.. _zendpdf.pages.interactive-features.destinations.types.fit-horizontally:

ZendPdf\Destination\FitHorizontally
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the vertical coordinate top positioned at the top edge of the window and the
contents of the page magnified just enough to fit the entire width of the page within the window.

Destination object may be created using ``ZendPdf\Destination\FitHorizontally::create($page, $top)`` method.

Where:

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$top`` is a top edge of the displayed page (float).

``ZendPdf\Destination\FitHorizontally`` class also provides the following methods:

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-vertically:

ZendPdf\Destination\FitVertically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the horizontal coordinate left positioned at the left edge of the window and the
contents of the page magnified just enough to fit the entire height of the page within the window.

Destination object may be created using ``ZendPdf\Destination\FitVertically::create($page, $left)`` method.

Where:

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$left`` is a left edge of the displayed page (float).

``ZendPdf\Destination\FitVertically`` class also provides the following methods:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-rectangle:

ZendPdf\Destination\FitRectangle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with its contents magnified just enough to fit the rectangle specified by the
coordinates left, bottom, right, and top entirely within the window both horizontally and vertically. If the
required horizontal and vertical magnification factors are different, use the smaller of the two, centering the
rectangle within the window in the other dimension.

Destination object may be created using ``ZendPdf\Destination\FitRectangle::create($page, $left, $bottom, $right,
$top)`` method.

Where:

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$left`` is a left edge of the displayed page (float).

- ``$bottom`` is a bottom edge of the displayed page (float).

- ``$right`` is a right edge of the displayed page (float).

- ``$top`` is a top edge of the displayed page (float).

``ZendPdf\Destination\FitRectangle`` class also provides the following methods:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

- ``Float`` ``getBottomEdge()``;

- ``setBottomEdge(float $bottom)``;

- ``Float`` ``getRightEdge()``;

- ``setRightEdge(float $right)``;

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box:

ZendPdf\Destination\FitBoundingBox
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with its contents magnified just enough to fit its bounding box entirely within the
window both horizontally and vertically. If the required horizontal and vertical magnification factors are
different, use the smaller of the two, centering the bounding box within the window in the other dimension.

Destination object may be created using ``ZendPdf\Destination\FitBoundingBox::create($page, $left, $bottom,
$right, $top)`` method.

Where ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box-horizontally:

ZendPdf\Destination\FitBoundingBoxHorizontally
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the vertical coordinate top positioned at the top edge of the window and the
contents of the page magnified just enough to fit the entire width of its bounding box within the window.

Destination object may be created using ``ZendPdf\Destination\FitBoundingBoxHorizontally::create($page, $top)``
method.

Where

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$top`` is a top edge of the displayed page (float).

``ZendPdf\Destination\FitBoundingBoxHorizontally`` class also provides the following methods:

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box-vertically:

ZendPdf\Destination\FitBoundingBoxVertically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Display the specified page, with the horizontal coordinate left positioned at the left edge of the window and the
contents of the page magnified just enough to fit the entire height of its bounding box within the window.

Destination object may be created using ``ZendPdf\Destination\FitBoundingBoxVertically::create($page, $left)``
method.

Where

- ``$page`` is a destination page (a ``ZendPdf\Page`` object or a page number).

- ``$left`` is a left edge of the displayed page (float).

``ZendPdf\Destination\FitBoundingBoxVertically`` class also provides the following methods:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

.. _zendpdf.pages.interactive-features.destinations.types.named:

ZendPdf\Destination\Named
^^^^^^^^^^^^^^^^^^^^^^^^^^

All destinations listed above are "Explicit Destinations".

In addition to this, *PDF* document may contain a dictionary of such destinations which may be used to reference
from outside the *PDF* (e.g. '``http://www.mycompany.com/document.pdf#chapter3``').

``ZendPdf\Destination\Named`` objects allow to refer destinations from the document named destinations dictionary.

Named destination object may be created using ``ZendPdf\Destination\Named::create(string $name)`` method.

``ZendPdf\Destination\Named`` class provides the only one additional method:

``String`` ``getName()``;

.. _zendpdf.pages.interactive-features.destinations.processing:

Document level destination processing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendPdf\PdfDocument`` class provides a set of destinations processing methods.

Each destination object (including named destinations) can be resolved using the
``resolveDestination($destination)`` method. It returns corresponding ``ZendPdf\Page`` object, if destination
target is found, or ``NULL`` otherwise.

``ZendPdf\PdfDocument::resolveDestination()`` method also takes an optional boolean parameter
``$refreshPageCollectionHashes``, which is ``TRUE`` by default. It forces ``ZendPdf\PdfDocument`` object to refresh internal
page collection hashes since document pages list may be updated by user using ``ZendPdf\PdfDocument::$pages`` property
(:ref:`Working with Pages <zendpdf.pages>`). It may be turned off for performance reasons, if it's known that
document pages list wasn't changed since last method request.

Complete list of named destinations can be retrieved using ``ZendPdf\PdfDocument::getNamedDestinations()`` method. It returns
an array of ``ZendPdf\Target`` objects, which are actually either an explicit destination or a GoTo action
(:ref:`Actions <zendpdf.pages.interactive-features.actions>`).

``ZendPdf\PdfDocument::getNamedDestination(string $name)`` method returns specified named destination (an explicit destination
or a GoTo action).

*PDF* document named destinations dictionary may be updated with ``ZendPdf\PdfDocument::setNamedDestination(string $name,
$destination)`` method, where ``$destination`` is either an explicit destination (any destination except
``ZendPdf\Destination\Named``) or a GoTo action.

If ``NULL`` is specified in place of ``$destination``, then specified named destination is removed.

.. note::

   Unresolvable named destinations are automatically removed from a document while document saving.

.. _zendpdf.interactive-features.destinations.example-1:

.. rubric:: Destinations usage example

.. code-block:: php
   :linenos:

   $pdf = new ZendPdf\PdfDocument();
   $page1 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page2 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page3 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   // Page created, but not included into pages list

   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;

   $destination1 = ZendPdf\Destination\Fit::create($page2);
   $destination2 = ZendPdf\Destination\Fit::create($page3);

   // Returns $page2 object
   $page = $pdf->resolveDestination($destination1);

   // Returns null, page 3 is not included into document yet
   $page = $pdf->resolveDestination($destination2);

   $pdf->setNamedDestination('Page2', $destination1);
   $pdf->setNamedDestination('Page3', $destination2);

   // Returns $destination2
   $destination = $pdf->getNamedDestination('Page3');

   // Returns $destination1
   $pdf->resolveDestination(ZendPdf\Destination\Named::create('Page2'));

   // Returns null, page 3 is not included into document yet
   $pdf->resolveDestination(ZendPdf\Destination\Named::create('Page3'));

.. _zendpdf.pages.interactive-features.actions:

Actions
-------

Instead of simply jumping to a destination in the document, an annotation or outline item can specify an action for
the viewer application to perform, such as launching an application, playing a sound, or changing an annotation's
appearance state.

.. _zendpdf.pages.interactive-features.actions.types:

Supported action types
^^^^^^^^^^^^^^^^^^^^^^

The following action types are recognized while loading *PDF* document:

- ``ZendPdf\Action\GoTo``- go to a destination in the current document.

- ``ZendPdf\Action\GoToR``- go to a destination in another document.

- ``ZendPdf\Action\GoToE``- go to a destination in an embedded file.

- ``ZendPdf\Action\Launch``- launch an application or open or print a document.

- ``ZendPdf\Action\Thread``- begin reading an article thread.

- ``ZendPdf\Action\URI``- resolve a *URI*.

- ``ZendPdf\Action\Sound``- play a sound.

- ``ZendPdf\Action\Movie``- play a movie.

- ``ZendPdf\Action\Hide``- hides or shows one or more annotations on the screen.

- ``ZendPdf\Action\Named``- execute an action predefined by the viewer application:

  - **NextPage**- Go to the next page of the document.

  - **PrevPage**- Go to the previous page of the document.

  - **FirstPage**- Go to the first page of the document.

  - **LastPage**- Go to the last page of the document.

- ``ZendPdf\Action\SubmitForm``- send data to a uniform resource locator.

- ``ZendPdf\Action\ResetForm``- set fields to their default values.

- ``ZendPdf\Action\ImportData``- import field values from a file.

- ``ZendPdf\Action\JavaScript``- execute a JavaScript script.

- ``ZendPdf\Action\SetOCGState``- set the state of one or more optional content groups.

- ``ZendPdf\Action\Rendition``- control the playing of multimedia content (begin, stop, pause, or resume a playing
  rendition).

- ``ZendPdf\Action\Trans``- update the display of a document, using a transition dictionary.

- ``ZendPdf\Action\GoTo3DView``- set the current view of a 3D annotation.

Only ``ZendPdf\Action\GoTo`` and ``ZendPdf\Action\URI`` actions can be created by user now.

GoTo action object can be created using ``ZendPdf\Action\GoTo::create($destination)`` method, where
``$destination`` is a ``ZendPdf\Destination`` object or a string which can be used to identify named destination.

``ZendPdf\Action\URI::create($uri[, $isMap])`` method has to be used to create a URI action (see *API*
documentation for the details). Optional ``$isMap`` parameter is set to ``FALSE`` by default.

It also supports the following methods:

.. _zendpdf.pages.interactive-features.actions.chaining:

Actions chaining
^^^^^^^^^^^^^^^^

Actions objects can be chained using ``ZendPdf\Action::$next`` public property.

It's an array of ``ZendPdf\Action`` objects, which also may have their sub-actions.

``ZendPdf\Action`` class supports RecursiveIterator interface, so child actions may be iterated recursively:

.. code-block:: php
   :linenos:

   $pdf = new ZendPdf\PdfDocument();
   $page1 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page2 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   // Page created, but not included into pages list
   $page3 = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;

   $action1 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Fit::create($page2));
   $action2 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Fit::create($page3));
   $action3 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Named::create('Chapter1'));
   $action4 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Named::create('Chapter5'));

   $action2->next[] = $action3;
   $action2->next[] = $action4;

   $action1->next[] = $action2;

   $actionsCount = 1; // Note! Iteration doesn't include top level action and
                      // walks through children only
   $iterator = new RecursiveIteratorIterator(
                                           $action1,
                                           RecursiveIteratorIterator::SELF_FIRST);
   foreach ($iterator as $chainedAction) {
       $actionsCount++;
   }

   // Prints 'Actions in a tree: 4'
   printf("Actions in a tree: %d\n", $actionsCount++);

.. _zendpdf.pages.interactive-features.actions.open-action:

Document Open Action
^^^^^^^^^^^^^^^^^^^^

Special open action may be specify a destination to be displayed or an action to be performed when the document is
opened.

``ZendPdf\Target ZendPdf\PdfDocument::getOpenAction()`` method returns current document open action (or ``NULL`` if open
action is not set).

``setOpenAction(ZendPdf\Target $openAction = null)`` method sets document open action or clean it if
``$openAction`` is ``NULL``.

.. _zendpdf.pages.interactive-features.outlines:

Document Outline (bookmarks)
----------------------------

A PDF document may optionally display a document outline on the screen, allowing the user to navigate interactively
from one part of the document to another. The outline consists of a tree-structured hierarchy of outline items
(sometimes called bookmarks), which serve as a visual table of contents to display the document's structure to the
user. The user can interactively open and close individual items by clicking them with the mouse. When an item is
open, its immediate children in the hierarchy become visible on the screen; each child may in turn be open or
closed, selectively revealing or hiding further parts of the hierarchy. When an item is closed, all of its
descendants in the hierarchy are hidden. Clicking the text of any visible item activates the item, causing the
viewer application to jump to a destination or trigger an action associated with the item.

``ZendPdf\PdfDocument`` class provides public property ``$outlines`` which is an array of ``ZendPdf\Outline`` objects.

   .. code-block:: php
      :linenos:

      $pdf = ZendPdf\PdfDocument::load($path);

      // Remove outline item
      unset($pdf->outlines[0]->childOutlines[1]);

      // Set Outline to be displayed in bold
      $pdf->outlines[0]->childOutlines[3]->setIsBold(true);

      // Add outline entry
      $pdf->outlines[0]->childOutlines[5]->childOutlines[] =
          ZendPdf\Outline::create('Chapter 2', 'chapter_2');

      $pdf->save($path, true);



Outline attributes may be retrieved or set using the following methods:

- ``string getTitle()``- get outline item title.

- ``setTitle(string $title)``- set outline item title.

- ``boolean isOpen()``-``TRUE`` if outline is open by default.

- ``setIsOpen(boolean $isOpen)``- set isOpen state.

- ``boolean isItalic()``-``TRUE`` if outline item is displayed in italic.

- ``setIsItalic(boolean $isItalic)``- set isItalic state.

- ``boolean isBold()``-``TRUE`` if outline item is displayed in bold.

- ``setIsBold(boolean $isBold)``- set isBold state.

- ``ZendPdf\Color\Rgb getColor()``- get outline text color (``NULL`` means black).

- ``setColor(ZendPdf\Color\Rgb $color)``- set outline text color (``NULL`` means black).

- ``ZendPdf\Target getTarget()``- get outline target (action or explicit or named destination object).

- ``setTarget(ZendPdf\Target|string $target)``- set outline target (action or destination). String may be used to
  identify named destination. ``NULL`` means 'no target'.

- ``array getOptions()``- get outline attributes as an array.

- ``setOptions(array $options)``- set outline options. The following options are recognized: 'title', 'open',
  'color', 'italic', 'bold', and 'target'.

New outline may be created in two ways:

- ``ZendPdf\Outline::create(string $title[, ZendPdf\Target|string $target])``

- ``ZendPdf\Outline::create(array $options)``

Each outline object may have child outline items listed in ``ZendPdf\Outline::$childOutlines`` public property.
It's an array of ``ZendPdf\Outline`` objects, so outlines are organized in a tree.

``ZendPdf\Outline`` class implements RecursiveArray interface, so child outlines may be recursively iterated using
RecursiveIteratorIterator:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\PdfDocument::load($path);

   foreach ($pdf->outlines as $documentRootOutlineEntry) {
       $iterator = new RecursiveIteratorIterator(
                       $documentRootOutlineEntry,
                       RecursiveIteratorIterator::SELF_FIRST
                   );
       foreach ($iterator as $childOutlineItem) {
           $OutlineItemTarget = $childOutlineItem->getTarget();
           if ($OutlineItemTarget instanceof ZendPdf\Destination) {
               if ($pdf->resolveDestination($OutlineItemTarget) === null) {
                   // Mark Outline item with unresolvable destination
                   // using RED color
                   $childOutlineItem->setColor(new ZendPdf\Color\Rgb(1, 0, 0));
               }
           } else if ($OutlineItemTarget instanceof ZendPdf\Action\GoTo) {
               $OutlineItemTarget->setDestination();
               if ($pdf->resolveDestination($OutlineItemTarget) === null) {
                   // Mark Outline item with unresolvable destination
                   // using RED color
                   $childOutlineItem->setColor(new ZendPdf\Color\Rgb(1, 0, 0));
               }
           }
       }
   }

   $pdf->save($path, true);

.. note::

   All outline items with unresolved destinations (or destinations of GoTo actions) are updated while document
   saving by setting their targets to ``NULL``. So document will not be corrupted by removing pages referenced by
   outlines.

.. _zendpdf.pages.interactive-features.annotations:

Annotations
-----------

An annotation associates an object such as a note, sound, or movie with a location on a page of a PDF document, or
provides a way to interact with the user by means of the mouse and keyboard.

All annotations are represented by ``ZendPdf\Annotation`` abstract class.

Annotation may be attached to a page using ``ZendPdf\Page::attachAnnotation(ZendPdf\Annotation $annotation)``
method.

Three types of annotations may be created by user now:

- ``ZendPdf\Annotation\Link::create($x1, $y1, $x2, $y2, $target)`` where ``$target`` is an action object or a
  destination or string (which may be used in place of named destination object).

- ``ZendPdf\Annotation\Text::create($x1, $y1, $x2, $y2, $text)``

- ``ZendPdf\Annotation\FileAttachment::create($x1, $y1, $x2, $y2, $fileSpecification)``

A link annotation represents either a hypertext link to a destination elsewhere in the document or an action to be
performed.

A text annotation represents a "sticky note" attached to a point in the PDF document.

A file attachment annotation contains a reference to a file.

The following methods are shared between all annotation types:

- ``setLeft(float $left)``

- ``float getLeft()``

- ``setRight(float $right)``

- ``float getRight()``

- ``setTop(float $top)``

- ``float getTop()``

- ``setBottom(float $bottom)``

- ``float getBottom()``

- ``setText(string $text)``

- ``string getText()``

Text annotation property is a text to be displayed for the annotation or, if this type of annotation does not
display text, an alternate description of the annotation's contents in human-readable form.

Link annotation objects also provide two additional methods:

- ``setDestination(ZendPdf\Target|string $target)``

- ``ZendPdf\Target getDestination()``


