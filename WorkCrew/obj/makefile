# With the GNAT Community 2021 compiler, the 
# gnatmake -I../Introduction main.adb
# ends up with linking the main in the ../Introduction folder
# not the main in this folder, so the instructions have to be
# a bit more explicit to avoid the confusion between the mains.

SOURCE=../src
INTRO=../../Introduction/src

main:
	gnatmake -c -O3 -gnatp -I$(INTRO) $(SOURCE)/main.adb
	gnatbind main -I$(INTRO)
	gnatlink main

clean:
	gnatclean main
