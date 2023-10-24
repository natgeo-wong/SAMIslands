using DrWatson
@quickactivate "TropICS"
using Logging
using Printf

rvec   = [5,10,15,20,30,50]
mldvec = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10]
mkpath(projectdir("exp","prm","IslandRCE"))
tprm   = projectdir("exp","prm","tmp.prm")

for imember = 1 : 10

    mbrstr = @sprintf("%02d",imember)

    oprm = projectdir("run","modifysam","prmtemplates","islandrce-controlstats.prm")
    nprm = projectdir("exp","prm","IslandRCE","control","output$mbrstr.prm")
    open(tprm,"w") do fprm
        open(oprm,"r") do rprm
            s = read(rprm,String)
            s = replace(s,"[xx]"  => mbrstr)
            s = replace(s,"[en]"  => "$(imember)")
            write(fprm,s)
        end
    end
    mkpath(projectdir("exp","prm","IslandRCE","control"))
    mv(tprm,nprm,force=true)
    @info "Creating new IslandRCE prm file control runs member $mbrstr"
    
    for r in rvec, mld in mldvec

        rstr   = @sprintf("%03d",r)
        mldstr = @sprintf("%05.2f",mld)
        fID    = "r_$(rstr)km-mld_$(mldstr)m"
        mkpath(projectdir("exp","prm","IslandRCE","$(fID)"))
        @info "Creating new spinup and statistics output IslandRCE prm files for r = $(rstr), MLD = $(mldstr) member $mbrstr"

        oprm = projectdir("run","modifysam","prmtemplates","islandrce-spinup.prm")
        nprm = projectdir("exp","prm","IslandRCE","$(fID)","spinup$mbrstr.prm")
        open(tprm,"w") do fprm
            open(oprm,"r") do rprm
                s = read(rprm,String)
                s = replace(s,"[r]"   => rstr)
                s = replace(s,"[mld]" => mldstr)
                s = replace(s,"[xx]"  => mbrstr)
                s = replace(s,"[en]"  => "$(imember)")
                write(fprm,s)
            end
        end
        mv(tprm,nprm,force=true)

        oprm = projectdir("run","modifysam","prmtemplates","islandrce-stats.prm")
        nprm = projectdir("exp","prm","IslandRCE","$(fID)","output$mbrstr.prm")
        open(tprm,"w") do fprm
            open(oprm,"r") do rprm
                s = read(rprm,String)
                s = replace(s,"[r]"   => rstr)
                s = replace(s,"[mld]" => mldstr)
                s = replace(s,"[xx]"  => mbrstr)
                s = replace(s,"[en]"  => "$(imember)")
                write(fprm,s)
            end
        end
        mv(tprm,nprm,force=true)

    end

end
