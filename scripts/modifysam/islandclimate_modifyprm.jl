using DrWatson
@quickactivate "TropICS"
using Logging
using Printf

rvec   = [2,3,5,7,10,15,20,30,50]
mldvec = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]
mkpath(projectdir("exp","prm","IslandClimate"))
tprm   = projectdir("exp","prm","tmp.prm")

cp(
    projectdir("run","modifysam","prmtemplates","islandclimate-control.prm"),
    projectdir("exp","prm","IslandClimate","control.prm")
)

for r in rvec, mld in mldvec
    rstr   = @sprintf("%03d",r)
    mldstr = @sprintf("%05.2f",mld)
    fID    = "r_$(rstr)km-mld_$(mldstr)m"

    oprm = projectdir("run","modifysam","prmtemplates","islandclimate-spinup.prm")
    nprm = projectdir("exp","prm","IslandClimate","spinup-$(fID).prm")
    open(tprm,"w") do fprm
        open(oprm,"r") do rprm
            s = read(rprm,String)
            s = replace(s,"[r]"   => rstr)
            s = replace(s,"[mld]" => mldstr)
            write(fprm,s)
        end
    end
    mv(tprm,nprm,force=true)
    @info "Creating new spinupIslandClimate prm file for r = $(rstr), MLD = $(mldstr)"

    oprm = projectdir("run","modifysam","prmtemplates","islandclimate.prm")
    nprm = projectdir("exp","prm","IslandClimate","$(fID).prm")
    open(tprm,"w") do fprm
        open(oprm,"r") do rprm
            s = read(rprm,String)
            s = replace(s,"[r]"   => rstr)
            s = replace(s,"[mld]" => mldstr)
            write(fprm,s)
        end
    end
    mv(tprm,nprm,force=true)
    @info "Creating new spinupIslandClimate prm file for r = $(rstr), MLD = $(mldstr)"

end
