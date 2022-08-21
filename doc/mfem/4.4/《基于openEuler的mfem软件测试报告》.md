# 《基于openEuler的mfem软件测试报告》

# 1.规范性自检

项目使用了Artistic Style对文件进行格式化

AStyle，即Artistic Style，是一个可用于C, C++, C++/CLI, Objective‑C, C# 和Java编程语言格式化和美化的工具。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`config/mfem.astylerc`，文件内容如下

```astylerc
# MFEM formatting options for Artistic Style
--style=allman
--indent=spaces=3
--keep-one-line-statements
--keep-one-line-blocks
--pad-header
--max-code-length=80
--max-instatement-indent=80
--min-conditional-indent=0
--indent-col1-comments
--indent-labels
--break-after-logical
--add-brackets
--indent-switches
--convert-tabs
--lineend=linux
--suffix=none
--preserve-date
--formatted
```

对于当前项目，检查代码规范性，可以通过使用AStyle对所有源码进行重新格式化，然后使用git查看文件修改。

统计代码不规范内容。

## 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```python
# -*- coding: utf-8 -*-

import os

print (os.getcwd())

def getAllFiles(targetDir):
    files = []
    listFiles = os.listdir(targetDir)
    for i in range(0, len(listFiles)):
        path = os.path.join(targetDir, listFiles[i])
        if os.path.isdir(path):
            files.extend(getAllFiles(path))
        elif os.path.isfile(path):
            files.append(path)
    return files

all_files=getAllFiles(os.curdir)
type_dict=dict()

for each_file in all_files:
    if os.path.isdir(each_file):
        type_dict.setdefault("文件夹",0)
        type_dict["文件夹"]+=1
    else:
        ext=os.path.splitext(each_file)[1]
        type_dict.setdefault(ext,0)
        type_dict[ext]+=1

for each_type in type_dict.keys():
    print ("当前文件夹下共有【%s】的文件%d个" %(each_type,type_dict[each_type]))
```



在mfem项目根目录下运行,运行结果如下

```bash
[root@dc6-80-067 mfem]# python run.py 
/root/mfem
当前文件夹下共有【】的文件110个
当前文件夹下共有【.in】的文件5个
当前文件夹下共有【.md】的文件9个
当前文件夹下共有【.py】的文件2个
当前文件夹下共有【.cpp】的文件456个
当前文件夹下共有【.xml】的文件4个
当前文件夹下共有【.idx】的文件1个
当前文件夹下共有【.mk】的文件2个
当前文件夹下共有【.cmake】的文件42个
当前文件夹下共有【.coeff】的文件1个
当前文件夹下共有【.pgm】的文件1个
当前文件夹下共有【.yml】的文件19个
当前文件夹下共有【.sh】的文件1个
当前文件夹下共有【.pack】的文件1个
当前文件夹下共有【.txt】的文件36个
当前文件夹下共有【.fms】的文件1个
当前文件夹下共有【.ipynb】的文件1个
当前文件夹下共有【.geo】的文件4个
当前文件夹下共有【.dox】的文件1个
当前文件夹下共有【.okl】的文件1个
当前文件夹下共有【.astylerc】的文件1个
当前文件夹下共有【.h】的文件6个
当前文件夹下共有【.gf】的文件2个
当前文件夹下共有【.bdr】的文件1个
当前文件夹下共有【.png】的文件1个
当前文件夹下共有【.mesh】的文件87个
当前文件夹下共有【.json】的文件3个
当前文件夹下共有【.sample】的文件12个
当前文件夹下共有【.vtk】的文件15个
当前文件夹下共有【.gen】的文件2个
当前文件夹下共有【.vtu】的文件7个
当前文件夹下共有【.cff】的文件1个
当前文件夹下共有【.hpp】的文件216个
当前文件夹下共有【.msh】的文件4个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`hpp`,`h`.

## 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.hpp\|.*\.h\|.*\.cpp" | xargs wc -l
```

统计结果

```bash
  438434 total
```

## 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`, 的所有文件进行格式

```bash
[root@dc6-80-067 mfem]# astyle --project=config/mfem.astylerc -R ./*.cpp,*.h,*.hpp -v
Artistic Style 3.1                                08/18/2022
Project option file  /root/mfem/config/mfem.astylerc
------------------------------------------------------------
Directory  ./*.cpp,*.h,*.hpp
------------------------------------------------------------
Formatted  fem/picojson.h
Formatted  fem/ceed/convection_qf.h
Formatted  general/tinyxml2.cpp
Formatted  general/tinyxml2.h
Formatted  tests/unit/catch.hpp
------------------------------------------------------------
 5 formatted   673 unchanged   3.5 seconds   443,155 lines
```

使用git 对文件格式化修改内容进行统计

```
[root@dc6-80-067 mfem]# git commit -m "fomat update"
[detached HEAD 8b4236103] fomat update
 5 files changed, 28277 insertions(+), 24234 deletions(-)
 rewrite fem/picojson.h (75%)
 rewrite general/tinyxml2.cpp (81%)
 rewrite general/tinyxml2.h (90%)
 rewrite tests/unit/catch.hpp (71%)
[root@dc6-80-067 mfem]# 
```

## 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 94.5%           24234/438434*100%

不通过率: 5.5  %           1-24234/438434*100%

# 2.功能性测试

## 2.1.所选测试案例

mfem内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表树如下

