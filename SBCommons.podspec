Pod::Spec.new do |s|
  s.name = 'SBCommons'
  s.version  = '0.1.0'
  s.summary  = 'Commons'
  s.description = <<-DESC
Common Swift Functionality
DESC

  s.homepage = 'http://github.com/EBGToo/SBCommons'

  s.license  = 'MIT'
  s.authors  = { 'Ed Gamble' => 'ebg@opuslogica.com' }
  s.source   = { :git => 'https://github.com/EBGToo/SBCommons.git',
  	         :tag => s.version }
  s.source_files = 'Sources/*.swift'

  s.osx.deployment_target = '10.9'
end
