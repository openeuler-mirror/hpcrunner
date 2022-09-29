# 基于openEuler的Elmer软件测试报告

## 规范性自检

项目使用了Artistic Style对文件进行格式化

AStyle，即Artistic Style，是一个可用于C, C++, C++/CLI, Objective‑C, C# 和Java编程语言格式化和美化的工具。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`config/elmer.astylerc`，文件内容如下

```astylerc
# ELMER formatting options for Artistic Style
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

### 选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```
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

在`Elmer`项目根目录下运行,运行结果如下:

```
分析文件夹：/home/season/elmerfem-scc20_kml
当前文件夹下共有后缀名为【.cmake】的文件3282个
当前文件夹下共有后缀名为【空】的文件2542个
当前文件夹下共有后缀名为【.f】的文件1589个
当前文件夹下共有后缀名为【.sif】的文件1443个
当前文件夹下共有后缀名为【.make】的文件1230个
当前文件夹下共有后缀名为【.txt】的文件1127个
当前文件夹下共有后缀名为【.grd】的文件1047个
当前文件夹下共有后缀名为【.o】的文件971个
当前文件夹下共有后缀名为【.c】的文件748个
当前文件夹下共有后缀名为【.marks】的文件663个
当前文件夹下共有后缀名为【.d】的文件483个
当前文件夹下共有后缀名为【.internal】的文件468个
当前文件夹下共有后缀名为【.F90】的文件453个
当前文件夹下共有后缀名为【.nodes】的文件380个
当前文件夹下共有后缀名为【.elements】的文件380个
当前文件夹下共有后缀名为【.boundary】的文件380个
当前文件夹下共有后缀名为【.header】的文件380个
当前文件夹下共有后缀名为【.h】的文件337个
当前文件夹下共有后缀名为【.png】的文件290个
当前文件夹下共有后缀名为【.gif】的文件268个
当前文件夹下共有后缀名为【.ts】的文件248个
当前文件夹下共有后缀名为【.cpp】的文件247个
当前文件夹下共有后缀名为【.so】的文件230个
当前文件夹下共有后缀名为【.html】的文件177个
当前文件夹下共有后缀名为【.msh】的文件138个
当前文件夹下共有后缀名为【.f90】的文件136个
当前文件夹下共有后缀名为【.names】的文件123个
当前文件夹下共有后缀名为【.hpp】的文件123个
当前文件夹下共有后缀名为【.dat】的文件105个
当前文件夹下共有后缀名为【.stamp】的文件104个
当前文件夹下共有后缀名为【.mod】的文件103个
当前文件夹下共有后缀名为【.build】的文件100个
当前文件夹下共有后缀名为【.geo】的文件58个
当前文件夹下共有后缀名为【.jpg】的文件56个
当前文件夹下共有后缀名为【.definitions】的文件49个
当前文件夹下共有后缀名为【.tcl】的文件39个
当前文件夹下共有后缀名为【.eg】的文件33个
当前文件夹下共有后缀名为【.xml】的文件33个
当前文件夹下共有后缀名为【.shared】的文件33个
当前文件夹下共有后缀名为【.in2d】的文件30个
当前文件夹下共有后缀名为【.ui】的文件28个
当前文件夹下共有后缀名为【.director】的文件24个
当前文件夹下共有后缀名为【.sh】的文件24个
当前文件夹下共有后缀名为【.lua】的文件22个
当前文件夹下共有后缀名为【.mif】的文件21个
当前文件夹下共有后缀名为【.xy】的文件19个
当前文件夹下共有后缀名为【.out】的文件17个
当前文件夹下共有后缀名为【.py】的文件15个
当前文件夹下共有后缀名为【.ico】的文件14个
当前文件夹下共有后缀名为【.rc】的文件13个
当前文件夹下共有后缀名为【.cm】的文件13个
当前文件夹下共有后缀名为【.pro】的文件12个
当前文件夹下共有后缀名为【.ttf】的文件12个
当前文件夹下共有后缀名为【.log】的文件9个
当前文件夹下共有后缀名为【.1】的文件9个
当前文件夹下共有后缀名为【.0】的文件8个
当前文件夹下共有后缀名为【.bat】的文件8个
当前文件夹下共有后缀名为【.IN】的文件8个
当前文件夹下共有后缀名为【.a】的文件7个
当前文件夹下共有后缀名为【.result】的文件7个
当前文件夹下共有后缀名为【.in】的文件7个
当前文件夹下共有后缀名为【.md】的文件7个
当前文件夹下共有后缀名为【.step】的文件6个
当前文件夹下共有后缀名为【.stl】的文件6个
当前文件夹下共有后缀名为【.umf】的文件6个
当前文件夹下共有后缀名为【.prb】的文件5个
当前文件夹下共有后缀名为【.cnd】的文件5个
当前文件夹下共有后缀名为【.mat】的文件5个
当前文件夹下共有后缀名为【.m】的文件5个
当前文件夹下共有后缀名为【.off】的文件5个
当前文件夹下共有后缀名为【.smesh】的文件5个
当前文件夹下共有后缀名为【.cam】的文件5个
当前文件夹下共有后缀名为【.cc】的文件5个
当前文件夹下共有后缀名为【.lin】的文件4个
当前文件夹下共有后缀名为【.sif_old】的文件4个
当前文件夹下共有后缀名为【.src】的文件4个
当前文件夹下共有后缀名为【.qrc】的文件4个
当前文件夹下共有后缀名为【.ply】的文件4个
当前文件夹下共有后缀名为【.terms】的文件4个
当前文件夹下共有后缀名为【.sed】的文件4个
当前文件夹下共有后缀名为【.F】的文件3个
当前文件夹下共有后缀名为【.bin】的文件3个
当前文件夹下共有后缀名为【.poly】的文件3个
当前文件夹下共有后缀名为【.brep】的文件3个
当前文件夹下共有后缀名为【.cxx】的文件3个
当前文件夹下共有后缀名为【.graph】的文件3个
当前文件夹下共有后缀名为【.dep】的文件3个
当前文件夹下共有后缀名为【.rua】的文件3个
当前文件夹下共有后缀名为【.pvsm】的文件3个
当前文件夹下共有后缀名为【.def】的文件2个
当前文件夹下共有后缀名为【.KEYWORDS】的文件2个
当前文件夹下共有后缀名为【.dat_ref】的文件2个
当前文件夹下共有后缀名为【.pos】的文件2个
当前文件夹下共有后缀名为【.good】的文件2个
当前文件夹下共有后缀名为【.best0】的文件2个
当前文件夹下共有后缀名为【.data】的文件2个
当前文件夹下共有后缀名为【.ep】的文件2个
当前文件夹下共有后缀名为【.ini】的文件2个
当前文件夹下共有后缀名为【.qs】的文件2个
当前文件夹下共有后缀名为【.stp】的文件2个
当前文件夹下共有后缀名为【.iges】的文件2个
当前文件夹下共有后缀名为【.ac】的文件2个
当前文件夹下共有后缀名为【.BMP】的文件2个
当前文件夹下共有后缀名为【.pdf】的文件2个
当前文件夹下共有后缀名为【.old】的文件2个
当前文件夹下共有后缀名为【.mac】的文件2个
当前文件夹下共有后缀名为【.lst】的文件2个
当前文件夹下共有后缀名为【.css】的文件2个
当前文件夹下共有后缀名为【.2】的文件2个
当前文件夹下共有后缀名为【.3】的文件2个
当前文件夹下共有后缀名为【.check_cache】的文件1个
当前文件夹下共有后缀名为【.commented】的文件1个
当前文件夹下共有后缀名为【.yml】的文件1个
当前文件夹下共有后缀名为【.pri】的文件1个
当前文件夹下共有后缀名为【.xcf】的文件1个
当前文件夹下共有后缀名为【.yy】的文件1个
当前文件夹下共有后缀名为【.ll】的文件1个
当前文件夹下共有后缀名为【.icc】的文件1个
当前文件夹下共有后缀名为【.unv】的文件1个
当前文件夹下共有后缀名为【.mphtxt】的文件1个
当前文件夹下共有后缀名为【.node】的文件1个
当前文件夹下共有后缀名为【.mtr】的文件1个
当前文件夹下共有后缀名为【.FDNEUT】的文件1个
当前文件夹下共有后缀名为【.gz】的文件1个
当前文件夹下共有后缀名为【.p】的文件1个
当前文件夹下共有后缀名为【.m4】的文件1个
当前文件夹下共有后缀名为【.cur】的文件1个
当前文件夹下共有后缀名为【.LOG】的文件1个
当前文件夹下共有后缀名为【.bmp】的文件1个
当前文件夹下共有后缀名为【.rgb】的文件1个
当前文件夹下共有后缀名为【.xmi】的文件1个
当前文件夹下共有后缀名为【.jpeg】的文件1个
当前文件夹下共有后缀名为【.dockerfile】的文件1个
当前文件夹下共有后缀名为【.mesh】的文件1个
当前文件夹下共有后缀名为【.mgraph】的文件1个
当前文件夹下共有后缀名为【.ans】的文件1个
当前文件夹下共有后缀名为【.bas】的文件1个
当前文件夹下共有后缀名为【.sim】的文件1个
当前文件夹下共有后缀名为【.cua】的文件1个
当前文件夹下共有后缀名为【.psa】的文件1个
当前文件夹下共有后缀名为【.umf4】的文件1个
当前文件夹下共有后缀名为【.inc】的文件1个
当前文件夹下共有后缀名为【.dvi】的文件1个
当前文件夹下共有后缀名为【.tex】的文件1个
当前文件夹下共有后缀名为【.ps】的文件1个
当前文件夹下共有后缀名为【.Po】的文件1个
当前文件夹下共有后缀名为【.script】的文件1个
当前文件夹下共有后缀名为【.pc】的文件1个
当前文件夹下共有后缀名为【.text】的文件1个
当前文件夹下共有后缀名为【.global】的文件1个
当前文件夹下共有后缀名为【.nc】的文件1个
当前文件夹下共有后缀名为【.checkL】的文件1个
当前文件夹下共有后缀名为【.checkB】的文件1个
当前文件夹下共有后缀名为【.pairs】的文件1个
```

###  统计源码总行数

统计所有源码文件的代码行数

```
 find ./ -regex ".*\.hpp\|.*\.h\|.*\.cpp" | xargs wc -l
```

统计结果:

```
2582464 total
```

### 统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`, 的所有文件进行格式

