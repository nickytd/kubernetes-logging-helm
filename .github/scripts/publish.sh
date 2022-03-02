#!/bin/bash

version="v1.3.0"
owner=$(cut -d '/' -f 1 <<< "$GITHUB_REPOSITORY")
git_repo=$(cut -d '/' -f 2 <<< "$GITHUB_REPOSITORY")
git_base_url="https://api.github.com/"
git_upload_url="https://uploads.github.com/"


echo "Installing chart-releaser... $version"
tmp=`mktemp -d`
curl -Lo $tmp/cr.tar.gz  "https://github.com/helm/chart-releaser/releases/download/$version/chart-releaser_${version#v}_linux_amd64.tar.gz"
tar -xzvf $tmp/cr.tar.gz
rm -f $tmp/cr.tar.gz

ls -la $tmp/

$tmp/cr package chart
$tmp/cr upload -o $owner -r $git_repo -t $token -b $git_base_url -u $ git_upload_url --skip-existing
$tmp/cr index -o $owner -r $git_repo -t $token -b $git_base_url -u $ git_upload_url
