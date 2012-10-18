Pod::Spec.new do |s|
    s.name = 'ELCImagePickerController'
    s.version = '0.0.1'
    s.summary = 'A Multiple Selection Image Picker.'
    s.homepage = 'https://github.com/elc/ELCImagePickerController'
    s.license = {
      :type => 'MIT',
      :file => 'README'
    }
    s.author = {'ELC Technologies' => 'http://elctech.com'}
    s.source = { 
      :git => 'https://github.com/elc/ELCImagePickerController.git', 
      :commit => 'HEAD' 
    }
    s.platform = :ios, '5.0'
    s.resources = "Classes/**/*.{xib}"
    s.source_files = 'Classes/**/*.{h,m}'
    s.framework = 'Foundation', 'UIKit'
    s.requires_arc = false
end