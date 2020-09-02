#
# Be sure to run `pod lib lint IJKMediaPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IJKMediaPlayer'
  s.version          = '1.0.0'
  s.summary          = 'IJKMediaPlayer build from IJKPlayer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  IJKMediaPlayer build from IJKPlayer. Dynamic framework.
  Support arm64 and x86_64 archs.
  
  Container: mp4, mov, mkv, 3gp, mpg, flv, wmv, rm, rmvb, avi, m4v, asf, m4a, webm, caf, ogg, ts
  Video decoder: wmv1~3, h263, h264, hevc, mpeg*, msmpeg*, rv*, vp*, theora
  Audio decoder: mp1~3, ac3, aac, amr*, alac, flac, opus, vorbis, cook

  Not support: swf
                       DESC

  s.homepage         = 'https://github.com/SEEWO-inc/IJKMediaPlayer.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guoqingwei' => 'guoqingwei@cvte.com' }
  s.source           = { :http => "https://github.com/SEEWO-inc/IJKMediaPlayer.git" }

  s.ios.deployment_target = '9.0'

  s.vendored_frameworks = 'IJKMediaFrameworkWithSSL.framework'

  s.frameworks = 'AudioToolbox', 'VideoToolbox', 'AVFoundation', 'CoreMedia', 'CoreVideo', 'MediaPlayer', 'OpenGLES', 'QuartzCore', 'CoreGraphics', 'MobileCoreServices'
  s.libraries = 'bz2', 'c++', 'z'

end
