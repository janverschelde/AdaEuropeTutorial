with number_types; use number_types;

package estimate_pi is

-- DESCRIPTION :
--   Exports a parallel estimator for pi.

   freq1second : constant integer64 := 116_000_000;
   -- constant frequency so the wall clock time equals one second

   type vector is array (integer64 range <>) of integer64;

   procedure random (seed : in out integer64; number : out float64);

   -- DESCRIPTION :
   --   Returns a random number in [0,1], using the given seed.
   --   The seed is updated for the next number.

   function coinflips (frequency : integer64) return integer64;

   -- DESCRIPTION :
   --   Returns the number of times the random number generator
   --   produced a number equal to or larger than 0.5.
   --   The integer on return is expected to be frequency/2.

   procedure test (frequency : integer64 := 1_000);

   -- DESCRIPTION :
   --   Does as many coin flips as the value of frequency
   --   and shows the number of heads,
   --   using the current time as the seed.

   function incircle (x, y : float64) return Boolean;

   -- DESCRIPTION :
   --   Returns the outcome of (x*x + y*y <= 1.0).

   procedure count
     (seed      : in out integer64; sum : in out integer64;
      frequency : in     integer64 := freq1second);

   -- DESCRIPTION :
   --   Counts the number of times a pair of two random numbers (x,y)
   --   made incircle(x,y) true, for i in range 1..frequency.

   procedure arguments (freqnbr : out integer64; workers : out integer64);

   -- DESCRIPTION :
   --   Returns the values of the two command line arguments,
   --   the frequency numbers and the number of workers.
   --   Default return values are one for both if there are
   --   no command line arguments.

   procedure hello_tasks (p : in integer64 := 4);

   -- DESCRIPTION :
   --   A "Hello world!" version for launching p tasks.

   procedure parallel_count
     (p         : in integer64;
      seeds     : in out vector; sums : in out vector;
      frequency : in integer64 := freq1second);

   -- DESCRIPTION :
   --   Runs the count procedure with p processors,
   --   starting at p seeds and returning p sums.
   --   Each processor runs at the same frequency.

   procedure run;

   -- DESCRIPTION :
   --   The main procedure for a parallel run.

end estimate_pi;
