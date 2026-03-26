local source = {}

source.new = function(opts)
    local self = setmetatable({}, { __index = source })
    self.opts = opts
    return self
end

local get_history = function(history_type)
    local items = {}
    local seen = {}
    local num = vim.fn.histnr(history_type)
    for i = num, 1, -1 do
        local text = vim.fn.histget(history_type, i)
        if text ~= "" and not seen[text] then
            seen[text] = true
            table.insert(items, {
                label = text,
                kind = 1,
                insertText = text,
                score_offset = i,
            })
        end
    end
    return { items = items, is_incomplete_backward = true, is_incomplete_forward = true }
end

local get_fixedkeyword = function(keyword)
    local items = { { label = keyword, kind = require('blink.cmp.types').CompletionItemKind.Keyword } }
    return { items = items, is_incomplete_backward = true, is_incomplete_forward = true }
end

source.get_completions = function(self, ctx, callback)
    local cmdline = vim.fn.getcmdline()

    if cmdline == '' then
        local cmdtype = vim.fn.getcmdtype()
        if cmdtype == '?' then cmdtype = '/' end
        return callback(get_history(cmdtype))
    end

    local keyword = ctx:get_keyword()
    if keyword ~= '' then return callback(get_fixedkeyword(keyword)) end

    callback({ items = {}, is_incomplete_backward = true, is_incomplete_forward = true })
    return function() end
end

return source
