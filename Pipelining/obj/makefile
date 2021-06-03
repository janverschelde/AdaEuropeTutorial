# With the GNAT Community 2021 compiler, the
# gnatmake -I../Introduction -I../WorkCrew main.adb
# ends up with linking the main in the ../Introduction folder
# not the main in this folder, so the instructions have to be
# a bit more explicit to avoid the confusion between the mains.

SOURCE=../src
INTRO=../../Introduction/src
WORK=../../WorkCrew/src

main:
	gnatmake -c -O3 -gnatp $(SOURCE)/main.adb -I$(INTRO) -I$(WORK)
	gnatbind main -I$(INTRO) -I$(WORK)
	gnatlink main

clean:
	gnatclean main
