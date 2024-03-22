#!/bin/bash

# NOTE: path to save workload data
WL_PATH=$1
# NOTE: what kind of workload do you need?
WL_TYPES=( $2 )
# NOTE: The size of workload
LOAD_WORKLOAD_COUNTS=($3)
RUN_WORKLOAD_COUNTS=($4)

ZIPFIAN=($5)


# YCSB=`pwd`/ycsb-0.17.0/bin/ycsb
YCSB=`pwd`/ycsbc

mkdir -p ${WL_PATH}

echo $WL_TYPES
echo $WORDLOAD_COUNTS

for WL_TYPE in ${WL_TYPES[*]}
do

WORKLOAD=workload${WL_TYPE}

for LOAD_WORKLOAD_COUNT in ${LOAD_WORKLOAD_COUNTS[*]}
do

for RUN_WORKLOAD_COUNT in ${RUN_WORKLOAD_COUNTS[*]}
do



TEMPWORKLOADFILENAME=${WL_PATH}/${WORKLOAD}-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}

if [ ${WORKLOAD} == "workloada" ]
then

# generate workload config

# Yahoo! Cloud System Benchmark
# Workload A: Update heavy workload
#   Application example: Session store recording recent actions
#
#   Read/update ratio: 50/50
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian


cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.5
updateproportion=0.5
scanproportion=0
insertproportion=0

requestdistribution=zipfian
EOF


cat ${TEMPWORKLOADFILENAME}

elif [ ${WORKLOAD} == "workloadlatest" ]
then

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.5
updateproportion=0.5
scanproportion=0
insertproportion=0

requestdistribution=latest
EOF


cat ${TEMPWORKLOADFILENAME}

elif [ ${WORKLOAD} == "workloaduniform" ]
then

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.5
updateproportion=0.5
scanproportion=0
insertproportion=0

requestdistribution=uniform
EOF


cat ${TEMPWORKLOADFILENAME}





elif [ ${WORKLOAD} == "workloadb" ]
then

# generate workload config
# Yahoo! Cloud System Benchmark
# Workload B: Read mostly workload
#   Application example: photo tagging; add a tag is an update, but most operations are to read tags
#
#   Read/update ratio: 95/5
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.95
updateproportion=0.05
scanproportion=0
insertproportion=0

requestdistribution=zipfian
EOF

cat ${TEMPWORKLOADFILENAME}

elif [ ${WORKLOAD} == "workloadc" ]
then

# generate workload config
# Yahoo! Cloud System Benchmark
# Workload C: Read only
#   Application example: user profile cache, where profiles are constructed elsewhere (e.g., Hadoop)
#
#   Read/update ratio: 100/0
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=1
updateproportion=0
scanproportion=0
insertproportion=0

requestdistribution=zipfian
EOF

cat ${TEMPWORKLOADFILENAME}


elif [ ${WORKLOAD} == "workloadd" ]
then

# generate workload config
# Yahoo! Cloud System Benchmark
# Workload D: Read latest workload
#   Application example: user status updates; people want to read the latest
#
#   Read/update/insert ratio: 95/0/5
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: latest

# The insert order for this is hashed, not ordered. The "latest" items may be
# scattered around the keyspace if they are keyed by userid.timestamp. A workload
# which orders items purely by time, and demands the latest, is very different than
# workload here (which we believe is more typical of how people build systems.)

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.95
updateproportion=0
scanproportion=0
insertproportion=0.05

requestdistribution=latest
EOF

cat ${TEMPWORKLOADFILENAME}

elif [ ${WORKLOAD} == "workloade" ]
then

# generate workload config
# Yahoo! Cloud System Benchmark
# Workload E: Short ranges
#   Application example: threaded conversations, where each scan is for the posts in a given thread (assumed to be clustered by thread id)
#
#   Scan/insert ratio: 95/5
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian

# The insert order is hashed, not ordered. Although the scans are ordered, it does not necessarily
# follow that the data is inserted in order. For example, posts for thread 342 may not be inserted contiguously, but
# instead interspersed with posts from lots of other threads. The way the YCSB client works is that it will pick a start
# key, and then request a number of records; this works fine even for hashed insertion.

cat <<EOF > ${TEMPWORKLOADFILENAME}
fieldcount=1
fieldlength=1
recordcount=${LOAD_WORKLOAD_COUNT}
operationcount=${RUN_WORKLOAD_COUNT}
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0
updateproportion=0
scanproportion=0.95
insertproportion=0.05

requestdistribution=zipfian

maxscanlength=100

scanlengthdistribution=uniform
EOF

cat ${TEMPWORKLOADFILENAME}


else

echo ${WORKLOAD} "is not implemented !"
exit

fi 


LOADLOGFILE=${WL_PATH}/${WORKLOAD}-load-${ZIPFIAN}-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}.log
cmd="${YCSB} -db basic -threads 4 -P ${TEMPWORKLOADFILENAME} > ${LOADLOGFILE} 2>&1"
echo $cmd
eval $cmd
./src/log_to_workload.py ${LOADLOGFILE}
rm ${LOADLOGFILE}

# RUNLOGFILE=${WL_PATH}/${WORKLOAD}-run-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}.log
# ${YCSB} -db basic -threads 1 -P ${TEMPWORKLOADFILENAME} > ${RUNLOGFILE} 2>&1
# ./src/log_to_workload.py ${RUNLOGFILE}
# rm ${RUNLOGFILE}

# DELETE Intermediate
# rm ${TEMPWORKLOADFILENAME}
done
done
done
