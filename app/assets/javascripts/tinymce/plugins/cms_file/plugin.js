(function() {
  tinymce.PluginManager.add('cms_file', function(editor, url) {
    // Adds a menu item to the tools menu
    editor.addMenuItem('cms_file', {
      text: 'Insert CMS File',
      context: 'insert',
      onclick: function() {
        // Open window with a specific url
        editor.windowManager.open({
          title: 'CMS File',
          url: '/admin/cms_files/find_or_create',
          width: 600,
          height: 600,
          buttons: [{
            text: 'Close',
            onclick: 'close'
          }]
        });
      }
    });
  });
}());
