\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tsjhandout1.0}[2026/11/23 Custom Math Handout Class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,openany]{book}

% =========================================================================
% 1. 核心基础与数学、绘图宏包
% =========================================================================
\RequirePackage[heading]{ctex}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{ifthen}
\RequirePackage{xfp}
\RequirePackage{siunitx}
\RequirePackage{comment}

% 数学与符号
\RequirePackage{amsmath, amssymb, amsthm, mathrsfs}
\RequirePackage{extarrows}
\RequirePackage{yhmath}        % 弧符号 \wideparen
\RequirePackage[e]{esvect}     % 向量箭头 \vv
\RequirePackage{pifont}        % 特殊符号如五角星
\RequirePackage{manfnt}

% 表格、列表与版面辅助
\RequirePackage{tabularx}
\RequirePackage{diagbox}       % 斜线表头
\RequirePackage{enumitem}
\RequirePackage{multicol}
\RequirePackage{float}
\RequirePackage{caption}
\RequirePackage{indentfirst}
\RequirePackage{zhnumber}
\RequirePackage[titles]{tocloft}
\RequirePackage{fancyhdr}
\RequirePackage{tagging}

% 图形与函数绘图 (注意：tkz-fct 必须在 tkz-euclide 之前加载)
\RequirePackage{graphicx}
\RequirePackage[dvipsnames,svgnames,x11names]{xcolor}
\RequirePackage{tikz}
\RequirePackage{tkz-fct}
\RequirePackage{tkz-euclide}
\RequirePackage{pgfplots}
\pgfplotsset{compat=newest}
\usetikzlibrary{intersections, shapes.geometric, arrows.meta}

% 超链接设置（放在宏包加载的最后以防冲突）
\RequirePackage[hyperindex]{hyperref}
\hypersetup{
	bookmarksopen=true,
	bookmarksopenlevel=1,
	bookmarksnumbered=true,
	pdftitle={必修一-唐松锦},
	pdfauthor={唐松锦},
	linktoc=all,
	CJKbookmarks=true,
	unicode=true,
	colorlinks=true,
	linkcolor=blue,
	citecolor=red,
	urlcolor=blue,
	anchorcolor=green
}

% =========================================================================
% 2. 页面布局、版面模式联动开关与字体配置
% =========================================================================
\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\setmainfont{Times New Roman}

% 默认四套独立颜色（可在主文件中用 \definecolor 覆盖修改）
\definecolor{BLUE}{RGB}{0,0,255}
\definecolor{solColor}{RGB}{75,0,130}          % 常规解答默认紫色
\definecolor{altsolcolor}{RGB}{0,174,239}      % 多解 altsol 默认青色
\definecolor{aicolor}{RGB}{170,65,130}         % AI解答 AIsol 默认橙紫色
\definecolor{analysiscolor}{RGB}{0,128,0}      % 思路分析 analysis 默认深绿色
\def\scalenumber{0.7}

% 声明所有开关（提前声明以便 \setlayoutmode 调用）
\newif\ifboardmode
\newif\ifneedboardbreak % 防粘连标记：记录上一题是否尚未换页
\newif\ifsol
\newif\iflxsol
\newif\iftzsol
\newif\ifproblems
\newif\ifanalysis
\newif\ifadding
\newif\ifonly
\newif\ifgroupA
\newif\ifgroupB
\newif\ifgroupC
\newif\ifAIproof

% 板书模式防粘连辅助命令
\newcommand{\boardstartproblem}{%
	\ifboardmode
	\ifneedboardbreak\newpage\fi
	\global\needboardbreaktrue
	\fi
}
\newcommand{\boardendproblem}{%
	\ifboardmode
	\newpage
	\global\needboardbreakfalse
	\fi
}
\newcommand{\boardflush}{%
	\ifboardmode
	\ifneedboardbreak\newpage\global\needboardbreakfalse\fi
	\fi
}

