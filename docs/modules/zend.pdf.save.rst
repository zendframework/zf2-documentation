
Save Changes to PDF Documents
=============================

There are two methods that save changes to *PDF* documents: the ``Zend_Pdf::save()`` and ``Zend_Pdf::render()`` methods.

``Zend_Pdf::save($filename, $updateOnly = false)`` saves the *PDF* document to a file. If $updateOnly is ``TRUE`` , then only the new *PDF* file segment is appended to a file. Otherwise, the file is overwritten.

``Zend_Pdf::render($newSegmentOnly = false)`` returns the *PDF* document as a string. If $newSegmentOnly is ``TRUE`` , then only the new *PDF* file segment is returned.


