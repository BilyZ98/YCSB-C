WL_PATH='data'
spec_base_path='./mlsm_workloads/'
gen_path='./gen_workload.sh'

# use all spec file to generate workload
files=$(ls $spec_base_path)

files=(

    /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_test_0.2.spec
    /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_test_0.9.spec
    /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_test_var.spec
    # 200GB 0.99 - 1024 4096 16384 65536
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSBA_200GB_0.99/workloada_200GB_0.99_1024_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSBA_200GB_0.99/workloada_200GB_0.99_4096_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSBA_200GB_0.99/workloada_200GB_0.99_16384_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSBA_200GB_0.99/workloada_200GB_0.99_65536_zipfian.spec

    # YCSB ABCDEF
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloada_100M_0.99_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloadb_100M_0.99_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloadc_100M_0.99_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloadd_100M_0.99_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloade_100M_0.99_zipfian.spec
    # /mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/YCSB_100M_0.99/workloadf_100M_0.99_zipfian.spec

    # 50M 100M - 0.2 0.5 0.9 load = write / 10
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_50M_0.2_zipfian.spec" 
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_50M_0.5_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_50M_0.9_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_100M_0.2_zipfian.spec" 
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_100M_0.5_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloadanew_100M_0.9_zipfian.spec"

    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.2_zipfian.spec" 
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.5_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_50M_0.9_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.2_zipfian.spec" 
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.5_zipfian.spec"
    # "/mnt/nvme1n1/xq/YCSB-C/mlsm_workloads/workloada_100M_0.9_zipfian.spec"
)

max_jobs=4  # Maximum number of jobs
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
