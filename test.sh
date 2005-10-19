#!sh
perl randam3.pl 0.txt 2.txt 1.txt
perl merge.pl 0.txt 2.txt 1.txt >pl.txt
diff3 -A -m 0.txt 2.txt 1.txt >d3.txt
diff d3.txt pl.txt
