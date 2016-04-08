# Introduction #

This code, like its corresponding Android equivalent, is meant to serve as a reference implementation for creating a mobile client capable of submitting to a specific YouTube Direct instance. As such, it makes sense to ensure that you have YouTube Direct configured and running on App Engine first. The [Getting Started guide](http://code.google.com/p/youtube-direct/wiki/GettingStarted) should assist there.


# Working with the iOS codebase #

Start by checking out the latest SVN trunk release of this project's code, following the [instructions provided](http://code.google.com/p/ytd-iphone/source/checkout).

The [read me](http://code.google.com/p/ytd-iphone/source/browse/trunk/YouTubeDirect/ReadMe.txt) file contains important instructions on some additional libraries that need to be downloaded from separate open source projects before you can build this code. It also contains details on how to configure the code's properties to point to your specific YouTube Direct instance.

The expectation is that developers will take the core YouTube Direct submission functionality in this project and customize the user experience to match the brand associated with the YouTube Direct instance. The code can be released as a standalone application or you can incorporate it into a larger, existing iOS application.