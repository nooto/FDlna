
platform :ios, '9.0'
#use_frameworks!
#use_modular_headers!
inhibit_all_warnings!

def commonkit
    #pod 'SmartCommunity', :git => 'ssh://git@gitlab.egtest.cn:10022/smartCommunity_ios/SmartCommunity.git', :branch => 'feature/1.5.0'
    pod 'StepOHelper', :path => '../StepOHelper'
end

target 'FDlna' do
    commonkit
end


#### 解决依赖库有静态库pod install时引起的错误
#### target has transitive dependencies that include static binaries
#pre_install do |installer| Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
#end