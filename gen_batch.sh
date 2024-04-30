WL_PATH='data'
spec_base_path='./mlsm_workloads/'
gen_path='./gen_workload.sh'

# use all spec file to generate workload
files=$(ls $spec_base_path)

files=(
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.2_zipfian.spec" 
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.5_zipfian.spec"
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.9_zipfian.spec"
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.2_zipfian.spec" 
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.5_zipfian.spec"
    "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.9_zipfian.spec"
)

max_jobs=6  # Maximum number of jobs
num_jobs=0  # Current number of jobs

for file in "${files[@]}"; do
    cmd="${gen_path} ${WL_PATH} ${file} &"
    echo $cmd
    eval $cmd

    ((num_jobs++))

    if ((num_jobs == max_jobs)); then
        wait -n
        ((num_jobs--))
    fi
done

wait