% 统一版面模式切换命令：\setlayoutmode{standard | loose | compact | board}
\newcommand{\setlayoutmode}[1]{%
	\ifstrequal{#1}{board}{%
		% 【单题板书版】标准 A5 横版（宽 210mm x 高 148mm），严格一题一页
		\boardmodetrue
		\global\needboardbreakfalse
		\geometry{
			paperheight=148mm,
			paperwidth=210mm,
			left=12mm,
			right=12mm,
			top=12mm,
			bottom=15mm,
			headheight=10mm,
			headsep=2mm
		}%
		\def\mystyle{}%
		\renewcommand{\headrulewidth}{2pt}%
		\renewcommand{\footrulewidth}{4pt}%
	}{%
		% 【常规 A4 讲义通用页面设置】
		\boardmodefalse
		\global\needboardbreakfalse
		\geometry{
			a4paper,
			portrait,
			centering,
			top=2.3cm,
			bottom=3.2cm,
			right=2.5cm,
			left=2.5cm,
			headheight=10mm,
			headsep=2mm
		}%
		\renewcommand{\headrulewidth}{0pt}%
		\renewcommand{\footrulewidth}{0pt}%
		% 根据子模式设置题目垂直间距 \mystyle
		\ifstrequal{#1}{loose}{%
			\def\mystyle{\vspace{2cm}\vfil~}% 【宽松版】
		}{%
			\ifstrequal{#1}{compact}{%
				\def\mystyle{\vspace{-1cm}}%     【紧凑版】
			}{%
				\def\mystyle{\vfil~}%             【标准版 standard】
			}%
		}%
	}%
}

% 宏包加载时默认初始化为标准版
\setlayoutmode{standard}

% =========================================================================
% 3. 章节与目录样式（完整保留原版双横线讲次样式）
% =========================================================================
\setcounter{tocdepth}{0}
\renewcommand{\contentsname}{\color{blue}目\qquad 录}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}

