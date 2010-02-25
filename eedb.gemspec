# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eedb}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Herald"]
  s.date = %q{2010-02-25}
  s.default_executable = %q{eedb}
  s.description = %q{Migrates your EE DB to and from a server with rollback capabilities and find and replace to change paths automagically.}
  s.email = %q{nathan@myobie.com}
  s.executables = ["eedb"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/eedb",
     "lib/eedb.rb",
     "lib/eedb/ext.rb",
     "lib/eedb/mysql.rb"
  ]
  s.homepage = %q{http://github.com/myobie/eedb}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Migrating your EE DB to and from a server is now easy}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, [">= 0"])
    else
      s.add_dependency(%q<bacon>, [">= 0"])
    end
  else
    s.add_dependency(%q<bacon>, [">= 0"])
  end
end