```
Artistic Style 3.1                                09/02/2022
Project option file  /home/season/elmerfem-scc20_kml/config/elmer.astylerc
------------------------------------------------------------
Directory  ./*.cpp,*.h,*.hpp
------------------------------------------------------------
Formatted  ElmerGUI/Application/cad/cadpreferences.cpp
Formatted  ElmerGUI/Application/cad/cadpreferences.h
Formatted  ElmerGUI/Application/cad/cadview.cpp
Formatted  ElmerGUI/Application/cad/cadview.h
Formatted  ElmerGUI/Application/plugins/egconvert.cpp
Formatted  ElmerGUI/Application/plugins/egconvert.h
Formatted  ElmerGUI/Application/plugins/egdef.h
Formatted  ElmerGUI/Application/plugins/egmain.cpp
Formatted  ElmerGUI/Application/plugins/egmain.h
Formatted  ElmerGUI/Application/plugins/egmesh.cpp
Formatted  ElmerGUI/Application/plugins/egmesh.h
Formatted  ElmerGUI/Application/plugins/egnative.cpp
Formatted  ElmerGUI/Application/plugins/egnative.h
Formatted  ElmerGUI/Application/plugins/egtypes.h
Formatted  ElmerGUI/Application/plugins/egutils.cpp
Formatted  ElmerGUI/Application/plugins/egutils.h
Formatted  ElmerGUI/Application/plugins/elmergrid_api.cpp
Formatted  ElmerGUI/Application/plugins/elmergrid_api.h
Formatted  ElmerGUI/Application/plugins/nglib_api.cpp
Formatted  ElmerGUI/Application/plugins/nglib_api.h
Formatted  ElmerGUI/Application/plugins/tetgen.h
Formatted  ElmerGUI/Application/plugins/tetlib_api.cpp
Formatted  ElmerGUI/Application/plugins/tetlib_api.h
Formatted  ElmerGUI/Application/src/bodypropertyeditor.cpp
Formatted  ElmerGUI/Application/src/bodypropertyeditor.h
Formatted  ElmerGUI/Application/src/boundarydivision.cpp
Formatted  ElmerGUI/Application/src/boundarydivision.h
Formatted  ElmerGUI/Application/src/boundarypropertyeditor.cpp
Formatted  ElmerGUI/Application/src/boundarypropertyeditor.h
Formatted  ElmerGUI/Application/src/checkmpi.cpp
Formatted  ElmerGUI/Application/src/checkmpi.h
Formatted  ElmerGUI/Application/src/convergenceview.cpp
Formatted  ElmerGUI/Application/src/convergenceview.h
Formatted  ElmerGUI/Application/src/dynamiceditor.cpp
Formatted  ElmerGUI/Application/src/dynamiceditor.h
Formatted  ElmerGUI/Application/src/edfeditor.cpp
Formatted  ElmerGUI/Application/src/edfeditor.h
Formatted  ElmerGUI/Application/src/egini.cpp
Formatted  ElmerGUI/Application/src/egini.h
Formatted  ElmerGUI/Application/src/generalsetup.cpp
Formatted  ElmerGUI/Application/src/generalsetup.h
Formatted  ElmerGUI/Application/src/glcontrol.cpp
Formatted  ElmerGUI/Application/src/glcontrol.h
Formatted  ElmerGUI/Application/src/glwidget.cpp
Formatted  ElmerGUI/Application/src/glwidget.h
Formatted  ElmerGUI/Application/src/helpers.cpp
Formatted  ElmerGUI/Application/src/helpers.h
Formatted  ElmerGUI/Application/src/main.cpp
Formatted  ElmerGUI/Application/src/mainwindow.cpp
Formatted  ElmerGUI/Application/src/mainwindow.h
Formatted  ElmerGUI/Application/src/materiallibrary.cpp
Formatted  ElmerGUI/Application/src/materiallibrary.h
Formatted  ElmerGUI/Application/src/maxlimits.cpp
Formatted  ElmerGUI/Application/src/maxlimits.h
Formatted  ElmerGUI/Application/src/meshcontrol.cpp
Formatted  ElmerGUI/Application/src/meshcontrol.h
Formatted  ElmerGUI/Application/src/meshingthread.cpp
Formatted  ElmerGUI/Application/src/meshingthread.h
Formatted  ElmerGUI/Application/src/meshtype.cpp
Formatted  ElmerGUI/Application/src/meshtype.h
Formatted  ElmerGUI/Application/src/meshutils.cpp
Formatted  ElmerGUI/Application/src/meshutils.h
Formatted  ElmerGUI/Application/src/newprojectdialog.cpp
Formatted  ElmerGUI/Application/src/newprojectdialog.h
Formatted  ElmerGUI/Application/src/objectbrowser.cpp
Formatted  ElmerGUI/Application/src/objectbrowser.h
Formatted  ElmerGUI/Application/src/operation.cpp
Formatted  ElmerGUI/Application/src/operation.h
Formatted  ElmerGUI/Application/src/parallel.cpp
Formatted  ElmerGUI/Application/src/parallel.h
Formatted  ElmerGUI/Application/src/projectio.cpp
Formatted  ElmerGUI/Application/src/projectio.h
Formatted  ElmerGUI/Application/src/sifgenerator.cpp
Formatted  ElmerGUI/Application/src/sifgenerator.h
Formatted  ElmerGUI/Application/src/sifwindow.cpp
Formatted  ElmerGUI/Application/src/sifwindow.h
Formatted  ElmerGUI/Application/src/solverlogwindow.cpp
Formatted  ElmerGUI/Application/src/solverlogwindow.h
Formatted  ElmerGUI/Application/src/solverparameters.cpp
Formatted  ElmerGUI/Application/src/solverparameters.h
Formatted  ElmerGUI/Application/src/summaryeditor.cpp
Formatted  ElmerGUI/Application/src/summaryeditor.h
Formatted  ElmerGUI/Application/twod/curveeditor.cpp
Formatted  ElmerGUI/Application/twod/curveeditor.h
Formatted  ElmerGUI/Application/twod/renderarea.cpp
Formatted  ElmerGUI/Application/twod/renderarea.h
Formatted  ElmerGUI/Application/twod/twodview.cpp
Formatted  ElmerGUI/Application/twod/twodview.h
Formatted  ElmerGUI/Application/vtkpost/axes.cpp
Formatted  ElmerGUI/Application/vtkpost/axes.h
Formatted  ElmerGUI/Application/vtkpost/colorbar.cpp
Formatted  ElmerGUI/Application/vtkpost/colorbar.h
Formatted  ElmerGUI/Application/vtkpost/ecmaconsole.cpp
Formatted  ElmerGUI/Application/vtkpost/ecmaconsole.h
Formatted  ElmerGUI/Application/vtkpost/epmesh.cpp
Formatted  ElmerGUI/Application/vtkpost/epmesh.h
Formatted  ElmerGUI/Application/vtkpost/featureedge.cpp
Formatted  ElmerGUI/Application/vtkpost/featureedge.h
Formatted  ElmerGUI/Application/vtkpost/isocontour.cpp
Formatted  ElmerGUI/Application/vtkpost/isocontour.h
Formatted  ElmerGUI/Application/vtkpost/isosurface.cpp
Formatted  ElmerGUI/Application/vtkpost/isosurface.h
Formatted  ElmerGUI/Application/vtkpost/matc.cpp
Formatted  ElmerGUI/Application/vtkpost/matc.h
Formatted  ElmerGUI/Application/vtkpost/mc.h
Formatted  ElmerGUI/Application/vtkpost/meshedge.cpp
Formatted  ElmerGUI/Application/vtkpost/meshedge.h
Formatted  ElmerGUI/Application/vtkpost/meshpoint.cpp
Formatted  ElmerGUI/Application/vtkpost/meshpoint.h
Formatted  ElmerGUI/Application/vtkpost/preferences.cpp
Formatted  ElmerGUI/Application/vtkpost/preferences.h
Formatted  ElmerGUI/Application/vtkpost/readepfile.cpp
Formatted  ElmerGUI/Application/vtkpost/readepfile.h
Formatted  ElmerGUI/Application/vtkpost/streamline.cpp
Formatted  ElmerGUI/Application/vtkpost/streamline.h
Formatted  ElmerGUI/Application/vtkpost/surface.cpp
Formatted  ElmerGUI/Application/vtkpost/surface.h
Formatted  ElmerGUI/Application/vtkpost/text.cpp
Formatted  ElmerGUI/Application/vtkpost/text.h
Formatted  ElmerGUI/Application/vtkpost/timestep.cpp
Formatted  ElmerGUI/Application/vtkpost/timestep.h
Formatted  ElmerGUI/Application/vtkpost/vector.cpp
Formatted  ElmerGUI/Application/vtkpost/vector.h
Formatted  ElmerGUI/Application/vtkpost/vtkpost.cpp
Formatted  ElmerGUI/Application/vtkpost/vtkpost.h
Formatted  ElmerGUI/PythonQt/src/PythonQt.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQt.h
Formatted  ElmerGUI/PythonQt/src/PythonQtClassInfo.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtClassInfo.h
Formatted  ElmerGUI/PythonQt/src/PythonQtConversion.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtConversion.h
Formatted  ElmerGUI/PythonQt/src/PythonQtCppWrapperFactory.h
Formatted  ElmerGUI/PythonQt/src/PythonQtDoc.h
Formatted  ElmerGUI/PythonQt/src/PythonQtImportFileInterface.h
Formatted  ElmerGUI/PythonQt/src/PythonQtImporter.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtImporter.h
Formatted  ElmerGUI/PythonQt/src/PythonQtMetaObjectWrapper.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtMetaObjectWrapper.h
Formatted  ElmerGUI/PythonQt/src/PythonQtMethodInfo.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtMethodInfo.h
Formatted  ElmerGUI/PythonQt/src/PythonQtMisc.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtMisc.h
Formatted  ElmerGUI/PythonQt/src/PythonQtObjectPtr.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtObjectPtr.h
Formatted  ElmerGUI/PythonQt/src/PythonQtSignalReceiver.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtSignalReceiver.h
Formatted  ElmerGUI/PythonQt/src/PythonQtSlot.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtSlot.h
Formatted  ElmerGUI/PythonQt/src/PythonQtStdDecorators.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtStdDecorators.h
Formatted  ElmerGUI/PythonQt/src/PythonQtStdOut.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtStdOut.h
Formatted  ElmerGUI/PythonQt/src/PythonQtSystem.h
Formatted  ElmerGUI/PythonQt/src/PythonQtVariantWrapper.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtVariantWrapper.h
Formatted  ElmerGUI/PythonQt/src/PythonQtVariants.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtVariants.h
Formatted  ElmerGUI/PythonQt/src/PythonQtWrapper.cpp
Formatted  ElmerGUI/PythonQt/src/PythonQtWrapper.h
Formatted  ElmerGUI/PythonQt/src/gui/PythonQtScriptingConsole.cpp
Formatted  ElmerGUI/PythonQt/src/gui/PythonQtScriptingConsole.h
Formatted  ElmerGUI/PythonQt/src/wrapper/PythonQtWrappedVariants.h
Formatted  ElmerGUI/matc/config.h
Formatted  ElmerGUI/matc/src/str.h
Formatted  ElmerGUI/matc/src/elmer/fnames.h
Formatted  ElmerGUI/matc/src/elmer/gra.h
Formatted  ElmerGUI/matc/src/elmer/matc.h
Formatted  ElmerGUI/netgen/libsrc/csg/algprim.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/algprim.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/brick.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/brick.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/bspline2d.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/csgeom.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/csgeom.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/csgparser.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/csgparser.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/curve2d.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/curve2d.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/edgeflw.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/edgeflw.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/explicitcurve2d.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/explicitcurve2d.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/extrusion.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/extrusion.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/gencyl.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/gencyl.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/genmesh.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/identify.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/identify.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/manifold.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/manifold.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/meshsurf.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/meshsurf.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/polyhedra.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/polyhedra.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/revolution.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/revolution.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/singularref.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/singularref.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/solid.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/solid.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/specpoin.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/specpoin.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/spline3d.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/spline3d.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/surface.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/surface.hpp
Formatted  ElmerGUI/netgen/libsrc/csg/triapprox.cpp
Formatted  ElmerGUI/netgen/libsrc/csg/triapprox.hpp
Formatted  ElmerGUI/netgen/libsrc/general/array.cpp
Formatted  ElmerGUI/netgen/libsrc/general/array.hpp
Formatted  ElmerGUI/netgen/libsrc/general/autodiff.hpp
Formatted  ElmerGUI/netgen/libsrc/general/autoptr.hpp
Formatted  ElmerGUI/netgen/libsrc/general/bitarray.cpp
Formatted  ElmerGUI/netgen/libsrc/general/bitarray.hpp
Formatted  ElmerGUI/netgen/libsrc/general/dynamicmem.cpp
Formatted  ElmerGUI/netgen/libsrc/general/dynamicmem.hpp
Formatted  ElmerGUI/netgen/libsrc/general/flags.cpp
Formatted  ElmerGUI/netgen/libsrc/general/flags.hpp
Formatted  ElmerGUI/netgen/libsrc/general/hashtabl.cpp
Formatted  ElmerGUI/netgen/libsrc/general/hashtabl.hpp
Formatted  ElmerGUI/netgen/libsrc/general/moveablemem.cpp
Formatted  ElmerGUI/netgen/libsrc/general/moveablemem.hpp
Formatted  ElmerGUI/netgen/libsrc/general/myadt.hpp
Formatted  ElmerGUI/netgen/libsrc/general/mystring.cpp
Formatted  ElmerGUI/netgen/libsrc/general/mystring.hpp
Formatted  ElmerGUI/netgen/libsrc/general/netgenout.hpp
Formatted  ElmerGUI/netgen/libsrc/general/ngexception.cpp
Formatted  ElmerGUI/netgen/libsrc/general/ngexception.hpp
Formatted  ElmerGUI/netgen/libsrc/general/optmem.cpp
Formatted  ElmerGUI/netgen/libsrc/general/optmem.hpp
Formatted  ElmerGUI/netgen/libsrc/general/parthreads.cpp
Formatted  ElmerGUI/netgen/libsrc/general/parthreads.hpp
Formatted  ElmerGUI/netgen/libsrc/general/profiler.cpp
Formatted  ElmerGUI/netgen/libsrc/general/profiler.hpp
Formatted  ElmerGUI/netgen/libsrc/general/seti.cpp
Formatted  ElmerGUI/netgen/libsrc/general/seti.hpp
Formatted  ElmerGUI/netgen/libsrc/general/sort.cpp
Formatted  ElmerGUI/netgen/libsrc/general/sort.hpp
Formatted  ElmerGUI/netgen/libsrc/general/spbita2d.cpp
Formatted  ElmerGUI/netgen/libsrc/general/spbita2d.hpp
Formatted  ElmerGUI/netgen/libsrc/general/stack.hpp
Formatted  ElmerGUI/netgen/libsrc/general/symbolta.cpp
Formatted  ElmerGUI/netgen/libsrc/general/symbolta.hpp
Formatted  ElmerGUI/netgen/libsrc/general/table.cpp
Formatted  ElmerGUI/netgen/libsrc/general/table.hpp
Formatted  ElmerGUI/netgen/libsrc/general/template.hpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/genmesh2d.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/geom2dmesh.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/geom2dmesh.hpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/spline.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/spline.hpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/spline2d.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/spline2d.hpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/splinegeometry.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/splinegeometry.hpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/splinegeometry2.cpp
Formatted  ElmerGUI/netgen/libsrc/geom2d/splinegeometry2.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/adtree.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/adtree.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geom2d.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geom2d.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geom3d.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geom3d.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomfuncs.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomfuncs.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomobjects.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomops.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomtest3d.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/geomtest3d.hpp
Formatted  ElmerGUI/netgen/libsrc/gprim/transform3d.cpp
Formatted  ElmerGUI/netgen/libsrc/gprim/transform3d.hpp
Formatted  ElmerGUI/netgen/libsrc/include/FlexLexer.h
Formatted  ElmerGUI/netgen/libsrc/include/mystdlib.h
Formatted  ElmerGUI/netgen/libsrc/interface/importsolution.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/nginterface.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/nginterface.h
Formatted  ElmerGUI/netgen/libsrc/interface/nglib.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/nglib.h
Formatted  ElmerGUI/netgen/libsrc/interface/readtetmesh.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/readuser.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writeabaqus.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writediffpack.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writedolfin.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writeelmer.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writefeap.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writefluent.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writegmsh.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writejcm.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writepermas.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writetecplot.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writetet.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writetochnog.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writeuser.cpp
Formatted  ElmerGUI/netgen/libsrc/interface/writeuser.hpp
Formatted  ElmerGUI/netgen/libsrc/interface/wuchemnitz.cpp
Formatted  ElmerGUI/netgen/libsrc/linalg/densemat.cpp
Formatted  ElmerGUI/netgen/libsrc/linalg/densemat.hpp
Formatted  ElmerGUI/netgen/libsrc/linalg/linalg.hpp
Formatted  ElmerGUI/netgen/libsrc/linalg/polynomial.cpp
Formatted  ElmerGUI/netgen/libsrc/linalg/polynomial.hpp
Formatted  ElmerGUI/netgen/libsrc/linalg/vector.cpp
Formatted  ElmerGUI/netgen/libsrc/linalg/vector.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/adfront2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/adfront2.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/adfront3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/adfront3.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/bisect.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/bisect.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/boundarylayer.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/classifyhpel.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/clusters.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/clusters.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/curvedelems.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/curvedelems.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/curvedelems2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/curvedelems_new.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/curvedelems_new.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/delaunay.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/findip.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/findip.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/findip2.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/geomsearch.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/geomsearch.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/global.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/global.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_hex.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_prism.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_pyramid.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_quad.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_segm.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_tet.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hpref_trig.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hprefinement.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/hprefinement.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/improve2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/improve2.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/improve2gen.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/improve3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/improve3.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/localh.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/localh.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshclass.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshclass.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshfunc.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshfunc.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshfunc2d.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshing.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshing2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshing2.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshing3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshing3.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshtool.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshtool.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshtype.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/meshtype.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/msghandler.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/msghandler.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/netrule2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/netrule3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/parser2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/parser3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/prism2rls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/pyramid2rls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/pyramidrls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/quadrls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/refine.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/ruler2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/ruler2.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/ruler3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/ruler3.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/secondorder.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/smoothing2.5.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/smoothing2.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/smoothing3.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/specials.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/specials.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/tetrarls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/topology.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/topology.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/triarls.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/validate.cpp
Formatted  ElmerGUI/netgen/libsrc/meshing/validate.hpp
Formatted  ElmerGUI/netgen/libsrc/meshing/zrefine.cpp
Formatted  ElmerGUI/netgen/libsrc/opti/bfgs.cpp
Formatted  ElmerGUI/netgen/libsrc/opti/linopt.cpp
Formatted  ElmerGUI/netgen/libsrc/opti/linsearch.cpp
Formatted  ElmerGUI/netgen/libsrc/opti/opti.hpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/meshstlsurface.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/meshstlsurface.hpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlgeom.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlgeom.hpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlgeomchart.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlgeommesh.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlline.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stlline.hpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stltool.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stltool.hpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stltopology.cpp
Formatted  ElmerGUI/netgen/libsrc/stlgeom/stltopology.hpp
Formatted  ElmerGUIlogger/src/main.cpp
Formatted  ElmerGUIlogger/src/mainwindow.cpp
Formatted  ElmerGUIlogger/src/mainwindow.h
Formatted  ElmerGUItester/src/main.cpp
Formatted  ElmerGUItester/src/tester.cpp
Formatted  ElmerGUItester/src/tester.h
Formatted  build/CMakeFiles/3.22.0/CompilerIdCXX/CMakeCXXCompilerId.cpp
Formatted  build/fem/config.h
Formatted  contrib/lua-5.1.5/src/lauxlib.h
Formatted  contrib/lua-5.1.5/src/lcode.h
Formatted  contrib/lua-5.1.5/src/ldebug.h
Formatted  contrib/lua-5.1.5/src/ldo.h
Formatted  contrib/lua-5.1.5/src/lfunc.h
Formatted  contrib/lua-5.1.5/src/lgc.h
Formatted  contrib/lua-5.1.5/src/llex.h
Formatted  contrib/lua-5.1.5/src/llimits.h
Formatted  contrib/lua-5.1.5/src/lmem.h
Formatted  contrib/lua-5.1.5/src/lobject.h
Formatted  contrib/lua-5.1.5/src/lopcodes.h
Formatted  contrib/lua-5.1.5/src/lparser.h
Formatted  contrib/lua-5.1.5/src/lstate.h
Formatted  contrib/lua-5.1.5/src/lstring.h
Formatted  contrib/lua-5.1.5/src/ltable.h
Formatted  contrib/lua-5.1.5/src/ltm.h
Formatted  contrib/lua-5.1.5/src/lua.h
Formatted  contrib/lua-5.1.5/src/luaconf.h
Formatted  contrib/lua-5.1.5/src/lualib.h
Formatted  contrib/lua-5.1.5/src/lundump.h
Formatted  contrib/lua-5.1.5/src/lvm.h
Formatted  contrib/lua-5.1.5/src/lzio.h
Formatted  elmergrid/src/common.h
Formatted  elmergrid/src/femdef.h
Formatted  elmergrid/src/femelmer.h
Formatted  elmergrid/src/femfilein.h
Formatted  elmergrid/src/femfileout.h
Formatted  elmergrid/src/feminfo.h
Formatted  elmergrid/src/femknot.h
Formatted  elmergrid/src/femmesh.h
Formatted  elmergrid/src/femtypes.h
Formatted  elmergrid/src/nrutil.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/GKlib.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_arch.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_getopt.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_macros.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_mkrandom.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_mksort.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_mkutils.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_proto.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_struct.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gk_types.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/gkregex.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/ms_inttypes.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/ms_stat.h
Formatted  elmergrid/src/metis-5.1.0/GKlib/ms_stdint.h
Formatted  elmergrid/src/metis-5.1.0/include/metis.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/defs.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/gklib_defs.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/macros.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/metislib.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/proto.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/rename.h
Formatted  elmergrid/src/metis-5.1.0/libmetis/struct.h
Formatted  elmergrid/src/metis-5.1.0/programs/metisbin.h
Formatted  elmergrid/src/metis-5.1.0/programs/proto.h
Formatted  elmergrid/src/metis-5.1.0/programs/struct.h
Formatted  fem/src/elmer_lua_iface.h
Formatted  fem/src/mpif_stub.h
Formatted  fem/src/view3d/ViewFactors.h
Formatted  fem/src/viewaxis/viewfact.cpp
Formatted  fem/src/viewaxis/viewfact.h
Formatted  fhutiter/include/huti_fdefs.h
Formatted  fhutiter/src/huti_fdefs.h
Formatted  matc/src/str.h
Formatted  matc/src/elmer/fnames.h
Formatted  matc/src/elmer/gra.h
Formatted  matc/src/elmer/matc.h
Formatted  mathlibs/src/arpack/debug.h
Formatted  mathlibs/src/arpack/stat.h
Formatted  mathlibs/src/arpack/version.h
Formatted  mathlibs/src/parpack/debug.h
Formatted  mathlibs/src/parpack/mpif_stub.h
Formatted  mathlibs/src/parpack/stat.h
Formatted  meshgen2d/src/BGGridMesh.cpp
Formatted  meshgen2d/src/BGTriangleMesh.cpp
Formatted  meshgen2d/src/BGVertex.cpp
Formatted  meshgen2d/src/BoundaryElement.cpp
Formatted  meshgen2d/src/BoundaryLayer.cpp
Formatted  meshgen2d/src/Connect.cpp
Formatted  meshgen2d/src/Element.cpp
Formatted  meshgen2d/src/GeometryEdge.cpp
Formatted  meshgen2d/src/Mesh.cpp
Formatted  meshgen2d/src/MeshNode.cpp
Formatted  meshgen2d/src/MeshParser.cpp
Formatted  meshgen2d/src/Node.cpp
Formatted  meshgen2d/src/PQ.cpp
Formatted  meshgen2d/src/QuadElement.cpp
Formatted  meshgen2d/src/QuadLayer.cpp
Formatted  meshgen2d/src/SSMFVoronoiSegment.cpp
Formatted  meshgen2d/src/SSSFVoronoiSegment.cpp
Formatted  meshgen2d/src/TriangleElement.cpp
Formatted  meshgen2d/src/TriangleNELayer.cpp
Formatted  meshgen2d/src/VSVertex.cpp
Formatted  meshgen2d/src/Vertex.cpp
Formatted  meshgen2d/src/VoronoiSegment.cpp
Formatted  meshgen2d/src/VoronoiVertex.cpp
Formatted  meshgen2d/src/main.cpp
Formatted  meshgen2d/src/include/BGMesh.h
Formatted  meshgen2d/src/include/BGVertex.h
Formatted  meshgen2d/src/include/Body.h
Formatted  meshgen2d/src/include/Border.h
Formatted  meshgen2d/src/include/BoundaryElement.h
Formatted  meshgen2d/src/include/BoundaryLayer.h
Formatted  meshgen2d/src/include/Connect.h
Formatted  meshgen2d/src/include/Element.h
Formatted  meshgen2d/src/include/GeometryEdge.h
Formatted  meshgen2d/src/include/GeometryNode.h
Formatted  meshgen2d/src/include/Layer.h
Formatted  meshgen2d/src/include/Loop.h
Formatted  meshgen2d/src/include/MGError.h
Formatted  meshgen2d/src/include/Mesh.h
Formatted  meshgen2d/src/include/MeshNode.h
Formatted  meshgen2d/src/include/MeshParser.h
Formatted  meshgen2d/src/include/Node.h
Formatted  meshgen2d/src/include/PQ.h
Formatted  meshgen2d/src/include/QuadElement.h
Formatted  meshgen2d/src/include/QuadLayer.h
Formatted  meshgen2d/src/include/SSMFVertex.h
Formatted  meshgen2d/src/include/SSMFVoronoiSegment.h
Formatted  meshgen2d/src/include/SSSFVertex.h
Formatted  meshgen2d/src/include/SSSFVoronoiSegment.h
Formatted  meshgen2d/src/include/SSVoronoiSegment.h
Formatted  meshgen2d/src/include/Tokens.h
Formatted  meshgen2d/src/include/TriangleElement.h
Formatted  meshgen2d/src/include/TriangleNELayer.h
Formatted  meshgen2d/src/include/Triple.h
Formatted  meshgen2d/src/include/VSVertex.h
Formatted  meshgen2d/src/include/Vertex.h
Formatted  meshgen2d/src/include/VoronoiSegment.h
Formatted  meshgen2d/src/include/VoronoiVertex.h
Formatted  meshgen2d/src/include/coreGeometry.h
Formatted  meshgen2d/src/include/minmaxpatch.h
Formatted  misc/brepsamples/crossed_fibers.cpp
Formatted  misc/brepsamples/cylinder.cpp
Formatted  misc/brepsamples/filleted_cube.cpp
Formatted  misc/brepsamples/occheaders.h
Formatted  misc/brepsamples/spheres_in_cylinder.cpp
Formatted  misc/tetgen_plugin/plugin/ElmerAPI.cpp
Formatted  misc/tetgen_plugin/plugin/tetgen.h
Formatted  misc/tetgen_plugin/testapp/main.cpp
Formatted  post/matc/config.h
Formatted  post/matc/src/str.h
Formatted  post/matc/src/elmer/fnames.h
Formatted  post/matc/src/elmer/gra.h
Formatted  post/matc/src/elmer/matc.h
Formatted  post/src/elmerpost.h
Formatted  post/src/fttext.cpp
Formatted  post/src/geometry.h
Formatted  post/src/camera/camera.h
Formatted  post/src/camera/glp.h
Formatted  post/src/camera/glpfile.h
Formatted  post/src/elements/elements.h
Formatted  post/src/glaux/3d.h
Formatted  post/src/glaux/glaux.h
Formatted  post/src/glaux_mingw/src/3d.h
Formatted  post/src/glaux_mingw/src/teapot.h
Formatted  post/src/glaux_mingw/src/tk.h
Formatted  post/src/glaux_mingw/src/GL/glaux.h
Formatted  post/src/graphics/graphics.h
Formatted  post/src/include/glaux.h
Formatted  post/src/include/gltk.h
Formatted  post/src/objects/objects.h
Formatted  post/src/sico2elmer/sico2elmer.h
Formatted  post/src/tk/private.h
Formatted  post/src/tk/tk.h
Formatted  post/src/visuals/visual.h
Formatted  umfpack/src/amd/amd_internal.h
Formatted  umfpack/src/amd/include/amd.h
Formatted  umfpack/src/umfpack/include/umf_2by2.h
Formatted  umfpack/src/umfpack/include/umf_analyze.h
Formatted  umfpack/src/umfpack/include/umf_apply_order.h
Formatted  umfpack/src/umfpack/include/umf_assemble.h
Formatted  umfpack/src/umfpack/include/umf_blas3_update.h
Formatted  umfpack/src/umfpack/include/umf_build_tuples.h
Formatted  umfpack/src/umfpack/include/umf_colamd.h
Formatted  umfpack/src/umfpack/include/umf_config.h
Formatted  umfpack/src/umfpack/include/umf_create_element.h
Formatted  umfpack/src/umfpack/include/umf_dump.h
Formatted  umfpack/src/umfpack/include/umf_extend_front.h
Formatted  umfpack/src/umfpack/include/umf_free.h
Formatted  umfpack/src/umfpack/include/umf_fsize.h
Formatted  umfpack/src/umfpack/include/umf_garbage_collection.h
Formatted  umfpack/src/umfpack/include/umf_get_memory.h
Formatted  umfpack/src/umfpack/include/umf_grow_front.h
Formatted  umfpack/src/umfpack/include/umf_init_front.h
Formatted  umfpack/src/umfpack/include/umf_internal.h
Formatted  umfpack/src/umfpack/include/umf_is_permutation.h
Formatted  umfpack/src/umfpack/include/umf_kernel.h
Formatted  umfpack/src/umfpack/include/umf_kernel_init.h
Formatted  umfpack/src/umfpack/include/umf_kernel_wrapup.h
Formatted  umfpack/src/umfpack/include/umf_local_search.h
Formatted  umfpack/src/umfpack/include/umf_lsolve.h
Formatted  umfpack/src/umfpack/include/umf_ltsolve.h
Formatted  umfpack/src/umfpack/include/umf_malloc.h
Formatted  umfpack/src/umfpack/include/umf_mem_alloc_element.h
Formatted  umfpack/src/umfpack/include/umf_mem_alloc_head_block.h
Formatted  umfpack/src/umfpack/include/umf_mem_alloc_tail_block.h
Formatted  umfpack/src/umfpack/include/umf_mem_free_tail_block.h
Formatted  umfpack/src/umfpack/include/umf_mem_init_memoryspace.h
Formatted  umfpack/src/umfpack/include/umf_realloc.h
Formatted  umfpack/src/umfpack/include/umf_report_perm.h
Formatted  umfpack/src/umfpack/include/umf_report_vector.h
Formatted  umfpack/src/umfpack/include/umf_row_search.h
Formatted  umfpack/src/umfpack/include/umf_scale.h
Formatted  umfpack/src/umfpack/include/umf_scale_column.h
Formatted  umfpack/src/umfpack/include/umf_set_stats.h
Formatted  umfpack/src/umfpack/include/umf_singletons.h
Formatted  umfpack/src/umfpack/include/umf_solve.h
Formatted  umfpack/src/umfpack/include/umf_start_front.h
Formatted  umfpack/src/umfpack/include/umf_store_lu.h
Formatted  umfpack/src/umfpack/include/umf_symbolic_usage.h
Formatted  umfpack/src/umfpack/include/umf_transpose.h
Formatted  umfpack/src/umfpack/include/umf_triplet.h
Formatted  umfpack/src/umfpack/include/umf_tuple_lengths.h
Formatted  umfpack/src/umfpack/include/umf_usolve.h
Formatted  umfpack/src/umfpack/include/umf_utsolve.h
Formatted  umfpack/src/umfpack/include/umf_valid_numeric.h
Formatted  umfpack/src/umfpack/include/umf_valid_symbolic.h
Formatted  umfpack/src/umfpack/include/umf_version.h
Formatted  umfpack/src/umfpack/include/umfpack.h
Formatted  umfpack/src/umfpack/include/umfpack_col_to_triplet.h
Formatted  umfpack/src/umfpack/include/umfpack_defaults.h
Formatted  umfpack/src/umfpack/include/umfpack_free_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_free_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_get_determinant.h
Formatted  umfpack/src/umfpack/include/umfpack_get_lunz.h
Formatted  umfpack/src/umfpack/include/umfpack_get_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_get_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_load_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_load_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_qsymbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_report_control.h
Formatted  umfpack/src/umfpack/include/umfpack_report_info.h
Formatted  umfpack/src/umfpack/include/umfpack_report_matrix.h
Formatted  umfpack/src/umfpack/include/umfpack_report_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_report_perm.h
Formatted  umfpack/src/umfpack/include/umfpack_report_status.h
Formatted  umfpack/src/umfpack/include/umfpack_report_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_report_triplet.h
Formatted  umfpack/src/umfpack/include/umfpack_report_vector.h
Formatted  umfpack/src/umfpack/include/umfpack_save_numeric.h
Formatted  umfpack/src/umfpack/include/umfpack_save_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_scale.h
Formatted  umfpack/src/umfpack/include/umfpack_solve.h
Formatted  umfpack/src/umfpack/include/umfpack_symbolic.h
Formatted  umfpack/src/umfpack/include/umfpack_tictoc.h
Formatted  umfpack/src/umfpack/include/umfpack_transpose.h
Formatted  umfpack/src/umfpack/include/umfpack_triplet_to_col.h
Formatted  umfpack/src/umfpack/include/umfpack_wsolve.h
Formatted  utils/ElmerClips/src/encoder.cpp
Formatted  utils/ElmerClips/src/encoder.h
Formatted  utils/ElmerClips/src/main.cpp
Formatted  utils/ElmerClips/src/preview.cpp
Formatted  utils/ElmerClips/src/preview.h
Formatted  utils/ElmerClips/src/win32/inttypes.h
Formatted  utils/ElmerClips/src/win32/stdint.h
------------------------------------------------------------
 666 formatted   41 unchanged   1.95 seconds   266,580 lines
```

