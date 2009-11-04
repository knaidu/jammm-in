function loadUrl(url){
  window.location = url;
}


// Redirects to a particular song page
function loadSong(id){
  if(!id) return;
  loadUrl("/song/" + id);
}

// Redirects to a particular song page
function loadJam(id){
  if(!id) return;
  loadUrl("/jam/" + id);
}
