
platform :ios, '9.0'
#use_frameworks!
#use_modular_headers!
inhibit_all_warnings!

def commonkit
    pod 'StepOHelper', '~> 0.0.3'
#    pod 'StepOHelper', :path => '../StepOHelper'
    pod 'MJRefresh'
end

target 'FDlna' do
    commonkit
end


#### 解决依赖库有静态库pod install时引起的错误
#### target has transitive dependencies that include static binaries
#pre_install do |installer| Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
#end