## 功能性测试

### 所选测试案例

将其进行`ctest`进行单元测试后测试结果如下：

```log
Test project /home/season/elmerfem-scc20/build
        Start   1: 1dtests
  1/677 Test   #1: 1dtests .................................................   Passed    0.33 sec
        Start   2: 1sttime
  2/677 Test   #2: 1sttime .................................................   Passed    2.38 sec
        Start   3: 2ndtime
  3/677 Test   #3: 2ndtime .................................................   Passed    2.41 sec
        Start   4: AdvDiffFCT
  4/677 Test   #4: AdvDiffFCT ..............................................   Passed    5.17 sec
        Start   5: AdvDiffFluxes
  5/677 Test   #5: AdvDiffFluxes ...........................................   Passed    0.27 sec
        Start   6: AdvReactDB
  6/677 Test   #6: AdvReactDB ..............................................   Passed    0.30 sec
        Start   7: AdvReactDB_np6
  7/677 Test   #7: AdvReactDB_np6 ..........................................***Failed    0.03 sec
        Start   8: AdvReactDBmap
  8/677 Test   #8: AdvReactDBmap ...........................................   Passed    1.13 sec
        Start   9: AdvReactDBmap_np6
  9/677 Test   #9: AdvReactDBmap_np6 .......................................***Failed    0.03 sec
        Start  10: AdvReactDG
 10/677 Test  #10: AdvReactDG ..............................................   Passed    0.33 sec
        Start  11: AdvReactDG_np6
 11/677 Test  #11: AdvReactDG_np6 ..........................................***Failed    0.03 sec
        Start  12: AdvReactDG_P
 12/677 Test  #12: AdvReactDG_P ............................................   Passed    0.36 sec
        Start  13: AnalyticalTest
 13/677 Test  #13: AnalyticalTest ..........................................   Passed    0.20 sec
        Start  14: AngleMetisLayer
 14/677 Test  #14: AngleMetisLayer .........................................   Passed    0.31 sec
        Start  15: AngleMetisLayer_np2
 15/677 Test  #15: AngleMetisLayer_np2 .....................................   Passed    0.32 sec
        Start  16: AngleMetisLayer_np3
 16/677 Test  #16: AngleMetisLayer_np3 .....................................   Passed    0.40 sec
        Start  17: AngleMetisLayer_np4
 17/677 Test  #17: AngleMetisLayer_np4 .....................................   Passed    0.42 sec
        Start  18: AnglePartitionLayer_np4
 18/677 Test  #18: AnglePartitionLayer_np4 .................................   Passed    0.45 sec
        Start  19: ArteryOutlet
 19/677 Test  #19: ArteryOutlet ............................................   Passed    4.97 sec
        Start  20: BDM2D
 20/677 Test  #20: BDM2D ...................................................   Passed    0.21 sec
        Start  21: BDM3D
 21/677 Test  #21: BDM3D ...................................................   Passed    1.71 sec
        Start  22: Beam_3D_Cantilever
 22/677 Test  #22: Beam_3D_Cantilever ......................................   Passed    0.16 sec
        Start  23: Beam_3D_Cantilever_Orientation
 23/677 Test  #23: Beam_3D_Cantilever_Orientation ..........................   Passed    0.17 sec
        Start  24: BlockDomainsFourHeaters
 24/677 Test  #24: BlockDomainsFourHeaters .................................   Passed    0.27 sec
        Start  25: BlockDomainsVtuParts
 25/677 Test  #25: BlockDomainsVtuParts ....................................   Passed    0.80 sec
        Start  26: BlockLinElast1
 26/677 Test  #26: BlockLinElast1 ..........................................   Passed    0.37 sec
        Start  27: BlockLinElast2
 27/677 Test  #27: BlockLinElast2 ..........................................   Passed    0.22 sec
        Start  28: BlockLinElast2b
 28/677 Test  #28: BlockLinElast2b .........................................   Passed    0.23 sec
        Start  29: BlockLinElast3
 29/677 Test  #29: BlockLinElast3 ..........................................   Passed    1.41 sec
        Start  30: BlockLinElast3b
 30/677 Test  #30: BlockLinElast3b .........................................   Passed    1.07 sec
        Start  31: BlockLinElast3c
 31/677 Test  #31: BlockLinElast3c .........................................   Passed    1.54 sec
        Start  32: BlockLinElast3d
 32/677 Test  #32: BlockLinElast3d .........................................   Passed    2.15 sec
        Start  33: BlockPoisson1
 33/677 Test  #33: BlockPoisson1 ...........................................   Passed    0.15 sec
        Start  34: BlockPoisson2
 34/677 Test  #34: BlockPoisson2 ...........................................   Passed    0.16 sec
        Start  35: BlockPoisson3
 35/677 Test  #35: BlockPoisson3 ...........................................   Passed    0.18 sec
        Start  36: BlockRotatingBCPoisson3D
 36/677 Test  #36: BlockRotatingBCPoisson3D ................................   Passed    0.67 sec
        Start  37: BoundaryFluxes
 37/677 Test  #37: BoundaryFluxes ..........................................   Passed    0.15 sec
        Start  38: BoundaryFluxes2
 38/677 Test  #38: BoundaryFluxes2 .........................................   Passed    0.15 sec
        Start  39: CapacitanceMatrix
 39/677 Test  #39: CapacitanceMatrix .......................................   Passed    0.21 sec
        Start  40: CapacitanceMatrix2
 40/677 Test  #40: CapacitanceMatrix2 ......................................   Passed    0.21 sec
        Start  41: CavityLid
 41/677 Test  #41: CavityLid ...............................................   Passed    0.32 sec
        Start  42: CavityLid2
 42/677 Test  #42: CavityLid2 ..............................................   Passed    1.55 sec
        Start  43: Classical2DShell
 43/677 Test  #43: Classical2DShell ........................................   Passed    0.79 sec
        Start  44: CoilSolver1
 44/677 Test  #44: CoilSolver1 .............................................   Passed    0.25 sec
        Start  45: CoilSolver1_np2
 45/677 Test  #45: CoilSolver1_np2 .........................................   Passed    0.24 sec
        Start  46: CoilSolver1_np4
 46/677 Test  #46: CoilSolver1_np4 .........................................   Passed    0.45 sec
        Start  47: CoilSolver2
 47/677 Test  #47: CoilSolver2 .............................................   Passed    0.21 sec
        Start  48: CoilSolver3
 48/677 Test  #48: CoilSolver3 .............................................   Passed    0.23 sec
        Start  49: CoilSolver4
 49/677 Test  #49: CoilSolver4 .............................................   Passed    0.23 sec
        Start  50: CoilSolver5
 50/677 Test  #50: CoilSolver5 .............................................   Passed    0.23 sec
        Start  51: CoilSolver6
 51/677 Test  #51: CoilSolver6 .............................................   Passed    0.22 sec
        Start  52: CoilSolverLoop
 52/677 Test  #52: CoilSolverLoop ..........................................   Passed    0.26 sec
        Start  53: CoilSolverLoop_np2
 53/677 Test  #53: CoilSolverLoop_np2 ......................................   Passed    0.24 sec
        Start  54: CoilSolverLoop_np4
 54/677 Test  #54: CoilSolverLoop_np4 ......................................   Passed    0.41 sec
        Start  55: CoilSolverLoopNarrow
 55/677 Test  #55: CoilSolverLoopNarrow ....................................   Passed    0.29 sec
        Start  56: CoilSolverTwoLoops
 56/677 Test  #56: CoilSolverTwoLoops ......................................   Passed    0.38 sec
        Start  57: CoilSolverTwoLoops_np2
 57/677 Test  #57: CoilSolverTwoLoops_np2 ..................................   Passed    0.34 sec
        Start  58: CoilSolverTwoLoops_np4
 58/677 Test  #58: CoilSolverTwoLoops_np4 ..................................   Passed    0.46 sec
        Start  59: ComponentResistance
 59/677 Test  #59: ComponentResistance .....................................   Passed    0.16 sec
        Start  60: ComponentResistance_np4
 60/677 Test  #60: ComponentResistance_np4 .................................   Passed    0.34 sec
        Start  61: CompressIdealGas
 61/677 Test  #61: CompressIdealGas ........................................   Passed    1.83 sec
        Start  62: CompressIdealGas2
 62/677 Test  #62: CompressIdealGas2 .......................................   Passed    0.68 sec
        Start  63: ConformingDisplacementCube
 63/677 Test  #63: ConformingDisplacementCube ..............................   Passed    1.19 sec
        Start  64: ConstantBCDisplacement
 64/677 Test  #64: ConstantBCDisplacement ..................................   Passed    1.49 sec
        Start  65: ConstantBCTemperature
 65/677 Test  #65: ConstantBCTemperature ...................................   Passed    0.16 sec
        Start  66: ContactBlunt2D
 66/677 Test  #66: ContactBlunt2D ..........................................   Passed    2.92 sec
        Start  67: ContactBlunt2Djump
 67/677 Test  #67: ContactBlunt2Djump ......................................   Passed    6.70 sec
        Start  68: ContactBlunt2Dresmode
 68/677 Test  #68: ContactBlunt2Dresmode ...................................   Passed    2.62 sec
        Start  69: ContactBlunt2Dslide
 69/677 Test  #69: ContactBlunt2Dslide .....................................   Passed   13.46 sec
        Start  70: ContactBlunt2Dstick
 70/677 Test  #70: ContactBlunt2Dstick .....................................   Passed    7.80 sec
        Start  71: ContactBlunt3DLevelProj
 71/677 Test  #71: ContactBlunt3DLevelProj .................................   Passed   21.01 sec
        Start  72: ContactBlunt3DNormalProj
 72/677 Test  #72: ContactBlunt3DNormalProj ................................   Passed   27.82 sec
        Start  73: ContactFriction
 73/677 Test  #73: ContactFriction .........................................   Passed    0.80 sec
        Start  74: ContactFrictionHeating
 74/677 Test  #74: ContactFrictionHeating ..................................   Passed    1.09 sec
        Start  75: ContactFrictionNonlin
 75/677 Test  #75: ContactFrictionNonlin ...................................   Passed    1.06 sec
        Start  76: ContactPatch2D
 76/677 Test  #76: ContactPatch2D ..........................................   Passed    0.19 sec
        Start  77: ContactPatch2Delim
 77/677 Test  #77: ContactPatch2Delim ......................................   Passed    6.32 sec
        Start  78: ContactPatch2Dnt
 78/677 Test  #78: ContactPatch2Dnt ........................................   Passed    0.18 sec
        Start  79: ContactPatch2DntQuadratic
 79/677 Test  #79: ContactPatch2DntQuadratic ...............................   Passed    0.23 sec
        Start  80: ContactPatch2Dtie
 80/677 Test  #80: ContactPatch2Dtie .......................................   Passed    0.18 sec
        Start  81: ContactPatch2Dtwo
 81/677 Test  #81: ContactPatch2Dtwo .......................................   Passed    0.17 sec
        Start  82: ContactPatch3D
 82/677 Test  #82: ContactPatch3D ..........................................   Passed    1.88 sec
        Start  83: ContactPatch3D_np4
 83/677 Test  #83: ContactPatch3D_np4 ......................................   Passed    2.01 sec
        Start  84: ContactPatch3DNames
 84/677 Test  #84: ContactPatch3DNames .....................................   Passed    1.77 sec
        Start  85: ContactPatch3DNames_np4
 85/677 Test  #85: ContactPatch3DNames_np4 .................................   Passed    1.78 sec
        Start  86: ContactPatch3DNamesAndAutonum
 86/677 Test  #86: ContactPatch3DNamesAndAutonum ...........................   Passed    1.73 sec
        Start  87: ContactPatch3DNamesAndAutonum_np4
 87/677 Test  #87: ContactPatch3DNamesAndAutonum_np4 .......................   Passed    1.78 sec
        Start  88: ContactPatch3DNamesAndAutonum2
 88/677 Test  #88: ContactPatch3DNamesAndAutonum2 ..........................   Passed    1.79 sec
        Start  89: ContactPatch3DNamesAndAutonum3
 89/677 Test  #89: ContactPatch3DNamesAndAutonum3 ..........................   Passed    1.78 sec
        Start  90: ContactPatch3DNormalProj
 90/677 Test  #90: ContactPatch3DNormalProj ................................   Passed    1.77 sec
        Start  91: ContactPatch3Delim
 91/677 Test  #91: ContactPatch3Delim ......................................   Passed    7.73 sec
        Start  92: ContactPatch3Delim_np4
 92/677 Test  #92: ContactPatch3Delim_np4 ..................................   Passed    7.85 sec
        Start  93: ConvergenceControl
 93/677 Test  #93: ConvergenceControl ......................................   Passed    3.59 sec
        Start  94: CooksMembrane
 94/677 Test  #94: CooksMembrane ...........................................   Passed    3.11 sec
        Start  95: CooksMembrane3D
 95/677 Test  #95: CooksMembrane3D .........................................   Passed   60.15 sec
        Start  96: CoordinateScaling
 96/677 Test  #96: CoordinateScaling .......................................   Passed    0.16 sec
        Start  97: CoordinateTrans
 97/677 Test  #97: CoordinateTrans .........................................   Passed    0.32 sec
        Start  98: CoordinateTrans2
 98/677 Test  #98: CoordinateTrans2 ........................................   Passed    0.44 sec
        Start  99: CoupledPoisson1
 99/677 Test  #99: CoupledPoisson1 .........................................   Passed    0.15 sec
        Start 100: CoupledPoisson1b
100/677 Test #100: CoupledPoisson1b ........................................   Passed    0.15 sec
        Start 101: CoupledPoisson2
101/677 Test #101: CoupledPoisson2 .........................................   Passed    0.84 sec
        Start 102: CoupledPoisson2b
102/677 Test #102: CoupledPoisson2b ........................................   Passed    0.97 sec
        Start 103: CoupledPoisson2c
103/677 Test #103: CoupledPoisson2c ........................................   Passed    0.89 sec
        Start 104: CoupledPoisson3
104/677 Test #104: CoupledPoisson3 .........................................   Passed    0.20 sec
        Start 105: CoupledPoisson4
105/677 Test #105: CoupledPoisson4 .........................................   Passed    0.17 sec
        Start 106: CoupledPoisson5
106/677 Test #106: CoupledPoisson5 .........................................   Passed    0.18 sec
        Start 107: CoupledPoisson6
107/677 Test #107: CoupledPoisson6 .........................................   Passed    0.16 sec
        Start 108: CoupledPoisson7
108/677 Test #108: CoupledPoisson7 .........................................   Passed    0.18 sec
        Start 109: CoupledPoisson8
109/677 Test #109: CoupledPoisson8 .........................................   Passed    0.16 sec
        Start 110: CoupledPoisson9
110/677 Test #110: CoupledPoisson9 .........................................   Passed    0.17 sec
        Start 111: CurvedBndryPFEM
111/677 Test #111: CurvedBndryPFEM .........................................   Passed    0.15 sec
        Start 112: CurvedBndryPFEM2
112/677 Test #112: CurvedBndryPFEM2 ........................................   Passed    0.15 sec
        Start 113: CylComAxi
113/677 Test #113: CylComAxi ...............................................   Passed    0.44 sec
        Start 114: CylComStruct
114/677 Test #114: CylComStruct ............................................   Passed    0.82 sec
        Start 115: DNS_WaveSimulation
115/677 Test #115: DNS_WaveSimulation ......................................   Passed    5.03 sec
        Start 116: DataToField
116/677 Test #116: DataToField .............................................   Passed    0.47 sec
        Start 117: DataToField2
117/677 Test #117: DataToField2 ............................................   Passed    0.19 sec
        Start 118: DgVariable
118/677 Test #118: DgVariable ..............................................   Passed    0.16 sec
        Start 119: DgVariable2
119/677 Test #119: DgVariable2 .............................................   Passed    0.17 sec
        Start 120: DirichletNeumann
120/677 Test #120: DirichletNeumann ........................................   Passed    0.19 sec
        Start 121: DirichletNeumannSlave
121/677 Test #121: DirichletNeumannSlave ...................................   Passed    0.18 sec
        Start 122: DisContBoundary
122/677 Test #122: DisContBoundary .........................................   Passed    0.15 sec
        Start 123: DisContBoundary3D
123/677 Test #123: DisContBoundary3D .......................................   Passed    0.24 sec
        Start 124: DisContBoundaryDouble
124/677 Test #124: DisContBoundaryDouble ...................................   Passed    0.22 sec
        Start 125: DisContBoundaryDoubleMortar
125/677 Test #125: DisContBoundaryDoubleMortar .............................   Passed    0.23 sec
        Start 126: DisContBoundaryDoubleMortar_np4
126/677 Test #126: DisContBoundaryDoubleMortar_np4 .........................   Passed    0.38 sec
        Start 127: DisContBoundaryDoubleMortar_np8
127/677 Test #127: DisContBoundaryDoubleMortar_np8 .........................***Failed    0.04 sec
        Start 128: DisContBoundaryDoubleNames
128/677 Test #128: DisContBoundaryDoubleNames ..............................   Passed    0.25 sec
        Start 129: DisContBoundaryMortarCont
129/677 Test #129: DisContBoundaryMortarCont ...............................   Passed    0.15 sec
        Start 130: DisContBoundaryMortarCont_np2
130/677 Test #130: DisContBoundaryMortarCont_np2 ...........................   Passed    0.19 sec
        Start 131: DisContBoundaryMortarCont_np4
131/677 Test #131: DisContBoundaryMortarCont_np4 ...........................   Passed    0.35 sec
        Start 132: DisContBoundaryMortarCont_np8
132/677 Test #132: DisContBoundaryMortarCont_np8 ...........................***Failed    0.03 sec
        Start 133: DisContBoundaryMortarContElim
133/677 Test #133: DisContBoundaryMortarContElim ...........................   Passed    0.17 sec
        Start 134: DisContBoundaryMortarContElim_np2
134/677 Test #134: DisContBoundaryMortarContElim_np2 .......................   Passed    0.22 sec
        Start 135: DisContBoundaryMortarContElim_np4
135/677 Test #135: DisContBoundaryMortarContElim_np4 .......................   Passed    0.34 sec
        Start 136: DisContBoundaryMortarContElim_np8
136/677 Test #136: DisContBoundaryMortarContElim_np8 .......................***Failed    0.03 sec
        Start 137: DisContBoundaryMortarJump
137/677 Test #137: DisContBoundaryMortarJump ...............................   Passed    0.18 sec
        Start 138: DisContBoundaryMortarJump_np2
138/677 Test #138: DisContBoundaryMortarJump_np2 ...........................   Passed    0.18 sec
        Start 139: DisContBoundaryMortarJump_np4
139/677 Test #139: DisContBoundaryMortarJump_np4 ...........................   Passed    0.35 sec
        Start 140: DisContBoundaryMortarJump_np8
140/677 Test #140: DisContBoundaryMortarJump_np8 ...........................***Failed    0.03 sec
        Start 141: DisContBoundaryMortarJumpB
141/677 Test #141: DisContBoundaryMortarJumpB ..............................   Passed    0.16 sec
        Start 142: DisContBoundaryMortarJumpB_np2
142/677 Test #142: DisContBoundaryMortarJumpB_np2 ..........................   Passed    0.19 sec
        Start 143: DisContBoundaryMortarJumpB_np4
143/677 Test #143: DisContBoundaryMortarJumpB_np4 ..........................   Passed    0.33 sec
        Start 144: DisContBoundaryMortarJumpB_np8
144/677 Test #144: DisContBoundaryMortarJumpB_np8 ..........................***Failed    0.03 sec
        Start 145: DisContBoundaryMortarJumpC
145/677 Test #145: DisContBoundaryMortarJumpC ..............................   Passed    0.16 sec
        Start 146: DisContBoundaryMortarJumpC_np2
146/677 Test #146: DisContBoundaryMortarJumpC_np2 ..........................   Passed    0.19 sec
        Start 147: DisContBoundaryMortarJumpC_np4
147/677 Test #147: DisContBoundaryMortarJumpC_np4 ..........................   Passed    0.34 sec
        Start 148: DisContBoundaryMortarJumpC_np8
148/677 Test #148: DisContBoundaryMortarJumpC_np8 ..........................***Failed    0.03 sec
        Start 149: DisContBoundaryNodalJump
149/677 Test #149: DisContBoundaryNodalJump ................................   Passed    0.16 sec
        Start 150: DisContBoundaryNodalJumpB
150/677 Test #150: DisContBoundaryNodalJumpB ...............................   Passed    0.16 sec
        Start 151: DisContBoundaryNodalProj
151/677 Test #151: DisContBoundaryNodalProj ................................   Passed    0.17 sec
        Start 152: DistributeSourceMgdyn
152/677 Test #152: DistributeSourceMgdyn ...................................   Passed    0.89 sec
        Start 153: DivergenceAnalytic2D
153/677 Test #153: DivergenceAnalytic2D ....................................   Passed    0.58 sec
        Start 154: EMWaveBoxHexas
154/677 Test #154: EMWaveBoxHexas ..........................................   Passed    1.45 sec
        Start 155: EMWaveBoxHexasPiola
155/677 Test #155: EMWaveBoxHexasPiola .....................................   Passed    0.87 sec
        Start 156: EMWaveBoxHexasQuad
156/677 Test #156: EMWaveBoxHexasQuad ......................................   Passed    3.43 sec
        Start 157: EMWavePiola2D
157/677 Test #157: EMWavePiola2D ...........................................   Passed    0.61 sec
        Start 158: EdgeElementInterpolation
158/677 Test #158: EdgeElementInterpolation ................................   Passed    1.03 sec
        Start 159: ElastElstat1DBeam
159/677 Test #159: ElastElstat1DBeam .......................................   Passed    0.21 sec
        Start 160: ElastElstatBeam
160/677 Test #160: ElastElstatBeam .........................................   Passed    0.22 sec
        Start 161: ElastElstatBeamNodal
161/677 Test #161: ElastElstatBeamNodal ....................................   Passed    0.25 sec
        Start 162: ElastPelem
162/677 Test #162: ElastPelem ..............................................   Passed    2.28 sec
        Start 163: ElasticBeamRestart
163/677 Test #163: ElasticBeamRestart ......................................   Passed    6.12 sec
        Start 164: ElasticLubrication
164/677 Test #164: ElasticLubrication ......................................   Passed    1.09 sec
        Start 165: Electrokinetics
165/677 Test #165: Electrokinetics .........................................   Passed    5.59 sec
        Start 166: ElemVariable
166/677 Test #166: ElemVariable ............................................   Passed    0.18 sec
        Start 167: ElemVariable2
167/677 Test #167: ElemVariable2 ...........................................   Passed    0.18 sec
        Start 168: ElmerGridCloneZ
168/677 Test #168: ElmerGridCloneZ .........................................   Passed    0.19 sec
        Start 169: ElmerGridCloneZ_np3
169/677 Test #169: ElmerGridCloneZ_np3 .....................................   Passed    0.35 sec
        Start 170: ElmerGridExtrudeHelicity
170/677 Test #170: ElmerGridExtrudeHelicity ................................   Passed    0.34 sec
        Start 171: ElmerGridExtrudeMaterial
171/677 Test #171: ElmerGridExtrudeMaterial ................................   Passed    0.24 sec
        Start 172: ElmerGridExtrudeMaterial2
172/677 Test #172: ElmerGridExtrudeMaterial2 ...............................   Passed    0.30 sec
        Start 173: ElmerGridExtrudeOffset
173/677 Test #173: ElmerGridExtrudeOffset ..................................   Passed    0.25 sec
        Start 174: ExpVariableDer
174/677 Test #174: ExpVariableDer ..........................................   Passed    0.58 sec
        Start 175: ExtrudedMesh
175/677 Test #175: ExtrudedMesh ............................................   Passed    0.17 sec
        Start 176: ExtrudedMesh2
176/677 Test #176: ExtrudedMesh2 ...........................................   Passed    0.20 sec
        Start 177: ExtrudedMesh3
177/677 Test #177: ExtrudedMesh3 ...........................................   Passed    0.26 sec
        Start 178: ExtrudedMesh4
178/677 Test #178: ExtrudedMesh4 ...........................................   Passed    0.22 sec
        Start 179: ExtrudedMesh5
179/677 Test #179: ExtrudedMesh5 ...........................................   Passed    1.43 sec
        Start 180: ExtrudedMesh6
180/677 Test #180: ExtrudedMesh6 ...........................................   Passed    0.19 sec
        Start 181: ExtrudedMesh7
181/677 Test #181: ExtrudedMesh7 ...........................................   Passed    0.15 sec
        Start 182: ExtrudedMeshBaseline1
182/677 Test #182: ExtrudedMeshBaseline1 ...................................   Passed    0.19 sec
        Start 183: ExtrudedMeshDG
183/677 Test #183: ExtrudedMeshDG ..........................................   Passed    2.81 sec
        Start 184: ExtrusionStructured2D
184/677 Test #184: ExtrusionStructured2D ...................................   Passed    1.12 sec
        Start 185: FaceElement2D_BCs
185/677 Test #185: FaceElement2D_BCs .......................................   Passed    0.14 sec
        Start 186: FaceElement3D_BCs
186/677 Test #186: FaceElement3D_BCs .......................................   Passed    0.30 sec
        Start 187: FacetShell
187/677 Test #187: FacetShell ..............................................   Passed    0.24 sec
        Start 188: FacetShell2
188/677 Test #188: FacetShell2 .............................................   Passed    0.34 sec
        Start 189: FixPotentialLevels
189/677 Test #189: FixPotentialLevels ......................................   Passed    0.21 sec
        Start 190: FlowResNoslip
190/677 Test #190: FlowResNoslip ...........................................   Passed    3.35 sec
        Start 191: FlowResSlip
191/677 Test #191: FlowResSlip .............................................   Passed    3.14 sec
        Start 192: FourierLoss
192/677 Test #192: FourierLoss .............................................   Passed    1.07 sec
        Start 193: H1BasisEvaluation
193/677 Test #193: H1BasisEvaluation .......................................   Passed    4.31 sec
        Start 194: HarmonicNS
194/677 Test #194: HarmonicNS ..............................................   Passed    0.87 sec
        Start 195: HeatAndDiffusion
195/677 Test #195: HeatAndDiffusion ........................................   Passed    0.33 sec
        Start 196: HeatControl
196/677 Test #196: HeatControl .............................................   Passed    0.16 sec
        Start 197: HeatControl2
197/677 Test #197: HeatControl2 ............................................   Passed    0.17 sec
        Start 198: HeatGap
198/677 Test #198: HeatGap .................................................   Passed    0.18 sec
        Start 199: HeatPlateSym
199/677 Test #199: HeatPlateSym ............................................   Passed    1.97 sec
        Start 200: HeatUniso
200/677 Test #200: HeatUniso ...............................................   Passed    0.17 sec
        Start 201: HeatUnisoMATC
201/677 Test #201: HeatUnisoMATC ...........................................   Passed    0.32 sec
        Start 202: HeatUnisoTable
202/677 Test #202: HeatUnisoTable ..........................................   Passed    0.20 sec
        Start 203: HeatUnisoUDF
203/677 Test #203: HeatUnisoUDF ............................................   Passed    0.33 sec
        Start 204: HelmholtzBEM
204/677 Test #204: HelmholtzBEM ............................................   Passed    0.50 sec
        Start 205: HelmholtzEdge
205/677 Test #205: HelmholtzEdge ...........................................   Passed    0.24 sec
        Start 206: HelmholtzFEM
206/677 Test #206: HelmholtzFEM ............................................   Passed    0.20 sec
        Start 207: HelmholtzFace
207/677 Test #207: HelmholtzFace ...........................................   Passed    0.27 sec
        Start 208: HelmholtzPlaneWaves
208/677 Test #208: HelmholtzPlaneWaves .....................................   Passed    0.37 sec
        Start 209: HelmholtzPlaneWavesAxis
209/677 Test #209: HelmholtzPlaneWavesAxis .................................   Passed    0.39 sec
        Start 210: HelmholtzPlaneWavesScan
210/677 Test #210: HelmholtzPlaneWavesScan .................................   Passed    1.18 sec
        Start 211: HelmholtzStructure
211/677 Test #211: HelmholtzStructure ......................................   Passed    0.35 sec
        Start 212: HelmholtzStructure2
212/677 Test #212: HelmholtzStructure2 .....................................   Passed    0.26 sec
        Start 213: HelmholtzStructure3
213/677 Test #213: HelmholtzStructure3 .....................................   Passed    0.64 sec
        Start 214: Hybrid2dMeshPartitionCyl_np8
214/677 Test #214: Hybrid2dMeshPartitionCyl_np8 ............................***Failed    0.82 sec
        Start 215: Hybrid2dMeshPartitionMetis_np8
215/677 Test #215: Hybrid2dMeshPartitionMetis_np8 ..........................***Failed    0.81 sec
        Start 216: Hybrid2dMeshPartitionMetisConnect_np8
216/677 Test #216: Hybrid2dMeshPartitionMetisConnect_np8 ...................***Failed    0.81 sec
        Start 217: HybridMeshMap
217/677 Test #217: HybridMeshMap ...........................................   Passed    0.52 sec
        Start 218: InductionHeating
218/677 Test #218: InductionHeating ........................................   Passed    0.27 sec
        Start 219: InductionHeating2
219/677 Test #219: InductionHeating2 .......................................   Passed    0.37 sec
        Start 220: InductionHeating3
220/677 Test #220: InductionHeating3 .......................................   Passed    0.30 sec
        Start 221: InternalPartitioning
221/677 Test #221: InternalPartitioning ....................................   Passed    1.29 sec
        Start 222: InternalPartitioning_np8
222/677 Test #222: InternalPartitioning_np8 ................................***Failed    0.56 sec
        Start 223: InternalPartitioning2
223/677 Test #223: InternalPartitioning2 ...................................   Passed    1.25 sec
        Start 224: InternalPartitioning2_np6
224/677 Test #224: InternalPartitioning2_np6 ...............................***Failed    0.54 sec
        Start 225: InternalPartitioning3
225/677 Test #225: InternalPartitioning3 ...................................   Passed    1.33 sec
        Start 226: InternalPartitioning3_np6
226/677 Test #226: InternalPartitioning3_np6 ...............................***Failed    0.69 sec
        Start 227: InternalPartitioning4
227/677 Test #227: InternalPartitioning4 ...................................   Passed    0.58 sec
        Start 228: InternalPartitioning5
228/677 Test #228: InternalPartitioning5 ...................................   Passed    0.70 sec
        Start 229: InternalPartitioning6
229/677 Test #229: InternalPartitioning6 ...................................   Passed    0.51 sec
        Start 230: IpVariable
230/677 Test #230: IpVariable ..............................................   Passed    0.20 sec
        Start 231: IpVariable2
231/677 Test #231: IpVariable2 .............................................   Passed    0.22 sec
        Start 232: IpVariable3
232/677 Test #232: IpVariable3 .............................................   Passed    0.19 sec
        Start 233: IsolineGmsh
233/677 Test #233: IsolineGmsh .............................................   Passed    0.23 sec
        Start 234: JouleHeatToOpenFOAM
234/677 Test #234: JouleHeatToOpenFOAM .....................................   Passed    0.45 sec
        Start 235: KeywordCompare
235/677 Test #235: KeywordCompare ..........................................   Passed    1.91 sec
        Start 236: KeywordCompare2
236/677 Test #236: KeywordCompare2 .........................................   Passed    6.25 sec
        Start 237: KeywordCompare3
237/677 Test #237: KeywordCompare3 .........................................   Passed    5.82 sec
        Start 238: KeywordCompare4
238/677 Test #238: KeywordCompare4 .........................................   Passed    0.21 sec
        Start 239: KeywordCompare5
239/677 Test #239: KeywordCompare5 .........................................   Passed    4.79 sec
        Start 240: L2norm
240/677 Test #240: L2norm ..................................................   Passed    1.04 sec
        Start 241: LevelsetFallingDrop
241/677 Test #241: LevelsetFallingDrop .....................................   Passed    4.40 sec
        Start 242: LimitDisplacement
242/677 Test #242: LimitDisplacement .......................................   Passed    1.82 sec
        Start 243: LimitDisplacement2
243/677 Test #243: LimitDisplacement2 ......................................   Passed    3.64 sec
        Start 244: LimitDisplacement3
244/677 Test #244: LimitDisplacement3 ......................................   Passed    1.16 sec
        Start 245: LimitTemperature
245/677 Test #245: LimitTemperature ........................................   Passed    7.25 sec
        Start 246: LimitTemperature2
246/677 Test #246: LimitTemperature2 .......................................   Passed    7.17 sec
        Start 247: LinearFormsAssembly
247/677 Test #247: LinearFormsAssembly .....................................   Passed   73.12 sec
        Start 248: LinearSystemNamespace
248/677 Test #248: LinearSystemNamespace ...................................   Passed    0.15 sec
        Start 249: LinearSystemNamespace2
249/677 Test #249: LinearSystemNamespace2 ..................................   Passed    0.16 sec
        Start 250: LubricationTunedForce
250/677 Test #250: LubricationTunedForce ...................................   Passed    0.39 sec
        Start 251: MarchingODE1
251/677 Test #251: MarchingODE1 ............................................   Passed    0.14 sec
        Start 252: MarchingODE2
252/677 Test #252: MarchingODE2 ............................................   Passed    0.16 sec
        Start 253: MazeMeshPartitionMetisContig_np6
253/677 Test #253: MazeMeshPartitionMetisContig_np6 ........................***Failed    0.03 sec
        Start 254: MeshColour
254/677 Test #254: MeshColour ..............................................   Passed    0.48 sec
        Start 255: MeshLevelsRestart
255/677 Test #255: MeshLevelsRestart .......................................   Passed    0.41 sec
        Start 256: MeshRefineGrading
256/677 Test #256: MeshRefineGrading .......................................   Passed    1.54 sec
        Start 257: MeshSolverCubeToSphere
257/677 Test #257: MeshSolverCubeToSphere ..................................   Passed    2.02 sec
        Start 258: MeshSwap1
258/677 Test #258: MeshSwap1 ...............................................   Passed    0.19 sec
        Start 259: MgDynDiscontBCs
259/677 Test #259: MgDynDiscontBCs .........................................   Passed    1.23 sec
        Start 260: MinimalExample
260/677 Test #260: MinimalExample ..........................................   Passed    0.18 sec
        Start 261: MixedPoisson2D
261/677 Test #261: MixedPoisson2D ..........................................   Passed    0.20 sec
        Start 262: MixedPoisson3D
262/677 Test #262: MixedPoisson3D ..........................................   Passed    3.66 sec
        Start 263: ModelPDE
263/677 Test #263: ModelPDE ................................................***Failed    2.14 sec
        Start 264: ModelPDEevol
264/677 Test #264: ModelPDEevol ............................................   Passed    0.17 sec
        Start 265: ModelPDEhandle
265/677 Test #265: ModelPDEhandle ..........................................   Passed    0.17 sec
        Start 266: ModelPDEipadapt
266/677 Test #266: ModelPDEipadapt .........................................   Passed    0.39 sec
        Start 267: ModelPDEsplitted
267/677 Test #267: ModelPDEsplitted ........................................   Passed    0.19 sec
        Start 268: ModelPDEthreaded
268/677 Test #268: ModelPDEthreaded ........................................   Passed    0.16 sec
        Start 269: MortarMixedDimensions
269/677 Test #269: MortarMixedDimensions ...................................   Passed    0.21 sec
        Start 270: MortarPoisson2D
270/677 Test #270: MortarPoisson2D .........................................   Passed    0.18 sec
        Start 271: MortarPoisson2Dpriority
271/677 Test #271: MortarPoisson2Dpriority .................................   Passed    0.17 sec
        Start 272: MortarPoisson2Dsum
272/677 Test #272: MortarPoisson2Dsum ......................................   Passed    0.20 sec
        Start 273: MortarPoissonPartz3D_np6
273/677 Test #273: MortarPoissonPartz3D_np6 ................................***Failed    0.07 sec
        Start 274: MortarPoissonPartz3D_np8
274/677 Test #274: MortarPoissonPartz3D_np8 ................................***Failed    0.08 sec
        Start 275: NaturalConvection
275/677 Test #275: NaturalConvection .......................................   Passed    2.32 sec
        Start 276: NaturalConvection2
276/677 Test #276: NaturalConvection2 ......................................   Passed    1.84 sec
        Start 277: NaturalConvection3
277/677 Test #277: NaturalConvection3 ......................................   Passed    3.56 sec
        Start 278: NaturalConvectionRestart
278/677 Test #278: NaturalConvectionRestart ................................   Passed    3.35 sec
        Start 279: NeoHookean2D
279/677 Test #279: NeoHookean2D ............................................   Passed    0.57 sec
        Start 280: NonconformingRestart
280/677 Test #280: NonconformingRestart ....................................   Passed    0.18 sec
        Start 281: NonconformingRestart2
281/677 Test #281: NonconformingRestart2 ...................................   Passed    0.20 sec
        Start 282: NonconformingRestart2par_np3
282/677 Test #282: NonconformingRestart2par_np3 ............................   Passed    0.34 sec
        Start 283: NonconformingRestart3
283/677 Test #283: NonconformingRestart3 ...................................   Passed    0.25 sec
        Start 284: NonconformingRestart4
284/677 Test #284: NonconformingRestart4 ...................................   Passed    0.40 sec
        Start 285: NonconformingRestartStructmap
285/677 Test #285: NonconformingRestartStructmap ...........................   Passed    0.24 sec
        Start 286: NonconformingRestartStructmap_np4
286/677 Test #286: NonconformingRestartStructmap_np4 .......................   Passed    0.39 sec
        Start 287: NonnewtonianChannelFlow
287/677 Test #287: NonnewtonianChannelFlow .................................   Passed    0.40 sec
        Start 288: NonnewtonianChannelFlow_vec
288/677 Test #288: NonnewtonianChannelFlow_vec .............................   Passed    1.83 sec
        Start 289: NormalTangentialBC
289/677 Test #289: NormalTangentialBC ......................................   Passed    0.78 sec
        Start 290: NormalTangentialDisplacement
290/677 Test #290: NormalTangentialDisplacement ............................   Passed    0.37 sec
        Start 291: NormalTangentialDisplacement2
291/677 Test #291: NormalTangentialDisplacement2 ...........................   Passed    0.28 sec
        Start 292: NormalizeBC
292/677 Test #292: NormalizeBC .............................................   Passed    0.15 sec
        Start 293: NormalizeBF
293/677 Test #293: NormalizeBF .............................................   Passed    0.16 sec
        Start 294: NormalizeMaterial
294/677 Test #294: NormalizeMaterial .......................................   Passed    0.18 sec
        Start 295: NtCartesianBC
295/677 Test #295: NtCartesianBC ...........................................   Passed    2.85 sec
        Start 296: OdeSolver1stOrder
296/677 Test #296: OdeSolver1stOrder .......................................   Passed    0.20 sec
        Start 297: OdeSolver2ndOrder
297/677 Test #297: OdeSolver2ndOrder .......................................   Passed    0.19 sec
        Start 298: OptimizeSimplexFourHeaters
298/677 Test #298: OptimizeSimplexFourHeaters ..............................   Passed    1.56 sec
        Start 299: OtherMeshResults
299/677 Test #299: OtherMeshResults ........................................   Passed    0.18 sec
        Start 300: OtherMeshResults_np4
300/677 Test #300: OtherMeshResults_np4 ....................................   Passed    0.44 sec
        Start 301: ParStokes_ISMIP_HOM_A010
301/677 Test #301: ParStokes_ISMIP_HOM_A010 ................................   Passed  149.56 sec
        Start 302: ParStokes_NormalTangentialBC
302/677 Test #302: ParStokes_NormalTangentialBC ............................   Passed    0.57 sec
        Start 303: ParStokes_NormalTangentialBC3D
303/677 Test #303: ParStokes_NormalTangentialBC3D ..........................   Passed   32.71 sec
        Start 304: ParamFourHeaters
304/677 Test #304: ParamFourHeaters ........................................   Passed    0.19 sec
        Start 305: ParticleAdvector
305/677 Test #305: ParticleAdvector ........................................   Passed    0.85 sec
        Start 306: ParticleAdvector2
306/677 Test #306: ParticleAdvector2 .......................................   Passed    1.43 sec
        Start 307: ParticleAdvector3
307/677 Test #307: ParticleAdvector3 .......................................   Passed    1.00 sec
        Start 308: ParticleAdvector3dg
308/677 Test #308: ParticleAdvector3dg .....................................   Passed    1.67 sec
        Start 309: ParticleAdvector3elemental
309/677 Test #309: ParticleAdvector3elemental ..............................   Passed    1.11 sec
        Start 310: ParticleAdvector3ip
310/677 Test #310: ParticleAdvector3ip .....................................   Passed    1.70 sec
        Start 311: ParticleAdvectorPathIntegral
311/677 Test #311: ParticleAdvectorPathIntegral ............................   Passed    4.18 sec
        Start 312: ParticleAdvectorZalesak
312/677 Test #312: ParticleAdvectorZalesak .................................   Passed    2.51 sec
        Start 313: ParticleFalling
313/677 Test #313: ParticleFalling .........................................   Passed    0.24 sec
        Start 314: ParticleFalling2
314/677 Test #314: ParticleFalling2 ........................................   Passed    0.20 sec
        Start 315: ParticleFalling3
315/677 Test #315: ParticleFalling3 ........................................   Passed    0.23 sec
        Start 316: ParticleFallingBlock
316/677 Test #316: ParticleFallingBlock ....................................   Passed    1.25 sec
        Start 317: ParticleHeating
317/677 Test #317: ParticleHeating .........................................   Passed    1.34 sec
        Start 318: PartitioningDirectionalQuads_np4
318/677 Test #318: PartitioningDirectionalQuads_np4 ........................   Passed    0.74 sec
        Start 319: PartitioningUniformQuads_np3
319/677 Test #319: PartitioningUniformQuads_np3 ............................   Passed    0.73 sec
        Start 320: PeriodicTime
320/677 Test #320: PeriodicTime ............................................   Passed    0.64 sec
        Start 321: PhaseChange
321/677 Test #321: PhaseChange .............................................   Passed    1.30 sec
        Start 322: PhaseChange2
322/677 Test #322: PhaseChange2 ............................................   Passed    0.41 sec
        Start 323: PhaseChange3
323/677 Test #323: PhaseChange3 ............................................   Passed    0.39 sec
        Start 324: PhaseChangeB
324/677 Test #324: PhaseChangeB ............................................   Passed    1.32 sec
        Start 325: PlatesHarmonic
325/677 Test #325: PlatesHarmonic ..........................................   Passed    0.22 sec
        Start 326: PlatesHarmonic2
326/677 Test #326: PlatesHarmonic2 .........................................   Passed    0.20 sec
        Start 327: PlatesHarmonic3
327/677 Test #327: PlatesHarmonic3 .........................................   Passed    0.70 sec
        Start 328: PoissonBEM
328/677 Test #328: PoissonBEM ..............................................   Passed    0.17 sec
        Start 329: PoissonBoltzmann
329/677 Test #329: PoissonBoltzmann ........................................   Passed    1.64 sec
        Start 330: PoissonDB
330/677 Test #330: PoissonDB ...............................................   Passed    0.17 sec
        Start 331: PoissonDB_np4
331/677 Test #331: PoissonDB_np4 ...........................................   Passed    0.34 sec
        Start 332: PoissonDB_np8
332/677 Test #332: PoissonDB_np8 ...........................................***Failed    0.03 sec
        Start 333: PoissonDG
333/677 Test #333: PoissonDG ...............................................   Passed    0.24 sec
        Start 334: PoissonDG_np3
334/677 Test #334: PoissonDG_np3 ...........................................   Passed    0.37 sec
        Start 335: PoissonDG_np8
335/677 Test #335: PoissonDG_np8 ...........................................***Failed    0.03 sec
        Start 336: PoissonPFEM
336/677 Test #336: PoissonPFEM .............................................   Passed    0.17 sec
        Start 337: PoissonThreaded
337/677 Test #337: PoissonThreaded .........................................   Passed    1.40 sec
        Start 338: PoissonThreaded2
338/677 Test #338: PoissonThreaded2 ........................................   Passed    1.40 sec
        Start 339: PoissonThreaded3
339/677 Test #339: PoissonThreaded3 ........................................   Passed    1.65 sec
        Start 340: PoissonToroid3D
340/677 Test #340: PoissonToroid3D .........................................   Passed    2.14 sec
        Start 341: PorousPipe
341/677 Test #341: PorousPipe ..............................................   Passed    0.36 sec
        Start 342: PredictorCorrector
342/677 Test #342: PredictorCorrector ......................................   Passed    0.47 sec
        Start 343: Q1Q0
343/677 Test #343: Q1Q0 ....................................................   Passed    0.20 sec
        Start 344: QuadraturesBrick
344/677 Test #344: QuadraturesBrick ........................................   Passed    0.20 sec
        Start 345: QuadraturesWedge
345/677 Test #345: QuadraturesWedge ........................................   Passed    0.21 sec
        Start 346: RaviartThomas2D
346/677 Test #346: RaviartThomas2D .........................................   Passed    0.18 sec
        Start 347: RaviartThomas3D
347/677 Test #347: RaviartThomas3D .........................................   Passed    0.54 sec
        Start 348: RichardsDyke
348/677 Test #348: RichardsDyke ............................................   Passed    2.13 sec
        Start 349: RichardsDyke2
349/677 Test #349: RichardsDyke2 ...........................................   Passed    3.47 sec
        Start 350: RigidMeshMapper1
350/677 Test #350: RigidMeshMapper1 ........................................   Passed    0.29 sec
        Start 351: RigidMeshMapper2
351/677 Test #351: RigidMeshMapper2 ........................................   Passed    0.28 sec
        Start 352: RotatingBCMagnetoDynamics
352/677 Test #352: RotatingBCMagnetoDynamics ...............................   Passed    4.16 sec
        Start 353: RotatingBCMagnetoDynamics2
353/677 Test #353: RotatingBCMagnetoDynamics2 ..............................   Passed   11.95 sec
        Start 354: RotatingBCMagnetoDynamicsConforming
354/677 Test #354: RotatingBCMagnetoDynamicsConforming .....................   Passed   31.41 sec
        Start 355: RotatingBCMagnetoDynamicsConformingAnti
355/677 Test #355: RotatingBCMagnetoDynamicsConformingAnti .................   Passed    3.64 sec
        Start 356: RotatingBCMagnetoDynamicsGeneric
356/677 Test #356: RotatingBCMagnetoDynamicsGeneric ........................   Passed   23.14 sec
        Start 357: RotatingBCPoisson2D
357/677 Test #357: RotatingBCPoisson2D .....................................   Passed    0.84 sec
        Start 358: RotatingBCPoisson3D
358/677 Test #358: RotatingBCPoisson3D .....................................   Passed    3.59 sec
        Start 359: RotatingBCPoisson3DGeneric
359/677 Test #359: RotatingBCPoisson3DGeneric ..............................   Passed    5.24 sec
        Start 360: RotatingBCPoisson3DNT
360/677 Test #360: RotatingBCPoisson3DNT ...................................   Passed    0.82 sec
        Start 361: RotatingBCPoisson3DSymmSkew
361/677 Test #361: RotatingBCPoisson3DSymmSkew .............................   Passed    2.34 sec
        Start 362: RotatingBCPoisson3Daxial
362/677 Test #362: RotatingBCPoisson3Daxial ................................   Passed    4.80 sec
        Start 363: RotatingBCPoisson3Daxial_np6
363/677 Test #363: RotatingBCPoisson3Daxial_np6 ............................***Failed    0.07 sec
        Start 364: RotatingBeamFlow
364/677 Test #364: RotatingBeamFlow ........................................   Passed    4.31 sec
        Start 365: RotatingFlow
365/677 Test #365: RotatingFlow ............................................   Passed    0.40 sec
        Start 366: RotatingHT2D
366/677 Test #366: RotatingHT2D ............................................   Passed    0.81 sec
        Start 367: SaveCircle
367/677 Test #367: SaveCircle ..............................................   Passed    0.70 sec
        Start 368: SaveDependence
368/677 Test #368: SaveDependence ..........................................   Passed    0.20 sec
        Start 369: SaveDependenceSpline
369/677 Test #369: SaveDependenceSpline ....................................   Passed    0.15 sec
        Start 370: SaveLine
370/677 Test #370: SaveLine ................................................   Passed    0.75 sec
        Start 371: SecondOrderEdgeElement2D
371/677 Test #371: SecondOrderEdgeElement2D ................................   Passed    0.50 sec
        Start 372: SecondOrderEdgeElement2D_BCs
372/677 Test #372: SecondOrderEdgeElement2D_BCs ............................   Passed    0.14 sec
        Start 373: SecondOrderEdgeElement3D
373/677 Test #373: SecondOrderEdgeElement3D ................................   Passed    0.32 sec
        Start 374: SensTemperature
374/677 Test #374: SensTemperature .........................................   Passed    0.46 sec
        Start 375: ShallowWaterNS
375/677 Test #375: ShallowWaterNS ..........................................   Passed    1.09 sec
        Start 376: Shell_And_Solid
376/677 Test #376: Shell_And_Solid .........................................   Passed    0.16 sec
        Start 377: Shell_And_Solid2
377/677 Test #377: Shell_And_Solid2 ........................................   Passed    0.20 sec
        Start 378: Shell_BenchmarkCase1_ElementalDirector
378/677 Test #378: Shell_BenchmarkCase1_ElementalDirector ..................   Passed    2.98 sec
        Start 379: Shell_BenchmarkCase1_Quad
379/677 Test #379: Shell_BenchmarkCase1_Quad ...............................   Passed    3.00 sec
        Start 380: Shell_BenchmarkCase1_Tria
380/677 Test #380: Shell_BenchmarkCase1_Tria ...............................   Passed    3.28 sec
        Start 381: Shell_BenchmarkCase2_Quad
381/677 Test #381: Shell_BenchmarkCase2_Quad ...............................   Passed    3.25 sec
        Start 382: Shell_BenchmarkCase2_Tria
382/677 Test #382: Shell_BenchmarkCase2_Tria ...............................   Passed    3.21 sec
        Start 383: Shell_Cantilever
383/677 Test #383: Shell_Cantilever ........................................   Passed    0.22 sec
        Start 384: Shell_Eigenanalysis_Cylinder
384/677 Test #384: Shell_Eigenanalysis_Cylinder ............................   Passed    0.69 sec
        Start 385: Shell_Eigenanalysis_Spherical
385/677 Test #385: Shell_Eigenanalysis_Spherical ...........................   Passed    1.36 sec
        Start 386: Shell_OpenHemisphere
386/677 Test #386: Shell_OpenHemisphere ....................................   Passed    4.61 sec
        Start 387: Shell_PinchedCylinder
387/677 Test #387: Shell_PinchedCylinder ...................................   Passed   20.93 sec
        Start 388: Shell_PlateCase_Quad
388/677 Test #388: Shell_PlateCase_Quad ....................................   Passed    0.27 sec
        Start 389: Shell_With_NormalSolver
389/677 Test #389: Shell_With_NormalSolver .................................   Passed    7.19 sec
        Start 390: Shell_With_NormalSolver_np2
390/677 Test #390: Shell_With_NormalSolver_np2 .............................   Passed    6.87 sec
        Start 391: ShoeboxFsiHarmonic
391/677 Test #391: ShoeboxFsiHarmonic ......................................   Passed    4.84 sec
        Start 392: ShoeboxFsiHarmonic2D
392/677 Test #392: ShoeboxFsiHarmonic2D ....................................   Passed    0.19 sec
        Start 393: ShoeboxFsiHarmonicPlate
393/677 Test #393: ShoeboxFsiHarmonicPlate .................................   Passed    2.29 sec
        Start 394: ShoeboxFsiStatic
394/677 Test #394: ShoeboxFsiStatic ........................................   Passed    1.23 sec
        Start 395: ShoeboxFsiStaticPlate
395/677 Test #395: ShoeboxFsiStaticPlate ...................................   Passed    0.70 sec
        Start 396: ShoeboxFsiStaticShell
396/677 Test #396: ShoeboxFsiStaticShell ...................................   Passed    1.14 sec
        Start 397: ShoeboxHarmonicPlate
397/677 Test #397: ShoeboxHarmonicPlate ....................................   Passed    0.59 sec
        Start 398: ShoeboxHarmonicShell
398/677 Test #398: ShoeboxHarmonicShell ....................................   Passed    0.66 sec
        Start 399: ShoeboxStaticPlate
399/677 Test #399: ShoeboxStaticPlate ......................................   Passed    0.22 sec
        Start 400: ShoeboxStaticShell
400/677 Test #400: ShoeboxStaticShell ......................................   Passed    0.55 sec
        Start 401: SinPlane
401/677 Test #401: SinPlane ................................................   Passed    2.91 sec
        Start 402: SlaveSolverSlots
402/677 Test #402: SlaveSolverSlots ........................................   Passed    0.19 sec
        Start 403: SlaveSolverSlotsScan
403/677 Test #403: SlaveSolverSlotsScan ....................................   Passed    0.16 sec
        Start 404: StatCurrentVec
404/677 Test #404: StatCurrentVec ..........................................   Passed    0.17 sec
        Start 405: StatCurrentVec2
405/677 Test #405: StatCurrentVec2 .........................................   Passed    0.17 sec
        Start 406: StatCurrentVecFarfield
406/677 Test #406: StatCurrentVecFarfield ..................................   Passed    0.18 sec
        Start 407: StatCurrentVecResMatrix
407/677 Test #407: StatCurrentVecResMatrix .................................   Passed    0.24 sec
        Start 408: StatCurrentVecUniso
408/677 Test #408: StatCurrentVecUniso .....................................   Passed    0.16 sec
        Start 409: Step_ke
409/677 Test #409: Step_ke .................................................   Passed    0.82 sec
        Start 410: Step_ns
410/677 Test #410: Step_ns .................................................   Passed    0.31 sec
        Start 411: Step_sa
411/677 Test #411: Step_sa .................................................   Passed    2.96 sec
        Start 412: Step_sst-kw-wf
412/677 Test #412: Step_sst-kw-wf ..........................................   Passed    5.05 sec
        Start 413: Step_stokes
413/677 Test #413: Step_stokes .............................................   Passed    0.19 sec
        Start 414: Step_stokes_block
414/677 Test #414: Step_stokes_block .......................................   Passed    0.22 sec
        Start 415: Step_stokes_vec
415/677 Test #415: Step_stokes_vec .........................................   Passed    0.18 sec
        Start 416: Step_v2f
416/677 Test #416: Step_v2f ................................................   Passed    8.53 sec
        Start 417: StokesPFEM
417/677 Test #417: StokesPFEM ..............................................   Passed    0.21 sec
        Start 418: StokesProj
418/677 Test #418: StokesProj ..............................................   Passed    0.36 sec
        Start 419: StrainCalculation01
419/677 Test #419: StrainCalculation01 .....................................   Passed    0.28 sec
        Start 420: StrainCalculation02
420/677 Test #420: StrainCalculation02 .....................................   Passed    2.86 sec
        Start 421: StrainCalculation03
421/677 Test #421: StrainCalculation03 .....................................   Passed    3.67 sec
        Start 422: StressConstraintModes
422/677 Test #422: StressConstraintModes ...................................   Passed    0.22 sec
        Start 423: StressConstraintModes2
423/677 Test #423: StressConstraintModes2 ..................................   Passed    0.17 sec
        Start 424: StressConstraintModes3
424/677 Test #424: StressConstraintModes3 ..................................   Passed   20.52 sec
        Start 425: StressEigen
425/677 Test #425: StressEigen .............................................   Passed    0.51 sec
        Start 426: StressEigen3D
426/677 Test #426: StressEigen3D ...........................................   Passed   12.81 sec
        Start 427: StructuredHeightDepth
427/677 Test #427: StructuredHeightDepth ...................................   Passed    1.38 sec
        Start 428: StructuredSpread
428/677 Test #428: StructuredSpread ........................................   Passed    0.93 sec
        Start 429: TankAst
429/677 Test #429: TankAst .................................................   Passed    0.21 sec
        Start 430: TemperatureFromOpenFOAM
430/677 Test #430: TemperatureFromOpenFOAM .................................   Passed    1.09 sec
        Start 431: ThermalActuator
431/677 Test #431: ThermalActuator .........................................   Passed   14.09 sec
        Start 432: ThermalBiMetal
432/677 Test #432: ThermalBiMetal ..........................................   Passed    0.20 sec
        Start 433: ThermalBiMetal2
433/677 Test #433: ThermalBiMetal2 .........................................   Passed    0.22 sec
        Start 434: ThermalCompress
434/677 Test #434: ThermalCompress .........................................   Passed    0.38 sec
        Start 435: ThermalPipe2D
435/677 Test #435: ThermalPipe2D ...........................................   Passed    0.19 sec
        Start 436: ThermalPipe3D
436/677 Test #436: ThermalPipe3D ...........................................   Passed    1.39 sec
        Start 437: ThermoElectric
437/677 Test #437: ThermoElectric ..........................................   Passed    0.24 sec
        Start 438: TimeAdapt
438/677 Test #438: TimeAdapt ...............................................   Passed    1.35 sec
        Start 439: TimeFunc
439/677 Test #439: TimeFunc ................................................   Passed    0.80 sec
        Start 440: TransientCostFourHeaters
440/677 Test #440: TransientCostFourHeaters ................................   Passed    0.78 sec
        Start 441: TravellingHeater
441/677 Test #441: TravellingHeater ........................................   Passed    1.80 sec
        Start 442: TravellingHeater2
442/677 Test #442: TravellingHeater2 .......................................   Passed    2.43 sec
        Start 443: UMAT_StVenant_2D
443/677 Test #443: UMAT_StVenant_2D ........................................   Passed    0.49 sec
        Start 444: UMAT_StVenant_axials
444/677 Test #444: UMAT_StVenant_axials ....................................   Passed    0.26 sec
        Start 445: UMAT_linear_isotropic_2D
445/677 Test #445: UMAT_linear_isotropic_2D ................................   Passed    0.23 sec
        Start 446: VectorHelmholtzWaveguide
446/677 Test #446: VectorHelmholtzWaveguide ................................   Passed    3.58 sec
        Start 447: VectorHelmholtzWaveguide2
447/677 Test #447: VectorHelmholtzWaveguide2 ...............................   Passed    5.12 sec
        Start 448: VectorHelmholtzWaveguide3
448/677 Test #448: VectorHelmholtzWaveguide3 ...............................   Passed    0.55 sec
        Start 449: VectorHelmholtzWaveguide4
449/677 Test #449: VectorHelmholtzWaveguide4 ...............................   Passed    1.37 sec
        Start 450: VectorHelmholtzWaveguide5
450/677 Test #450: VectorHelmholtzWaveguide5 ...............................   Passed    0.73 sec
        Start 451: ViscoElasticMaxwell
451/677 Test #451: ViscoElasticMaxwell .....................................   Passed    9.77 sec
        Start 452: WaveEqu
452/677 Test #452: WaveEqu .................................................   Passed    0.37 sec
        Start 453: WaveEquEigen
453/677 Test #453: WaveEquEigen ............................................   Passed    0.18 sec
        Start 454: WeightComputation
454/677 Test #454: WeightComputation .......................................   Passed    0.26 sec
        Start 455: WinkelBmPoissonCgIlu0_np2
455/677 Test #455: WinkelBmPoissonCgIlu0_np2 ...............................   Passed    1.08 sec
        Start 456: WinkelBmPoissonCgIlu0_np8
456/677 Test #456: WinkelBmPoissonCgIlu0_np8 ...............................***Failed    0.13 sec
        Start 457: WinkelBmPoissonIdrsIlu0_np2
457/677 Test #457: WinkelBmPoissonIdrsIlu0_np2 .............................   Passed    0.83 sec
        Start 458: WinkelBmPoissonIdrsIlu0_np8
458/677 Test #458: WinkelBmPoissonIdrsIlu0_np8 .............................***Failed    0.10 sec
        Start 459: WinkelPartitionMetis_np8
459/677 Test #459: WinkelPartitionMetis_np8 ................................***Failed    0.08 sec
        Start 460: WinkelPartitionMetisConnect_np8
460/677 Test #460: WinkelPartitionMetisConnect_np8 .........................***Failed    0.12 sec
        Start 461: WinkelPartitionMetisRec_np8
461/677 Test #461: WinkelPartitionMetisRec_np8 .............................***Failed    0.12 sec
        Start 462: WinkelPartitionRecursive_np8
462/677 Test #462: WinkelPartitionRecursive_np8 ............................***Failed    0.05 sec
        Start 463: WinkelPartitionRecursiveHaloBC_np8
463/677 Test #463: WinkelPartitionRecursiveHaloBC_np8 ......................***Failed    0.06 sec
        Start 464: WinkelPartitionRecursiveLevel2_np8
464/677 Test #464: WinkelPartitionRecursiveLevel2_np8 ......................***Failed    0.06 sec
        Start 465: WinkelPartitionUniform_np4
465/677 Test #465: WinkelPartitionUniform_np4 ..............................   Passed    0.40 sec
        Start 466: WinkelPartitionUniformHaloBC_np4
466/677 Test #466: WinkelPartitionUniformHaloBC_np4 ........................   Passed    0.42 sec
        Start 467: WinkelPartitionUniformLevel2_np4
467/677 Test #467: WinkelPartitionUniformLevel2_np4 ........................   Passed    0.68 sec
        Start 468: WinkelPoissonMetisKwayDual
468/677 Test #468: WinkelPoissonMetisKwayDual ..............................   Passed   12.15 sec
        Start 469: WinkelPoissonMetisKwayDual_np2
469/677 Test #469: WinkelPoissonMetisKwayDual_np2 ..........................   Passed   11.02 sec
        Start 470: WinkelPoissonMetisKwayDual_np4
470/677 Test #470: WinkelPoissonMetisKwayDual_np4 ..........................   Passed    8.20 sec
        Start 471: WinkelPoissonMetisKwayDual_np8
471/677 Test #471: WinkelPoissonMetisKwayDual_np8 ..........................***Failed    0.09 sec
        Start 472: WinkelPoissonMetisKwayNodal_np2
472/677 Test #472: WinkelPoissonMetisKwayNodal_np2 .........................   Passed    8.16 sec
        Start 473: WinkelPoissonMetisKwayNodal_np4
473/677 Test #473: WinkelPoissonMetisKwayNodal_np4 .........................   Passed    6.41 sec
        Start 474: WinkelPoissonMetisKwayNodal_np8
474/677 Test #474: WinkelPoissonMetisKwayNodal_np8 .........................***Failed    0.11 sec
        Start 475: WinkelPoissonPartitionRecursive_np8
475/677 Test #475: WinkelPoissonPartitionRecursive_np8 .....................***Failed    0.05 sec
        Start 476: WinkelPoissonPartitionUniform_np4
476/677 Test #476: WinkelPoissonPartitionUniform_np4 .......................   Passed    6.37 sec
        Start 477: Zirka
477/677 Test #477: Zirka ...................................................   Passed    5.52 sec
        Start 478: adaptivity1
478/677 Test #478: adaptivity1 .............................................   Passed    0.28 sec
        Start 479: adaptivity2
479/677 Test #479: adaptivity2 .............................................   Passed    0.25 sec
        Start 480: adaptivity3
480/677 Test #480: adaptivity3 .............................................   Passed    0.39 sec
        Start 481: adaptivity4
481/677 Test #481: adaptivity4 .............................................   Passed    0.25 sec
        Start 482: adaptivity5
482/677 Test #482: adaptivity5 .............................................   Passed    0.27 sec
        Start 483: adv_diff1
483/677 Test #483: adv_diff1 ...............................................   Passed    0.38 sec
        Start 484: adv_diff2
484/677 Test #484: adv_diff2 ...............................................   Passed    0.42 sec
        Start 485: adv_diff3
485/677 Test #485: adv_diff3 ...............................................   Passed    0.99 sec
        Start 486: adv_diff4
486/677 Test #486: adv_diff4 ...............................................   Passed    1.47 sec
        Start 487: amultg
487/677 Test #487: amultg ..................................................   Passed    0.56 sec
        Start 488: amultg2
488/677 Test #488: amultg2 .................................................   Passed    0.34 sec
        Start 489: beam-springs
489/677 Test #489: beam-springs ............................................   Passed    0.45 sec
        Start 490: bentonite
490/677 Test #490: bentonite ...............................................   Passed    0.18 sec
        Start 491: bodydir
491/677 Test #491: bodydir .................................................   Passed    0.17 sec
        Start 492: bodydir2
492/677 Test #492: bodydir2 ................................................   Passed    1.38 sec
        Start 493: bodyload
493/677 Test #493: bodyload ................................................   Passed    0.15 sec
        Start 494: buckling
494/677 Test #494: buckling ................................................   Passed    0.22 sec
        Start 495: channel_v2f
495/677 Test #495: channel_v2f .............................................   Passed    2.33 sec
        Start 496: circuits2D_harmonic_foil
496/677 Test #496: circuits2D_harmonic_foil ................................   Passed    0.29 sec
        Start 497: circuits2D_harmonic_massive
497/677 Test #497: circuits2D_harmonic_massive .............................   Passed    0.25 sec
        Start 498: circuits2D_harmonic_stranded
498/677 Test #498: circuits2D_harmonic_stranded ............................   Passed    0.19 sec
        Start 499: circuits2D_harmonic_stranded_explicit_coil_resistance
499/677 Test #499: circuits2D_harmonic_stranded_explicit_coil_resistance ...   Passed    0.19 sec
        Start 500: circuits2D_harmonic_stranded_homogenization
500/677 Test #500: circuits2D_harmonic_stranded_homogenization .............   Passed    0.22 sec
        Start 501: circuits2D_scan_harmonics
501/677 Test #501: circuits2D_scan_harmonics ...............................   Passed    0.60 sec
        Start 502: circuits2D_transient_foil
502/677 Test #502: circuits2D_transient_foil ...............................   Passed    0.32 sec
        Start 503: circuits2D_transient_massive
503/677 Test #503: circuits2D_transient_massive ............................   Passed    0.25 sec
        Start 504: circuits2D_transient_stranded
504/677 Test #504: circuits2D_transient_stranded ...........................   Passed    0.31 sec
        Start 505: circuits2D_with_hysteresis
505/677 Test #505: circuits2D_with_hysteresis ..............................   Passed    6.08 sec
        Start 506: circuits2D_with_hysteresis_axi
506/677 Test #506: circuits2D_with_hysteresis_axi ..........................   Passed    8.48 sec
        Start 507: circuits_harmonic_foil
507/677 Test #507: circuits_harmonic_foil ..................................   Passed    5.99 sec
        Start 508: circuits_harmonic_massive
508/677 Test #508: circuits_harmonic_massive ...............................   Passed    0.49 sec
        Start 509: circuits_harmonic_stranded
509/677 Test #509: circuits_harmonic_stranded ..............................   Passed    4.56 sec
        Start 510: circuits_harmonic_stranded_homogenization
510/677 Test #510: circuits_harmonic_stranded_homogenization ...............   Passed    5.20 sec
        Start 511: circuits_transient_foil
511/677 Test #511: circuits_transient_foil .................................   Passed    5.27 sec
        Start 512: circuits_transient_massive
512/677 Test #512: circuits_transient_massive ..............................   Passed    2.79 sec
        Start 513: circuits_transient_stranded
513/677 Test #513: circuits_transient_stranded .............................   Passed    3.62 sec
        Start 514: cmultg
514/677 Test #514: cmultg ..................................................   Passed    1.76 sec
        Start 515: coating
515/677 Test #515: coating .................................................   Passed    1.48 sec
        Start 516: coordinate_transform
516/677 Test #516: coordinate_transform ....................................   Passed    0.20 sec
        Start 517: current
517/677 Test #517: current .................................................   Passed    0.26 sec
        Start 518: current_heat_control
518/677 Test #518: current_heat_control ....................................   Passed    0.34 sec
        Start 519: diffuser_sa
519/677 Test #519: diffuser_sa .............................................   Passed    3.39 sec
        Start 520: diffuser_sst
520/677 Test #520: diffuser_sst ............................................   Passed    2.64 sec
        Start 521: diffuser_v2f
521/677 Test #521: diffuser_v2f ............................................   Passed    3.06 sec
        Start 522: el_adaptivity
522/677 Test #522: el_adaptivity ...........................................   Passed    0.25 sec
        Start 523: elasticity
523/677 Test #523: elasticity ..............................................   Passed    0.38 sec
        Start 524: elasticity_with_springs
524/677 Test #524: elasticity_with_springs .................................   Passed    0.30 sec
        Start 525: elstat
525/677 Test #525: elstat ..................................................   Passed    1.59 sec
        Start 526: elstat_infty
526/677 Test #526: elstat_infty ............................................   Passed    1.04 sec
        Start 527: elstat_source
527/677 Test #527: elstat_source ...........................................   Passed    0.18 sec
        Start 528: fluxsolver
528/677 Test #528: fluxsolver ..............................................   Passed    0.19 sec
        Start 529: fluxsolver2
529/677 Test #529: fluxsolver2 .............................................   Passed    0.15 sec
        Start 530: fluxsolver3
530/677 Test #530: fluxsolver3 .............................................   Passed    0.23 sec
        Start 531: freesurf
531/677 Test #531: freesurf ................................................   Passed    0.55 sec
        Start 532: freesurf_axi
532/677 Test #532: freesurf_axi ............................................   Passed    0.60 sec
        Start 533: freesurf_int
533/677 Test #533: freesurf_int ............................................   Passed    0.46 sec
        Start 534: freesurf_ltd
534/677 Test #534: freesurf_ltd ............................................   Passed    1.92 sec
        Start 535: freesurf_maxd
535/677 Test #535: freesurf_maxd ...........................................   Passed    0.74 sec
        Start 536: freesurf_maxd_np2
536/677 Test #536: freesurf_maxd_np2 .......................................   Passed    0.72 sec
        Start 537: freesurf_maxd_np4
537/677 Test #537: freesurf_maxd_np4 .......................................   Passed    0.85 sec
        Start 538: freesurf_maxd_local
538/677 Test #538: freesurf_maxd_local .....................................   Passed    0.77 sec
        Start 539: freesurf_maxd_local_np2
539/677 Test #539: freesurf_maxd_local_np2 .................................   Passed    0.78 sec
        Start 540: freesurf_maxd_local_np4
540/677 Test #540: freesurf_maxd_local_np4 .................................   Passed    0.87 sec
        Start 541: freesurf_sloshing_2d
541/677 Test #541: freesurf_sloshing_2d ....................................   Passed    2.53 sec
        Start 542: fsi_beam
542/677 Test #542: fsi_beam ................................................   Passed    0.72 sec
        Start 543: fsi_beam_nodalforce
543/677 Test #543: fsi_beam_nodalforce .....................................   Passed    0.81 sec
        Start 544: fsi_beam_optimize
544/677 Test #544: fsi_beam_optimize .......................................   Passed    2.28 sec
        Start 545: fsi_box
545/677 Test #545: fsi_box .................................................   Passed    1.14 sec
        Start 546: fsi_box2
546/677 Test #546: fsi_box2 ................................................   Passed    0.83 sec
        Start 547: geomstiff
547/677 Test #547: geomstiff ...............................................   Passed    0.24 sec
        Start 548: gmultg
548/677 Test #548: gmultg ..................................................   Passed    0.24 sec
        Start 549: heateq
549/677 Test #549: heateq ..................................................   Passed    0.25 sec
        Start 550: heateq_bdf2
550/677 Test #550: heateq_bdf2 .............................................   Passed    0.22 sec
        Start 551: heateq_bdf3
551/677 Test #551: heateq_bdf3 .............................................   Passed    0.21 sec
        Start 552: heateq_infty
552/677 Test #552: heateq_infty ............................................   Passed    1.09 sec
        Start 553: heateq_infty_np2
553/677 Test #553: heateq_infty_np2 ........................................   Passed    0.91 sec
        Start 554: heateq_infty_np4
554/677 Test #554: heateq_infty_np4 ........................................   Passed    1.15 sec
        Start 555: heateq_newmark
555/677 Test #555: heateq_newmark ..........................................   Passed    0.19 sec
        Start 556: heateq_newmark_global
556/677 Test #556: heateq_newmark_global ...................................   Passed    0.24 sec
        Start 557: heateq_resmode
557/677 Test #557: heateq_resmode ..........................................   Passed    0.44 sec
        Start 558: heateq_spline_table
558/677 Test #558: heateq_spline_table .....................................   Passed    0.43 sec
        Start 559: heateq_steady_start
559/677 Test #559: heateq_steady_start .....................................   Passed    0.27 sec
        Start 560: levelset1
560/677 Test #560: levelset1 ...............................................   Passed    2.01 sec
        Start 561: levelset2
561/677 Test #561: levelset2 ...............................................   Passed    1.03 sec
        Start 562: levelset3
562/677 Test #562: levelset3 ...............................................   Passed    4.61 sec
        Start 563: levelset3b
563/677 Test #563: levelset3b ..............................................   Passed    3.89 sec
        Start 564: linearsolvers
564/677 Test #564: linearsolvers ...........................................   Passed    0.25 sec
        Start 565: linearsolvers_cmplx
565/677 Test #565: linearsolvers_cmplx .....................................   Passed    0.63 sec
        Start 566: marangoni
566/677 Test #566: marangoni ...............................................   Passed    0.20 sec
        Start 567: mgdyn2D_compute_average_b
567/677 Test #567: mgdyn2D_compute_average_b ...............................   Passed    0.46 sec
        Start 568: mgdyn2D_compute_bodycurrent
568/677 Test #568: mgdyn2D_compute_bodycurrent .............................   Passed    0.48 sec
        Start 569: mgdyn2D_compute_complex_power
569/677 Test #569: mgdyn2D_compute_complex_power ...........................   Passed    0.46 sec
        Start 570: mgdyn2D_em
570/677 Test #570: mgdyn2D_em ..............................................   Passed    2.64 sec
        Start 571: mgdyn2D_em_conforming
571/677 Test #571: mgdyn2D_em_conforming ...................................   Passed    0.63 sec
        Start 572: mgdyn2D_em_harmonic
572/677 Test #572: mgdyn2D_em_harmonic .....................................   Passed    0.79 sec
        Start 573: mgdyn2D_harmonic_anisotropic_permeability
573/677 Test #573: mgdyn2D_harmonic_anisotropic_permeability ...............   Passed    0.22 sec
        Start 574: mgdyn2D_pm
574/677 Test #574: mgdyn2D_pm ..............................................   Passed    0.26 sec
        Start 575: mgdyn2D_scan_homogenization_elementary_solutions
575/677 Test #575: mgdyn2D_scan_homogenization_elementary_solutions ........   Passed    6.85 sec
        Start 576: mgdyn_3phase
576/677 Test #576: mgdyn_3phase ............................................   Passed    3.45 sec
        Start 577: mgdyn_airgap
577/677 Test #577: mgdyn_airgap ............................................   Passed    0.22 sec
        Start 578: mgdyn_airgap2
578/677 Test #578: mgdyn_airgap2 ...........................................   Passed    0.23 sec
        Start 579: mgdyn_airgap_force
579/677 Test #579: mgdyn_airgap_force ......................................   Passed   14.72 sec
        Start 580: mgdyn_airgap_force_np2
580/677 Test #580: mgdyn_airgap_force_np2 ..................................   Passed    8.49 sec
        Start 581: mgdyn_airgap_harmonic
581/677 Test #581: mgdyn_airgap_harmonic ...................................   Passed    0.27 sec
        Start 582: mgdyn_angular_steady
582/677 Test #582: mgdyn_angular_steady ....................................   Passed    3.48 sec
        Start 583: mgdyn_angular_steady_np2
583/677 Test #583: mgdyn_angular_steady_np2 ................................   Passed    2.33 sec
        Start 584: mgdyn_anisotropic_cond
584/677 Test #584: mgdyn_anisotropic_cond ..................................   Passed    4.33 sec
        Start 585: mgdyn_anisotropic_rel
585/677 Test #585: mgdyn_anisotropic_rel ...................................   Passed    1.62 sec
        Start 586: mgdyn_bh
586/677 Test #586: mgdyn_bh ................................................   Passed   12.89 sec
        Start 587: mgdyn_bh_gauge
587/677 Test #587: mgdyn_bh_gauge ..........................................   Passed    4.39 sec
        Start 588: mgdyn_bh_gauge_np2
588/677 Test #588: mgdyn_bh_gauge_np2 ......................................   Passed    2.97 sec
        Start 589: mgdyn_bh_gauge2
589/677 Test #589: mgdyn_bh_gauge2 .........................................   Passed    4.00 sec
        Start 590: mgdyn_faraday_disc
590/677 Test #590: mgdyn_faraday_disc ......................................   Passed   36.93 sec
        Start 591: mgdyn_faraday_disc_transient
591/677 Test #591: mgdyn_faraday_disc_transient ............................   Passed   78.64 sec
        Start 592: mgdyn_faraday_wheel
592/677 Test #592: mgdyn_faraday_wheel .....................................   Passed   47.96 sec
        Start 593: mgdyn_harmonic
593/677 Test #593: mgdyn_harmonic ..........................................   Passed    9.58 sec
        Start 594: mgdyn_harmonic_loss
594/677 Test #594: mgdyn_harmonic_loss .....................................   Passed    8.03 sec
        Start 595: mgdyn_harmonic_wire
595/677 Test #595: mgdyn_harmonic_wire .....................................   Passed    6.28 sec
        Start 596: mgdyn_lamstack_lowfreq_harmonic
596/677 Test #596: mgdyn_lamstack_lowfreq_harmonic .........................   Passed    9.02 sec
        Start 597: mgdyn_lamstack_lowfreq_transient
597/677 Test #597: mgdyn_lamstack_lowfreq_transient ........................   Passed    9.88 sec
        Start 598: mgdyn_lamstack_widefreq_harmonic
598/677 Test #598: mgdyn_lamstack_widefreq_harmonic ........................   Passed    5.19 sec
        Start 599: mgdyn_nodalforce2d
599/677 Test #599: mgdyn_nodalforce2d ......................................   Passed    0.32 sec
        Start 600: mgdyn_steady
600/677 Test #600: mgdyn_steady ............................................   Passed    4.80 sec
        Start 601: mgdyn_steady_2ndorder
601/677 Test #601: mgdyn_steady_2ndorder ...................................   Passed    1.01 sec
        Start 602: mgdyn_steady_periodic
602/677 Test #602: mgdyn_steady_periodic ...................................   Passed    5.50 sec
        Start 603: mgdyn_steady_piolaversion
603/677 Test #603: mgdyn_steady_piolaversion ...............................   Passed    0.64 sec
        Start 604: mgdyn_steady_plate
604/677 Test #604: mgdyn_steady_plate ......................................   Passed    1.34 sec
        Start 605: mgdyn_steady_wire
605/677 Test #605: mgdyn_steady_wire .......................................   Passed    2.12 sec
        Start 606: mgdyn_steady_wire2
606/677 Test #606: mgdyn_steady_wire2 ......................................   Passed    6.42 sec
        Start 607: mgdyn_steady_wire_conforming
607/677 Test #607: mgdyn_steady_wire_conforming ............................   Passed    1.30 sec
        Start 608: mgdyn_steady_wire_periodic
608/677 Test #608: mgdyn_steady_wire_periodic ..............................   Passed    8.17 sec
        Start 609: mgdyn_stump_jfix
609/677 Test #609: mgdyn_stump_jfix ........................................   Passed    4.20 sec
        Start 610: mgdyn_stump_jfix2
610/677 Test #610: mgdyn_stump_jfix2 .......................................   Passed    3.98 sec
        Start 611: mgdyn_torus
611/677 Test #611: mgdyn_torus .............................................   Passed    3.21 sec
        Start 612: mgdyn_torus_np2
612/677 Test #612: mgdyn_torus_np2 .........................................   Passed    2.30 sec
        Start 613: mgdyn_torus_np4
613/677 Test #613: mgdyn_torus_np4 .........................................   Passed    1.72 sec
        Start 614: mgdyn_torus_harmonic
614/677 Test #614: mgdyn_torus_harmonic ....................................   Passed    8.58 sec
        Start 615: mgdyn_transient
615/677 Test #615: mgdyn_transient .........................................   Passed   12.10 sec
        Start 616: mgdyn_transient_loss
616/677 Test #616: mgdyn_transient_loss ....................................   Passed   13.39 sec
        Start 617: mhd
617/677 Test #617: mhd .....................................................   Passed    1.08 sec
        Start 618: mhd2
618/677 Test #618: mhd2 ....................................................   Passed    1.29 sec
        Start 619: multimesh
619/677 Test #619: multimesh ...............................................   Passed    0.35 sec
        Start 620: normals
620/677 Test #620: normals .................................................   Passed    0.16 sec
        Start 621: passive
621/677 Test #621: passive .................................................   Passed    0.35 sec
        Start 622: periodic1
622/677 Test #622: periodic1 ...............................................   Passed    0.20 sec
        Start 623: periodic2
623/677 Test #623: periodic2 ...............................................   Passed    0.19 sec
        Start 624: periodic3
624/677 Test #624: periodic3 ...............................................   Passed    0.22 sec
        Start 625: periodic_explicit
625/677 Test #625: periodic_explicit .......................................   Passed    0.58 sec
        Start 626: periodic_homogenize
626/677 Test #626: periodic_homogenize .....................................   Passed    0.29 sec
        Start 627: periodic_nonconforming
627/677 Test #627: periodic_nonconforming ..................................   Passed    0.17 sec
        Start 628: periodic_offset
628/677 Test #628: periodic_offset .........................................   Passed    0.19 sec
        Start 629: periodic_offset2
629/677 Test #629: periodic_offset2 ........................................   Passed    0.44 sec
        Start 630: periodic_rot
630/677 Test #630: periodic_rot ............................................   Passed    0.18 sec
        Start 631: piezo
631/677 Test #631: piezo ...................................................   Passed    0.23 sec
        Start 632: plates
632/677 Test #632: plates ..................................................   Passed    0.16 sec
        Start 633: platesEigen
633/677 Test #633: platesEigen .............................................   Passed    0.38 sec
        Start 634: pmultg
634/677 Test #634: pmultg ..................................................   Passed    1.62 sec
        Start 635: pointdir
635/677 Test #635: pointdir ................................................   Passed    0.20 sec
        Start 636: pointload
636/677 Test #636: pointload ...............................................   Passed    0.19 sec
        Start 637: pointload2
637/677 Test #637: pointload2 ..............................................   Passed    1.01 sec
        Start 638: poisson_steady_conforming
638/677 Test #638: poisson_steady_conforming ...............................   Passed    0.33 sec
        Start 639: poisson_steady_conforming_anti
639/677 Test #639: poisson_steady_conforming_anti ..........................   Passed    0.29 sec
        Start 640: poisson_transient_conforming_anti
640/677 Test #640: poisson_transient_conforming_anti .......................   Passed    0.23 sec
        Start 641: poisson_transient_conforming_anti_np4
641/677 Test #641: poisson_transient_conforming_anti_np4 ...................   Passed    0.48 sec
        Start 642: poisson_transient_conforming_anti_np8
642/677 Test #642: poisson_transient_conforming_anti_np8 ...................***Failed    0.04 sec
        Start 643: radiation
643/677 Test #643: radiation ...............................................   Passed    0.24 sec
        Start 644: radiation2
644/677 Test #644: radiation2 ..............................................   Passed    0.30 sec
        Start 645: radiation2d
645/677 Test #645: radiation2d .............................................   Passed    0.61 sec
        Start 646: radiation2dAA
646/677 Test #646: radiation2dAA ...........................................   Passed    0.41 sec
        Start 647: radiation2dsymm
647/677 Test #647: radiation2dsymm .........................................   Passed    0.21 sec
        Start 648: radiation3d
648/677 Test #648: radiation3d .............................................   Passed    0.71 sec
        Start 649: radiation_bin
649/677 Test #649: radiation_bin ...........................................   Passed    0.20 sec
        Start 650: radiation_dg
650/677 Test #650: radiation_dg ............................................   Passed    0.26 sec
        Start 651: reload
651/677 Test #651: reload ..................................................   Passed    0.49 sec
        Start 652: reynolds1
652/677 Test #652: reynolds1 ...............................................   Passed    2.09 sec
        Start 653: reynolds2
653/677 Test #653: reynolds2 ...............................................   Passed    0.53 sec
        Start 654: reynolds3
654/677 Test #654: reynolds3 ...............................................   Passed    5.12 sec
        Start 655: reynolds3b
655/677 Test #655: reynolds3b ..............................................   Passed    3.09 sec
        Start 656: rgdblock
656/677 Test #656: rgdblock ................................................   Passed    0.97 sec
        Start 657: rot_aniso
657/677 Test #657: rot_aniso ...............................................   Passed    1.83 sec
        Start 658: rotflow
658/677 Test #658: rotflow .................................................   Passed    0.51 sec
        Start 659: savescalars
659/677 Test #659: savescalars .............................................   Passed    0.24 sec
        Start 660: savescalars_boundary
660/677 Test #660: savescalars_boundary ....................................   Passed    0.25 sec
        Start 661: savescalars_flux
661/677 Test #661: savescalars_flux ........................................   Passed    0.19 sec
        Start 662: savescalars_many
662/677 Test #662: savescalars_many ........................................   Passed    0.26 sec
        Start 663: savescalars_mask
663/677 Test #663: savescalars_mask ........................................   Passed    0.18 sec
        Start 664: staged_sim
664/677 Test #664: staged_sim ..............................................   Passed    0.79 sec
        Start 665: streamlines
665/677 Test #665: streamlines .............................................   Passed    0.29 sec
        Start 666: stress
666/677 Test #666: stress ..................................................   Passed    0.27 sec
        Start 667: structmap
667/677 Test #667: structmap ...............................................   Passed    0.19 sec
        Start 668: structmap2
668/677 Test #668: structmap2 ..............................................   Passed    0.58 sec
        Start 669: structmap3
669/677 Test #669: structmap3 ..............................................   Passed    5.49 sec
        Start 670: structmap4
670/677 Test #670: structmap4 ..............................................   Passed    0.41 sec
        Start 671: structmap5
671/677 Test #671: structmap5 ..............................................   Passed    0.38 sec
        Start 672: structmap6
672/677 Test #672: structmap6 ..............................................   Passed    0.41 sec
        Start 673: structmap_multilayer
673/677 Test #673: structmap_multilayer ....................................   Passed    0.20 sec
        Start 674: structmap_p2
674/677 Test #674: structmap_p2 ............................................   Passed    0.18 sec
        Start 675: tresca
675/677 Test #675: tresca ..................................................   Passed    0.20 sec
        Start 676: vortex2d
676/677 Test #676: vortex2d ................................................   Passed    0.62 sec
        Start 677: vortex3d
677/677 Test #677: vortex3d ................................................   Passed    0.68 sec

95% tests passed, 34 tests failed out of 677

Label Time Summary:
2D                =  25.66 sec*proc (16 tests)
3D                =  27.93 sec*proc (7 tests)
aster             =   6.34 sec*proc (5 tests)
beam              =   0.33 sec*proc (2 tests)
benchmark         = 142.59 sec*proc (16 tests)
block             =  19.47 sec*proc (19 tests)
circuit_utils     =   0.20 sec*proc (1 test)
circuits          =  45.12 sec*proc (18 tests)
contact           = 121.70 sec*proc (24 tests)
dg                =   0.54 sec*proc (3 tests)
elasticity        =  10.76 sec*proc (4 tests)
elasticsolve      = 205.20 sec*proc (43 tests)
eliminate         =   0.76 sec*proc (4 tests)
elmerice          = 149.56 sec*proc (1 test)
em-wave           =   6.37 sec*proc (4 tests)
extrude           =   2.49 sec*proc (3 tests)
fsi               =  22.22 sec*proc (13 tests)
gauge             =  11.36 sec*proc (3 tests)
harmonic          =  28.47 sec*proc (20 tests)
heateq            =  66.14 sec*proc (43 tests)
helmholtz         =   3.39 sec*proc (7 tests)
homogenization    =   5.41 sec*proc (2 tests)
hutiter           =   2.14 sec*proc (4 tests)
matc              =  48.13 sec*proc (30 tests)
mgdyn             = 225.30 sec*proc (28 tests)
mortar            =  48.78 sec*proc (2 tests)
namespace         =   3.06 sec*proc (7 tests)
parallel          = 104.06 sec*proc (90 tests)
param             =   0.19 sec*proc (1 test)
particle          =  22.33 sec*proc (14 tests)
plate             =   0.22 sec*proc (1 test)
quick             =  85.77 sec*proc (290 tests)
scanning          =   7.45 sec*proc (2 tests)
serial            = 1468.29 sec*proc (587 tests)
shell             =  60.58 sec*proc (18 tests)
slow              = 170.57 sec*proc (2 tests)
stranded          =   5.20 sec*proc (1 test)
threaded          =  77.90 sec*proc (6 tests)
transient         = 117.74 sec*proc (48 tests)
umat              =   0.98 sec*proc (3 tests)
useextrude        =   8.09 sec*proc (16 tests)
vector_element    =   9.54 sec*proc (13 tests)
viscoelastic      =   9.77 sec*proc (1 test)
whitney           = 305.42 sec*proc (57 tests)

Total Test time (real) = 1573.06 sec

The following tests FAILED:
	  7 - AdvReactDB_np6 (Failed)
	  9 - AdvReactDBmap_np6 (Failed)
	 11 - AdvReactDG_np6 (Failed)
	127 - DisContBoundaryDoubleMortar_np8 (Failed)
	132 - DisContBoundaryMortarCont_np8 (Failed)
	136 - DisContBoundaryMortarContElim_np8 (Failed)
	140 - DisContBoundaryMortarJump_np8 (Failed)
	144 - DisContBoundaryMortarJumpB_np8 (Failed)
	148 - DisContBoundaryMortarJumpC_np8 (Failed)
	214 - Hybrid2dMeshPartitionCyl_np8 (Failed)
	215 - Hybrid2dMeshPartitionMetis_np8 (Failed)
	216 - Hybrid2dMeshPartitionMetisConnect_np8 (Failed)
	222 - InternalPartitioning_np8 (Failed)
	224 - InternalPartitioning2_np6 (Failed)
	226 - InternalPartitioning3_np6 (Failed)
	253 - MazeMeshPartitionMetisContig_np6 (Failed)
	263 - ModelPDE (Failed)
	273 - MortarPoissonPartz3D_np6 (Failed)
	274 - MortarPoissonPartz3D_np8 (Failed)
	332 - PoissonDB_np8 (Failed)
	335 - PoissonDG_np8 (Failed)
	363 - RotatingBCPoisson3Daxial_np6 (Failed)
	456 - WinkelBmPoissonCgIlu0_np8 (Failed)
	458 - WinkelBmPoissonIdrsIlu0_np8 (Failed)
	459 - WinkelPartitionMetis_np8 (Failed)
	460 - WinkelPartitionMetisConnect_np8 (Failed)
	461 - WinkelPartitionMetisRec_np8 (Failed)
	462 - WinkelPartitionRecursive_np8 (Failed)
	463 - WinkelPartitionRecursiveHaloBC_np8 (Failed)
	464 - WinkelPartitionRecursiveLevel2_np8 (Failed)
	471 - WinkelPoissonMetisKwayDual_np8 (Failed)
	474 - WinkelPoissonMetisKwayNodal_np8 (Failed)
	475 - WinkelPoissonPartitionRecursive_np8 (Failed)
	642 - poisson_transient_conforming_anti_np8 (Faile
```

