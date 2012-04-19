Mopup - code clean up utility gem
===

Cleans up rogue whitespace in source code. Will also translate tabs to spaces

Usage
---
  mopup <options> <file|directory>

If no file or directory is supplied the current working directory is presumed.

Options
---

--recurse         -r                  Recurse into sub direcories
--translate       -t [TAB_STOP=2]     Translate leading tabs to spaces
--verbose         -v                  Print result of each file cleanup
--file            -f [FILE}           System path to a file to clean
--directory       -d [DIR]            System path to a directory to clean
