Pod::Spec.new do |spec|
spec.name = "MobileConnectSDK"
spec.version = "2.0.2"
spec.summary = "MobileConnectSDK is a framework for accessing Mobile Connect services for fast login."
spec.homepage = "https://developer.mobileconnect.io"
spec.license = { type: 'MIT', file: 'Metadata/LICENSE' }
spec.authors = { "Dan Andoni" => 'dan.andoni@bjss.com' }
spec.social_media_url = "https://developer.mobileconnect.io"

spec.platform = :ios, "8.0"
spec.requires_arc = true
spec.source = { :git => "https://github.com/Mobile-Connect/ios-sdk-v2.git", :branch => 'master', :tag=>  "#{spec.version}"}

spec.subspec 'Extensions' do |extensions|
extensions.source_files = 'MobileConnectSDK/Extensions/Extension{NSException,Dictionary}.swift'
end

spec.subspec 'Services' do |services|

services.subspec 'MobileConnect' do |mobileConnect|
mobileConnect.source_files = 'MobileConnectSDK/Services/MobileConnect/*.swift'
end

services.subspec 'Discovery' do |discovery|
discovery.source_files = 'MobileConnectSDK/Services/Discovery/*.swift'
end

services.source_files = 'MobileConnectSDK/Services/*.swift'
end

spec.subspec 'Models' do |models|
models.source_files = 'MobileConnectSDK/Models/*.{h,m}'
end

spec.subspec 'MobileConnectManager' do |mobileConnectManager|
mobileConnectManager.source_files = 'MobileConnectSDK/MobileConnectManager/*.swift'
end

spec.resources = "MobileConnectSDK/AdditionalFiles/*.{xcassets,storyboard,strings}"

spec.subspec 'Controllers' do |controllers|
controllers.source_files = "MobileConnectSDK/Controllers/*.swift"
end

spec.subspec 'Views' do |views|
views.source_files = "MobileConnectSDK/Views/*.swift"
end

spec.subspec 'Utilities' do |utilities|

utilities.subspec 'Networking' do |networking|

networking.subspec 'RequestConstructor' do |requestConstructor|
requestConstructor.source_files = "MobileConnectSDK/Utilities/Networking/RequestConstructor/*.swift"
end

networking.source_files = "MobileConnectSDK/Utilities/Networking/*.swift"
end

utilities.source_files = "MobileConnectSDK/Utilities/*.swift"
end

spec.source_files = 'MobileConnectSDK/*.{h,plist,swift}'

spec.dependency 'JSONModel', '~> 1.2.0'
spec.dependency 'Alamofire', '~> 3.4'

end
