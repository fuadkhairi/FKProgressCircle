Pod::Spec.new do |spec|
spec.name = "FKProgressCircle"
spec.version = "0.0.1"
spec.summary = "Easily create progress circle with icon/arrow"
spec.description = "Its a library to render progress circle along with indicators like arrow, etc"
spec.homepage = "https://github.com/fuadkhairi/FKProgressCircle"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.author = { "Fuad Khairi Hamid" => "fuadkhairihamid@gmail.com" }
spec.platform = :ios, "12.0"
spec.swift_version = '5.0'
spec.source = { :git => "https://github.com/fuadkhairi/FKProgressCircle.git", :tag => '0.0.1', :branch => 'main' }
spec.source_files = "FKProgressCircle/FKProgressCircle/**/*.swift"
end