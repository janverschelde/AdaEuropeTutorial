with pipelined_pi;

procedure main is
begin
   -- pipelined_pi.test_linear_launch(10);
   -- pipelined_pi.test_fanout_launch(1);
   -- pipelined_pi.test_fanout_launch(2);
   pipelined_pi.test_fanout_launch(3);
   -- pipelined_pi.test_fanout_launch(4);
   -- pipelined_pi.test_fanout_launch(5);
   -- pipelined_pi.run_linear_pipe(64);
   -- pipelined_pi.run_pyramid_pipe(3);
end main;
