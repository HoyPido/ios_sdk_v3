Pod::Spec.new do |spec|
spec.name = "MobileConnectSDK"
spec.version = "3.2.2"
spec.summary = "MobileConnectSDK is a framework for accessing Mobile Connect services for fast login."
spec.homepage = "https://developer.mobileconnect.io"
spec.license = { type: 'MIT', file: 'Metadata/LICENSE' }
spec.authors = { "Dan Andoni" => 'dan.andoni@bjss.com' }
spec.social_media_url = "https://developer.mobileconnect.io"

spec.platform = :ios, "8.0"
spec.requires_arc = true
spec.source = { :git => "https://github.com/Mobile-Connect/r2-ios-sdk", :branch => 'master', :tag=>  "#{spec.version}"}

spec.subspec 'Extensions' do |extensions|
extensions.source_files = 'MobileConnectSDK/Extensions/*.swift'
end

spec.subspec 'Services' do |services|

services.subspec 'AttributeService' do |attributeservice|
attributeservice.source_files = 'MobileConnectSDK/Services/AttributeService/*.swift'
end

services.subspec 'RefreshToken' do |refreshtoken|
refreshtoken.source_files = 'MobileConnectSDK/Services/RefreshToken/*.swift'
end

services.subspec 'RevokeToken' do |revoketoken|
revoketoken.source_files = 'MobileConnectSDK/Services/RevokeToken/*.swift'
end

services.subspec 'BaseMobileConnect' do |basemobileconnect|
basemobileconnect.source_files = 'MobileConnectSDK/Services/BaseMobileConnect/*.swift'
end

services.subspec 'MobileConnect' do |mobileConnect|

mobileConnect.subspec 'Configurations' do |configurations|
configurations.source_files = 'MobileConnectSDK/Services/MobileConnect/Configurations/*.swift'
end

mobileConnect.source_files = 'MobileConnectSDK/Services/MobileConnect/*.swift'
end

services.subspec 'Discovery' do |discovery|
discovery.source_files = 'MobileConnectSDK/Services/Discovery/*.swift'
end

services.subspec 'UserInfoService' do |userInfo|
userInfo.source_files = 'MobileConnectSDK/Services/UserInfoService/*.swift'
end

services.source_files = 'MobileConnectSDK/Services/*.swift'
end

spec.subspec 'Models' do |models|

models.subspec 'TokenId' do |tokenid|
tokenid.source_files = 'MobileConnectSDK/Models/TokenId/*.*'
end

models.subspec 'Enums' do |enums|
enums.source_files = 'MobileConnectSDK/Models/Enums/*.*'
end

models.source_files = 'MobileConnectSDK/Models/*.{h,m,swift}'
end

spec.subspec 'MobileConnectManager' do |mobileConnectManager|
mobileConnectManager.source_files = 'MobileConnectSDK/MobileConnectManager/*.swift'
end

spec.resources = 'MobileConnectSDK/AdditionalFiles/*.{xcassets,storyboard,strings}'

spec.subspec 'Controllers' do |controllers|
controllers.source_files = "MobileConnectSDK/Controllers/*.swift"
end

spec.subspec 'Views' do |views|
views.source_files = "MobileConnectSDK/Views/*.swift"
end

spec.subspec 'Utilities' do |utilities|

utilities.subspec 'JWTTools' do |jwttools|
jwttools.source_files = "MobileConnectSDK/Utilities/JWTTools/*.swift"
end

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
spec.dependency 'Heimdall', '~> 1.0.0'

end