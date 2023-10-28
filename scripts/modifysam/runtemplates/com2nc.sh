#!/bin/sh 

##SBATCH -p test         # short jobs, time limit 8 hours
##SBATCH -p huce_intel   # cheap, slower, no time limit
##SBATCH -p huce_cascade # expensive, faster, no time limit
##SBATCH -p shared       # longer jobs, 7 days, use only when needed

#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem-per-cpu=8GB # memory pool for each core
#SBATCH -t 0 # time (D-HH:MM)

#SBATCH -J "SAM_com2nc"
#SBATCH --mail-user=[email]
#SBATCH --mail-type=ALL
#SBATCH -o ./LOGS/com2nc.%j.out # STDOUT
#SBATCH -e ./LOGS/com2nc.%j.err # STDERR

module purge
module load intel/23.0.0-fasrc01 intelmpi/2021.8.0-fasrc01 netcdf-fortran/4.6.0-fasrc03

cd ./OUT_3D

for config in RCE_TropICS-IslandRCE-[runname]-*/;
do
    cd "$config"
    for fcom3D in *.com3D
    do
        if com3D2nc "$fcom3D" >& /dev/null
        then
            echo "Processing SAM com3D output file $fcom3D ... done"
            rm "$fcom3D"
        else
            echo "Processing SAM com3D output file $fcom3D ... failed"
        fi
    done

    for fcom2D in *.com2D
    do
        if com2D2nc "$fcom2D" >& /dev/null
        then
            echo "Processing SAM com2D output file $fcom2D ... done"
            rm "$fcom2D"
        else
            echo "Processing SAM bin2D output file $fcom2D ... failed"
        fi
    done

    cd ..
done

cd ../OUT_2D

for config in RCE_TropICS-IslandRCE-[runname]-*/;
do
    cd "$config"
    for f2Dcom in *.2Dcom
    do
        if 2Dcom2nc "$f2Dcom" >& /dev/null
        then
            echo "Processing SAM 2Dcom output file $f2Dcom ... done"
            rm "$f2Dcom"
        else
            echo "Processing SAM 2Dcom output file $f2Dcom ... failed"
        fi
    done
    cd ..
done

cd ../OUT_STAT

for fstat in RCE_TropICS-IslandRCE-[runname]-*.stat
do
    if stat2nc "$fstat" >& /dev/null
    then
        echo "Processing SAM STAT  output file $fstat ... done"
        rm "$fstat"
    else
        echo "Processing SAM STAT  output file $fstat ... failed"
    fi
done

for config in RCE_TropICS-IslandRCE-[runname]-*/;
do
    cd "$config"
    for fstat in *.stat
    do
        if stat2nc "$fstat" >& /dev/null
        then
            echo "Processing SAM STAT  output file $fstat ... done"
            rm "$fstat"
        else
            echo "Processing SAM STAT  output file $fstat ... failed"
        fi
    done
    cd ..
done

cd ..

exit 0