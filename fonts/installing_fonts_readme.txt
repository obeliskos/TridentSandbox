NOTE : I am able to include custom fonts because these truetype fonts are included in my distribution.

You can include your own fonts as well but they need to be registered with the main page (TridentSandbox.htm), so adding and registering
your own fonts means running your PRG file on other computers will not see that font and will fall back to a different font.
-----------------
The heorot.ttf font has already been 'registered' with the TridentSandbox.htm page within a <STYLE> tag located near the top of the page.

If you wish to add the others, add your own, or add other true type fonts downloaded from the web you will want to place them in this folder
and register them in the style section, similarly to the heorot @font-face definition.  At that point, they can be used in any UI elements
in you own programs by setting its style="font-family:'heorot'" (substitute your own font face name).

This particular heorot font was googled quicky and downloaded from this (random) website :
http://www.1001freefonts.com/

Or just google free truetype fonts