%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Medium Length Professional CV - RESUME CLASS FILE
%
% This template has been downloaded from:
% http://www.LaTeXTemplates.com
%
% This class file defines the structure and design of the template. 
%
% Original header:
% Copyright (C) 2010 by Trey Hunner
%
% Copying and distribution of this file, with or without modification,
% are permitted in any medium without royalty provided the copyright
% notice and this notice are preserved. This file is offered as-is,
% without any warranty.
%
% Created by Trey Hunner and modified by www.LaTeXTemplates.com
%
% Further modified by Wesley Spikes for my own ends.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{resume}[2017/02/28 v0.9.1 Resume class]

\LoadClass[11pt,letterpaper]{article} % Font size and paper type

\usepackage[realmainfile]{currfile}

\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
\usepackage{ifthen} % Required for ifthenelse statements
\usepackage{lastpage} % Required for header (page X of Y)
\usepackage{fancyhdr} % Required for header
\usepackage[nostamp]{draftwatermark} % Required for draft watermark.
\usepackage{datetime2} % Required for draft watermark.
\usepackage[left=0.75in,top=0.6in,right=0.75in,bottom=0.6in]{geometry} % Document margins

\pagestyle{fancy} % Disables built-in page numbering, and let's us use our own.

%----------------------------------------------------------------------------------------
%	HEADINGS COMMANDS: Commands for printing name and address
%----------------------------------------------------------------------------------------

\def \name#1{\def\@name{#1}} % Defines the \name command to set name
\def \@name {} % Sets \@name to empty by default

\def \addressSep {$\diamond$} % Set default address separator to a diamond

% One, two or three address lines can be specified 
\let \@addressone \relax
\let \@addresstwo \relax
\let \@addressthree \relax

% \address command can be used to set the first, second, and third address (last 2 optional)
\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
  \@ifundefined{@addressthree}{
  \def \@addressthree {#1}
  }{
     \def \@addressone {#1}
  }}
}

% \printaddress is used to style an address line (given as input)
\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    \centerline{#1}
  \endgroup
  \par
  \addressskip
}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    \hfil{\MakeUppercase{\namesize\bf \@name}}\hfil
    \nameskip\break
  \endgroup
}

%----------------------------------------------------------------------------------------
%	PRINT THE HEADING LINES
%----------------------------------------------------------------------------------------

% This must be called by the document start (below here), so that it's always
% printed on the first page. This is because we use \thispagestyle here.
\def \printpageheader {
  \fancyhf{}

  % Silence a warning where fancyhdr is auto-growing this to 13.5999
  \headheight 13.6pt

  % I'm ashamed to say, I don't understand how this fixes it, but this does fix the
  % issue where the header isn't full-width on the second (and likely beyond) pages.
  % I'm estimating that this forces fancyhdr to recalculate based on the updated
  % geometry since it was first loaded?
  \fancyheadoffset[lh]{0pt}%

  % FIXME: The "~ \\ ~ \\" here is to force the header to be ~ 12pt further down, so that
  % the header prints right (can't be at top of sheet). This isn't really ideal, but I don't know
  % of a better fix right now.
  \lhead{~ \\ ~ \\ \@name}
  \rhead{~ \\ ~ \\ \thepage\ of \pageref{LastPage}}

  % The first page won't have a header, since it has the name on it already.
  \thispagestyle{empty}
}

\let\ori@document=\document
\renewcommand{\document}{
  \printpageheader % Add the header first.
  \ori@document  % Begin document
  \printname % Print the name specified with \name
  \@ifundefined{@addressone}{}{ % Print the first address if specified
    \printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{ % Print the second address if specified
    \printaddress{\@addresstwo}}
     \@ifundefined{@addressthree}{}{ % Print the third address if specified
    \printaddress{\@addressthree}}

  % If the jobname is the same as the *.tex filename, then we're in draft mode,
  % most likely editing in TeXShop.
  \ifcurrfilebase{\jobname}{
    \printdraftwatermark
  }
}

%----------------------------------------------------------------------------------------
%	DRAFT WATERMARKING
%----------------------------------------------------------------------------------------

% Call this to print a watermark on every page with the date and time,
% clearly tagging the document as a draft. Date and time is just so I can
% keep track of which draft is which. (I'm re-using the backside of printed
% drafts when reviewing/editing.)
\def \printdraftwatermark {
  \SetWatermarkText{DRAFT \DTMnow}
  \SetWatermarkScale{2}
  \SetWatermarkColor[rgb]{0.8,0.8,0.8}
  \@sc@wm@stamptrue
}

%----------------------------------------------------------------------------------------
%	SECTION FORMATTING
%----------------------------------------------------------------------------------------

% Defines the rSection environment for the large sections within the CV
\newenvironment{rSection}[1]{ % 1 input argument - section name
  \sectionskip
  \MakeUppercase{\bf #1} % Section title
  \sectionlineskip
  \hrule % Horizontal line
  \begin{list}{}{ % List for each individual item in the section
    \setlength{\leftmargin}{1.5em} % Margin within the section
  }
  \item[]
}{
  \end{list}
}

%----------------------------------------------------------------------------------------
%	WORK EXPERIENCE FORMATTING
%----------------------------------------------------------------------------------------

\newenvironment{rSubsection}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
 {\bf #1} \hfill {#2} % Bold company name and date on the right
 \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
  \\
  {\em #3} \hfill {\em #4} % Italic job title and location
  }\smallskip
  \begin{list}{$\cdot$}{\leftmargin=0em} % \cdot used for bullets, no indentation
   \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
  }{
  \end{list}
  \vspace{0.5em} % Some space after the list of bullet points
  \pagebreak[2] % Encourage pagebreaks between jobs, instead of in the middle of our lists
}

% A simple \begin{list} doesn't work in a rSubsection, so we'll wrap it up all necessary
% formatting like so. There's got to be a better way to do this, right?
\newenvironment{rSubsectionSublist}[0] {
  \begin{list}{$\cdot$}{\leftmargin=2.0em} % \cdot used for bullets, no indentation
    \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
}{
  \end{list}
}

\def\rItemCategory#1{\textbf{#1}}

%----------------------------------------------------------------------------------------
%	WORK EXPERIENCE VARIANT SUPPORT
%----------------------------------------------------------------------------------------

% And we'll use this to include job highlights for each position.
\let \ResumeVariant \relax
\newcommand{\SetResumeVariant}[1] {
  % If the jobname is the same as the *.tex filename, then we're in draft mode,
  % most likely editing in TeXShop.
  \ifcurrfilebase{\jobname}{
    \def \ResumeVariant {#1}
  }{
    \def \ResumeVariant {\jobname}
  }
}

\newcommand{\rIncludeSection}[1] {
  \IfFileExists{./inc/#1/\ResumeVariant.tex}{
    \input{./inc/#1/\ResumeVariant}
  }{
    \input{./inc/#1/generic}
  }
}

% The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip
\def\namesize{\huge} % Size of the name at the top of the document
\def\addressskip{\smallskip} % The space between the two address (or phone/email) lines
\def\sectionlineskip{\medskip} % The space above the horizontal line for each section 
\def\nameskip{\bigskip} % The space after your name at the top
\def\sectionskip{\medskip} % The space after the heading section
