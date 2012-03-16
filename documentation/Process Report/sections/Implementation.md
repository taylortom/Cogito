**Implementation**

The progress you made, problems encountered, their solutions and the lessons learnt

- General notes about the code:
	- Header files/private interfaces
-	


















_**Game Component**_
		
**Code Structure/Features**

Before I could build any learning into my project, I first had to build the underlying game component which would run it. The game component of my project was ___. 

As I was using the Cocos2D engine, a lot of the very low-level functionality had been taken care of. For example, the direct OpenGL ES calls needed for loading and binding textures were all contained within the CCSprite class, making adding new textures as easy as initialising a CCSprite class. 

Although the very low-level functionality had been simplified by the engine, 

As I was building my game from the ground up (albeit with the help of the Cocos2D framework), I needed to take care of the fairly low-level features such as loading in the level assets, building the levels; to load in the levels and sprites

**OpenGL ES:** The Open Graphics Library for Embedded Systems (OpenGL ES) is a subset of the OpenGL 3D graphics API which targets embedded systems such as the Nintendo 3DS, the Sony Playstation 3, and devices running Apple's iOS and Google's Android operating systems.

**Cocos2D:** My decision to use the Cocos2D framework proved to be

The Cocos2D framework uses a hierarchical structure to manage the many components which make up a typical game. It uses the analogy of film production to make this easy to understand. At the highest level is the CCDirector class which, as one would expect, controls the running of each individual level in the game (known as CCScenes). Each scene consists of one or more  layers (CCLayers) which contain the actual game objects (for example the background image, the level terrain and the game characters). The game objects could take the form of CCSprites (at it's most basic terms, a sprite is an image displayed onscreen)

The Cocos2D framework is loaded via the AppDelegate singleton class, a class which deals with the basic running of the application; what should happen when launching the app, when the user closes the app, when the app is sent to the background etc.

In computer programming, a constant is an identifier whose associated value cannot typically be altered by the program during its execution.

**Singleton/Manager classes:** I make a lot of use of the singleton design pattern throughout my project to create various 'manager' classes to deal with the shared data in my system. A singleton class is a special kind of class which only has one instance; calling a singleton instance will always return the one instance of the class, regardless of which class called it. The benefit of using the singleton pattern is that you only need to store the data in one central location, which can then be accessed by any class anywhere in the program; provided that the access to the data is restricted to a single thread at a time (otherwise there would likely be concurrency issues with data corruption). For example, my LemmingManager class as its name suggests manages all of the lemming characters in the game. It hold the only list of the characters, and contains the functionality to add and remove lemmings among other things. Using the singleton 

Restricts the instantiation of a class to one object; useful when exactly one object is needed to coordinate actions across the system. When you want to ensure that no additional instances of the class are created accidentally.

**Levels:** When it came to designing how the levels would work in my game, I wanted something which was very flexible, in that I could easily add extra levels (or modify existing levels) with a minimal amount of work. The way that I decided to do his was to create a number of generic assets which I could re-use in each level. Things such as platforms, water hazards, trapdoors etc. This meant that when I wanted to add an additional level to the game, I could simply specify the positioning of these existing elements, rather than having to create new level assets per level. By using re-usable assets, not only was adding new levels a lot simpler, it also meant that I could drastically cut down on the amount of disk-space that my game needed.

To accompany the assets, I also needed some way to have some way to specify the layout of each level, as well as other level specific data. To accomplish this, I used the natively supported Property List (plist) file format. Plist files are simply XML files of dictionary objects; consisting of a key object (usually a string), and a 'value' object. One of the advantages to using the plist is that it's easily editable in any text editor. It also supports a variety of datatypes, such as strings, numbers (ints, floats, etc) and dates. You can also nest dictionaries inside each other for even more flexibility. 

I used one plist file to specify how many levels there were in my game, along with certain level-specific information such as difficulty, number of tool uses. I then created a plist file for each level, which stored the positions of each piece of terrain, as well as the type of the terrain, and in some cases whether the terrain piece was collide able (this was enabled by default, so was only included if the object was to be removed from collision detection). My game then loaded in the list of the levels, and each individual level plist. 

Initially, I planned to have levels of varying difficulty, with an option on the new game screen to allow the user to select a difficulty. However, I found it difficult to determine what an 'easy' level should be for example, and so the final game just assumes all of the levels are the same difficulty.

**Characters:**

**Menu System:**

**Basic Functionality:** Agent behaviour (non-AI), winning the game

**Constants:** I created a file to contain the constants used in my program (for example the framerate, the default font filename and the various rewards associated with reinforcement learning). Moving all of these variables into a single separate file means that Each constant in this file follows the standard naming convention for constants (i.e. starting with a "k"). This is a legacy feature from the pre-Mac OS X days, possibly back when the Mac OS was written mostly in Pascal. It's interesting that this convention is kept up, given that it doesn't follow the standard C convention of defining constants in capital letters. 

**Datatypes:** Similar to the constants file. Defines all of the datatypes/enums used in my game.

**Utils:** I created a Utils class with some useful static-access 'utility' methods which I was likely to want to use a lot in my game; functions such as random number generation, enumeration-to-string conversions, and timestamp generation. It made sense to create a separate class with all of these types of methods because it not only cut down on the amount of code that I had to write, but also meant that were I to find a bug in my random number generation code for example, I would only need to fix the bug in one place, rather than having to go and search every source file for occurrences of the broken code. 
		
**Deviance From The Design**

Overall, I think I adhered to my original designs pretty 

**Performance Optimisations**

As already mentioned, Cocos2D offers a variety of performance optimisations specifically tailored for developing games. One such optimisation is the 'CCSpriteBatchNode'. It is not uncommon to experience poor performance when there are a large number of objects onscreen at once. 

For each sprite, OpenGL ES must first bind to the texture, and then render the sprite. As more and more sprites are added to the screen, it isn't difficult to see that the number of calls to OpenGL will steeply increase too, with every call costing a few CPU cycles. It is basic common sense to see that the game will run faster the fewer calls to OpenGL are made. 

The CCSpriteBatchNode is a Cocos2D class which has been created to help with this problem. The CCSpriteBatchNode works by taking a single texture which contains all of the textures needed by the current scene (called a texture atlas, SEE DIAGRAM), and sends all of the images for rendering to OpenGL at once, rather than individually. This essentially reduces the number of bind calls needed from O(n) to O(1) (in Big-O notation). Using texture atlases also cuts down on the amount of memory needed to store each individual image. In some version of the iOS, textures were required to be stored in sizes of the poet of two (64, 128, 512 etc.). This meant that the textures would often have a lot of unnecessary white space around the image (SEE DIAGRAM), which obviously takes up extra memory; something which even with todays devices is not a commodity. An additional optimisation which can be made regarding the textures is to use the 	compressed PVR CCZ file format. In addition to saving disk space in terms of the actual size of the image, the PVR CCZ format is supported natively by the iPhone's GPU, and can be loaded directly onto the GPU without the need for conversion.

Aside from the performance optimisations offered by Cocos2D, I also did a few other things to ensure that my program ran as efficiently as possible.

**Random number generation:** Although it may not seem like a likely source for a performance bottleneck, the random number generator (RNG) I chose to use could have a noticeable impact on performance. Based on some very quick tests carried out by a poster on the official Cocos2D forums (http://www.cocos2d-iphone.org/forum/topic/11290), I was surprised to see the difference in speed between different RNGs. SEE TABLE. Typically, the RNG I had chosen to use (arc4Rand) was by far the slowest method tested. Based on the tests carried out, I instead decided to use the CCRANDOM_0_1 function, which was shown to be 5 times quicker. Although the tests carried out on the forum were tested by performing 5 million iterations of the algorithm, far more than I would ever need to use, every performance enhancement helps.
		
**Problems Faced** 

General problems learning the language, differences between languages learnt already. Can only add objects to an array - need to use [NSNull null]

An array can contain only objects (same as Java, but Java hides this from the user by wrapping core types in objects). Similar fix in Objective-C, but have to do it manually (e.g. [NSNumber numberWithInt:1]).

**Memory management:** Something which I found particularly tricky about using Objective-C over a language like Java was the memory management. It isn't until you start to learn another language that you realise how much the Java runtime shields the programmer from the low-level bugs associated with memory management thanks to the garbage collector. In Java, memory is reserved for an object simply by using the 'new' keyword, and memory is automatically released when that object goes out of scope and is no longer accessible. This could be by the programmer setting the object to null. At this point, the garbage collector reclaims the memory.

On the other hand, languages such as Objective-C  require manual memory management, meaning that every object created needs to be manually released by the programmer when finished. 

The big problem with memory leaks is that they can often go undetected, only to cause the program to unexpectedly crash later on down the line. For this reason, they can be notoriously difficult to track down. 

I discovered a particularly nasty bug in my game's update method for example, which is called every frame, whereby I was allocating an array to hold all of the game objects, but failing to release the memory at the end of the method. 

I discovered that I had made this very error in my game's main update method (which is called 60 times per second). Using Instruments, I found that this relatively minor error was losing a lot of memory, and causing the game to drop 15 frames per second after about 15 minutes. Although this may not seem like much, it had a knock-on effect on my game timer, which determined the game time by counting each frame. Therefore, losing 15fps meant that I was essentially losing one second in every five. 

Carrying out this project really taught me the importance of keeping a close eye on what memory you're allocating and where you're releasing it. What may at first seem like a negligible memory leak can build up over time, and combined with other similarly small memory leaks, can cause big problems with your programs performance. I would even go so far as to say that these smaller memory leaks are even more troublesome than the bigger ones, as they are much harder to track down, and are often more widely spread, and therefore more difficult to fix.

Xcode comes with a very useful set of performance analysis tools called 'Instruments' which can be used to establish any memory-related or runtime issues, such as memory leaks etc.

Another problem I frequently came across which couldn't happen in Java was that of initialised variables. Whereas in Java, whenever you declare a new variable, it's automatically initialised with whatever the default value may be, you get no such privilege in Objective-C. When you declare a variable in Objective-C, it stays uninitialised until you specifically set it. This caused me the biggest problems with arrays; trying to access an uninitialised array wouldn't cause a compiler error, but would cause a crash at runtime.

_**AI**_

**Code Structure/Features**

**Deviance From The Design**
	
**Performance Optimisations**

**Problems Faced**