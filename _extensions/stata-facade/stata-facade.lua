
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

-- Transform ast of cells where Stata output is split across multiple output
-- blocks
Div = function(el)
  if el.t == "Div" and
    el.attr.classes:includes("cell") and
    #el.content > 0 and
    el.content[1].t == "CodeBlock" and
    el.content[1].attr.classes:includes("cell-code") and
    el.content[1].attr.classes:includes("stata") and
    -- Don't touch cells with output-location specified
    el.attr.attributes["output-location"] == nil then
      -- Check for multiple cell output blocks
      local hasMultipleOutput = #el.content:filter(
        function(el)
          return el.attr.classes:includes("cell-output")
        end
      )
      -- Check for Stata graphic cell output; don't touch these cells
      local hasStataGraphics = el.content:find_if(
        function(el)
          return el.attr.classes:includes("cell-output-display")
        end
      )
      if hasMultipleOutput > 1 and hasStataGraphics == nil then
        -- Split out the source code and the cell output blocks
        local codeDiv = el.content[1]
        local outputDivs = tslice(el.content, 2, #el.content)
        -- Extract and concatenate text from the output blocks
        local newOutputText = pandoc.List()
        for _,output in ipairs(outputDivs) do
          local outputText = output.content[1].text
          newOutputText:insert(outputText)
        end
        local newOutputText = table.concat(newOutputText)
        -- Wrap output text in an output block
        local newOutputDiv = pandoc.Div(
          pandoc.CodeBlock(newOutputText),
          pandoc.Attr("", {"cell-output", "cell-output-stdout"})
        )
        -- Recompile the source code and output into a new cell
        local newCell = pandoc.Div(
          {codeDiv, newOutputDiv},
          pandoc.Attr(el.attr)
        )
        return newCell
    end
  end
end

-- Helpers
-- From Quarto source code
-- Quarto license: https://quarto.org/license.html
-- https://github.com/quarto-dev/quarto-cli/blob/9754973987adc13f6722f7a3e279edd16cd66ec2/src/resources/filters/common/table.lua#L18-L25
function tslice(t, first, last, step)
  local sliced = {}
  for i = first or 1, last or #t, step or 1 do
    sliced[#sliced+1] = t[i]
  end
  return sliced
end
-- https://github.com/quarto-dev/quarto-cli/blob/5b5751dc14b8b7bc5afa9e34135f01a50a953b0c/src/resources/filters/common/pandoc.lua#L20-L22
function removeClass(classes, remove)
  return classes:filter(function(clz) return clz ~= remove end)
end


