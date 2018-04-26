Pod::Spec.new do |spec|
spec.name = "ClientSide"
spec.version = "3.3.5"
spec.summary = "ClientSide is a framework for accessing Mobile Connect services for fast login."
spec.homepage = "https://developer.mobileconnect.io"
spec.license = { type: 'MIT', file: 'Metadata/LICENSE' }
spec.authors = { "Dmitry Maretsky" => 'd.maretsky@a1qa.com' }
spec.social_media_url = "https://developer.mobileconnect.io"

spec.platform = :ios, "9.0"
spec.requires_arc = true
spec.source = { :git => "https://github.com/Mobile-Connect/r2-ios-sdk", :branch => 'master', :tag=>  "#{spec.version}"}

spec.subspec 'Utils' do |utils|
utils.source_files = 'ClientSide/Utils/*.swift'
end

spec.subspec 'Objects' do |objects|
objects.source_files = 'ClientSide/Objects/*.swift'
end

spec.subspec 'RequestManager' do |requestmanager|
requestmanager.source_files = 'ClientSide/RequestManager/*.swift'
end

spec.subspec 'Services' do |services|
services.source_files = 'ClientSide/Services/*.swift'
end

end

