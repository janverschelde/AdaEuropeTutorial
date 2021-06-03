# With the GNAT Community 2021 compiler, the
# gnatmake -I../Introduction -I../WorkCrew -I../Pipelining main.adb
# ends up with linking the main in the ../Introduction folder
# not the main in this folder, so the instructions have to be
# a bit more explicit to avoid the confusion between the mains.

SOURCE=../src
INTRO=../../Introduction/src
WORK=../../WorkCrew/src
PIPE=../../Pipelining/src

main:
	gnatmake -c $(SOURCE)/main.adb -I$(INTRO) -I$(WORK) -I$(PIPE)
	gnatbind main -I$(INTRO) -I$(WORK) -I$(PIPE)
	gnatlink main

clean:
	gnatclean main
