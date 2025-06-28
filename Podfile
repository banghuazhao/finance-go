# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'finance-go' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit', '~> 5.0.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Hue'
  pod 'Then'
  pod 'Localize-Swift', '~> 2.0'
  # pod 'Google-Mobile-Ads-SDK'
  # pod "SkeletonView"
  # pod 'WCLShineButton'
  # pod 'WechatOpenSDK'
  # pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
  pod 'Toast-Swift'
  pod 'MBProgressHUD'
  pod "Sheeeeeeeeet"
  pod 'Cache'
  pod 'JTAppleCalendar'
  pod 'JXSegmentedView'
  pod 'MJRefresh'
  pod 'JTAppleCalendar'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Alamofire', '~> 5.4'
  pod 'PPBadgeViewSwift'
  pod 'TagListView', '~> 1.0'
  pod 'Charts', '~> 3.6.0'
  # pod 'AMScrollingNavbar'
  pod 'ImageViewer.swift', '~> 3.0'
  # pod "StatefulViewController"
  pod 'SnapshotKit'
  pod 'Schedule', '~> 2.0'
  pod 'DateToolsSwift'

end

post_install do |installer|

    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end

    installer.pods_project.targets.each do |target|
        if target.name.start_with?("Pods")
            puts "Updating #{target.name} OTHER_LDFLAGS to OTHER_LDFLAGS[sdk=iphone*]"
            target.build_configurations.each do |config|
                xcconfig_path = config.base_configuration_reference.real_path
                xcconfig = File.read(xcconfig_path)
                new_xcconfig = xcconfig.sub('OTHER_LDFLAGS =', 'OTHER_LDFLAGS[sdk=iphone*] =')
                File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
            end
        end
    end
end
