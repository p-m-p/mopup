require 'lib/mopup'

Gem::Specification.new do |s|

  s.name = 'mopup'
  s.authors = ['Phil Parsons']
  s.email = 'phil@profilepicture.co.uk'
  s.homepage = 'https://github.com/p-m-p/mopup'
  s.require_path = 'lib'
  s.summary = 'Code cleanup utils'
  s.description = 'White space and tab clean up and removal tool'
  s.version = Mopup::VERSION
  s.executables = 'mopup'
  s.files = Dir.glob("{bin,lib}/*")

end
