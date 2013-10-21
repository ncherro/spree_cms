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
          vals = {},
          i,
          len;

      for (i=0, len=data.length; i<len; i++) {
        vals[data[i].name] = data[i].value;
      }

      $.ajax({
        type: 'GET',
        url: '/admin/cms_images/' + vals.cms_image_id + '.js',
        data: $form.serialize(),
        dataType: 'json',
        success: function(data) {
          window.top.tinymce.activeEditor.execCommand('mceInsertContent', false, data.html);
          window.top.tinymce.activeEditor.windowManager.close();
        },
        error: function(a, b, c) {
          console.log('error', a, b, c);
        }
      });
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

  function showFind(e) {
    e.preventDefault()
    $('h3 a').removeClass('on');
    $(this).addClass('on');
    $create_wrap.hide();
    $find_wrap.show();
  }

  function showCreate(e) {
    e.preventDefault()
    $('h3 a').removeClass('on');
    $(this).addClass('on');
    $create_wrap.show();
    $find_wrap.hide();
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

    $('h3 a.find').click(showFind);
    $('h3 a.upload').click(showCreate);

    $form_wrap.find('.icon-remove').click(cancelSelect);

    // 'live' functionality since find_wrap will be replaced by ajax requests
    $find_wrap.on('click', 'li a', showSelect);
    $find_wrap.on('click', '.pagination a', function(e) {
      e.preventDefault();
      var url = $(this).attr('href').split('?');
      if (url[0].indexOf('.js') === -1) url[0] = url[0] + '.js';
      $.get(url.join('?'));
    });

    $form.submit(handleSelect);
  }

  $(init); // on document.ready

}(jQuery, window, document));
