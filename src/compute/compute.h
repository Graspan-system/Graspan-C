#ifndef COMPUTE_H
#define COMPUTE_H

#include <boost/asio/io_service.hpp>
#include <boost/thread/thread.hpp>
#include <boost/bind.hpp>
#include "computationset.h"
#include "array/arraystomerge.h"
#include "list/liststomerge.h"
#include "array2/arraystomerge.h"
#include "containerstomerge.h"
#include "../datastructures/partition.h"
#include "../common.h"

class Compute {
private:
	long oneRoundEdges;
	long numAddedEdgesP;
	long numAddedEdgesQ;
	long totalAddedEdges; // only used for log 

	std::mutex comp_mtx;
	std::condition_variable cv;
	short numFinished;
	bool compFinished;

public:
	Compute();
	void loadTwoPartition(Partition &p,Partition &q,partitionid_t new_pid,partitionid_t new_qid,Context &c);
	void initComputationSet(ComputationSet &compset,Partition &p,Partition &q,Context &c);
	bool scheduler(partitionid_t &p,partitionid_t &q,Context &c);
	
	long computeOneRound(ComputationSet &compset,Context &c,boost::asio::io_service &ioServ,bool &isFinished);
	void computeOneIteration(ComputationSet &compset,int segsize,int nSegs,Context &c,boost::asio::io_service &ioServ);
	void runUpdates(int lower,int upper,int nSegs,ComputationSet &compset,Context &c);
	long computeOneVertex(vertexid_t index,ComputationSet &compset,Context &c);		
	void postProcessOneIteration(ComputationSet &compset);

	void getEdgesToMerge(vertexid_t index,ComputationSet &compset,bool oldEmpty,bool deltaEmpty,ContainersToMerge &containers,Context &c);
	void genS_RuleEdges(vertexid_t index,ComputationSet &compset,ContainersToMerge &containers,Context &c);
	void genD_RuleEdges(vertexid_t index,ComputationSet &compset,ContainersToMerge &containers,Context &c,bool isOld);
	void checkEdges(vertexid_t dstInd,char dstVal,ComputationSet &compset,ContainersToMerge &containers,Context &c,bool isOld);
	
	void updatePartitions(ComputationSet &compset,Partition &p,Partition &q,bool isFinished,Context &c);
	void updateSinglePartition(ComputationSet &compset,Partition &p,bool isFinished,Context &c,bool isP);

	void repartAndUpdateVIT(Partition &p,Context &c,bool &compIsFinished,int &numSubPartition,bool isP);
	void repartAndUpdateDDM(Partition &p,Partition &q,Context &c,bool &compIsFinished);
	void writeRepartitionsToFile(Partition &p,Context &c,partitionid_t p_start,partitionid_t p_end);

	long startCompute(Context &c);	// return newTotalEdges;

	void writeAllPartitionsToTxtFile(Context &c);
};
#endif
