#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

home = "./"
cfg = YAML.load_file(home + "config.yml")

cfg["rhdg_tutorials"].each do |version, sub|
  puts "#{version} wget"
  zipUrl=sub["zip-url"]
  puts "#{version} wget #{zipUrl}"
  %x( wget #{zipUrl} -O _tmp.zip)
  %x( unzip _tmp.zip "*documentation/*" -d _tmp)
  Dir.glob("_tmp/**/*.asciidoc").each do |f|
    %x( asciidoctor -a allow-uri-read -a productized #{f} )
  end
  Dir.glob("_tmp/**/*.html").each do |f|
    %x( cp -r #{f} _tmp )
  end
  %x( rm -rf infinispan-simple-tutorials/#{version} )
  %x( mkdir -p infinispan-simple-tutorials/#{version}/tutorials )
  %x( mv _tmp/index.html infinispan-simple-tutorials/#{version}/ )
  %x( mv _tmp/*.html infinispan-simple-tutorials/#{version}/tutorials )
  %x( tar -czvf simple-tutorial-html.tar.gz infinispan-simple-tutorials )
  %x( rm -rf _tmp* infinispan-simple-tutorials )
end
