#!/usr/bin/bash

# This file automates the conda env set up to run a local server using `bundle exec jekyll serve`

# Set up Conda env
# conda env create -f web_env.yml
# conda activate web_env

# Modify ruby set up (as see on https://github.com/conda-forge/staged-recipes/issues/5978#issuecomment-499585477)
# cd $(gem environment gemdir)
# cd ../../$(basename $PWD)/$(gem environment platform | sed -e 's/.*://')
# mv rbconfig.rb rbconfig.rb.bu
# perl -pe 's/\/\S*?\/_build_env\/bin\///g' rbconfig.rb.bu > rbconfig.rb 

# Some stuff for nokogiri
conda install -c anaconda libxml2 
# conda install -c conda-forge backports.lzma 
# sudo apt-get install liblzma-dev zlib1g-dev
# LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
# LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
# CPATH=/usr/lib/x86_64-linux-gnu:$CPATH
# read -t 10 branch || exit

# Install Jekyll stuff
gem install nokogiri -v '1.6.3' --source 'https://rubygems.org/'
# gem install bundler jekyll