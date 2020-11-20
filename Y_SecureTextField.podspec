Pod::Spec.new do |s|
  #名称
  s.name         = "Y_SecureTextField"
  #版本
  s.version      = "0.0.2"
  #简介
  s.summary      = "验证码/密码输入框"
  #详介
  s.description  = <<-DESC
  类似支付宝验证码输入框，指定验证码/密码位数，每一位值有方框框起来的输入框
                   DESC
  #首页
  s.homepage     = "https://github.com/1ilI/Y_SecureTextField"
  #截图
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  #开源协议
  s.license      = { :type => "MIT", :file => "LICENSE" }
  #作者信息
  s.author             = { "1ilI" => "1ilI" }
  #iOS的开发版本
  s.ios.deployment_target = "9.0"
  #源码地址
  s.source       = { :git => "https://github.com/1ilI/Y_SecureTextField.git", :tag => "#{s.version}" }
  #源文件所在文件夹，会匹配到该文件夹下所有的 .h、.m文件
  s.source_files  = "Y_SecureTextField", "Y_SecureTextField/**/*.{h,m}"
  #依赖的framework
  s.framework  = "UIKit"
end