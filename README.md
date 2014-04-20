TridentSandbox
==============

An In-Browser Scripting IDE for HTML5/Javascript

This project is scripting environment which runs in browser.  It can run in several modes: 
1) : Offline served up from your local file system
2) : Hosted on a webserver
3) : AppCached - Similar to #2 except the client caches the entire website and can run offline.  For internet explorer, this allows local storage and indexeddb which would not otherwise be available when running from your local filesystem.

This application is similar to jsfiddle and can be somewhat used as such, however this project aims to turn this scripting environment into a framework/ecosystem of its own.  Programs which you create can be exported into a single .PRG file which can be loaded on other TridentSandbox environments (on possibly different operating systems and browsers) to become a somewhat useful application engine.

Currently the environment allows the user to code in single Markup and Script editors... CSS was not included for screen real estate purposes but might be added later.  As a workaround STYLES seem to work when placed into the markup area but this is likely bad practice.

This project aims to utilize the newer HTML 5 interfaces such as File API, Fullscreen API, LocalStorage/IndexedDB as well as newer ECMA 5/6 constructs to fully explore and experiment with their integration into a sanboxed ecosystem. 

As its name somewhat indicates, its original purpose was specifically for Internet Explorer 10/11.  I have tested this on Firefox and utilize polyfill FileSaver.js to handle saving of programs as well as feature detection for Fullscreen API.  Firefox does not seem to allow you to save to a specific location, so you might want to store your own programs in local storage.  Chrome or other browsers can try it out on their own browsers to see how well it works.  Although i do not intend to test other browsers on my own, it would be nice to support as many as can be possible. 

Additional capabilities above and beyond a typical 'fiddle' type website include are that i provide a simple javascript API which you can use to leverage and manipulate the enviroment for more functionality.  For example i have API calls for playing sounds (using HTML 5 audio), controlling environment layout (maximizing output area, fullscreen, logging text), and (where available) Trident Sandbox creates a key-value database in indexed db for storing programs and user keys based on an app/key/value selection (where app could be their prg name).

Within the folder structure i am including some useful third party libraries and some sample .prg files to load and experiment with.  There are some samples which may represent functionality i wish to embed within the main htm file (possibly as jQuery dialogs), to support inspection of the TridentDB (kvp built using indexedDb) or other system level configuration / diagnostics.

This sandboxed ide currently does not utilize iframes, it functions more like a Single Page Application which builds up and tears down HTML dom elements (divs) within an Output area of the main page.  It is currently up to your program to implement a cleanup callback to disable any intervals or cleanup variables... this is covered in the integrated html help pages.
