// Creating a reusable 'ListView' Class via a function definition
// At the end of this TridentListView definition, we actually instance it 
// and call into it to invoke its functionality 

// Pass in the DOM UL element name, and an optional callback to call whenever selection changes
// You can also just manually get the selectedId value on the object the get selection
function TridentList(listId, userCallback) {
	this.listSettings = {
		listElementId : listId,
		selectedId : null,
    	clickCallback : userCallback,
		bright: false
    };
    
	this.makeBright = function() {
		this.listSettings.bright = true;
		
		$("#" + this.listSettings.listElementId).attr("class", "tlist-bright");
		$("#" + this.listSettings.listElementId).find("div.tlistitem").attr("class", "tlistitem-bright");
		$("#" + this.listSettings.listElementId).find("div.tlistitem-selected").attr("class", "tlistitem-selected-bright");
		$("#" + this.listSettings.listElementId).find("span.tlistitem-caption").attr("class", "tlistitem-caption-bright");
		$("#" + this.listSettings.listElementId).find("span.tlistitem-description").attr("class", "tlistitem-description-bright");
	}
	
	this.setCaptionColor = function(colorCode) {
		$("#" + this.listSettings.listElementId).find("span.tlistitem-caption").css("color", colorCode);
		$("#" + this.listSettings.listElementId).find("span.tlistitem-caption-bright").css("color", colorCode);
	}
	
	this.clearList = function() {
		$("#" + this.listSettings.listElementId).empty(); 
	};

	this.addListItem = function(id, caption, description) {
		var captionSpan = document.createElement("span");
		
		if (this.listSettings.bright) captionSpan.className = "tlistitem-caption-bright";
    	else captionSpan.className = "tlistitem-caption";
		
    	$(captionSpan).text(caption);
    
    	var descSpan = document.createElement("span");

		if (this.listSettings.bright) descSpan.className = "tlistitem-description-bright";
    	else descSpan.className = "tlistitem-description";
		
    	if (description) $(descSpan).text(description);
    
    	var listitemDiv = document.createElement("div");

		if (this.listSettings.bright) listitemDiv.className = "tlistitem-bright";
    	else listitemDiv.className = "tlistitem";
		
		$(listitemDiv).attr("aria-describedby", id);
    	listitemDiv.appendChild(captionSpan);
    	listitemDiv.appendChild(document.createElement("br"));
    	listitemDiv.appendChild(descSpan);
		listitemDiv.onclick = (function(id, settings) {
			return function() { 
				if (settings.bright) {
					$("#" + settings.listElementId).find("div.tlistitem-selected-bright").attr("class", "tlistitem-bright");
					this.className = "tlistitem-selected-bright";
				}
				else {
					$("#" + settings.listElementId).find("div.tlistitem-selected").attr("class", "tlistitem");
					this.className = "tlistitem-selected";
				}

                settings.selectedId = id;
                if (settings.clickCallback) settings.clickCallback(settings.listElementId, id);
			}
		})(id, this.listSettings);

		var elem = document.createElement("li");
		$(elem).attr("aria-describedby", id);
    	elem.appendChild(listitemDiv);
    
    	var dlv = document.getElementById(this.listSettings.listElementId);
    	dlv.appendChild(elem);
	};
    
    // deletes the specified item id 
    // if no id is passed into this function, it will delete the selected item
    this.deleteListItem = function(id) {
    	if (id == null) id = this.listSettings.selectedId;
        
        // find the LI within this UL that has the id specified in param
        $("#" + this.listSettings.listElementId).find("li[aria-describedby="+id+"]").remove();
		
		this.listSettings.selectedId = null;
    };
    
    this.updateListItem = function(id, caption, description) {
        var item = $("#" + this.listSettings.listElementId).find("li[aria-describedby="+id+"]");
    	
        $(item).find("span.tlistitem-caption").text(caption);
        $(item).find("span.tlistitem-description").text(description);
    }
    
    // pass in the item id you want 'selected'
    this.setSelection = function(id) {
    	// clear previous selection
		$("#" + this.listSettings.listElementId).find("div.tlistitem-selected").attr("class", "tlistitem");
		$("#" + this.listSettings.listElementId).find("div.tlistitem-selected-bright").attr("class", "tlistitem-bright");
        
        // find the div within this list that has the id specified in param
        var item = $("#" + this.listSettings.listElementId).find("div[aria-describedby="+id+"]");

		// if it found the item with that id, select it
		if (item && item.length > 0) {
        	// apply 'selected' css class
			if (this.listSettings.bright) $(item).addClass("tlistitem-selected-bright");
			else $(item).addClass("tlistitem-selected");
            
            this.listSettings.selectedId = id;
        }
        else {
        	// id was not found, we un-selected any previous selection so clear selectedId
            this.listSettings.selectedId = null;
        }
     }
}