```bash
tests/unit/
├── catch.hpp
├── ceed
│   ├── test_ceed.cpp
│   └── test_ceed_main.cpp
├── CMakeLists.txt
├── cunit_test_main.cpp
├── data
│   ├── quad_append_b64_compress.vtu
│   ├── quad_append_b64.vtu
│   ├── quad_append_raw_compress.vtu
│   ├── quad_append_raw.vtu
│   ├── quad_ascii.vtu
│   ├── quad_binary_compress.vtu
│   ├── quad_binary.vtu
│   └── quad-spiral-q20.mesh
├── fem
│   ├── test_1d_bilininteg.cpp
│   ├── test_2d_bilininteg.cpp
│   ├── test_3d_bilininteg.cpp
│   ├── test_assemblediagonalpa.cpp
│   ├── test_assembly_levels.cpp
│   ├── test_bilinearform.cpp
│   ├── test_blocknonlinearform.cpp
│   ├── test_build_dof_to_arrays.cpp
│   ├── test_calccurlshape.cpp
│   ├── test_calcdivshape.cpp
│   ├── test_calcdshape.cpp
│   ├── test_calcshape.cpp
│   ├── test_calcvshape.cpp
│   ├── test_coefficient.cpp
│   ├── test_datacollection.cpp
│   ├── test_derefine.cpp
│   ├── test_doftrans.cpp
│   ├── test_domain_int.cpp
│   ├── test_eigs.cpp
│   ├── test_estimator.cpp
│   ├── test_face_elem_trans.cpp
│   ├── test_face_permutation.cpp
│   ├── test_fe.cpp
│   ├── test_getderivative.cpp
│   ├── test_get_value.cpp
│   ├── test_intrules.cpp
│   ├── test_intruletypes.cpp
│   ├── test_inversetransform.cpp
│   ├── test_lexicographic_ordering.cpp
│   ├── test_linear_fes.cpp
│   ├── test_lin_interp.cpp
│   ├── test_lor.cpp
│   ├── test_operatorjacobismoother.cpp
│   ├── test_oscillation.cpp
│   ├── test_pa_coeff.cpp
│   ├── test_pa_grad.cpp
│   ├── test_pa_idinterp.cpp
│   ├── test_pa_kernels.cpp
│   ├── test_project_bdr.cpp
│   ├── test_quadf_coef.cpp
│   ├── test_quadinterpolator.cpp
│   ├── test_quadraturefunc.cpp
│   ├── test_r1d_bilininteg.cpp
│   ├── test_r2d_bilininteg.cpp
│   ├── test_sparse_matrix.cpp
│   ├── test_sum_bilin.cpp
│   ├── test_surf_blf.cpp
│   ├── test_tet_reorder.cpp
│   ├── test_transfer.cpp
│   └── test_var_order.cpp
├── general
│   ├── test_array.cpp
│   ├── test_mem.cpp
│   ├── test_text.cpp
│   ├── test_umpire_mem.cpp
│   └── test_zlib.cpp
├── LICENSE_1_0.txt
├── linalg
│   ├── test_cg_indefinite.cpp
│   ├── test_chebyshev.cpp
│   ├── test_complex_operator.cpp
│   ├── test_constrainedsolver.cpp
│   ├── test_direct_solvers.cpp
│   ├── test_hypre_ilu.cpp
│   ├── test_hypre_vector.cpp
│   ├── test_ilu.cpp
│   ├── test_matrix_block.cpp
│   ├── test_matrix_dense.cpp
│   ├── test_matrix_hypre.cpp
│   ├── test_matrix_rectangular.cpp
│   ├── test_matrix_sparse.cpp
│   ├── test_matrix_square.cpp
│   ├── test_ode2.cpp
│   ├── test_ode.cpp
│   ├── test_operator.cpp
│   └── test_vector.cpp
├── makefile
├── mesh
│   ├── test_fms.cpp
│   ├── test_mesh.cpp
│   ├── test_ncmesh.cpp
│   ├── test_periodic_mesh.cpp
│   ├── test_pmesh.cpp
│   └── test_vtu.cpp
├── miniapps
│   ├── test_debug_device.cpp
│   ├── test_sedov.cpp
│   └── test_tmop_pa.cpp
├── pcunit_test_main.cpp
├── punit_test_main.cpp
├── run_unit_tests.hpp
├── unit_test_main.cpp
└── unit_tests.hpp
```

在项目根目录下执行命令来运行单元测试

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1;
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1;
make unittest
```

## 2.2.运行结果

```bash
[root@dc6-80-067 mfem-4.4]# make unittest
make -C tests/unit test
make[1]: Entering directory '/root/build/mfem-4.4/tests/unit'
    Parallel unit tests [ mpirun -np 1 punit_tests ... ]: OK  (18.00s 67520kB)
    Parallel unit tests [ mpirun -np 4 punit_tests ... ]: OK  (7.55s 77440kB)
    Parallel unit tests [ mpirun -np 1 psedov_tests_cpu ... ]: OK  (1.48s 49920kB)
    Parallel unit tests [ mpirun -np 4 psedov_tests_cpu ... ]: OK  (0.63s 67456kB)
    Parallel unit tests [ mpirun -np 1 psedov_tests_debug ... ]: OK  (2.43s 73856kB)
    Parallel unit tests [ mpirun -np 4 psedov_tests_debug ... ]: OK  (3.01s 95296kB)
    Parallel unit tests [ mpirun -np 1 ptmop_pa_tests_cpu ... ]: OK  (2.17s 52928kB)
    Parallel unit tests [ mpirun -np 4 ptmop_pa_tests_cpu ... ]: OK  (0.83s 70336kB)
    Unit tests [ unit_tests ... ]: OK  (16.95s 53440kB)
    Unit tests [ sedov_tests_cpu ... ]: OK  (1.37s 13568kB)
    Unit tests [ sedov_tests_debug ... ]: OK  (2.32s 32256kB)
    Unit tests [ tmop_pa_tests_cpu ... ]: OK  (1.96s 17408kB)
    Unit tests [ tmop_pa_tests_debug ... ]: OK  (9.93s 42944kB)
    Unit tests [ debug_device_tests ... ]: OK  (91.39s 22080kB)
