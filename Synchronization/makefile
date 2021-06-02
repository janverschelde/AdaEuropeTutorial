# With the GNAT Community 2021 compiler, the
# gnatmake -I../Introduction -I../WorkCrew -I../Pipelining main.adb
# ends up with linking the main in the ../Introduction folder
# not the main in this folder, so the instructions have to be
# a bit more explicit to avoid the confusion between the mains.

main:
	gnatmake -c -O3 -gnatp main.adb \
                 -I../Introduction -I../WorkCrew -I../Pipelining
	gnatbind main -I../Introduction -I../WorkCrew -I../Pipelining
	gnatlink main

clean:
	gnatclean main
