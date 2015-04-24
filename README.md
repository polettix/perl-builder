# NAME

perl-builder - create a perl-building Perl program

# VERSION

Ask the version number to the script itself, calling:

    shell$ perl-builder --version

# USAGE

    perl-builder [--usage] [--help] [--man] [--version]

    perl-builder locator
                 [--cpanm cpanm-locator]
                 [--mirror|-m URI]
                 [--output|-o path]
                 [--path|-p path]

# EXAMPLES

    # generate perl-builder-5.20.2.pl
    shell$ perl-builder 5.20.2

    # use a local archive to do the same
    shell$ perl-builder ./perl-5.20.2.tar.bz2

    # set output file name for a builder of version 5.18.1
    shell$ perl-builder -o build-it.pl 5.18.1

    # use locally cached version of cpanm
    shell$ perl-builder --cpanm local 5.16.1

# DESCRIPTION

`perl-builder` is a program that allows you to create installers for
specific versions of Perl. These installers are Perl programs themselves,
and you will need nothing more than some previous perl installation to
build the whole thing.

For example, suppose that you want to streamline the installation of
release 5.20.2; you can generate the installer:

    # generate perl-builder-5.20.2.pl
    shell$ perl-builder 5.20.2

and then move `perl-builder-5.20.2.pl` where you actually want to do
the installation.

In the plethora of perl-installing facilities, `perl-builder` takes a
somehow _inside-out_ approach, where you generate a script that installs
a specific version of Perl, as opposed to having a script (e.g.
perlbrew or perl-build) that is capable, alone, of installing many
different perls.

## Opinionated Installation

To start the installation, just run the generated builder program. By
default it will be installed in a subdirectory of the current one, named
after the perl tarball contained in the builder; you can pass one single
(optional) path to install somewhere else.

The installation process is somehow _opinionated_, subject to change
in the future (most probably by adding options):

- **relocatable**

    `perl-builder` tries hard to make your perl relocatable. Compilation
    is done using `-Duserelocatableinc`, and a `relocate` script is also
    included to help you mangle the start of the scripts and the different
    `Config*` files with embedded paths.

- **undocumented**

    or so. Manual pages are not installed for reduced space disk, you can
    always use `perldoc` anyway.

- **non-expandable**

    or better it helps you to avoid installing things in `site_perl` by
    removing it and placing an empty regular file instead (so that
    installing there will always produce an error). Why? This helps to
    remember to have a separate _private_ installation of modules for
    each project, although you can always revert this change back by
    re-creating the directory.

- **cpanm-provided**

    a copy of `cpanm` ([http://cpanmin.us](http://cpanmin.us)) is installed by default
    for ease of installation of modules. You will probably have to
    resort to the `-L` options of `cpanm` to install modules locally
    to a project.

Why the features (or lack thereof) above? When I need to install Perl
in some machine, I know that I will probably be cut out of the Internet
(hence the self-installer comes handy) and that I want to keep my
new Perl as _original_ as possible, forcing me to install modules
needed for a project in a per-project tree. For doing this, `cpanm`
is very useful. I usually don't need the man pages (`perldoc` FTW!)
and I might need to move the installed perl to some other location
later.

## Builder Goodies

The builder program is generated using `deployable` (you can
find some info here: [http://blog.polettix.it/parachuting-whatever/](http://blog.polettix.it/parachuting-whatever/)), so
it provides you its goodies.

As an added bonus, the builder also carries the tools for tweaking it
and re-generate the builder itself. A typical workflow for making tweaks
would be like this (suppose you are using builder
`perl-build-5.20.2.pl`):

    shell$ ./perl-build-5.20.2.pl --inspect here
    # some lines are printed... and directory here is created
    shell$ cd here
    # here you do your tweaking. When ready, we can generate a
    # new builder like this:
    shell$ ./regenerate ../perl-build-5.20.2-tweaked.pl

In this way you can e.g. modify the `installer` program, that is the
real workhorse in the installation process.

# OPTIONS

The only mandatory option is provided directly without an option name. It
consists in a _locator_ for the perl to be installed:

- a simple version number, e.g. `5.16.1`
- a perl package name, e.g. `perl-5.20.2`
- a URI where the specific perl can be downloaded from
- a file path in the local filesystem

Depending on the value of the locator, the corresponding tarball will
be copied/downloaded for generating the self-installing executable.

All other options are optionals and come with a name:

- --cpanm cpanm-locator

    set the place where `cpanm` will be taken. You can pass different values:

    - the string `local`, in which case a locally cached version will be used
    - a URI for downloading
    - a path in the filesystem

    By default, it will try to download from `http://cpanmin.us/`. In case
    of failure, `perl-builder` will fallback on the locally cached copy.

- --help

    print a somewhat more verbose help, showing usage, this description of
    the options and some examples from the synopsis.

- --man

    print out the full documentation for the script.

- --mirror|-m URI

    set the mirror to use for fetching the list of available packages and
    download the relevant tarball. Ignored unless the script has to find
    a tarball position. Defaults to [http://www.cpan.org/](http://www.cpan.org/).

- --output|-o path

    set the output path for the builder program. By default, the builder is
    saved in the current directory with name `perl-builder-X.Y.Z.pl`, where
    `X.Y.Z` is the perl version.

- --path|-p path

    set the path where differnt perls are stored in the mirror. Defaults
    to `/src/5.0/`.

- --usage

    print a concise usage line and exit.

- --version

    print the version of the script.

# CONFIGURATION AND ENVIRONMENT

perl-builder requires no configuration files or environment variables.

# DEPENDENCIES

Quite a few:

- `Log::Log4perl::Tiny`
- `WWW::Mechanize`
- `File::chdir`
- `Path::Tiny`

and what they imply.

# BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through GitHub
([https://github.com/polettix/perl-builder](https://github.com/polettix/perl-builder)).

# AUTHOR

Flavio Poletti `polettix@cpan.org`

# LICENSE AND COPYRIGHT

Copyright (c) 2015, Flavio Poletti `polettix@cpan.org`.

This module is free software.  You can redistribute it and/or
modify it under the terms of the Artistic License 2.0. Please read
the full license in the `LICENSE` file inside the distribution,
as you can find at [https://github.com/polettix/perl-builder](https://github.com/polettix/perl-builder).

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.
