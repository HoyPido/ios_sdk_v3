Pod::Spec.new do |spec|
  spec.name = "MobileConnectSDK"
  spec.version = "1.1"
  spec.summary = "MobileConnectSDK is a framework for accessing Mobile Connect services for fast login."
  spec.homepage = "https://developer.mobileconnect.io"
  spec.license = { type: 'MIT', file: 'Metadata/LICENSE' }
  spec.authors = { "Dan Andoni" => 'dan.andoni@bjss.com' }
  spec.social_media_url = "https://developer.mobileconnect.io"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
spec.source = { :git => "https://github.com/Mobile-Connect/ios-sdk-v2.git", :branch => 'master', :tag=>  "#{spec.version}"}
  spec.source_files = "MobileConnectSDK/**/*.{h,swift,m}"
  spec.public_header_files = "MobileConnectSDK/**/*.h"

  spec.dependency 'JSONModel', '~> 1.2.0'
  spec.dependency 'Alamofire', '~> 3.4'

end
