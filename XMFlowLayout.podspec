#
#  Be sure to run `pod spec lint XMFlowLayout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "XMFlowLayout"
  s.version      = "1.0.0"
  s.summary      = "custom CollectionViewLayout"
  s.license      = "MIT"
  s.homepage     = "https://github.com/guxinming/XMFlowLayout.git"
  s.author        = { "liliangming" => "liliangming@58ganji.com" }
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/guxinming/XMFlowLayout.git", :tag => s.version }
  s.source_files  = "XMFlowLayout/XMFlowLayout/*.{h,m}"
  s.frameworks    = 'Foundation', 'UIKit'
  s.requires_arc = true

end
