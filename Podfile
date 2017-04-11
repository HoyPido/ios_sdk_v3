target 'DemoSwift' do
  use_frameworks!
  pod 'JSONModel', '~> 1.7.0’
  pod 'Alamofire', '~> 4.4’
  pod 'Heimdall', '~> 1.1.3’
  
end

target ‘ExampleAppWithoutDiscovery’ do
    use_frameworks!
end


target 'MobileConnectSDKTests' do
  use_frameworks!
  pod 'Quick', '~> 1.1.0’
  pod 'Nimble', '~> 6.1.0’
  pod 'JSONModel', '~> 1.7.0’
  pod 'Alamofire', '~> 4.4’
  pod 'Heimdall', '~> 1.1.3’
end

target 'MobileConnectSDK' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Heimdall', '~> 1.1.3’
  pod 'JSONModel', '~> 1.7.0’
  pod 'Alamofire', '~> 4.4’
  # Pods for MobileConnectSDK
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
