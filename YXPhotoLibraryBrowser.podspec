#
#  Be sure to run `pod spec lint YXPhotoLibraryBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

version = "0.0.1"
s.name         = "YXPhotoLibraryBrowser"
s.version      = version
s.summary      = "a lib for select local photos."
s.homepage     = "https://github.com/LucienYep/YXPhotoLibraryBrowser"
s.author       = { "Lucien" => "506652461@qq.com" }
s.source       = { :git => "https://github.com/LucienYep/YXPhotoLibraryBrowser.git", :tag => version }
s.platform     = :ios, '8.0'
s.source_files = "YXPhotoLibraryBrowser", "YXPhotoLibraryBrowser/YXPhotoLibraryBrowser/PhotoLibraryPicker/**/*.{h,m}"
s.resources = "YXPhotoLibraryBrowser/YXPhotoLibraryBrowser/PhotoLibraryPicker/imgs/*.png"
s.requires_arc = true
s.license      = { :type => 'MIT', :file => 'LICENSE' }



end
