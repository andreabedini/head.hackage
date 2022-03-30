#!/bin/bash

set -e

inputDir=$1 # head.hackage checkout

for n in "$inputDir"/patches/*.patch; do
  pkgId="$(basename "$n" .patch)"
  name="${pkgId%-*}"
  version="${pkgId##*-}"
  url="https://hackage.haskell.org/package/$pkgId/$pkgId.tar.gz"

  mkdir -p _sources/$name/$version
  echo "url = '$url'" >_sources/$name/$version/meta.toml
  mkdir -p _sources/$name/$version/patches
  cp -v $n _sources/$name/$version/patches/1.patch
done

awk -i inplace '/timestamp = / { hasTimestamp = 1 }; !hasTimestamp { printf("timestamp = %s\n", strftime("%Y-%m-%dT%H:%M:%S", systime(), 1)) }; { print }' _sources/*/*/meta.toml
