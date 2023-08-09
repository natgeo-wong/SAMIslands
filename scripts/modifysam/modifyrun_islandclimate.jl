using DrWatson
@quickactivate "TropICS"
using Printf

rvec   = [10,15,20,30,50,70,100]
mldvec = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]

mrun = projectdir("run","modifysam","runtemplates","modelrun.sh")
brun = projectdir("run","modifysam","runtemplates","Build.csh")

open(mrun,"r") do frun
    s = read(frun,String)
    for r in rvec, mld in mldvec

        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        runname = "r_$(rstr)km-mld_$(mldstr)m"
        nrun = projectdir("run","IslandClimate","$(runname).sh")

        open(nrun,"w") do wrun
            sn = replace(s ,"[email]"   => )
            sn = replace(sn,"[prjname]" => projectdir())
            sn = replace(sn,"[expname]" => "IslandClimate")
            sn = replace(sn,"[runname]" => runname)
            sn = replace(sn,"[sndname]" => "control")
            sn = replace(sn,"[lsfname]" => "control")
            write(wrun,sn)
        end

    end
end

open(brun,"r") do frun
    s = read(frun,String)
    nrun = projectdir("run","IslandClimate","Build.csh")
    open(nrun,"w") do wrun
        sn = replace(s ,"[datadir]" => datadir())
        sn = replace(sn,"[expname]" => "IslandClimate")
        write(wrun,sn)
    end

    for r in rvec, mld in mldvec

        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        runname = "r_$(rstr)km-mld_$(mldstr)m"
        mkpath(datadir("IslandClimate","OUT_2D",runname))
        mkpath(datadir("IslandClimate","OUT_3D",runname))
        mkpath(datadir("IslandClimate","OUT_MOMENTS",runname))
        mkpath(datadir("IslandClimate","OUT_MOVIES",runname))
        mkpath(datadir("IslandClimate","OUT_STAT",runname))
        mkpath(datadir("IslandClimate","RESTART",runname))

    end
end