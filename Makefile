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

doc:
	bundle exec jazzy \
	--output Documentation \
	--readme README.md \
	--module-version 1.0.0 \
	--min-acl public \
	--author @pepibumur \
	--author_url http://github.com/pepibumur \
	--module SoundCloudSwift \
	--github_url https://github.com/pepibumur/soundcloudswift

test:
	set -o pipefail && xcodebuild test -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift iOS" -sdk iphonesimulator9.1 ONLY_ACTIVE_ARCH=NO | xcpretty -c
	set -o pipefail && xcodebuild test -project SoundCloudSwift.xcodeproj -scheme "SoundCloudSwift OSX" ONLY_ACTIVE_ARCH=NO | xcpretty -c
