Pod::Spec.new do |spec|
  spec.name = "MobileConnectSDK"
  spec.version = "1.0.12"
  spec.summary = "MobileConnectSDK is a framework for accessing Mobile Connect services for fast login."
  spec.homepage = "https://developer.mobileconnect.io"
  spec.license = { type: 'MIT', file: 'Metadata/LICENSE' }
  spec.authors = { "Dan Andoni" => 'dan.andoni@bjss.com' }
  spec.social_media_url = "https://developer.mobileconnect.io"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Dan-Andoni-BJSS/GSMA-iOS-Swift.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "MobileConnectSDK/**/*.{h,swift,m}"
  spec.public_header_files = "MobileConnectSDK/**/*.h"

  spec.dependency 'JSONModel', '~> 1.2.0'
  spec.dependency 'Alamofire', '~> 3.4'

end
