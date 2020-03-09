%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original header below, for attribution. However, this resume class is now
% fairly distinct and notably restyled.
%
% While the oringal visual appearance tends to be the same, the underlying
% wiring has changed dramatically over time.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2020/03/08 v0.10.0 Resume class]  % YYYY/MM/DD

\LoadClass[11pt,letterpaper]{article}

\RequirePackage[realmainfile]{currfile}
\RequirePackage[parfill]{parskip} % Remove paragraph indentation
\RequirePackage[
  left=0.75in,right=0.75in,
  top=0.4in,bottom=0.4in,
  includehead=true,
  headheight=14pt,  % Silence fancyhdr warning
  headsep=6pt,
]{geometry}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage[nostamp]{draftwatermark}
\RequirePackage{datetime2}

\pagestyle{fancy}  % Has to be in our preamble

%
% Make a stable PDF build
% * Removes the /CreationDate and /ModDate entries in the document info dictionary
% * Stabilize the \ID in the PDF Trailer
%
\pdfinfoomitdate=1
\pdftrailerid{\jobname}


%
% Variables, contact info, etc.
%
% Use \def to set these before you begin your document.
%
% In the \@address* fields, you can use \\ to add an appropriate separator between lines.
%
\def \@name {}
\def \name#1 {\def \@name{#1}}

\def \@address {}
\def \address #1 {\def \@address{#1}}

\def \@phone {}
\def \phone#1 {\def \@phone{#1}}

\def \@email {}
\def \email#1 {\def \@email{#1}}

%
% Variant support.
%
% When \jobname is the same as the basename of the filename, then we use the default variant.
% Otherwise, we use \jobname for the variant.
%
% jobname is passed on the command line of pdflatex, as "-jobname=STRING"
%
\def \@draftVariant {dev}
\def \@variant {}
\def \computeVariant {  % Called at document begin
  \ifdraft{
    \let \@variant \@draftVariant
  }{
    \let \@variant \jobname
  }
}

% Include the variant from an include directory, if it exists. If not, generic.tex is used instead.
\newcommand{\includeVariant}[1] {
  \IfFileExists{./inc/#1/\@variant.tex}{
    \input{./inc/#1/\@variant}
  }{
    \input{./inc/#1/generic}
  }
}



%
% Header
%
\def \namesize         {\huge}
\def \nameSkip         {\bigskip}
\def \addressSkip      {\smallskip}
\def \addressSeparator {$\diamond$}

\def \printNameLine {
  \hfil{\MakeUppercase{\namesize\bf \@name}}
  \hfil\nameSkip\break
}

\def \printAddressLine#1 {
  \begingroup
    \def \\ {\addressSeparator\ }
    \centerline{#1}
  \endgroup
  \par
  \addressSkip
}

\renewcommand{\maketitle}{
  \printNameLine
  \printAddressLine{\@address}
  \printAddressLine{\@phone\ \\ \@email}
}

\newcommand{\ifdraft}[2] {
  % If the jobname is the same as the *.tex filename, then we're in draft mode,
  % most likely editing in TeXShop.
  \ifcurrfilebase{\jobname}{#1}{#2}
}


%
% Page Headers
%
\def \makePageHeaders {
  \fancyhf{}
  \fancyhead[L]{\@name}
  \fancyhead[R]{\thepage}
  \thispagestyle{empty}
}


%
% A generic resume section
%
\def \sectionSkipBeforeHeader {\medskip}
\def \sectionSkipAfterHeader  {\medskip}

\renewenvironment{section}[1] {
  \sectionSkipBeforeHeader
  \MakeUppercase{\bf #1}
  \sectionSkipAfterHeader
  \hrule
  \begin{list}{}{
    \setlength{\leftmargin}{1.5em} % Margin within the section
  }
  % Include an empty item here so we can reuse this environment to also contain a non-itemized section (e.g., Summary)
  \item[]
}{
  \end{list}
}


%
% A Work-experience specialized helper.
%
% This uses files in inc/#1/ to render the work experience, as such:
%
% * metadata.tex contains the job basics -- title, company, etc
% * {variant}.tex contains the description for the job. If that doesn't exist, we use generic.tex instead.
%
\newcommand{\workExperience}[1] {
  \input{./inc/#1/metadata}
  {\bf \company} \hfill {\startDate - \endDate}
  \\
  {\em \title} \hfill {\em \cityState}
  \smallskip
  \begin{list}{$\cdot$}{\leftmargin=0em}
    \itemsep -0.5em \vspace{-0.5em}
    \includeVariant{#1}
  \end{list}
  \vspace{0.5em}
  \pagebreak[2]  % Encourage pagebreaks between jobs, instead of in the middle of lists
}


%
% In order to KISS, we'll wrap up the document to automatically add the header and such.
%
\let\ori@document=\document
\renewcommand{\document}{
  \makePageHeaders
  \ori@document
  \computeVariant
  \maketitle
  \ifdraft{
    % TeXShop has an ugly grey background by default, and the PDF seems otherwise transparent.
    \pagecolor{white}

    % Include a draft watermark
    \SetWatermarkText{DRAFT \DTMnow}
    \SetWatermarkScale{2}
    \SetWatermarkColor[rgb]{0.8,0.8,0.8}
    \@sc@wm@stamptrue
  }
}{}
