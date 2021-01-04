%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This class was originally built upon the works of Trey Hunner.
%
% While the oringal visual appearance tends to be similar, many years of usage has resulted in this changing
% substantially -- from the underlying LaTeX wiring to stylistic preferences.
%
% Given the sheer volume of changes, I'm unable to say what % of this is the same as Trey originally authored.
% Accordingly, I'm preserving his original header below, but all blame for faults rests solely upon my shoulders.
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

% TODO: ORR reccomended using 10pt instead of the 11pt I was using previously.
% It feels a bit too small to me, so I'm undecided.
\LoadClass[11pt,letterpaper]{article}

\RequirePackage[
  left=0.5in,right=0.5in,
  top=0.5in,bottom=0.5in,
]{geometry}
\RequirePackage[parfill]{parskip}  % Remove paragraph indentation
\RequirePackage{xcolor}
\RequirePackage[colorlinks=true,urlcolor=blue]{hyperref}
\RequirePackage[realmainfile]{currfile}
\RequirePackage[stamp=false]{draftwatermark}
\RequirePackage{datetime2}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}

%
% Document Header and Title
%
\def \name#1     {\def \@name     {#1}}
\def \location#1 {\def \@location {#1}}
\def \phone#1    {\def \@phone    {#1}}
\def \email#1    {\def \@email    {#1}}
\def \linkedin#1 {\def \@linkedin {#1}}

\def \nameSize         {\Large}
\def \nameSkip         {\smallskip}
\def \addressSkip      {\smallskip}
\def \addressSeparator {$|$}

\renewcommand{\maketitle}{
  % Name line
  \centerline{\MakeUppercase{\nameSize\bf \@name}}
  \nameSkip

  % Address Line
  \begingroup
    \def \\ {\ \addressSeparator\ }
    \centerline{
      \@location\\
      \@phone\\
      \href{mailto:\@email}{\@email}\\
      \href{\@linkedin}{LinkedIn}
    }
  \endgroup
  \addressSkip
}

%
% Sections
%
% The bulk of our document, other than the title, is broken down into sections. This
% is the environment for a single section, with a section title as it's only argument.
%
\def \sectionSkipBeforeHeader {\medskip}
\def \sectionSkipAfterHeader  {\medskip}

\renewenvironment{section}[1] {
  \sectionSkipBeforeHeader
  \MakeUppercase{\bf #1}
  \sectionSkipAfterHeader
  \hrule
}{}

%
% Variant Support
%
% We use \jobname as the variant to build. jobname is passed on the command line of pdflatex as "-jobname=STRING"
%
% When \jobname is the same as the basename of the filename, then we consider ourselves to be in draft mode.  This is
% typically true when building in TeXShop (live rendering).
%
\def \draftVariant#1 {\def \@draftVariant {#1}}
\draftVariant{generic}

\def \@variant {}
\def \computeVariant {  % Called at document begin
  \ifdraft{
    \let \@variant \@draftVariant
  }{
    \let \@variant \jobname
  }
}

\newcommand{\includeVariant}[1] {
  \IfFileExists{./inc/#1/\@variant.tex}{
    \input{./inc/#1/\@variant}
  }{
    \input{./inc/#1/generic}
  }
}

% If the jobname is the same as the *.tex filename, then we're in draft mode, most likely editing in TeXShop.
\newcommand{\ifdraft}[2] {
  \ifcurrfilebase{\jobname}{#1}{#2}
}

%
% Watarmarking
%
% We don't want to ship a resume that isn't committed (using the draft variant), so we'll make it obvious when we're
% working with a draft variant.
%
\newcommand{\makeWatermark} {
  % TeXShop has an ugly grey background by default, and the PDF seems otherwise transparent.
  \pagecolor{white}

  % Include a draft watermark
  \DraftwatermarkOptions{text={DRAFT \DTMnow}}
  % FIXME: Maybe switch to lmodern font/pkg to reset scale=1. Would require setting fontsize=
  %     LaTeX Font Warning: Size substitutions with differences
  %     (Font)              up to 128.69374pt have occurred.
  \DraftwatermarkOptions{scale=2}
  \DraftwatermarkOptions{color={[rgb]{0.8,0.8,0.8}}}
  \DraftwatermarkOptions{stamp=true}
}

%
% Work Experience Support
%
% The jist of this is that we'll be including the company's metadata, generating a header,
% then including each of the jobs under the company.
%

% These var setters are required to be called within inc/{company}.tex.
% These @vars are purposefully not defined outside of the company context.
\def \companyName#1     {\def \@companyName     {#1}}
\def \companyLocation#1 {\def \@companyLocation {#1}}
\def \companyJobs#1     {\def \@companyJobs     {#1}}

\newcommand{\includeCompany}[1] {
  \begingroup
    \def \@company {#1}
    \input{./inc/#1}
    {\bf \@companyName} \hfill \@companyLocation \\
    \@companyJobs
  \endgroup
}

% Jobs are included as well; this uses \@company, which was defined in \includeCompany
%
% These var setters are required to be called within inc/{company}/{job}.tex.
% These @vars are purposefully not defined outside of the job context.
\def \jobTitle#1 {\def \@jobTitle {#1}}
\def \jobStart#1 {\def \@jobStart {#1}}
\def \jobEnd#1   {\def \@jobEnd   {#1}}
\newtoggle{jobDutiesIsList}  % Has to be global, unfortunately.

\newcommand{\includeJob}[1] {
  \begingroup
    \def \@companyJob {\@company/#1}
    \toggletrue{jobDutiesIsList}
    \input{./inc/\@companyJob/metadata.tex}
    {\em \@jobTitle} \hfill \@jobStart\ -- \@jobEnd \\
    \iftoggle{jobDutiesIsList}{
      \vspace{-2em}  % FIXME: This is a hack to deal with excessive whitespace. I don't like it.
      \begin{list}{$\cdot$}{\leftmargin=1em}
        \itemsep -0.6em
        \vspace{0em}
        \includeVariant{\@companyJob}
      \end{list}
    }{
      \includeVariant{\@companyJob}
    }
    \smallskip
    %\vspace{0.5em}  % Is this needed?
    %\pagebreak[2]  % Encourage pagebreaks between jobs, instead of in the middle of lists
  \endgroup
}

%
% Make a stable PDF build
% * Removes the /CreationDate and /ModDate entries in the document info dictionary
% * Stabilize the \ID in the PDF Trailer
%
\pdfinfoomitdate=1
\pdftrailerid{\jobname}

%
% Disable headers and footers
%
% By default, LaTeX includes a footer with just the page number.
%
\pagestyle{empty}

%
% We'll wrap up the document environment, to automatically inject our key bits (header, etc)
%
\let\ori@document=\document
\renewcommand{\document}{
  \ori@document
  \computeVariant
  \maketitle
  \ifdraft{\makeWatermark}
}{}
