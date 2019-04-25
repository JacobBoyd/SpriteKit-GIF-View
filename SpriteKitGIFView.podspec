Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "SpriteKiteGIFView"
s.summary = "Uses SpriteKit and ImageIO to support animated GIFs"
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Jacob Boyd" => "jacobboyd14012@gmail.com" }

s.homepage = "https://github.com/JacobBoyd/SpriteKit-GIF-View"

s.source = { :git => "https://github.com/JacobBoyd/SpriteKit-GIF-View.git",
:tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "SpriteKitGIF/**/*.{swift}"

#s.resources = "SpriteKitGIF/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "4.2"

end
