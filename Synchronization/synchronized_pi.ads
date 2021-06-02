with number_types; use number_types;

package synchronized_pi is

-- DESCRIPTION :
--   Applies the producer/consumer pipeline to the function evaluations
--   and summations in the composite trapezoidal rule to approximate pi.

   procedure test_producer_consumer
                ( cycles_number : in integer64 := 5;
                  queue_size    : in integer64 := 2;
                  producer_pace : in duration := 1.0; 
                  consumer_pace : in duration := 1.0 ) ;

   -- DESCRIPTION :
   --   Simulates a producer/consumer model each operating at some pace.

   -- INPUT PARAMETERS :
   --   cycles_number   number of producer/consumer steps;
   --   queue_size      size of the queue to store the numbers;
   --   producer_pace   time the producer needs to produce a new number;
   --   consumer_pace   time the consuder needs to consume a new number.

   procedure test_producers_consumers
                ( cycles_number   : in integer64 := 5;
                  queue_size      : in integer64 := 2;
                  producer_number : in integer64 := 3;
                  consumer_number : in integer64 := 3;
                  producer_pace   : in duration := 1.0; 
                  consumer_pace   : in duration := 1.0 );

   -- DESCRIPTION :
   --   Simulates a model of many producers and consumers.

   -- INPUT PARAMETERS :
   --   cycles_number   number of producer/consumer steps;
   --   queue_size      size of the queue to store the numbers;
   --   producer_number is the number of producers;
   --   consumer_number is the number of consumers;
   --   producer_pace   time the producers need to produce a new number;
   --   consumer_pace   time the consuders need to consume a new number.

   procedure run_2stage4pi
                ( step_number : in integer64 := 16;
                  queue_size  : in integer64 := 16 );

  -- DESCRIPTION :
  --   Runs a 2-stage pipeline to approximate pi.

end synchronized_pi; 
