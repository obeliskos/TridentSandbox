# Trident Sandbox

## An In-Browser Scripting IDE for HTML5/Javascript

![trident preview](http://www.obeliskos.com/surface/trident_sandbox_210.png)

This project is an offline browser-app development environment which itself runs within a web browser.  It utilizes HTML 5 appcache functionality to allow offline use.

You can use this environment by visiting http://www.obeliskos.com/TridentSandbox

Visiting this page will automatically download the site (about 8 megs) into a web browser 'application cache' (you may need to approve storage), so that the site continues to work when run offline.  Diagnostic messages should indicate 'downloading' and 'idle' when completely cached.  You can bookmark the page to avoid erasing the appcache when you clean internet files.

Alternatively, Node Webkit support is provided so you may run the project directory as a node webkit application.  This method allows you to use all Trident Sandbox functionality in addition to allowing use of node libraries and permissions.

This environment provides an IDE for creating and editing apps which run within your browser.  Those apps may utilize the TridentSandbox javascript API library and included third party javascript libraries and can be saved to the browser's indexed db storage (via the environment's TridentDatabase).  The environment provides Markup and Script editors... style tags should go in the HTML area.

This project aims to utilize the newer HTML 5 interfaces such as File API, Fullscreen API, LocalStorage/IndexedDB as well as newer ECMA 5/6 constructs to fully explore and experiment with their integration into a sandboxed app ecosystem. 

This project is a pure HTML5/Javascript project.  It's support of Visual Studio is optional, allowing for intellisense and web bundles.  On other environments, if you need to rebuild the web bundles, you may use the gulp bundling via :

```
npm install
npm run rebundle
```

Trident Sandbox makes use of its own app/key/value indexeddb object store (when available) for storing programs, library units, and user data.  This 'Trident Database' now comes with indexedDB, web service, and in-memory adapters... if you want to use another means of storage, you are able to write your own custom adapter as long as it supports the expected adapter interface.


Copyright (c) 2015, David Easterday (admin@obeliskos.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
