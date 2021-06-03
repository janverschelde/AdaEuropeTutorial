package body Semaphore is

   protected body Binary_Semaphore is

      function Is_Available return Boolean is
      begin
         return available;
      end Is_Available;

      entry Seize when available is
      begin
         available := False;
      end Seize;

      procedure Release is
      begin
         available := True;
      end Release;

   end Binary_Semaphore;

   function Available (s : Lock) return Boolean is
   begin
      return s.b.Is_Available;
   end Available;

   procedure Request (s : in out Lock) is
   begin
      s.b.Seize;
   end Request;

   procedure Release (s : in out Lock) is
   begin
      s.b.Release;
   end Release;

end Semaphore;
