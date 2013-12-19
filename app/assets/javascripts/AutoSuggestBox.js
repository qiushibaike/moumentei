/*  
	Title : Auto Suggest Box
	Author : Tom Coote
	Wedsite : http://www.tomcoote.co.uk
*/

 /**
	* @argument SearchInputID - The id of the text input for the loop up.
	* @argument MultiSelectID - The id of the select tag for the results to be placed.
	* @argument fnSearch - The JavaScript function to call to get results, 
	*						this function will get passed a string value of the requested search text and
	*						must return an array of objects with the following members; id, text
	* @argument fnFound - The JavaScript function to call when a result is selected,
	*						this function will get passed the id and text of the selected object plus any extra arguments passed in
	*						when the results were created.
	*/
function AutoSuggestBox(SearchInputID, MultiSelectID, fnSearch, fnFound) {
    
	var that = {}; // Must use 'that' so not to confuse with 'this' which is the global object.

	/* Private Variables 
	*
	* These variables can only be accessed by functions inside the scope of this object.
	*/
	var eSearchInput, eMultiSelect;
	var iMaxListHeight = 280;
	var arrArgs; 
	var iSelectTextHeight = 22; // You may need to change this depending on your CSS.

    /* Private Functions 
	*
	* These functions can only be accessed by functions inside the scope of this object.
	*/

	function Initiate() {
		eSearchInput = document.getElementById(SearchInputID);
		eMultiSelect = document.getElementById(MultiSelectID);

		// Position the results area directly underneath the input box ready for deployment
		PositionElement();
		eMultiSelect.style.visibility = 'hidden';

		// Add events
		eMultiSelect.onclick = GetResultClickHandler;
		eMultiSelect.onkeypress = GetResultKeyPressHandler;
	}

	function GetResultClickHandler() {
		var id = eMultiSelect.options[eMultiSelect.selectedIndex].id,
			text = eMultiSelect.options[eMultiSelect.selectedIndex].innerHTML;

		eSearchInput.value = text;
		eMultiSelect.style.visibility = 'hidden';

		fnFound(id,text,arrArgs);
	}
	function GetResultKeyPressHandler(e) {
		if (GetKeyCode(e) == 13) {
			GetResultClickHandler();
		}
	}

	function GetKeyCode(e)
	{
		if (e) {
			return e.charCode ? e.charCode : e.keyCode;
		}
		else {
			return window.event.charCode ? window.event.charCode : window.event.keyCode;
		}
	}

	function PositionElement() {
		eMultiSelect.style.position = 'absolute';
		eMultiSelect.style.width = eSearchInput.offsetWidth + 'px';
	}

	/* Public Variables 
	*
	* These variables are available from the returning object that this constructor creates,
	* new public variables can be added to the returning object at any time.
	*/
	var undefined;

	/* Public Functions 
	*
	* These functions are available from the returning object that this constructor creates,
	* new public functions can be added to the returning object at any time.
	*/

	that.CreateResults = function(e) {

		// Check for additional arguments
		if (arguments != undefined) {
			arrArgs = arguments;
		}

		// Check for up/down key press
		var unicode = GetKeyCode(e);

		if (unicode == 40) {
			if (eMultiSelect.style.visibility == 'visible') {
				eMultiSelect.options.selectedIndex = 0;
				eMultiSelect.focus();
				return;
			}
		}
		if (unicode == 38) {
			if (eMultiSelect.style.visibility == 'visible') {
				eMultiSelect.options.selectedIndex = eMultiSelect.options.length-1;
				eMultiSelect.focus();
				return;
			}
		}

		// Check for valid search criteria
		if (eSearchInput.value.length < 1) {
			eMultiSelect.style.visibility = 'hidden';
			return;
		}

		// Get results
		var arrResults = fnSearch(eSearchInput.value), i, eOption, iCount = 0;
		
		if (arrResults == undefined) {
			eMultiSelect.style.visibility = 'hidden';
			return;
		}

		eMultiSelect.innerHTML = ''; 

		for (i=0; i < arrResults.length; i++) {
			if (arrResults[i] != undefined) {

				eOption = document.createElement('option');
				eOption.setAttribute('id',arrResults[i].id);
				eOption.innerHTML = arrResults[i].text;

				eMultiSelect.appendChild(eOption);

				iCount++;
			}
		}

		if (iCount < 1) {
			eMultiSelect.style.visibility = 'hidden';
			return; // No results found.
		}

		PositionElement();
		var iHeight = iCount*iSelectTextHeight; 
	
		if (iCount > 2) {
			if (iHeight > iMaxListHeight) { // Don't want it to tall on the page
				eMultiSelect.style.height = iMaxListHeight+'px';
			}
			else {
				eMultiSelect.style.height = iHeight+'px';
			}
		}

		eMultiSelect.style.visibility = 'visible';
	}

	Initiate(); // Do all setup when the object is created.

	/* 
	* This (or that) is the object returned with all public members and
	* functions included above when the contructor is instantiated.
	*/
    return that;
}