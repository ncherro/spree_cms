/**
 * Ajaxify menu item lists
 */

;(function($, window, document, undefined) {

  var plugin_name = 'cmsMenuSelect',
      defaults = {
        menu_item_sel: '#menu_item', // either a jquery selector or a function
        toggle_visibility: true,
        show_none: true
      };

  function Plugin(el, options) {
    this.el = el;
    this.$el = $(el);

    this.settings = $.extend({}, defaults, options);

    this._defaults = defaults;
    this._name = plugin_name;

    this.init();
  }

  Plugin.prototype = {
    handleResponse: function(data) {
      var opts = data.items_html;
      if (this.settings.show_none) {
        opts = '<option value="">- None (root) -</option>' + opts;
      }
      this.$menu_item.removeAttr('disabled').html(opts);
      if (this.settings.toggle_visibility) this.$menu_item_wrap.show();
    },

    changed: function() {
      var val = this.$el.val(),
          menu_item_qs;
      if (val) {
        menu_item_qs = this.parent_id ? '?menu_item_id=' + this.parent_id : '';
        $.getJSON('/admin/menus/' + val + '/menu_item_options' + menu_item_qs, $.proxy(this.handleResponse, this));
      } else {
        this.$menu_item.attr('disabled', 'disabled');
        if (this.settings.toggle_visibility) this.$menu_item_wrap.hide();
      }
    },

    init: function() {
      if (typeof this.settings.menu_item_sel === 'function') {
        this.$menu_item = this.settings.menu_item_sel.call(this);
      } else {
        this.$menu_item = $(this.settings.menu_item_sel);
      }
      if (this.$menu_item.length) {
        // NOTE: this assumes the selects are wrapped
        this.$menu_item_wrap = this.$menu_item.parent();
        // if set, we are omitting invalid parent options from the results
        this.parent_id = parseInt(this.$el.data('menuItemId'), 10);
        this.$el.change($.proxy(this.changed, this));
      }
    }
  };

  $.fn[plugin_name] = function(options) {
    return this.each(function() {
      if (!$.data(this, "plugin_" + plugin_name)) {
        $.data(
          this, "plugin_" + plugin_name,
          new Plugin(this, options)
        );
      }
    });
  }

}(jQuery, window, document));




