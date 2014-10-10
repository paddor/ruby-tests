module MyMod
  #require "require_in_module_data"
  load "require_in_module_data.rb"
end

MyModData.hello
MyMod::MyModData.hello
