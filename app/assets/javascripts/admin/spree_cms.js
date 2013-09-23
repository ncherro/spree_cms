//= require admin/spree_backend
//= require jquery_nested_form

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
        var $el = $(this), val = $el.val();
        if (val) {
          $.getJSON("/admin/menus/" + val + "/menu_item_options/" + $el.data('menuItemId' || ''), function(data, b, c) {
            $el.data('menu_item_select').removeAttr('disabled').html("<option value=\"\">- None (root) -</option>\n" + data.items_html).parent().show();
          });
        } else {
          $el.data('menu_item_select').attr('disabled', 'disabled').parent().hide();
        }
      });

    });
  };

  setMenus();
  $(document).on('nested:fieldAdded', setMenus)

});
