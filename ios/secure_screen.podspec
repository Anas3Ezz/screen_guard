Pod::Spec.new do |s|
  s.name             = 'screen_guard'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to prevent screenshots and screen recording on Android and iOS.'
  s.description      = <<-DESC
    A Flutter plugin that prevents screenshots and screen recording.
    Uses FLAG_SECURE on Android and the UITextField secure layer trick on iOS.
  DESC
  s.homepage         = 'https://github.com/Anas3Ezz/screen_guard'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anas Ezz' => 'anas3ez@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'
end
