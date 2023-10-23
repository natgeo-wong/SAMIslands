using DrWatson
@quickactivate "TropICS"
using Printf

rvec   = [5,10,15,20,30,50]
mldvec = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]

mrun = projectdir("run","modifysam","runtemplates","modelrun.sh")
brun = projectdir("run","modifysam","runtemplates","Build.csh")

email = ""

open(nrun,"w") do wrun
    sn = replace(s ,"[email]"   => email)
    sn = replace(sn,"[prjname]" => projectdir())
    sn = replace(sn,"[expname]" => "IslandRCE")
    sn = replace(sn,"[runname]" => "control")
    sn = replace(sn,"[sndname]" => "islandrce")
    sn = replace(sn,"[lsfname]" => "control")
    write(wrun,sn)
end

open(mrun,"r") do frun
    s = read(frun,String)
    for r in rvec, mld in mldvec

        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        runname = "r_$(rstr)km-mld_$(mldstr)m"
        srun = projectdir("run","IslandRCE","spinup-$(runname).sh")
        nrun = projectdir("run","IslandRCE","$(runname).sh")

        open(nrun,"w") do wrun
            sn = replace(s ,"[email]"   => email)
            sn = replace(sn,"[prjname]" => projectdir())
            sn = replace(sn,"[expname]" => "IslandRCE")
            sn = replace(sn,"[runname]" => runname)
            sn = replace(sn,"[sndname]" => "islandrce")
            sn = replace(sn,"[lsfname]" => "control")
            write(wrun,sn)
        end

        open(srun,"w") do wrun
            sn = replace(s ,"[email]"   => email)
            sn = replace(sn,"[prjname]" => projectdir())
            sn = replace(sn,"[expname]" => "IslandRCE")
            sn = replace(sn,"[runname]" => "spinup-$(runname)")
            sn = replace(sn,"[sndname]" => "islandrce")
            sn = replace(sn,"[lsfname]" => "control")
            write(wrun,sn)
        end

    end
end

open(brun,"r") do frun
    s = read(frun,String)
    nrun = projectdir("run","IslandRCE","Build.csh")
    open(nrun,"w") do wrun
        sn = replace(s ,"[datadir]" => datadir())
        sn = replace(sn,"[expname]" => "IslandRCE")
        write(wrun,sn)
    end

    for r in rvec, mld in mldvec

        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        runname = "r_$(rstr)km-mld_$(mldstr)m"
        mkpath(datadir("IslandRCE","OUT_2D",runname))
        mkpath(datadir("IslandRCE","OUT_3D",runname))
        mkpath(datadir("IslandRCE","OUT_MOMENTS",runname))
        mkpath(datadir("IslandRCE","OUT_MOVIES",runname))
        mkpath(datadir("IslandRCE","OUT_STAT",runname))
        mkpath(datadir("IslandRCE","RESTART",runname))

    end
end