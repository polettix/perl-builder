#!/bin/bash
ME=$(readlink -f "$0")
MYDIR=$(dirname "$ME")
PACK=$(ls "$MYDIR"/perl-*.tar.*)

die() {
   echo "$*" >&2
   exit 1
}

packname() {
   local fullname=$1
   basename "$fullname" | sed 's/\.tar\.\(bz2\|gz\)$//'
}

resolve_target() {
   local target=$1
   local packfile=$2
   if [ -z "$target" ] ; then
      target=$(packname "$packfile")
   fi
   [ -n "$OLD_PWD" ] || die "OLD_PWD is empty..."
   cd "$OLD_PWD" || die "cannot hop back into $OLDPWD"
   [ -e "$target" ] && die "target '$target' exists"
   mkdir -p "$target"
   readlink -f "$target"
}

compile_and_install() {
   local package=$1
   local target=$2
   local startdir=$PWD
   subdir=$(packname "$package")
   mkdir build &&
   tar xvf "$package" -C build &&
   cd "build/$subdir" &&
   sh Configure -des -Duserelocatableinc -Dman1dir=none -Dman3dir=none -Dprefix="$target" &&
   make &&
   make install &&
   cd "$target" &&
   rm -rf man &&
   cd lib &&
   rm -rf site_perl &&
   touch site_perl &&
   cd "$startdir" &&
   rm -rf build &&
   sed -e "1s#.*#\#!$target/bin/perl#" cpanm >"$target/bin/cpanm" &&
   sed -e "1s#.*#\#!$target/bin/perl#" relocate >"$target/bin/relocate" &&
   chmod +x "$target/bin/cpanm" "$target/bin/relocate"
}

TARGET=$(resolve_target "$1" "$PACK")
[ $? -eq 0 ] || die 'bailing out'
[ -n "$TARGET" ] || die 'bailing out'
compile_and_install "$PACK" "$TARGET" || die 'something went wrong'
