Pod::Spec.new do |s|
  s.name       = "MixerAPI"
  s.version    = "1.6.3"
  s.summary    = "An interface to communicate with Mixer's backend."
  s.homepage   = "https://github.com/mixer/mixer-client-swift"
  s.license    = "MIT"
  s.author     = { "Jack Cook" => "jack@mixer.com" }

  s.requires_arc           = true
  s.ios.deployment_target  = "8.2"
  s.source                 = { :git => "https://github.com/mixer/mixer-client-swift.git", :tag => "1.6.3" }
  s.source_files           = "Pod/Classes/**/*"

  s.dependency "Starscream", "~> 2.0"
  s.dependency "SwiftyJSON", "~> 3.1"
end
