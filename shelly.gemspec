# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shelly}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonas Grimfelt"]
  s.date = %q{2009-05-16}
  s.default_executable = %q{shelly}
  s.description = %q{Remotely stored shell scripts runned locally - shell scripts á la rubygems sort of.}
  s.email = %q{grimen@gmail.com}
  s.executables = ["shelly"]
  s.extra_rdoc_files = [
    "README.textile",
    "TODO.textile"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "TODO.textile",
    "bin/shelly",
    "config/shelly.yml",
    "lib/shelly.rb",
    "lib/shelly/script_source/base.rb",
    "lib/shelly/script_source/plain/base.rb",
    "lib/shelly/script_source/plain/gist.rb",
    "lib/shelly/script_source/plain/pastebin.rb",
    "lib/shelly/script_source/plain/pastie.rb",
    "lib/shelly/script_source/plain/raw.rb",
    "lib/shelly/script_source/scm/base.rb",
    "lib/shelly/script_source/scm/github.rb",
    "lib/shelly/shell_script.rb",
    "lib/shelly/store/alias.rb",
    "lib/shelly/store/base.rb",
    "lib/shelly/store/repo.rb",
    "test/shelly_test.rb"
  ]
  s.homepage = %q{http://github.com/grimen/shelly/tree/master}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Remotely stored shell scripts runned locally - shell scripts á la rubygems sort of.}
  s.test_files = [
    "test/shelly_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
