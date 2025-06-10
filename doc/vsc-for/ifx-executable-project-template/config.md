
####    项目目录

    ifx-project-template/
    │   .git/                     git 目录
    │   .vscode/                  vscode 配置
    │   │   launch.json           调试配置
    │   │   settings.json         项目配置
    │   │   tasks.json            任务配置
    │   bin/                      .exe 安装目录
    │   build/                    生成目录
    │   │   Debug/                Debug 目录
    │   │   │   bin/              .exe 输出目录
    │   │   │   mod/              .mod 输出目录
    │   │   │   ...
    │   │   Linter/               Linter .mod 输出目录
    │   │   Release/              Release 目录
    │   cmake/                    CMake 项目目录
    │   │   CMakeLists.txt        CMake 项目配置
    │   │   ...
    │   src/                      源文件目录
    │   test/                     测试目录
    │   .gitignore                gitignore 文件

#####   ~~清理项目~~

~~删除 `./bin/` `./build/Debug/` `./build/Release/` `./build/Linter/` 4 个目录下的所有文件, 或者~~  
~~删除 `./bin/` `./build/` 2 个目录, 然后新建 `./build/Linter/` 目录 (缺少该目录会导致 Modern Fortran Linter 报错)~~  
~~最后重新配置并生成项目~~  

#####   CMakeLists.txt

配置 `_PROJECT_NAME_` `_PROJECT_VERSION_` `_TARGET_NAME_` `_EXECUTABLE_NAME_` `_SOURCE_NAME_` 以及编译器选项  

#####   settings.json

配置 Linter 编译器 `ifx`  
配置 Linter `Include Paths` 和 `Mod Output` (由于 Modern Fortran 将这 2 个目录处理为 Linux 下的编译器选项, 此处需将其处理为 Windows 下的编译器选项, 并以 `Extra Args` 方式给出)  
配置 oneAPI 安装目录 (每次打开 VS Code 需首先执行 `Intel oneAPI: Initialize default environment variables`)  

#####   tasks.json

配置 `config` `build` `clean` `install` 4 个任务, 每个任务均对应 2 个生成类型 `Debug` 和 `Release`  
配置 `reset` 任务，用于清理项目  

#####   launch.json

配置调试器 `cppvsdbg`, 指定调试对象、目录和参数  

