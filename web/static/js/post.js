$('.show-post-form').click(function(e) {
  e.preventDefault();
  console.log('click');

  $('.post-form').toggleClass('visible');
})
