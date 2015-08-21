Pod::Spec.new do |s|
  s.name             = 'MRGLaunchImageViewController'
  s.version          = '0.1.4'
  s.summary          = 'A view controller that displays the launch image to ease your transitions at app launch.'
  s.homepage         = 'https://github.com/Mirego/MRGLaunchImageViewController'
  s.license          = 'BSD 3-Clause'
  s.authors          = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source           = { :git => 'https://github.com/Mirego/MRGLaunchImageViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mirego'

  s.platform         = :ios, '7.0'
  s.requires_arc     = true

  s.source_files     = 'Pod/Classes'
end
