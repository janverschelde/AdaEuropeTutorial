# Synchronization

The goal of the package ``synchronized_pi`` is to illustrate 
the synchronization of producers and consumers with a queue.

To build the code, run ``gprbuild intro.gpr`` at the command line,
or for use in GNATstudio.  To compile the code with full optimization
and the suppression of all checks, use the makefile in the ``obj`` folder.

On Linux, with ``time``, as in ``time ./main``, 
we obtain the wall clock time of the run.
PowerShell users on Windows 10 can use ``Measure-Command {./main}``
to obtain the wall clock time.