\newcommand{\chapternamebox}[1]{%
	\parbox{\ccwd}{\linespread{1}\selectfont\centering #1}%
}

\ctexset{
	chapter = {
		name        = {第,讲},
		beforeskip  = 0pt,
		fixskip     = true,
		format      = \Huge\color{cyan}\bfseries,
		nameformat  = \rule{\linewidth}{1bp}\par\bigskip\hfill\label{chap\thechapter}\chapternamebox,
		number      = \arabic{chapter},
		aftername   = \par\medskip,
		aftertitle  = \par\bigskip\nointerlineskip\rule{\linewidth}{2bp}\par
	},
	section = {
		format      = \color{cyan}\Large\bfseries,
	},
	contentsname = {目 录}
}

% =========================================================================
% 4. 定理环境与知识模块标题
% =========================================================================
\numberwithin{equation}{section}

\newtheoremstyle{thm}
{10pt}  % 上间距
{10pt}  % 下间距
{}      % 正文字体
{}      % 缩进
{}      % 定理头字体
{.}     % 标点
{.5em}  % 标点后间距
{}

\theoremstyle{thm}
\newtheorem{thm}{\qquad\textbf{定理}}[chapter]
\newtheorem{definition}{\qquad\textbf{定义}}[chapter]
\newtheorem{lemma}{\qquad\textbf{引理}}[chapter]
\newtheorem{corollary}{\qquad\textbf{推论}}[chapter]
\newtheorem{property}{\qquad\textbf{性质}}[chapter]
\newtheorem{conclusion}{\qquad\textbf{结论}}[chapter]
\newtheorem{formula}{\qquad\textbf{公式}}[chapter]

% 板块大标题（进入新板块前自动结算上一题的板书分页）
\newcommand{\zhishiyaodian}{\boardflush\par\noindent{\bfseries\color{cyan}\zihao{3} 知识要点}\par}
\newcommand{\litifenxi}{\boardflush\par\noindent{\bfseries\color{cyan}\zihao{3} 例题分析}\par}
\newcommand{\kehoulianxi}{\boardflush\par\noindent{\bfseries\color{cyan}\zihao{3} 课后练习}\par}

% 多级知识点编号 (\zsd, \subzsd, \subsubzsd)
\newcounter{myenvcounter}[chapter]
\setcounter{myenvcounter}{1}
\def\theenv{\arabic{chapter}.\arabic{myenvcounter}}

\newcounter{mysubenvcounter}[myenvcounter]
\def\thesubenv{\arabic{chapter}.\arabic{myenvcounter}.\arabic{mysubenvcounter}}

\newcounter{mysubsubenvcounter}[mysubenvcounter]
\def\thesubsubenv{\arabic{chapter}.\arabic{myenvcounter}.\arabic{mysubenvcounter}.\arabic{mysubsubenvcounter}}

\newcommand{\zsd}[1]{%
	\boardflush
	\refstepcounter{myenvcounter}%
	\par\vspace{1em}%
	\noindent{\zihao{3}\color{cyan}\textbf{\theenv{}~~#1}}%
	\par\vspace{1em}%
}
\newcommand{\subzsd}[1]{%
	\boardflush
	\refstepcounter{mysubenvcounter}%
	\par\vspace{0.8em}%
	\noindent{\zihao{4}\textbf{\thesubenv{}~~#1}}%
	\par\vspace{0.8em}%
}
\newcommand{\subsubzsd}[1]{%
	\boardflush
	\refstepcounter{mysubsubenvcounter}%
	\par\vspace{0.5em}%
	\noindent{\zihao{-4}\textbf{\thesubsubenv{}~~#1}}%
	\par\vspace{0.5em}%
}
% =========================================================================
% 5. 题型环境与解答显示开关（支持 board 防粘连、隐藏题干序号直连、多解自动编号）
\% ========================================================================= \newlength{\solfiveproblems}  \setlength{\solfiveproblems}{0cm} \newlength{\solfourproblems}  \setlength{\solfourproblems}{0cm} \newlength{\solthreeproblems} \setlength{\solthreeproblems}{0cm} \newlength{\soltwoproblems}   \setlength{\soltwoproblems}{0cm} \newlength{\soloneproblems}   \setlength{\soloneproblems}{0cm}

% 多解与 AI 解答共享计数器（每道新题开始时自动重置，从 2 开始递增）
\newcounter{solnum} \setcounter{solnum}{1}

% 暂存题号盒子与状态开关（用于注释掉 \problemstrue 时无视空行直连序号与“解答：”）
\newif\ifmhpendingnum \mhpendingnumfalse \newcommand{\mhpendingnumtext}{}

\newcommand{\mhflushpendingnum}{%
	\ifmhpendingnum
	\par\noindent\textbf{\zihao{-4}\mhpendingnumtext}~\% 	\global\mhpendingnumfalse \fi }

% --- 题目计数器与基础环境 --- \newcounter{exampletest} \counterwithin{exampletest}{chapter} \renewcommand{\theexampletest}{\arabic{exampletest}} \newenvironment{exampletest}{\% \refstepcounter{exampletest}\% \ifproblems 	\par\textbf{\zihao{-4}例\theexampletest}~\% \else 	\gdef\mhpendingnumtext{例\theexampletest}\% 	\global\mhpendingnumtrue \fi }{\ifproblems\par\fi}

\newcounter{lianxitest} \counterwithin{lianxitest}{chapter} \renewcommand{\thelianxitest}{\arabic{lianxitest}} \newenvironment{lianxitest}{\% \refstepcounter{lianxitest}\% \ifproblems 	\par\textbf{\zihao{-4}练\thelianxitest}~\% \else 	\gdef\mhpendingnumtext{练\thelianxitest}\% 	\global\mhpendingnumtrue \fi }{\ifproblems\par\fi}

\newcounter{zuoyetest} \counterwithin{zuoyetest}{chapter} \renewcommand{\thezuoyetest}{\thechapter-\arabic{zuoyetest}} \newenvironment{zuoyetest}{\% \refstepcounter{zuoyetest}\% \ifproblems 	\par\textbf{\zihao{-4}题\thezuoyetest}~\% \else 	\gdef\mhpendingnumtext{题\thezuoyetest}\% 	\global\mhpendingnumtrue \fi }{\ifproblems\par\fi}

\newcounter{tuozhantest} \counterwithin{tuozhantest}{chapter} \renewcommand{\thetuozhantest}{\thechapter-\arabic{tuozhantest}} \newenvironment{tuozhantest}{\% \refstepcounter{tuozhantest}\% \ifproblems 	\par\textbf{\zihao{-4}拓展\thetuozhantest}~\% \else 	\gdef\mhpendingnumtext{拓展\thetuozhantest}\% 	\global\mhpendingnumtrue \fi }{\ifproblems\par\fi}

% --- 题目包装环境（每题开始重置 solnum=1，结束时兜底释放未消耗题号） --- \NewDocumentEnvironment{example}{+b}{\% \setcounter{solnum}{1}\% \global\mhpendingnumfalse \boardstartproblem \ifproblems 	\ifsol 		\begin{exampletest}@1\end{exampletest}\% 	\else 		\ifboardmode 			\begin{exampletest}@1\end{exampletest}\% 		\else 			\hspace{-1cm}\begin{minipage}[t][][t]{\textwidth} 				\setlength{\parindent}{2em} 				\begin{exampletest}@1\end{exampletest} 			\end{minipage}\mystyle 		\fi 	\fi \else 	\begin{exampletest}@1\end{exampletest}\% 	\mhflushpendingnum \fi }{\par}

\NewDocumentEnvironment{lianxi}{+b}{\% \setcounter{solnum}{1}\% \global\mhpendingnumfalse \boardstartproblem \ifproblems 	\iflxsol 		\begin{lianxitest}@1\end{lianxitest}\% 	\else 		\ifboardmode 			\begin{lianxitest}@1\end{lianxitest}\% 		\else 			\hspace{-1cm}\begin{minipage}[t][][t]{\textwidth} 				\setlength{\parindent}{2em} 				\begin{lianxitest}@1\end{lianxitest} 			\end{minipage}\mystyle 		\fi 	\fi \else 	\begin{lianxitest}@1\end{lianxitest}\% 	\mhflushpendingnum \fi }{\par}

\NewDocumentEnvironment{zuoye}{+b}{\% \setcounter{solnum}{1}\% \global\mhpendingnumfalse \boardstartproblem \ifproblems 	\iflxsol 		\vspace{0.1cm}\begin{zuoyetest}@1\end{zuoyetest}\% 	\else 		\ifboardmode 			\vspace{0.1cm}\begin{zuoyetest}@1\end{zuoyetest}\% 		\else 			\hspace{-1.5cm}\begin{minipage}[t][][t]{\textwidth} 				\setlength{\parindent}{2em} 				\begin{zuoyetest}@1\end{zuoyetest} 			\end{minipage}\mystyle 		\fi 	\fi \else 	\begin{zuoyetest}@1\end{zuoyetest}\% 	\mhflushpendingnum \fi }{\par}

\NewDocumentEnvironment{tuozhan}{+b}{\% \setcounter{solnum}{1}\% \global\mhpendingnumfalse \boardstartproblem \ifproblems 	\iflxsol 		\vspace{0.1cm}\begin{tuozhantest}@1\end{tuozhantest}\% 	\else 		\ifboardmode 			\vspace{0.1cm}\begin{tuozhantest}@1\end{tuozhantest}\% 		\else 			\hspace{-1.5cm}\begin{minipage}[t][][t]{\textwidth} 				\setlength{\parindent}{2em} 				\begin{tuozhantest}@1\end{tuozhantest} 			\end{minipage}\mystyle 		\fi 	\fi \else 	\begin{tuozhantest}@1\end{tuozhantest}\% 	\mhflushpendingnum \fi }{\par}

% 无编号小题环境
\newcommand{\duotisep}[1]{\vspace{@1}} \NewDocumentEnvironment{duoti}{+b}{\% \setcounter{solnum}{1}\% \global\mhpendingnumfalse \boardstartproblem \ifsol 	\vspace{0.1cm}@1\vspace{0.1cm} \else 	\ifboardmode 		\vspace{0.1cm}@1\vspace{0.1cm} 	\else 		\hspace{-1cm}\begin{minipage}[t][][t]{\textwidth} 			\setlength{\parindent}{2em}@1 		\end{minipage}\mystyle 	\fi \fi }{\par}

% 题干环境（受 \ifproblems 控制；隐藏时静默不输出空行）
\NewDocumentEnvironment{problems}{+b}{\% \ifproblems @1\par\fi }{}

% 内部统一解答渲染宏（若存在待输出题号则直接同行拼接“序号 解答：...”）
\newcommand{\mhrendersol}[3]{\% \ifbool{@1}{%
		\ifmhpendingnum
		\mhflushpendingnum
		{\color{solColor}解答：@2}\vspace{0.3cm}\par 	\else 		\vspace{0.3cm}{\color{solColor}解答：@2}\vspace{0.3cm}\par 	\fi }{\% 	\mhflushpendingnum 	\ifboardmode\else\ifdefempty{@3}{}{\vspace*{@3}}\fi
	}%
	\boardendproblem
}

\newcommand{\mhrendersolvfill}[3]{\% \ifbool{@1}{%
		\ifmhpendingnum
		\mhflushpendingnum
		{\color{solColor}解答：@2}\vspace{0.3cm}\par 	\else 		\vspace{0.3cm}{\color{solColor}解答：@2}\vspace{0.3cm}\par 	\fi }{\% 	\mhflushpendingnum 	\ifboardmode\else\ifdefempty{@3}{}{\vspace*{@3}\vfill}\fi
	}%
	\boardendproblem
}

% --- 解答环境（board 模式下无论是否显示答案，均在末尾换页并重置状态） --- \NewDocumentEnvironment{sol}{+b}{\mhrendersol{sol}{@1}{\solfiveproblems}}{} \NewDocumentEnvironment{Ssol}{+b}{\mhrendersol{sol}{@1}{\solfourproblems}}{} \NewDocumentEnvironment{Msol}{+b}{\mhrendersolvfill{sol}{@1}{\solthreeproblems}}{} \NewDocumentEnvironment{Bsol}{+b}{\mhrendersol{sol}{@1}{\soltwoproblems}}{}

% 练习/作业解答环境
\NewDocumentEnvironment{lxsol}{+b}{\mhrendersol{lxsol}{@1}{\solfiveproblems}}{} \NewDocumentEnvironment{lxSsol}{+b}{\mhrendersol{lxsol}{@1}{\solfourproblems}}{} \NewDocumentEnvironment{lxMsol}{+b}{\mhrendersol{lxsol}{@1}{\solthreeproblems}}{} \NewDocumentEnvironment{lxBsol}{+b}{\mhrendersol{lxsol}{@1}{\soltwoproblems}}{}

% 拓展解答环境
\NewDocumentEnvironment{tzsol}{+b}{\mhrendersol{tzsol}{@1}{\solfiveproblems}}{} \NewDocumentEnvironment{tzSsol}{+b}{\mhrendersol{tzsol}{@1}{\solfourproblems}}{} \NewDocumentEnvironment{tzMsol}{+b}{\mhrendersol{tzsol}{@1}{\solthreeproblems}}{} \NewDocumentEnvironment{tzBsol}{+b}{\mhrendersol{tzsol}{@1}{\soltwoproblems}}{}

% 无编号小题解答环境
\NewDocumentEnvironment{duotisol}{+b}{\mhrendersolvfill{sol}{@1}{\solfiveproblems}}{} \NewDocumentEnvironment{duotiSsol}{+b}{\mhrendersolvfill{sol}{@1}{\solfourproblems}}{} \NewDocumentEnvironment{duotiMsol}{+b}{\mhrendersolvfill{sol}{@1}{\solthreeproblems}}{} \NewDocumentEnvironment{duotiBsol}{+b}{\mhrendersolvfill{sol}{@1}{\soltwoproblems}}{}

% --- 一题多解与 AIsol 环境（共享 solnum 计数器，每题自动从 2 递增） --- \NewDocumentEnvironment{altsol}{g +b}{\% \stepcounter{solnum}\% \par{\color{altsolcolor}\textbf{解法\thesolnum：}@2}\par
}{}

\NewDocumentEnvironment{AIsol}{g +b}{\% \ifAIproof 	\stepcounter{solnum}\% 	\par{\color{aicolor}\textbf{解法(T)\thesolnum：}@2}\par
	\fi
}{}

% --- 辅助与分组环境 --- \NewDocumentEnvironment{analysis}{+b}{\ifanalysis\vspace{0.1cm}{\color{analysiscolor}分析：@1}\vspace{0.1cm}\fi}{\par} \NewDocumentEnvironment{adding}{+b}{\ifadding{\color{red}@1}\vspace{0.1cm}\fi}{\par} \NewDocumentEnvironment{onlytopic}{+b}{\ifonly @1\else\zsd{课后创新培养}\fi}{\par} \NewDocumentEnvironment{groupA}{+b}{\ifgroupA\boardflush\par\vspace{1em}\begin{center}{\zihao{3}\color{cyan}\textbf{\ensuremath{A}~组}}\end{center}\par@1\else\vspace{\solthreeproblems}\fi}{\par} \NewDocumentEnvironment{groupB}{+b}{\ifgroupB\boardflush\par\vspace{1em}\begin{center}{\zihao{3}\color{cyan}\textbf{\ensuremath{B}~组}}\end{center}\par@1\else\vspace{\solthreeproblems}\fi}{\par} \NewDocumentEnvironment{groupC}{+b}{\ifgroupC\boardflush\par\vspace{1em}\begin{center}{\zihao{3}\color{cyan}\textbf{\ensuremath{C}~组}}\end{center}\par@1\else\vspace{\solthreeproblems}\fi}{\par}

% 标签式信息命令
\newcommand{\ans}[1]{\vspace{0.2cm}\iftagged{ans}{{\bfseries 答案：}{\color{red}@1}\par}{}\vspace{0.2cm}}
\newcommand{\daan}[1]{\vspace{0.2cm}\iftagged{daan}{{\bfseries 答案：}{\color{red}@1}\par}{}\vspace{0.2cm}}
\newcommand{\beizhu}[1]{\vspace{0.2cm}\iftagged{ans}{{\bfseries 备注：}{\color{red}@1}\par}{}\vspace{0.2cm}}
\newcommand{\laiyuan}[1]{\vspace{0.2cm}\iftagged{laiyuan}{{\bfseries 题源：}{\color{red}@1}\par}{}\vspace{0.2cm}}
\newcommand{\kaodian}[1]{\vspace{0.2cm}\iftagged{kaodian}{\quad{\color{red}@1}\par}{}\vspace{0.2cm}} \newcommand{\difficulty}[1]{\iftagged{difficulty}{{\color{red}@1}}{}}

% =========================================================================
% 6. 自定义符号、图片与自动排版命令
\% ========================================================================= \newcommand{\huo}{\text{或}} \newcommand{\qie}{\text{且}} \newcommand{\edot}{\hfil\cdots} \newcommand{\yuanshi}{\text{原式}} \newcommand{\DDA}{\ding{72}} \newcommand{\DDB}{\ding{72}\ding{72}} \newcommand{\DDC}{\ding{72}\ding{72}\ding{72}} \newcommand{\DDD}{\ding{72}\ding{72}\ding{72}\ding{72}} \newcommand{\DDE}{\ding{72}\ding{72}\ding{72}\ding{72}\ding{72}}

\def\kge@1{\,\raisebox{-2pt}{\rule{@1}{0.4pt}}\,} \def\tk{\kge{1.5cm}} \newcommand{\kh}[1][0.7]{\nolinebreak\hfill\mbox{(\hspace{@1 cm})}}

\newcommand{\pxqdy}{\% \mathrel{\text{\% 	\tikz[baseline,line width=0.05ex,line cap=round] 	\draw (0,0) -- (.7em,0) (0,.45ex) -- (.7em,.45ex) 	(.25em,.55ex) -- (.35em,1.6ex) (.45em,.55ex) -- (.55em,1.6ex); }}\% } \newcommand{\pxsbx}{\% \mathord{\text{\% 	\tikz[baseline,line width=0.05ex,line join=round] 	\draw (0,.1ex) -- (.8em,.1ex) -- (1em,1.6ex) -- (.2em,1.6ex) -- cycle; }}\% } \newcommand*{\circled}[1]{\lower.7ex\hbox{\tikz\draw (0pt,0pt) circle (.5em) node {\makebox[1em][c]{\small @1}};}} \newcommand{\libcirc}[1]{\% \pgfmathparse{ifthenelse(@1 > 0 && @1 < 21, Hex(9311+@1), Hex(9450))}\% {\fontspec{Cambria}\char"\pgfmathresult}%
}
\newcommand{\newsquare}{\tikz[scale=0.3]\draw(0,0)grid(1,1);} \newcommand{\newcircle}{\tikz\draw(0,0)circle(4.5pt);}

\def\tkzDefRotateFangsuo(@1,@2,@3,@4){%
	\begingroup
	\tkzDefPointBy[rotation=center @1 angle @2](@4)
	\pgfnodealias{tkzFirstPointResult}{tkzPointResult} \tkzDefPointOnLine[pos=@3](@1,tkzFirstPointResult) \pgfnodealias{tkzSecondPointResult}{tkzPointResult} \endgroup }

\newcommand{\imgin}[3][0.38]{\% \par\begin{minipage}[t]{1.0\textwidth} 	\ifblank{@2}{\centering}{\% 		\ifstrequal{@2}{l}{\raggedright}{\% 			\ifstrequal{@2}{r}{\raggedleft}{\centering}\% 		}\% 	}\% 	\includegraphics[scale=@1]{@3}\% \end{minipage}\% } \newcommand{\myfig}[2]{\% \begin{figure}[H] 	\begin{flushright} 		\includegraphics[width=@1\linewidth]{@2} 	\end{flushright} \end{figure} }

\newlength{\lab} \newlength{\lb} \newlength{\lc} \newlength{\ld} \newlength{\lhalf} \newlength{\lquarter} \newlength{\lmax} \newcommand{\xx}[4]{\% \mbox{}\\[.5pt]\% \settowidth{\lab}{\ensuremath{\text{A.~}}@1~~~}%
	\settowidth{\lb}{\ensuremath{\text{B.~}}@2~~~}\% \settowidth{\lc}{\ensuremath{\text{C.~}}@3~~~}%
	\settowidth{\ld}{\ensuremath{\text{D.~}}@4~~~}\% \setlength{\lmax}{\lab}\% \ifdim\lb>\lmax \setlength{\lmax}{\lb}\fi \ifdim\lc>\lmax \setlength{\lmax}{\lc}\fi \ifdim\ld>\lmax \setlength{\lmax}{\ld}\fi \setlength{\lhalf}{0.5\linewidth}\% \setlength{\lquarter}{0.25\linewidth}\% \ifdim\lmax>\lhalf
	\noindent{}A.~@1 \\ B.~@2 \\ C.~@3 \\ D.~@4
	\else
	\ifdim\lmax>\lquarter
	\noindent\makebox[\lhalf][l]{A.~@1~~~}\makebox[\lhalf][l]{B.~@2~~~}\\%
	\noindent\makebox[\lhalf][l]{C.~@3~~~}\makebox[\lhalf][l]{D.~@4~~~}%
	\else
	\noindent\makebox[\lquarter][l]{A.~@1~~~}\makebox[\lquarter][l]{B.~@2~~~}%
	\makebox[\lquarter][l]{C.~@3~~~}\makebox[\lquarter][l]{D.~@4~~~}%
	\fi
	\fi
}

\endinput