make[1]: Leaving directory '/root/build/mfem-4.4/tests/unit'
[root@dc6-80-067 mfem-4.4]# 
```

测试结果

单元测试运行正常，说明各类型函数和功能都响应正常。测试通过。

# 3.性能测试

## 3.1.测试平台信息对比

|          | arm信息                                       | x86信息                     |
| -------- | --------------------------------------------- | --------------------------- |
| 操作系统 | openEuler 20.09                               | openEuler 21.09             |
| 内核版本 | dc6-80-067 4.19.140-2009.4.0.0048.oe1.aarch64 | 5.10.0-5.10.0.24.oe1.x86_64 |

## 3.2.测试软件环境信息对比

|       | arm信息       | x86信息   |
| ----- | ------------- | --------- |
| gcc   | bisheng 2.1.0 | gcc 9.3.0 |
| mpi   | hmpi1.1.1     | hmpi1.1.1 |
| hyper | 2.25.0        | 2.25.0    |
| metis | 4.0.3         | 4.0.3     |
| mfem  | 4.4           | 4.4       |

## 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 4           | 4        |
| 内存   | 6.7 GB      | 7.5 GB   |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

## 3.4.测试选择的案例：

example 目录下的文件 ex6p.cpp

AMR 的拉普拉斯问题

具有齐次狄利克雷边界条件。根据简单的 ZZ 误差估计器，在以一致（三角形、四面体）或非一致（四边形、六面体）方式局部细化的网格序列上解决了该问题。

代码如下

```bash
#include "mfem.hpp"
#include <fstream>
#include <iostream>

using namespace std;
using namespace mfem;

