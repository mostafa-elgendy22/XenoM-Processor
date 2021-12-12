The number of files in the project will be large, So it is better to structure the file into directories
but ModelSim doesn't do this by default, however there is a way to do so by following these instructions:

// Note that the ModelSim project is already created.
- To open the project in modelsim, follow these stpes:
	1- From the top bar of ModelSim, click File >> Open
	2- Go to the project directory "RTL Code"
	3- From the last bar in the shown window, change the "Files of type" to be "Project Files (*.mpf)"
	4- Choose "processor.mpf"

/*
 Note that if you create a folder from ModelSim, it doesn't actually create it but it creates it virtually
 inside the project without actually creating a directory
*/
- If you want to create a new directory then create it manually in the desired location (not from ModelSim) 
then create a new virtual directory in ModelSim project by the following steps:
	1- From the top bar of ModelSim, click Project >> Add to Project >> Folder
	2- Write the virtual directory name (same as the actual created directory)
	3- If this directory is inside another directory, then change the "Folder Location" field to be the name
	   of the other directory

- If you want to create a new file then create it manually (not from ModelSim) in the desired directory then add
it to the ModelSim project by the following steps:
	1- From the top bar of ModelSim, click Project >> Add to Project >> Existing File
	2- Choose the file location by clicking Browse
	3- Change the "Folder" field to be the name of the virtual directory
