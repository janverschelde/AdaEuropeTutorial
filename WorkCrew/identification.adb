package body Identification is

-- The code for the id_generator is copied from the book of
-- John W. McCormick, Frank Singhoff, and Jerome Hugues:
-- "Building Parallel, Embedded, and Real-Time Applications with Ada."
-- Cambridge University Press, 2011, section 4.4, page 137.

   protected id_generator is

      procedure get ( id : out integer64 );
      -- returns a unique identification number

   private
      next_id : integer64 := 1;
   end id_generator;

   protected body id_generator is
      procedure get ( id : out integer64 ) is
      begin
         id := next_id;
         next_id := next_id + 1;
      end get;
   end id_generator;

   function Number return integer64 is

      result : integer64;

   begin
      id_generator.get(result);
      return result;
   end Number;

end Identification;
