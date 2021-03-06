#!/bin/sh

#use path according to boost installation directory in user machine
export LD_LIBRARY_PATH=/home/aftab/Downloads/boost_1.62_installed/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/cloud/aftab/Downloads/boost_1.62_installed/lib:$LD_LIBRARY_PATH

#dataset path and grammar files path
RULES_DATAFLOW=rules_dataflow
RULES_POINTSTO=rules_pointsto
DATAFLOW_DIR=dataflow
POINTSTO_DIR=pointsto

#arguments
NUMPARTITIONS=2
MEMBUDGET=$1
NUMTHREADS=$2
DATASTRUCTURE="array"
#DATASTRUCTURE="list"
#DATASTRUCTURE="array2"

#DiskSpa test

runDiskSpa(){
	for file in $(ls $1) 
	do
		logFile="log/$file.$NUMPARTITIONS.$MEMBUDGET.$NUMTHREADS.output"
		../bin/comp $1/$file $2 $3 $4 $5 $DATASTRUCTURE > $logFile
		preTime=$(tail -3 $logFile | head -1)
		computeTime=$(tail -2 $logFile | head -1)
		totalTime=$(tail -1 $logFile | head -1)
		totalNewEdges=$(tail -5 $logFile | head -1)
		echo "$file $preTime $computeTime $totalTime $totalNewEdges"
	done		
}

echo "DiskSpa test running..."
runDiskSpa $DATAFLOW_DIR/Apache_Httpd_2.2.18_Dataflow $RULES_DATAFLOW $NUMPARTITIONS $MEMBUDGET $NUMTHREADS 
runDiskSpa $DATAFLOW_DIR/PostgreSQL_8.3.9_Dataflow $RULES_DATAFLOW $NUMPARTITIONS $MEMBUDGET $NUMTHREADS 

runDiskSpa $POINTSTO_DIR/Hdfs_Points-to $RULES_POINTSTO $NUMPARTITIONS $MEMBUDGET $NUMTHREADS
runDiskSpa $POINTSTO_DIR/Mapreduce_Points-to $RULES_POINTSTO $NUMPARTITIONS $MEMBUDGET $NUMTHREADS
runDiskSpa $POINTSTO_DIR/PostgreSQL_8.3.9_Points-to $RULES_POINTSTO $NUMPARTITIONS $MEMBUDGET $NUMTHREADS
runDiskSpa $POINTSTO_DIR/Apache_Httpd_2.2.18_Points-to $RULES_POINTSTO $NUMPARTITIONS $MEMBUDGET $NUMTHREADS

runDiskSpa $DATAFLOW_DIR/Linux_dataflow_data $RULES_DATAFLOW $NUMPARTITIONS $MEMBUDGET $NUMTHREADS 
runDiskSpa $POINTSTO_DIR/Linux_pointsto_data $RULES_POINTSTO $NUMPARTITIONS $MEMBUDGET $NUMTHREADS
echo "DiskSpa test finished"