​		**以上功能性测试出现失败的原因可能是由于进行单节点测试造成的。**

## 性能测试

### 测试平台信息对比

|          | arm信息                                        | x86信息。                                      |
| -------- | ---------------------------------------------- | ---------------------------------------------- |
| 操作系统 | openEuler 22.03 LTS                            | openEuler 20.03 (LTS-SP1)                      |
| 内核版本 | Linux 5.10.0-60.18.0.50.oe2203.aarch64 aarch64 | Linux 5.10.16.3-microsoft-standard-WSL2 x86_64 |

### 测试软件环境信息对比

|          | arm信息       | x86信息       |
| -------- | ------------- | ------------- |
| gcc      | bisheng 2.1.0 | gcc 7.3.0     |
| mpi      | hmpi1.1.1     | openmpi-4.0.2 |
| OpenBlas | 0.3.6         | 0.3.6         |
| Elmer    | 8.4           | 8.4           |

### 测试硬件性能信息对比

|        | arm信息     | x86信息                                  |
| ------ | ----------- | ---------------------------------------- |
| cpu    | Kunpeng 920 | Intel(R) Core(TM) i5-9300H CPU @ 2.40GHz |
| 核心数 | 32          | 4                                        |
| 内存   | 16 GB       | 8 GB                                     |
| 磁盘io | 1.3 GB/s    | 400 MB/s                                 |
| 虚拟化 | KVM         | KVM                                      |

