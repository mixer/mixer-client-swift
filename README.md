# MixerAPI

[![Build Status](https://travis-ci.org/mixer/mixer-client-swift.svg)](https://travis-ci.org/mixer/mixer-client-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MixerAPI.svg)](https://cocoapods.org/pods/MixerAPI)

This is a client library for [Mixer](https://dev.mixer.com) written in Swift.

## Features

- Authenticate with Mixer and manage your user session
- Retrieve full data about channels, users, and other resources
- Send and receive packets through the chat and Interactive servers
- [Complete Documentation](http://cocoadocs.org/docsets/MixerAPI/)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.2+ / tvOS 9.0+ (macOS and watchOS coming soon)
- Xcode 7.3+

## Installation

### CocoaPods

You can add MixerAPI to your project by adding it to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

Because MixerAPI is written in Swift, you will need to add the `use_frameworks!` flag in your Podfile.

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'MixerAPI', '~> 1.6'
end
```

## Usage

### Retrieving Channel Data

```swift
import MixerAPI

MixerClient.sharedClient.channels.getChannelWithId(252) { (channel, error) in
    guard let channel = channel else {
        return
    }

    print("\(channel.token) has \(channel.viewersCurrent) viewers.")
}
```

### Connecting to Chat

```swift
import MixerAPI

class ChatReceiver: NSObject, ChatClientDelegate {

    // Connect to the channel with an id of 252
    func start() {
        let client = ChatClient(delegate: self)
        client.joinChannel(252)
    }

    // Called when a connection is made to the chat server
    func chatDidConnect() {
        print("connected to chat")
    }

    // Called when the chat server sent us a packet
    func chatReceivedPacket(packet: Packet) {
        if let packet = packet as? MessagePacket {
            print("message received: \(packet.messageText)")
        }
    }

    // Called when there is a new viewer count available
    func updateWithViewers(viewers: Int) {
        print("\(viewers) are watching")
    }
}
```

## License

MixerAPI is available under the MIT license. See the LICENSE file for more info.
