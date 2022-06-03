# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'Furat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Firebase'
  pod 'GoogleSignIn'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Functions'
  pod 'Firebase/Analytics'
  pod 'Firebase/Storage'
  pod 'Firebase/Crashlytics'
  pod 'FirebaseUI/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
  
  pod 'RealmSwift'
  pod 'Collections'
  # Pods for Furat

  target 'FuratTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FuratUITests' do
    # Pods for testing
  end

end
