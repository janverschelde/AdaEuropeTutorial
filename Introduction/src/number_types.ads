with system;

package number_types is

-- DESCRIPTION :
--   Defines the names of the 64-bit integers 
--   and the 64-bit floating-point numbers,
--   respectively as integer64 and float64.

  type integer64 is new long_long_integer; -- 64-bit integer numbers
  -- the largest 64-bit integer is 2**63-1
  -- the smallest 64-bit integer is -2**63

  type float64 is digits 15; 
  -- system.Max_Digits;               -- 64-bit floating-point numbers

end number_types;
