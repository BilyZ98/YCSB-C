source_dir=/mnt/nvme1n1/xq/YCSB-C/data
# source_paths=($(ls ${source_dir}/*.log_run.formated))
source_paths=(
    # "/mnt/nvme1n1/xq/YCSB-C/data/workloada_200GB_0.99_1024_zipfian.log_run.formated"
    # "/mnt/nvme1n1/xq/YCSB-C/data/workloada_200GB_0.99_4096_zipfian.log_run.formated"
    # "/mnt/nvme1n1/xq/YCSB-C/data/workloada_200GB_0.99_16384_zipfian.log_run.formated"
    # "/mnt/nvme1n1/xq/YCSB-C/data/workloada_200GB_0.99_65536_zipfian.log_run.formated"
    
    "/mnt/nvme1n1/xq/YCSB-C/data/workloada_100M_0.99_zipfian.log_load.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadb_100M_0.99_zipfian.log_load.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadc_100M_0.99_zipfian.log_load.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadd_100M_0.99_zipfian.log_load.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloade_100M_0.99_zipfian.log_load.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadf_100M_0.99_zipfian.log_load.formated"

    "/mnt/nvme1n1/xq/YCSB-C/data/workloada_100M_0.99_zipfian.log_run.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadb_100M_0.99_zipfian.log_run.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadc_100M_0.99_zipfian.log_run.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadd_100M_0.99_zipfian.log_run.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloade_100M_0.99_zipfian.log_run.formated"
    "/mnt/nvme1n1/xq/YCSB-C/data/workloadf_100M_0.99_zipfian.log_run.formated"
)

target_users=(
    "xq" # ctb3
    "xq" # dfs_2
    "xq" # dfs_3
    "xq" # dfs_4
    "ubuntu" # dfs_5
)
target_hosts=(
    "ctb3" # ctb3
    "dfs_2" # dfs_2
    "dfs_3" # dfs_3
    "dfs_4" # dfs_4
    "dfs_5" # dfs_5
)
target_paths=(
    "/mnt/nvme/YCSB-C/data/" # ctb3
    "/mnt/nvme0n1/YCSB-C/data/" # dfs_2
    "/mnt/nvme0n1/YCSB-C/data/" # dfs_3
    "/mnt/nvme0n1/YCSB-C/data/" # dfs_4
    "/mnt/nvme0n1/YCSB-C/data/" # dfs_5
)

max_jobs=5  # Maximum number of jobs
num_jobs=0  # Current number of jobs

for source_path in ${source_paths[@]}; do
    for i in $(seq 0 $((${#target_hosts[@]}-1))); do
        cmd="scp ${source_path} ${target_users[i]}@${target_hosts[i]}:${target_paths[i]} &"
        echo $cmd
        eval $cmd

        ((num_jobs++))

        if ((num_jobs == max_jobs)); then
            wait -n
            ((num_jobs--))
        fi
    done
done

wait
