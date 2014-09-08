Pod::Spec.new do |s|

  s.name         = "CoreWeather"
  s.version      = "1.0.1"
  s.summary      = "Weather API for Objective-C"
  s.homepage     = "https://github.com/MegaBits/CoreWeather"

  # s.license      = 'MIT (example)'
  # s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }

  s.author             = { "MegaBits" => "dev@megabitsapp.com" }

  s.platform     = :ios, '6.0'
  s.source       = {
      :git => "https://github.com/MegaBits/CoreWeather.git",
      :tag => "v1.0.1"
  }

  # s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.source_files = '*.h', 'Categories/*.{h,m}', 'Classes/*.{h,m}'

  s.requires_arc = true
  s.dependency 'PCHTTP', '~> 1.0.0'

end
