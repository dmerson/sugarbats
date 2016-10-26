# sugarbats
Data for the INFO 505 Class from Dr. Heidorn in 2016
# what's here
This is data taken from an experiment about migritory bats. 
# Data
There are files that have already been cleaned.

The file names are the date of the data gathering with .txt.
THese files have already been cleaned.

There is a header on them:
%%%DateTime	ms since program start
2016-10-20T18:25:36.252-07:00	904
2235	-1
2236	-2
2237	-3
2238	-4
2238	-5
2238	-6

This line is the time the device was able to gather data and the millisecond it took to establish a telnet connection.

There are 6 sensors. When the sensor's light gets broke, it sends its number. When the sensor is restablished, it sends the negative number. 
For example, number has a bat lick sends the 1st sensor a 1 with the milliseconds since startup. When the bats finishs, it sends a -1 with the milliseconds.
So in the following example:
42876	1
43274	-1
Something licked the first sensor 42 minutes and 876 milliseconds after 8:25:36
Or about 9:07 (you can do the exact math)

# Other programs
To playback the pde file, you will need to install the processing IDE at:

https://processing.org/download/?processing 


If you try to run the pde file in the root directory, it give you a message that it will move it to the batplackback folder. I just used the one in the bat playback folder and pointed to a file that existed in the directory and it seems to work. I will Dr. Heidorn decide if that is correct or not.