### 测试选择的案例：

Flow through a hole——确定声阻抗问题

问题包括找出流体在被迫流过孔时所面临的阻力。 流动阻力由孔上的压降与输入速度之比表示。 在微系统建模中，通常需要孔阻力来分析穿孔结构中的气体阻尼效应。 在此，基于单孔电阻，孔的贡献在穿孔结构上是均匀的。 对于 Elmer 中的均质化，使用特定的声阻抗来表示流动阻力。

文件具体内容如下：

```
***** ElmerGrid input file for structured grid generation *****
Version = 210903
Coordinate System = Cartesian 2D
Subcell Divisions in 2D = 3 3 
Subcell Limits 1 = 0 2.5 5 10 
Subcell Limits 2 = 0 1 4 9 
Material Structure in 2D
  1    1    3    
  1    2    3    
  1    1    3    
End
Revolve Blocks = 1
Revolve Radius = -1      
Materials Interval = 1 1
Boundary Definitions
! type     out      int     
  1        2        -4       1       
  2        2        -3       1       
  3        2        -1       1       
  4        0        -3       1       
  5        0        -1       1       
  6        3        1        1       
End
Numbering = Horizontal
Element Degree = 1
Element Innernodes = False
Triangles = False
Surface Elements = 750
Coordinate Ratios = 1       
Minimum Element Divisions = 1 1
Element Ratios 1 = 1 1.5 1 
Element Ratios 2 = 1 -1.35 3 
Element Densities 1 = 1.3 1 1 
Element Densities 2 = 4 2.4 1.8 
```

