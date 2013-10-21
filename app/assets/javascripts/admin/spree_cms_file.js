// CMS FILE SELECTOR
(function($, window, document, undefined) {
  var $find_wrap,
      $find,
      $create_wrap,
      $img_wrap;

  function insertFile(e) {
    e.preventDefault();

    // insert the stuff
    if (window == window.top) {
      alert("This must be called from within an iFrame");
    } else {
      var data = $(this).data(),
          html = '<a href="' + data.url + '"';

      if (data.title) html += ' title="' + data.title + '"';
      html += ' data-cms-file="' + data.id + '"';
      html += '>' + data.name + '</a>';

      window.top.tinymce.activeEditor.execCommand('mceInsertContent', false, html);
      window.top.tinymce.activeEditor.windowManager.close();
    }
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

  function init() {
    $find_wrap = $('#cms-file-find');
    $create_wrap = $('#cms-file-create');

    $('h3 a.find').click(showFind);
    $('h3 a.upload').click(showCreate);

    // 'live' functionality since find_wrap will be replaced by ajax requests
    $find_wrap.on('click', 'li a', insertFile);
    $find_wrap.on('click', '.pagination a', function(e) {
      e.preventDefault();
      var url = $(this).attr('href').split('?');
      if (url[0].indexOf('.js') === -1) url[0] = url[0] + '.js';
      $.get(url.join('?'));
    });
  }

  $(init); // on document.ready

}(jQuery, window, document));
