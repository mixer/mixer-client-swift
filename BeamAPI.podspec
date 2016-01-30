Pod::Spec.new do |s|
  s.name             = "BeamAPI"
  s.version          = "0.1.7"
  s.summary          = "An interface to communicate with Beam's backend."
  s.homepage         = "https://github.com/WatchBeam/beam-client-swift"
  s.license          = 'MIT'
  s.author           = { "Jack Cook" => "jack@mcprohosting.com" }

  s.requires_arc     = true
  s.platform         = :ios, '8.2'
  s.source           = { :git => "https://github.com/WatchBeam/beam-client-swift.git" }
  s.source_files = 'Pod/Classes/**/*'

  # s.resource_bundles = {
  #   'BeamAPI' => ['Pod/Assets/*.png']
  # }

  s.dependency 'Starscream', '~> 1.1'
  s.dependency 'SwiftyJSON', '~> 2.3'
end
