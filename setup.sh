rm -rf build

BUILD_DIR=build
BUILD_TYPE=Release

BUILD_DIR=build
BUILD_TYPE=Debug
BUILD_SHARED_LIBS=ON

FC=gfortran
FFLAGS='-ffree-line-length-none -m64 -std=f2008 -march=native -fbounds-check -fmodule-private -fimplicit-none -finit-real=nan'

BUILD_TESTING=ON
RTE_ENABLE_SP=OFF
KERNEL_MODE=default
FAILURE_THRESHOLD='7.e-4'

cmake -S . -B $BUILD_DIR -G "Ninja" \
        -DCMAKE_Fortran_COMPILER=$FC \
        -DCMAKE_Fortran_FLAGS="$FFLAGS" \
        -DRTE_ENABLE_SP=$RTE_ENABLE_SP \
        -DKERNEL_MODE=$KERNEL_MODE \
        -DBUILD_TESTING=$BUILD_TESTING \
        -DFAILURE_THRESHOLD=$FAILURE_THRESHOLD \
        -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE

cmake --build $BUILD_DIR --parallel

cmake --install $BUILD_DIR --prefix install_test

# The --test-dir option is available only starting CMake 3.20:
# ctest --output-on-failure --test-dir ${BUILD_DIR} -V
ctest -R run_rrtmgp_rfmip_lw --test-dir ${BUILD_DIR} -V
# ctest -R run_allsky_gptclds_sw --test-dir ${BUILD_DIR} -V
