using DrWatson
@quickactivate "TropICS"
using Printf

include(srcdir("sam.jl"))

s0vec  = [0,250,1361/pi,500,750,1361*2/pi,1000,1250,1361]
rvec   = [10,20,40]
mldvec = [0.01,0.02,0.05,0.1,0.2,0.5,1]

mrun = projectdir("run","modifysam","runtemplates","modelrun.sh")
brun = projectdir("run","modifysam","runtemplates","Build.csh")

open(mrun,"r") do frun
    s = read(frun,String)
    for s0 in s0vec, r in rvec, mld in mldvec

        s0str  = @sprintf("%04d",s0)
        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        nrun = projectdir("run","DGW",expname,pwrname,"ensemble$(mstr).sh")

        open(nrun,"w") do wrun
            sn = replace(s ,"[email]"   => )
            sn = replace(sn,"[prjname]" => projectdir())
            sn = replace(sn,"[expname]" => "IslandBreeze")
            sn = replace(sn,"[runname]" => "r_$(rstr)km-mld_$(mldstr)m")
            sn = replace(sn,"[sndname]" => "control")
            sn = replace(sn,"[lsfname]" => "control")
            write(wrun,sn)
        end

    end
end

open(brun,"r") do frun
    s = read(frun,String)
    for pwrii in pwrvec

        pwrname = dampingstrprnt(pwrii)
        nrun = projectdir("run","DGW",expname,pwrname,"Build.csh")

        open(nrun,"w") do wrun
            sn = replace(s ,"[datadir]" => datadir())
            sn = replace(sn,"[schname]" => "DGW")
            sn = replace(sn,"[expname]" => expname)
            write(wrun,sn)
        end

    end
end