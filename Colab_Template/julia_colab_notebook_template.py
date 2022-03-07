# -*- coding: utf-8 -*-
"""Julia_Colab_Notebook_Template.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/github/ageron/julia_notebooks/blob/master/Julia_Colab_Notebook_Template.ipynb

# <img src="https://github.com/JuliaLang/julia-logo-graphics/raw/master/images/julia-logo-color.png" height="100" /> _Colab Notebook Template_

## Instructions
1. Work on a copy of this notebook: _File_ > _Save a copy in Drive_ (you will need a Google account). Alternatively, you can download the notebook using _File_ > _Download .ipynb_, then upload it to [Colab](https://colab.research.google.com/).
2. If you need a GPU: _Runtime_ > _Change runtime type_ > _Harware accelerator_ = _GPU_.
3. Execute the following cell (click on it and press Ctrl+Enter) to install Julia, IJulia and other packages (if needed, update `JULIA_VERSION` and the other parameters). This takes a couple of minutes.
4. Reload this page (press Ctrl+R, or ⌘+R, or the F5 key) and continue to the next section.

_Notes_:
* If your Colab Runtime gets reset (e.g., due to inactivity), repeat steps 2, 3 and 4.
* After installation, if you want to change the Julia version or activate/deactivate the GPU, you will need to reset the Runtime: _Runtime_ > _Factory reset runtime_ and repeat steps 3 and 4.
"""

# Commented out IPython magic to ensure Python compatibility.
# %%shell
# set -e
# 
# #---------------------------------------------------#
# JULIA_VERSION="1.7.1" # any version ≥ 0.7.0
# JULIA_PACKAGES="IJulia BenchmarkTools Plots"
# JULIA_PACKAGES_IF_GPU="CUDA" # or CuArrays for older Julia versions
# JULIA_NUM_THREADS=2
# #---------------------------------------------------#
# 
# if [ -n "$COLAB_GPU" ] && [ -z `which julia` ]; then
#   # Install Julia
#   JULIA_VER=`cut -d '.' -f -2 <<< "$JULIA_VERSION"`
#   echo "Installing Julia $JULIA_VERSION on the current Colab Runtime..."
#   BASE_URL="https://julialang-s3.julialang.org/bin/linux/x64"
#   URL="$BASE_URL/$JULIA_VER/julia-$JULIA_VERSION-linux-x86_64.tar.gz"
#   wget -nv $URL -O /tmp/julia.tar.gz # -nv means "not verbose"
#   tar -x -f /tmp/julia.tar.gz -C /usr/local --strip-components 1
#   rm /tmp/julia.tar.gz
# 
#   # Install Packages
#   if [ "$COLAB_GPU" = "1" ]; then
#       JULIA_PACKAGES="$JULIA_PACKAGES $JULIA_PACKAGES_IF_GPU"
#   fi
#   for PKG in `echo $JULIA_PACKAGES`; do
#     echo "Installing Julia package $PKG..."
#     julia -e 'using Pkg; pkg"add '$PKG'; precompile;"' &> /dev/null
#   done
# 
#   # Install kernel and rename it to "julia"
#   echo "Installing IJulia kernel..."
#   julia -e 'using IJulia; IJulia.installkernel("julia", env=Dict(
#       "JULIA_NUM_THREADS"=>"'"$JULIA_NUM_THREADS"'"))'
#   KERNEL_DIR=`julia -e "using IJulia; print(IJulia.kerneldir())"`
#   KERNEL_NAME=`ls -d "$KERNEL_DIR"/julia*`
#   mv -f $KERNEL_NAME "$KERNEL_DIR"/julia  
# 
#   echo ''
#   echo "Successfully installed `julia -v`!"
#   echo "Please reload this page (press Ctrl+R, ⌘+R, or the F5 key) then"
#   echo "jump to the 'Checking the Installation' section."
# fi

"""# Checking the Installation
The `versioninfo()` function should print your Julia version and some other info about the system:
"""

versioninfo()

using BenchmarkTools

M = rand(2^11, 2^11)

@btime $M * $M;

if ENV["COLAB_GPU"] == "1"
    using CUDA

    run(`nvidia-smi`)

    # Create a new random matrix directly on the GPU:
    M_on_gpu = CUDA.CURAND.rand(2^11, 2^11)
    @btime $M_on_gpu * $M_on_gpu; nothing
else
    println("No GPU found.")
end

"""# Need Help?

* Learning: https://julialang.org/learning/
* Documentation: https://docs.julialang.org/
* Questions & Discussions:
  * https://discourse.julialang.org/
  * http://julialang.slack.com/
  * https://stackoverflow.com/questions/tagged/julia

If you ever ask for help or file an issue about Julia, you should generally provide the output of `versioninfo()`.

Add new code cells by clicking the `+ Code` button (or _Insert_ > _Code cell_).

Have fun!

<img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia-logo-mask.png" height="100" />
"""