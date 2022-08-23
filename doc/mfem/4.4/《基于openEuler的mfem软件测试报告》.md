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

|        | arm信息     | x86信息    |
| ------ | ----------- | ---------- |
| cpu    | Kunpeng 920 |           |
| 核心数 | 16          | 4         |
| 内存   | 32 GB       | 8 GB      |
| 磁盘io | 1.3 GB/s    | 400 MB/s   |
| 虚拟化 | KVM         | KVM        |

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

参数最大自由度设置为400000时，

arm多线程时间耗费数据表：

| 线程       | 1     | 2     | 3       | 4       | 5      | 6      | 7     | 8      | 9      | 10      | 11     | 12     | 13      | 14     | 15     | 16     |
| :--------- | ----- | ----- | ------- | ------- | ------ | ------ | ----- | ------ | ------ | ------- | ------ | ------ | ------- | ------ | ------ | ------ |
| 用户时间(s)   | 80.15 | 48.99 | 34.719  | 26.21   | 21.37  | 18.138 | 15.38 | 13.66  | 12.57  | 11.32   | 10.29  | 9.67   | 8.94    | 8.66   | 8.083  | 7.75   |
| 用户态时间(s) | 79.73 | 97.4  | 103.372 | 103.887 | 105.31 | 107.55 | 106.3 | 107.72 | 111.39 | 111.419 | 111.44 | 113.56 | 114.229 | 118.42 | 118.91 | 121.31 |
| 内核态时间(s) | 0.17  | 0.22  | 0.22    | 0.24    | 0.248  | 0.32   | 0.3   | 0.39   | 0.37   | 0.37    | 0.48   | 0.49   | 0.46    | 0.61   | 0.53   | 0.6    |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程大于10之后，每次减少的用户时间都少于1s，且系统调用的时间有较为明显的上升趋势。

![image-20220822211048259](data:image/png;base64,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)



x86多线程时间耗费数据表：

| 线程            | 1     | 2     | 3     | 4     |
| --------------- | ----- | ----- | ----- | ----- |
| 用户时间 （s）  | 48.29 | 32.5  | 27.23 | 22.35 |
| 用户态时间（s） | 47.2  | 63.32 | 79.5  | 87.41 |
| 内核态时间（s） | 0.89  | 1.28  | 1.52  | 1.23  |

![image-20220823175149755](data:image/png;base64,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)

不同平台相同案例实际运行时间对比：

![image-20220823180010903](data:image/png;base64,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)

## 3.8.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

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

