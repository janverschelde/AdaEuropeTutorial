with Text_IO;
with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
with integer64_io;
with float64_io;
with Ada.Task_Identification;
with Identification;
with Semaphore;

package body trapezoidal_pi is

   function composite_rule
              ( f : access function ( x : float64 ) return float64;
                a,b : float64; n : integer64 ) return float64 is
 
      result : float64 := (f(a) + f(b))/2.0;
      step : constant float64 := (b - a)/float64(n);
      xarg : float64 := step;

   begin
      for k in 1..n-1 loop
         result := result + f(xarg);
         xarg := xarg + step;
      end loop;
      result := step*result;
      return result;
   end composite_rule;

   function recursive_rule
              ( f : access function ( x : float64 ) return float64;
                a,b : float64; n : integer64 ) return float64 is
 
      result,middle : float64;

   begin
      if n = 1 then
         result := (b-a)*(f(a) + f(b))/2.0;
      else
         middle := a + (b-a)/2.0;
         result := recursive_rule(f,a,middle,n/2)
                 + recursive_rule(f,middle,b,n/2);
      end if;
      return result;
   end recursive_rule;

   function reverse_rule
              ( f : access function ( x : float64 ) return float64;
                a,b : float64; n : integer64 ) return float64 is
 
      result : float64 := (f(a) + f(b))/2.0;
      step : constant float64 := (b - a)/float64(n);
      xarg : float64 := b;

   begin
      for k in 1..n-1 loop
         xarg := xarg - step;
         result := result + f(xarg);
      end loop;
      result := step*result;
      return result;
   end reverse_rule;

   package Double_Elementary_Functions is
      new Ada.Numerics.Generic_Elementary_Functions(float64);

   function circle ( x : float64 ) return float64 is
   begin
      return Double_Elementary_Functions.SQRT(1.0 - x**2);
   end circle;

   procedure run ( nsteps : in integer64 ) is

     -- approx : float64 := composite_rule(circle'access,0.0,1.0,nsteps);
      approx : constant float64
             := recursive_rule(circle'access,0.0,1.0,nsteps);
      est4pi : constant float64 := 4.0*approx;
      error : float64;

   begin
      Text_IO.put("Estimate for pi :");
      float64_io.put(est4pi);
      error := abs(Ada.Numerics.Pi - est4pi);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3);
      Text_IO.put("  N : ");
      integer64_io.put(nsteps,1);
      Text_IO.new_line;
   end run;

   procedure test is
   begin
      run(2**28);
   end test;

   procedure test_accuracy is

      nsteps : constant integer64 := 2**28;
   -- if 2**20, then no noticeable difference in the accuracy --
      forward : constant float64
              := composite_rule(circle'access,0.0,1.0,nsteps);
      backward : constant float64
               := reverse_rule(circle'access,0.0,1.0,nsteps);
      approx : constant float64
             := recursive_rule(circle'access,0.0,1.0,nsteps);
      est4pi1 : constant float64 := 4.0*forward;
      est4pi2 : constant float64 := 4.0*backward;
      est4pi3 : constant float64 := 4.0*approx;
      error : float64;

   begin
      Text_IO.put("  Forward approximation :"); float64_io.put(est4pi1);
      error := abs(Ada.Numerics.Pi - est4pi1);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3); Text_IO.new_line;
      Text_IO.put(" Backward approximation :"); float64_io.put(est4pi2);
      error := abs(Ada.Numerics.Pi - est4pi2);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3); Text_IO.new_line;
      Text_IO.put("Recursive approximation :"); float64_io.put(est4pi3);
      error := abs(Ada.Numerics.Pi - est4pi3);
      Text_IO.put("  error : ");
      float64_io.put(error,1,3,3); Text_IO.new_line;
      Text_IO.put("    Number of intervals : ");
      integer64_io.put(nsteps,1); Text_IO.new_line;
   end test_accuracy;

   procedure hello_tasks (p : in integer64 := 4) is

      task type worker;

      task body worker is

         idnbr : constant integer64 := Identification.Number;
         taskid : constant Ada.Task_Identification.Task_Id
                := Ada.Task_Identification.Current_Task;

      begin
         Text_IO.Put_Line ("Task" & integer64'image (idnbr)
                                  & " says hello with id "
                & Ada.Task_Identification.Image(taskid) & ".");
      end worker;

      workers : array(1..p) of worker;

   begin
      null;
   end hello_tasks;

   procedure test_job_queue (p : in integer64 := 4; n : in integer64 := 17) is

      nextjob : integer64 := 0;
      sem : Semaphore.Lock;

      task type worker;

      task body worker is

         idnbr : constant integer64 := Identification.Number;
         myjob : integer64;

      begin
         loop
            Semaphore.Request(sem);
            nextjob := nextjob + 1; myjob := nextjob;
            Semaphore.Release(sem);
            exit when (myjob > n);
            Text_IO.Put_Line ("Task" & integer64'image (idnbr) & " does job"
                                     & integer64'image (myjob) & ".");
         end loop;
      end worker;

      workers : array(1..p) of worker;

   begin
      null;
   end test_job_queue;

   procedure test_task_launch (p : integer64 := 4) is
   begin
      Text_IO.Put_Line ("Launching tasks ...");
      hello_tasks (p);
      Text_IO.Put_Line ("Launched" & integer64'image (p) & " tasks.");
   end test_task_launch;

   procedure run_workers (p : in integer64; results : out vector) is

      step : constant Float64 := 1.0/Float64(p);
      nsteps : constant integer64 := (2**28/p);

      task type worker;

      task body worker is

         myid : constant integer64 := Identification.Number;
         start,stop : float64;

      begin
         start := float64(myid-1)*step;
         stop := float64(myid)*step;
         results(myid) := recursive_rule(circle'access,start,stop,nsteps);
      end worker;

      workers : array(1..p) of worker;

   begin
      null;
   end run_workers;

   procedure do_jobs (p,n : in integer64; results : out vector) is

      step : constant Float64 := 1.0/Float64(n);
      nsteps : constant integer64 := (2**28/n);
      nextjob : integer64 := 0;
      sem : Semaphore.Lock;

      task type worker;

      task body worker is

         myid : constant integer64 := Identification.Number;
         myjob : integer64;
         start,stop : float64;

      begin
         loop
            Semaphore.Request(sem);
            nextjob := nextjob + 1; myjob := nextjob;
            Semaphore.Release(sem);
            exit when (myjob > n);
            start := float64(myjob-1)*step;
            stop := float64(myjob)*step;
            results(myid) := results(myid)
                           + recursive_rule(circle'access,start,stop,nsteps);
         end loop;
      end worker;

      workers : array(1..p) of worker;

   begin
      null;
   end do_jobs;

   procedure static_run (p : in integer64 := 4) is

      results : vector(1..p);
      est4pi : float64 := 0.0;
      error : float64;

   begin
      run_workers(p,results);
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
   end static_run;

   procedure dynamic_run (p : in integer64 := 4; n : in integer64 := 17) is

      results : vector(1..p) := (1..p => 0.0);
      est4pi : float64 := 0.0;
      error : float64;

   begin
      do_jobs(p,n,results);
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
   end dynamic_run;

end trapezoidal_pi;
