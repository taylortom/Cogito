Choice of Tools [Background Research]

Although it may seem a fairly trivial task at first, choosing the right tools to develop my project was not an easy job; I had to make sure that the applications and engines/code libraries that I chose would be suitable for their intended purpose before I started any serious development, as trying to switch mid-way through the development process would undoubtably cause big problems were I to try and migrate the existing code to use other tools/libraries.

The first, and arguably the biggest decision I had to make was which language I was going to develop my project in. My choice of language would not only have a big influence on the performance (and so the scale/features I would develop), but also the hardware that my game would run on.  

I initially planned to develop my project in Java. I felt that Java was an appropriate choice for a couple of reasons: the first and foremost being that I was already comfortable using the language, as it had been taught in several modules I had studied. Secondly, I was attracted to the cross-platform nature of Java; not only could I develop my application to run on the Windows, Mac OS X and Linux platforms, but it could also be embedded in an applet and run in a web-browser. This meant that collecting testing data would be much easier, as I could have the data sent to a central database and processed. In addition, the actual testing process itself would be much easier due to the fact that my product would be available to all desktop users, as opposed to limiting the user base to a single platform.

After some initial research, I found the JMonkey engine (JME); a 3D game engine written in Java with some pretty nice features: a nice IDE based on the popular NetBeans, asset management, integrated GUI elements, applet integration and networking to mention a few. 

Before deciding on Java/JME as my tools of choice, I had a play around with the IDE and did a few tests. The first think I noted about the engine, was that it was overly complex for my needs. This isn't necessarily a fault of JME or Java, but rather of my choice to look at 3D game engines in general. I had no need for the more advanced features such as complex physics, lighting, texturing and materials, animation, cameras etc. These features were completely overkill for my needs; even setting up a basic side-on view took a considerable amount of code, which involved setting up cameras, loading 3D models etc. None of which were really necessary for my project. In addition, I didn't feel that 3D particularly benefitted me from an aesthetic point of view. Additionally, I also had a few issues with a low framerate when adding many objects to the scene. Although this was likely due to errors with my implementation rather than the engine itself, it highlighted to me the problems with developing in Java, and its lack of any memory management - at least from the point of view of the programmer. I have also experienced similar performance issues when using the Swing interface bundled with Java which is notoriously poor from a performance perspective. Due to these points, I decided against trying to use a 3D engine and programming in Java, and instead began to research 2D game engines.

My research eventually led me to Cocos2D: a popular cross-platform 2D game engine originally written in Python, but having since been ported to C++, JavaScript and Objective-C, and is available for desktop platforms (Windows, Linux and Mac OS X) as well as mobile (iOS and Android). This opened up the possibility of developing my game for a mobile platform; something which greatly interests me (although admittedly, the JME does offer Android support).

I felt that Cocos2D was particularly well suited to my project as first and foremost, it is a well-established engine optimised for developing 2D games, with asset loaders, particle systems, and scene management to name a few features. It also comes bundled with two popular physics engines (Box2D and Chipmunk), which were available for my use. Another point worth noting is that being a 2D engine, Cocos2D already has a thriving community of developers with experience making 2D games, whereas the JME is intended for 3D games, and as such, there was a lot less documentation for 2D games.

Another benefit to using the Cocos2D engine is that it comes with libraries of code specifically optimised for games. For example, the engine comes with an alternative collection named 'CCArray' which is essentially an optimised version of the default NSArray class. 

After testing out a few example apps, I decided that Cocos2D would be suitable for my needs. 

I decided to develop my project for the iPhone, so would need to learn Objective-C; a challenge I was willing to accept. 

One of the main benefits to using Objective-C over Java is that it offers memory management, and so affords the developer much more control over their application. Although this may not be so much of an issue with modern desktop systems, the amount of available memory in a mobile environment is still fairly limited. Objective-C is also comparable to C++ in terms of runtime 'speed', due to the fact that Objective-C can be seen as really C (due to the fact that Objective-C is a strict subset of C) so any 'heavy lifting' code can be written in C to squeeze out the maximum performance. Objective-C also allows the developer to write code in C++ (called Objective-C++) if need be; something that would be necessary had I chosen to utilise the Box2D physics engine.

Another benefit to using Objective-C is having the option to use Apple's Xcode as a development environment, as well as the Instruments performance profiling tools to get detailed analysis of the program's runtime performance.

Asset Production

Looking past the code, I also needed to create a variety of assets for my game: backgrounds, character sprites, menu items, fonts etc. COCOS2D SUPPORTED FILE FORMATS. 

For the graphical assets, I used an image manipulation program called Pixelmator[WEBSITE] which exports to the PNG image format which I would be using for the majority of my game's assets. 

Sprite batch node: In order to utilise a performance optimisation feature of the Cocos2D engine called the sprite batch node I needed to create texture atlass or sprite sheets, which contained the images I would be using in my game. BENEFITS - why not use for backgrounds etc.

For the fonts, I used a program called bmGlyph[WEBSITE], which has been specifically developed for use with game engines that support the FNT file format.

Version Control

Using some form of version control system is a necessity in modern software development; it provides an easy way for multiple developers to collaborate on a single project (or even a single file) without causing file corruption. It is an invaluable tool for modern software development teams where it is not uncommon for developers to be in different cities or even continents. It also tracks all changes made throughout the development of the project. This is perhaps the most useful function of any version control systems as it not only allows the developers to see exactly what was changed (and by whom) in a project's history, but also means that were a mistake made, the project could easily reverted to an earlier state. Although I'm unlikely to experience any problems with file corruption as I'm the only one who will be contributing to the code-base, using a version control system still provides an incredibly useful way for me to not only track the progress of my project, but also as a way to incrementally back-up my project to ensure that any data loss is recoverable.

There are a variety of different source control systems available, such as CVS Subversion, Mercurial and Git. I decided to use Git as the version control system for my project for a couple of reasons. The first reason being that it is widely supported by many IDEs and other version control management software, with a number of services offering free Git hosting. I also generally prefer Distributed Version Control Systems (DVCS) as opposed to centralised systems for the reason that I like the freedom that DCVS systems give you in terms of being able to work on a project without the need for an internet connection. I also feel that DVCS systems provide more security in that each user has a backup of the entire system. However, this is not necessarily a benefit, as it could take up an inordinate amount of storage space were I working with many binary files (for example Adobe Flash files). In this case, using a DVCS would be unsuitable.

The Git version control system is actually very simple; it tracks all of the files in a project (known as the 'tree'), with each change submitted to the system (called a 'commit') consisting of a snapshot of the state of each file in the tree at that point in time. Specific commits can be 'tagged' to mark their significance; a feature which is normally used to mark specific releases of a project. Part of the reason Git is so efficient is that it uses an encoded string called a SHA hash (essentially a 'fingerprint' of the file) to determine whether or not a file has been changed; checking just requires comparing the local SHA to the remote SHA. 

I will be using a Git server hosted by GitHub to store the source code and documentation for my project. 

Project Management

To manage the progress of my project, I used a web-based application called ProjectPier which I installed on my web server so could be accessed from anywhere.

Using this system, I split my project into a number of 'task-lists' for each component in my project's development; for example: asset production, game development, AI development, testing, etc. I also added milestones to my project to mark specific targets that I wanted to achieve by certain dates.

Using this system, I could add individual tasks that needed to be completed, deadlines (or 'milestones') to mark specific targets in the development of my project. I could also use the system to create a wiki for my project containing useful information. 
