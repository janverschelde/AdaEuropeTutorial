# Ideal Parallel Computations

The goal of the package ``estimate_pi`` is to illustrate the launching
of any number of threads and to demonstrate that speedups are obtained
in the application to a simple simulation to estimate pi.

To build the code, run ``gprbuild intro.gpr`` at the command line,
or for use in GNATstudio.  To compile the code with full optimization
and the suppression of all checks, use the makefile in the obj folder.

On Linux, with ``time``, as in ``time ./main``, gives the wall clock time.
PowerShell users on Windows 10 can use ``Measure-Command {./main}``
to obtain the wall clock time.
