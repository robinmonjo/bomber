
# Game Description

Bomber is a 2D iOS game. The user plays with a character, lets call him Bomber. The goal is to draw a path that will allow Bomber to destroy all the targets, usin the available weapons.
The level is succeeded if all targets are killed and if Bomber has joined the goal end-point.

// insert a video here

# Technical description

This game is built using the [cocos2d](http://www.cocos2d-iphone.org/) for iPhone library. All the physics is managed by [Chipmunk](http://chipmunk-physics.net/) physic engine (the free version, included in cocos2d).

# Set up the dev environment

*Create a root directory. Clone the repository inside this root directory. This will create a folder *bomber*.

*Clone the cocos2d [repository](https://github.com/cocos2d/cocos2d-iphone). This will create a *cocos2d-iphone* folder.

*Create a folder named *deps*

At this point you should have

--root
	--bomber
	--cocos2d-iphone
	--deps

Create a symbolic link of *cocos2d-iphone* within the *deps* folder

ln -s cocos2d-iphone deps/

At this point you should have this

--root
	--bomber
	--cocos2d-iphone
	--deps
		--cocos2d-iphone #symlink

Open the xcode project (in the *bomber* folder). Set the build target to *Bomber*, then build and run.
