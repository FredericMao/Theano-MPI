source set4theano.sh
# server
host0='cop5' 
device0='gpu3'
if [[ $device0 -ge '4' ]]; then
	numa0=1
else
	numa0=0
fi

# worker
host1='cop5'
device1='gpu0'
if [[ $device1 -ge '4' ]]; then
	numa1=1
else
	numa1=0
fi

# worker
host2='cop5'
device2='gpu1'
if [[ $device2 -ge '4' ]]; then
	numa2=1
else
	numa2=0
fi


# server device default to gpu7, so numactl = 1

# need to use mpirun and ompi-server, otherwise comm.Lookup_names() doesn't work
# See https://www.open-mpi.org/doc/v1.5/man1/ompi-server.1.php
rm ./ompi-server.txt

mpirun --mca mpi_common_cuda_event_max 10000 --mca btl_smcuda_use_cuda_ipc 1 --mca mpi_common_cuda_cumemcpy_async 1 --prefix /opt/sharcnet/openmpi/1.8.7/intel-15.0.3/std -x PYTHONPATH=$PYTHONPATH -x PATH=$PATH -x CPATH=$CPATH -x LIBRARY_PATH=$LIBRARY_PATH -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH --report-uri ./ompi-server.txt -n 1 -host $host0 numactl -N $numa0 python -u ../lib/ASGD_Server.py $device0 : \
	   --mca mpi_common_cuda_event_max 10000 --mca btl_smcuda_use_cuda_ipc 1 --mca mpi_common_cuda_cumemcpy_async 1 --prefix /opt/sharcnet/openmpi/1.8.7/intel-15.0.3/std -x PYTHONPATH=$PYTHONPATH -x PATH=$PATH -x CPATH=$CPATH -x LIBRARY_PATH=$LIBRARY_PATH -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH --ompi-server file:./ompi-server.txt -n 1 -host $host1 numactl -N $numa1 python -u ../lib/ASGD_Worker.py $device1 : \
	   --mca mpi_common_cuda_event_max 10000 --mca btl_smcuda_use_cuda_ipc 1 --mca mpi_common_cuda_cumemcpy_async 1 --prefix /opt/sharcnet/openmpi/1.8.7/intel-15.0.3/std -x PYTHONPATH=$PYTHONPATH -x PATH=$PATH -x CPATH=$CPATH -x LIBRARY_PATH=$LIBRARY_PATH -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH --ompi-server file:./ompi-server.txt -n 1 -host $host2 numactl -N $numa2 python -u ../lib/ASGD_Worker.py $device2
	
