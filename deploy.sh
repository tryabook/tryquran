#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# perform git updates
cd $DIR
cd themes/hestia && git pull origin master
rm -rf $DIR/public/
rm -rf $DIR/content/post/

# copy posts over
/usr/bin/rclone --config $DIR/rclone.conf copy google:tryquran/ $DIR/content/post/

# build content
cd $DIR && hugo --theme=hestia

# deploy
cd $DIR/public
cp $DIR/CNAME .
git init
git remote add origin https://tryabook:$GITHUB_TOKEN@github.com/tryabook/tryquran.git
git config user.name "Travis CI"
git config user.email "travis@travisci.org"
git config commit.gpgsign false
git checkout --orphan gh-pages
git add --all
git commit -m "Publishing to gh-pages"
git push -f origin gh-pages
