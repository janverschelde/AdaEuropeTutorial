with number_types; use number_types;

package Identification is

-- DESCRIPTION :
--   Wraps a protected object to generate a unique identification number,
--   The code for the id_generator is copied from the book of
--   John W. McCormick, Frank Singhoff, and Jerome Hugues:
--   "Building Parallel, Embedded, and Real-Time Applications with Ada."
--   Cambridge University Press, 2011, section 4.4, page 137.

   function Number return integer64;

   -- DESCRIPTION :
   --   Returns a unique identifiation number.

end Identification;