int main(int argc, char *argv[])
{
   // 1. Initialize MPI and HYPRE.
   Mpi::Init(argc, argv);
   int num_procs = Mpi::WorldSize();
   int myid = Mpi::WorldRank();
   Hypre::Init();

   // 2. Parse command-line options.
   const char *mesh_file = "../data/star.mesh";
   int order = 1;
   bool pa = false;
   const char *device_config = "cpu";
   bool nc_simplices = true;
   int reorder_mesh = 0;
   int max_dofs = 100000;
   bool smooth_rt = true;
   bool restart = false;
   bool visualization = true;

   OptionsParser args(argc, argv);
   args.AddOption(&mesh_file, "-m", "--mesh",
                  "Mesh file to use.");
   args.AddOption(&order, "-o", "--order",
                  "Finite element order (polynomial degree).");
   args.AddOption(&pa, "-pa", "--partial-assembly", "-no-pa",
                  "--no-partial-assembly", "Enable Partial Assembly.");
   args.AddOption(&device_config, "-d", "--device",
                  "Device configuration string, see Device::Configure().");
   args.AddOption(&reorder_mesh, "-rm", "--reorder-mesh",
                  "Reorder elements of the coarse mesh to improve "
                  "dynamic partitioning: 0=none, 1=hilbert, 2=gecko.");
   args.AddOption(&nc_simplices, "-ns", "--nonconforming-simplices",
                  "-cs", "--conforming-simplices",
                  "For simplicial meshes, enable/disable nonconforming"
                  " refinement");
   args.AddOption(&max_dofs, "-md", "--max-dofs",
                  "Stop after reaching this many degrees of freedom.");
   args.AddOption(&smooth_rt, "-rt", "--smooth-rt", "-h1", "--smooth-h1",
                  "Represent the smooth flux in RT or vector H1 space.");
   args.AddOption(&restart, "-res", "--restart", "-no-res", "--no-restart",
                  "Restart computation from the last checkpoint.");
   args.AddOption(&visualization, "-vis", "--visualization", "-no-vis",
                  "--no-visualization",
                  "Enable or disable GLVis visualization.");
   args.Parse();
   if (!args.Good())
   {
      if (myid == 0)
      {
         args.PrintUsage(cout);
      }
      return 1;
   }
   if (myid == 0)
   {
      args.PrintOptions(cout);
   }

   // 3. Enable hardware devices such as GPUs, and programming models such as
   //    CUDA, OCCA, RAJA and OpenMP based on command line options.
   Device device(device_config);
   if (myid == 0) { device.Print(); }

   ParMesh *pmesh;
   if (!restart)
   {
      // 4. Read the (serial) mesh from the given mesh file on all processors.
      //    We can handle triangular, quadrilateral, tetrahedral, hexahedral,
      //    surface and volume meshes with the same code.
      Mesh mesh(mesh_file, 1, 1);

      // 5. A NURBS mesh cannot be refined locally so we refine it uniformly
      //    and project it to a standard curvilinear mesh of order 2.
      if (mesh.NURBSext)
      {
         mesh.UniformRefinement();
         mesh.SetCurvature(2);
      }

      // 6. MFEM supports dynamic partitioning (load balancing) of parallel non-
      //    conforming meshes based on space-filling curve (SFC) partitioning.
      //    SFC partitioning is extremely fast and scales to hundreds of
      //    thousands of processors, but requires the coarse mesh to be ordered,
      //    ideally as a sequence of face-neighbors. The mesh may already be
      //    ordered (like star-hilbert.mesh) or we can order it here. Ordering
      //    type 1 is a fast spatial sort of the mesh, type 2 is a high quality
      //    optimization algorithm suitable for ordering general unstructured
      //    meshes.
      if (reorder_mesh)
      {
         Array<int> ordering;
         switch (reorder_mesh)
         {
            case 1: mesh.GetHilbertElementOrdering(ordering); break;
            case 2: mesh.GetGeckoElementOrdering(ordering); break;
            default: MFEM_ABORT("Unknown mesh reodering type " << reorder_mesh);
         }
         mesh.ReorderElements(ordering);
      }

      // 7. Make sure the mesh is in the non-conforming mode to enable local
      //    refinement of quadrilaterals/hexahedra, and the above partitioning
      //    algorithm. Simplices can be refined either in conforming or in non-
      //    conforming mode. The conforming mode however does not support
      //    dynamic partitioning.
      mesh.EnsureNCMesh(nc_simplices);

      // 8. Define a parallel mesh by partitioning the serial mesh.
      //    Once the parallel mesh is defined, the serial mesh can be deleted.
      pmesh = new ParMesh(MPI_COMM_WORLD, mesh);
   }
   else
   {
      // 9. We can also restart the computation by loading the mesh from a
      //    previously saved check-point.
      string fname(MakeParFilename("ex6p-checkpoint.", myid));
      ifstream ifs(fname);
      MFEM_VERIFY(ifs.good(), "Checkpoint file " << fname << " not found.");
      pmesh = new ParMesh(MPI_COMM_WORLD, ifs);
   }

   int dim = pmesh->Dimension();
   int sdim = pmesh->SpaceDimension();

   MFEM_VERIFY(pmesh->bdr_attributes.Size() > 0,
               "Boundary attributes required in the mesh.");
   Array<int> ess_bdr(pmesh->bdr_attributes.Max());
   ess_bdr = 1;

   // 10. Define a finite element space on the mesh. The polynomial order is
   //     one (linear) by default, but this can be changed on the command line.
   H1_FECollection fec(order, dim);
   ParFiniteElementSpace fespace(pmesh, &fec);

   // 11. As in Example 1p, we set up bilinear and linear forms corresponding to
   //     the Laplace problem -\Delta u = 1. We don't assemble the discrete
   //     problem yet, this will be done in the main loop.
   ParBilinearForm a(&fespace);
   if (pa)
   {
      a.SetAssemblyLevel(AssemblyLevel::PARTIAL);
      a.SetDiagonalPolicy(Operator::DIAG_ONE);
   }
   ParLinearForm b(&fespace);

   ConstantCoefficient one(1.0);

   BilinearFormIntegrator *integ = new DiffusionIntegrator(one);
   a.AddDomainIntegrator(integ);
   b.AddDomainIntegrator(new DomainLFIntegrator(one));

   // 12. The solution vector x and the associated finite element grid function
   //     will be maintained over the AMR iterations. We initialize it to zero.
   ParGridFunction x(&fespace);
   x = 0;

   // 13. Connect to GLVis.
   char vishost[] = "localhost";
   int  visport   = 19916;

   socketstream sout;
   if (visualization)
   {
      sout.open(vishost, visport);
      if (!sout)
      {
         if (myid == 0)
         {
            cout << "Unable to connect to GLVis server at "
                 << vishost << ':' << visport << endl;
            cout << "GLVis visualization disabled.\n";
         }
         visualization = false;
      }

      sout.precision(8);
   }

   // 14. Set up an error estimator. Here we use the Zienkiewicz-Zhu estimator
   //     with L2 projection in the smoothing step to better handle hanging
   //     nodes and parallel partitioning. We need to supply a space for the
   //     discontinuous flux (L2) and a space for the smoothed flux.
   L2_FECollection flux_fec(order, dim);
   ParFiniteElementSpace flux_fes(pmesh, &flux_fec, sdim);
   FiniteElementCollection *smooth_flux_fec = NULL;
   ParFiniteElementSpace *smooth_flux_fes = NULL;
   if (smooth_rt && dim > 1)
   {
      // Use an H(div) space for the smoothed flux (this is the default).
      smooth_flux_fec = new RT_FECollection(order-1, dim);
      smooth_flux_fes = new ParFiniteElementSpace(pmesh, smooth_flux_fec, 1);
   }
   else
   {
      // Another possible option for the smoothed flux space: H1^dim space
      smooth_flux_fec = new H1_FECollection(order, dim);
      smooth_flux_fes = new ParFiniteElementSpace(pmesh, smooth_flux_fec, dim);
   }
   L2ZienkiewiczZhuEstimator estimator(*integ, x, flux_fes, *smooth_flux_fes);

   // 15. A refiner selects and refines elements based on a refinement strategy.
   //     The strategy here is to refine elements with errors larger than a
   //     fraction of the maximum element error. Other strategies are possible.
   //     The refiner will call the given error estimator.
   ThresholdRefiner refiner(estimator);
   refiner.SetTotalErrorFraction(0.7);

   // 16. The main AMR loop. In each iteration we solve the problem on the
   //     current mesh, visualize the solution, and refine the mesh.
   for (int it = 0; ; it++)
   {
      HYPRE_BigInt global_dofs = fespace.GlobalTrueVSize();
      if (myid == 0)
      {
         cout << "\nAMR iteration " << it << endl;
         cout << "Number of unknowns: " << global_dofs << endl;
      }

      // 17. Assemble the right-hand side and determine the list of true
      //     (i.e. parallel conforming) essential boundary dofs.
      Array<int> ess_tdof_list;
      fespace.GetEssentialTrueDofs(ess_bdr, ess_tdof_list);
      b.Assemble();

      // 18. Assemble the stiffness matrix. Note that MFEM doesn't care at this
      //     point that the mesh is nonconforming and parallel.  The FE space is
      //     considered 'cut' along hanging edges/faces, and also across
      //     processor boundaries.
      a.Assemble();

      // 19. Create the parallel linear system: eliminate boundary conditions.
      //     The system will be solved for true (unconstrained/unique) DOFs only.
      OperatorPtr A;
      Vector B, X;

      const int copy_interior = 1;
      a.FormLinearSystem(ess_tdof_list, x, b, A, X, B, copy_interior);

      // 20. Solve the linear system A X = B.
      //     * With full assembly, use the BoomerAMG preconditioner from hypre.
      //     * With partial assembly, use a diagonal preconditioner.
      Solver *M = NULL;
      if (pa)
      {
         M = new OperatorJacobiSmoother(a, ess_tdof_list);
      }
      else
      {
         HypreBoomerAMG *amg = new HypreBoomerAMG;
         amg->SetPrintLevel(0);
         M = amg;
      }
      CGSolver cg(MPI_COMM_WORLD);
      cg.SetRelTol(1e-6);
      cg.SetMaxIter(2000);
      cg.SetPrintLevel(3); // print the first and the last iterations only
      cg.SetPreconditioner(*M);
      cg.SetOperator(*A);
      cg.Mult(B, X);
      delete M;

      // 21. Switch back to the host and extract the parallel grid function
      //     corresponding to the finite element approximation X. This is the
      //     local solution on each processor.
      a.RecoverFEMSolution(X, b, x);

      // 22. Send the solution by socket to a GLVis server.
      if (visualization)
      {
         sout << "parallel " << num_procs << " " << myid << "\n";
         sout << "solution\n" << *pmesh << x << flush;
      }

      if (global_dofs >= max_dofs)
      {
         if (myid == 0)
         {
            cout << "Reached the maximum number of dofs. Stop." << endl;
         }
         break;
      }

      // 23. Call the refiner to modify the mesh. The refiner calls the error
      //     estimator to obtain element errors, then it selects elements to be
      //     refined and finally it modifies the mesh. The Stop() method can be
      //     used to determine if a stopping criterion was met.
      refiner.Apply(*pmesh);
      if (refiner.Stop())
      {
         if (myid == 0)
         {
            cout << "Stopping criterion satisfied. Stop." << endl;
         }
         break;
      }

      // 24. Update the finite element space (recalculate the number of DOFs,
      //     etc.) and create a grid function update matrix. Apply the matrix
      //     to any GridFunctions over the space. In this case, the update
      //     matrix is an interpolation matrix so the updated GridFunction will
      //     still represent the same function as before refinement.
      fespace.Update();
      x.Update();

      // 25. Load balance the mesh, and update the space and solution. Currently
      //     available only for nonconforming meshes.
      if (pmesh->Nonconforming())
      {
         pmesh->Rebalance();

         // Update the space and the GridFunction. This time the update matrix
         // redistributes the GridFunction among the processors.
         fespace.Update();
         x.Update();
      }

      // 26. Inform also the bilinear and linear forms that the space has
      //     changed.
      a.Update();
      b.Update();

      // 27. Save the current state of the mesh every 5 iterations. The
      //     computation can be restarted from this point. Note that unlike in
      //     visualization, we need to use the 'ParPrint' method to save all
      //     internal parallel data structures.
      if ((it + 1) % 5 == 0)
      {
         ofstream ofs(MakeParFilename("ex6p-checkpoint.", myid));
         ofs.precision(8);
         pmesh->ParPrint(ofs);

         if (myid == 0)
         {
            cout << "\nCheckpoint saved." << endl;
         }
      }
   }

   delete smooth_flux_fes;
   delete smooth_flux_fec;
   delete pmesh;

   return 0;
}
```

## 3.5.所用数据集

数据集位于文件 data/star.mesh 中

```
MFEM mesh v1.0

