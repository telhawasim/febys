# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'febys' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for febys
  inhibit_all_warnings!
  
  pod 'JWTDecode', '~> 2.6'
  pod 'IQKeyboardManagerSwift'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GoogleSignIn', '~> 6.2.4'
  pod 'FBSDKLoginKit'
  pod 'Kingfisher', '~> 7.0'
  pod 'XLPagerTabStrip'
  pod 'Cosmos'
  pod 'PhoneNumberKit'
  pod "FlagPhoneNumber"
  pod 'PayPalCheckout'
  pod 'BraintreeDropIn'
  pod 'ScrollableSegmentedControl'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'ImageViewer'
  pod 'SnapKit'
  
  pod 'ZendeskAnswerBotSDK' # AnswerBot-only on the Unified SDK
  pod 'ZendeskChatSDK'      # Chat-only on the Unified SDK
  pod 'ZendeskSupportSDK'   # Support-only on the Unified SDK

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
         end
    end
  end
end
