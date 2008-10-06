# Although the haml instructions say to "haml --rails ." to install a simple
# haml plugin (which has just an init.rb file), I was a little nervous about
# its use of "require 'rubygems'" and 'rescue LoadError'. Since I know I've
# got haml config.gem'ed and unpacked in vendor/gems, I'm just going to make
# the initialization call here:
Haml.init_rails(binding)