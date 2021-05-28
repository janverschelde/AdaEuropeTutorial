with number_types; use number_types;

package trapezoidal_pi is

-- DESCRIPTION :
--   Applies the composite trapezoidal rule, to compute the integral
--   of a function over a finite interval, to approximate pi.

   type vector is array (integer64 range <>) of float64;

   function composite_rule
              ( f : access function ( x : float64 ) return float64;
                a,b : float64; n : integer64 ) return float64;

   -- DESCRIPTION :
   --   Applies the composite trapezoidal rule to approximate the
   --   definite integral of f over [a,b] with n subintervals.
   --   For better accuracy, n should be a power of 2.

   function recursive_rule
              ( f : access function ( x : float64 ) return float64;
                a,b : float64; n : integer64 ) return float64;

   -- DESCRIPTION :
   --   Applies the composite trapezoidal rule recursively
   --   for a more accurate summation to approximate the definite
   --   integral of f over [a,b] with n subintervals.
   --   For better accuracy, n should be a power of 2.

   function circle ( x : float64 ) return float64;

   -- DESCRIPTION :
   --   Returns sqrt(1-x**2) for the approximation of pi.

   procedure test;

   -- DESCRIPTION :
   --   Tests the trapezoidal rule for the estimation of pi.

   procedure test_task_launch (p : integer64 := 4);

   -- DESCRIPTION :
   --   Tests the launching of p tasks with an array of tasks,
   --   with an identification number generator.

   procedure hello_tasks (p : in integer64 := 4);

   -- DESCRIPTION :
   --   Tests the array of workers.

   procedure test_job_queue (p : in integer64 := 4; n : in integer64 := 17);

   -- DESCRIPTION :
   --   Tests the assignment of n jobs to p tasks,
   --   ensuring that every task gets a different job number.

   procedure static_run (p : in integer64 := 4);

   -- DESCRIPTION :
   --   Defines a parallel run with p tasks,
   --   using a static work assignment.

   procedure dynamic_run (p : in integer64 := 4; n : in integer64 := 17);

   -- DESCRIPTION :
   --   Defines a parallel run with p tasks,
   --   using a dynamic work assignment with n jobs.

end trapezoidal_pi;
