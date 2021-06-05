with unchecked_deallocation;
with Semaphore;
with pipelined_pi; use pipelined_pi;

package body Float64_Queue is

   type vector_pointer is access vector;

   data : vector_pointer;
   front : integer64;    -- index of the front of the queue
   back : integer64;     -- index to the back of the queue
   full_queue : boolean; -- status flag for full queue
   sem : Semaphore.Lock;

   procedure Initialize ( size : in integer64 ) is

      v : vector(1..size) := (1..size => 0.0);

   begin
      data := new vector'(v);
      front := 0; back := 0;
      full_queue := false;
   end Initialize;  

   procedure push_back ( nbr : in Float64 ) is

      fail : boolean := false;

   begin
      if full_queue then
         raise queue_full;
      else
         Semaphore.Request(sem);
         if full_queue then
            fail := true;
	 elsif front = 0 then
            data(1) := nbr;
            front := 1; back := 1;
            full_queue := (data'last = 1);
         else
            if back = data'last
             then back := 1;
             else back := back + 1;
            end if;
            data(back) := nbr;
            if back = data'last
             then full_queue := (front = 1);
             else full_queue := (front = back+1);
            end if;
         end if;
         Semaphore.Release(sem);
         if fail
          then raise queue_full;
         end if;
      end if;
   end push_back;

   function pop_front return Float64 is

      result : Float64 := 0.0;
      fail : boolean := false;

   begin
      if front = 0 then
         raise queue_empty;
      else
         Semaphore.Request(sem);
	 if front = 0 then
            fail := true;
         else
            result := data(front);
            if front = back then
               front := 0;
            else
               front := front + 1;
               if front > data'last
                then front := 1;
               end if;
               if full_queue
                then full_queue := false;
               end if;
            end if;
         end if;
         Semaphore.Release(sem);
         if fail
          then raise queue_empty;
         end if;
      end if;
      return result;
   end pop_front;

   function empty return boolean is
   begin
      return (front = 0);
   end empty;

   procedure Clear is

      procedure free is new unchecked_deallocation(vector,vector_pointer);

   begin
      free(data);
   end Clear;

end Float64_Queue;
