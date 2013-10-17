//= require admin/spree_backend
//= require jquery_nested_form
//= require admin/libs/jquery.mjs.nestedSortable
//= require admin/plugins/jquery.cmsMenuSelect
//= require tinymce

// MENUS / MENU ITEM TREES
(function($, window, document, undefined) {

  var updated = false,
      positions = [],
      $update_positions;

  function init() {

    $('.cms-menu').nestedSortable({
      handle: 'div',
      listType: 'ul',
      items: 'li',
      toleranceElement: '> div',
      update: function(event, obj) {
        var $list = $(event.target);

        positions = [];
        updated = true;

        $list.find('li').each(function(idx) {
          positions.push({
            id: $(this).attr('rel'),
            position: idx
          });
        });

        $update_positions.data({
          list: $list,
          item: $(obj.item)
        }).removeAttr('disabled').addClass('on');
      }
    });

    $update_positions = $('.update-mi-positions');

    if ($update_positions.length) {
      $update_positions.click(function(e) {
        e.preventDefault();

        var $el = $(this),
            $list = $el.data('list'),
            $item = $el.data('item'),
            id = $item.attr('rel'),
            parent_id = ($item.parent().parent().attr('rel') || null);

        // disable stuff
        $el.attr('disabled', 'disabled');
        $list.nestedSortable('disable');

        // POST and wait
        $.post('/admin/menu_items/update_positions', { positions: positions }, function(a, b, c) {
          // update the parent of the thing that moved
          $.post('/admin/menu_items/' + id + '/update_parent', { parent_id: parent_id }, function(data, b, c) {
            $list.html(data.items_html);
            // re-enable
            $list.nestedSortable('enable');
            // disable the window warning
            updated = false;
            // and hide our button
            $el.removeClass('on');
          }, 'json')
        }, 'json');
      });
      function checkForUpdates() {
        if (updated) {
          return 'You have unsaved changes.';
        }
      }
      window.onbeforeunload = checkForUpdates;
    }

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
  var mce_opts = {
    theme : "modern",
    plugins: "autolink link code cms_image image",
    toolbar1: "insertfile undo redo | formatselect | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
    image_advtab: true,
    style_formats: [
      {
      title : 'Button',
      selector : 'a',
      classes: 'button'
    }
    ]
  };

  // to override, set CMS_TINYMCE_OPTIONS in the global scope
  if (typeof CMS_TINYMCE_OPTIONS === 'object') mce_opts = CMS_TINYMCE_OPTIONS;

  function initTinyMce() {
    $('textarea.tinymce:visible').tinymce(mce_opts);
  }

  function init() {
    initTinyMce();
    $(document).on('nested:fieldAdded', initTinyMce);
  }
  $(init);

}(jQuery, window, document));
