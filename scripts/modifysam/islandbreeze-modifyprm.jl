using DrWatson
@quickactivate "TropICS"
using Logging
using Printf

s0vec  = [0,250,1361/pi,500,750,1361*2/pi,1000,1250,1361]
rvec   = [10,15,20,30,50,70,100]
mldvec = [0.01,0.1,1,10]
mkpath(projectdir("exp","prm","LandSeaBreeze"))
tprm   = projectdir("exp","prm","tmp.prm")

for s0 in s0vec, r in rvec, mld in mldvec
    s0str  = @sprintf("%04d",s0)
    rstr   = @sprintf("%03d",r)
    mldstr = @sprintf("%05.2f",mld)
    fID    = "s0_$(s0str)-r_$(rstr)-mld_$(mldstr)"
    for imember = 1 : 15
        mstr = @sprintf("%02d",imember)
        oprm = projectdir("run","modifysam","prmtemplates","landseabreeze.prm")
        nprm = projectdir("exp","prm","LandSeaBreeze","$(fID).prm")
        open(tprm,"w") do fprm
            open(oprm,"r") do rprm
                s = read(rprm,String)
                s = replace(s,"[s0]"  => s0str)
                s = replace(s,"[r]"   => rstr)
                s = replace(s,"[mld]" => mldstr)
                write(fprm,s)
            end
        end
        mv(tprm,nprm,force=true)
        @info "Creating new prm file for S0 = $(s0str), r = $(rstr), MLD = $(mldstr)"
    end
end