`impedance.sif`文件如下

```
Check Keywords Warn

Header
  Mesh DB "." "hole"
End

Simulation
  Coordinate System = Cartesian 3D
  Simulation Type = Steady State
  Steady State Max Iterations = 1
  Output File = "flow.result"
  Post File = "flow.ep"
End

Body 1
  Equation = 1
  Material = 1
End

Equation 1
  Active Solvers(3) = 1 2 3
  NS Convect = False
End


Solver 1
   Equation = Navier-Stokes
   Variable = Flow Solution
   Variable DOFs = 3
   Linear System Solver = Iterative
   Linear System Iterative Method = BiCGStab
   Linear System Preconditioning = ILU0
   Linear System Max Iterations = 200
   Linear System Convergence Tolerance = 1.0e-08
   Stabilize = True
   Nonlinear System Convergence Tolerance = 1.0e-05
   Nonlinear System Max Iterations = 1
   Nonlinear System Newton After Iterations = 3
   Nonlinear System Newton After Tolerance = 1.0e-08
   Nonlinear System Relaxation Factor = 1.0
   Steady State Convergence Tolerance = 1.0e-05
End

Solver 2
  Exec Solver = After Timestep
  Equation = Fluidic Force
  Procedure  ="FluidicForce" "ForceCompute"
  Calculate Viscous Force = True
End

Solver 3
  Exec Solver = After All
  Equation = SaveScalars
  Procedure = "SaveData" "SaveScalars"
  Filename = "flowdata.dat"
  Save Variable 1 = Velocity 3
  Save Coordinates(1,2) = 0.0 0.0
End 

Material 1
  Name = Air
  Density = 1.293e-12
  Viscosity = 1.67e-5
End

Boundary Condition 1
  Target Boundaries = 4
   Velocity 1 = 0.0
   Velocity 2 = 0.0
   Velocity 3 = 1.0e3
   Calculate Fluidic Force = True
End

Boundary Condition 2
  Target Boundaries(2) = 8 10
   Velocity 2 = 0.0
End

Boundary Condition 3
  Target Boundaries(4) = 1 2 3 7
   Velocity 1 = 0.0
   Velocity 2 = 0.0
   Velocity 3 = 0.0
End

Boundary Condition 4
  Target Boundaries(2) = 6 9
   Velocity 1 = 0.0
End

Boundary Condition 5
  Target Boundaries = 5
  Pressure = 0.0
End

!End Of File
```

