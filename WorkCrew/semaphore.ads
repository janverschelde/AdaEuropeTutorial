with System;

package Semaphore is

-- DESCRIPTION :
--   A semaphore is a lock to guard a critical section.
--   The code for the protected type is based on AdaCore Gem #81,
--   see also GNAT.Semaphores.

   protected type Binary_Semaphore
     (initially_available : Boolean; Ceiling : System.Priority) is

      pragma Priority (Ceiling);
      function Is_Available return Boolean;
      -- returns true if the available
      entry Seize;
      -- blocks the caller unless available
      procedure Release;
      -- make the semaphore available

   private
      available : Boolean := initially_available;
   end Binary_Semaphore;

   type Lock is limited private;

   function Available (s : Lock) return Boolean;

   -- DESCRIPTION :
   --   Returns the status of the lock.

   procedure Request (s : in out Lock);

   -- DESCRIPTION :
   --   Requests a lock to enter a critical section.

   procedure Release (s : in out Lock);

   -- DESCRIPTION :
   --   Releases the lock of a critical section.

private

   type Lock is record
      b : Binary_Semaphore (True, System.Default_Priority);
   end record;

end Semaphore;
