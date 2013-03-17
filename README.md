

Set up the dev environment

Create a root directory. Clone the repository inside this root directory. This will create a folder bomber.

Clone the cocos2d repository. This will create a cocos2d folder.

Create a folder named deps

At this point you should have

--root
	--bomber
	--cocos2d-iphone
	--deps

Create a symbolic link of cocos2d-iphone

ln -s cocos2d-iphone deps/

At this point you should have this

--root
	--bomber
	--cocos2d-iphone
	--deps
		--cocos2d-iphone #symlink

Open the xcode project (in the bomber folder). Set the build target to Bomber, then build and run.
