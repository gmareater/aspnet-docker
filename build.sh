#!/usr/bin/env bash

set -e

cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $cwd > /dev/null

export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
if [ "$DOTNET_HOME" == "" ]; then
    export DOTNET_HOME="$cwd/.dotnet"
    export PATH="$DOTNET_HOME:$PATH"
fi

mkdir -p $DOTNET_HOME

export DotnetCliVersion=$(<$cwd/CliVersion.txt)

if test ! -x $DOTNET_HOME/dotnet || test "$($DOTNET_HOME/dotnet --version)" != $DotnetCliVersion ; then
    sh ./scripts/dotnet-install.sh --install-dir $DOTNET_HOME --version $DotnetCliVersion
fi

$DOTNET_HOME/dotnet msbuild build.proj /nologo "$@"