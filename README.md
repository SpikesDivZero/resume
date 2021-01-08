# Spikes' Resume

Only the "generic" form of my resume is available in this repo.

## Building

The primary build command is `make rebuild`.

We rebuild every time as make doesn't give me a great way to say "this variant depends on these files".
Make also doesn't allow us to readily detect a rebuild being necessary when a variant file is deleted.

## Variants

I have a few variants of my resume, but only the generic variant appears in this public repository.

The build system detects the number of variants via a listing of files in the `inc` directory.
This is done in the Makefile's `VARIANTS` declaration.

The resume class determines which variant we're building based on the LaTeX `jobname`, provided by the Makefile.

When doing our includes for a folder named `f`, we use `f/{jobname}.tex` if it exists.
If there is no variant-specific file in the named folder, we fall back on `f/generic.tex` instead.

## Include Directory Layout

### Skills / Summary

These are the simpler case, and provide a great demonstration for how `includeVariant` works.
The bodies for these sections exist simply in `inc/{section}/{variant}.tex`

### Companies and Jobs

`includeCompany` loads in `inc/{company}.tex` to get the basic information about the company, as well as which jobs to include.

The company uses `includeJob` to include `inc/{company}/{job}/{variant}.tex` to include specifics about each job within the company.

Job folders are named in the format of `{startYear}-{title}`.
Start Year is used as it's stable, and so folders are nicely ordered in the directory listings.
