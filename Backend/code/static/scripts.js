window.onLoadCallback = function(){
gapi.signin.render("GSignIn", {
  'scope': 'openid email',
  'clientid': '1052707430490-cnpd2pjn6b5jl9njs4n1re1g1q6p8s4g.apps.googleusercontent.com',
  'redirecturi': 'postmessage',
  'accesstype': 'offline',
  'cookiepolicy': 'single_host_origin',
  'callback': 'signInCallback',
  'approvalprompt': 'force'
});
}

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

// function to populate the modal
function populateModalItem(itemName, itemDescription) {
  description_str = "<p>Description:</p>";
  if (itemDescription) {
    document.getElementById('modalBody').innerHTML = description_str + itemDescription;
  }
  else {
    document.getElementById('modalBody').innerHTML = description_str + "No description";
  }
  document.getElementById('myModalLabel').innerHTML = itemName;
  document.getElementById('myModalFooter').innerHTML = '<a href="" class="btn btn-default" data-dismiss="modal">Close</a>';
}

// function to populate the modal
function populateModalDeleteCategory(categoryName, categoryId) {
  document.getElementById('myModalLabel').innerHTML = "Delete Category";
  document.getElementById('modalBody').innerHTML = "Are you sure you want to delete " + categoryName + "?<br>" + "<br><p>By deleting this category you will delete all the itams inside it as well!</p>";
  document.getElementById('myModalFooter').innerHTML = '<a href="/category/' + categoryId + '/delete/" class="btn btn-danger">Yes</a>' + '<a href="" class="btn btn-success" data-dismiss="modal">No</a>';
}

// function to populate the modal
function populateModalDeleteItem(itemName, itemId) {
  document.getElementById('myModalLabel').innerHTML = "Delete Item";
  document.getElementById('modalBody').innerHTML = "Are you sure you want to delete " + itemName + "?";
  document.getElementById('myModalFooter').innerHTML = '<a href="/category/item/' + itemId + '/delete/" class="btn btn-danger">Yes</a>' + '<a href="" class="btn btn-success" data-dismiss="modal">No</a>';
}
