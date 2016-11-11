target 'DemoSwift' do
  use_frameworks!
  pod 'JSONModel', '~> 1.2.0'
  pod 'Alamofire', '3.5'
  pod 'Heimdall', '~> 1.0.0'
end

target 'MobileConnectSDKTests' do
  use_frameworks!
  pod 'Quick', '~> 0.9.3'
  pod 'Nimble', '~> 4.1.0'
  pod 'JSONModel', '~> 1.2.0'
  pod 'Alamofire', '3.5'
  pod 'Heimdall', '~> 1.0.0'
end

target 'MobileConnectSDK' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Heimdall', '~> 1.0.0'
  pod 'JSONModel', '~> 1.2.0'
  pod 'Alamofire', '3.5'
  # Pods for MobileConnectSDK
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
