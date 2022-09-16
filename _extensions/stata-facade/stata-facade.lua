
-- Reclass Python code blocks with Stata cell magic to Stata code blocks

CodeBlock = function(block)
  local isPython = block.attr.classes:includes("python")
  local isExec = block.attr.classes:includes("cell-code")
  if (isPython and isExec) then
    local hasStataMagic = block.text:find("^%%%%stata\n") ~= nil
    if hasStataMagic then
      block.attr.classes = removeClass(block.attr.classes, "python")
      block.attr.classes:insert("stata")
      -- Remove the Stata cell magic line from the code block
      block.text = block.text:gsub("^%%%%stata\n", "")
    end
  end
  return block
end


-- In HTML documents, wrap all cell output blocks within a cell in a div

if quarto.doc.isFormat("html:js") then

  Div = function(div)
    local isCell = div.attr.classes:includes("cell")
    local hasOutput = div.content:find_if(isOutput)
    local hasStata = div.content:find_if(isStata)
    if isCell and hasOutput and hasStata then
      local wrapper = pandoc.Div({}, pandoc.Attr("", {"cell-output-scroll"}))
      for i = 1, #div.content do
        local el = div.content[i]
        if isOutput(el) then
          wrapper.content:insert(el)
          div.content:remove(i)
        end
      end
      div.content:insert(wrapper)
    end
    return div
    end

  quarto.doc.addHtmlDependency({
    name = "stata-facade",
    version = "0.0.1",
    stylesheets = {"stata-facade.css"}
  })

end


-- Helpers

function isOutput(el)
  return el.attr.classes:includes("cell-output")
end

function isStata(el)
  return el.attr.classes:includes("stata")
end
-- taken from Quarto source code: https://github.com/quarto-dev/quarto-cli/blob/5b5751dc14b8b7bc5afa9e34135f01a50a953b0c/src/resources/filters/common/pandoc.lua#L20-L22
-- Quarto license: https://quarto.org/license.html
function removeClass(classes, remove)
  return classes:filter(function(clz) return clz ~= remove end)
end


