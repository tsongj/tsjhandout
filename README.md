# tsjhandout
tex讲义模板
# 数学教学讲义与板书 LaTeX 模板及资料库

本仓库为数学教学专用 LaTeX 排版系统与讲义源码库。项目提供**类文件（`.cls`）**与**宏包文件（`.sty`）**两套编译体系，支持同一套讲义源码一键切换多种 A4 打印版面、横屏单题课堂板书模式，以及教师版/学生版/纯答案册的灵活生成。

---

## 📁 仓库结构与两套编译体系对比

仓库中包含两条独立的编译入口，请根据使用场景选择对应的主文件进行编译：

| 维度 | 方案一：类文件体系（推荐 / 新版） | 方案二：宏包体系（基础版） |
| :--- | :--- | :--- |
| **核心样式文件** | `tsjhandout1.0.cls` | `tsjpaper26v1.0.sty`（内部声明 `tsongjpaper25`） |
| **主编译入口** | `main-handout.tex` | `main-tsjpaper26.tex` |
| **文档类声明** | `\documentclass[12pt,a4paper,openany]{handout}`<br>*(注：编译时需确保文件名或调用名与 `tsjhandout1.0` 对应)* | `\documentclass[12pt,a4paper,openany]{book}`<br>`\usepackage{tsjpaper26v1.0}` |
| **宏包集成度** | **全集成**：内置 `siunitx`、`comment`、`xparse` 及 `xcolor` 扩展色库，主文件无需额外加载宏包 | **基础集成**：主文件需额外手动加载 `siunitx` 和 `comment` |
| **板书模式尺寸** | **标准 A5 横版**（`210mm × 148mm`） | **自定义横屏尺寸**（`200mm × 150mm`） |
| **专属进阶功能** | • **四套独立解答配色**（常规/多解/AI解/分析）<br>• **多解自动递增编号**（`altsol` 与 `AIsol` 共享计数器）<br>• **隐藏题干直连答案**（注释 `\problemstrue` 生成纯答案册） | • 基础例题/练习/拓展环境<br>• 基础单题板书防粘连分页<br>• 基础解答开关控制 |

### 其他目录说明
* `chapter4A-260402/`：存放各讲讲义正文（如 `4-02-1-小数计算.tex`）及配套练习（`-exercises.tex`）。
* `chapter/review.tex`：期末复习讲义模块。

---

## 🛠️ 编译与使用指南

### 1. 环境要求
* **TeX 发行版**：推荐使用 **TeX Live 2025/2026** 或更新版本。
* **编译器**：必须使用 **XeLaTeX** 编译（依赖 `ctex`、`fontspec` 与 `xeCJK`，默认西文字体为 `Times New Roman`）。
* **编译次数**：建议连续运行 **两次 `xelatex`**，以确保目录（`\tableofcontents`）与章节交叉引用正确生成。

### 2. 方案一：使用类文件编译（`main-handout.tex`）
1. 确保 `tsjhandout1.0.cls` 与 `main-handout.tex` 位于同一目录下（注意：若直接调用 `\documentclass{tsjhandout1.0}`，请保持文件名与类名一致）。
2. 在 `main-handout.tex` 中配置版面与解答开关后，执行：
   ```bash
   xelatex main-handout.tex
   xelatex main-handout.tex


方案二：使用宏包文件编译（main-tsjpaper26.tex）

1. 确保 tsjpaper26v1.0.sty 与 main-tsjpaper26.tex 位于同一目录下。
2. main-tsjpaper26.tex 以标准 book 类为基础，通过 \usepackage{tsjpaper26v1.0} 加载样式，执行：
   
核心功能与参数配置说明


1. 一键切换四种版面模式（\setlayoutmode）

在主文件导言区修改 \setlayoutmode{参数}，即可自动联动页面尺寸、页眉页脚分隔线及题间留白：
• standard：A4 标准版（默认），正常题间弹性留白（\vfil），适合日常讲义打印。
• loose：A4 宽松版，在题目间额外增加 2cm 留白，适合需要充足演算空间的学案。
• compact：A4 紧凑版，压缩题目垂直间距（-1cm），适合习题汇编。
• board：单题板书版（课堂投影专用）：
	• 自动切换为横屏小尺寸，并加粗页眉（2pt）与页脚（4pt）分隔线。
	• 内置防粘连机制（\boardstartproblem / \boardendproblem），无论是否显示答案，均严格保证“一题一页”，且在进入新知识点或新板块前自动结算换页。


• 学生版答题留白控制：关闭解答开关时，可通过导言区的 \soloneproblems（9cm）、\soltwoproblems（6cm）、\solthreeproblems（4.8cm）、\solfourproblems（3cm）、\solfiveproblems（0cm）统一调节不同题型的作答空白高度。
• 备课内容隔离：主文件默认通过 \excludecomment 隐藏 knowledge（知识背景）、beike（备课笔记）与 Del（待删题目）环境中的内容。

常用教学环境与快捷命令速查


1. 结构与标题命令

• 板块大标题：\zhishiyaodian（知识要点）、\litifenxi（例题分析）、\kehoulianxi（课后练习）
• 多级知识点：\zsd{标题}（一级，如 1.2 标题）、\subzsd{标题}（二级，如 1.2.1 标题）、\subsubzsd{标题}（三级，如 1.2.1.1 标题）
• 定理环境：thm（定理）、definition（定义）、lemma（引理）、corollary（推论）、property（性质）、conclusion（结论）、formula（公式）

2. 题型与对应解答环境


题型名称	题目环境	对应解答环境（按学生版留白从小到大排列）
例题
	\begin{example} ... \end{example}	sol / Ssol / Msol / Bsol
课堂练习
	\begin{lianxi} ... \end{lianxi}	lxsol / lxSsol / lxMsol / lxBsol
课后作业
	\begin{zuoye} ... \end{zuoye}	lxsol / lxSsol / lxMsol / lxBsol
拓展提升
	\begin{tuozhan} ... \end{tuozhan}	tzsol / tzSsol / tzMsol / tzBsol
无编号小题
	\begin{duoti} ... \end{duoti}	duotisol / duotiSsol / duotiMsol / duotiBsol


3. 数学与排版快捷命令

• 选择题自动排版：\xx{选项A}{选项B}{选项C}{选项D}（自动测量选项宽度，智能排成一行四列、两行两列或四行一列）。
• 填空与括号：\tk（默认 1.5cm 下划线）、\kge{长度}（自定义长度下划线）、\kh（行末右对齐选择题括号）。
• 难度星级：\DDA（★）至 \DDE（★★★★★）。
• 几何与特殊符号：\pxqdy（平行且等于 $\pxqdy$）、\pxsbx（平行四边形）、\circled{1}（带圈数字）、\libcirc{1}（1~20 字体带圈数字）、\wideparen{AB}（弧符号）、\vv{a}（向量箭头）。
• 图片插入：\imgin[缩放比例]{对齐方式 l/c/r}{图片路径}。
  
