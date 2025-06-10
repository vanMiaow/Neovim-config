
###     VSC:FOR
######  使用 Visual Studio Code 进行 Fortran 开发

---

####    工具需求

<table><thead>
    <tr>
        <th></th><th width=44%>Intel Fortran 编译器</th><th width=44%>GNU Fortran 编译器</th>
    </tr>
</thead><tbody>
    <tr>
        <th rowspan=2>编辑器</th>
        <td colspan=2>
            <b>默认编辑器</b><br>
            来自 VS Code
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <b>[插件] Vim</b><br>
            为 VS Code 默认编辑器提供 Vim 行为模拟
        </td>
    </tr>
    <tr>
        <th rowspan=2>编译器</th>
        <td>
            <b>ifx</b><br>
            Intel Fortran 编译器, 来自 Intel oneAPI
        </td>
        <td rowspan=2>
            <b>gfortran</b><br>
            GNU Fortran 编译器, 来自 MinGW
        </td>
    </tr>
    <tr>
        <td>
            <b>[插件] Environment Configurator for Intel Software Developer Tools</b><br>
            Intel oneAPI 环境配置
        </td>
    </tr>
    <tr>
        <th>链接器</th>
        <td>
            <b>link</b><br>
            ifx 在 Windows 平台使用的链接器, 来自 Build Tools for Visual Studio
        </td>
        <td>
            <b>ld</b><br>
            GNU 链接器, 来自 MinGW
        </td>
    </tr>
    <tr>
        <th rowspan=3>调试器</th>
        <td colspan=2>
            <b>[插件] C/C++</b><br>
            为 VS Code 提供 cppvsdbg 和 cppdbg 调试器支持等, 来自插件包 C/C++ Extension Pack
        </td>
    </tr>
    <tr>
        <td>
            <b>Visual Studio Windows Debugger (cppvsdbg)</b><br>
            来自 Build Tools for Visual Studio
        </td>
        <td rowspan=2>
            <b>GDB (cppdbg)</b><br>
            GNU 调试器, 来自 MinGW
        </td>
    </tr>
    <tr>
        <td>
            <b>[cppvsdbg 插件] Fortran Expression Evaluator</b><br>
            为 cppvsdbg 调试器提供 Fortran 表达式支持, 从整合了 Intel oneAPI 的 Visual Studio 中移植, 参考 <a href="https://gist.github.com/albertziegenhagel/6431811950864bd0009b6a1fa78e7f2b" target="_blank">How-To: Enable Intel Fortran Debugging Support in VS Code</a>
        </td>
    </tr>
    <tr>
        <th rowspan=2>生成工具</th>
        <td colspan=2>
            <b>MinGW Makefiles</b><br>
            构建工具, 来自 MinGW
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <b>CMake</b><br>
            构建系统生成器
        </td>
    </tr>
    <tr>
        <th rowspan=4>其他功能</th>
        <td colspan=2>
            <b>[插件] Chinese (Simplified) (简体中文) Language Pack for Visual Studio Code</b><br>
            为 VS Code 提供简体中文界面
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <b>[插件] Modern Fortran</b><br>
            为 VS Code 提供 Fortran 语言支持
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <b>fortls</b><br>
            为 Modern Fortran 提供语法功能支持, 通过 pip 安装
        </td>
    </tr>
    <tr>
        <td colspan=2>
            <b>findent</b><br>
            为 Modern Fortran 提供格式化功能支持, 通过 pip 安装
        </td>
    </tr>
</tbody></table>

####    安装汇总

**VS Code**  
&emsp;Chinese (Simplified) (简体中文) Language Pack for Visual Studio Code  
&emsp;Vim  
&emsp;Environment Configurator for Intel Software Developer Tools 🚫  
&emsp;Modern Fortran  
&emsp;C/C++  
&emsp;Fortran Expression Evaluator 🚫  
**Python**  
&emsp;fortls  
&emsp;findent  
**MinGW**  
**CMake**  
**Build Tools for Visual Studio** 🚫  
&emsp;Desktop development with C++  
**Intel oneAPI** 🚫  
&emsp;Base Toolkit  
&emsp;HPC Toolkit  

🚫 表示 GNU Fortran 编译器不需要该项  

####    其它事项

+   可用 `Visual Studio 2022` 代替 `Build Tools for Visual Studio`，方便提取 `Fortran Expression Evaluator`  
+   如果 `Intel oneAPI` 非默认位置安装，需要在 `settings.json` 中设置 `intel-corporation.oneapi-environment-configurator.ONEAPI_ROOT`，否则无法正确加载开发环境  
+   如果 `Visual Studio 2022` 或者 `Build Tools for Visual Studio` 非默认位置安装，需要设置环境变量 `VS2022INSTALLDIR`，否则无法正确加载链接器  
+   `ifx` 仅支持 `x64` 目标程序，如需编译 `x86` 目标程序，需要使用 `ifort`，最后版本在 `Intel oneAPI 2024.2`
+   环境配置脚本 `setvars.bat` 或 `oneapi-vars.bat` 默认加载 `x64` 目标环境，如需加载 `x86` 目标环境，需要传入参数 `ia32`；但是 `Environment Configurator for Intel Software Developer Tools` 不支持传入参数，如需编译 `x86` 目标程序，需要手动修改脚本（注意备份），或直接通过命令行编译  

