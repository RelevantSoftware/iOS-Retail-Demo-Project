# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'


def shared_pods
    use_frameworks!
   pod 'MagicalRecord', :git => 'https://github.com/TheFirm/MagicalRecord'
end


target 'RetailDemo' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks

    shared_pods
    pod 'MagicalRecord', :git => 'https://github.com/TheFirm/MagicalRecord'

    #pod 'MagicalRecord' , ‘2.3.0'
    pod 'IQKeyboardManager', '4.0.7'
    pod 'Alamofire', '4.0'
    pod 'SVProgressHUD', '2.0.3'
    pod 'RSBarcodes_Swift'
    pod 'SDWebImage', '3.8.2'
    pod 'KINWebBrowser'
    pod 'RAMAnimatedTabBarController', '~> 2.0.13'
    pod 'Appsee'
end

target 'Widget' do
    shared_pods

end

target 'RetailDemoWatch Extension' do
    shared_pods

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts target.name
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

