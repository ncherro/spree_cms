//= require admin/spree_backend
//= require jquery_nested_form
//= require admin/libs/jquery.mjs.nestedSortable
//= require admin/plugins/jquery.cmsMenuSelect
//= require admin/libs/tinymce/jquery.tinymce.min
//= require admin/libs/tinymce/tinymce.min

// MENUS / MENU ITEM TREES
(function($, window, document, undefined) {

  function init() {

    $('.cms-menu').nestedSortable({
      handle: 'div',
      listType: 'ul',
      items: 'li',
      toleranceElement: '> div',
      update: function(event, obj) {
        var $list = $(event.target), $item = $(obj.item), id = $item.attr('rel'),
        parent_id = ($item.parent().parent().attr('rel') || null), positions = [];

        $list.nestedSortable('disable');

        $list.find('li').each(function(idx) {
          positions.push({
            id: $(this).attr('rel'),
            position: idx
          });
        });

        // update positions
        $.post('/admin/menu_items/update_positions', { positions: positions }, function(a, b, c) {
          console.log(a, b, c);
          // update the parent of the thing that moved
          $.post('/admin/menu_items/' + id + '/update_parent', { parent_id: parent_id }, function(data, b, c) {
            $list.html(data.items_html);
            // re-enable
            $list.nestedSortable('enable');
          }, 'json')
        }, 'json');
      }
    });

    $('select[name$="[spree_menu_id]"]:visible').cmsMenuSelect({
      menu_item_sel: function() {
        // `this` will be the plugin instance
        return this.$el.parent().next().find('select');
      },
      show_none: false
    });
  }

  $(init); // on document.ready

}(jQuery, window, document));



// MENU BLOCKS
(function($, window, document, undefined) {
  var $menu_block_type,
      $menu_item,
      $menu_item_wrap,
      $menu_wrap,
      $menu,
      menu_required = [1, 2],
      menu_item_required = [2];

  function menuBlockTypeChanged() {
    var val = parseInt($menu_block_type.val(), 10),
        show_menu = $.inArray(val, menu_required) !== -1,
        show_menu_item = $.inArray(val, menu_item_required) !== -1;

    if (show_menu) {
      $menu.removeAttr('disabled');
      $menu_wrap.show();
    } else {
      $menu.attr('disabled', 'disabled');
      $menu_wrap.hide();
    }

    if (show_menu_item) {
      $menu_item.removeAttr('disabled');
      $menu_item_wrap.show();
      $menu.trigger('change'); // make sure correct menu items are displayed
    } else {
      $menu_item.attr('disabled', 'disabled');
      $menu_item_wrap.hide();
    }
  }

  function init() {
    $menu = $('#menu_block_spree_menu_id');
    $menu_wrap = $menu.parent();
    $menu_item = $('#menu_block_spree_menu_item_id');
    $menu_item_wrap = $menu_item.parent();
    $menu_block_type = $('#menu_block_menu_block_type');

    $menu_block_type.change(menuBlockTypeChanged).trigger('change');

    $menu.cmsMenuSelect({
      menu_item_sel: '#menu_block_spree_menu_item_id',
      show_none: false,
      toggle_visibility: false // handled by the menu block type toggler
    });
  }

  $(init); // on document.ready
}(jQuery, window, document));


(function($, window, document, undefined) {

  function addTinyMce() {
    $('textarea.tinymce:visible').each(function() {
      // TODO: look into global CSS settings
      path = $(this).data('mce');
      $(this).tinymce({
        theme : "modern",
        plugins: "autolink link code cms_image image",
        toolbar1: "styleselect insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
        image_advtab: true,
        style_formats: [
          {title : 'Button', selector : 'a', classes: 'button' }
        ]
      });
    });
  }

  function init() {
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
    });

    addTinyMce();
    $(document).on('nested:fieldAdded', addTinyMce);

  }
  $(init);

}(jQuery, window, document));
