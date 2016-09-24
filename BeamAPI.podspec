Pod::Spec.new do |s|
  s.name       = "BeamAPI"
  s.version    = "1.3"
  s.summary    = "An interface to communicate with Beam's backend."
  s.homepage   = "https://github.com/WatchBeam/beam-client-swift"
  s.license    = "MIT"
  s.author     = { "Jack Cook" => "jack@beam.pro" }

  s.requires_arc           = true
  s.ios.deployment_target  = "8.2"
  s.tvos.deployment_target = "9.0"
  s.source                 = { :git => "https://github.com/WatchBeam/beam-client-swift.git", :tag => "1.3" }
  s.source_files           = "Pod/Classes/**/*"

  s.dependency "Starscream", "~> 2.0"
  s.dependency "SwiftyJSON", "~> 3.0"
end
