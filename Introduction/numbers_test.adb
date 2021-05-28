with text_io;
with number_types;
with integer64_io;
with float64_io;

procedure numbers_test is

  use number_types;

  smallest : constant integer64 := -2**63;
  largest : constant integer64 := 2**63-1;
  macheps : constant float64 := 2.0**(-52);
  macheps2 : constant float64 := macheps/2.0;

begin
  text_io.put_line("Welcome to Programming Parallel Shared Memory Computers!");
  text_io.put_line("Checking the 64-bit number types ...");
  text_io.put("the smallest 64-bit integer is "); 
  integer64_io.put(smallest,1); text_io.new_line;
  text_io.put("             integer64'first : ");
  integer64_io.put(integer64'first,1); text_io.new_line;
  text_io.put(" the largest 64-bit integer is +"); 
  integer64_io.put(largest,1); text_io.new_line;
  text_io.put("              integer64'last : +"); 
  integer64_io.put(integer64'last,1); text_io.new_line;
  text_io.put("the machine precision : ");
  float64_io.put(macheps,1,3,3); text_io.new_line;
  text_io.put("1.0 plus once the machine precision : ");
  float64_io.put(1.0 + macheps,1,17,3); text_io.new_line;
  text_io.put("1.0 plus half the machine precision : ");
  float64_io.put(1.0 + macheps2,1,17,3); text_io.new_line;
end numbers_test;
