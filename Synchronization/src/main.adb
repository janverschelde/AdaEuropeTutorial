with synchronized_pi;

procedure main is
begin
  -- synchronized_pi.test_producer_consumer; -- equal paced
  -- synchronized_pi.test_producer_consumer(13,3,0.2,0.9); -- faster producer
  -- synchronized_pi.test_producer_consumer(13,3,0.9,0.2); -- faster consumer
  -- synchronized_pi.test_producers_consumers; -- equal paced
  -- producers are faster than consumers
  -- synchronized_pi.test_producers_consumers(7,3,3,3,0.2,0.9);
  -- comsumers are faster than producers
   synchronized_pi.test_producers_consumers(7,3,4,2,0.9,0.2);
  -- synchronized_pi.run_2stage4pi(409600,1024);
end main;
