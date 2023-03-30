
-- Reclass Python code blocks with Stata cell magic to Stata code blocks
CodeBlock = function(block)
  if block.attr.classes:includes("python") and
     block.attr.classes:includes("cell-code") and
     block.text:find("^%%%%stata\n") ~= nil then
      block.attr.classes = removeClass(block.attr.classes, "python")
      block.attr.classes:insert("stata")
      -- Remove the Stata cell magic line from the code block
      block.text = block.text:gsub("^%%%%stata\n", "")
    end
  return block
end

-- Helper from Quarto source code
-- Quarto license: https://quarto.org/license.html
-- https://github.com/quarto-dev/quarto-cli/blob/5b5751dc14b8b7bc5afa9e34135f01a50a953b0c/src/resources/filters/common/pandoc.lua
function removeClass(classes, remove)
  return classes:filter(function(clz) return clz ~= remove end)
end


