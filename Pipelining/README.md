# Pipelining

The goal of the package ``pipelined_pi`` is to apply the method
of delegating work to linear pipelines and pyramid pipelines.

To build the code, run ``gprbuild intro.gpr`` at the command line,
or for use in GNATstudio.  To compile the code with full optimization
and the suppression of all checks, use the makefile in the ``obj`` folder.

On Linux, with ``time``, as in ``time ./main``, 
we obtain the wall clock time of the run.
PowerShell users on Windows 10 can use ``Measure-Command {./main}``
to obtain the wall clock time.
