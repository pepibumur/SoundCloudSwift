bootstrap:
	brew install carthage
	gem install cocoapods

dependencies:
	carthage update

build:
	set -o pipefail && xcodebuild build -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift iOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift OSX" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift tvOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild build -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift watchOS" ONLY_ACTIVE_ARCH=NO | xcpretty -c

test:
	set -o pipefail && xcodebuild test -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift iOS" -sdk iphonesimulator9.1 ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild test -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift OSX" ONLY_ACTIVE_ARCH=NO | xcpretty -c
