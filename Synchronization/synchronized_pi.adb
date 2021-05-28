with Text_IO,Integer64_IO,Float64_IO;
with float64_queue;

package body synchronized_pi is

   procedure test_producer_consumer
                ( cycles_number : in integer64 := 5;
                  queue_size    : in integer64 := 2;
                  producer_pace : in duration := 1.0; 
                  consumer_pace : in duration := 1.0 ) is

      result : float64 := 0.0;

      procedure run is

         task type producer;

         task body producer is

            nbr : float64 := 0.0;
            fail : boolean;

         begin
            Text_IO.put_line("The producer says hello!");
            for k in 1..cycles_number loop
               Text_IO.put_line("Producer enters cycle" & integer64'image(k)
                                                        & ".");
               delay producer_pace;
               nbr := nbr + 1.0;
               loop
                  fail := false;
                  declare
                  begin
                     float64_queue.push_back(nbr);
                  exception
                     when float64_queue.queue_full => fail := true;
                  end;
                  exit when not fail;
                  Text_IO.put_line("Producer waits ...");
                  delay producer_pace/2.0;
               end loop;
            end loop;
         end producer;

         task type consumer;

         task body consumer is

            nbr : float64;
            fail : boolean;

         begin
            Text_IO.put_line("The consumer says hello!");
            for k in 1..cycles_number loop
               Text_IO.put_line("Consumer enters cycle" & integer64'image(k)
                                                        & ".");
               loop
                  fail := false;
                  declare
                  begin
                     nbr := float64_queue.pop_front;
                  exception
                     when float64_queue.queue_empty => fail := true;
                  end;
                  exit when not fail;
                  Text_IO.put_line("Consumer waits ...");
                  delay consumer_pace/2.0;
               end loop;
               delay consumer_pace;
               result := result + nbr;
            end loop;
         end consumer;

     begin
        null;
     end run;

   begin
      Text_IO.put_line("Starting run with" & integer64'image(cycles_number) 
                                           & " cycles ...");
      float64_queue.Initialize(cycles_number/2);
      run;
      float64_queue.Clear;
      Text_io.put("The result : "); Float64_IO.put(result);
      Text_IO.new_line;
      declare
         checksum : constant integer64 := (cycles_number*(cycles_number+1))/2;
      begin
         Text_io.put(" check sum : "); Integer64_IO.put(checksum,1);
         if checksum = integer64(result)
          then Text_IO.put_line("  okay.");
          else Text_IO.put_line("  wrong!");
         end if;
      end;
   end test_producer_consumer;

-- The code for the producer_id_generator and consumer_id_generator
-- is adapted from the book of
-- John W. McCormick, Frank Singhoff, and Jerome Hugues:
-- "Building Parallel, Embedded, and Real-Time Applications with Ada."
-- Cambridge University Press, 2011, section 4.4, page 137.

   protected producer_id_generator is

      procedure get ( id : out integer64 );
      -- returns a unique identification number

   private
      next_id : integer64 := 1;
   end producer_id_generator;

   protected body producer_id_generator is
      procedure get ( id : out integer64 ) is
      begin
         id := next_id;
         next_id := next_id + 1;
      end get;
   end producer_id_generator;

   protected consumer_id_generator is

      procedure get ( id : out integer64 );
      -- returns a unique identification number

   private
      next_id : integer64 := 1;
   end consumer_id_generator;

   protected body consumer_id_generator is
      procedure get ( id : out integer64 ) is
      begin
         id := next_id;
         next_id := next_id + 1;
      end get;
   end consumer_id_generator;

   procedure test_producers_consumers
                ( cycles_number   : in integer64 := 5;
                  queue_size      : in integer64 := 2;
                  producer_number : in integer64 := 3;
                  consumer_number : in integer64 := 3;
                  producer_pace   : in duration := 1.0; 
                  consumer_pace   : in duration := 1.0 ) is

      results : array(1..consumer_number) of float64;
      sum_results : float64 := 0.0;
      all_done : array(1..producer_number) of boolean;

      function stop return boolean is -- stop condition for consumers
      begin
         for k in all_done'range loop -- consumers do not stop if
            if not all_done(k)
             then return false;       -- the k-th producer is not done
            end if;
         end loop;
         return float64_queue.empty;  -- or if the queue is not empty
      end stop;

      procedure run is

         task type producer;

         task body producer is

            nbr : float64 := 0.0;
            fail : boolean;
            idnbr : integer64;

         begin
            producer_id_generator.get(idnbr);
            Text_IO.put_line("Producer" & integer64'image(idnbr)
                                        & " says hello!");
            nbr := float64(idnbr);
            for k in 1..cycles_number loop
               Text_IO.put_line("Producer" & integer64'image(idnbr)
                         & " enters cycle" & integer64'image(k)
                                           & ".");
               delay producer_pace;
               loop
                  fail := false;
                  declare
                  begin
                     float64_queue.push_back(nbr);
                  exception
                     when float64_queue.queue_full => fail := true;
                  end;
                  exit when not fail;
                  Text_IO.put_line("Producer" & integer64'image(idnbr)
                                              & " waits ...");
                  delay producer_pace/2.0;
               end loop;
               nbr := nbr + float64(producer_number);
            end loop;
            all_done(idnbr) := true; -- to stop the consumers
         end producer;

         producers : array(1..producer_number) of producer;

         task type consumer;

         task body consumer is

            nbr : float64;
            fail : boolean;
            idnbr : integer64;
            cycle : integer64 := 0;

         begin
            consumer_id_generator.get(idnbr);
            Text_IO.put_line("Consumer" & integer64'image(idnbr)
                                        & " says hello!");
            loop
               cycle := cycle + 1;
               Text_IO.put_line("Consumer" & integer64'image(idnbr)
                         & " enters cycle" & integer64'image(cycle)
                                           & ".");
               loop
                  fail := false;
                  declare
                  begin
                     nbr := float64_queue.pop_front;
                  exception
                     when float64_queue.queue_empty => fail := true;
                  end;
                  exit when not fail or stop;
                  Text_IO.put_line("Consumer" & integer64'image(idnbr)
                                              & " waits ...");
                  delay consumer_pace/2.0;
               end loop;
               if not fail then -- do not forget to process last element!
                  delay consumer_pace;
                  results(idnbr) := results(idnbr) + nbr;
               end if;
               exit when stop;
            end loop;
         end consumer;

         consumers : array(1..consumer_number) of consumer;

     begin
        null;
     end run;

   begin
      Text_IO.put_line("Starting run with" & integer64'image(cycles_number) 
                                           & " cycles ...");
      results := (results'range => 0.0);
      all_done := (all_done'range => false);
      float64_queue.Initialize(cycles_number/2);
      run;
      float64_queue.Clear;
      for k in results'range loop
         sum_results := sum_results + results(k);
      end loop;
      Text_io.put("The result : "); Float64_IO.put(sum_results);
      Text_IO.new_line;
      declare
         count : constant integer64 := producer_number*cycles_number;
         checksum : constant integer64 := (count*(count+1))/2;
      begin
         Text_io.put(" check sum : "); Integer64_IO.put(checksum,1);
         if checksum = integer64(sum_results)
          then Text_IO.put_line("  okay.");
          else Text_IO.put_line("  wrong!");
         end if;
      end;
   end test_producers_consumers;

end synchronized_pi; 