#
# MFEM Geometry Types (see mesh/geom.hpp):
#
# POINT       = 0
# SEGMENT     = 1
# TRIANGLE    = 2
# SQUARE      = 3
# TETRAHEDRON = 4
# CUBE        = 5
#

dimension
2

elements
20
1 3 0 11 26 14
1 3 0 14 27 17
1 3 0 17 28 20
1 3 0 20 29 23
1 3 0 23 30 11
1 3 11 1 12 26
1 3 26 12 3 13
1 3 14 26 13 2
1 3 14 2 15 27
1 3 27 15 5 16
1 3 17 27 16 4
1 3 17 4 18 28
1 3 28 18 7 19
1 3 20 28 19 6
1 3 20 6 21 29
1 3 29 21 9 22
1 3 23 29 22 8
1 3 23 8 24 30
1 3 30 24 10 25
1 3 11 30 25 1

boundary
20
1 1 13 2
1 1 12 3
1 1 16 4
1 1 15 5
1 1 19 6
1 1 18 7
1 1 22 8
1 1 21 9
1 1 25 1
1 1 24 10
1 1 3 13
1 1 1 12
1 1 5 16
1 1 2 15
1 1 7 19
1 1 4 18
1 1 9 22
1 1 6 21
1 1 10 25
1 1 8 24

vertices
31
2
0 0
1 0
0.309017 0.951057
1.30902 0.951057
-0.809017 0.587785
-0.5 1.53884
-0.809017 -0.587785
-1.61803 0
0.309017 -0.951057
-0.5 -1.53884
1.30902 -0.951057
0.5 0
1.15451 0.475529
0.809019 0.951057
0.154508 0.475529
-0.0954915 1.24495
-0.654508 1.06331
-0.404508 0.293893
-1.21352 0.293893
-1.21352 -0.293892
-0.404508 -0.293893
-0.654508 -1.06331
-0.0954915 -1.24495
0.154508 -0.475529
0.809019 -0.951057
1.15451 -0.475529
0.654509 0.475529
-0.25 0.769421
-0.809016 0
-0.25 -0.76942
0.654509 -0.475529
```

## 3.6.单线程

单线程运行测试时间对比（五次运行取平均值）

|                | arm    | x86    |
| -------------- | ------ | ------ |
| 参数最大自由度 | 100000 | 100000 |
| 实际CPU时间    | 18.4s  | 11.3s  |
| 用户时间       | 18.5s  | 12.1s  |

## 3.7.多线程

多线程运行测试时间对比（五次运行取平均值）

|                | arm    | x86    |
| -------------- | ------ | ------ |
| 线程数         | 4      | 4      |
| 参数最大自由度 | 200000 | 200000 |
| 实际CPU时间    | 28.6s  | 22.1s  |
| 用户时间       | 7.5s   | 5.7 s  |

## 3.8.测试总结

性能测试arm平台均在x86平台50%以上

# 4.精度测试

## 4.1.所选测试案例：

使用 MFEM 解决特征值问题 -Delta u = lambda u 与齐次狄利克雷边界条件。

文件位于examples/ex16p.cpp，使用数据集同上为data/star.mesh

代码如下

```cpp
#include "mfem.hpp"
#include <fstream>
#include <iostream>

