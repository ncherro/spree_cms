// CMS IMAGE SELECTOR
(function($, window, document, undefined) {
  var $find_wrap,
      $find,
      $create_wrap,
      $form_wrap,
      $form,
      $cancel_form,
      $img_wrap;

  function handleSelect(e) {
    e.preventDefault();

    // TODO: validate

    // insert the stuff
    if (window == window.top) {
      alert("This must be called from within an iFrame");
    } else {
      var data = $form.serializeArray(),
          vals = {}, i, len, token, attrs = [];

      for (i=0, len=data.length; i<len; i++) {
        vals[data[i].name] = data[i].value;
      }

      if (vals.css_id) attrs.push('id:"' + vals.css_id + '"');
      if (vals.css_class) attrs.push('class:"' + vals.css_class + '"');
      if (attrs.length) {
        attrs = ' ' + attrs.join(' ');
      } else {
        attrs = '';
      }
      token = '[image:' + vals.cms_image_id + ' ' + (vals.w || 0) + 'x' + (vals.h || 0) + vals.style + attrs + ']';

      window.top.tinymce.activeEditor.execCommand('mceInsertContent', false, token);
      window.top.tinymce.activeEditor.windowManager.close();
    }
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

  function cancelSelect(e) {
    e.preventDefault();
    $form_wrap.hide();
    $find_wrap.show();
  }

  function init() {
    $find_wrap = $('#cms-image-find');
    $create_wrap = $('#cms-image-create');
    $form_wrap = $('#cms-image-select');
    $form = $form_wrap.find('form');
    $img_wrap = $form_wrap.find('.img-wrap');

    $find_wrap.find('h3 a').click(showCreate);
    $find_wrap.find('li a').click(showSelect);
    $form_wrap.find('.icon-remove').click(cancelSelect);

    $form.submit(handleSelect);
  }

  $(init); // on document.ready

}(jQuery, window, document));
