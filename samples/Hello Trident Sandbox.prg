{
  "progName": "Hello Trident Sandbox",
  "htmlText": "<img onmouseover=\"this.style.opacity=0.6;\" onmouseout=\"this.style.opacity=1.0;\" onclick=\"RestoreLayout()\" src=\"images_ide/metro-back.png\"/>\n<h3>Welcome to Trident Sandbox</h3>\n\n<p style=\"font-family:Sans Serif\">Trident Sandbox was developed to turn Internet Explorer into a scripting IDE.  It is named \nafter the <a href=\"http://en.wikipedia.org/wiki/Trident_(layout_engine)\" target=\"_blank\">Trident</a> rendering engine within Internet Explorer \nbrowsers.  Internet Explorer 11 uses Trident engine version 7 \n(IE 10 uses Trident 6).  Trident 6 added the HTML 5 <a href=\"http://www.html5rocks.com/en/tutorials/file/dndfiles/\" target=\"_blank\">File API</a> \nwhich allows loading and saving files to local filesystem. \nTrident 7 added HTML 5 Fullscreen API and WebGL (among other changes). These capabilities along with a myriad of \nopen source third-party javascript libraries allow the interactive creation of HTML 5 based applications.  Although it was inspired \nby similar online web tools like <a href=\"http://jsfiddle.net/\" target=\"_blank\">jsfiddle</a>, Trident Sandbox is intended to be \nprimarily run from the local filesystem.</p>\n\n\n<p style=\"font-family:Sans Serif\">There is a pattern of web development called Single Page Application (SPA) \nin which you attempt to create a web page that changes dynamically vs going from page to page to page.  This \npattern most closely resembles what goes on in a Trident Sandbox app... you are still on the same page when \nyou run different programs, you are just dynamically building up and tearing down DOM elements from the \nhierarchical Document Object Model.  Your applications are not sandboxed because of the Trident Sandbox \nmain page, they are sandboxed because of Internet Explorer.  You can't accidentally change the main page's \ncontents on disk but you can change how it looks/act in the current load of that page.  Because of this you \nmay and probably will accidentally mess up the main page from time to time, in which case a reload of the main \npage will restore to a fresh slate.</p>\n\n<p style=\"font-family:Sans Serif\">There are two versions of the TridentSandbox html file, the only difference \n  being that the main version uses the CodeMirror code editors and the other version uses the EditArea component. \nCodeMirror was made the default choice because it is visually more stable and less prone to glitches.  The EditArea \n  control was written in 2010 and no updates have been made since, so CodeMirror is probably best for future proofing \n  the Trident Sandbox app itself.  The EditArea controls do have nicer capabilities though so I will keep a version which \n  uses those.  For both versions, the top editor (Markup) is for setting \nup the HTML to be displayed on the Main Output and the script will execute against that Markup.  Any code \noutside a function will execute immediately when you Run your program.  You can 'fullscreen' the development \narea if you want to make maximum use of space for development.</p>\n\n<p style=\"font-family:Sans Serif\">The User Area where the (currently) three tabs : Main Output, Log (HTML), \nand Log (Text) are located is an attempt to create a flexible enough environment to handle simple programs \nas well as more complicated ones.  In theory the main output would be used for mostly static HTML closely \nresembling what is defined in your Markup area.  The Log (HTML) can be used either as a log screen \n(supporting HTML styling) or you can use it for your own dynamically rendered web pages.  You can dynamically \ncreate textboxes, list boxes, buttons, canvas objects, media object, dump a large chart there, etc.  The Log (Text) tab is where you \nmight log pure text messages... it contains a scrollable textarea and has easy API interface.</p>\n\n<p style=\"font-family:Sans Serif\">To help simplify your ability to manipulate the sandbox, i have provided \na set of API functions, user elements, and variables which can help you control the environment.</p>\n\n<table width=\"100%\">\n  <tr>\n    <th>Function Name</th>\n    <th>Description</th>\n  </tr>\n  <tr>\n    <td>API_ClearOutput()</td>\n    <td>This clears out the contents of all output tabs, hides the user filepicker, and sets the active tab to Main Output.</td>\n  </tr>\n  <tr>\n    <td>API_LogMain(msg)</td>\n    <td>Easy way to log html text to the Main Output</td>\n  </tr>\n  <tr>\n    <td>API_ClearMain()</td>\n    <td>this clears out the contents of just the Main Output tab</td>\n  </tr>\n  <tr>\n    <td>API_LogHtml(msg)</td>\n    <td>easy way to log html text to the HTML Log</td>\n  </tr>\n  <tr>\n    <td>API_ClearHtmlLog()</td>\n    <td>clears the contents of the Log (HTML) tab</td>\n  </tr>\n  <tr>\n    <td>API_LogMessage(msg)</td>\n    <td>log text to the Log (Text) tab</td>\n  </tr>\n  <tr>\n    <td>API_ClearLog()</td>\n    <td>clear contents of the Log (Text) tab</td>\n  </tr>\n  <tr>\n    <td>API_SetBackgroundColor(colorCode)</td>\n    <td>Sets the background color for Main Output tab. Color Code is string such as \"#cca\"</td>\n  <tr>\n    <td>API_SetActiveTab(tabId)</td>\n    <td>allows you to switch active tab programmatically. tabId is zero-based... 0 is Main, 1 is Log (HTML), or 2 is Log (Text)</td>\n  </tr>\n  <tr>\n    <td>API_MetalFullscreen()</td>\n    <td>equivalent to pressing the 'Fullscreen Dev' button</td>\n  </tr>\n  <tr>\n    <td>API_UserFullscreen()</td>\n    <td>this command zooms the users Output tabs fullscreen.</td>\n  </tr>\n  <tr>\n    <td>API_UserFullscreenExit()</td>\n    <td>this command un-zooms an active fullscreen.</td>\n  </tr>\n  <tr>\n    <td>API_ShowLoad()</td>\n    <td>Displays a file loader control withing the user area.  See more info below.</td>\n  </tr>\n  <tr>\n    <td>API_SaveTextFile(fileName, saveString)</td>\n    <td>allows the user to easily save some text to a file.  This will trigger a download.</td>\n  </tr>\n  <tr>\n    <td>API_SetWindowMode(mode)</td>\n    <td>pass in 1 for Code only view, 2 for 50/50 split, or 3 for Output Only view</td>\n  </tr>\n  <tr>\n    <td>API_SetToolbarMode(showCaption, showLoader, showDevToolbar)</td>\n    <td>programmatically show/hide the three areas at the top of the screen.  \nIf you hide the dev toolbar you should save any pending changes your program first, and provide a means within your program of getting \n      them back!</td>\n  </tr>\n  <tr>\n    <td></td>\n    <td></td>\n  </tr>\n</table>\n\n<p style=\"font-family:Sans Serif\">When loading files with API_ShowLoad you have two options for 'receiving' the loaded text.  You can either \nimplement a function called EVT_UserLoadCallback(filestring) to perform action immediately after load completes, or you can just manually \ncheck for the output of the last load in a variable called VAR_UserFileValue.</p>\n\n<p style=\"font-family:Sans Serif\">It is possible to debug your programs but its another window to open in already crowded user interface.  You can use the Internet Explorer \nscript debugger to debug your scripts by placing a javascript command 'debugger;' (no quotes) into a line of \ncode in your script and then pressing F12 to open the Internet Explorer tools and find the tab with a bug icon \npicture on it to enable the script debugger... leaving the script debugger window open attempt your run your \nprogram and when it hits that line of code you can inspect variables by hovering over them.</p>\n\n<p style=\"font-family:Sans Serif\">Trident Sandbox comes with a number of open source third-party javascript libraries which you can use within \nyour programs. These libraries (as of Trident Sandbox version 1.1) include : </p>\n\n<ul>\n\t<li><a href=\"http://jquery.com/\" target=\"_blank\">jQuery</a> : like a query language for the html DOM.  It is also needed by most of the other libraries.</li>\n\t<li><a href=\"https://jqueryui.com/\" target=\"_blank\">jQuery UI</a> : provides some common controls like datepickers, dialog boxes, etc and supports themes.</li>\n\t<li><a href=\"http://www.trirand.com/blog/\" target=\"_blank\">jqGrid</a> : a popular versatile grid control</li>\n\t<li><a href=\"http://www.jqplot.com/\" target=\"_blank\">jqPlot</a> : awesome charting library</li>\n\t<li><a href=\"http://fabien-d.github.io/alertify.js/\" target=\"_blank\">Alertify.JS</a> : Simple way of dispaying message boxes or notifications. </li>\n\t<li><a href=\"https://code.google.com/p/crypto-js/\" target=\"_blank\">Crypto.JS</a> : Simple encryption capabilities</li>\n\t<li><a href=\"http://code.google.com/p/dynatree/\" target=\"_blank\">Dynatree</a> : a hierarchical tree control</li>\n\t<li><a href=\"http://arshaw.com/fullcalendar/\" target=\"_blank\">FullCalendar</a> : in case you need an advanced calendar control (for simple calendar just use jQuery UI datepicker)</li>\n\t<li><a href=\"http://highcharttable.org/\" target=\"_blank\">HighchartTable</a> : Easy way to convert html table into chart.</li>\n\t<li><a href=\"http://threejs.org/\" target=\"_blank\">Three.JS</a> : Bare minimum distribution included, download the full zip file from their website.  Allows higher level use of WebGL.</li>\n  \t<li><a href=\"http://lokijs.org\" target=\"_blank\">Loki.JS</a> : A lightweight javascript document oriented database</li>\n</ul>\n\n<p style=\"font-family:Sans Serif\">If you need to add other javascript libraries you can put them alongside the others... in the libraries subfolder. \nThen edit the TridentSandbox.htm file and add script include tags (or stylesheet links) similar to the other libraries.\n</p>\n\n<img onmouseover=\"this.style.opacity=0.6;\" onmouseout=\"this.style.opacity=1.0;\" onclick=\"RestoreLayout()\" src=\"images_ide/metro-back.png\"/>\n",
  "scriptText": "API_SetBackgroundColor(\"#FFFFdd\");\nAPI_SetToolbarMode(false, false, false);\nAPI_SetWindowMode(3);\n\nalertify.success(\"Ok so maybe this is a bit longer than your usual hello world app :)\");\n\nfunction RestoreLayout() {\n\tAPI_SetToolbarMode(true, true, true);\n\tAPI_SetWindowMode(2);\n}"
}