//= require admin/spree_backend
//= require jquery_nested_form
//= require admin/libs/jquery.mjs.nestedSortable

$(function() {

  var $el, menu_sel = 'select[name$="[spree_menu_id]"]:visible';

  function setMenus(event) {
    $(menu_sel).each(function() {
      $el = $(this);
      if ($el.data('menu_item_select')) return;

      // NOTE: this assumes the menu_items dropdown is the next thing in the
      // form. pretty fragile
      $el.data('menu_item_select', $el.parent().next().find('select'));
      $el.change(function() {
        var $el = $(this), val = $el.val(), menu_item_id;
        if (val) {
          menu_item_id = parseInt($el.data('menuItemId'), 10) ? '?menu_item_id=' + $el.data('menuItemId') : ''
          $.getJSON('/admin/menus/' + val + '/menu_item_options' + menu_item_id, function(data) {
            $el.data('menu_item_select').removeAttr('disabled').html("<option value=\"\">- None (root) -</option>\n" + data.items_html).parent().show();
          });
        } else {
          $el.data('menu_item_select').attr('disabled', 'disabled').parent().hide();
        }
      });

    });
  };

  $('.cms-menu').nestedSortable({
    handle: 'div',
    listType: 'ul',
    items: 'li',
    toleranceElement: '> div',
    update: function(event, obj) {
      var $list = $(event.target), $item = $(obj.item), id = $item.attr('rel'),
        parent_id = ($item.parent().parent().attr('rel') || null);

      $list.nestedSortable('disable');

      // update the database
      $.post('/admin/menu_items/' + id + '/update_position', { parent_id: parent_id }, function() {
        $list.nestedSortable('enable');
      }, 'json')
    }
  });

  setMenus();

});
