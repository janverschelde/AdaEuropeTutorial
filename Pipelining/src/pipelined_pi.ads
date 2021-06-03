with number_types; use number_types;

package pipelined_pi is

-- DESCRIPTION :
--   Applies the composite trapezoidal rule to approximate pi,
--   with a fan out launch of the tasks.

   type vector is array (integer64 range <>) of float64;

   procedure test_linear_launch ( pwr : integer64 := 3 );

   -- DESCRIPTION :
   --   Tests the launching of an array of 2**pwr tasks.

   procedure test_fanout_launch ( pwr : integer64 := 3 );

   -- DESCRIPTION :
   --   Tests the fanout launching of 2**pwr-1 tasks.

   procedure run_linear_pipe ( p : in integer64 );

   -- DESCRIPTION :
   --   Runs a linear pipeline with p tasks to approximate pi
   --   with the composite trapezoidal rule.

   procedure run_pyramid_pipe ( pwr : in integer64 := 3);

   -- DESCRIPTION :
   --   Runs a pyramid pipeline with 2**pwr-1 tasks to approximate pi
   --   with the composite trapezoidal rule.

end pipelined_pi;