using namespace std;
using namespace mfem;

int main(int argc, char *argv[])
{
   // 1. Initialize MPI and HYPRE.
   Mpi::Init(argc, argv);
   int num_procs = Mpi::WorldSize();
   int myid = Mpi::WorldRank();
   Hypre::Init();

   // 2. Parse command-line options.
   const char *mesh_file = "../data/star.mesh";
   int ser_ref_levels = 2;
   int par_ref_levels = 1;
   int order = 1;
   int nev = 5;
   int seed = 75;
   bool slu_solver  = false;
   bool sp_solver = false;
   bool cpardiso_solver = false;
   bool visualization = 1;

   OptionsParser args(argc, argv);
   args.AddOption(&mesh_file, "-m", "--mesh",
                  "Mesh file to use.");
   args.AddOption(&ser_ref_levels, "-rs", "--refine-serial",
                  "Number of times to refine the mesh uniformly in serial.");
   args.AddOption(&par_ref_levels, "-rp", "--refine-parallel",
                  "Number of times to refine the mesh uniformly in parallel.");
   args.AddOption(&order, "-o", "--order",
                  "Finite element order (polynomial degree) or -1 for"
                  " isoparametric space.");
   args.AddOption(&nev, "-n", "--num-eigs",
                  "Number of desired eigenmodes.");
   args.AddOption(&seed, "-s", "--seed",
                  "Random seed used to initialize LOBPCG.");
#ifdef MFEM_USE_SUPERLU
   args.AddOption(&slu_solver, "-slu", "--superlu", "-no-slu",
                  "--no-superlu", "Use the SuperLU Solver.");
#endif
#ifdef MFEM_USE_STRUMPACK
   args.AddOption(&sp_solver, "-sp", "--strumpack", "-no-sp",
                  "--no-strumpack", "Use the STRUMPACK Solver.");
#endif
#ifdef MFEM_USE_MKL_CPARDISO
   args.AddOption(&cpardiso_solver, "-cpardiso", "--cpardiso", "-no-cpardiso",
                  "--no-cpardiso", "Use the MKL CPardiso Solver.");
#endif
   args.AddOption(&visualization, "-vis", "--visualization", "-no-vis",
                  "--no-visualization",
                  "Enable or disable GLVis visualization.");
   args.Parse();
   if (slu_solver && sp_solver)
   {
      if (myid == 0)
         cout << "WARNING: Both SuperLU and STRUMPACK have been selected,"
              << " please choose either one." << endl
              << "         Defaulting to SuperLU." << endl;
      sp_solver = false;
   }
   // The command line options are also passed to the STRUMPACK
   // solver. So do not exit if some options are not recognized.
   if (!sp_solver)
   {
      if (!args.Good())
      {
         if (myid == 0)
         {
            args.PrintUsage(cout);
         }
         return 1;
      }
   }
   if (myid == 0)
   {
      args.PrintOptions(cout);
   }

   // 3. Read the (serial) mesh from the given mesh file on all processors. We
   //    can handle triangular, quadrilateral, tetrahedral, hexahedral, surface
   //    and volume meshes with the same code.
   Mesh *mesh = new Mesh(mesh_file, 1, 1);
   int dim = mesh->Dimension();

   // 4. Refine the serial mesh on all processors to increase the resolution. In
   //    this example we do 'ref_levels' of uniform refinement (2 by default, or
   //    specified on the command line with -rs).
   for (int lev = 0; lev < ser_ref_levels; lev++)
   {
      mesh->UniformRefinement();
   }

   // 5. Define a parallel mesh by a partitioning of the serial mesh. Refine
   //    this mesh further in parallel to increase the resolution (1 time by
   //    default, or specified on the command line with -rp). Once the parallel
   //    mesh is defined, the serial mesh can be deleted.
   ParMesh *pmesh = new ParMesh(MPI_COMM_WORLD, *mesh);
   delete mesh;
   for (int lev = 0; lev < par_ref_levels; lev++)
   {
      pmesh->UniformRefinement();
   }

   // 6. Define a parallel finite element space on the parallel mesh. Here we
   //    use continuous Lagrange finite elements of the specified order. If
   //    order < 1, we instead use an isoparametric/isogeometric space.
   FiniteElementCollection *fec;
   if (order > 0)
   {
      fec = new H1_FECollection(order, dim);
   }
   else if (pmesh->GetNodes())
   {
      fec = pmesh->GetNodes()->OwnFEC();
   }
   else
   {
      fec = new H1_FECollection(order = 1, dim);
   }
   ParFiniteElementSpace *fespace = new ParFiniteElementSpace(pmesh, fec);
   HYPRE_BigInt size = fespace->GlobalTrueVSize();
   if (myid == 0)
   {
      cout << "Number of unknowns: " << size << endl;
   }

   // 7. Set up the parallel bilinear forms a(.,.) and m(.,.) on the finite
   //    element space. The first corresponds to the Laplacian operator -Delta,
   //    while the second is a simple mass matrix needed on the right hand side
   //    of the generalized eigenvalue problem below. The boundary conditions
   //    are implemented by elimination with special values on the diagonal to
   //    shift the Dirichlet eigenvalues out of the computational range. After
   //    serial and parallel assembly we extract the corresponding parallel
   //    matrices A and M.
   ConstantCoefficient one(1.0);
   Array<int> ess_bdr;
   if (pmesh->bdr_attributes.Size())
   {
      ess_bdr.SetSize(pmesh->bdr_attributes.Max());
      ess_bdr = 1;
   }

   ParBilinearForm *a = new ParBilinearForm(fespace);
   a->AddDomainIntegrator(new DiffusionIntegrator(one));
   if (pmesh->bdr_attributes.Size() == 0)
   {
      // Add a mass term if the mesh has no boundary, e.g. periodic mesh or
      // closed surface.
      a->AddDomainIntegrator(new MassIntegrator(one));
   }
   a->Assemble();
   a->EliminateEssentialBCDiag(ess_bdr, 1.0);
   a->Finalize();

   ParBilinearForm *m = new ParBilinearForm(fespace);
   m->AddDomainIntegrator(new MassIntegrator(one));
   m->Assemble();
   // shift the eigenvalue corresponding to eliminated dofs to a large value
   m->EliminateEssentialBCDiag(ess_bdr, numeric_limits<double>::min());
   m->Finalize();

   HypreParMatrix *A = a->ParallelAssemble();
   HypreParMatrix *M = m->ParallelAssemble();

#if defined(MFEM_USE_SUPERLU) || defined(MFEM_USE_STRUMPACK)
   Operator * Arow = NULL;
#ifdef MFEM_USE_SUPERLU
   if (slu_solver)
   {
      Arow = new SuperLURowLocMatrix(*A);
   }
#endif
#ifdef MFEM_USE_STRUMPACK
   if (sp_solver)
   {
      Arow = new STRUMPACKRowLocMatrix(*A);
   }
#endif
#endif

   delete a;
   delete m;

   // 8. Define and configure the LOBPCG eigensolver and the BoomerAMG
   //    preconditioner for A to be used within the solver. Set the matrices
   //    which define the generalized eigenproblem A x = lambda M x.
   Solver * precond = NULL;
   if (!slu_solver && !sp_solver && !cpardiso_solver)
   {
      HypreBoomerAMG * amg = new HypreBoomerAMG(*A);
      amg->SetPrintLevel(0);
      precond = amg;
   }
   else
   {
#ifdef MFEM_USE_SUPERLU
      if (slu_solver)
      {
         SuperLUSolver * superlu = new SuperLUSolver(MPI_COMM_WORLD);
         superlu->SetPrintStatistics(false);
         superlu->SetSymmetricPattern(true);
         superlu->SetColumnPermutation(superlu::PARMETIS);
         superlu->SetOperator(*Arow);
         precond = superlu;
      }
#endif
#ifdef MFEM_USE_STRUMPACK
      if (sp_solver)
      {
         STRUMPACKSolver * strumpack = new STRUMPACKSolver(argc, argv, MPI_COMM_WORLD);
         strumpack->SetPrintFactorStatistics(true);
         strumpack->SetPrintSolveStatistics(false);
         strumpack->SetKrylovSolver(strumpack::KrylovSolver::DIRECT);
         strumpack->SetReorderingStrategy(strumpack::ReorderingStrategy::METIS);
         strumpack->DisableMatching();
         strumpack->SetOperator(*Arow);
         strumpack->SetFromCommandLine();
         precond = strumpack;
      }
#endif
#ifdef MFEM_USE_MKL_CPARDISO
      if (cpardiso_solver)
      {
         auto cpardiso = new CPardisoSolver(A->GetComm());
         cpardiso->SetMatrixType(CPardisoSolver::MatType::REAL_STRUCTURE_SYMMETRIC);
         cpardiso->SetPrintLevel(1);
         cpardiso->SetOperator(*A);
         precond = cpardiso;
      }
#endif
   }

   HypreLOBPCG * lobpcg = new HypreLOBPCG(MPI_COMM_WORLD);
   lobpcg->SetNumModes(nev);
   lobpcg->SetRandomSeed(seed);
   lobpcg->SetPreconditioner(*precond);
   lobpcg->SetMaxIter(200);
   lobpcg->SetTol(1e-8);
   lobpcg->SetPrecondUsageMode(1);
   lobpcg->SetPrintLevel(1);
   lobpcg->SetMassMatrix(*M);
   lobpcg->SetOperator(*A);

   // 9. Compute the eigenmodes and extract the array of eigenvalues. Define a
   //    parallel grid function to represent each of the eigenmodes returned by
   //    the solver.
   Array<double> eigenvalues;
   lobpcg->Solve();
   lobpcg->GetEigenvalues(eigenvalues);
   ParGridFunction x(fespace);

   // 10. Save the refined mesh and the modes in parallel. This output can be
   //     viewed later using GLVis: "glvis -np <np> -m mesh -g mode".
   {
      ostringstream mesh_name, mode_name;
      mesh_name << "mesh." << setfill('0') << setw(6) << myid;

      ofstream mesh_ofs(mesh_name.str().c_str());
      mesh_ofs.precision(8);
      pmesh->Print(mesh_ofs);

      for (int i=0; i<nev; i++)
      {
         // convert eigenvector from HypreParVector to ParGridFunction
         x = lobpcg->GetEigenvector(i);

         mode_name << "mode_" << setfill('0') << setw(2) << i << "."
                   << setfill('0') << setw(6) << myid;

         ofstream mode_ofs(mode_name.str().c_str());
         mode_ofs.precision(8);
         x.Save(mode_ofs);
         mode_name.str("");
      }
   }

   // 11. Send the solution by socket to a GLVis server.
   if (visualization)
   {
      char vishost[] = "localhost";
      int  visport   = 19916;
      socketstream mode_sock(vishost, visport);
      mode_sock.precision(8);

      for (int i=0; i<nev; i++)
      {
         if ( myid == 0 )
         {
            cout << "Eigenmode " << i+1 << '/' << nev
                 << ", Lambda = " << eigenvalues[i] << endl;
         }

         // convert eigenvector from HypreParVector to ParGridFunction
         x = lobpcg->GetEigenvector(i);

         mode_sock << "parallel " << num_procs << " " << myid << "\n"
                   << "solution\n" << *pmesh << x << flush
                   << "window_title 'Eigenmode " << i+1 << '/' << nev
                   << ", Lambda = " << eigenvalues[i] << "'" << endl;

         char c;
         if (myid == 0)
         {
            cout << "press (q)uit or (c)ontinue --> " << flush;
            cin >> c;
         }
         MPI_Bcast(&c, 1, MPI_CHAR, 0, MPI_COMM_WORLD);

         if (c != 'c')
         {
            break;
         }
      }
      mode_sock.close();
   }

   // 12. Free the used memory.
   delete lobpcg;
   delete precond;
   delete M;
   delete A;
#if defined(MFEM_USE_SUPERLU) || defined(MFEM_USE_STRUMPACK)
   delete Arow;
#endif

   delete fespace;
   if (order > 0)
   {
      delete fec;
   }
   delete pmesh;

   return 0;
}
```

## 4.2.获得对比数据

arm 运行结果(部分)

```bash
Initial Max. Residual   6.22597304778508e+01
Iteration 1     bsize 5         maxres   8.14500952563639e+00
Iteration 2     bsize 5         maxres   1.58186120365622e+00
Iteration 3     bsize 5         maxres   7.20612486588792e-01
Iteration 4     bsize 5         maxres   4.79133721954905e-01
Iteration 5     bsize 5         maxres   6.47855060390559e-01
Iteration 6     bsize 5         maxres   3.89461841567388e-01
Iteration 7     bsize 5         maxres   1.32866836325373e-01
Iteration 8     bsize 5         maxres   5.47779211140872e-02
Iteration 9     bsize 5         maxres   2.22808172788889e-02
Iteration 10    bsize 5         maxres   8.26812707897509e-03
Iteration 11    bsize 4         maxres   4.60681834106959e-03
Iteration 12    bsize 2         maxres   3.14883000303378e-03
Iteration 13    bsize 2         maxres   2.34502333482461e-03
Iteration 14    bsize 2         maxres   8.58833956290390e-04
Iteration 15    bsize 2         maxres   4.02068859559396e-04
Iteration 16    bsize 2         maxres   2.38331764716424e-04
Iteration 17    bsize 2         maxres   1.13647298392604e-04
Iteration 18    bsize 2         maxres   8.21226611962563e-05
Iteration 19    bsize 2         maxres   5.61947598976011e-05
Iteration 20    bsize 2         maxres   3.39924114003984e-05
Iteration 21    bsize 1         maxres   1.73992653100637e-05
```

x86运行结果(部分)

```bash
Initial Max. Residual   6.22597304778508e+01
Iteration 1     bsize 5         maxres   8.14499424704347e+00
Iteration 2     bsize 5         maxres   1.58184918503312e+00
Iteration 3     bsize 5         maxres   7.20606797821068e-01
Iteration 4     bsize 5         maxres   4.79210647873104e-01
Iteration 5     bsize 5         maxres   6.47960723251003e-01
Iteration 6     bsize 5         maxres   3.89285219601352e-01
Iteration 7     bsize 5         maxres   1.32726564292503e-01
Iteration 8     bsize 5         maxres   5.47088874700843e-02
Iteration 9     bsize 5         maxres   2.22647121321856e-02
Iteration 10    bsize 5         maxres   8.26343158280533e-03
Iteration 11    bsize 4         maxres   4.60288590457887e-03
Iteration 12    bsize 2         maxres   3.15045906060227e-03
Iteration 13    bsize 2         maxres   2.34292416065806e-03
Iteration 14    bsize 2         maxres   8.56280093151789e-04
Iteration 15    bsize 2         maxres   4.00612061400047e-04
Iteration 16    bsize 2         maxres   2.37486649777647e-04
Iteration 17    bsize 2         maxres   1.13166966336497e-04
Iteration 18    bsize 2         maxres   8.17279606516457e-05
Iteration 19    bsize 2         maxres   5.60460050373551e-05
Iteration 20    bsize 2         maxres   3.38855538139852e-05
Iteration 21    bsize 1         maxres   1.73220461344292e-05
```

使用以上数据进行误差计算

```python

