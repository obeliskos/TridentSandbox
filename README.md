Trident Sandbox
==============

An In-Browser Scripting IDE for HTML5/Javascript

![trident preview](http://obeliskos.com/surface/trident_sandbox_182.png)

This project is scripting environment which runs within a web browser.  It can run in several modes: 
1) : Offline served up from your local file system
2) : Hosted on a webserver
3) : AppCached - Similar to #2 except the client caches the entire website and can run offline.  For internet explorer, this allows local storage and indexeddb which would not otherwise be available when running from your local filesystem. 

To test out this application you can Download the zip to your local filesystem.  If you are on Windows 8/8.1/RT you should right click the downloaded zip file and unblock it before extracting it.  To run TridentSandbox you can then double click or drag and drop the TridentSandbox.htm file into your web browser, enable scripts, and bookmark for easier access.

You can also use my AppCache site by visiting http://www.obeliskos.com/TridentSandbox ... this will automatically download the site (about 6 megs) into an 'application cache' so that the site continues to work when run offline.  Pay attention to the AppCache diagnostic messages (top left of page) to see the appcache status... is should say 'downloading' and then 'idle' when completely cached.  If it says idle you should be able to go offline and continue to use (bookmark the page to avoid erasing the appcache when you clean internet files).

This application is similar to jsfiddle and can be somewhat used as such, however this project aims to turn this scripting environment into a framework/ecosystem of its own.  Programs which you create can be exported into a single .PRG file which can be loaded on other TridentSandbox environments (on possibly different operating systems and browsers) to become a somewhat useful application engine.

Currently the environment allows the user to code in single Markup and Script editors... CSS was not included for screen real estate purposes but might be added later.  As a workaround you might embed STYLE tags into the markup area.

This project aims to utilize the newer HTML 5 interfaces such as File API, Fullscreen API, LocalStorage/IndexedDB as well as newer ECMA 5/6 constructs to fully explore and experiment with their integration into a sanboxed ecosystem. 

As its name somewhat indicates, its original purpose was specifically for Internet Explorer 10/11.  I have tested this on Firefox and utilize polyfill FileSaver.js to handle saving of programs as well as feature detection for Fullscreen API.  Firefox does not seem to allow you to save to a specific location, so you might want to store your own programs in local storage.  Chrome or other browsers can try it out on their own browsers to see how well it works.  Although i do not intend to test other browsers on my own, it would be nice to support as many as can be possible. 

Additional capabilities above and beyond a typical 'fiddle' type website include are that i provide a simple javascript API which you can use to leverage and manipulate the enviroment for more functionality.  For example i have API calls for playing sounds (using HTML 5 audio), controlling environment layout (maximizing output area, fullscreen, logging text), and (where available) Trident Sandbox creates an app-key-value database in indexed db for storing programs and user keys based on an app/key/value selection (where app could be their prg name). 

Within the folder structure i am including some useful third party libraries and some sample .prg files to load and experiment with.  There are some samples which may represent functionality i wish to embed within the main htm file (possibly as jQuery dialogs), to support inspection of the TridentDB (kvp built using indexedDb) or other system level configuration / diagnostics.

This sandboxed ide currently does not utilize iframes, it functions more like a Single Page Application which builds up and tears down HTML dom elements (divs) within an Output area of the main page.  
