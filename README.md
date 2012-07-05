karthaus
========

Copyright 2009--2012  Ed Bueler

Introduction
------

These are notes and codes for my numerical lectures at the Karthaus (Italy)
Summer School on Ice Sheets and Glaciers, for years 2009 and 2010.  The
materials for the current year (2012) is in progress.  The Karthaus school
page website is at

http://www.projects.science.uu.nl/iceclimate/karthaus/

The lectures (`lecture.pdf`, along with the reference list in `refs.pdf`) form
a self-contained course.  Self-contained, that is, if you don't
want to do exercises (`exers.pdf`) or actually run and modify codes.

Working with actual codes is recommended!  See `mfiles/` for the Matlab/Octave 
programs.  The lectures are the major documentation of these programs,
but there are also help pages (= leading comments).

The directory `petsc/` contains a C code using the [PETSc]()
library to solve the same SSA problem as solved by some Matlab/Octave programs.
Wise students would only look in `petsc/` after becoming reasonably familiar
with the Matlab/Octave versions.

Build instructions
------

To build PDF form of lectures, we require these tools

*  pdflatex
*  bibtex
*  epstopdf
*  inkscape
*  pdftk
*  convert   (from ImageMagick)

and standard Linux tools including sed and GNU make.  See
Makefile for details.  The `pdffigs/` directory is filled by "make" 
below, from *.eps and *.svg sources, using epstopdf and inkscape.
Note that epstopdf is found in debian package texlive-extra-utils.

Octave and Matlab were used to generate some figures, typically via
.eps: `print -deps foo.eps`.

There is a ridiculously fragile route from .svg to get .pdf that will work
in pdflatex, using \includegraphics{}, without errors or warnings.
*But* at least it can be done at the command line.  Here is an example,
starting with an image "coffee.svg":

    $ inkscape --export-eps=coffee.eps coffee.svg
    $ epstopdf coffee.eps  # creates coffee.pdf which works in pdflatex
    $ rm coffee.eps

In this case coffee.pdf comes out *smaller* in file size than coffee.svg.
The disadvantage is that transparency is lost.  But at least there
are no errors in the .pdf that results from this route.

The Matlab/Octave codes in mfiles/ are stripped of comments and print
statements before going in the presentation.  That is the significance
of the *.slim.m names and the obscure sed command.

For BibTeX to work, a link must be created to the "master" .bib file from
the PISM source tree, or that file must be copied into the current directory.
Thus either do something similar to this:

    $ ln -s ~/pism-dev/doc/ice_bib.bib

To build the presentation (`lecture.pdf`), exercises (`exers.pdf`),
and references (`refs.pdf`), do:

    $ make

To clean up everything but leave the PDFs just produced:

    $ make clean

