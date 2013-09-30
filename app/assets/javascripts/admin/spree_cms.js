//= require admin/spree_backend
//= require jquery_nested_form
//= require admin/libs/jquery.mjs.nestedSortable
//= require admin/plugins/jquery.cmsMenuSelect

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




// CMS IMAGE SELECTOR
(function($, window, document, undefined) {
  var $find_wrap,
      $find,
      $create_wrap,
      $create_form,
      $form_wrap,
      $form,
      $cancel_form,
      $img_wrap;

  function handleSelect(e) {
  }

  function handleCreate(e) {
    // cannot upload files - need to use something else...

    e.preventDefault();

    // reset form errors
    $create_form.find('.input').removeClass('withError').find('.formError').remove();

    $.ajax({
      url: $create_form.attr('action') + '.json',
      data: $create_form.serialize(),
      type: 'POST'
    }).success(function(a, b, c) {
      console.log('success', a, b, c)
    }).error(function(data) {
      var key, i, len, error_text;
      for (key in data.responseJSON.errors) {
        $('.input.cms_image_' + key)
          .addClass('withError')
          .append('<span class="formError">' + data.responseJSON.errors[key].join('<br />') + '</span>');
      }
    });
  }

  function showSelect(e) {
    e.preventDefault();
    $('#cms-image-id').val($(this).attr('rel'));
    $img_wrap.html('').append($(this).parent().prev().clone());
    $form_wrap.show();
    $form.find('input[type="text"]').val('');
    $form.find('select option').removeAttr('selected').first().attr('selected', 'selected');
    $find_wrap.hide();
  }

  function showCreate(e) {
    e.preventDefault()
    $create_wrap.show();
  }

  function cancelSelect() {
    $form_wrap.hide();
    $find_wrap.show();
  }

  function init() {
    $find_wrap = $('#cms-image-find');
    $create_wrap = $('#cms-image-create');
    $create_form = $create_wrap.find('form');
    $form_wrap = $('#cms-image-select');
    $form = $form_wrap.find('form');
    $img_wrap = $form_wrap.find('.img-wrap');

    $find_wrap.find('h3 a').click(showCreate);
    $find_wrap.find('li a').click(showSelect);
    $form_wrap.find('.icon-remove').click(cancelSelect);

//    $create_form.submit(handleCreate);
  }

  $(init); // on document.ready

}(jQuery, window, document));
