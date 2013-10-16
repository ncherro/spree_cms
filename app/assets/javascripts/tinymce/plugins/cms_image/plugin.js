(function() {
  tinymce.PluginManager.add('cms_image', function(editor, url) {
    // Adds a menu item to the tools menu
    editor.addMenuItem('cms_image', {
      text: 'Insert CMS Image',
      context: 'insert',
      onclick: function() {
        // Open window with a specific url
        editor.windowManager.open({
          title: 'CMS Image',
          url: '/admin/cms_images/find_or_create',
          width: 600,
          height: 600,
          buttons: [{
            text: 'Close',
            onclick: 'close'
          }]
        });
      }
    });
  })
}());
