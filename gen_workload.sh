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


TEMPWORKLOADFILENAME=${WL_PATH}/${WORKLOAD}-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}
spec_dir='./mlsm_workloads/'
# pushd $spec_dir
# for file  in ${spec_dir}/*.spec; do
file=./mlsm_workloads/workloada_65536kb_100GB_0.9_zipfian.spec
  # moreve .spec from file
  file_name=$(basename $file)
  workload_name=${file_name%.spec}
  echo $workload_name
  TEMPWORKLOADFILENAME=$file
  LOADLOGFILE=${WL_PATH}/${workload_name}.log
  echo $file
  # cmd="${YCSB} -db basic -threads 4 -P ${TEMPWORKLOADFILENAME} > ${LOADLOGFILE} 2>&1"
  cmd="${YCSB} -db basic -threads 4 -P ${TEMPWORKLOADFILENAME} > ${LOADLOGFILE}"
  echo $cmd
  eval $cmd
  ./src/log_to_workload.py ${LOADLOGFILE}
  rm ${LOADLOGFILE}

#
  # echo $f
  # cat $f >> ${TEMPWORKLOADFILENAME}
# done
# popd
exit

# LOADLOGFILE=${WL_PATH}/${WORKLOAD}-load-${ZIPFIAN}-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}.log
# cmd="${YCSB} -db basic -threads 4 -P ${TEMPWORKLOADFILENAME} > ${LOADLOGFILE} 2>&1"
# echo $cmd
# eval $cmd
# ./src/log_to_workload.py ${LOADLOGFILE}
# rm ${LOADLOGFILE}
#

# RUNLOGFILE=${WL_PATH}/${WORKLOAD}-run-${LOAD_WORKLOAD_COUNT}-${RUN_WORKLOAD_COUNT}.log
# ${YCSB} -db basic -threads 1 -P ${TEMPWORKLOADFILENAME} > ${RUNLOGFILE} 2>&1
# ./src/log_to_workload.py ${RUNLOGFILE}
# rm ${RUNLOGFILE}

# DELETE Intermediate
# rm ${TEMPWORKLOADFILENAME}
