
// Enclose all cell output in a single div
$("div.cell").each(function() {
  $(this).find(".cell-output-stdout").wrapAll("<div class='cell-output-scroll'></div>");
});

// Reclass Python code blocks to Stata
$('pre.python').addClass('stata').removeClass('python');
$('pre code.python').addClass('stata').removeClass('python');

// Enable hiding of first line of Stata code blocks
document.querySelectorAll('code.sourceCode.stata > span:first-child').forEach(function(el) {
  el.parentElement.removeChild(el.nextSibling);
});

// Mark Stata code to be highlighted, leaving aside line markers
$('pre.stata code > span').each(function() {
  var text = $(this).text();
  var a = $(this).find("a").detach();
  $(this).empty();
  $(this).append(a);
  $(this).append("<span class='language-stata'>" + text + "</span>");
});

// Highlight Stata code blocks
hljs.configure({
  languages: ['stata'],
  cssSelector: '.language-stata',
  ignoreUnescapedHTML: true
});
hljs.highlightAll();