###  单线程

​		单线程运行测试时间对比（五次运行取平均值）

|             | SOLVER TOTAL TIME(CPU/s) | SOLVER TOTAL TIME(REAL/s) |
| ----------- | ------------------------ | ------------------------- |
| arm64未优化 | 3.33                     | 3.45                      |
| arm64       | 2.28                     | 2.53                      |
| x86         | 2.64                     | 2.76                      |

### 多线程

​		多线程运行测试时间对比（五次运行取平均值）：

|             | 线程数 | SOLVER TOTAL TIME(CPU/s) | SOLVER TOTAL TIME(REAL/s) |
| ----------- | ------ | ------------------------ | ------------------------- |
| arm64未优化 | 2      | 2.04                     | 2.46                      |
| arm64       | 2      | 1.39                     | 1.52                      |
| x86         | 2      | 1.7                      | 1.73                      |

### 性能对比

<table><tr> <td><img src=C:/Users/86151/AppData/Roaming/Typora/typora-user-images/image-20220907005141944.png border=0></td> <td><img src=C:/Users/86151/AppData/Roaming/Typora/typora-user-images/image-20220907005150210.png border=0></td> </tr></table>

​		由以上两个图片可以看出amd经过优化后其性能得到明显提升，而随着线程数的增加，性能得到进一步提升。

