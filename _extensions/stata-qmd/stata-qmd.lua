
if quarto.doc.isFormat("html:js") then

  quarto.doc.addHtmlDependency({
    name = "jquery",
    version = "3.6.0",
    scripts = {"resources/jquery-3.6.0.min.js"}
  })

  quarto.doc.addHtmlDependency({
    name = "highlightjs",
    version = "11.6.0",
    scripts = {
      "resources/highlightjs/highlight.min.js",
      "resources/highlightjs/stata.min.js"

    }
  })

  quarto.doc.addHtmlDependency({
    name = "stata-qmd",
    scripts = {{path = "stata-qmd.js", afterBody = true}},
    stylesheets = {"stata-qmd.css"}
  })

end
