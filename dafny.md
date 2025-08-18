---
layout: page
title: Set up Dafny
description: How to set up Dafny
---

# Installing Dafny on Visual Studio Code

To install Dafny in Visual Studio Code, you need first to download and install Visual Studio Code if you do not have it already. On Linux and Mac Os you will also need the latest version of Mono.

Once you have Visual Studio Code, you can install the Dafny extension for Visual
Studio Code following [these
instructions](https://marketplace.visualstudio.com/items?itemName=dafny-lang.ide-vscode). This
extension contains everything you need, including its own copy of Dafny.

**Note**: you need to have .NET installed. Only the runtime one is necessary. If you want to install it on Ubuntu, for example, you can follow [these instructions](https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu), or likewise look for similar instructions for your environment. To install on Windows, you can download the SDK (preferably version >= 6) and install, then you must configure the executable path of the dotnet.exe file when prompted in Visual Studio Code.

## Mac M1 installation

Thanks to Guilherme de Oliveira Silva:

1. Install Dafny via Homebrew with `brew install dafny`. All dependencies will be automatically installed.

2. Install the Dafny extension on VS Code.

3. Edit the `settings.json` file of VS Code to include:

"dafny.dotnetExecutablePath": "/opt/homebrew/opt/dotnet@6/bin/dotnet",
"dafny.languageServerRuntimePath": "/opt/homebrew/Cellar/dafny/4.3.0/libexec/DafnyLanguageServer.dll",
"dafny.compilerRuntimePath": "/opt/homebrew/Cellar/dafny/4.3.0/libexec/Dafny.dll"

## Using via command line

Thanks to Lecio Charlles Barbosa. A possible makefile for Dafny files:

``` makefile
# install java
# apt install default-jre
#
# install dotnet 6.0 from Microsoft site
# https://dotnet.microsoft.com/en-us/download/dotnet/6.0
#
# install these programs from source:
# git clone https://github.com/dafny-lang/dafny
# git checkout 4.3.0 # or the next one
#
# git clone https://github.com/Z3Prover/z3
# git checkout 4.12.2 # or the next one
#


# FIXME LOCATE AND SET PARAMETERS:
NET_RUNTIME=dotnet
DAFNY=/root/dafny/Binaries/Dafny.dll
# can use DafnyDriver.dll too
INPUT=test.dfy
args=

# List of Comands (Targets):
# resolve Only check for parse and type resolution errors.
# verify Verify the program.
# build Produce an executable binary or a library.
# run Run the program. []
# translate Translate Dafny sources to source and build files in a specified language.
# audit Report issues in the Dafny code that might limit the soundness claims of verification, emitting them as warnings or in a report document.

run:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)

r: resolve
resolve:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)

v: verify
verify:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)

b: build
build:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)

t: translate
translate:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)

a: audit
audit:
$(NET_RUNTIME) $(DAFNY) $@ $(INPUT) $(args)
```

# Using Dafny

Opening a Dafny file (with a `.dfy` extension) with Visual Studio or Visual Studio Code will allow you to see syntax highlighting as well as any errors, as underlined text, in the code or specification. Dafny is reinvoked automatically as you edit the text.