### 其他测试样例

|           | ElasticEigenValues测试结果 |                |
| --------- | -------------------------- | -------------- |
| arm64     | 单线程                     | 双线程         |
|           | real  0m2.749s             | real  0m1.156s |
|           | user  0m2.202s             | user  0m0.053s |
|           | sys   0m0.120s             | sys   0m0.103s |
|           |                            |                |
| x86       | real  0m2.832s             | real  0m0.233s |
|           | user  0m2.661s             | user  0m0.479s |
|           | sys   0m0.419s             | sys   0m0.180s |
|           |                            |                |
|           |                            |                |
| arm未优化 | real  0m5.583s             | real  0m2.684s |
|           | user  0m2.419s             | user  0m2.600s |
|           | sys   0m0.136s             | sys   0m0.037s |

### 测试总结

​	通过多个测试样例的对比可以发现，经过优化的amd平台的Elmer性能在单线程相较优化前性能提升约25%，多线程性能提升约20%，相比x86平台性能优化后单线程性能提升约9%，多线程性能提升约15%。

## 精度测试

###  所选测试案例

可以下载官方算例包“ElmerTutorialsFiles_nonGUI.tar.gz”后进行测试了，下载地址：[https://sources.debian.org/data/non-free/e/elmer-doc/2014.02.06-1~bpo70%2B1/ElmerTutorialsFiles_nonGUI.tar.gz](https://sources.debian.org/data/non-free/e/elmer-doc/2014.02.06-1~bpo70+1/ElmerTutorialsFiles_nonGUI.tar.gz)。

其文件目录结构如图所示：

```
/test/tutorials_files
├── AcousticWaves
│   ├── domain.egf
│   ├── ELMERSOLVER_STARTINFO
│   └── helmholtz.sif
├── ArteryFlow
│   ├── AddOneDim.f90
│   ├── contra.grd
│   ├── contra.sif
│   ├── ELMERSOLVER_STARTINFO
│   ├── Motion.f90
│   └── PostProcessingInstr.txt
├── CapacitanceMatrix
│   ├── 4_holes.sif
│   ├── ELMERSOLVER_STARTINFO
│   └── mesh.FDNEUT
├── CoatingProcess
│   ├── coat.grd
│   ├── coat.sif
│   └── ELMERSOLVER_STARTINFO
├── ElasticBeam
│   ├── linear
│   │   ├── Beam.egf
│   │   ├── Beam.sif
│   │   └── ELMERSOLVER_STARTINFO
│   └── nonlinear
│       ├── Beam.egf
│       ├── Beam.sif
│       └── ELMERSOLVER_STARTINFO
├── ElasticEigenValues
│   ├── eigen_values_aniso.sif
│   ├── eigen_values.sif
│   ├── ELMERSOLVER_STARTINFO
│   └── mesh.FDNEUT
├── ElasticPlateLinear
│   ├── Draw
│   ├── ELMERSOLVER_STARTINFO
│   ├── simple_plate.grd
│   └── simple_plate.sif
├── Electrostatics
│   ├── ELMERSOLVER_STARTINFO
│   ├── elmesh.grd
│   └── elstatics.sif
├── FlowLinearRestriction
│   ├── AddMassFlow.f90
│   ├── ELMERSOLVER_STARTINFO
│   ├── mflow.grd
│   └── mflow.sif
├── FlowResistance
│   ├── ELMERSOLVER_STARTINFO
│   ├── hole.grd
│   ├── impedance.sif
│   └── impedance_slip.sif
├── FlowStepCompressible
│   ├── compress_step.sif
│   ├── ELMERSOLVER_STARTINFO
│   └── mesh.grd
├── FlowStepIncompressible
│   ├── rectangles
│   │   ├── ELMERSOLVER_STARTINFO
│   │   ├── Step.grd
│   │   ├── StepMesh.gif
│   │   ├── StepRes.gif
│   │   └── Step.sif
│   └── triangles
│       ├── ELMERSOLVER_STARTINFO
│       ├── picmesh1.gif
│       ├── respic1.gif
│       ├── respic2.gif
│       ├── respic3.gif
│       ├── StepFlow.egf
│       └── StepFlow.sif
├── FlowStreamlines
│   ├── ELMERSOLVER_STARTINFO
│   ├── step.grd
│   ├── streamlines.sif
│   └── StreamSolver.f90
├── FluidStructureBeam
│   ├── displace.gif
│   ├── ELMERSOLVER_STARTINFO
│   ├── flowvect.gif
│   ├── fsi.grd
│   ├── fsi.sif
│   ├── FsiStuff.f90
│   ├── mesh.gif
│   └── pressure.gif
├── InductionHeating
│   ├── crucible.grd
│   ├── crucible.sif
│   └── ELMERSOLVER_STARTINFO
├── Microfluidic
│   ├── ELMERSOLVER_STARTINFO
│   ├── inject.sif
│   └── Tcross.grd
├── PassiveElements
│   ├── ELMERSOLVER_STARTINFO
│   ├── temp.sif
│   └── tmesh.grd
├── PoissonBEM
│   ├── ELMERSOLVER_STARTINFO
│   ├── heater.grd
│   └── PoissonBEM.sif
├── RayleighBenard
│   ├── ELMERSOLVER_STARTINFO
│   ├── Mesh
│   │   ├── mesh.boundary
│   │   ├── mesh.elements
│   │   ├── mesh.header
│   │   └── mesh.nodes
│   └── RayleighBenard.sif
├── RayleighBenardGUI
│   ├── box.grd
│   ├── case.ep
│   ├── case.sif
│   ├── ELMERSOLVER_STARTINFO
│   ├── mesh.boundary
│   ├── mesh.elements
│   ├── mesh.header
│   └── mesh.nodes
├── Temperature1D
│   ├── 1dheat.grd
│   ├── 1dheat.sif
│   ├── ELMERSOLVER_STARTINFO
│   └── Poisson.f90
├── TemperatureAngle
│   ├── ELMERSOLVER_STARTINFO
│   ├── TempDist.egf
│   ├── TempDist.sif
│   └── temperature.jpg
├── TemperatureAngleGUI
│   ├── angle.grd
│   ├── case.ep
│   ├── case.sif
│   ├── ELMERSOLVER_STARTINFO
│   ├── mesh.boundary
│   ├── mesh.elements
│   ├── mesh.header
│   └── mesh.nodes
├── TemperatureOperatorsplitting
│   ├── ELMERSOLVER_STARTINFO
│   ├── femlab-mesh
│   │   ├── mesh.boundary
│   │   ├── mesh.elements
│   │   ├── mesh.header
│   │   └── mesh.nodes
│   └── os-example.sif
├── TemperatureRadiation
│   ├── ELMERSOLVER_STARTINFO
│   ├── radiation.grd
│   └── radiation.sif
├── ThermalActuator
│   ├── ELMERSOLVER_STARTINFO
│   ├── ExportMesh.boundary
│   ├── ExportMesh.elem
│   ├── ExportMesh.header
│   ├── ExportMesh.node
│   ├── SOLVER.KEYWORDS
│   └── thermal_actuator.sif
└── 列表树.txt

32 directories, 126 files
```

此处可以选择`test/tutorials_files/FlowResistance`

文件具体内容如下：

```
***** ElmerGrid input file for structured grid generation *****
Version = 210903
Coordinate System = Cartesian 2D
Subcell Divisions in 2D = 3 3 
Subcell Limits 1 = 0 2.5 5 10 
Subcell Limits 2 = 0 1 4 9 
Material Structure in 2D
  1    1    3    
  1    2    3    
  1    1    3    
End
Revolve Blocks = 1
Revolve Radius = -1      
Materials Interval = 1 1
Boundary Definitions
! type     out      int     
  1        2        -4       1       
  2        2        -3       1       
  3        2        -1       1       
  4        0        -3       1       
  5        0        -1       1       
  6        3        1        1       
End
Numbering = Horizontal
Element Degree = 1
Element Innernodes = False
Triangles = False
Surface Elements = 750
Coordinate Ratios = 1       
Minimum Element Divisions = 1 1
Element Ratios 1 = 1 1.5 1 
Element Ratios 2 = 1 -1.35 3 
Element Densities 1 = 1.3 1 1 
Element Densities 2 = 4 2.4 1.8 
```

`impedance.sif`文件如下

```
Check Keywords Warn

Header
  Mesh DB "." "hole"
End

Simulation
  Coordinate System = Cartesian 3D
  Simulation Type = Steady State
  Steady State Max Iterations = 1
  Output File = "flow.result"
  Post File = "flow.ep"
End

Body 1
  Equation = 1
  Material = 1
End

Equation 1
  Active Solvers(3) = 1 2 3
  NS Convect = False
End


Solver 1
   Equation = Navier-Stokes
   Variable = Flow Solution
   Variable DOFs = 3
   Linear System Solver = Iterative
   Linear System Iterative Method = BiCGStab
   Linear System Preconditioning = ILU0
   Linear System Max Iterations = 200
   Linear System Convergence Tolerance = 1.0e-08
   Stabilize = True
   Nonlinear System Convergence Tolerance = 1.0e-05
   Nonlinear System Max Iterations = 1
   Nonlinear System Newton After Iterations = 3
   Nonlinear System Newton After Tolerance = 1.0e-08
   Nonlinear System Relaxation Factor = 1.0
   Steady State Convergence Tolerance = 1.0e-05
End

Solver 2
  Exec Solver = After Timestep
  Equation = Fluidic Force
  Procedure  ="FluidicForce" "ForceCompute"
  Calculate Viscous Force = True
End

Solver 3
  Exec Solver = After All
  Equation = SaveScalars
  Procedure = "SaveData" "SaveScalars"
  Filename = "flowdata.dat"
  Save Variable 1 = Velocity 3
  Save Coordinates(1,2) = 0.0 0.0
End 

Material 1
  Name = Air
  Density = 1.293e-12
  Viscosity = 1.67e-5
End

Boundary Condition 1
  Target Boundaries = 4
   Velocity 1 = 0.0
   Velocity 2 = 0.0
   Velocity 3 = 1.0e3
   Calculate Fluidic Force = True
End

Boundary Condition 2
  Target Boundaries(2) = 8 10
   Velocity 2 = 0.0
End

Boundary Condition 3
  Target Boundaries(4) = 1 2 3 7
   Velocity 1 = 0.0
   Velocity 2 = 0.0
   Velocity 3 = 0.0
End

Boundary Condition 4
  Target Boundaries(2) = 6 9
   Velocity 1 = 0.0
End

Boundary Condition 5
  Target Boundaries = 5
  Pressure = 0.0
End

!End Of File
```

### 获得对比数据

经过运行一下命令后有：

```
ElmerGrid 1 2 hole.grd -autoclean
time mpirun --allow-run-as-root -mca btl ^openib -np 1 ElmerSolver
```

可以在flowdata.dat中得到测试数据，具体结果如下所示

arm数据

```
    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00    2.500000000000E+01    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00    0.000000000000E+00
```

x86数据

```
   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   2.500000000000E+001   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000   0.000000000000E+000
```

使用以上数据进行误差计算

```python
x86 = [0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,2.500000000000E+01,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00]
arm = [0.000000000000E+000,0.000000000000E+000,0.000000000000E+000,0.000000000000E+000,0.000000000000E+000,0.000000000000E+000,2.500000000000E+001,0.000000000000E+000,0.000000000000E+000,0.000000000000E+000,0.000000000000E+000]


for i in range(len(arm)):
    if arm[i] == 0:
        print(x86[i]-arm[i])
    else:
        print(abs((x86[i]-arm[i]) / arm[i]) * 100, '%')
```

### 误差运算结果

```
0.0
0.0
0.0
0.0
0.0
0.0
0.0 %
0.0
0.0
0.0
0.0
```

###  测试总结

所有运算结果偏差极小，几乎没有差别。

