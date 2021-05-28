with Text_IO;
with Ada.Numerics;
with integer64_io;
with float64_io;
with estimate_pi;
with trapezoidal_pi;
with Identification;

package body pipelined_pi is

--   The code for the leveled_id_generator is an adaptation of the
--   id_generator, copied from the book of
--   John W. McCormick, Frank Singhoff, and Jerome Hugues:
--   "Building Parallel, Embedded, and Real-Time Applications with Ada."
--   Cambridge University Press, 2011, section 4.4, page 137.

   protected leveled_id_generator is

      procedure get ( lvl : in integer64; id : out integer64 );
      -- returns a unique identification number,
      -- within the current level lvl

   private
      next_id : integer64 := 1;
      current_lvl : integer64 := -1;
   end leveled_id_generator;

   protected body leveled_id_generator is
      procedure get ( lvl : in integer64; id : out integer64 ) is
      begin
         if lvl /= current_lvl then -- reset the id counter
            current_lvl := lvl;
            next_id := 1;
         end if;
         id := next_id;
         next_id := next_id + 1;
      end get;
   end leveled_id_generator;

   procedure test_linear_launch ( pwr : integer64 := 3 ) is

      p : constant integer64 := 2**integer(pwr);
      s : constant string := integer64'image(p);

   begin
      Text_IO.Put_Line ("Launching tasks ...");
      declare
         task type worker;
         task body worker is
            i : constant integer64 := Identification.Number;
         begin
            Text_IO.Put_Line ("Hello from worker" & integer64'image(i) & ".");
            delay 100.0;
         end worker;
         workers : array(0..p-1) of worker;
      begin
         null;
      end;
      Text_IO.Put_Line ("Launched" & s & " workers.");
   end test_linear_launch;

   procedure test_fanout_launch ( pwr : integer64 := 3 ) is

      p : constant integer64 := 2**integer(pwr)-1;
      s : constant string := integer64'image(p);

      procedure launch (level : integer64) is
     
         task type worker;

         task body worker is

            i,n : integer64;

         begin
            leveled_id_generator.get(level,i);
            n := i;
            for j in 0..level-1 loop
               n := n + 2**integer(j);
            end loop;
            text_io.put_line("Hello from worker" & integer64'image(i)
                                                 & " at level"
                                                 & integer64'image(level)
                                                 & " with number"
                                                 & integer64'image(n)
                                                 & ".");
         end worker;

         nbrtasks : constant integer64 := 2**integer(level);
         workers : array(1..nbrtasks) of worker;

      begin
         if level < pwr-1 then
            launch(level+1);
         end if;
      end launch;

   begin
      Text_IO.Put_Line ("Launching tasks ...");
      launch(0);
      Text_IO.Put_Line ("Launched" & s & " workers.");
   end test_fanout_launch;

   procedure linear_pipe ( p : in integer64; results : out vector ) is

      s : constant string := integer64'image(p);
      step : constant float64 := 1.0/float64(p);
      nsteps : constant integer64 := (2**28/p);

      use estimate_pi;
      use trapezoidal_pi;

      task type worker (i:integer64);

      task body worker is

         a : constant float64 := float64(i-1)*step;
         b : constant float64 := float64(i)*step;

      begin
         Text_IO.Put_Line ("Hello from worker" & integer64'image(i) & ".");
         results(i) := recursive_rule(circle'access,a,b,nsteps);
      end worker;

      procedure launch (i: in integer64) is

         w : worker(i);

      begin
         if i < p then
            launch (i+1);
         end if;
      end launch;

   begin
      Text_IO.Put_Line ("Launching tasks ...");
      launch(1);
      Text_IO.Put_Line ("Launched" & s & " workers.");
   end linear_pipe;

   procedure pyramid_pipe ( pwr : integer64; results : out vector ) is

      p : constant integer64 := 2**integer(pwr)-1;
      s : constant string := integer64'image(p);
      step : constant float64 := 1.0/float64(p);
      nsteps : constant integer64 := (2**28/p);

      use estimate_pi;
      use trapezoidal_pi;

      procedure launch (level : integer64) is
     
         task type worker;

         task body worker is

            i,n : integer64;
            a,b : float64;

         begin
            leveled_id_generator.get(level,i);
            n := i;
            for j in 0..level-1 loop
               n := n + 2**integer(j);
            end loop;
            text_io.put_line("Hello from worker" & integer64'image(i)
                                                 & " at level"
                                                 & integer64'image(level)
                                                 & " with number"
                                                 & integer64'image(n)
                                                 & ".");
            a := float64(n-1)*step;
            b := float64(n)*step;
            results(n) := recursive_rule(circle'access,a,b,nsteps);
         end worker;

         nbrtasks : constant integer64 := 2**integer(level);
         workers : array(1..nbrtasks) of worker;

      begin
         if level < pwr-1 then
            launch(level+1);
         end if;
      end launch;

   begin
      Text_IO.Put_Line ("Launching tasks ...");
      launch(0);
      Text_IO.Put_Line ("Launched" & s & " workers.");
   end pyramid_pipe;

   procedure run_linear_pipe ( p : in integer64 ) is

      results : vector(1..p);
      est4pi : float64 := 0.0;
      error : float64;

   begin
      linear_pipe(p,results);
      Text_IO.put_line("The results :");
      for k in 1..p loop
         integer64_io.put(k,1);
         text_IO.put(" : ");
         float64_io.put(results(k),1);
         text_IO.new_line;
         est4pi := est4pi + results(k);
      end loop;
      est4pi := 4.0*est4pi;
      Text_IO.put("Estimate for pi :");
      float64_io.put(est4pi);
      error := abs(Ada.Numerics.Pi - est4pi);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3);
      Text_IO.new_line;
   end run_linear_pipe;

   procedure run_pyramid_pipe ( pwr : in integer64 := 3 ) is

      p : constant integer64 := 2**integer(pwr)-1;
      results : vector(1..p);
      est4pi : float64 := 0.0;
      error : float64;

   begin
      pyramid_pipe(pwr,results);
      Text_IO.put_line("The results :");
      for k in 1..p loop
         integer64_io.put(k,1);
         text_IO.put(" : ");
         float64_io.put(results(k),1);
         text_IO.new_line;
         est4pi := est4pi + results(k);
      end loop;
      est4pi := 4.0*est4pi;
      Text_IO.put("Estimate for pi :");
      float64_io.put(est4pi);
      error := abs(Ada.Numerics.Pi - est4pi);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3);
      Text_IO.new_line;
   end run_pyramid_pipe;

end pipelined_pi;
