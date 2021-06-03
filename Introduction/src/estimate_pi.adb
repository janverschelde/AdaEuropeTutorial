with System.Multiprocessors;
with Text_IO;
with integer64_io;
with float64_io;
with Ada.Calendar;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Numerics;

package body estimate_pi is

   procedure random (seed : in out integer64; number : out float64) is

      a     : constant integer64 := 16_807;
      m     : constant integer64 := 2_147_483_647;
      p     : constant integer64 := a * seed;
      pmodm : constant integer64 := p mod m;

   begin
      seed   := pmodm;
      number := float64 (seed) / float64 (m);
   end random;

   function coinflips (frequency : integer64) return integer64 is

      result : integer64 := 0;
      seed   : integer64 := 12_345;
      number : float64;

   begin
      for i in 1 .. frequency loop
         random (seed, number);
         result := result + integer64 (number);
      end loop;
      return result;
   end coinflips;

   procedure test (frequency : in integer64 := 1_000) is

      now : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      s   : integer64 := integer64 (Ada.Calendar.Seconds (now));
      nbr : integer64                  := 0;

   begin
      Text_IO.Put ("Flipping ");
      integer64_io.Put (frequency, 1);
      Text_IO.Put_Line (" times a coin ...");
      nbr := coinflips (frequency);
      Text_IO.Put ("number of heads : ");
      integer64_io.Put (nbr, 1);
      Text_IO.New_Line;
   end test;

   function incircle (x, y : float64) return Boolean is
   begin
      return (x * x + y * y <= 1.0);
   end incircle;

   procedure count
     (seed      : in out integer64; sum : in out integer64;
      frequency : in     integer64 := freq1second)
   is

      x, y : float64;

   begin
      for k in 1 .. frequency loop
         random (seed, x);
         random (seed, y);
         if incircle (x, y) then
            sum := sum + 1;
         end if;
      end loop;
   end count;

   procedure arguments (freqnbr : out integer64; workers : out integer64) is

      argcnt : constant integer64 :=
        integer64 (Ada.Command_Line.Argument_Count);

   begin
      if argcnt = 0 then
         freqnbr := 1;
         workers := 1;
      elsif argcnt = 1 then
         declare
            arg1 : constant String := Ada.Command_Line.Argument (1);
            sarg : constant Ada.Strings.Unbounded.Unbounded_String :=
              Ada.Strings.Unbounded.To_Unbounded_String (arg1);
         begin
            freqnbr :=
              integer64'value (Ada.Strings.Unbounded.To_String (sarg));
            workers := 1;
         end;
      else
         declare
            arg1  : constant String := Ada.Command_Line.Argument (1);
            arg2  : constant String := Ada.Command_Line.Argument (2);
            sarg1 : constant Ada.Strings.Unbounded.Unbounded_String :=
              Ada.Strings.Unbounded.To_Unbounded_String (arg1);
            sarg2 : constant Ada.Strings.Unbounded.Unbounded_String :=
              Ada.Strings.Unbounded.To_Unbounded_String (arg2);
         begin
            freqnbr :=
              integer64'value (Ada.Strings.Unbounded.To_String (sarg1));
            workers :=
              integer64'value (Ada.Strings.Unbounded.To_String (sarg2));
         end;
      end if;
   end arguments;

   procedure hello_tasks (p : in integer64 := 4) is

      task type worker (idnbr : integer64);

      task body worker is
      begin
         Text_IO.Put_Line ("Task" & integer64'image (idnbr) & " says hello.");
      end worker;

      procedure launch (i : in integer64) is

         w : worker (i);

      begin
         if i < p then
            launch (i + 1);
         end if;
      end launch;

   begin
      Text_IO.put("Number of CPUs : ");
      integer64_io.put(integer64(System.Multiprocessors.Number_of_CPUs),1);
      Text_IO.new_line;
      Text_IO.Put_Line ("Launching tasks ...");
      launch (1);
      Text_IO.Put_Line ("Launched" & integer64'image (p) & " tasks.");
   end hello_tasks;

   procedure parallel_count
     (p         : in integer64;
      seeds     : in out vector; sums : in out vector;
      frequency : in integer64 := freq1second) is

      task type worker (idnbr : integer64);

      task body worker is
      begin
         count (seeds (idnbr), sums (idnbr), frequency);
      end worker;

      procedure launch (i : in integer64) is

         w : worker (i);

      begin
         if i < p then
            launch (i + 1);
         end if;
      end launch;

   begin
      launch (1);
   end parallel_count;

   procedure run is

      use number_types;

      now                  : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      s : integer64                  := integer64 (Ada.Calendar.Seconds (now));
      sum                  : integer64                  := 0;
      ratio, est4pi, error : float64;
      freq, prcs           : integer64;

   begin
      Text_IO.Put_Line
        ("Welcome to Programming Parallel Shared Memory Computers!");
      Text_IO.Put ("estimating");
      float64_io.Put (Ada.Numerics.Pi);
      Text_IO.New_Line;
      arguments (freq, prcs);
      freq := freq * freq1second;
      if prcs = 1 then
         count (s, sum, freq);
         ratio := float64 (sum) / float64 (freq);
      else
         declare
            sums  : estimate_pi.vector (1 .. prcs) := (1 .. prcs => 0);
            seeds : estimate_pi.vector (1 .. prcs);
         begin
            seeds (1) := s;
            for k in 2 .. prcs loop
               seeds (k) := s + k;
            end loop;
            parallel_count (prcs, seeds, sums, freq);
            ratio := float64 (sums (1)) / float64 (prcs * freq);
            for k in 2 .. prcs loop
               ratio := ratio + float64 (sums (k)) / float64 (prcs * freq);
            end loop;
         end;
      end if;
      est4pi := 4.0 * ratio;
      Text_IO.Put ("estimate :");
      float64_io.Put (est4pi);
      error := abs (Ada.Numerics.Pi - est4pi);
      Text_IO.Put ("  error : ");
      float64_io.Put (error, 1, 3, 3);
      Text_IO.New_Line;
      Text_IO.Put ("frequency : ");
      integer64_io.Put (freq, 1);
      Text_IO.Put ("  number of workers : ");
      integer64_io.Put (prcs, 1);
      Text_IO.New_Line;
   end run;

end estimate_pi;
