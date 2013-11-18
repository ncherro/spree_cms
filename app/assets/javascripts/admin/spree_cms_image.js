// CMS IMAGE SELECTOR
(function($, window, document, undefined) {
  var $find_wrap,
      $find,
      $create_wrap,
      $form_wrap,
      $form,
      $cancel_form,
      $img_wrap,

      $resize_style,
      $resize_info,
      $resize_w,
      $resize_h;

  function handleSelect(e) {
    e.preventDefault();

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

      console.log(vals);

      // validate
      if (vals.style !== 'none') {
        var errors = [];
        if (vals.w === '' || isNaN(vals.w) || parseInt(vals.w, 10) < 1) {
          errors.push('Please enter a valid width.');
        }
        if (vals.h === '' || isNaN(vals.h) || parseInt(vals.h, 10) < 1) {
          errors.push('Please enter a valid height.');
        }
        if (errors.length) {
          alert(errors.join("\n"));
          return false;
        }
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

    if (typeof($resize_style) === 'undefined') {
      $resize_style = $form.find('select')
      $resize_info = $resize_style.next();
      $resize_w = $('#w');
      $resize_h = $('#h');
      $resize_style.change(function() {
        var show_dims = true;
        switch($(this).val()) {
          case '':
            // resize to fit
            $resize_info.text('Image will be resized to fit within the "box" defined by the width and height.');
            break;
          case '>':
            // resize to fill
            $resize_info.text('Image will be resized to fill the "box" defined by the width and height.');
            break;
          case '#':
            // crop
            $resize_info.text('Image will be resized to fill the "box" defined by the width and height, then cropped.');
            break;
          case 'none':
            show_dims = false;
            // no resize
            $resize_info.text('Image will be displayed as-is.');
            break;
        }
        if (show_dims) {
          $resize_w.parent().show();
          $resize_h.parent().show();
        } else {
          $resize_w.parent().hide();
          $resize_h.parent().hide();
        }
      });
    }

    $resize_style.find('option').removeAttr('selected').first().attr('selected', 'selected').end().trigger('change');

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