x86 = [8.14499424704347,1.58184918503312,7.20606797821068,4.79210647873104,6.47960723251003,3.89285219601352,1.32726564292503,5.47088874700843,2.22647121321856,8.26343158280533,4.60288590457887,3.15045906060227,2.34292416065806,8.56280093151789,4.00612061400047,2.37486649777647,1.13166966336497,8.17279606516457,5.60460050373551,3.38855538139852,1.73220461344292]
arm = [8.14500952563639,1.58186120365622,7.20612486588792,4.79133721954905,6.47855060390559,3.89461841567388,1.32866836325373,5.47779211140872,2.22808172788889,8.26812707897509,4.60681834106959,3.14883000303378,2.34502333482461,8.58833956290390,4.02068859559396,2.38331764716424,1.13647298392604,8.21226611962563,5.61947598976011,3.39924114003984,1.73992653100637]

for i in range(len(arm)):
    print(abs((x86[i]-arm[i]) / x86[i]) * 100, '%')
```

## 4.3.误差运算结果

```bash
0.00018758261154547205 %
0.0007597831205269057 %
0.0007894413071317905 %
0.01605263124692207 %
0.01630698538544704 %
0.0453708379210687 %
0.10568497242259714 %
0.12618360049936483 %
0.07233485260301671 %
0.05682259389101559 %
0.08543415092709378 %
0.05170857761212838 %
0.08959633443535467 %
0.2982509063361347 %
0.36364311005958866 %
0.35585787225017923 %
0.42444546465859473 %
0.4829443209686225 %
0.2654156351498285 %
0.3153485021959367 %
0.44578553269766075 %
```

## 4.4.测试总结

所有运算结果偏差在1%以内，偏差较小。

