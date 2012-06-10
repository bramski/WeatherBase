Gem::Specification.new do |s|
  s.name = 'weatherbase'
  s.version = '0.0.2'
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'A gem for retrieving WeatherBase data from mysql'
  s.description = s.summary
  s.author = 'Bram Whillock'
  s.email = 'bramski@gmail.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end
