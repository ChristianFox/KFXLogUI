

Pod::Spec.new do |s|
	s.name             = 'KFXLogUI'
	s.version          = '0.1.0'
	s.summary          = 'KFXLogUI is the UI components for KFXLog. '
	
	s.description      = <<-DESC
	UI Classes for displaying log files from [KFXLog](https://github.com/ChristianFox/KFXLog.git)
	DESC
	
	s.homepage         = 'https://github.com/ChristianFox/KFXLogUI'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'Christian Fox' => 'christianfox@kfxtech.com' }
	s.source           = { :git => 'https://github.com/Christian Fox/KFXLogUI.git', :tag => s.version.to_s }
	
	s.ios.deployment_target = '8.2'
	
	s.source_files = 'KFXLogUI/Classes/**/*'
	
	s.dependency 'KFXLog'
end
