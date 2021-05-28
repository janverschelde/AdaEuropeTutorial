with number_types; use number_types;

package Float64_Queue is

-- DESCRIPTION :
--   Represents a queue of 64-bit floating-point numbers.

   queue_full : exception;  -- raised when queue is full

   queue_empty : exception; -- raised when queue is empty

   procedure Initialize ( size : in integer64 );

   -- DESCRIPTION :
   --   Initializes the queue to its given size.

   procedure push_back ( nbr : in Float64 );

   -- DESCRIPTION :
   --   Pushes the number to the back of the queue.
   --   Raises the expection queue_full if the queue is full.

   function pop_front return Float64;

   -- DESCRIPTION :
   --   Pops the number from the front of the queue.
   --   Raises the expection queue_empty if the queue is empty.

   function empty return boolean;

   -- DESCRIPTION :
   --   Returns true if the queue is empty.

   procedure Clear;

   -- DESCRIPTION :
   --   Deallocates the memory occupied by the queue.

end Float64_Queue;
